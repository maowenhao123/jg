//
//  YZSmartBetViewController.m
//  ez
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZSmartBetViewController.h"
#import "YZLoginViewController.h"
#import "YZNavigationController.h"
#import "YZRechargeListViewController.h"
#import "YZBetSuccessViewController.h"
#import "IQKeyboardManager.h"
#import "YZSmartBetTableViewCell.h"
#import "YZSmartBetSettingView.h"
#import "YZSmartBet.h"
#import "YZStatusCacheTool.h"
#import "YZValidateTool.h"
#import "YZBetStatus.h"
#import "YZMathTool.h"
#import "YZBetTool.h"
#import "JSON.h"
#import "YZDateTool.h"

@interface YZSmartBetViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,YZSmartBetSettingViewDelegate>
{
    NSInteger _remainSeconds;//本期截止倒计时剩余秒数
    NSInteger _nextOpenRemainSeconds;//下期开奖倒计时剩余秒数
    NSString * _currentTermId;
    NSDictionary *_currentTermDict;//当前期的字典信息
    int _type;
    int _multipleNumber;
    BOOL _winStop;
    int _baseMoney;//每注的钱数
    int _minPrize;//最小奖金
    int _maxPrize;//最大奖金
}
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIButton *settingBtn;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UILabel *amountLabel;
@property (nonatomic, weak) UIButton *payBtn;
@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) YZSmartBetSettingView * settingView;
@property (nonatomic, strong) NSTimer *getCurrentTermDataTimer;
@property (nonatomic, strong) NSMutableArray *statusArray;//投注信息数组
@property (nonatomic, strong) NSMutableArray *smartBetArray;//智能追号信息数组
@property (nonatomic, assign) int amountMoney;//金额
@property (nonatomic, strong) NSArray *profitArray;

@end

