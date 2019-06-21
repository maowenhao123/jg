//
//  YZBasketBallBetViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/5/29.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZBasketBallBetViewController.h"
#import "YZLoginViewController.h"
#import "YZChooseVoucherViewController.h"
#import "YZRechargeListViewController.h"
#import "YZFbBetSuccessViewController.h"
#import "YZBasketBallBetHeaderView.h"
#import "YZBasketBallBetTableViewCell.h"
#import "YZAdjustNumberView.h"
#import "YZBasketBallPassWayView.h"
#import "YZBasketBallAllPlayView.h"
#import "YZFootBallMatchRate.h"
#import "YZDateTool.h"
#import "YZFbasketBallTool.h"
#import "YZFootBallTool.h"

@interface YZBasketBallBetViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, YZAdjustNumberViewDelegate, YZBasketBallBetHeaderViewDelegate, YZBasketBallAllPlayViewDelegate>
{
    int _selectedPlayType;
    BOOL _showChoosePassWayView;
    NSIndexPath * _upDateIndexPath;
    float _minPrize;//最小奖金
    float _maxPrize;//最大奖金
    int _betCount;//注数
    float _amountMoney;//金额
    NSString *_playType;
}
@property (nonatomic, weak) UIImageView *whiteSawToothImageView;
@property (nonatomic, weak) UILabel * titleLabel;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView * passWayView;
@property (nonatomic, weak) UIButton *passWayBtn;
@property (nonatomic, weak) YZBasketBallPassWayView * choosePassWayView;
@property (nonatomic, weak) UIView * numberView;
@property (nonatomic, weak) YZAdjustNumberView * adjustNumberView;//数量改变
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UILabel *amountLabel;
@property (nonatomic, weak) UILabel *bonusLabel;
@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) YZBasketBallAllPlayView *allPlayView;
@property (nonatomic, strong) NSMutableArray *statusArray;

@end

@implementation YZBasketBallBetViewController

