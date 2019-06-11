//
//  YZUnionBuyDetailViewController.m
//  ez
//
//  Created by apple on 15/3/20.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#define padding 5.0f
#define bottomViewH 80
#define orderInfoLabelH 22
#define orderInfoLabelCount 10

#import "YZUnionBuyDetailViewController.h"
#import "YZBetSuccessViewController.h"
#import "YZRechargeListViewController.h"
#import "YZFCOrderDetailTableViewCell.h"
#import "YZLoginViewController.h"
#import "YZNavigationController.h"
#import "YZUnionBuyFollowRecordViewController.h"//合买跟单记录控制器
#import "JSON.h"
#import "YZUnionBuyStatus.h"
#import "YZCircleChart.h"
#import "YZValidateTool.h"
#import "YZUnionChangeNickNameView.h"
#import "YZUnionBuyDetaiBottomView.h"
#import "YZUnionBuyComfirmPayTool.h"
#import "YZDateTool.h"
#import "YZTicketList.h"
#import "NSDate+YZ.h"

@interface YZUnionBuyDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,YZUnionChangeNickNameViewDelegate, YZUnionBuyDetaiBottomViewDelegate>
{
    BOOL _isUnionBuyDetail;//是合买详情，no就是我的合买记录详情
    NSString *_unionBuyPlanId;
    NSString *_unionBuyUserId;
}
@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) YZUnionBuyStatus *unionBuyStatus;//合买信息模型
//上面部分的界面
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, weak) UIImageView * logoImageView;//logo
@property (nonatomic, weak) UILabel *gameNameLabel;
@property (nonatomic, weak) UILabel *termIdLabel;
@property (nonatomic, weak) UIView *separator;
@property (nonatomic, strong) NSMutableArray *topLabels;
@property (nonatomic,weak) UILabel *gradeLabel;
@property (nonatomic, weak) YZCircleChart *circleChart;//圆饼图
@property (nonatomic, weak) UILabel *statusLabel;
@property (nonatomic,weak) UIView *lineView;
//下面部分的界面
@property (nonatomic,strong) UIView *footerView;
@property (nonatomic,weak) UIButton *followDetailBtn;
@property (nonatomic, weak) UIButton *cancelPlanBtn;
@property (nonatomic, weak) YZUnionBuyDetaiBottomView *bottomView;
@property (nonatomic,weak) UIView *myUnionBuyBottomView;
@property (nonatomic, weak) UILabel *ratioLabel;//占用比例
@property (nonatomic, weak) UILabel *myUnionRatioLabel;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YZUnionBuyDetailViewController

