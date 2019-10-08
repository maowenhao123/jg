//
//  YZTabBarViewController.m
//  ez
//
//  Created by apple on 14-8-6.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <UserNotifications/UserNotifications.h>
#import "YZTabBarViewController.h"
#import "YZHomePageViewController.h"
#import "YZOrderViewController.h"
#import "YZUnionBuyViewController.h"
#import "YZWinNumberViewController.h"
#import "YZMineViewController.h"
#import "YZZCMineViewController.h"
#import "YZCSMineViewController.h"
#import "YZRRMineViewController.h"
#import "YZLoginViewController.h"
#import "YZNavigationController.h"
#import "YZUpGradeView.h"
#import "YZVoucherGuideView.h"
#import "YZGiveVoucherView.h"
#import "YZDateTool.h"

@interface YZTabBarViewController ()<UITabBarControllerDelegate, HChatDelegate>

@end

@implementation YZTabBarViewController

+ (void)initialize
{
    UITabBar * tabBar = [UITabBar appearance];
    // 设置背景
    [tabBar setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:CGRectMake(0, 0, screenWidth, tabBarH)]];
    tabBar.tintColor = YZColor(224, 3, 12, 1);
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:YZGetFontSize(20)];
    [[UITabBarItem appearance] setTitleTextAttributes:textAttrs
                                             forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupTabbars];
    
    //检查升级
    [self checkUpgrade];
    
    //接收注册成功返回购彩大厅的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toBuyLottey) name:@"ToBuyLottery" object:nil];
    //接收投注成功后查看投注记录的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toRecord:) name:RefreshRecordNote object:nil];
    //接收去个人中心的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toMine) name:@"ToMine" object:nil];
    //接收去个人中心的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toMine) name:HtmlRechargeSuccessNote object:nil];
    //活动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGuide) name:loginSuccessNote object:nil];
    //获取赠送彩劵
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getGiveVoucherData) name:loginSuccessNote object:nil];

    //添加消息监控，第二个参数是执行代理方法的队列，默认是主队列
    [[HChatClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

- (void)setupTabbars
{
#if JG
    // 1.购彩
    YZHomePageViewController *homePageVC = [[YZHomePageViewController alloc] init];
    UITabBarItem * tabberItem1 = [self getTabberByImage:[UIImage imageNamed:@"tabbar_buyLottery"] selectedImage:[UIImage imageNamed:@"tabbar_buyLottery_selected"] title:@"购彩"];
    homePageVC.tabBarItem = tabberItem1;
    YZNavigationController *buyLottery_nav = [[YZNavigationController alloc]initWithRootViewController:homePageVC];
    buyLottery_nav.view.tag = 1;
    
    // 2.订单
    YZOrderViewController *orderVC = [[YZOrderViewController alloc] init];
    UITabBarItem * tabberItem2 = [self getTabberByImage:[UIImage imageNamed:@"tabber_order"] selectedImage:[UIImage imageNamed:@"tabber_order_selected"] title:@"订单"];
    orderVC.tabBarItem = tabberItem2;
    YZNavigationController *orderyVC_nav = [[YZNavigationController alloc]initWithRootViewController:orderVC];
    orderyVC_nav.view.tag = 2;
    
    // 3.合买
    YZUnionBuyViewController *unionBuyVC = [[YZUnionBuyViewController alloc] init];
    UITabBarItem * tabberItem3 = [self getTabberByImage:[UIImage imageNamed:@"tabber_unionBuy"] selectedImage:[UIImage imageNamed:@"tabber_unionBuy_selected"] title:@"合买"];
    unionBuyVC.tabBarItem = tabberItem3;
    YZNavigationController *unionBuyVC_nav = [[YZNavigationController alloc]initWithRootViewController:unionBuyVC];
    unionBuyVC_nav.view.tag = 3;
    
    // 4.开奖
    YZWinNumberViewController *winNumberVC = [[YZWinNumberViewController alloc] init];
    UITabBarItem * tabberItem4 = [self getTabberByImage:[UIImage imageNamed:@"tabbar_winNumber"] selectedImage:[UIImage imageNamed:@"tabbar_winNumber_selected"] title:@"开奖"];
    winNumberVC.tabBarItem = tabberItem4;
    YZNavigationController *winNumberVC_nav = [[YZNavigationController alloc]initWithRootViewController:winNumberVC];
    winNumberVC_nav.view.tag = 4;
    
    // 5.我的
    YZMineViewController *mineVC = [[YZMineViewController alloc] init];
    UITabBarItem * tabberItem5 = [self getTabberByImage:[UIImage imageNamed:@"tabbar_mine"] selectedImage:[UIImage imageNamed:@"tabbar_mine_selected"] title:@"我的"];
    mineVC.tabBarItem = tabberItem5;
    YZNavigationController *mineVC_nav = [[YZNavigationController alloc]initWithRootViewController:mineVC];
    mineVC_nav.view.tag = 5;
    
    self.viewControllers = @[buyLottery_nav,orderyVC_nav,unionBuyVC_nav,winNumberVC_nav,mineVC_nav];
    
#elif ZC
    // 1.购彩
    YZHomePageViewController *homePageVC = [[YZHomePageViewController alloc] init];
    UITabBarItem * tabberItem1 = [self getTabberByImage:[UIImage imageNamed:@"tabbar_buyLottery_zc"] selectedImage:[UIImage imageNamed:@"tabbar_buyLottery_selected_zc"] title:@"购彩"];
    homePageVC.tabBarItem = tabberItem1;
    YZNavigationController *buyLottery_nav = [[YZNavigationController alloc]initWithRootViewController:homePageVC];
    buyLottery_nav.view.tag = 1;
    
    // 2.订单
    YZOrderViewController *orderVC = [[YZOrderViewController alloc] init];
    UITabBarItem * tabberItem2 = [self getTabberByImage:[UIImage imageNamed:@"tabber_order_zc"] selectedImage:[UIImage imageNamed:@"tabber_order_selected_zc"] title:@"订单"];
    orderVC.tabBarItem = tabberItem2;
    YZNavigationController *orderyVC_nav = [[YZNavigationController alloc]initWithRootViewController:orderVC];
    orderyVC_nav.view.tag = 2;
    
    // 3.合买
    YZUnionBuyViewController *unionBuyVC = [[YZUnionBuyViewController alloc] init];
    UITabBarItem * tabberItem3 = [self getTabberByImage:[UIImage imageNamed:@"tabber_unionBuy_zc"] selectedImage:[UIImage imageNamed:@"tabber_unionBuy_selected_zc"] title:@"合买"];
    unionBuyVC.tabBarItem = tabberItem3;
    YZNavigationController *unionBuyVC_nav = [[YZNavigationController alloc]initWithRootViewController:unionBuyVC];
    unionBuyVC_nav.view.tag = 3;
    
    // 4.开奖
    YZWinNumberViewController *winNumberVC = [[YZWinNumberViewController alloc] init];
    UITabBarItem * tabberItem4 = [self getTabberByImage:[UIImage imageNamed:@"tabbar_winNumber_zc"] selectedImage:[UIImage imageNamed:@"tabbar_winNumber_selected_zc"] title:@"开奖"];
    winNumberVC.tabBarItem = tabberItem4;
    YZNavigationController *winNumberVC_nav = [[YZNavigationController alloc]initWithRootViewController:winNumberVC];
    winNumberVC_nav.view.tag = 4;
    
    // 5.我的
    YZZCMineViewController *mineVC = [[YZZCMineViewController alloc] init];
    UITabBarItem * tabberItem5 = [self getTabberByImage:[UIImage imageNamed:@"tabbar_mine_zc"] selectedImage:[UIImage imageNamed:@"tabbar_mine_selected_zc"] title:@"我的"];
    mineVC.tabBarItem = tabberItem5;
    YZNavigationController *mineVC_nav = [[YZNavigationController alloc]initWithRootViewController:mineVC];
    mineVC_nav.view.tag = 5;
    
    self.viewControllers = @[buyLottery_nav, orderyVC_nav, unionBuyVC_nav, winNumberVC_nav, mineVC_nav];
#elif CS
    // 1.购彩
    YZHomePageViewController *homePageVC = [[YZHomePageViewController alloc] init];
    UITabBarItem * tabberItem1 = [self getTabberByImage:[UIImage imageNamed:@"tabbar_buyLottery_zc"] selectedImage:[UIImage imageNamed:@"tabbar_buyLottery_selected_zc"] title:@"购彩"];
    homePageVC.tabBarItem = tabberItem1;
    YZNavigationController *buyLottery_nav = [[YZNavigationController alloc]initWithRootViewController:homePageVC];
    buyLottery_nav.view.tag = 1;
    
    // 2.订单
    YZOrderViewController *orderVC = [[YZOrderViewController alloc] init];
    UITabBarItem * tabberItem2 = [self getTabberByImage:[UIImage imageNamed:@"tabber_order"] selectedImage:[UIImage imageNamed:@"tabber_order_selected"] title:@"订单"];
    orderVC.tabBarItem = tabberItem2;
    YZNavigationController *orderyVC_nav = [[YZNavigationController alloc]initWithRootViewController:orderVC];
    orderyVC_nav.view.tag = 2;
    
    // 3.合买
    YZUnionBuyViewController *unionBuyVC = [[YZUnionBuyViewController alloc] init];
    UITabBarItem * tabberItem3 = [self getTabberByImage:[UIImage imageNamed:@"tabber_unionBuy_zc"] selectedImage:[UIImage imageNamed:@"tabber_unionBuy_selected_zc"] title:@"合买"];
    unionBuyVC.tabBarItem = tabberItem3;
    YZNavigationController *unionBuyVC_nav = [[YZNavigationController alloc]initWithRootViewController:unionBuyVC];
    unionBuyVC_nav.view.tag = 3;
    
    // 4.开奖
    YZWinNumberViewController *winNumberVC = [[YZWinNumberViewController alloc] init];
    UITabBarItem * tabberItem4 = [self getTabberByImage:[UIImage imageNamed:@"tabbar_winNumber_zc"] selectedImage:[UIImage imageNamed:@"tabbar_winNumber_selected_zc"] title:@"开奖"];
    winNumberVC.tabBarItem = tabberItem4;
    YZNavigationController *winNumberVC_nav = [[YZNavigationController alloc]initWithRootViewController:winNumberVC];
    winNumberVC_nav.view.tag = 4;
    
    // 5.我的
    YZCSMineViewController *mineVC = [[YZCSMineViewController alloc] init];
    UITabBarItem * tabberItem5 = [self getTabberByImage:[UIImage imageNamed:@"tabbar_mine_zc"] selectedImage:[UIImage imageNamed:@"tabbar_mine_selected_zc"] title:@"我的"];
    mineVC.tabBarItem = tabberItem5;
    YZNavigationController *mineVC_nav = [[YZNavigationController alloc]initWithRootViewController:mineVC];
    mineVC_nav.view.tag = 5;
    
    self.viewControllers = @[buyLottery_nav, orderyVC_nav, unionBuyVC_nav, winNumberVC_nav, mineVC_nav];
#elif RR
    // 1.购彩
    YZHomePageViewController *homePageVC = [[YZHomePageViewController alloc] init];
    UITabBarItem * tabberItem1 = [self getTabberByImage:[UIImage imageNamed:@"tabbar_buyLottery_rr"] selectedImage:[UIImage imageNamed:@"tabbar_buyLottery_selected_rr"] title:@"购彩"];
    homePageVC.tabBarItem = tabberItem1;
    YZNavigationController *buyLottery_nav = [[YZNavigationController alloc]initWithRootViewController:homePageVC];
    buyLottery_nav.view.tag = 1;
    
    // 2.订单
    YZOrderViewController *orderVC = [[YZOrderViewController alloc] init];
    UITabBarItem * tabberItem2 = [self getTabberByImage:[UIImage imageNamed:@"tabber_order_rr"] selectedImage:[UIImage imageNamed:@"tabber_order_selected_rr"] title:@"订单"];
    orderVC.tabBarItem = tabberItem2;
    YZNavigationController *orderyVC_nav = [[YZNavigationController alloc]initWithRootViewController:orderVC];
    orderyVC_nav.view.tag = 2;
    
    // 4.开奖
    YZWinNumberViewController *winNumberVC = [[YZWinNumberViewController alloc] init];
    UITabBarItem * tabberItem4 = [self getTabberByImage:[UIImage imageNamed:@"tabbar_winNumber_rr"] selectedImage:[UIImage imageNamed:@"tabbar_winNumber_selected_rr"] title:@"开奖"];
    winNumberVC.tabBarItem = tabberItem4;
    YZNavigationController *winNumberVC_nav = [[YZNavigationController alloc]initWithRootViewController:winNumberVC];
    winNumberVC_nav.view.tag = 4;
    
    // 5.我的
    YZRRMineViewController *mineVC = [[YZRRMineViewController alloc] init];
    UITabBarItem * tabberItem5 = [self getTabberByImage:[UIImage imageNamed:@"tabbar_mine_rr"] selectedImage:[UIImage imageNamed:@"tabbar_mine_selected_rr"] title:@"我的"];
    mineVC.tabBarItem = tabberItem5;
    YZNavigationController *mineVC_nav = [[YZNavigationController alloc]initWithRootViewController:mineVC];
    mineVC_nav.view.tag = 5;
    
    self.viewControllers = @[buyLottery_nav, orderyVC_nav, winNumberVC_nav, mineVC_nav];
#endif
    self.delegate = self;
}
//去购彩大厅
- (void)toBuyLottey
{
    self.selectedIndex = 0;
}
//去订单
- (void)toRecord:(NSNotification *)note
{
    if (!UserId) {
        YZLoginViewController *login = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
    }else
    {
        self.selectedIndex = 1;
    }
}
//去个人中心
- (void)toMine
{
    if (!UserId) {
        YZLoginViewController *login = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
    }
#if JG
    self.selectedIndex = 4;
#elif ZC
    self.selectedIndex = 4;
#elif CS
    self.selectedIndex = 4;
#elif RR
    self.selectedIndex = 3;
#endif
}

- (UITabBarItem *)getTabberByImage:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title
{
    UITabBarItem * tabberItem = [[UITabBarItem alloc]init];
    tabberItem.title = title;
    tabberItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabberItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return tabberItem;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    //点击账户按钮和没有登录，modal登录界面
    if((viewController.view.tag == 2 || viewController.view.tag == 3 || viewController.view.tag == 5) && !UserId)
    {
        YZLoginViewController *login = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
        return NO;
    }
    
    return YES;
}

#pragma mark - 收到普通消息
- (void)messagesDidReceive:(NSArray *)aMessages
{
    id<HDIMessageModel> messageModel  = aMessages.firstObject;
    NSDictionary *objectDic = @{
                                @"message":messageModel
                                };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"haveNewMessageNote" object:objectDic];
    
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        [self showNotificationWithMessage:aMessages];
    }else {
        [self playSoundAndVibration];
    }
}