- (instancetype)initWithStatusArray:(NSMutableArray *)statusArray
                   selectedPlayType:(int)selectedPlayType
{
    if(self = [super init])
    {
        self.statusArray = statusArray;
        _selectedPlayType = selectedPlayType;
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"投注单";
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    [self setupSonChilds];
}

#pragma mark - 添加子视图
- (void)setupSonChilds
{
    //添加按钮
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(50, 10, screenWidth - 50 * 2, 40);
    addButton.backgroundColor = [UIColor whiteColor];
    NSMutableAttributedString *addAttStr = [[NSMutableAttributedString alloc] initWithString:@"+ 添加/编辑赛事"];
    [addAttStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:YZGetFontSize(34)] range:NSMakeRange(0, 1)];
    [addAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, addAttStr.length)];
    [addAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:NSMakeRange(1, addAttStr.length - 1)];
    [addButton setAttributedTitle:addAttStr forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    addButton.layer.borderWidth = 1;
    addButton.layer.borderColor = YZGrayLineColor.CGColor;
    [self.view addSubview:addButton];
    
    CGFloat bottomViewH = 59;
    CGFloat passWayViewH = 50;
    CGFloat promptViewH = 25;
    //tableView背景图片
    UIImage *cylinderImage = [UIImage imageNamed:@"fb_cylinderImage"];
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:cylinderImage];
    topImageView.frame = CGRectMake(10, 60, screenWidth - 2 * 10, 5);
    [self.view addSubview:topImageView];
    
    UIImage *whiteSawTooth = [UIImage resizedImageWithName:@"whtieSawToothImage" left:0 top:0.1];
    UIImageView *whiteSawToothImageView = [[UIImageView alloc] initWithImage:whiteSawTooth];
    self.whiteSawToothImageView = whiteSawToothImageView;
    whiteSawToothImageView.userInteractionEnabled = YES;
    CGFloat whiteSawToothImageViewH = screenHeight - navBarH - statusBarH - bottomViewH - passWayViewH - promptViewH - 60 - 10;
    whiteSawToothImageView.frame = CGRectMake(10, CGRectGetMaxY(topImageView.frame) - 2.5, screenWidth - 2 * 10, whiteSawToothImageViewH);
    [self.view addSubview:whiteSawToothImageView];
    
    //截止时间
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, whiteSawToothImageView.width, 30)];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleLabelText];
    [whiteSawToothImageView addSubview:titleLabel];
    
    //清空按钮
    UIButton *emptyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    emptyBtn.frame = CGRectMake(whiteSawToothImageView.width - 80, whiteSawToothImageView.height - 40, 70, 30);
    [emptyBtn setTitle:@"清空所有" forState:UIControlStateNormal];
    [emptyBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    emptyBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [emptyBtn addTarget:self action:@selector(emptyBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [whiteSawToothImageView addSubview:emptyBtn];
    
    //tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(titleLabel.frame), whiteSawToothImageView.width - 10 * 2, emptyBtn.y - CGRectGetMaxY(titleLabel.frame))];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [whiteSawToothImageView addSubview:tableView];
    
    //底栏
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - statusBarH - navBarH - bottomViewH, screenWidth, bottomViewH)];
    self.bottomView = bottomView;
    bottomView.backgroundColor = YZColor(40, 40, 40, 1);
    [self.view addSubview:bottomView];
    
    CGFloat buttonH = 33;
    CGFloat buttonW = 80;
    CGFloat buttonY = (bottomViewH - buttonH) / 2;
    //投注按钮
    YZBottomButton *betBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    betBtn.frame = CGRectMake(screenWidth - buttonW - 15, buttonY, buttonW, buttonH);
    [betBtn setTitle:@"投注" forState:UIControlStateNormal];
    [betBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    betBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [bottomView addSubview:betBtn];
    [betBtn addTarget:self action:@selector(betBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //注数和倍数和金额总数
    UILabel *amountLabel = [[UILabel alloc] init];
    self.amountLabel = amountLabel;
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.font = [UIFont boldSystemFontOfSize:YZGetFontSize(32)];
    amountLabel.textColor = [UIColor whiteColor];
    amountLabel.frame = CGRectMake(10, 10, betBtn.x - 20, 20);
    [bottomView addSubview:amountLabel];
    
    //奖金范围
    UILabel *bonusLabel = [[UILabel alloc] init];
    self.bonusLabel = bonusLabel;
    bonusLabel.textAlignment = NSTextAlignmentCenter;
    bonusLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    bonusLabel.textColor = [UIColor whiteColor];
    bonusLabel.frame = CGRectMake(10, 30, betBtn.x - 20, 20);
    [bottomView addSubview:bonusLabel];
    [self setBonusLabelTextWithMinPrize:0 maxPrize:0];
    
    //过关方式按钮
    UIView * passWayView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomView.y - passWayViewH, 120, passWayViewH)];
    self.passWayView = passWayView;
    passWayView.backgroundColor = [UIColor whiteColor];
    passWayView.layer.borderWidth = 0.8;
    passWayView.layer.borderColor = YZWhiteLineColor.CGColor;
    [self.view addSubview:passWayView];
   
    UIButton *passWayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.passWayBtn = passWayBtn;
    passWayBtn.backgroundColor = [UIColor whiteColor];
    passWayBtn.frame = passWayView.bounds;
    [passWayBtn setTitle:@"过关方式" forState:UIControlStateNormal];
    passWayBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [passWayBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];//草绿
    [passWayBtn addTarget:self action:@selector(passWayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [passWayView addSubview:passWayBtn];
    if (_selectedPlayType > 4) {
        [passWayBtn setTitle:@"单关" forState:UIControlStateNormal];
        passWayBtn.enabled = NO;
    }
    
    //改变数量
    UIView * numberView = [[UIView alloc] initWithFrame:CGRectMake(120, bottomView.y - passWayViewH, screenWidth - 120, passWayViewH)];
    self.numberView = numberView;
    numberView.backgroundColor = [UIColor whiteColor];
    numberView.layer.borderWidth = 0.8;
    numberView.layer.borderColor = YZWhiteLineColor.CGColor;
    [self.view addSubview:numberView];
    
    YZAdjustNumberView * adjustNumberView = [[YZAdjustNumberView alloc] init];
    self.adjustNumberView = adjustNumberView;
    adjustNumberView.delegate = self;
    adjustNumberView.frame = CGRectMake((numberView.width - 150) / 2, 5, 150, 40);
    adjustNumberView.textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    adjustNumberView.textField.text = @"1";
    adjustNumberView.max = 999;//最大999
    [numberView addSubview:adjustNumberView];
    
    for (int i = 0; i < 2; i++) {
        UILabel *wordLabel = [[UILabel alloc] init];
        if (i == 0) {
            wordLabel.text = @"投";
        }else
        {
            wordLabel.text = @"倍";
        }
        wordLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
        wordLabel.textColor = YZBlackTextColor;
        CGSize wordLabelSize = [wordLabel.text sizeWithLabelFont:wordLabel.font];
        if (i == 0) {
            wordLabel.frame = CGRectMake(adjustNumberView.x - wordLabelSize.width - 3, 0,wordLabelSize.width, numberView.height);
        }else
        {
            wordLabel.frame = CGRectMake(CGRectGetMaxX(adjustNumberView.frame) + 3, 0,wordLabelSize.width, numberView.height);
        }
        [numberView addSubview:wordLabel];
    }
    
    //提示
    UIView * promptView = [[UIView alloc] initWithFrame:CGRectMake(0, numberView.y - promptViewH, screenWidth, promptViewH)];
    promptView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:promptView];
    
    UILabel *  promptLabel = [[UILabel alloc] initWithFrame:promptView.bounds];
    promptLabel.text = @"页面盘口、赔率仅供参考，请以出票时的盘口、赔率为准";
    promptLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    promptLabel.textColor = [UIColor darkGrayColor];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    [promptView addSubview:promptLabel];
    
    //选择玩法
    YZBasketBallPassWayView * choosePassWayView = [[YZBasketBallPassWayView alloc] initWithFrame:CGRectMake(0, self.bottomView.y, screenWidth, 0) statusArray:self.statusArray];
    self.choosePassWayView = choosePassWayView;
    choosePassWayView.hidden = YES;
    [self.view addSubview:choosePassWayView];
    
    [self.view bringSubviewToFront:bottomView];
    [self.view bringSubviewToFront:passWayView];
    [self.view bringSubviewToFront:numberView];
    
    [self setPassWayButtonTitle];
    [self computeBetCountAndPrizeRange];
}

- (void)adjustNumbeView:(YZAdjustNumberView *)numberView currentNumber:(NSString *)number
{
    [self computeBetCountAndPrizeRange];
}
#pragma mark - 按钮点击
- (void)addButtonDidClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)emptyBtnDidClick
{
    for(YZMatchInfosStatus *matchInfosModel in self.statusArray)
    {
        [matchInfosModel deleteAllSelBtn];//删除所有选中按钮
    }
    
    [self.statusArray removeAllObjects];
    [self.tableView reloadData];
    [self setTitleLabelText];
    [self computeBetCountAndPrizeRange];
}

- (void)passWayBtnClick:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"收起"]) {
        [UIView animateWithDuration:animateDuration animations:^{
            self.passWayView.y = self.bottomView.y - self.passWayView.height;
            self.numberView.y = self.bottomView.y - self.numberView.height;
            self.choosePassWayView.y = self.bottomView.y;
        }completion:^(BOOL finished) {
            [self setPassWayButtonTitle];
            
            self.choosePassWayView.hidden = YES;
            [self computeBetCountAndPrizeRange];
        }];
    }else
    {
        if(self.statusArray.count < 2)
        {
            [MBProgressHUD showError:@"请至少选择2场比赛"];
            return;
        }
        
        self.choosePassWayView.hidden = NO;
        [UIView animateWithDuration:animateDuration animations:^{
            self.passWayView.y = self.bottomView.y - self.passWayView.height - self.choosePassWayView.height;
            self.numberView.y = self.bottomView.y - self.numberView.height - self.choosePassWayView.height;
            self.choosePassWayView.y = self.bottomView.y - self.choosePassWayView.height;
        }completion:^(BOOL finished) {
            [button setTitle:@"收起" forState:UIControlStateNormal];
        }];
    }
}

