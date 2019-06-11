//
//  YZWinNumberFBViewController.m
//  ez
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 9ge. All rights reserved.
//
#import "YZWinNumberFBViewController.h"
#import "YZGameIdViewController.h"
#import "YZWinNumberFBTableViewCell.h"
#import "YZFBTimeChooseView.h"
#import "YZWinNumberFBStatus.h"

@interface YZWinNumberFBViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, weak) MJRefreshGifHeader *header;
@property (nonatomic, weak) MJRefreshBackGifFooter *footer;
@property (nonatomic, assign) int pageIndex1;
@property (nonatomic, assign) int pageIndex2;

@end

@implementation YZWinNumberFBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    if ([self.gameId isEqualToString:@"T52"]) {
        self.title = @"竞彩篮球";
    }else
    {
        self.title = @"竞彩足球";
    }
    [self setupChilds];
    waitingView_loadingData;
    [self getDataIsByDate:NO];
}
#pragma mark - 获取数据
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self headerRefreshViewBeginRefreshing];
}
- (void)getDataIsByDate:(BOOL)isByDate
{
    NSDictionary *dict = [NSDictionary dictionary];
    NSString * url;
    if (isByDate) {
        NSString * roundDateStr = [self.dateStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        dict = @{
                   @"pageIndex":@(self.pageIndex2),
                   @"pageSize":@(10),
                   @"roundDateStr":roundDateStr,
                   @"gameId":self.gameId
                };
        url = BaseUrlJingcai(@"/matchresults/rounddate");
    }else
    {
        dict = @{
                 @"pageIndex":@(self.pageIndex1),
                 @"pageSize":@(10),
                 @"gameId":self.gameId
                 };
        url = BaseUrlJingcai(@"/matchresults/default");
    }
    [[YZHttpTool shareInstance] requestTarget:self PostWithURL:url params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"%@",json);
        if (SUCCESS) {;
            NSArray * dataArray = [YZWinNumberFBStatus objectArrayWithKeyValuesArray:json[@"matchResults"]];//转模型数组
            [self.dataArray addObjectsFromArray:dataArray];
            [self.tableView reloadData];
            if(dataArray.count > 0)
            {
                [self.header endRefreshing];
                [self.footer endRefreshing];
            }else
            {
                [self.header endRefreshing];
                [self.footer endRefreshingWithNoMoreData];
            }
        }else
        {
            [self.tableView reloadData];
            [self.header endRefreshing];
            [self.footer endRefreshing];
            ShowErrorView;
        }
    }failure:^(NSError *error)
    {
         [self.tableView reloadData];
         [self.header endRefreshing];
         [self.footer endRefreshing];
         [MBProgressHUD hideHUDForView:self.view];
         YZLog(@"error = %@",error);
     }];
}
#pragma mark - 布局视图
- (void)setupChilds
{
    UIBarButtonItem *timeBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"近期比赛" style:UIBarButtonItemStylePlain target:self action:@selector(chooseTimeBarClick)];
    self.navigationItem.rightBarButtonItem = timeBarButtonItem;
    
    //tableview
    CGFloat betButtonH = 40;
    CGFloat tableViewH = screenHeight - statusBarH - navBarH - 10 * 2 - betButtonH - [YZTool getSafeAreaBottom];
    if (IsBangIPhone) {
        tableViewH = screenHeight - statusBarH - navBarH - 10 - betButtonH - [YZTool getSafeAreaBottom];
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, tableViewH)];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:tableView];
    
    //初始化头部刷新控件
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderData:header];
    self.header = header;
    tableView.mj_header = header;
    
    //初始化底部刷新控件
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshViewBeginRefreshing)];
    [YZTool setRefreshFooterData:footer];
    self.footer = footer;
    tableView.mj_footer = footer;
    
    //立即投注
    YZBottomButton * betButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    betButton.y = CGRectGetMaxY(tableView.frame) + 10;
    [betButton setTitle:@"立即投注" forState:UIControlStateNormal];
    [betButton addTarget:self action:@selector(betButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:betButton];
}
- (void)headerRefreshViewBeginRefreshing
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"近期比赛"]) {
        self.pageIndex1 = 0;
        [self.dataArray removeAllObjects];
        [self getDataIsByDate:NO];
    }else
    {
        self.pageIndex2 = 0;
        [self.dataArray removeAllObjects];
        [self getDataIsByDate:YES];
    }
}
- (void)footerRefreshViewBeginRefreshing
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"近期比赛"]) {
        self.pageIndex1 += 1;
        [self getDataIsByDate:NO];
    }else
    {
        self.pageIndex2 += 1;
        [self getDataIsByDate:YES];
    }
}
#pragma mark - 选择时间
- (void)chooseTimeBarClick
{
    YZFBTimeChooseView * timeChooseView = [[YZFBTimeChooseView alloc]initWithDateStr:self.dateStr];
    timeChooseView.block = ^(NSString * dateStr){
        self.dateStr = dateStr;
        if ([dateStr isEqualToString:@"近期比赛"]) {
            self.navigationItem.rightBarButtonItem.title = dateStr;
            self.pageIndex2 = 0;
            [self.dataArray removeAllObjects];
            [self getDataIsByDate:NO];
        }else
        {
            self.navigationItem.rightBarButtonItem.title = [dateStr substringFromIndex:5];
            self.pageIndex1 = 0;
            [self.dataArray removeAllObjects];
            [self getDataIsByDate:YES];
        }
    };
    [timeChooseView show];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZWinNumberFBTableViewCell *cell = [YZWinNumberFBTableViewCell cellWithTableView:tableView];
    if (indexPath.row <= self.dataArray.count) {
        if ([self.gameId isEqualToString:@"T52"]) {
            cell.isBasketBall = YES;
        }
        cell.status = self.dataArray[indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= self.dataArray.count) {
        YZWinNumberFBStatus * status = self.dataArray[indexPath.row];
        if (status.open) {
            return 50 + 38;
        }
        return 50;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
    headerView.backgroundColor = [UIColor whiteColor];
    //标题
    NSArray *titles = @[@"编号",@"主队",@"赛果",@"客队"];
    for (NSString * title in titles) {
        NSInteger index = [titles indexOfObject:title];
        
        CGFloat labelW = screenWidth / titles.count;
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(index * labelW, 0, labelW, 30)];
        titleLabel.text = titles[index];
        titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        titleLabel.textColor = YZBlackTextColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:titleLabel];
    }
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //关闭已打开的cell
    NSMutableArray * indexPaths = [NSMutableArray array];
    for (int i = 0; i < self.dataArray.count; i++) {
        YZWinNumberFBStatus * status = self.dataArray[i];
        if (status.open && indexPath.row != i) {
            status.open = NO;
            NSIndexPath * openIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPaths addObject:openIndexPath];
        }
    }
    //点击的indexPath
    YZWinNumberFBStatus * status = self.dataArray[indexPath.row];
    status.open = !status.open;//取反,打开/关闭
    [indexPaths addObject:indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark - 立即投注
- (void)betButtonClick
{
    YZGameIdViewController *destVc = (YZGameIdViewController *)[[[YZTool gameDestClassDict][self.gameId] alloc] initWithGameId:self.gameId];
    [self.navigationController pushViewController:destVc animated:YES];
}
#pragma mark - 初始化
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSString *)dateStr
{
    if (_dateStr == nil) {
        _dateStr = @"近期比赛";
    }
    return _dateStr;
}
@end