- (void)showNotificationWithMessage:(NSArray *)messages
{
    HPushOptions *options = [[HChatClient sharedClient] hPushOptions];

    NSString *messageStr = nil;
    id<HDIMessageModel> messageModel  = messages.firstObject;
    if (options.displayStyle == HPushDisplayStyleMessageSummary) {
        switch (messageModel.body.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageModel.body).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = @"[图片]";
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = @"[位置]";
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = @"[音频]";
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = @"[视频]";
            }
                break;
            default:
                break;
        }
    }
    else
    {
        messageStr = @"您有一条新消息";
    }

    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.sound = [UNNotificationSound defaultSound];
        content.body = messageStr;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:messageModel.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }else
    {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.alertBody = messageStr;
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

//private
- (void)playSoundAndVibration
{
    // 收到视频请求消息时，播放音频
    [[HDCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[HDCDDeviceManager sharedInstance] playVibration];
}

#pragma mark - 检查升级
- (void)checkUpgrade
{
    NSString * imei = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary *dict = @{
                           @"cmd":@(8000),
                           @"imei":imei
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        //检查账号密码返回数据
        YZLog(@"%@", json);
        if(SUCCESS)
        {
            if ([json[@"shouldUpgrade"] boolValue]) {
                YZUpGradeView * upGradeView = [[YZUpGradeView alloc] initWithFrame:self.view.bounds json:json];
                [self.view addSubview:upGradeView];
            }
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"自动登录error");
    }];
}

#pragma mark - 活动
- (void)getGuide
{
    if (!UserId) return;
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"version":@"0.0.2"
                           };
#if RR
    dict = @{
             @"userId":UserId,
             @"version":@"0.0.1"
             };
#endif
    [[YZHttpTool shareInstance] postWithURL:BaseUrlShare(@"/getGuide") params:dict success:^(id json) {
        YZLog(@"getGuide:%@",json);
        if (SUCCESS) {
            if (json[@"guide"]) {
                YZGuideModel * guideModel = [YZGuideModel objectWithKeyValues:json[@"guide"]];
                if (guideModel) {//
                    YZVoucherGuideView * voucherGuideView = [[YZVoucherGuideView  alloc] initWithFrame:self.view.bounds guideModel:guideModel];
                    voucherGuideView.owerViewController = self.selectedViewController;
                    [self.view addSubview:voucherGuideView];
                }
            }
        }
    } failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
    }];
}

#pragma mark - 赠送彩票
- (void)getGiveVoucherData
{
    if (!UserId) return;
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"timestamp":[YZDateTool getNowTimeTimestamp],
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrl(@"promotion/couponRedPackageList") params:dict success:^(id json) {
        YZLog(@"couponRedpackageList:%@",json);
        if (SUCCESS) {
            YZGiveVoucherModel * giveVoucherModel = [YZGiveVoucherModel objectWithKeyValues:json];
            NSArray * couponRedpackageList = [CouponRedPackage objectArrayWithKeyValuesArray:json[@"couponRedpackageList"]];
            giveVoucherModel.couponRedpackageList = couponRedpackageList;
            if (giveVoucherModel.couponRedpackageList.count > 0) {
                YZGiveVoucherView * giveVoucherView = [[YZGiveVoucherView alloc] initWithFrame:self.view.bounds giveVoucherModel:giveVoucherModel];
                giveVoucherView.owerViewController = self.selectedViewController;
                [self.view addSubview:giveVoucherView];
            }
        }
    } failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
    }];
}

@end