- (void)setPassWayButtonTitle
{
    NSMutableString * buttonTitleStr = [NSMutableString string];
    for (UIButton * button in self.choosePassWayView.selFreeWayButtons) {
        [buttonTitleStr appendFormat:@"%@;", button.currentTitle];
    }
    for (UIButton * button in self.choosePassWayView.selMoreWayButtons) {
        [buttonTitleStr appendFormat:@"%@;", button.currentTitle];
    }
    if (YZStringIsEmpty(buttonTitleStr)) {
        [self.passWayBtn setTitle:@"过关方式" forState:UIControlStateNormal];
    }else
    {
        [self.passWayBtn setTitle:[buttonTitleStr substringToIndex:buttonTitleStr.length - 1] forState:UIControlStateNormal];
    }
}

#pragma mark - 投注
- (void)betBtnClick
{
    int minMatchCount = 2;
    if (_selectedPlayType >= 5) {
        minMatchCount = 1;
    }
    if(self.statusArray.count < minMatchCount)
    {
        [MBProgressHUD showError:[NSString stringWithFormat:@"请至少选择%d场比赛",minMatchCount]];
        return;
    }
    if(_amountMoney > 20000)
    {
        [MBProgressHUD showError:@"单注金额不能超过2万元"];
        return;
    }
    if(!UserId)//没登录
    {
        YZLoginViewController *loginVc = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }else
    {
        [self loadUserInfo];//刷新个人信息
    }
}

