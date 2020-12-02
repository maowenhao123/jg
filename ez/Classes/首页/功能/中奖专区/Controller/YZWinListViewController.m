//
//  YZWinListViewController.m
//  zc
//
//  Created by dahe on 2020/9/11.
//  Copyright © 2020 9ge. All rights reserved.
//

#import "YZWinListViewController.h"
#import "YZGameIdViewController.h"
#import "YZWinLiveTableViewCell.h"
#import "YZWinRankingTableViewCell.h"

@interface YZWinListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, strong) NSMutableArray *winLiveArray;
@property (nonatomic, strong) NSMutableArray *winRankingArray;

@end

@implementation YZWinListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupChilds];
    self.pageIndex = 0;
    [self getWinData];
}

#pragma  mark - 获取中奖实况、排名数据
- (void)getWinData
{
    NSString *url = @"";
    NSDictionary * dict = [NSDictionary dictionary];
    if (self.index == 0)
    {
        url = @"/getHitLive";
        dict = @{
            @"pageIndex": @(self.pageIndex),
            @"pageSize":@(10)
        };
    }else if(self.index == 1)
    {
        url = @"/getHitRanking";
    }
    [[YZHttpTool shareInstance] postWithURL:url params:dict success:^(id json) {
        YZLog(@"%@",json);
        if (SUCCESS) {
            NSArray *dataArray = [YZWinModel objectArrayWithKeyValuesArray:json[@"hitLiveList"]];
            if (self.pageIndex == 0 && self.index == 0) {
                [self.winLiveArray removeAllObjects];
            }else if (self.index == 1)
            {
                [self.winRankingArray removeAllObjects];
            }
            if (self.index == 0) {
                [self.winLiveArray addObjectsFromArray:dataArray];
            }else
            {
                self.winRankingArray = [NSMutableArray arrayWithArray:dataArray];
            }
            [self.tableView reloadData];//刷新数据
            if (dataArray.count == 0) {//没有新的数据
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else
            {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView.mj_header endRefreshing];
        }else
        {
            ShowErrorView;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        YZLog(@"getHitLive请求error");
    }];
}

#pragma  mark - 初始化
- (void)setupChilds
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH - 44)];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 7)];
    tableHeaderView.backgroundColor = YZBackgroundColor;
    tableView.tableHeaderView = tableHeaderView;
    
    //初始化头部刷新控件
    MJRefreshGifHeader *headerView = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderData:headerView];
    tableView.mj_header = headerView;
    
    //初始化底部刷新控件
    MJRefreshBackGifFooter *footerView = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshViewBeginRefreshing)];
    [YZTool setRefreshFooterData:footerView];
    if (self.index == 0) {
        tableView.mj_footer = footerView;
    }
}

#pragma  mark - 刷新
- (void)headerRefreshViewBeginRefreshing
{
    if (self.index == 0) {
        self.pageIndex = 0;
    }
    [self getWinData];
}

- (void)footerRefreshViewBeginRefreshing
{
    self.pageIndex++;
    [self getWinData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.index == 0) {
        return self.winLiveArray.count;
    }else if (self.index == 1)
    {
        return self.winRankingArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0) {
        YZWinLiveTableViewCell * cell = [YZWinLiveTableViewCell cellWithTableView:tableView];
        cell.winModel = self.winLiveArray[indexPath.row];
        return cell;
    }else if (self.index == 1)
    {
        YZWinRankingTableViewCell * cell = [YZWinRankingTableViewCell cellWithTableView:tableView];
        cell.winModel = self.winRankingArray[indexPath.row];
        cell.index = indexPath.row;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0) {
        return 70;
    }else if (self.index == 1)
    {
        return 90;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.index == 0) {
        YZWinModel * winModel = self.winLiveArray[indexPath.row];
        NSString * gameId = winModel.gameId;
        YZGameIdViewController *gameVC = (YZGameIdViewController *)[[[YZTool gameDestClassDict][gameId] alloc] initWithGameId:gameId];
        [self.navigationController pushViewController:gameVC animated:YES];
    }
}

#pragma mark - 初始化
- (NSMutableArray *)winLiveArray
{
    if(_winLiveArray == nil)
    {
        _winLiveArray = [NSMutableArray array];
    }
    return _winLiveArray;
}

- (NSMutableArray *)winRankingArray
{
    if(_winRankingArray == nil)
    {
        _winRankingArray = [NSMutableArray array];
    }
    return _winRankingArray;
}


@end