@implementation YZSmartBetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"智能追号";
    _winStop = YES;
    _type = 0;
    [self getBetData];
    [self setupChilds];
    [self getCurrentTermData];//获取当前期信息，获得截止时间
    [self addSetSmartBetDeadlineTimer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshCountdownNotification) name:RefreshCountdownNote object:nil];
}
- (void)RefreshCountdownNotification
{
    if (_nextOpenRemainSeconds > 0) {//倒计时运行时才刷新
        self.timeLabel.text = @"获取期次中...";
        _remainSeconds = 0;
        _nextOpenRemainSeconds = 0;
        [self getCurrentTermData];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.view endEditing:YES];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [self removeSetDeadlineTimer];
}
//获取投注信息
- (void)getBetData
{
    NSRange prize;
    YZBetStatus * betStatus = [self.statusArray firstObject];
    if ([self.gameId isEqualToString:@"T06"]) {
        int selectCount = 0;
        if (self.selectedPlayTypeBtnTag == 1 || self.selectedPlayTypeBtnTag == 2) {
            for (int i = 0; i < betStatus.labelText.string.length; i++) {
                NSString * subString = [betStatus.labelText.string substringWithRange:NSMakeRange(i, 1)];
                if ([subString isEqualToString:@"|"]) {
                    selectCount ++;
                }
            }
            selectCount ++;
        }
        prize = [YZMathTool getKy481Prize_putongWithTag:self.selectedPlayTypeBtnTag selectCount:selectCount betCount:betStatus.betCount];
    }else
    {
        int danballscount = 0;
        int tuoballscount = 0;
        int selectballcount = 0;
        NSString * betCodes = betStatus.labelText.string;
        NSRange range = [betCodes rangeOfString:@"["];
        NSString * betCode = [betCodes substringWithRange:NSMakeRange(0, range.location)];
        BOOL dantuo = NO;
        if ([betCode rangeOfString:@"$"].location != NSNotFound) {//是否为胆拖
            dantuo = YES;
            NSArray * dantuoSelectBalls = [betCode componentsSeparatedByString:@"$"];
            for (NSString * selectBallStr in dantuoSelectBalls) {
                int index = (int)[dantuoSelectBalls indexOfObject:selectBallStr];
                NSArray * selectBalls = [selectBallStr componentsSeparatedByString:@","];
                if (index == 0) {
                    danballscount = (int)selectBalls.count;
                }else if (index == 1)
                {
                    tuoballscount = (int)selectBalls.count;
                }
            }
        }else
        {
            NSArray *selectBalls = [betCode componentsSeparatedByString:@","];
            selectballcount = (int)selectBalls.count;
        }
        
        if(self.selectedPlayTypeBtnTag < 12)//普通投注
        {
            if(self.selectedPlayTypeBtnTag != 8 || self.selectedPlayTypeBtnTag != 10)
            {
                prize = [YZMathTool get11x5Prize_putongWithTag:self.selectedPlayTypeBtnTag selectballcount:selectballcount betCount:betStatus.betCount];
            }else
            {
                prize = [YZMathTool get11x5Prize_putongWithTag:self.selectedPlayTypeBtnTag selectballcount:0  betCount:betStatus.betCount];//是前二直选和前三直选,不用已选球参数
            }
        }else//胆拖投注
        {
            //转换tag
            int tag = [self dantuoTagToNormalTagWithTag:self.selectedPlayTypeBtnTag];
            prize = [YZMathTool get11x5Prize_dantuoWithTag:tag danballscount:danballscount tuoballscount:tuoballscount betCount:betStatus.betCount];
        }
    }
    
    //每注的钱数
    _baseMoney = betStatus.betCount * 2;
    //最大最小奖金
    _minPrize = (int)prize.location;
    _maxPrize = (int)prize.length;
}
#pragma  mark - 获取当前期信息
- (void)getCurrentTermData
{
    if(_nextOpenRemainSeconds > 0) return;
    NSDictionary *dict = @{
                           @"cmd":@(8026),
                           @"gameId":self.gameId
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            _currentTermDict = json;
            NSArray *termList = json[@"game"][@"termList"];
            if(termList.count)//当前期次正在销售
            {
                NSString * endTime = [json[@"game"][@"termList"] lastObject][@"endTime"];
                NSString * nextOpenTime = [json[@"game"][@"termList"] lastObject][@"nextOpenTime"];
                NSString * sysTime = json[@"sysTime"];
                _currentTermId = [termList lastObject][@"termId"];
                //彩种截止时间
                NSDateComponents *deltaDate = [YZDateTool getDeltaDateFromDateString:sysTime fromFormat:@"yyyy-MM-dd HH:mm:ss" toDateString:endTime ToFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDateComponents *nextOpenDeltaDate = [YZDateTool getDeltaDateFromDateString:sysTime fromFormat:@"yyyy-MM-dd HH:mm:ss" toDateString:nextOpenTime ToFormat:@"yyyy-MM-dd HH:mm:ss"];
                _remainSeconds = deltaDate.day * 24 * 60 * 60 + deltaDate.hour * 60 * 60 + deltaDate.minute * 60 + deltaDate.second;
                _nextOpenRemainSeconds = nextOpenDeltaDate.day * 24 * 60 * 60 + nextOpenDeltaDate.hour * 60 * 60 + nextOpenDeltaDate.minute * 60 + nextOpenDeltaDate.second;
                [self setSmartBetArrayData];
            }else
            {
                self.timeLabel.text = @"当前期已截止销售";
            }
        }
    } failure:^(NSError *error) {
        YZLog(@"getCurrentTermData - error = %@",error);
    }];
}
#pragma mark - 布局子控件
- (void)setupChilds
{
    //倒计时
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, screenWidth - 110, 30)];
    self.timeLabel = timeLabel;
    timeLabel.text = @"未能获取当前期号";
    timeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    timeLabel.textColor = YZBlackTextColor;
    [self.view addSubview:timeLabel];

    //修改方案
    UIButton * settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingBtn = settingBtn;
    settingBtn.frame = CGRectMake(screenWidth - 100, 5, 90, 30);
    [settingBtn setTitle:@"修改方案" forState:UIControlStateNormal];
    [settingBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    settingBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    settingBtn.layer.masksToBounds = YES;
    settingBtn.layer.cornerRadius = 2;
    settingBtn.layer.borderColor = [UIColor grayColor].CGColor;
    settingBtn.layer.borderWidth = 1;
    [settingBtn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingBtn];
    
    //tableView
    CGFloat bottomViewH = 49 + [YZTool getSafeAreaBottom];
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, screenWidth, screenHeight - statusBarH - navBarH - 40 - bottomViewH) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:tableView];
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight - navBarH - statusBarH - bottomViewH, screenWidth, bottomViewH)];
    [self.view addSubview:bottomView];
    
    //注数和倍数和金额总数
    UILabel *amountLabel = [[UILabel alloc] init];
    self.amountLabel = amountLabel;
    amountLabel.frame = CGRectMake(YZMargin, 0, screenWidth - 20 - 85, 49);
    amountLabel.textColor = YZBlackTextColor;
    amountLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [bottomView addSubview:amountLabel];

    //付款
    YZBottomButton *confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    CGFloat confirmBtnH = 30;
    CGFloat confirmBtnW = 75;
    confirmBtn.frame = CGRectMake(screenWidth - confirmBtnW - 15, (49 - confirmBtnH) / 2, confirmBtnW, confirmBtnH);
    [confirmBtn setTitle:@"付款" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [bottomView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(payBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //分割线
    UIView * bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    bottomLineView.backgroundColor = YZGrayLineColor;
    [bottomView addSubview:bottomLineView];
}
#pragma  mark - 设置时间label
- (void)addSetSmartBetDeadlineTimer
{
    if(self.getCurrentTermDataTimer == nil)//空才创建
    {
        self.getCurrentTermDataTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(setSmartBetDeadlineTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.getCurrentTermDataTimer forMode:NSRunLoopCommonModes];
        [self.getCurrentTermDataTimer fire];
    }
}
- (void)setSmartBetDeadlineTime
{
    if(_nextOpenRemainSeconds <= 0 && _remainSeconds <= 0)
    {
        [self getCurrentTermData];//重新获取所有彩种信息
        return;
    }
    _remainSeconds--;
    _nextOpenRemainSeconds--;
    
    NSDictionary *json = _currentTermDict;
    NSString * termId = [json[@"game"][@"termList"] lastObject][@"termId"];
    NSString * nextTermId = [json[@"game"][@"termList"] lastObject][@"nextTermId"];
    //截取期数
    termId = [termId substringFromIndex:termId.length - 2];
    nextTermId = [nextTermId substringFromIndex:nextTermId.length - 2];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
    NSDateComponents *deltaDate = [YZDateTool getDateComponentsBySeconds:_remainSeconds];
    NSDateComponents *nextOpenDeltaDate = [YZDateTool getDateComponentsBySeconds:_nextOpenRemainSeconds];
    if(_remainSeconds > 0)//当前期正在销售
    {
        NSString * deltaTime = [NSString stringWithFormat:@"%ld分%ld秒", (long)deltaDate.minute, (long)deltaDate.second];
        attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距%@期截止:%@",termId,deltaTime]];
    }else if (_remainSeconds <= 0 && _nextOpenRemainSeconds > 0)//当前期已截止销售,下期还未开始
    {
        NSString * deltaTime = [NSString stringWithFormat:@"%ld分%ld秒", (long)nextOpenDeltaDate.minute, (long)nextOpenDeltaDate.second];
        attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距%@期开始:%@",nextTermId,deltaTime]];
    }else//为0的时候，重新刷新数据
    {
        attStr = [[NSMutableAttributedString alloc]initWithString:@"获取新期次中..."];
        _nextOpenRemainSeconds = 0;
    }
    if (_remainSeconds == 0) {//本期结束提示
        [self showAlertByTermId:termId];
    }
    NSRange qiRange = [[attStr string] rangeOfString:@":"];
    NSRange fenRange = [[attStr string] rangeOfString:@"分"];
    NSRange miaoRange = [[attStr string] rangeOfString:@"秒"];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, attStr.length)];
    if (fenRange.location != NSNotFound)//分、秒
    {
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(qiRange.location+1, fenRange.location-qiRange.location-1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(fenRange.location+1, miaoRange.location-fenRange.location-1)];
    }
    self.timeLabel.attributedText = attStr;
}
- (void)showAlertByTermId:(NSString *)termId
{
    NSString * title = [NSString stringWithFormat:@"%@期已停止投注",termId];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:@"请确认投注期次" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:alertAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.smartBetArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSmartBetTableViewCell *cell = [YZSmartBetTableViewCell cellWithTableView:tableView];
    if(indexPath.row % 2 == 0)
    {
        cell.backgroundColor = UIColorFromRGB(0xFFE7E7E7);
        cell.showLine = YES;
    }else
    {
        cell.backgroundColor = [UIColor whiteColor];
        cell.showLine = NO;
    }
    cell.multipleTextField.delegate = self;
    cell.status = self.smartBetArray[indexPath.row];
    return  cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSmartBet * smartBet = self.smartBetArray[indexPath.row];
    if (smartBet.isTomorrow) {
        return 35 + 30;
    }else
    {
        return 35;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat lineWidth = 0.4;
    CGFloat headerViewH = 30;
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, headerViewH)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    //期次
    UILabel * termLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth * 0.1, headerViewH)];
    termLabel.textAlignment = NSTextAlignmentCenter;
    termLabel.font = [UIFont systemFontOfSize:13];
    termLabel.textColor = [UIColor grayColor];
    termLabel.text = @"期号";
    [headerView addSubview:termLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(termLabel.frame), 0, lineWidth, 30)];
    line1.backgroundColor = [UIColor grayColor];
    [headerView addSubview:line1];
    
    //倍数
    UILabel *multipleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line1.frame) , 0, screenWidth * 0.27, headerViewH)];
    multipleLabel.text = @"倍数";
    multipleLabel.textColor = [UIColor grayColor];
    multipleLabel.font = [UIFont systemFontOfSize:13];
    multipleLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:multipleLabel];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(multipleLabel.frame), 0, lineWidth, headerViewH)];
    line2.backgroundColor = [UIColor grayColor];
    [headerView addSubview:line2];
    
    //累计
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line2.frame), 0, screenWidth * 0.17, headerViewH)];
    totalLabel.text = @"累计";
    totalLabel.font = [UIFont systemFontOfSize:13];
    totalLabel.textColor = [UIColor grayColor];
    totalLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:totalLabel];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(totalLabel.frame), 0, lineWidth, headerViewH)];
    line3.backgroundColor = [UIColor grayColor];
    [headerView addSubview:line3];
    
    //奖金
    UILabel *bonusLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line3.frame), 0, screenWidth * 0.22, headerViewH)];
    bonusLabel.text = @"奖金";
    bonusLabel.font = [UIFont systemFontOfSize:13];
    bonusLabel.textColor = [UIColor grayColor];
    bonusLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:bonusLabel];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(bonusLabel.frame), 0, lineWidth, headerViewH)];
    line4.backgroundColor = [UIColor grayColor];
    [headerView addSubview:line4];
    
    //盈利
    UILabel *profitLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line4.frame), 0, screenWidth * 0.24, headerViewH)];
    profitLabel.text = @"盈利";
    profitLabel.font = [UIFont systemFontOfSize:13];
    profitLabel.textColor = [UIColor redColor];
    profitLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:profitLabel];
    
    //分割线
    UIView *lineTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, lineWidth)];
    lineTop.backgroundColor = [UIColor grayColor];
    [headerView addSubview:lineTop];
    
    UIView *lineBottom = [[UIView alloc]initWithFrame:CGRectMake(0, headerViewH - lineWidth, screenWidth, lineWidth)];
    lineBottom.backgroundColor = [UIColor grayColor];
    [headerView addSubview:lineBottom];
    
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.payBtn.userInteractionEnabled = NO;
    
    YZSmartBetTableViewCell * cell = (YZSmartBetTableViewCell *)textField.superview.superview;

    CGRect frame = [cell convertRect:cell.multipleTextField.frame toView:self.view];
    CGFloat height = self.view.height;
    int offset = CGRectGetMaxY(frame) - (height - 216.0 - 42);//键盘高度216
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animateDuration];
    float width = self.view.width;
    if(offset > 0)
    {
        self.view.frame = CGRectMake(0.0f, -offset,width,height);
    }
    [UIView commitAnimations];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [YZValidateTool validateNumber:string];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.payBtn.userInteractionEnabled = YES;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animateDuration];
    self.view.frame = CGRectMake(0.0f, navBarH + statusBarH, self.view.width, self.view.height);;
    [UIView commitAnimations];
    
    if ([textField.text intValue] == 0)
    {
        textField.text = @"1";
    }
    if([textField.text intValue] > 9999)
    {
        textField.text = @"9999";
    }
    //修改数据
    YZSmartBetTableViewCell * cell = (YZSmartBetTableViewCell *)textField.superview.superview;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    //刷新数据
    self.smartBetArray = [YZMathTool get_changeBeishuSmartBetArrayBySmartBetArray:self.smartBetArray itemnum:(int)indexPath.row beishu:[textField.text intValue]];
    [self.tableView reloadData];
    //再次计算钱数
    [self setAmountLabelText];
}
#pragma  mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint pos = [touch locationInView:self.settingView.superview];
        if (CGRectContainsPoint(self.settingView.frame, pos)) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 按钮点击