- (void)loadUserInfo
{
    if (!UserId)
    {
        [MBProgressHUD hideHUDForView:self.view];
        return;
    }
    waitingView;
    NSDictionary *dict = @{
                           @"cmd":@(8006),
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            //存储用户信息
            YZUser *user = [YZUser objectWithKeyValues:json];
            [YZUserDefaultTool saveUser:user];
            [self getConsumableList];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"账户error");
    }];
}

- (void)getConsumableList
{
    NSDictionary * orderDic = @{
                                @"money":@(_amountMoney * 100),
                                @"game":@"T52"
                                };
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"order":orderDic,
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithURL:BaseUrlCoupon(@"/getConsumableList") params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (SUCCESS) {
            NSArray * respCouponList = json[@"respCouponList"];
            if (respCouponList.count == 0) {
                [self showComfirmPayAlertView];
            }else
            {
                [self gotoChooseVoucherVC];
            }
        }else
        {
            [self showComfirmPayAlertView];
        }
    }failure:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}

- (void)gotoChooseVoucherVC
{
    //选择彩券
    YZChooseVoucherViewController * chooseVoucherVC = [[YZChooseVoucherViewController alloc]init];
    chooseVoucherVC.gameId = @"T52";
    chooseVoucherVC.amountMoney = _amountMoney;
    chooseVoucherVC.betCount = _betCount;
    chooseVoucherVC.multiple = [self.adjustNumberView.textField.text intValue];
    NSString * betType;
    if (_selectedPlayType >= 5) {//单关1串1
        betType = @"11";
    }else
    {
        betType = [self getBetType];
    }
    chooseVoucherVC.betType = betType;
    chooseVoucherVC.numbers = [self getNumbers];
    chooseVoucherVC.playType = _playType;
    chooseVoucherVC.isJC = YES;
    [self.navigationController pushViewController:chooseVoucherVC animated:YES];
}

- (NSMutableString *)getBetType
{
    NSMutableString *betTypes = [NSMutableString string];
    for (UIButton * button in self.choosePassWayView.selFreeWayButtons) {
        NSString * freeWay = button.currentTitle;
        NSString * betType = [freeWay stringByReplacingOccurrencesOfString:@"串" withString:@""];
        [betTypes appendString:betType];
        [betTypes appendString:@","];
    }
    for (UIButton * button in self.choosePassWayView.selMoreWayButtons) {
        NSString * moreWay = button.currentTitle;
        NSString * betType = [moreWay stringByReplacingOccurrencesOfString:@"串" withString:@""];
        [betTypes appendString:betType];
        [betTypes appendString:@","];
    }
    if (betTypes.length > 1) {
        [betTypes deleteCharactersInRange:NSMakeRange(betTypes.length - 1, 1)];
    }
    
    return  betTypes;
}

