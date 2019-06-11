//
//  YZCircleViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleViewController.h"
#import "YZPublishCircleViewController.h"
#import "YZCircleTableView.h"
#import "YZUserCircleViewController.h"
#import "YZCircleTableHeaderView.h"

@interface YZCircleViewController ()

@end

@implementation YZCircleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"彩友圈";
    [self setupChilds];
}

#pragma mark - 布局子视图
- (void)setupChilds
{
    UIBarButtonItem * mineBar = [[UIBarButtonItem alloc] initWithTitle:@"我的" style:UIBarButtonItemStylePlain target:self action:@selector(mineBarDidClick)];
    UIBarButtonItem * publishBar = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(publishBarDidClick)];
    self.navigationItem.rightBarButtonItems = @[mineBar, publishBar];
    
    //添加btnTitle
    self.btnTitles = @[@"圈子", @"我关注的"];
    //添加tableview
    CGFloat scrollViewH = screenHeight-statusBarH-navBarH-topBtnH;
    for(int i = 0;i < self.btnTitles.count; i++)
    {
        YZCircleTableView *tableView = [[YZCircleTableView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, scrollViewH)];
        tableView.tag = i;
        [self.views addObject:tableView];
        
        if (i == 0) {
            YZCircleTableHeaderView * headerView = [[YZCircleTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 140)];
            tableView.tableHeaderView = headerView;
        }
    }
    //完成配置
    [super configurationComplete];
    [super topBtnClick:self.topBtns[0]];
}

- (void)mineBarDidClick
{
    YZUserCircleViewController * userCircleVC = [[YZUserCircleViewController alloc] init];
    [self.navigationController pushViewController:userCircleVC animated:YES];
}

- (void)publishBarDidClick
{
    YZPublishCircleViewController * publishCircleVC = [[YZPublishCircleViewController alloc] init];
    [self.navigationController pushViewController:publishCircleVC animated:YES];
}

@end
