//
//  YZFCOrderDetailViewController.m
//  ez
//
//  Created by apple on 16/9/30.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define orderInfoLabelH 27
#define orderInfoLabelCount 5

#import "YZFCOrderDetailViewController.h"
#import "YZRechargeListViewController.h"
#import "YZBetSuccessViewController.h"
#import "YZPublishLotteryCircleViewController.h"
#import "YZChooseVoucherViewController.h"
#import "YZFCOrderDetailTableViewCell.h"
#import "YZWinNumberBall.h"
#import "YZFCOrderDetailStatus.h"
#import "JSON.h"
#import "YZShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"

@interface YZFCOrderDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isScheme;//是追号跳转来的
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UITableView * tableView;//滚动视图
@property (nonatomic, weak) UIView * winView;//中奖视图
@property (nonatomic, weak) UIImageView * logoImageView;//logo
@property (nonatomic, weak) UILabel * playTypeNameLabel;//玩法名称
@property (nonatomic, weak) UILabel * bonusLabel;//奖金
@property (nonatomic, weak) UIView *orderInfoView;//订单信息的视图
@property (nonatomic, strong) NSMutableArray *orderInfoLabels;//订单信息的label数组
@property (nonatomic, weak) UIImageView *ticketImageView;//出票状态
@property (nonatomic, copy) NSString *currentTermId;
@property (nonatomic, strong) NSMutableArray *ticketList;//请求参数的号码数组

@end