//拼接比赛信息的字符串
- (NSMutableString *)getNumbers
{
    NSMutableString *numbers = [NSMutableString string];
    for(YZMatchInfosStatus *matchInfosModel in self.statusArray)
    {
        if([matchInfosModel numberSelMatch] > 0)
        {
            for (NSMutableArray * selMatchArr in matchInfosModel.selMatchArr) {
                NSString *number = [self getNumberFromOddsInfoArray:selMatchArr withCode:matchInfosModel.code];
                [numbers appendString:number.length > 0 ? [NSString stringWithFormat:@"%@",number] : @""];
                if(number.length > 0) [numbers appendString:@"&"];
            }
            if(numbers.length > 0) [numbers deleteCharactersInRange:NSMakeRange(numbers.length-1, 1)];//删除最后一个&
            if(numbers.length > 0) [numbers appendString:@";"];
        }
    }
    if(numbers.length > 0) [numbers deleteCharactersInRange:NSMakeRange(numbers.length-1, 1)];//删除最后一个分号
    
    YZLog(@"numbers = %@",numbers);
    return  numbers;
}
//返回的格式是"02|201407244001|3,1,0"
- (NSMutableString *)getNumberFromOddsInfoArray:(NSMutableArray *)oddsInfoArray withCode:(NSString *)code
{
    if(!oddsInfoArray || oddsInfoArray.count == 0) return nil;
    NSString *oddsInfo = [self getOddsInfoFromArray:oddsInfoArray];
    if(oddsInfo.length == 0) return nil;
    NSMutableString *number = [NSMutableString string];
    YZFootBallMatchRate *rate = [oddsInfoArray firstObject];
    NSDictionary * playTypeDict = @{@"CN01" : @"01",@"CN02" : @"02",@"CN03" : @"03",@"CN04" : @"04",@"CN05" : @"05"};
    NSString *playType = playTypeDict[rate.CNType];
    
    [number appendString:playType];
    [number appendString:@"|"];
    [number appendString:code];
    [number appendString:@"|"];
    [number appendString:oddsInfo];
    
    //设置playType
    if(!_playType)//空，直接赋值
    {
        _playType = playType;
    }else
    {
        if(![_playType isEqualToString:playType])//不相等，说明是混合投注
        {
            _playType = @"05";
        }
    }
    
    return number;
}
//返回的格式是"3,1,0"
- (NSMutableString *)getOddsInfoFromArray:(NSMutableArray *)oddsInfoArray
{
    if(!oddsInfoArray || oddsInfoArray.count == 0) return nil;
    NSMutableString *oddsInfo = [NSMutableString string];
    YZFootBallMatchRate *rate = [oddsInfoArray firstObject];
    if ([rate.CNType isEqualToString:@"CN01"]) {//让球
        for (YZFootBallMatchRate * rate in oddsInfoArray) {
            if ([rate.info isEqualToString:@"让球客胜"]) {
                [oddsInfo appendString:@"2,"];
            }else if ([rate.info isEqualToString:@"让球主胜"])
            {
                [oddsInfo appendString:@"1,"];
            }
        }
    }else if ([rate.CNType isEqualToString:@"CN02"])//胜负
    {
        for (YZFootBallMatchRate * rate in oddsInfoArray) {
            if ([rate.info isEqualToString:@"客胜"]) {
                [oddsInfo appendString:@"2,"];
            }else if ([rate.info isEqualToString:@"主胜"])
            {
                [oddsInfo appendString:@"1,"];
            }
        }
    }else if ([rate.CNType isEqualToString:@"CN03"])//胜分差
    {
        for (YZFootBallMatchRate * rate in oddsInfoArray) {
            NSDictionary * bBshengfenDic = [YZTool bBshengfenDic];
            for (NSString * key in bBshengfenDic) {
                if ([bBshengfenDic[key] isEqualToString:rate.info]) {
                    [oddsInfo appendFormat:@"%@,", key];
                }
            }
        }
    }else if ([rate.CNType isEqualToString:@"CN04"])//大小分
    {
        for (YZFootBallMatchRate * rate in oddsInfoArray) {
            if ([rate.info isEqualToString:@"大分"]) {
                [oddsInfo appendString:@"1,"];
            }else if ([rate.info isEqualToString:@"小分"])
            {
                [oddsInfo appendString:@"2,"];
            }
        }
    }
    if(oddsInfo.length > 0)
        [oddsInfo deleteCharactersInRange:NSMakeRange(oddsInfo.length - 1, 1)];//删除最后一个,
    return oddsInfo;
}

