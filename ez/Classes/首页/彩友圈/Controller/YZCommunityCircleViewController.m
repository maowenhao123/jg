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
    waitingView_loadingData;
    [self getData];
}

#pragma mark - 请求数据
- (void)getData
{
    NSDictionary *dict = @{
                           @"userId": UserId,
                           @"communityId": self.communityId,
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getCommunityPlayType") params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"getCommunityPlayType:%@",json);
        if (SUCCESS){
            self.dataArray = json[@"topics"];
            [self configurationChildsWithDataArray:self.dataArray];
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
- (void)configurationChildsWithDataArray:(NSArray *)dataArray
{
    NSMutableArray *btnTitles = [NSMutableArray array];
    [btnTitles addObject:@"全部"];
    for (NSDictionary * dic in dataArray) {
        [btnTitles addObject:dic[@"name"]];
    }
    self.btnTitles = [NSArray arrayWithArray:btnTitles];
    CGFloat scrollViewH = screenHeight - statusBarH - navBarH - topBtnH;
    for(int i = 0; i < self.btnTitles.count; i++)
    {
        YZCircleTableView *tableView = [[YZCircleTableView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, scrollViewH)];
        tableView.tag = i;
        tableView.type = CircleCommunityTopic;
        tableView.communityId = self.communityId;
        if (i == 0) {
            tableView.playTypeId = @"";
        }else
        {
            NSDictionary * dic = dataArray[i - 1];
            tableView.playTypeId = dic[@"id"];
        }
        [self.views addObject:tableView];
        
        [tableView getData];
    }
    //完成配置
    [super configurationComplete];
    [super topBtnClick:self.topBtns[0]];
}

//设置圈子可选玩法
- (void)sortDone
{
    NSMutableArray * playTypes = [NSMutableArray array];
    for (int i = 0; i < self.views.count; i++) {
        if (i != 0) {
            YZCircleTableView *tableView = self.views[i];
            NSDictionary * dict = @{
                                    @"playTypeId": tableView.playTypeId,
                                    @"order": @(i)
                                    };
            [playTypes addObject:dict];
        }
    }
    
    NSDictionary *dict = @{
                           @"userId": UserId,
                           @"communityId": self.communityId,
                           @"playTypes": playTypes
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/setCommunityPlayType") params:dict success:^(id json) {
        if (SUCCESS){
            
        }
    }failure:^(NSError *error)
    {
        YZLog(@"error = %@",error);
    }];
}

@end