@implementation YZFCOrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"投注详情";
    if (self.order) {//追号跳转来的,视图稍微不一样
        self.isScheme = YES;
    }else
    {
        self.isScheme = NO;
    }
    [self setupChilds];
    if (self.order) {//追号跳转来的，不用请求数据
        [self setDataArray];
    }else
    {
        waitingView_loadingData;
        [self getOrderDetailData];
    }
}
#pragma mark - 获取订单明细
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self getOrderDetailData];
}
- (void)getOrderDetailData
{
    NSDictionary *dict = @{
                           @"cmd":@(8022),
                           @"orderId":self.orderId
                           };
    
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        YZLog(@"json = %@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            self.order = [YZOrder objectWithKeyValues:json[@"order"]];
            [self setDataArray];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"getOrderDetailData - error = %@",error);
    }];
}
- (void)setDataArray
{
    for (int i = 0; i < self.order.ticketList.count; i++) {
        YZFCOrderDetailStatus * status = [[YZFCOrderDetailStatus alloc]init];
        status.order = self.order;
        status.ticketList = self.order.ticketList[i];
        [self.dataArray addObject:status];
    }
    [self.tableView reloadData];
    [self refreshUI];
}
#pragma mark - 布局视图
- (void)setupChilds
{
    //分享
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"order_share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    CGFloat tableViewH = screenHeight - statusBarH - navBarH - 40 - [YZTool getSafeAreaBottom];
    if (self.isScheme || [self.gameId isEqualToString:@"T53"] || [self.gameId isEqualToString:@"T54"]) {
        tableViewH = screenHeight - statusBarH - navBarH - [YZTool getSafeAreaBottom];
    }
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, tableViewH)];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:tableView];

    //顶部视图
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50 + orderInfoLabelH * orderInfoLabelCount + 7 * 2 + 10)];
    headerView.backgroundColor = YZBackgroundColor;
    
    //玩法信息
    UIView * playTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    playTypeView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:playTypeView];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 49, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [headerView addSubview:line];
    
    UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7.5, 35, 35)];
    self.logoImageView = logoImageView;
    [playTypeView addSubview:logoImageView];
    
    UILabel * playTypeNameLabel = [[UILabel alloc]init];
    self.playTypeNameLabel = playTypeNameLabel;
    playTypeNameLabel.font = [UIFont boldSystemFontOfSize:YZGetFontSize(30)];
    playTypeNameLabel.textColor = YZBlackTextColor;
    [playTypeView addSubview:playTypeNameLabel];
    
    UILabel * bonusLabel = [[UILabel alloc]init];
    self.bonusLabel = bonusLabel;
    bonusLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [playTypeView addSubview:bonusLabel];
    
    CGFloat orderInfoViewY = CGRectGetMaxY(playTypeView.frame);
    UIView * orderInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, orderInfoViewY, screenWidth, orderInfoLabelH * orderInfoLabelCount + 7 * 2)];
    orderInfoView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:orderInfoView];
    
    for (int i = 0; i < orderInfoLabelCount; i++) {
        UILabel * orderInfoLabel = [[UILabel alloc]init];
        orderInfoLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        orderInfoLabel.textColor = YZBlackTextColor;
        [orderInfoView addSubview:orderInfoLabel];
        
        [self.orderInfoLabels addObject:orderInfoLabel];
    }
    //状态图标
    CGFloat ticketImageViewWH = 50;
    UIImageView * ticketImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - ticketImageViewWH - 15, 7, ticketImageViewWH, ticketImageViewWH)];
    self.ticketImageView = ticketImageView;
    [orderInfoView addSubview:ticketImageView];
    
    tableView.tableHeaderView = headerView;
    
    UIView *bottomButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - statusBarH - navBarH - 40 - [YZTool getSafeAreaBottom], screenWidth, 40 + [YZTool getSafeAreaBottom])];
    bottomButtonView.backgroundColor = YZBaseColor;
    [self.view addSubview:bottomButtonView];
    
    NSArray * bottomButtonTitles = @[@"晒单"];
    if (!(self.isScheme || [self.gameId isEqualToString:@"T53"] || [self.gameId isEqualToString:@"T54"])) {
        //快速投注 胜负彩 四场进球不显示快速投注
        bottomButtonTitles = @[@"快速投注", @"晒单"];
    }
    CGFloat bottomButtonW = screenWidth / bottomButtonTitles.count;
    for (int i = 0; i < bottomButtonTitles.count; i++) {
        YZBottomButton * bottomButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
        bottomButton.tag = i;
        bottomButton.frame = CGRectMake(i * bottomButtonW, 0, bottomButtonW, 40);
        [bottomButton setTitle:bottomButtonTitles[i] forState:UIControlStateNormal];
        bottomButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
        [bottomButton addTarget:self action:@selector(bottomButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomButtonView addSubview:bottomButton];
    }
    if (bottomButtonTitles.count == 2)
    {
        //分割线
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(screenWidth / 2 - 0.75, (40 - 20) / 2, 1.5, 20)];
        line.backgroundColor = [UIColor whiteColor];
        [bottomButtonView addSubview:line];
    }
}
- (void)refreshUI
{
    if (self.order.openPrize) {//今日开奖
        self.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"today_%@",self.order.gameId]];
    }else
    {
#if JG
        self.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",self.order.gameId]];
#elif ZC
        self.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_zc",self.order.gameId]];
#elif CS
        self.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_zc",self.order.gameId]];
#endif
    }
    
    self.playTypeNameLabel.text = [YZTool gameIdNameDict][self.order.gameId];
    //是否中奖
    float bonus = [_order.bonus intValue] / 100.0;
    if(bonus > 0)
    {
        self.bonusLabel.text = [NSString stringWithFormat:@"中奖：%.2f元",bonus];
        self.bonusLabel.textColor = YZRedTextColor;
    }else
    {
        self.bonusLabel.text = self.order.ishitDesc;
        self.bonusLabel.textColor = YZGrayTextColor;
    }
    
    CGSize playTypeNameSize = [self.playTypeNameLabel.text sizeWithLabelFont:self.playTypeNameLabel.font];
    self.playTypeNameLabel.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + YZMargin, 10, playTypeNameSize.width, 30);
    
    CGSize bonusSize = [self.bonusLabel.text sizeWithLabelFont:self.bonusLabel.font];
    self.bonusLabel.frame = CGRectMake(screenWidth - bonusSize.width - YZMargin, 10, bonusSize.width, 30);
    
    //订单信息
    for (UILabel * orderInfoLabel in self.orderInfoLabels) {
        NSInteger index = [self.orderInfoLabels indexOfObject:orderInfoLabel];
        if (index == 0) {
            orderInfoLabel.text = [NSString stringWithFormat:@"彩种期号：第%@期",self.order.termId];
        }else if (index == 1)
        {
            orderInfoLabel.text = [NSString stringWithFormat:@"投注金额：%.2f元",[self.order.amount floatValue] / 100];
        }else if (index == 2)
        {
            orderInfoLabel.text = [NSString stringWithFormat:@"投注时间：%@",self.order.createTime];
        }else if (index == 3)
        {
            orderInfoLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.order.orderId];
        }else if (index == 4)
        {
            NSString * openWinTime = self.order.term.openWinTime;
            if (openWinTime.length > 0) {
                openWinTime = [openWinTime substringWithRange:NSMakeRange(0, 10)];
            }
            orderInfoLabel.text = [NSString stringWithFormat:@"开奖日期：%@", openWinTime];
        }
        CGSize orderInfoLabelSize = [orderInfoLabel.text sizeWithLabelFont:orderInfoLabel.font];
        CGFloat orderInfoLabelY = 7 + index * orderInfoLabelH;
        orderInfoLabel.frame = CGRectMake(YZMargin, orderInfoLabelY, orderInfoLabelSize.width, orderInfoLabelH);
    }
    
    if ([self.order.status intValue] == 2)//出票中
    {
        self.ticketImageView.image = [UIImage imageNamed:@"ticket_chupiaozhong"];
    }else if ([self.order.status intValue] == 3)//出票成功
    {
        self.ticketImageView.image = [UIImage imageNamed:@"ticket_chengong"];
    }else if ([self.order.status intValue] == 4)//出票失败
    {
        self.ticketImageView.image = [UIImage imageNamed:@"ticket_shibai"];
    }else if ([self.order.status intValue] == 5)//部分出票
    {
        self.ticketImageView.image = [UIImage imageNamed:@"ticket_bufen"];
    }
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *rid = @"betPromptCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rid];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"投注号码:";
            cell.textLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
            cell.textLabel.textColor = YZBlackTextColor;
        }
        return cell;
    }else
    {
        YZFCOrderDetailTableViewCell * cell = [YZFCOrderDetailTableViewCell cellWithTableView:tableView];
        if(indexPath.row % 2 != 0)
        {
            cell.backgroundColor = UIColorFromRGB(0xFFE7E7E7);
        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.status = self.dataArray[indexPath.row - 1];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 35;
    }
    YZFCOrderDetailStatus * status = self.dataArray[indexPath.row - 1];
    return status.cellH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSString *winNumber = self.order.winNumber;
    if (!winNumber || winNumber.length == 0) {//没有时
        return 0;
    }else
    {
        return 40 + 35;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *winNumber = self.order.winNumber;
    if (!winNumber || winNumber.length == 0) {//没有时不显示
        return nil;
    }else
    {
         //开奖号码
        UIView * winNumberView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 40 + 35)];
        winNumberView.backgroundColor = [UIColor whiteColor];
        
        UILabel * winNumberPromptLabel = [[UILabel alloc]initWithFrame:CGRectMake(YZMargin, 0, screenWidth - 20, 35)];
        winNumberPromptLabel.text = @"开奖号码:";
        winNumberPromptLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        winNumberPromptLabel.textColor = YZBlackTextColor;
        [winNumberView addSubview:winNumberPromptLabel];
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 34, screenWidth, 1)];
        line.backgroundColor = YZWhiteLineColor;
        [winNumberView addSubview:line];
        
        winNumber = [winNumber stringByReplacingOccurrencesOfString:@"|" withString:@","];
        NSArray *winNumberArr = [winNumber componentsSeparatedByString:@","];

        CGFloat padding = YZMargin;//最左边球里边框的间距
        CGFloat padding1 = 5;//两个球之间的间距
        CGFloat ballW = 25;
        CGFloat ballH = 25;
        if ([self.gameId isEqualToString:@"T53"]) {//胜负彩
            ballW = 15;
            padding1 = 2;
        }
        YZWinNumberBall * lastWinNumberBall;
        for(int i = 0;i < winNumberArr.count;i++)
        {
            CGFloat ballX = padding + (ballW + padding1) * i;
            CGFloat ballY = 35 + (40 - ballH) / 2;
            YZWinNumberBallStatus * winNumberBallStatus = [[YZWinNumberBallStatus alloc]init];
            winNumberBallStatus.number = winNumberArr[i];
            winNumberBallStatus.type = 1;
            if(i >= winNumberArr.count - [self getBlueBallCount:self.gameId])//蓝色的球
            {
                winNumberBallStatus.type = 2;
                ballX += 10;
            }
            if ([self.gameId isEqualToString:@"T53"]) {//胜负彩
                winNumberBallStatus.type = 4;
            }else if ([self.gameId isEqualToString:@"T53"])//四场进球
            {
                winNumberBallStatus.type = 3;
            }
            YZWinNumberBall * winNumberBall = [[YZWinNumberBall alloc]init];
            winNumberBall.frame = CGRectMake(ballX, ballY, ballW, ballH);
            winNumberBall.status = winNumberBallStatus;
            [winNumberView addSubview:winNumberBall];
            lastWinNumberBall = winNumberBall;
        }
        return winNumberView;
    }
}