- (void)showComfirmPayAlertView
{
    BOOL hasEnoughMoney = [YZTool hasEnoughMoneyWithAmountMoney:_amountMoney];
    if (hasEnoughMoney) {
        NSString * message = [YZTool getAlertViewTextWithAmountMoney:_amountMoney];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"支付确认" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getCurrentTermData];//当前期次的信息
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

- (void)gotoRecharge
{
    YZRechargeListViewController *rechargeVc = [[YZRechargeListViewController alloc] init];
    rechargeVc.isOrderPay = YES;
    [self.navigationController pushViewController:rechargeVc animated:YES];
}

//获取当前期信息
- (void)getCurrentTermData
{
    [MBProgressHUD showMessage:text_gettingCurrentTerm toView:self.view];
    NSDictionary *dict = @{
                           @"cmd":@(8028),
                           @"gameId":@"T52"
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"getCurrentTermData - json = %@",json);
        if(SUCCESS)
        {
            if(!Jump)//不跳
            {
                [self comfirmPay];//支付
            }else //跳转网页
            {
                [MBProgressHUD hideHUDForView:self.view];
                NSNumber *multiple = [NSNumber numberWithInt:[self.adjustNumberView.textField.text intValue]];//投多少倍
                NSNumber *amount = [NSNumber numberWithInt:(int)_amountMoney * 100];
                NSString *number = [self getNumbers];
#if JG
                NSString * mcpStr = @"EZmcp";
#elif ZC
                NSString * mcpStr = @"ZCmcp";
#elif CS
                NSString * mcpStr = @"CSmcp";
#endif
                NSString *param = [NSString stringWithFormat:@"userId=%@&gameId=%@&multiple=%@&amount=%@&number=%@&payType=%@&id=%@&channel=%@&childChannel=%@&version=%@&playType=%@&betType=%@&remark=%@",UserId,@"T52",multiple,amount,[number URLEncodedString],@"ACCOUNT",@"1407305392008",mainChannel,childChannel,[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],_playType,[self getBetType],mcpStr];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",jumpURLStr,param]];
                YZLog(@"url = %@",url);
                
                [[UIApplication sharedApplication] openURL:url];
            }
        }else
        {
            ShowErrorView
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"获取当前期信息失败"];
        YZLog(@"getCurrentTermData - error = %@",error);
    }];
}
#pragma  mark - 确认支付
- (void)comfirmPay//支付接口
{
    [MBProgressHUD showMessage:text_paying toView:self.view];
    NSNumber *multiple = [NSNumber numberWithInt:[self.adjustNumberView.textField.text intValue]];
    NSNumber *amount = [NSNumber numberWithInt:(int)_amountMoney * 100];
    NSString * betType;
    if (_selectedPlayType >= 7) {//单关1串1
        betType = @"11";
    }else
    {
        betType = [self getBetType];
    }
    NSDictionary *dict = @{
                           @"cmd":@(8034),
                           @"userId":UserId,
                           @"gameId":@"T52",
                           @"multiple":multiple,
                           @"amount":amount,
                           @"payType":@"ACCOUNT",
                           @"number":[self getNumbers],
                           @"playType":_playType,
                           @"betType":betType,
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];//隐藏正在支付的弹框
        if(SUCCESS)
        {
            //清空所有数据
            [self deleteAllStatus];
            //支付成功控制器
            YZFbBetSuccessViewController *betSuccessVc = [[YZFbBetSuccessViewController alloc] initWithAmount:[amount floatValue] bonus:[json[@"balance"] floatValue] isJC:YES];
            //跳转
            [self.navigationController pushViewController:betSuccessVc animated:YES];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];//隐藏正在支付的弹框
        YZLog(@"error = %@",error);
    }];
}

- (void)deleteAllStatus
{
    for(YZMatchInfosStatus *matchInfosModel in self.statusArray)
    {
        [matchInfosModel deleteAllSelBtn];
    }
    [self.statusArray removeAllObjects];
    [self.tableView reloadData];
    [self setTitleLabelText];
    [self computeBetCountAndPrizeRange];
}