- (instancetype)initWithUnionBuyPlanId:(NSString *)unionBuyPlanId gameId:(NSString *)gameId
{
    if(self = [super init])
    {
        _unionBuyPlanId = unionBuyPlanId;
        _gameId = gameId;
        _isUnionBuyDetail = YES;
    }
    return  self;
}
- (instancetype)initWithUnionBuyUserId:(NSString *)unionBuyUserId unionBuyPlanId:(NSString *)unionBuyPlanId gameId:(NSString *)gameId
{
    if(self = [super init])
    {
        _unionBuyUserId = unionBuyUserId;
        _unionBuyPlanId = unionBuyPlanId;
        _gameId = gameId;
    }
    return  self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //先初始化固定控件
    [self setupChilds];
    waitingView_loadingData
    //获取订单详情数据
    [self getUnionBuyDetailData];
}
#pragma mark - 获取订单明细
- (void)getUnionBuyDetailData
{
    NSNumber *cmd = _isUnionBuyDetail ? @(8121) : @(8124);//合买详情就是前面，我的合买记录详情就是后面的
    NSMutableDictionary *dict = [@{
                           @"cmd":cmd,
                           } mutableCopy];
    if(_isUnionBuyDetail)
    {
        [dict setObject:_unionBuyPlanId forKey:@"unionBuyPlanId"];//合买详情
    }else
    {
        [dict setObject:_unionBuyUserId forKey:@"unionBuyUserId"];//我的合买记录详情
    }

    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"getUnionBuyDetailData - json = %@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            self.unionBuyStatus = [YZUnionBuyStatus objectWithKeyValues:json[@"unionBuy"]];
            [self setDataArray];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"getOrderDetailData - error = %@",error);
    }];
}
- (void)setDataArray
{
    for (int i = 0; i < self.unionBuyStatus.tickets.count; i++) {
        YZFCOrderDetailStatus * status = [[YZFCOrderDetailStatus alloc] init];
        YZOrder *order = [[YZOrder alloc] init];
        order.winNumber = self.unionBuyStatus.winNumber;
        order.gameId = self.gameId;
        status.order = order;
        status.ticketList = self.unionBuyStatus.tickets[i];
        [self.dataArray addObject:status];
    }
    [self.tableView reloadData];
}
#pragma mark - 初始化所有子控件
- (void)setupChilds
{
    CGFloat tableViewH = screenHeight - statusBarH - navBarH - bottomViewH - [YZTool getSafeAreaBottom];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, tableViewH) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:tableView];
    
    //headerView
    //上面显示的界面
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50 + orderInfoLabelH * orderInfoLabelCount + 7 * 2 + 10)];
    self.headerView.backgroundColor = [UIColor whiteColor];
    
    //logo
    UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7.5, 35, 35)];
    self.logoImageView = logoImageView;
    [self.headerView addSubview:logoImageView];
    
    //彩票名字
    UILabel *gameNameLabel = [[UILabel alloc] init];
    self.gameNameLabel = gameNameLabel;
    gameNameLabel.textColor = YZBlackTextColor;
    gameNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [self.headerView addSubview:gameNameLabel];
    
    //期数
    UILabel *termIdLabel = [[UILabel alloc] init];
    self.termIdLabel = termIdLabel;
    termIdLabel.textColor = YZGrayTextColor;
    termIdLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [self.headerView addSubview:termIdLabel];
    
    //分割线
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 50, screenWidth, 1)];
    separator.backgroundColor = YZWhiteLineColor;
    self.separator = separator;
    [self.headerView addSubview:separator];
    
    //发起用户、订单编号、发起时间、结束时间、投注倍数、方案金额、方案佣金、方案详情、方案进行中
    for(NSUInteger i = 0; i < orderInfoLabelCount; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        label.textColor = YZBlackTextColor;
        label.numberOfLines = 0;
        [self.headerView addSubview:label];
        [self.topLabels addObject:label];
    }
    
    //等级
    UILabel *gradeLabel = [[UILabel alloc] init];
    self.gradeLabel = gradeLabel;
    gradeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(20)];
    gradeLabel.textColor = YZBlackTextColor;
    [self.headerView addSubview:gradeLabel];
    
    //方案进度的圆饼图
    YZCircleChart *circleChart = [[YZCircleChart alloc] init];
    self.circleChart = circleChart;
    [self.headerView addSubview:circleChart];
    
    //状态
    UILabel *statusLabel = [[UILabel alloc] init];
    self.statusLabel = statusLabel;
    statusLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    statusLabel.textColor = YZColor(134, 134, 134, 1);
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.numberOfLines = 0;
    [self.headerView addSubview:statusLabel];
    
    //分割线
    UIView *lineView = [[UIView alloc] init];
    self.lineView = lineView;
    lineView.backgroundColor = YZBackgroundColor;
    [self.headerView addSubview:lineView];
    
    //footerView
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 0)];
    self.footerView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
    lineView2.backgroundColor = YZBackgroundColor;
    [self.footerView addSubview:lineView2];
    
    //跟单详情
    YZBottomButton *followDetailBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.followDetailBtn = followDetailBtn;
    followDetailBtn.frame = CGRectMake(YZMargin, CGRectGetMaxY(lineView2.frame) + YZMargin, screenWidth - 2 * YZMargin, 37);
    [followDetailBtn setTitle:@"跟单详情" forState:UIControlStateNormal];
    [followDetailBtn addTarget:self action:@selector(followDetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    followDetailBtn.layer.masksToBounds = YES;
    followDetailBtn.layer.cornerRadius = followDetailBtn.height / 2;
    [self.footerView addSubview:followDetailBtn];
    
    //撤单
    UIButton *cancelPlanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelPlanBtn = cancelPlanBtn;
    cancelPlanBtn.backgroundColor = [UIColor whiteColor];
    [cancelPlanBtn setTitle:@"撤单" forState:UIControlStateNormal];
    [cancelPlanBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    cancelPlanBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [cancelPlanBtn addTarget:self action:@selector(cancelPlanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    cancelPlanBtn.frame = CGRectMake(YZMargin, CGRectGetMaxY(followDetailBtn.frame) + YZMargin, screenWidth - 2 * YZMargin, 37);
    cancelPlanBtn.layer.masksToBounds = YES;
    cancelPlanBtn.layer.cornerRadius = cancelPlanBtn.height / 2;
    cancelPlanBtn.layer.borderWidth = 1;
    cancelPlanBtn.layer.borderColor = YZGrayLineColor.CGColor;
    [self.footerView addSubview:cancelPlanBtn];

    //底部视图
    CGFloat bottomViewY = screenHeight - statusBarH - navBarH - bottomViewH - [YZTool getSafeAreaBottom];
    YZUnionBuyDetaiBottomView *bottomView = [[YZUnionBuyDetaiBottomView alloc] initWithFrame:CGRectMake(0, bottomViewY, screenWidth, bottomViewH + [YZTool getSafeAreaBottom])];
    self.bottomView = bottomView;
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    
//    [self setupBottomBar];
    [self setupMyUnionBuyRecordDetailBottomBar];
}

//初始化我的合买记录详情的底部栏
- (void)setupMyUnionBuyRecordDetailBottomBar
{
    UIFont *unionFont = [UIFont systemFontOfSize:YZGetFontSize(24)];
    //底栏
    CGFloat bottomViewH_ = 40;
    CGFloat bottomViewY = screenHeight - bottomViewH_ - statusBarH - navBarH - [YZTool getSafeAreaBottom];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomViewY, screenWidth, bottomViewH_ + [YZTool getSafeAreaBottom])];
    self.myUnionBuyBottomView = bottomView;
    bottomView.backgroundColor = [UIColor whiteColor];
    //阴影
    bottomView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    bottomView.layer.shadowOffset = CGSizeMake(0, -1);
    bottomView.layer.shadowOpacity = 1;
    [self.view addSubview:bottomView];
    
    //占用多少的label
    UILabel *myUnionRatioLabel = [[UILabel alloc] init];
    self.myUnionRatioLabel = myUnionRatioLabel;
    myUnionRatioLabel.textAlignment = NSTextAlignmentCenter;
    myUnionRatioLabel.textColor = YZBlackTextColor;
    myUnionRatioLabel.font = unionFont;
    myUnionRatioLabel.frame = CGRectMake(padding, 0, screenWidth - 2 * padding, bottomViewH_);
    [bottomView addSubview:myUnionRatioLabel];
}
#pragma mark - 更新所有的UI
- (void)setUnionBuyStatus:(YZUnionBuyStatus *)unionBuyStatus
{
    _unionBuyStatus = unionBuyStatus;
    if(!_isUnionBuyDetail)
    {
        _unionBuyPlanId = _unionBuyStatus.unionBuyPlanId;
    }
    [self refreshUI];
}
- (void)refreshUI
{
    [self refreshTopUI];

    //撤单按钮
    if(!_isUnionBuyDetail &&  [_unionBuyStatus.status integerValue] == 10 && [_unionBuyStatus.schedule integerValue] < 50 && [_unionBuyStatus.userType integerValue] == 1)//不是合买大厅push过来的、方案进行中、认购金额大于等于50%时发起人不能撤单、发起合买才可以撤单
    {
        self.cancelPlanBtn.hidden = NO;
        self.cancelPlanBtn.height = 37;
        self.footerView.height = CGRectGetMaxY(self.cancelPlanBtn.frame) + YZMargin;
    }else
    {
        self.cancelPlanBtn.hidden = YES;
        self.cancelPlanBtn.height = 0;
        self.footerView.height = CGRectGetMaxY(self.followDetailBtn.frame) + YZMargin;
    }
    self.tableView.tableFooterView = self.footerView;

    if(_isUnionBuyDetail)
    {
        self.myUnionBuyBottomView.hidden = YES;
        if([_unionBuyStatus.status integerValue] > 10)
        {
            self.tableView.height = screenHeight - statusBarH - navBarH - [YZTool getSafeAreaBottom];
            self.bottomView.hidden = YES;
            return;//10以后都是满员，不出现底部参与购买栏
        }
        self.bottomView.hidden = NO;
        self.bottomView.unionBuyStatus = self.unionBuyStatus;
    }else
    {
        self.tableView.height = screenHeight - statusBarH - navBarH - 40 - [YZTool getSafeAreaBottom];
        self.bottomView.hidden = YES;
        self.myUnionBuyBottomView.hidden = NO;
        [self setMyUnionBuyRecordDetailRatioLabelText];
    }
}
- (void)refreshTopUI
{
    self.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",_unionBuyStatus.gameId]];
    
    //设置数据
    self.gameNameLabel.text = [NSString stringWithFormat:@"%@",_unionBuyStatus.gameName];
    self.termIdLabel.text = [NSString stringWithFormat:@"%@期",_unionBuyStatus.term.termId];
    
    //设置frame
    CGSize gameNameLabelSize = [self.gameNameLabel.text sizeWithLabelFont:self.gameNameLabel.font];
    self.gameNameLabel.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 10, 0, gameNameLabelSize.width, 50);
    
    //期数
    CGSize termIdLabelSize = [self.termIdLabel.text sizeWithLabelFont:self.termIdLabel.font];
    CGFloat termIdLabelX = CGRectGetMaxX(self.gameNameLabel.frame) + padding;
    self.termIdLabel.frame = CGRectMake(termIdLabelX, 0, termIdLabelSize.width, 50);
    
    //发起用户、订单编号、发起时间、结束时间、投注倍数、方案金额、方案佣金、方案详情、方案进行中
    UILabel *lastLabel;
    for(NSUInteger i = 0;i < self.topLabels.count; i++)
    {
        UILabel *label = self.topLabels[i];
        if (i == 0) {
            label.text = [NSString stringWithFormat:@"发起用户：%@",_unionBuyStatus.userName];
        }else if (i == 1)
        {
            label.text = [NSString stringWithFormat:@"订单编号：%@",_unionBuyStatus.unionBuyPlanId];
        }else if (i == 2)
        {
            label.text = [NSString stringWithFormat:@"发起时间：%@",_unionBuyStatus.createTime];
        }else if (i == 3)
        {
            label.text = [NSString stringWithFormat:@"结束时间：%@",_unionBuyStatus.endTime];
        }else if (i == 4)
        {
            label.text = [NSString stringWithFormat:@"投注倍数：%@倍",_unionBuyStatus.multiple];
        }else if (i == 5)
        {
            label.text = [NSString stringWithFormat:@"方案金额：%ld元",[_unionBuyStatus.totalAmount integerValue] / 100];
        }else if (i == 6)
        {
            label.text = [NSString stringWithFormat:@"方案佣金：%ld%%",(long)[_unionBuyStatus.commission integerValue]];
        }else if (i == 7)
        {
            label.text = [NSString stringWithFormat:@"方案详情：%@", [YZTool getSecretStatus:[_unionBuyStatus.settings integerValue]]];
        }else if (i == 8)
        {
            label.text = [NSString stringWithFormat:@"方案标题：%@",_unionBuyStatus.title ? _unionBuyStatus.title : @"无"];
        }else if (i == 9)
        {
            label.text = [NSString stringWithFormat:@"方案描述：%@",_unionBuyStatus.desc ? _unionBuyStatus.desc : @"无"];
        }
        CGSize labelSize = [label.text sizeWithFont:label.font maxSize:CGSizeMake(screenWidth -  2 * YZMargin, MAXFLOAT)];
        CGFloat labelY = CGRectGetMaxY(lastLabel.frame);
        if (i == 0) {
            labelY = 50;
        }
        CGFloat labelH = labelSize.height > 20 ? labelSize.height : orderInfoLabelH;
        label.frame = CGRectMake(YZMargin, labelY, labelSize.width, labelH);
        lastLabel = label;
    }
    self.gradeLabel.attributedText = [self getAttStrByGrade:_unionBuyStatus.grade];
    UILabel *userNameLabel = self.topLabels.firstObject;
    self.gradeLabel.frame = CGRectMake(CGRectGetMaxX(userNameLabel.frame) + 4, userNameLabel.y, screenWidth - (CGRectGetMaxX(userNameLabel.frame) + 4), userNameLabel.height);
    
    //圆饼图
    CGFloat circleChartWH = 65;
    CGFloat circleChartX = screenWidth - circleChartWH - 20;
    CGFloat circleChartY = 50 + 20;
    self.circleChart.frame = CGRectMake(circleChartX, circleChartY, circleChartWH, circleChartWH);
    self.circleChart.selfBuyRatio = _unionBuyStatus.schedule;
    self.circleChart.guaranteeRatio = @([_unionBuyStatus.deposit floatValue] / [_unionBuyStatus.totalAmount floatValue]);
    [self.circleChart strokeChart];
    
    //状态
    CGSize statusLabelSize;
    if ([_unionBuyStatus.hitMoney longLongValue] > 0) {//中奖
        NSString * money = [NSString stringWithFormat:@"%.2f", [_unionBuyStatus.hitMoney longLongValue] / 100.0];
        NSString * statusStr = [NSString stringWithFormat:@"%@\n%@%@元",_unionBuyStatus.ticketStatusDesc, _unionBuyStatus.statusDesc, money];
        NSMutableAttributedString * statusAttStr = [[NSMutableAttributedString alloc] initWithString:statusStr];
        [statusAttStr addAttribute:NSFontAttributeName value:self.statusLabel.font range:NSMakeRange(0, statusAttStr.length)];
        [statusAttStr addAttribute:NSForegroundColorAttributeName value:self.statusLabel.textColor range:NSMakeRange(0, statusAttStr.length)];
        [statusAttStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:[statusStr rangeOfString:money]];
        self.statusLabel.attributedText = statusAttStr;
        
        statusLabelSize = [self.statusLabel.attributedText boundingRectWithSize:CGSizeMake(circleChartWH + 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    }else
    {
        self.statusLabel.text = [NSString stringWithFormat:@"%@\n%@",_unionBuyStatus.ticketStatusDesc, _unionBuyStatus.statusDesc];
        statusLabelSize = [self.statusLabel.text sizeWithFont:self.statusLabel.font maxSize:CGSizeMake(circleChartWH + 20, MAXFLOAT)];
    }

    CGFloat statusLabelY = CGRectGetMaxY(self.circleChart.frame) + 7;
    self.statusLabel.frame = CGRectMake(0, statusLabelY, statusLabelSize.width, statusLabelSize.height);
    self.statusLabel.centerX = self.circleChart.centerX;
    
    self.lineView.frame = CGRectMake(0, CGRectGetMaxY(lastLabel.frame) + 7, screenWidth, 10);
    self.headerView.height = CGRectGetMaxY(self.lineView.frame);
    
    self.tableView.tableHeaderView = self.headerView;
}

- (void)setMyUnionBuyRecordDetailRatioLabelText
{
    NSInteger money = [_unionBuyStatus.money integerValue] / 100;
    NSInteger deposit = [_unionBuyStatus.deposit integerValue] / 100;
    float ratio = ([_unionBuyStatus.money floatValue] / [_unionBuyStatus.totalAmount floatValue]) * 100;
    NSString *str;
    if (deposit > 0) {
        str = [NSString stringWithFormat:@"已认购%ld元 占%0.1f%%  保底%ld元",(long)money, ratio, deposit];
    }else
    {
        str = [NSString stringWithFormat:@"已认购%ld元 占%0.1f%%",(long)money,ratio];
    }
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSDictionary *dict = @{NSFontAttributeName : [UIFont systemFontOfSize:YZGetFontSize(28)],NSForegroundColorAttributeName : YZRedTextColor};
    
    NSRange yuanRange = [str rangeOfString:@"元"];
    [attStr addAttributes:dict range:NSMakeRange(0, yuanRange.location + 1)];
    self.myUnionRatioLabel.attributedText = attStr;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL show = YES;
    int settings = [_unionBuyStatus.settings intValue];
    if (settings == 1) {//完全公开
        show = YES;
    }else if (settings == 2)//跟单可见
    {
        if (_isUnionBuyDetail) {
            show = NO;
        }else
        {
            show = YES;
        }
    }else if (settings == 3)//截止可见
    {
        NSString * endTime = _unionBuyStatus.endTime;
        NSString * sysTime = _unionBuyStatus.sysTime;
        NSDate * endDate = [YZDateTool getDateFromDateString:endTime format:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * sysDate = [YZDateTool getDateFromDateString:sysTime format:@"yyyy-MM-dd HH:mm:ss"];
        long long endTimeSp = [[NSNumber numberWithDouble:[endDate timeIntervalSince1970]] longLongValue];
        long long sysTimeSp = [[NSNumber numberWithDouble:[sysDate timeIntervalSince1970]] longLongValue];
        if (sysTimeSp > endTimeSp) {//已截止
            show = YES;
        }else
        {
            show = NO;
        }
    }else if (settings == 4)//完全保密
    {
        show = NO;
    }
    
    if (show) {
        return self.dataArray.count;
    }else
    {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZFCOrderDetailTableViewCell * cell = [YZFCOrderDetailTableViewCell cellWithTableView:tableView];
    if(indexPath.row % 2 != 0)
    {
        cell.backgroundColor = UIColorFromRGB(0xFFE7E7E7);
    }else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.status = self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZFCOrderDetailStatus * status = self.dataArray[indexPath.row];
    return status.cellH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!self.unionBuyStatus) return 0;
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (!self.unionBuyStatus) return nil;
    //开奖号码
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(YZMargin, 0, screenWidth - 2 * YZMargin, 30)];
    label.text = [NSString stringWithFormat:@"该方案设置为%@",[YZTool getSecretStatus:[_unionBuyStatus.settings integerValue]]];
    label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    label.textColor = YZBlackTextColor;
    [headerView addSubview:label];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 29, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [headerView addSubview:line];
    
    return headerView;
}
#pragma mark - 确认按钮点击、参与合买
- (void)bottomViewConfirmBtnClick
{
    [self.view endEditing:YES];
    
    if(!UserId)//没登录
    {
        YZLoginViewController *loginVc = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }

    if ([YZTool needChangeNickName]) {
        YZUnionChangeNickNameView * changeNickNameView = [[YZUnionChangeNickNameView alloc] initWithFrame:self.view.bounds];
        changeNickNameView.delegate = self;
        [self.view addSubview:changeNickNameView];
        return;
    }
    
    YZStartUnionbuyModel *param = [[YZStartUnionbuyModel alloc] init];
    param.gameId = self.gameId;
    param.userName = _unionBuyStatus.userName;
    param.unionBuyPlanId = _unionBuyStatus.unionBuyPlanId;
    param.planId = _unionBuyStatus.planId;
    param.money = @([self.bottomView.moneyTd.text integerValue] * 100);
    param.singleMoney = _unionBuyStatus.singleMoney;
    param.gameId = _unionBuyStatus.gameId;
    param.termId = _unionBuyStatus.issue;
    
    [[YZUnionBuyComfirmPayTool shareInstance] participateUnionBuyOfAllWithParam:param sourceController:self];
}
- (void)confirmBtnDidClick:(NSString *)nickName
{
    if (YZStringIsEmpty(nickName)) return;
    YZUser *user = [YZUserDefaultTool user];
    NSDictionary *dict = @{
                           @"cmd":@(8126),
                           @"userId":UserId,
                           @"userName":user.userName,
                           @"nickName":nickName
                           };
    waitingView
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            [self loadUserInfo];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"修改昵称失败"];
    }];
}
- (void)loadUserInfo
{
    if (!UserId) return;
    NSDictionary *dict = @{
                           @"cmd":@(8006),
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        YZLog(@"%@",json);
        if (SUCCESS) {
            //存储用户信息
            YZUser *user = [YZUser objectWithKeyValues:json];
            [YZUserDefaultTool saveUser:user];
            [MBProgressHUD showSuccess:@"修改成功"];
        }
    } failure:^(NSError *error) {
        YZLog(@"账户error");
    }];
}
#pragma mark - 撤单按钮点击
- (void)cancelPlanBtnClick
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认撤销订单吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cancelPlan];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}
//撤单订单接口
- (void)cancelPlan
{
    [MBProgressHUD showMessage:@"请稍后" toView:self.view];

    NSDictionary *dict = @{
                           @"cmd":@(8122),
                           @"unionBuyUserId":_unionBuyUserId,
                           };
    
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"cancelPlanBtnClick - json = %@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:@"撤销成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            dispatch_time_t poptime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(poptime, dispatch_get_main_queue(), ^{
                
                //请求账户中心刷新合买记录
                [MBProgressHUD showSuccess:@"购买成功"];
                //跳转
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshRecordNote object:@(AccountRecordTypeMyUnionBuy)];
            });
        }else
        {
            ShowErrorView
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"cancelPlanBtnClick - error = %@",error);
    }];
}
#pragma mark - 跟单详情按钮点击
- (void)followDetailBtnClick
{
    YZUnionBuyFollowRecordViewController *followList = [[YZUnionBuyFollowRecordViewController alloc] initWithUnionBuyPlanId:_unionBuyPlanId unionBuyUserId:_unionBuyStatus.userId];
    [self.navigationController pushViewController:followList animated:YES];
}
#pragma mark - 初始化
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)topLabels
{
    if(_topLabels == nil)
    {
        _topLabels = [NSMutableArray array];
    }
    return  _topLabels;
}

