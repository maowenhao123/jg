//
//  YZGameIdViewController.m
//  ez
//
//  Created by apple on 15/1/14.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import "YZGameIdViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZBetViewController.h"
#import "YZMenuView.h"

@interface YZGameIdViewController ()<MenuViewDelegate>

@property (nonatomic, weak) YZMenuView * menuView;

@end

@implementation YZGameIdViewController

- (instancetype)initWithGameId:(NSString *)gameId
{
    if(self = [super init])
    {
        _gameId = gameId;
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"more_flat" highIcon:@"more_pressed_flat" target:self action:@selector(openMenuView)];
    [self setupMenuView];
}

#pragma mark - 返回上一页面
- (void)back
{
    if([YZStatusCacheTool getStatues].count)
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定清空所选的内容吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //删除数据库的数据
            [YZStatusCacheTool deleteAllStatus];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 菜单
- (void)setupMenuView
{
    BOOL isS1x5 = [self.gameId isEqualToString:@"T05"] || [self.gameId isEqualToString:@"T61"] || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"];
    BOOL isTC = [self.gameId isEqualToString:@"T51"] || [self.gameId isEqualToString:@"T53"] || [self.gameId isEqualToString:@"T52"] || [self.gameId isEqualToString:@"T54"];
    BOOL isDlt = [self.gameId isEqualToString:@"T01"];
    BOOL isSsq = [self.gameId isEqualToString:@"F01"];
    BOOL isKs = [self.gameId isEqualToString:@"F04"];
    BOOL isKy = [self.gameId isEqualToString:@"T06"];
    NSArray *titleArray = [NSArray array];
    if (isS1x5 || isSsq || isDlt || isKy)//大乐透 双色球 快赢
    {
        titleArray = @[@"走势图", @"购物车", @"近期开奖", @"玩法说明"];
    }else if (isKs)//快三
    {
        titleArray = @[@"购物车", @"近期开奖", @"玩法说明"];
    }else if (isTC)//体彩
    {
        titleArray = @[@"玩法说明"];
    }else
    {
        titleArray = @[@"购物车", @"玩法说明"];
    }
    
    YZMenuView * menuView = [[YZMenuView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) titleArray:titleArray];
    self.menuView = menuView;
    menuView.delegate = self;
    [self.tabBarController.view addSubview:menuView];
}

- (void)openMenuView
{
    [self.menuView show];
}

- (void)menuViewButtonDidClick:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"购物车"]) {
        [self buyCartBtnClick];
    }else if ([button.currentTitle isEqualToString:@"玩法说明"])
    {
        [self introduceBtnClick];
    }else if ([button.currentTitle isEqualToString:@"近期开奖"])
    {
        [self recentOpenLotteryBtnClick];
    }else if ([button.currentTitle isEqualToString:@"走势图"])
    {
        [self trendBtnDidClick];
    }
}

- (void)introduceBtnClick
{
    NSString *fileName = [NSString stringWithFormat:@"%@.html",self.gameId];
    NSString *web = @"";
    if ([self.gameId isEqualToString:@"T05"]) {
        web = [NSString stringWithFormat:@"%@%@", baseH5Url, @"/helper/11x5.html"];
    }else if ([self.gameId isEqualToString:@"T61"])
    {
        web = [NSString stringWithFormat:@"%@%@", baseH5Url, @"/helper/11x5t61.html"];
    }else if ([self.gameId isEqualToString:@"T62"])
    {
        web = [NSString stringWithFormat:@"%@%@", baseH5Url, @"/helper/11x5t62.html"];
    }else if ([self.gameId isEqualToString:@"T63"])
    {
        web = [NSString stringWithFormat:@"%@%@", baseH5Url, @"/helper/11x5t63.html"];
    }else if ([self.gameId isEqualToString:@"T64"])
    {
        web = [NSString stringWithFormat:@"%@%@", baseH5Url, @"/helper/11x5t64.html"];
    }else if ([self.gameId isEqualToString:@"T06"])
    {
        web = [NSString stringWithFormat:@"%@%@", baseH5Url, @"/helper/kwin481.html"];
    }else if ([self.gameId isEqualToString:@"T01"])
    {
        web = [NSString stringWithFormat:@"%@%@", baseH5Url, @"/helper/daletou.html"];
    }else if ([self.gameId isEqualToString:@"F01"])
    {
        web = [NSString stringWithFormat:@"%@%@", baseH5Url, @"/helper/shuangseqiu.html"];
    }else if ([self.gameId isEqualToString:@"T02"])
    {
        web = [NSString stringWithFormat:@"%@%@", baseH5Url, @"/helper/qixingcai.html"];
    }else if ([self.gameId isEqualToString:@"T03"])
    {
        web = [NSString stringWithFormat:@"%@%@", baseH5Url, @"/helper/array-3.html"];
    }else if ([self.gameId isEqualToString:@"T04"])
    {
        web = [NSString stringWithFormat:@"%@%@", baseH5Url, @"/helper/pailie5.html"];
    }else if ([self.gameId isEqualToString:@"F02"])
    {
        web = [NSString stringWithFormat:@"%@%@", baseH5Url, @"/helper/3D.html"];
    }else if ([self.gameId isEqualToString:@"F03"])
    {
        web = [NSString stringWithFormat:@"%@%@", baseH5Url, @"/helper/qilecai.html"];
    }else if ([self.gameId isEqualToString:@"F04"])
    {
        web = [NSString stringWithFormat:@"%@%@", baseH5Url, @"/helper/kuaisan.html"];
    }
    YZLoadHtmlFileController *htmlVc = [[YZLoadHtmlFileController alloc] init];
    if (YZStringIsEmpty(web)) {
        htmlVc.fileName = fileName;
    }else
    {
        htmlVc.web = web;
    }
    if ([self.gameId isEqualToString:@"T06"]) {
        htmlVc.title = [NSString stringWithFormat:@"%@（泳坛夺金）玩法说明", [YZTool gameIdNameDict][self.gameId]];
    }else
    {
        htmlVc.title = [NSString stringWithFormat:@"%@玩法说明", [YZTool gameIdNameDict][self.gameId]];
    }
    [self.navigationController pushViewController:htmlVc animated:YES];
}

- (void)buyCartBtnClick
{
    YZBetViewController *bet = [[YZBetViewController alloc] init];//投注控制器
    bet.gameId = self.gameId;
    [self.navigationController pushViewController: bet animated:YES];
}

- (void)recentOpenLotteryBtnClick
{
    
}

- (void)trendBtnDidClick
{
    
}

@end