#pragma mark - 设置label的文字
- (void)setTitleLabelText
{
    NSString * matchNumStr = [NSString stringWithFormat:@"%ld", self.statusArray.count];
    NSString * timeStr = @"";
    NSTimeInterval timeIntervalMin = 0;
    for (YZMatchInfosStatus *matchInfosModel in self.statusArray) {
        NSTimeInterval timeInterval = [YZDateTool getTimestampByTime:matchInfosModel.endTime format:@"yyyy-MM-dd HH:mm:ss"];
        if (timeIntervalMin == 0 || timeInterval < timeIntervalMin) {
            timeIntervalMin = timeInterval;
            NSDate * timeDate = [YZDateTool getDateFromDateString:matchInfosModel.endTime format:@"yyyy-MM-dd HH:mm:ss"];
            timeStr = [YZDateTool getDateStringFromDate:timeDate format:@"MM-dd HH:mm"];
        }
    }
    NSString * titleStr = [NSString stringWithFormat:@"已选%@场比赛，截止时间%@", matchNumStr, timeStr];
    NSMutableAttributedString * titleAttStr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    NSRange range1 = [titleAttStr.string rangeOfString:@"选"];
    NSRange range2 = [titleAttStr.string rangeOfString:@"场"];
    [titleAttStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
    self.titleLabel.attributedText = titleAttStr;
}

- (void)setAmountLabelText
{
    NSInteger betCount = _betCount;
    NSInteger multiple = [self.adjustNumberView.textField.text integerValue];
    _amountMoney = _betCount * 2 * multiple;
    NSString * moenyStr = [NSString stringWithFormat:@"共%ld注 %ld倍 %ld元", betCount, multiple, betCount * multiple * 2];
    NSMutableAttributedString * moneyAttStr = [[NSMutableAttributedString alloc] initWithString:moenyStr];
    NSRange range1 = [moneyAttStr.string rangeOfString:@"倍"];
    NSRange range2 = [moneyAttStr.string rangeOfString:@"元"];
    [moneyAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(224, 230, 119, 1) range:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
    self.amountLabel.attributedText = moneyAttStr;
    
}

- (void)setBonusLabelTextWithMinPrize:(double)minPrize maxPrize:(double)maxPrize
{
    NSInteger multiple = [self.adjustNumberView.textField.text integerValue];
    self.bonusLabel.text = [NSString stringWithFormat:@"预测奖金(仅供参考):%@-%@元", [YZTool formatFloat:minPrize * 2 * multiple], [YZTool formatFloat:maxPrize * 2 * multiple]];
}

#pragma mark - tableView的数据源和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.statusArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZBasketBallBetTableViewCell *cell = [YZBasketBallBetTableViewCell cellWithTableView:tableView];
    cell.matchInfosModel = self.statusArray[indexPath.section];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YZBasketBallBetHeaderView *header = [YZBasketBallBetHeaderView headerViewWithTableView:tableView];
    header.delegate = self;
    header.tag = section;
    header.matchInfosModel = self.statusArray[section];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZMatchInfosStatus *matchInfosModel = self.statusArray[indexPath.section];
    return matchInfosModel.cellH;
}

//headerView的代理方法
- (void)headerViewDidClickWithHeader:(YZBasketBallBetHeaderView *)header
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:header.tag];
    YZMatchInfosStatus *matchInfosModel = self.statusArray[header.tag];
    [matchInfosModel deleteAllSelBtn];
    [self.statusArray removeObjectAtIndex:header.tag];
    [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [self computeBetCountAndPrizeRange];
    [self setTitleLabelText];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _upDateIndexPath = indexPath;
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.backView = backView;
    backView.backgroundColor = YZColor(0, 0, 0, 0.4);
    [KEY_WINDOW addSubview:backView];
    
    YZMatchInfosStatus *matchInfosModel = self.statusArray[indexPath.section];
    matchInfosModel.playTypeTag = _selectedPlayType;
    YZBasketBallAllPlayView * allPlayView = [[YZBasketBallAllPlayView alloc]initWithFrame:CGRectMake(20, statusBarH, screenWidth - 40, screenHeight - statusBarH) matchInfosModel:matchInfosModel onlyShowShengfen:NO];
    self.allPlayView = allPlayView;
    allPlayView.delegate = self;
    [backView addSubview:allPlayView];
    allPlayView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        allPlayView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBackView)];
    tap.delegate = self;
    [backView addGestureRecognizer:tap];
}