#pragma mark - 修改方案
- (void)settingBtnClick
{
    [self.view endEditing:YES];
    
    UIView * backView = [[UIView alloc]initWithFrame:KEY_WINDOW.bounds];
    self.backView = backView;
    backView.backgroundColor = YZColor(0, 0, 0, 0.4);
    [KEY_WINDOW addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBackView)];
    tap.delegate = self;
    [backView addGestureRecognizer:tap];
    
    YZSmartBetSettingView * settingView = [[YZSmartBetSettingView alloc]initWithFrame:CGRectMake(20, 0, screenWidth - 2 * 20, 375)];
    self.settingView = settingView;
    settingView.termCount = (int)self.smartBetArray.count;
    settingView.multipleNumber = _multipleNumber;
    settingView.type = _type;
    settingView.profitArray = self.profitArray;
    settingView.winStop = _winStop;
    settingView.delegate = self;
    settingView.center = KEY_WINDOW.center;
    settingView.layer.masksToBounds = YES;
    settingView.layer.cornerRadius = 5;
    [backView addSubview:settingView];
    
    //动画
    settingView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        settingView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)removeBackView
{
    [self.backView removeFromSuperview];
}
#pragma mark - 付款
- (void)payBtnClick
{
    if (self.smartBetArray.count == 0) {
        [MBProgressHUD showError:@"请至少添加一注号码"];
        return;
    }else if (self.amountMoney > 30000 && _winStop)
    {
        [MBProgressHUD showError:@"单次投注方案不能超过3万元!"];
        return;
    }else if (self.amountMoney > 20000)
    {
        [MBProgressHUD showError:@"单次投注方案不能超过2万元!"];
        return;
    }else if(!UserId)//没登录
    {
        YZLoginViewController *loginVc = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:loginVc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
        return;
    }else
    {
        [self showComfirmPayAlertView];
    }
}
- (void)showComfirmPayAlertView
{
    BOOL hasEnoughMoney = [YZTool hasEnoughMoneyWithAmountMoney:self.amountMoney];
    if (hasEnoughMoney) {
        NSString * message = [YZTool getAlertViewTextWithAmountMoney:self.amountMoney];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"支付确认" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getCurrentTermDataForPay];//当前期次的信息
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }else
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"余额不足" message:@"对不起，余额不足，请充值。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gotoRecharge];
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)getCurrentTermDataForPay
{
    NSDictionary *dict = @{
                           @"cmd":@(8026),
                           @"gameId":self.gameId
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            NSArray *termList = json[@"game"][@"termList"];
            if(!termList.count)
            {
                [MBProgressHUD showError:text_sailStop];
                return;
            }
            _currentTermId = [termList lastObject][@"termId"];
            [self isJump:Jump];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"getCurrentTermData - error = %@",error);
    }];
}
- (void)isJump:(BOOL)jump
{
    if(!jump)//不跳
    {
        [MBProgressHUD showMessage:text_paying toView:self.view];
        [self comfirmPay];//支付
    }else //跳转网页
    {
        [MBProgressHUD hideHUDForView:self.view];
        NSMutableArray *ticketList = [YZBetTool getS1x5TicketList];
        NSMutableArray * smartSchemeList = [NSMutableArray array];
        for (YZSmartBet * smartBet in self.smartBetArray) {
            NSDictionary * dictionary = @{
                                          @"termId":smartBet.termId,
                                          @"mutiple":[NSNumber numberWithInt:[smartBet.multiple intValue]]
                                          };
            [smartSchemeList addObject:dictionary];
        }
        NSString *ticketListJsonStr = [ticketList JSONRepresentation];
        NSString *smartSchemeListJsonStr = [smartSchemeList JSONRepresentation];
        
#if JG
        NSString * mcpStr = @"EZmcp";
#elif ZC
        NSString * mcpStr = @"ZCmcp";
#elif CS
        NSString * mcpStr = @"CSmcp";
#elif RR
        NSString * mcpStr = @"CSmcp";
#endif
        
        NSString *param = [NSString stringWithFormat:@"userId=%@&gameId=%@&termId=%@&smartSchemeList=%@&amount=%@&ticketList=%@&payType=%@&termCount=%@&startTermId=%@&winStop=%@&id=%@&channel=%@&childChannel=%@&version=%@&remark=%@",UserId,self.gameId,_currentTermId,[smartSchemeListJsonStr URLEncodedString],[NSNumber numberWithInt:self.amountMoney * 100],[ticketListJsonStr URLEncodedString],@"ACCOUNT",[NSNumber numberWithInteger:self.smartBetArray.count],_currentTermId,[NSNumber numberWithBool:_winStop],@"1407305392008",mainChannel,childChannel,[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],mcpStr];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",jumpURLStr,param]];
        
        [[UIApplication sharedApplication] openURL:url];
    }
}
- (void)gotoRecharge
{
    YZRechargeListViewController *rechargeVc = [[YZRechargeListViewController alloc] init];
    rechargeVc.isOrderPay = YES;
    [self.navigationController pushViewController:rechargeVc animated:YES];
}
- (void)comfirmPay//支付接口
{
    NSMutableArray *ticketList = [YZBetTool getS1x5TicketList];
    NSMutableArray * smartSchemeList = [NSMutableArray array];
    for (YZSmartBet * smartBet in self.smartBetArray) {
        NSDictionary * dictionary = @{
                                      @"termId":smartBet.termId,
                                      @"mutiple":[NSNumber numberWithInt:[smartBet.multiple intValue]]
                                      };
        [smartSchemeList addObject:dictionary];
    }
    NSDictionary *dict = @{
                           @"cmd":@(8051),
                           @"userId":UserId,
                           @"gameId":self.gameId,
                           @"termId":_currentTermId,
                           @"amount":[NSNumber numberWithInt:self.amountMoney * 100],
                           @"ticketList":ticketList,
                           @"payType":@"ACCOUNT",
                           @"termCount":[NSNumber numberWithInteger:self.smartBetArray.count],
                           @"startTermId":_currentTermId,
                           @"winStop":[NSNumber numberWithBool:_winStop],
                           @"smartSchemeList":smartSchemeList,
                           @"multiple":@1
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            [MBProgressHUD hideHUDForView:self.view];
            YZBetSuccessViewController *betSuccessVc = [[YZBetSuccessViewController alloc] init];
            betSuccessVc.payVcType = BetTypeSmartBet;
            betSuccessVc.termCount = (int)self.smartBetArray.count;
            //跳转
            [self.navigationController pushViewController:betSuccessVc animated:YES];
            //删除数据库中得所有号码球数据
            [YZStatusCacheTool deleteAllStatus];
            [self.smartBetArray removeAllObjects];
            [self.tableView reloadData];
            [self setAmountLabelText];
        }else
        {
            [MBProgressHUD hideHUDForView:self.view];//隐藏正在支付的弹框
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",json[@"retDesc"]]];
        }
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"error = %@",error);
    }];
}
#pragma mark - YZSmartBetSettingViewDelegate
- (void)SmartBetSettingViewCancelBtnClick
{
    [self removeBackView];
}
- (void)SmartBetSettingViewConfirmBtnClickWithTermNumber:(int)termNumber multipleNumber:(int)multipleNumber type:(int)type profitArray:(NSArray *)profitArray isWinStop:(BOOL)winStop
{
    [self removeBackView];

    [self reloadSmartBetArrayDataWithTermNumber:termNumber multipleNumber:multipleNumber type:type profitArray:profitArray isWinStop:winStop];
    
    //更新值
    self.profitArray = profitArray;
    _multipleNumber = multipleNumber;
    _type = type;
    _winStop = winStop;
}
//将胆拖码tag转换为普通tag
- (int)dantuoTagToNormalTagWithTag:(int)tag
{
    if(tag >=12 && tag <= 17){
        tag -= 12;
    }else if(tag == 18){
        tag = 9;
    }else if(tag == 19){
        tag = 11;
    }
    return tag;
}
#pragma mark - 设置
- (void)setSmartBetArrayData
{
    int termNumber = (int)self.smartBetArray.count;
    if (termNumber == 0) {
        termNumber = [self getTermNumber];
    }
    if (_multipleNumber == 0) {
        _multipleNumber = 1;
    }
    [self reloadSmartBetArrayDataWithTermNumber:termNumber multipleNumber:_multipleNumber type:_type profitArray:self.profitArray isWinStop:_winStop];
}