- (NSAttributedString *)getAttStrByGrade:(NSNumber *)grade
{
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] init];
    NSString * gradeSystem8 = [YZTool transformNumber:[NSString stringWithFormat:@"%@", grade] withNumberSystem:@"8"];
    NSMutableArray *characters = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        [characters addObject:@"0"];
    }
    if (gradeSystem8.length >= 4) {
        NSString * character = [gradeSystem8 substringWithRange:NSMakeRange(0, gradeSystem8.length - 3)];
        characters[0] = character;
    }
    if (gradeSystem8.length >= 3) {
        NSString * character = [gradeSystem8 substringWithRange:NSMakeRange(gradeSystem8.length - 3, 1)];
        characters[1] = character;
    }
    if (gradeSystem8.length >= 2) {
        NSString * character = [gradeSystem8 substringWithRange:NSMakeRange(gradeSystem8.length - 2, 1)];
        characters[2] = character;
    }
    if (gradeSystem8.length >= 1) {
        NSString * character = [gradeSystem8 substringWithRange:NSMakeRange(gradeSystem8.length - 1, 1)];
        characters[3] = character;
    }
    
    for (int i = 0; i < characters.count; i++) {
        if ([characters[i] intValue] > 0) {
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc]initWithData:nil ofType:nil];
            textAttachment.bounds = CGRectMake(0, 0, 16, 11);
            textAttachment.image = [UIImage imageNamed:[NSString stringWithFormat:@"unionBuy_gold_grade%d", i + 1]];
            NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [attStr appendAttributedString:textAttachmentString];
            
            NSAttributedString * textAttStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ", characters[i]]];
            [attStr appendAttributedString:textAttStr];
        }
    }
    
    return attStr;
}

@end
