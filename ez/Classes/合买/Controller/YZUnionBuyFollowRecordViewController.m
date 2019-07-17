//
//  YZUnionBuyFollowRecordViewController.m
//  ez
//
//  Created by apple on 15/3/23.
//  Copyright (c) 2015年 9ge. All rights reserved.
//  各买跟单列表

#import "YZUnionBuyFollowRecordViewController.h"
#import "YZUnionBuyFollowUserCellStatusFrame.h"
#import "YZUnionBuyFollowUserCell.h"

@interface YZUnionBuyFollowRecordViewController ()

@property (nonatomic, copy) NSString *unionBuyPlanId;
@property (nonatomic, copy) NSString *unionBuyUserId;
@property (nonatomic, strong) NSArray *unionBuyFollowUserStatus;//模型数组
@property (nonatomic, strong) NSMutableArray *statusFrames;//模型和frame数组
@property (nonatomic, strong) NSNumber *totalMoney;//总金额
@property (nonatomic, weak) MJRefreshGifHeader *header;

@end

@implementation YZUnionBuyFollowRecordViewController

- (instancetype)initWithUnionBuyPlanId:(NSString *)unionBuyPlanId unionBuyUserId:(NSString *)unionBuyUserId
{
    self = [super init];
    if(self)
    {
        _unionBuyPlanId = unionBuyPlanId;
        _unionBuyUserId = unionBuyUserId;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"参与者列表";
    self.view.backgroundColor = YZBackgroundColor;
    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithIcon:@"back_btn_flat" highIcon:@"back_btn_flat" target:self action:@selector(back)];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [[UIView alloc] init];
    waitingView
    [self getFollowDetail];
    
    //初始化头部刷新控件
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(getFollowDetail)];
    self.header = header;
    [YZTool setRefreshHeaderData:header];
    self.tableView.mj_header = header;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 请求数据
- (void)getFollowDetail
{
    NSDictionary *dict = @{
                           @"cmd":@(8125),
                           @"unionBuyPlanId":self.unionBuyPlanId,
                           @"unionBuyUserId":self.unionBuyUserId
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"followDetailBtnClick - json = %@",json);
        [MBProgressHUD hideHUDForView:self.view];
        [self.header endRefreshing];
        if (SUCCESS) {
            self.totalMoney = json[@"totalMoney"];
            self.unionBuyFollowUserStatus = [YZUnionBuyStatus objectArrayWithKeyValuesArray:json[@"unionBuys"]];
            [self.tableView reloadData];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.header endRefreshing];
        YZLog(@"followDetailBtnClick - error = %@",error);
    }];
}

- (void)setUnionBuyFollowUserStatus:(NSArray *)unionBuyFollowUserStatus
{
    _unionBuyFollowUserStatus = unionBuyFollowUserStatus;
    
    //设置statusFrame
    NSMutableArray *statusFrames = [NSMutableArray array];
    for(YZUnionBuyStatus *status in _unionBuyFollowUserStatus)
    {
        YZUnionBuyFollowUserCellStatusFrame *statusFrame = [[YZUnionBuyFollowUserCellStatusFrame alloc] init];
        status.followMoney = [NSString stringWithFormat:@"参与金额：%ld元",[status.money integerValue] / 100];
        status.moneyOfTotal = [NSString stringWithFormat:@"占方案总金额：%0.1f%%",[status.money floatValue] / [self.totalMoney floatValue] * 100];
        statusFrame.status = status;
        [statusFrames addObject:statusFrame];
    }
    _statusFrames = statusFrames;
}

#pragma mark - tableview的数据源的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YZUnionBuyFollowUserCell *cell = [YZUnionBuyFollowUserCell cellWithTableView:tableView];
    cell.statusFrame = self.statusFrames[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZUnionBuyFollowUserCellStatusFrame *statusFrame = self.statusFrames[indexPath.row];
    return  statusFrame.cellH;
}


@end
