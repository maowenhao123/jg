//
//  YZCommunityCircleViewController.m
//  ez
//
//  Created by dahe on 2019/6/20.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZCommunityCircleViewController.h"
#import "YZCircleTableView.h"

@interface YZCommunityCircleViewController ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation YZCommunityCircleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.canEdit = YES;
//    waitingView_loadingData;
//    [self getData];
    //初始化顶
    [self configurationChilds];
}

#pragma mark - 请求数据
- (void)getData
{
    NSDictionary *dict = @{
                           @"userId": UserId,
                           @"communityId": self.communityId,
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlCircle(@"/getByConcernMineUser") params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"getByConcernMineUser:%@",json);
        if (SUCCESS){

            
        }else
        {
            ShowErrorView
        }
    }failure:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view];
         YZLog(@"error = %@",error);
     }];
}

#pragma mark - 布局子视图
- (void)configurationChilds
{
    self.btnTitles = @[@"未使用", @"已用完", @"已失效", @"已失效" , @"已失效"];
    CGFloat scrollViewH = screenHeight-statusBarH-navBarH-topBtnH;
    for(int i = 0; i < self.btnTitles.count; i++)
    {
        YZCircleTableView *tableView = [[YZCircleTableView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, scrollViewH) style:UITableViewStyleGrouped];
        tableView.tag = i;
        [self.views addObject:tableView];
    }
    //完成配置
    [super configurationComplete];
    [super topBtnClick:self.topBtns[0]];
}

#pragma mark - 初始化
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

@end
