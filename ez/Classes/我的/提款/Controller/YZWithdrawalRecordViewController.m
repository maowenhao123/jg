//
//  YZWithdrawalRecordViewController.m
//  ez
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZWithdrawalRecordViewController.h"
#import "YZWithdrawalRecordTableViewCell.h"
#import "YZNoDataTableViewCell.h"
#import "YZWithdrawalRecordStatus.h"

@interface YZWithdrawalRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *withdrawalRecords;
@property (nonatomic, weak) MJRefreshGifHeader *header;
@property (nonatomic, weak) MJRefreshBackGifFooter *footer;
@property (nonatomic, assign) int pageIndex;

@end

@implementation YZWithdrawalRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提款记录";
    [self setupChilds];
    [self setupRefreshView];
    [self getData];
}
- (void)setupChilds
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:tableView];
}
#pragma mark - 集成上拉下拉刷新控件
- (void)setupRefreshView
{
    //初始化头部刷新控件
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderData:header];
    self.header = header;
    self.tableView.mj_header = header;
    
    //初始化底部刷新控件
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshViewBeginRefreshing)];
    [YZTool setRefreshFooterData:footer];
    self.footer = footer;
    self.tableView.mj_footer = footer;
}
#pragma  mark - MJRefreshBaseViewDelegate的代理方法
- (void)headerRefreshViewBeginRefreshing
{
    _pageIndex = 0;
    [self.withdrawalRecords removeAllObjects];
    [self getData];
}
- (void)footerRefreshViewBeginRefreshing
{
    _pageIndex ++;
    [self getData];
}
#pragma mark - 请求数据
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self headerRefreshViewBeginRefreshing];
}
- (void)getData
{
    NSDictionary *dict = @{
                           @"cmd":@(10900),
                           @"userId":UserId,
                           @"pageIndex":@(self.pageIndex),
                           @"pageSize":@(10)
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"%@",json);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (SUCCESS) {
             NSArray * withdrawalRecords = [YZWithdrawalRecordStatus objectArrayWithKeyValuesArray:json[@"petitions"]];
            [self.withdrawalRecords addObjectsFromArray:withdrawalRecords];
            [self.tableView reloadData];
            [self.header endRefreshing];
            if (withdrawalRecords.count == 0) {
                [self.footer endRefreshingWithNoMoreData];
            }else
            {
                [self.footer endRefreshing];
            }
        }else
        {
            [self.tableView reloadData];
            [self.header endRefreshing];
            [self.footer endRefreshing];
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [self.tableView reloadData];
        [self.header endRefreshing];
        [self.footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"账户error");
    }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.withdrawalRecords.count == 0 ? 1 : self.withdrawalRecords.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.withdrawalRecords.count == 0) {
        YZNoDataTableViewCell *cell = [YZNoDataTableViewCell cellWithTableView:tableView cellId:@"noMessageCell"];
        cell.imageName = @"no_recharge";
        cell.noDataStr = @"暂时没有提款记录";
        return cell;
    }else
    {
        YZWithdrawalRecordTableViewCell * cell = [YZWithdrawalRecordTableViewCell cellWithTableView:tableView];
        cell.status = self.withdrawalRecords[indexPath.section];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.withdrawalRecords.count == 0 ? tableView.height * 0.7 : 85;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.withdrawalRecords.count - 1 == section) {
        return 10;
    }
    return 0.01;
}
#pragma mark - 初始化
- (NSMutableArray *)withdrawalRecords
{
    if (_withdrawalRecords == nil) {
        _withdrawalRecords = [NSMutableArray array];
    }
    return _withdrawalRecords;
}
@end
