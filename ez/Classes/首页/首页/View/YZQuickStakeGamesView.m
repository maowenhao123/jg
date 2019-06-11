//
//  YZQuickStakeGamesView.m
//  ez
//
//  Created by 毛文豪 on 2019/6/5.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZQuickStakeGamesView.h"
#import "YZLoginViewController.h"
#import "YZChooseVoucherViewController.h"
#import "YZRechargeListViewController.h"
#import "YZBetSuccessViewController.h"
#import "YZWinNumberBall.h"
#import "YZQuickStakeGameModel.h"
#import "NSDate+YZ.h"
#import "UIButton+YZ.h"
#import "NSObject+SBJSON.h"

@interface YZQuickStakeGamesView ()

@property (nonatomic, weak) UIView * recommendContentView;
@property (nonatomic, weak) UILabel *titleLabel;//标题
@property (nonatomic, strong) NSMutableArray *balls;
@property (nonatomic, strong) NSArray *ballStatuss;
@property (nonatomic, copy) NSString *currentTermId;

@end

@implementation YZQuickStakeGamesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZBackgroundColor;
        [self setupChilds];
    }
    return self;
}

#pragma mark - 布局试图
- (void)setupChilds
{
    //内容视图
    UIView * recommendContentView = [[UIView alloc] initWithFrame:CGRectMake(8, 15, screenWidth - 2 * 8, 100)];
    self.recommendContentView = recommendContentView;
    recommendContentView.backgroundColor = [UIColor whiteColor];
    recommendContentView.hidden = YES;
    recommendContentView.layer.masksToBounds = YES;
    recommendContentView.layer.cornerRadius = 5;
    recommendContentView.layer.borderColor = YZGrayLineColor.CGColor;
    recommendContentView.layer.borderWidth = 0.5;
    [self addSubview:recommendContentView];
    
    //标题
    UILabel * titleLabel = [[UILabel alloc] init];
    self.titleLabel = titleLabel;
    titleLabel.frame = CGRectMake(10, 15, recommendContentView.width - 2 * 7 - 50, titleLabel.font.lineHeight);
    [recommendContentView addSubview:titleLabel];
    
    //刷新
    UIButton * refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshButton.frame = CGRectMake(recommendContentView.width - 50 - 10, 12, 50, 25);
    [refreshButton setTitle:@"换一注" forState:UIControlStateNormal];
    [refreshButton setTitleColor:YZDrayGrayTextColor forState:UIControlStateNormal];
    refreshButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [refreshButton addTarget:self action:@selector(refreshButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [recommendContentView addSubview:refreshButton];
    
    //支付
    YZBottomButton * payButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    payButton.frame = CGRectMake(recommendContentView.width - 77 - 7, recommendContentView.height - 26 - 15, 77, 26);
    [payButton setTitle:@"投注2元" forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [payButton addTarget:self action:@selector(payButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [recommendContentView addSubview:payButton];
    
    //选号球
    CGFloat ballH = recommendContentView.height - 13 - CGRectGetMaxY(titleLabel.frame) - 10;
    CGFloat ballW = (payButton.x - 7 - 10 - 6 * 8) / 7;
    CGFloat ballWH = MIN(ballH, ballW);
    CGFloat ballPadding = (payButton.x - 7 - 10 - 7 * ballWH) / 6;
    CGFloat ballY = recommendContentView.height - 13 - ballWH;
    for (int i = 0; i < 7; i++) {
        YZWinNumberBall * ball = [[YZWinNumberBall alloc]init];
        ball.frame = CGRectMake(7 + (ballWH + ballPadding) * i, ballY, ballWH, ballWH);
        [recommendContentView addSubview:ball];
        [self.balls addObject:ball];
    }
    
    [self refreshButtonDidClick];
}

- (void)refreshButtonDidClick
{
    if ([self.gameModel.id isEqualToString:@"T01"]) {//大乐透
        [self getDltBallStatus];
    }else if ([self.gameModel.id isEqualToString:@"F01"])//双色球
    {
        [self getSsqBallStatus];
    }else if ([self.gameModel.id isEqualToString:@"T02"])//七星彩
    {
        [self getQxcBallStatus];
    }else if ([self.gameModel.id isEqualToString:@"T03"])//排列三
    {
        [self getPlsBallStatus];
    }else if ([self.gameModel.id isEqualToString:@"T04"])//排列五
    {
        [self getPlwBallStatus];
    }else if ([self.gameModel.id isEqualToString:@"F03"])//七乐彩
    {
        [self getQlcBallStatus];
    }else if ([self.gameModel.id isEqualToString:@"F02"])//福彩3D
    {
        [self getFcBallStatus];
    }
}

#pragma mark - 设置数据
- (void)setGameModel:(YZQuickStakeGameModel *)gameModel
{
    _gameModel = gameModel;
    
    if (YZObjectIsEmpty(_gameModel)) {
        self.recommendContentView.hidden = YES;
        return;
    }
    self.recommendContentView.hidden = NO;
    NSDictionary * gameIdNameDict = [YZTool gameIdNameDict];
    NSString * gameNameStr = [NSString stringWithFormat:@"[%@]", gameIdNameDict[_gameModel.id]];
    NSString * desc = _gameModel.desc;
    NSMutableAttributedString * titleAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", gameNameStr, desc]];
    NSRange gameNameRange = [titleAttStr.string rangeOfString:gameNameStr];
    [titleAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:gameNameRange];
    [titleAttStr addAttribute:NSForegroundColorAttributeName value:YZDrayGrayTextColor range:NSMakeRange(gameNameRange.length, titleAttStr.length - gameNameRange.length)];
    [titleAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(30)] range:gameNameRange];
    [titleAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(gameNameRange.length, titleAttStr.length - gameNameRange.length)];
    self.titleLabel.attributedText = titleAttStr;
    
    [self refreshButtonDidClick];
}

- (void)getDltBallStatus
{
    //红球
    NSMutableSet *redSet = [NSMutableSet set];
    while (redSet.count < 5) {//红球至少5个
        int random = arc4random() % 35 + 1;
        [redSet addObject:@(random)];
    }
    NSMutableArray * array1 = [NSMutableArray array];
    for (NSNumber * number in redSet) {
        YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
        ballStatus.number = [NSString stringWithFormat:@"%02d",[number intValue]];
        ballStatus.type = 1;
        ballStatus.isRecommendLottery = YES;
        [array1 addObject:ballStatus];
    }
    //对红球数组排序
    NSMutableArray *sortArray1 = [self sortBallsArray:array1];
    //蓝球
    NSMutableSet *blueSet = [NSMutableSet set];
    while (blueSet.count < 2) {
        int random = arc4random() % 12 + 1;
        [blueSet addObject:@(random)];
    }
    NSMutableArray * array2 = [NSMutableArray array];
    for (NSNumber * number in blueSet) {
        YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
        ballStatus.number = [NSString stringWithFormat:@"%02d",[number intValue]];
        ballStatus.type = 2;
        ballStatus.isRecommendLottery = YES;
        [array2 addObject:ballStatus];
    }
    //对蓝球数组排序
    NSMutableArray *sortArray2 = [self sortBallsArray:array2];
    //合并数组
    NSMutableArray * array = [NSMutableArray arrayWithArray:sortArray1];
    [array addObjectsFromArray:sortArray2];
    self.ballStatuss = array;
    
    [self setBallStatus];
}

- (void)getSsqBallStatus
{
    //红球
    NSMutableSet *redSet = [NSMutableSet set];
    while (redSet.count < 6) {//红球至少6个
        int random = arc4random() % 33 + 1;
        [redSet addObject:@(random)];
    }
    NSMutableArray * array1 = [NSMutableArray array];
    for (NSNumber * number in redSet) {
        YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
        ballStatus.number = [NSString stringWithFormat:@"%02d",[number intValue]];
        ballStatus.type = 1;
        ballStatus.isRecommendLottery = YES;
        [array1 addObject:ballStatus];
    }
    //对红球数组排序
    NSMutableArray *sortArray1 = [self sortBallsArray:array1];
    //蓝球
    NSMutableSet *blueSet = [NSMutableSet set];
    while (blueSet.count < 1) {
        int random = arc4random() % 16 + 1;
        [blueSet addObject:@(random)];
    }
    NSMutableArray * array2 = [NSMutableArray array];
    for (NSNumber * number in blueSet) {
        YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
        ballStatus.number = [NSString stringWithFormat:@"%02d",[number intValue]];
        ballStatus.type = 2;
        ballStatus.isRecommendLottery = YES;
        [array2 addObject:ballStatus];
    }
    //对蓝球数组排序
    NSMutableArray *sortArray2 = [self sortBallsArray:array2];
    //合并数组
    NSMutableArray * array = [NSMutableArray arrayWithArray:sortArray1];
    [array addObjectsFromArray:sortArray2];
    self.ballStatuss = array;
    
    [self setBallStatus];
}

- (void)getQxcBallStatus
{
    //红球
    NSMutableArray *redArray = [NSMutableArray array];
    while (redArray.count < 7) {//红球至少7个
        int random = arc4random() % 9;
        [redArray addObject:@(random)];
    }
    NSMutableArray * array1 = [NSMutableArray array];
    for (NSNumber * number in redArray) {
        YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
        ballStatus.number = [NSString stringWithFormat:@"%d",[number intValue]];
        ballStatus.type = 1;
        ballStatus.isRecommendLottery = YES;
        [array1 addObject:ballStatus];
    }
    //蓝球
    NSMutableArray *array2 = [NSMutableArray array];
    //合并数组
    NSMutableArray * array = [NSMutableArray arrayWithArray:array1];
    [array addObjectsFromArray:array2];
    self.ballStatuss = array;
    
    [self setBallStatus];
}

- (void)getPlsBallStatus
{
    //红球
    NSMutableArray *redArray = [NSMutableArray array];
    while (redArray.count < 3) {//红球至少3个
        int random = arc4random() % 9;
        [redArray addObject:@(random)];
    }
    NSMutableArray * array1 = [NSMutableArray array];
    for (NSNumber * number in redArray) {
        YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
        ballStatus.number = [NSString stringWithFormat:@"%d",[number intValue]];
        ballStatus.type = 1;
        ballStatus.isRecommendLottery = YES;
        [array1 addObject:ballStatus];
    }
    //蓝球
    NSMutableArray *array2 = [NSMutableArray array];
    //合并数组
    NSMutableArray * array = [NSMutableArray arrayWithArray:array1];
    [array addObjectsFromArray:array2];
    self.ballStatuss = array;
    
    [self setBallStatus];
}

- (void)getPlwBallStatus
{
    //红球
    NSMutableArray *redArray = [NSMutableArray array];
    while (redArray.count < 5) {//红球至少5个
        int random = arc4random() % 9;
        [redArray addObject:@(random)];
    }
    NSMutableArray * array1 = [NSMutableArray array];
    for (NSNumber * number in redArray) {
        YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
        ballStatus.number = [NSString stringWithFormat:@"%d",[number intValue]];
        ballStatus.type = 1;
        ballStatus.isRecommendLottery = YES;
        [array1 addObject:ballStatus];
    }
    //蓝球
    NSMutableArray *array2 = [NSMutableArray array];
    //合并数组
    NSMutableArray * array = [NSMutableArray arrayWithArray:array1];
    [array addObjectsFromArray:array2];
    self.ballStatuss = array;
    
    [self setBallStatus];
}

- (void)getFcBallStatus
{
    //红球
    NSMutableArray *redArray = [NSMutableArray array];
    while (redArray.count < 3) {//红球至少3个
        int random = arc4random() % 9;
        [redArray addObject:@(random)];
    }
    NSMutableArray * array1 = [NSMutableArray array];
    for (NSNumber * number in redArray) {
        YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
        ballStatus.number = [NSString stringWithFormat:@"%d",[number intValue]];
        ballStatus.type = 1;
        ballStatus.isRecommendLottery = YES;
        [array1 addObject:ballStatus];
    }
    //蓝球
    NSMutableArray *array2 = [NSMutableArray array];
    //合并数组
    NSMutableArray * array = [NSMutableArray arrayWithArray:array1];
    [array addObjectsFromArray:array2];
    self.ballStatuss = array;
    
    [self setBallStatus];
}

- (void)getQlcBallStatus
{
    //红球
    NSMutableSet *redSet = [NSMutableSet set];
    while (redSet.count < 7) {//红球至少7个
        int random = arc4random() % 30 + 1;
        [redSet addObject:@(random)];
    }
    NSMutableArray * array1 = [NSMutableArray array];
    for (NSNumber * number in redSet) {
        YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
        ballStatus.number = [NSString stringWithFormat:@"%02d",[number intValue]];
        ballStatus.type = 1;
        ballStatus.isRecommendLottery = YES;
        [array1 addObject:ballStatus];
    }
    //对红球数组排序
    NSMutableArray *sortArray1 = [self sortBallsArray:array1];
    //蓝球
    NSMutableArray *array2 = [NSMutableArray array];
    //合并数组
    NSMutableArray * array = [NSMutableArray arrayWithArray:sortArray1];
    [array addObjectsFromArray:array2];
    self.ballStatuss = array;
    
    [self setBallStatus];
}

- (void)setBallStatus
{
    for (YZWinNumberBall * ball in self.balls) {
        ball.hidden = YES;
    }
    
    for (YZWinNumberBallStatus * ballStatus in self.ballStatuss) {
        NSInteger index = [self.ballStatuss indexOfObject:ballStatus];
        YZWinNumberBall * ball = self.balls[index];
        ball.hidden = NO;
        ball.status = ballStatus;
    }
}

#pragma mark - 支付
- (void)payButtonDidClick
{
    if (!UserId)
    {
        YZLoginViewController *loginVc = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:loginVc];
        [self.viewController presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    NSDictionary *dict = @{
                           @"cmd":@(8006),
                           @"userId":UserId
                           };
    [MBProgressHUD showMessage:@"客官请稍后" toView:self.viewController.tabBarController.view];
    [[YZHttpTool shareInstance] requestTarget:self.viewController PostWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
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
        YZLog(@"账户error");
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
    }];
}
- (void)getConsumableList
{
    NSDictionary * orderDic = @{
                                @"money":@(200),
                                @"game":self.gameModel.id
                                };
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"order":orderDic,
                           };
    [MBProgressHUD showMessage:@"客官请稍后" toView:self.viewController.tabBarController.view];
    [[YZHttpTool shareInstance] requestTarget:self.viewController PostWithURL:BaseUrlCoupon(@"/getConsumableList") params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
        if (SUCCESS) {;
            NSArray * respCouponList = json[@"respCouponList"];
            if (respCouponList.count == 0) {//没有彩券直接购买
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
         [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
     }];
}
- (void)gotoChooseVoucherVC
{
    //选择彩券
    YZChooseVoucherViewController * chooseVoucherVC = [[YZChooseVoucherViewController alloc]init];
    chooseVoucherVC.gameId = self.gameModel.id;
    chooseVoucherVC.amountMoney = 2;
    chooseVoucherVC.betCount = 1;
    chooseVoucherVC.multiple = 1;
    chooseVoucherVC.ticketList = [self getTicketList];
    [self.viewController.navigationController pushViewController:chooseVoucherVC animated:YES];
}
- (void)showComfirmPayAlertView
{
    BOOL hasEnoughMoney = [YZTool hasEnoughMoneyWithAmountMoney:2];
    if (hasEnoughMoney) {
        NSString * message = [YZTool getAlertViewTextWithAmountMoney:2];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"支付确认" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getCurrentTermData];//当前期次的信息
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
    }else
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"余额不足" message:@"对不起，余额不足，请充值。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gotoRecharge];
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self.viewController presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)gotoRecharge
{
    YZRechargeListViewController *rechargeVc = [[YZRechargeListViewController alloc] init];
    [self.viewController.navigationController pushViewController:rechargeVc animated:YES];
}
//获取当前期信息
- (void)getCurrentTermData
{
    NSDictionary *dict = @{
                           @"cmd":@(8026),
                           @"gameId":self.gameModel.id
                           };
    [MBProgressHUD showMessage:text_gettingCurrentTerm toView:self.viewController.tabBarController.view];
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
        if(SUCCESS)
        {
            NSArray *termList = json[@"game"][@"termList"];
            if(!termList.count)
            {
                [MBProgressHUD showError:text_sailStop];
                return;
            }
            self.currentTermId = [termList lastObject][@"termId"];
            [self isJump:Jump];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        YZLog(@"getCurrentTermData - error = %@",error);
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
    }];
}
- (void)isJump:(BOOL)jump
{
    if(!jump)//不跳
    {
        [self comfirmPay];//支付
    }else //跳转网页
    {
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
        
        NSNumber *multiple = @(1);//投多少倍
        NSNumber *amount = @(200);
        NSNumber *termCount = @(1);//追期数
        NSMutableArray *ticketList = [self getTicketList];
        NSString *ticketListJsonStr = [ticketList JSONRepresentation];
        YZLog(@"ticketListJsonStr = %@",ticketListJsonStr);
#if JG
        NSString * mcpStr = @"EZmcp";
#elif ZC
        NSString * mcpStr = @"ZCmcp";
#elif CS
        NSString * mcpStr = @"CSmcp";
#endif
        NSString *param = [NSString stringWithFormat:@"userId=%@&gameId=%@&termId=%@&multiple=%@&amount=%@&ticketList=%@&payType=%@&termCount=%@&startTermId=%@&winStop=%@&id=%@&channel=%@&childChannel=%@&version=%@&remark=%@",UserId,@"F01",self.currentTermId,multiple,amount,[ticketListJsonStr URLEncodedString],@"ACCOUNT",termCount,self.currentTermId,@false,@"1407305392008",mainChannel,childChannel,[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],mcpStr];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",jumpURLStr,param]];
        [[UIApplication sharedApplication] openURL:url];
    }
}
#pragma  mark - 确认支付
- (void)comfirmPay//支付接口
{
    NSNumber *multiple = @(1);//投多少倍
    NSNumber *amount = @(200);
    NSMutableArray *ticketList = [self getTicketList];
    NSDictionary * dict = @{
                            @"cmd":@(8052),
                            @"userId":UserId,
                            @"gameId":self.gameModel.id,
                            @"termId":self.currentTermId,
                            @"multiple":multiple,
                            @"amount":amount,
                            @"ticketList":ticketList,
                            @"payType":@"ACCOUNT",
                            @"startTermId":self.currentTermId,
                            };
    [MBProgressHUD showMessage:text_paying toView:self.viewController.tabBarController.view];
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
        if(SUCCESS)
        {
            YZBetSuccessViewController *betSuccessVc = [[YZBetSuccessViewController alloc] init];
            betSuccessVc.termCount = 1;
            //跳转
            [self.viewController.navigationController pushViewController:betSuccessVc animated:YES];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        YZLog(@"error = %@",error);
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
    }];
}
- (NSMutableArray *)getTicketList
{
    NSMutableArray * ticketList = [NSMutableArray array];
    NSMutableString * redNumbers = [NSMutableString string];
    NSMutableString * blueNumbers = [NSMutableString string];
    for(YZWinNumberBallStatus * ballStatus in self.ballStatuss)
    {
        if (ballStatus.type == 1) {
            if ([self.gameModel.id isEqualToString:@"T02"] || [self.gameModel.id isEqualToString:@"T03"] || [self.gameModel.id isEqualToString:@"T04"] || [self.gameModel.id isEqualToString:@"F02"]) {
                [redNumbers appendString:[NSString stringWithFormat:@"|%@",ballStatus.number]];
            }else
            {
                [redNumbers appendString:[NSString stringWithFormat:@",%@",ballStatus.number]];
            }
        }else if (ballStatus.type == 2)
        {
            [blueNumbers appendString:[NSString stringWithFormat:@",%@",ballStatus.number]];
        }
    }
    if (!YZStringIsEmpty(redNumbers)) {
        [redNumbers deleteCharactersInRange:NSMakeRange(0, 1)];//删除第一个一个逗号
    }
    if (!YZStringIsEmpty(blueNumbers)) {
        [blueNumbers deleteCharactersInRange:NSMakeRange(0, 1)];//删除第一个一个逗号
    }
    NSMutableString *numbers = [NSMutableString stringWithFormat:@"%@", redNumbers];
    if (!YZStringIsEmpty(blueNumbers)) {
        [numbers appendFormat:@"|%@", blueNumbers];
    }
    NSDictionary *dict = [NSDictionary dictionary];
    if ([self.gameModel.id isEqualToString:@"T03"] || [self.gameModel.id isEqualToString:@"F02"]) {
        dict = @{
                 @"numbers":numbers,
                 @"betType":@"00",
                 @"playType":@"01"
                 };
    }else
    {
        dict = @{
                 @"numbers":numbers,
                 @"betType":@"00",
                 @"playType":@"00"
                 };
    }
    [ticketList addObject:dict];
    return ticketList;
}
#pragma mark - 工具
- (int)getRandomRedBallNumber
{
    return arc4random() % 33 + 1;
}
- (int)getRandomBlueBallNumber
{
    return arc4random() % 16 + 1;
}

//冒泡排序球数组
- (NSMutableArray *)sortBallsArray:(NSMutableArray *)mutableArray
{
    if(mutableArray.count == 1) return mutableArray;
    for(int i = 0;i < mutableArray.count;i++)
    {
        for(int j = i + 1;j <mutableArray.count;j++)
        {
            YZWinNumberBallStatus * ballStatus1 = mutableArray[i];
            YZWinNumberBallStatus * ballStatus2 = mutableArray[j];
            int number1 = [ballStatus1.number intValue];
            int number2 = [ballStatus2.number intValue];
            if(number1 > number2)
            {
                [mutableArray replaceObjectAtIndex:i withObject:ballStatus2];
                [mutableArray replaceObjectAtIndex:j withObject:ballStatus1];
            }
        }
    }
    return mutableArray;
}

#pragma mark - 初始化
- (NSMutableArray *)balls
{
    if (_balls == nil) {
        _balls = [NSMutableArray array];
    }
    return _balls;
}


@end
