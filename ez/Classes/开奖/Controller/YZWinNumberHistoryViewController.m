//
//  YZWinNumberHistoryViewController.m
//  ez
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define pageSize 15

#import "YZWinNumberHistoryViewController.h"
#import "YZWinNumberDetailViewController.h"
#import "YZWinNumberStatusFrame.h"
#import "YZWinNumberBallStatus.h"
#import "YZWinNumberTableViewCell.h"

@interface YZWinNumberHistoryViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _pageIndex;
}

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *termList;
@property (nonatomic, strong) NSMutableArray *statusFrames;
@property (nonatomic, weak) MJRefreshGifHeader *header;
@property (nonatomic, weak) MJRefreshBackGifFooter *footer;

@end

@implementation YZWinNumberHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"历史开奖";
    _pageIndex = 0;
    [self setupChilds];
    //集成上拉下拉刷新控件
    [self setupRefreshView];
    waitingView_loadingData;
    [self loadHistoryOpenLottery];
}

- (void)setupChilds
{
    CGFloat tableViewH = screenHeight - statusBarH - navBarH;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, tableViewH)];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
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
- (void)headerRefreshViewBeginRefreshing
{
    _pageIndex = 0;
    [self.termList removeAllObjects];
    [self loadHistoryOpenLottery];
}
- (void)footerRefreshViewBeginRefreshing
{
    _pageIndex ++;
    [self loadHistoryOpenLottery];
}
#pragma mark - 请求历史开奖数据
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self headerRefreshViewBeginRefreshing];
}
- (void)loadHistoryOpenLottery
{
    NSDictionary *dict = @{
                           @"cmd":@(8018),
                           @"gameId":self.gameId,
                           @"pageIndex":@(_pageIndex),
                           @"pageSize":@(pageSize)
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            NSArray *temp = json[@"termList"];
            if(temp.count > 0)
            {
                for (NSDictionary *status in temp) {
                    [self.termList addObject:status];
                }
                [self setStatusFrames];
                [self.tableView reloadData];
                [self.header endRefreshing];
                [self.footer endRefreshing];
            }else
            {
                [self setStatusFrames];
                [self.tableView reloadData];
                [self.header endRefreshing];
                [self.footer endRefreshingWithNoMoreData];
            }
        }else
        {
            [self setStatusFrames];
            [self.tableView reloadData];
            [self.header endRefreshing];
            [self.footer endRefreshing];
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"开奖error = %@",error);
        [self.tableView reloadData];
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZWinNumberTableViewCell * cell = [YZWinNumberTableViewCell cellWithTableView:tableView];
    cell.statusFrame = self.statusFrames[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZWinNumberDetailViewController * winNumberDetailVC = [[YZWinNumberDetailViewController alloc]init];
    YZWinNumberStatusFrame * statusFrame = self.statusFrames[indexPath.row];
    winNumberDetailVC.gameId = statusFrame.status.gameId;
    winNumberDetailVC.termId = self.termList[indexPath.row][@"termId"];
    [self.navigationController pushViewController:winNumberDetailVC animated:YES];
}
#pragma mark - 初始化
- (void)setStatusFrames
{
    NSMutableArray *statusFrameArray = [NSMutableArray array];
    
    for(int i = 0;i < self.termList.count;i++)
    {
        YZWinNumberStatus *status = [[YZWinNumberStatus alloc] init];
        status.lotteryName = [YZTool gameIdNameDict][self.gameId];
        status.lotteryPeriod = [NSString stringWithFormat:@"第%@期",self.termList[i][@"termId"]];
        status.lotteryTime = [self.termList[i][@"endTime"] substringToIndex:10];
        status.gameId = self.gameId;
        
        //开奖号码
        NSString *winNumberStr = [self.termList[i][@"winNumber"] stringByReplacingOccurrencesOfString:@"|" withString:@","];
        NSArray *winNumbers = [winNumberStr componentsSeparatedByString:@","];
        NSMutableArray * lotteryNumberInfos = [NSMutableArray array];
        for (int j = 0; j < winNumbers.count; j++) {
            NSString * winNumber = winNumbers[j];
            YZWinNumberBallStatus * winNumberBallStatus = [[YZWinNumberBallStatus alloc]init];
            winNumberBallStatus.number = winNumber;
            winNumberBallStatus.type = 1;//默认红色
            if (j > (winNumbers.count - [self getBlueBallCount:self.gameId] - 1)) {
                winNumberBallStatus.type = 2;
            }
            if([self.gameId isEqualToString:@"T54"])//四场进球显示绿色
            {
                winNumberBallStatus.type = 3;
            }else if([self.gameId isEqualToString:@"T53"])
            {
                winNumberBallStatus.type = 4;
            }
            [lotteryNumberInfos addObject:winNumberBallStatus];
        }
        status.lotteryNumberInfos = lotteryNumberInfos;
        YZWinNumberStatusFrame *statusFrame = [[YZWinNumberStatusFrame alloc] init];
        statusFrame.status = status;
        [statusFrameArray addObject:statusFrame];
    }
    //赋值
    self.statusFrames = statusFrameArray;
}
- (NSMutableArray *)statusFrames
{
    if(_statusFrames == nil)
    {
        _statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}
- (NSArray *)termList
{
    if(_termList == nil)
    {
        _termList = [NSMutableArray array];
    }
    return _termList;
}
#pragma mark - 工具
- (NSInteger)getBlueBallCount:(NSString *)gameId
{
    NSInteger blueBallCount = 0;
    if([gameId isEqualToString:@"T01"])
    {
        blueBallCount = 2;
    }else if([gameId isEqualToString:@"F01"])
    {
        blueBallCount = 1;
    }else if([gameId isEqualToString:@"F03"])
    {
        blueBallCount = 1;
    }else
    {
        blueBallCount = 0;
    }
    return blueBallCount;
}
@end
