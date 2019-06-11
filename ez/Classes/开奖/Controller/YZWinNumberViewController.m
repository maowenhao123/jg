//
//  YZWinNumberViewController.m
//  ez
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZWinNumberViewController.h"
#import "YZWinNumberStatusFrame.h"
#import "YZWinNumberBallStatus.h"
#import "YZWinNumberTableViewCell.h"
#import "YZWinNumberHistoryViewController.h"
#import "YZWinNumberFBViewController.h"

@interface YZWinNumberViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) MJRefreshGifHeader *header;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *statusFrames;
@property (nonatomic, strong) NSArray *termList;

@end

@implementation YZWinNumberViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"最新开奖";
    [self setupChilds];
    waitingView_loadingData;
    [self loadData];
}

#pragma mark - 请求历史开奖数据
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self headerRefreshViewBeginRefreshing];
}
- (void)loadData
{
    NSDictionary *dict = @{
                           @"cmd":@(8017),
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            self.termList = json[@"termList"];
        }else
        {
            ShowErrorView;
        }
        [self setStatusFrames];
        [self.tableView reloadData];
        [self.header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView reloadData];
        [self.header endRefreshing];
    }];
}

#pragma mark - 初始化视图
- (void)setupChilds
{
    CGFloat tableViewH = screenHeight - statusBarH - navBarH - tabBarH;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, tableViewH)];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    
    //初始化头部刷新控件
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderData:header];
    self.header = header;
    self.tableView.mj_header = header;
}
// 开始进入刷新状态就会调用
- (void)headerRefreshViewBeginRefreshing
{
    [self loadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZWinNumberTableViewCell * cell = [YZWinNumberTableViewCell cellWithTableView:tableView];
    YZWinNumberStatusFrame * statusFrame = self.statusFrames[indexPath.row];
    cell.statusFrame = statusFrame;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YZWinNumberStatusFrame * statusFrame = self.statusFrames[indexPath.row];
    
    if ([statusFrame.status.gameId isEqualToString:@"T51"] || [statusFrame.status.gameId isEqualToString:@"T52"]) {//竞彩足球
        YZWinNumberFBViewController *winNumberFBVC = [[YZWinNumberFBViewController alloc]init];
        winNumberFBVC.gameId = statusFrame.status.gameId;
        [self.navigationController pushViewController:winNumberFBVC animated:YES];
    } else
    {
        YZWinNumberHistoryViewController * winNumberHistoryVC = [[YZWinNumberHistoryViewController alloc]init];
        winNumberHistoryVC.gameId = statusFrame.status.gameId;
        [self.navigationController pushViewController:winNumberHistoryVC animated:YES];
    }
}
#pragma mark - 初始化
- (void)setStatusFrames
{
    NSMutableArray *statusFrameArray = [NSMutableArray array];
    NSMutableArray *muArr = [[YZTool gameIds] mutableCopy];
    for(int i = 0;i < muArr.count;i++)
    {
        NSString *gameId = muArr[i];
        YZWinNumberStatus *status = [[YZWinNumberStatus alloc] init];
#if JG
        status.lotteryImage = [NSString stringWithFormat:@"icon_%@",gameId];
#elif ZC
        status.lotteryImage = [NSString stringWithFormat:@"icon_%@_zc",gameId];
#elif CS
        status.lotteryImage = [NSString stringWithFormat:@"icon_%@_zc",gameId];
#endif
        status.lotteryName = [YZTool gameIdNameDict][gameId];
        for(int j = 0;j < self.termList.count;j++)
        {
            NSString *aGameId = self.termList[j][@"gameId"];
            if([aGameId isEqualToString:gameId])
            {
                status.gameId = aGameId;
                status.lotteryPeriod = [NSString stringWithFormat:@"第%@期",self.termList[j][@"termId"]];
                status.lotteryTime = [self.termList[j][@"endTime"] substringToIndex:10];
                status.lotteryNumber = self.termList[j][@"winNumber"];
                //开奖号码
                NSString *winNumberStr = [self.termList[j][@"winNumber"] stringByReplacingOccurrencesOfString:@"|" withString:@","];
                NSArray *winNumbers = [winNumberStr componentsSeparatedByString:@","];
                NSMutableArray * lotteryNumberInfos = [NSMutableArray array];
                for (int k = 0; k < winNumbers.count; k++) {
                    NSString * winNumber = winNumbers[k];
                    YZWinNumberBallStatus * winNumberBallStatus = [[YZWinNumberBallStatus alloc]init];
                    winNumberBallStatus.number = winNumber;
                    winNumberBallStatus.type = 1;//默认红色
                    if (k > (winNumbers.count - [self getBlueBallCount:gameId] - 1)) {
                        winNumberBallStatus.type = 2;
                    }
                    if([gameId isEqualToString:@"T54"])//四场进球显示绿色
                    {
                        winNumberBallStatus.type = 3;
                    }else if ([gameId isEqualToString:@"T53"])
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
        }
    }
    if (statusFrameArray.count > 0) {//添加竞彩足球 竞彩篮球
        YZWinNumberStatusFrame *statusFrame1 = [[YZWinNumberStatusFrame alloc] init];
        YZWinNumberStatus *status1 = [[YZWinNumberStatus alloc] init];
        NSString * gameId1 = @"T51";
        status1.gameId = gameId1;
#if JG
        status1.lotteryImage = [NSString stringWithFormat:@"icon_%@",gameId1];
#elif ZC
        status1.lotteryImage = [NSString stringWithFormat:@"icon_%@_zc",gameId1];
#elif CS
        status1.lotteryImage = [NSString stringWithFormat:@"icon_%@_zc",gameId1];
#endif
        status1.lotteryName = [YZTool gameIdNameDict][gameId1];
        statusFrame1.status = status1;
        [statusFrameArray insertObject:statusFrame1 atIndex:0];
        
        YZWinNumberStatusFrame *statusFrame2 = [[YZWinNumberStatusFrame alloc] init];
        YZWinNumberStatus *status2 = [[YZWinNumberStatus alloc] init];
        NSString * gameId2 = @"T52";
        status2.gameId = gameId2;
#if JG
        status2.lotteryImage = [NSString stringWithFormat:@"icon_%@",gameId2];
#elif ZC
        status2.lotteryImage = [NSString stringWithFormat:@"icon_%@_zc",gameId2];
#elif CS
        status2.lotteryImage = [NSString stringWithFormat:@"icon_%@_zc",gameId2];
#endif
        status2.lotteryName = [YZTool gameIdNameDict][gameId2];
        statusFrame2.status = status2;
        [statusFrameArray insertObject:statusFrame2 atIndex:1];
    }
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