- (void)removeBackView
{
    [self.backView removeFromSuperview];
}

- (void)upDateByMatchInfosModel:(YZMatchInfosStatus *)matchInfosModel
{
    self.statusArray[_upDateIndexPath.section] = matchInfosModel;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:_upDateIndexPath.section];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    [self computeBetCountAndPrizeRange];
}

#pragma mark - 手势协议
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.allPlayView) {
            CGPoint pos = [touch locationInView:self.allPlayView.superview];
            if (CGRectContainsPoint(self.allPlayView.frame, pos)) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - 计算注数和奖金
- (void)computeBetCountAndPrizeRange
{
    __block NSMutableArray *muArr = [NSMutableArray array];
    NSArray * playWays = [self getPlayWayIndexArray];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        muArr = [YZFbasketBallTool computeBetCountAndPrizeRangeWithBetArray:self.statusArray playWays:playWays selectedPlayType:_selectedPlayType];
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        
        //回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            _betCount = [muArr[0] intValue];
            _minPrize = [muArr[1] floatValue];
            _maxPrize = [muArr[2] floatValue];
            [self setAmountLabelText];
            [self setBonusLabelTextWithMinPrize:_minPrize maxPrize:_maxPrize];
            YZLog(@"muArr:%@", muArr);
        });
    }];
    [op2 addDependency:op1];//先算，后更新UI
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSArray *opArr = [NSArray arrayWithObjects:op1,op2, nil];
    [queue addOperations:opArr waitUntilFinished:NO];
}
- (NSArray *)getPlayWayIndexArray
{
    NSMutableArray * playArray = [NSMutableArray array];
    NSArray * moreWayIndexArray = [self getMoreWayIndexArray];
    NSArray * freeWayIndexArray = [self getFreeWayIndexArray];
    [playArray addObjectsFromArray:freeWayIndexArray];
    [playArray addObjectsFromArray:moreWayIndexArray];
    return playArray;
}
- (NSArray *)getMoreWayIndexArray
{
    NSMutableArray *moreWayIndexArray = [NSMutableArray array];
    if (self.choosePassWayView.selMoreWayButtons.count > 0) {//有选择多串过关方式
        NSDictionary * morePassWayDic = [YZFootBallTool getMorePassWayDict];
        for (UIButton * button in self.choosePassWayView.selMoreWayButtons) {
            NSString * morePassWayKey = button.currentTitle;
            NSArray * morePassWayArr = [morePassWayKey componentsSeparatedByString:@"串"];
            NSString * morePassWayValue = morePassWayDic[morePassWayKey];//3,1,0,0,0,0,0
            NSArray * freePassWayNums = [morePassWayValue componentsSeparatedByString:@","];
            //把多串过关拆分成自由过关
            for (int i = 0; i < freePassWayNums.count; i++) {
                int freePassWayNum = [freePassWayNums[i] intValue];
                if (freePassWayNum > 0) {
                    YZPlayPassWay * playPassWay = [[YZPlayPassWay alloc]init];
                    playPassWay.index = [[morePassWayArr firstObject] intValue];
                    playPassWay.number = i + 2;
                    playPassWay.name = morePassWayKey;
                    [moreWayIndexArray addObject:playPassWay];
                }
            }
        }
    }
    return [moreWayIndexArray copy];
}
- (NSArray *)getFreeWayIndexArray//有多少个自由过关方式，元素是m串1的m值
{
    NSMutableArray *freeWayIndexArray = [NSMutableArray arrayWithCapacity:self.choosePassWayView.selFreeWayButtons.count];
    for (UIButton * button in self.choosePassWayView.selFreeWayButtons) {
        NSString * freePassWayKey = button.currentTitle;
        YZPlayPassWay * playPassWay = [[YZPlayPassWay alloc]init];
        playPassWay.index = (int)button.tag + 2;
        playPassWay.number = (int)button.tag + 2;
        playPassWay.name = freePassWayKey;
        [freeWayIndexArray addObject:playPassWay];
    }
    return [freeWayIndexArray copy];
}


@end
