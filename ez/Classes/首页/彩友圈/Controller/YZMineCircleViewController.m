//
//  YZMineCircleViewController.m
//  ez
//
//  Created by dahe on 2019/6/27.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZMineCircleViewController.h"
#import "YZCircleUserInfoHeaderView.h"
#import "YZCircleTableView.h"
#import "YZCircleCommentTableView.h"
#import "YZSegementView.h"

@interface YZMineCircleViewController ()

@property (nonatomic, weak) YZCircleUserInfoHeaderView *headerView;
@property (nonatomic, strong) YZCircleUserInfoModel *userInfoModel;

@end

@implementation YZMineCircleViewController

#pragma mark - 控制器的生命周期
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChilds];
    [self getData];
}

#pragma mark - 请求数据
- (void)getData
{
    NSDictionary *dict = @{
                           @"currentUserId": UserId,
                           @"targetUserId": UserId,
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getUserInfo") params:dict success:^(id json) {
        YZLog(@"getUserInfo:%@",json);
        if (SUCCESS){
            self.userInfoModel = [YZCircleUserInfoModel objectWithKeyValues:json[@"userInfo"]];
        }else
        {
            ShowErrorView
        }
    }failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
    }];
}

- (void)setUserInfoModel:(YZCircleUserInfoModel *)userInfoModel
{
    _userInfoModel = userInfoModel;
    
    self.headerView.userId = UserId;
    self.headerView.userInfoModel = _userInfoModel;
}

#pragma mark - 布局子视图
- (void)setupChilds
{
    //headerView
    YZCircleUserInfoHeaderView *headerView = [[YZCircleUserInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 212)];
    self.headerView = headerView;
    headerView.canChooseAvatar = YES;
    [self.view addSubview:headerView];
    
    //返回
    UIButton * backButon = [UIButton buttonWithType:UIButtonTypeCustom];
    backButon.frame = CGRectMake(5, statusBarH + 6, 34, 30);
    [backButon setImage:[UIImage imageNamed:@"back_btn_flat"] forState:UIControlStateNormal];
    [backButon addTarget:self action:@selector(backButonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButon];
    
    //tableView
    NSMutableArray * views = [NSMutableArray array];
    
    CGFloat tableViewH = screenHeight - CGRectGetMaxY(headerView.frame) - topBtnH;
    YZCircleTableView *circleTableView = [[YZCircleTableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, tableViewH)];
    circleTableView.type = CircleMineTopic;
    [self.view addSubview:circleTableView];
    [circleTableView getData];
    [views addObject:circleTableView];
    
    YZCircleCommentTableView *commentTableView = [[YZCircleCommentTableView alloc] initWithFrame:CGRectMake(screenWidth, 0, screenWidth, tableViewH)];
    [self.view addSubview:commentTableView];
    [views addObject:commentTableView];
    
    NSArray * btnTitles = @[@"帖子", @"消息"];
    CGFloat segementViewY = CGRectGetMaxY(headerView.frame);
    YZSegementView * segementView = [[YZSegementView alloc] initWithFrame:CGRectMake(0, segementViewY, screenWidth, screenHeight - segementViewY) btnTitles:btnTitles views:views];
    [self.view addSubview:segementView];
}

- (void)backButonDidClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