- (void)reloadSmartBetArrayDataWithTermNumber:(int)termNumber multipleNumber:(int)multipleNumber type:(int)type profitArray:(NSArray *)profitArray isWinStop:(BOOL)winStop
{
    //当前期次
    int termId = [[_currentTermId substringFromIndex:6] intValue];
    //
    if (type == 0) {
        int yinglilv = [profitArray[0] intValue];
        self.smartBetArray = [YZMathTool get_yinglilvSmartBetArrayByBasemoney:_baseMoney baseminprize:_minPrize basemaxprize:_maxPrize yinglilv:yinglilv qihao:termId currentTermId:_currentTermId qishu:termNumber firstbeishu:multipleNumber currentleiji:0];
    }else if (type == 1)
    {
        int firstqishu = [profitArray[1] intValue];
        int firstyinglilv = [profitArray[2] intValue];
        int secondyinglilv = [profitArray[3] intValue];
        self.smartBetArray = [YZMathTool get_changeSmartBetArrayByBasemoney:_baseMoney baseminprize:_minPrize basemaxprize:_maxPrize firstqishu:firstqishu firstyinglilv:firstyinglilv secondyinglilv:secondyinglilv qihao:termId currentTermId:_currentTermId qishu:termNumber firstbeishu:multipleNumber currentleiji:0];
    }else
    {
        int lessyingli = [profitArray[4] intValue];
        self.smartBetArray = [YZMathTool get_lessSmartBetArrayByBasemoney:_baseMoney baseminprize:_minPrize basemaxprize:_maxPrize qihao:termId currentTermId:_currentTermId qishu:termNumber firstbeishu:multipleNumber lessyingli:lessyingli currentleiji:0];
    }
    [self.tableView reloadData];
    //如果过大 弹出框
    if (self.smartBetArray.count < termNumber) {
        NSString * message;
        if (type == 0) {
            message = [NSString stringWithFormat:@"盈利率设置过大，只能生成%ld期！",(unsigned long)self.smartBetArray.count];
        }else if (type == 1)
        {
            message = [NSString stringWithFormat:@"盈利率设置过大，只能生成%ld期！",(unsigned long)self.smartBetArray.count];
            
        }else if (type == 2)
        {
            message = [NSString stringWithFormat:@"最低盈利设置过大，只能生成%ld期！",(unsigned long)self.smartBetArray.count];
        }
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:alertAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    //计算钱
    [self setAmountLabelText];
}

- (void)setAmountLabelText
{
    int termNumber = (int)self.smartBetArray.count;
    YZSmartBet * smartBet = [self.smartBetArray lastObject];
    int amount = [smartBet.total intValue];
    NSString *str = [NSString stringWithFormat:@"共追 %d 期 %d 元",termNumber,amount];
    
    NSRange range1 = [str rangeOfString:@"期"];
    NSRange range2 = [str rangeOfString:@"元"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
    
    self.amountLabel.attributedText = attStr;
    self.amountMoney = amount;
}
- (int)getTermNumber
{
    int termNumber = 0;
    YZBetStatus * betStatus = [self.statusArray firstObject];
    int playType = [betStatus.playType intValue];
    if (playType == 22 || playType == 28) {
        termNumber = 6;
    }else if (playType == 23 || playType == 27)
    {
        termNumber = 12;
    }else if (playType == 24 || playType == 25)
    {
        termNumber = 20;
    }else if (playType == 26 || playType == 29 || playType == 30 || playType == 31 ||playType == 32)
    {
        termNumber = 15;
    }else if (playType == 21)
    {
        termNumber = 5;
    }else
    {
        termNumber = 10;
    }
    return termNumber;
}
#pragma  mark - 初始化
- (NSMutableArray *)smartBetArray
{
    if (_smartBetArray == nil) {
        _smartBetArray = [NSMutableArray array];
    }
    return _smartBetArray;
}
- (NSMutableArray *)statusArray
{
    if(_statusArray == nil)
    {
        _statusArray = [NSMutableArray array];
    }
    //从数据库中获取所有号码模型数据
    NSArray *temp = [YZStatusCacheTool getStatues];
    _statusArray = [NSMutableArray arrayWithArray:temp];
    
    return  _statusArray;
}
- (NSArray *)profitArray
{
    if (_profitArray == nil) {
        _profitArray = @[@"30",@"5",@"50",@"20",@"30"];
    }
    return _profitArray;
}
#pragma  mark - 销毁对象
- (void)dealloc
{
    [self removeSetDeadlineTimer];
}
- (void)removeSetDeadlineTimer
{
    [self.getCurrentTermDataTimer invalidate];
    self.getCurrentTermDataTimer = nil;
}

@end
