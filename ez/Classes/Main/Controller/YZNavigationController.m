//
//  YZNavigationController.m
//  ez
//
//  Created by apple on 14-8-6.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZNavigationController.h"
#import "YZFbBetSuccessViewController.h"
#import "YZSfcBetViewController.h"
#import "YZScjqViewController.h"
#import "YZSelectBaseViewController.h"
#import "YZKsViewController.h"
#import "YZMessageViewController.h"

@interface YZNavigationController ()<UINavigationControllerDelegate>

@end

@implementation YZNavigationController

/**
 *  第一次使用这个类的时候会调用(1个类只会调用1次)
 */
+ (void)initialize
{
    [self setupNavigationBarTheme];
    
    [self setupBarButtonItemTheme];
}

+ (void)setupNavigationBarTheme{
    // 取出appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];
#if JG
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:YZBaseColor WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = nil;
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //设置颜色
    navBar.tintColor = [UIColor whiteColor];
    
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:17];
    [navBar setTitleTextAttributes:textAttrs];
#elif ZC
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = nil;
    //设置状态栏
    if (@available(iOS 13.0, *)) {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    } else
    {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    
    //设置颜色
    navBar.tintColor = YZBlackTextColor;
    
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = YZBlackTextColor;
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [navBar setTitleTextAttributes:textAttrs];
#endif
}

+ (void)setupBarButtonItemTheme
{
#if JG
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [barItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *highlighteTextAttrs = [NSMutableDictionary dictionary];
    highlighteTextAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    highlighteTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [barItem setTitleTextAttributes:highlighteTextAttrs forState:UIControlStateHighlighted];
#elif ZC
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = YZBlackTextColor;
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [barItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *disabledTextAttrs = [NSMutableDictionary dictionary];
    disabledTextAttrs[NSForegroundColorAttributeName] = YZBlackTextColor;
    disabledTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [barItem setTitleTextAttributes:disabledTextAttrs forState:UIControlStateHighlighted];
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.tabBarController.viewControllers.count > 0)
    {
        [viewController setHidesBottomBarWhenPushed:YES];
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [super popViewControllerAnimated:animated];

    //非竞彩的基类控制器
    if([vc isKindOfClass:[YZSelectBaseViewController class]])
    {
        [(YZSelectBaseViewController *)vc removeSetDeadlineTimer];//解决控制器不销毁的bug
        if([YZStatusCacheTool getStatues].count)
        {
            //删除数据库的数据
            [YZStatusCacheTool deleteAllStatus];
        }
    }
    if ([vc isKindOfClass:[YZKsViewController class]]) {
        [(YZKsViewController *)vc removeSetDeadlineTimer];//解决控制器不销毁的bug
        if([YZStatusCacheTool getStatues].count)
        {
            //删除数据库的数据
            [YZStatusCacheTool deleteAllStatus];
        }
    }
    //新UI投注控制器pop
    if([vc isKindOfClass:[YZSfcBetViewController class]])
    {
        //胜负彩和四场进球投注控制器，pop后需要前一控制器刷新
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tableViewNeedReload" object:nil];
    }
    
    if([vc isKindOfClass:[YZMessageViewController class]])
    {
        //刷新是否有新消息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"upDataHaveNewMessage" object:nil];
    }
    return vc;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    BOOL hiddenNavBar = [viewController isKindOfClass:[NSClassFromString(@"YZHomePageViewController") class]] || [viewController isKindOfClass:[NSClassFromString(@"YZRRHomePageViewController") class]] || [viewController isKindOfClass:[NSClassFromString(@"YZZCMineViewController") class]] || [viewController isKindOfClass:[NSClassFromString(@"YZRRMineViewController") class]]  || [viewController isKindOfClass:[NSClassFromString(@"YZLoginViewController") class]] || [viewController isKindOfClass:[NSClassFromString(@"YZUserCircleViewController") class]] || [viewController isKindOfClass:[NSClassFromString(@"YZMineCircleViewController") class]] || [viewController isKindOfClass:[NSClassFromString(@"YZFBMatchDetailViewController") class]] || [viewController isKindOfClass:[NSClassFromString(@"YZShopInfoViewController") class]];
#if JG
    if ([viewController isKindOfClass:[NSClassFromString(@"YZLoginViewController") class]]) {
        hiddenNavBar = NO;
    }
#elif ZC
#endif
    [navigationController setNavigationBarHidden:hiddenNavBar animated:YES];
}

@end