#pragma mark - 底部按钮
- (void)bottomButtonDidClick:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"快速投注"]) {
        [self fastBetBtnClick];
    }else
    {
        CGSize size = self.tableView.contentSize;
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.view.layer renderInContext:context];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        YZPublishLotteryCircleViewController * publishCircleVC = [[YZPublishLotteryCircleViewController alloc] init];
        publishCircleVC.gameId = self.order.gameId;
        publishCircleVC.image = image;
        [self.navigationController pushViewController:publishCircleVC animated:YES];
    }
}

//快速投注
- (void)fastBetBtnClick
{
    [self loadUserInfo];
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
    NSDictionary * orderDic = @{@"money":self.order.amount,
                                @"game":self.gameId
                                };
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"order":orderDic,
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithURL:BaseUrlCoupon(@"/getConsumableList") params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (SUCCESS) {;
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
    chooseVoucherVC.gameId = self.gameId;
    chooseVoucherVC.amountMoney = [self.order.amount floatValue] / 100.0f;
    chooseVoucherVC.betCount = [self.order.count intValue];
    chooseVoucherVC.multiple = [self.order.multiple intValue];
    chooseVoucherVC.ticketList = self.ticketList;
    [self.navigationController pushViewController:chooseVoucherVC animated:YES];
}
- (void)showComfirmPayAlertView
{
    float amount = [self.order.amount floatValue] / 100.0f;
    BOOL hasEnoughMoney = [YZTool hasEnoughMoneyWithAmountMoney:amount];
    if (hasEnoughMoney) {
        NSString * message = [YZTool getAlertViewTextWithAmountMoney:amount];
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
//获取当前期次信息
- (void)getCurrentTermData
{
    [MBProgressHUD showMessage:text_gettingCurrentTerm toView:self.view];
    NSDictionary *dict = @{
                           @"cmd":@(8026),
                           @"gameId":self.order.gameId
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            NSArray *termList = json[@"game"][@"termList"];
            if(!termList.count)
            {
                [MBProgressHUD showError:text_sailStop];
                return;
            }
            self.currentTermId = [termList lastObject][@"termId"];
            if(!Jump)//不跳
            {
                [self comfirmPay];//支付
            }else //跳转网页
            {
                [MBProgressHUD hideHUDForView:self.view];
                NSNumber *multiple = self.order.multiple;//投多少倍
                NSNumber *amount = self.order.amount;
                NSNumber *termCount = @(1);//追期数
                NSMutableArray *ticketList = self.ticketList;
                NSString *ticketListJsonStr = [ticketList JSONRepresentation];
                YZLog(@"ticketListJsonStr = %@",ticketListJsonStr);
#if JG
                NSString * mcpStr = @"EZmcp";
#elif ZC
                NSString * mcpStr = @"ZCmcp";
#elif CS
                NSString * mcpStr = @"CSmcp";
#endif
                NSString *param = [NSString stringWithFormat:@"userId=%@&gameId=%@&termId=%@&multiple=%@&amount=%@&ticketList=%@&payType=%@&termCount=%@&startTermId=%@&id=%@&channel=%@&childChannel=%@&version=%@&remark=%@",UserId,self.gameId,self.currentTermId,multiple,amount,[ticketListJsonStr URLEncodedString],@"ACCOUNT",termCount,self.currentTermId,@"1407305392008",mainChannel,childChannel,[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],mcpStr];
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
- (void)comfirmPay//支付接口
{
    [MBProgressHUD showMessage:text_paying toView:self.view];
    
    NSDictionary *dict = @{
                           @"cmd":@(8052),
                           @"userId":UserId,
                           @"gameId":self.order.gameId,
                           @"termId":self.currentTermId,
                           @"multiple":self.order.multiple,
                           @"amount":self.order.amount,
                           @"ticketList":self.ticketList,
                           @"payType":@"ACCOUNT",
                           @"startTermId":self.currentTermId,
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            [MBProgressHUD hideHUDForView:self.view];
            YZBetSuccessViewController *betSuccessVc = [[YZBetSuccessViewController alloc] init];
            betSuccessVc.payVcType = BetTypeFastBet;
            betSuccessVc.termCount = 1;
            [self.navigationController pushViewController:betSuccessVc animated:YES];
        }else
        {
            [MBProgressHUD hideHUDForView:self.view];//隐藏正在支付的弹框
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"error = %@",error);
    }];
}
- (NSMutableArray *)ticketList
{
    if(_ticketList == nil)
    {
        _ticketList = [NSMutableArray array];
        NSArray *ticketListArray = self.order.ticketList;
        for(YZTicketList *ticketList in ticketListArray)
        {
            NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
            [muDict setValue:ticketList.numbers forKey:@"numbers"];
            [muDict setValue:ticketList.betType forKey:@"betType"];
            [muDict setValue:ticketList.playType forKey:@"playType"];
            [muDict setValue:ticketList.multiple forKey:@"multiple"];
            [muDict setValue:ticketList.amount forKey:@"amount"];
            
            [_ticketList addObject:muDict];
        }
    }
    return _ticketList;
}
#pragma mark - 初始化
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)orderInfoLabels
{
    if (_orderInfoLabels == nil) {
        _orderInfoLabels = [NSMutableArray array];
    }
    return _orderInfoLabels;
}
#pragma mark - 工具
- (NSInteger)getBlueBallCount:(NSString *)gameId
{
    NSInteger blueBallCount = 0;
    if([gameId isEqualToString:@"T01"])
    {
        blueBallCount = 2;
    }else if([gameId isEqualToString:@"F01"])
    {
        blueBallCount = 1;
    }else if([gameId isEqualToString:@"F03"])
    {
        blueBallCount = 1;
    }else
    {
        blueBallCount = 0;
    }
    return blueBallCount;
}
#pragma mark - 分享
- (void)share
{
    YZUser *user = [YZUserDefaultTool user];
    NSDictionary *dict = @{
                           @"gameId":self.order.gameId,
                           @"userName":user.userName
                           };
    waitingView;
    [[YZHttpTool shareInstance] postWithURL:BaseUrlShare(@"/getShareOrder") params:dict success:^(id json) {
        YZLog(@"getShareOrder:%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            YZShareView * shareView = [[YZShareView alloc]init];
            [shareView show];
            shareView.block = ^(UMSocialPlatformType platformType){//选择平台
                [self shareToPlatformType:platformType json:json];
            };
        }
    } failure:^(NSError *error)
    {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"error = %@",error);
    }];
}
- (void)shareToPlatformType:(UMSocialPlatformType)platformType json:(id)json
{
    NSString * title;
    NSString * descr;
    //是否中奖
    float bonus = [self.order.bonus intValue] / 100.0;
    float amount = [self.order.amount intValue] / 100.0;
    if(bonus > 0)
    {
        title = [NSString stringWithFormat:@"%@", json[@"hitTitle"]];
        descr = [[NSString stringWithFormat:@"%@", json[@"hitDesc"]] stringByReplacingOccurrencesOfString:@"hitmoney" withString:[NSString stringWithFormat:@"%.2f",bonus]];
    }else
    {
        title = [NSString stringWithFormat:@"%@", json[@"unHitTitle"]];
        descr = [[NSString stringWithFormat:@"%@", json[@"unHitDesc"]] stringByReplacingOccurrencesOfString:@"stakemoney" withString:[NSString stringWithFormat:@"%.2f",amount]];
    }
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
#if JG
    UIImage * image = [UIImage imageNamed:@"logo"];
#elif ZC
    UIImage * image = [UIImage imageNamed:@"logo1"];
#elif CS
    UIImage * image = [UIImage imageNamed:@"logo1"];
#endif
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:image];
    shareObject.webpageUrl = json[@"url"];
    messageObject.shareObject = shareObject;//调用分享接口
#if JG
    [WXApi registerApp:WXAppIdOld withDescription:@"九歌彩票"];
#elif ZC
    [WXApi registerApp:WXAppIdOld withDescription:@"中彩啦"];
#elif CS
    [WXApi registerApp:WXAppIdOld withDescription:@"财多多"];
#endif
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSInteger errorCode = error.code;
            if (errorCode == 2003) {
                [MBProgressHUD showError:@"分享失败"];
            }else if (errorCode == 2008)
            {
                [MBProgressHUD showError:@"应用未安装"];
            }else if (errorCode == 2010)
            {
                [MBProgressHUD showError:@"网络异常"];
            }
        }
    }];
}

@end
