//
//  YZSetmealRecordViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/7/11.
//  Copyright © 2018年 9ge. All rights reserved.
//
#define monthViewH 30

#import "YZSetmealRecordViewController.h"
#import "YZSchemeDetailsViewController.h"
#import "YZOrderTableViewCell.h"
#import "YZNoOrderTableViewCell.h"
#import "YZOrderSectionStatus.h"
#import "YZDateTool.h"

@interface YZSetmealRecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIButton * backTopBtn;
@property (nonatomic, weak) MJRefreshGifHeader *header;
@property (nonatomic, weak) MJRefreshBackGifFooter *footer;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, strong) NSMutableArray *schemeList;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YZSetmealRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"套餐记录";
    [self setupChilds];
    waitingView_loadingData;
    self.pageIndex = 0;
    [self loadData];
}

#pragma mark - 请求数据
- (void)loadData
{
    NSDictionary *dict = @{
                           @"cmd":@(12500),
                           @"userId":UserId,
                           @"pageIndex":@(self.pageIndex),
                           @"pageSize":@(10)
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"%@", json);
        if (SUCCESS) {
            NSArray *  schemeList = [YZOrderStatus objectArrayWithKeyValuesArray:json[@"schemeList"]];
            [self.schemeList addObjectsFromArray:schemeList];
            [self setMonthStatus];
            //结束刷新
            [self.tableView reloadData];
            [self.header endRefreshing];
            if (self.schemeList.count == 0) {//有数据才能滑动
                self.tableView.scrollEnabled = NO;
            }else
            {
                self.tableView.scrollEnabled = YES;
            }
            if (schemeList.count == 0) {//没有新的数据
                [self.footer endRefreshingWithNoMoreData];
            }else
            {
                [self.footer endRefreshing];
            }
        }else
        {
            ShowErrorView;
            [self.tableView reloadData];
            [self.header endRefreshing];
            [self.footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView reloadData];
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}

- (void)setMonthStatus
{
    if (self.schemeList.count == 0) return;//没有数据就return
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //获得当前时间的月份
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    for (int i = 0; i < self.schemeList.count; i++) {//月份
        YZOrderStatus *status = self.schemeList[i];
        NSString * year = [status.createTime substringWithRange:NSMakeRange(0, 4)];
        NSString * month = [status.createTime substringWithRange:NSMakeRange(5, 2)];
        NSDate * date = [YZDateTool getDateFromDateString:status.createTime format:@"yyyy-MM-dd HH:mm:ss"];
        if (date.isToday) {
            status.month = @"今天";
        }else if (date.isYesterday)
        {
            status.month = @"昨天";
        }else if ([month integerValue] == nowCmps.month && [year integerValue] == nowCmps.year)
        {
            status.month = @"本月";
        }else
        {
            status.month = [NSString stringWithFormat:@"%d月",[month intValue]];
        }
    }
    //对数据进行时间分组后的数组，元素是数组，元素数组的元素的时间是同一月
    NSMutableArray *timeSortedStatusArray = [NSMutableArray array];
    for(int i = 0;i < self.schemeList.count;i++)
    {
        YZOrderStatus *status = self.schemeList[i];
        if(i == 0)//先把第一个放进去
        {
            NSMutableArray *muArr = [NSMutableArray array];
            [muArr addObject:status];
            [timeSortedStatusArray addObject:muArr];
        }else
        {
            NSMutableArray *muArr = [timeSortedStatusArray lastObject];
            YZOrderStatus *lastStatus = [muArr lastObject];
            //对code进行比较，是否同一月
            BOOL isequalMonth = [status.month isEqualToString:lastStatus.month];
            if(isequalMonth)//同一月
            {
                [muArr addObject:status];
            }else//不是同一月
            {
                //新建一个数组放不同时间的数据，数组放入timeSortedStatusArray
                NSMutableArray *muArr = [NSMutableArray array];
                [muArr addObject:status];
                [timeSortedStatusArray addObject:muArr];
            }
        }
    }
    [self.dataArray removeAllObjects];//先清空之前的数据
    for(int i = 0;i < timeSortedStatusArray.count;i++)
    {
        YZOrderSectionStatus *sectionStatus = [[YZOrderSectionStatus alloc] init];
        sectionStatus.array = timeSortedStatusArray[i];//比赛信息
        YZOrderStatus *status = [sectionStatus.array firstObject];
        sectionStatus.title = status.month;//section标题
        [self.dataArray addObject:sectionStatus];
    }
}

#pragma mark - 初始化视图
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
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    
    //初始化头部刷新控件
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderData:header];
    self.header = header;
    self.tableView.mj_header = header;
    
    //初始化底部刷新控件
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshViewBeginRefreshing)];
    [YZTool setRefreshFooterData:footer];
    self.footer = footer;
    tableView.mj_footer = footer;
    
    //回到顶部按钮
    UIButton * backTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backTopBtn = backTopBtn;
    CGFloat backTopBtnW = 27;
    CGFloat backTopBtnH = 83;
    CGFloat backTopBtnX = screenWidth - backTopBtnW - 20;
    CGFloat backTopBtnY = screenHeight - statusBarH - navBarH - backTopBtnH - 20;
    backTopBtn.frame = CGRectMake(backTopBtnX, backTopBtnY, backTopBtnW, backTopBtnH);
    backTopBtn.hidden = YES;
    [backTopBtn setBackgroundImage:[UIImage imageNamed:@"order_backTop"] forState:UIControlStateNormal];
    [backTopBtn addTarget:self action:@selector(backTopBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backTopBtn];
}

- (void)backTopBtnDidClick
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma  mark - 刷新
- (void)headerRefreshViewBeginRefreshing
{
    //清空数据
    self.pageIndex = 0;
    [self.schemeList removeAllObjects];
    [self loadData];
}

- (void)footerRefreshViewBeginRefreshing
{
    self.pageIndex++;
    [self loadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.schemeList.count == 0) {//没有数据时
        return 1;
    }
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.schemeList.count == 0) {//没有数据时
        return 1;
    }
    YZOrderSectionStatus *sectionStatus = self.dataArray[section];
    return sectionStatus.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.schemeList.count == 0) {
        YZNoOrderTableViewCell * cell = [YZNoOrderTableViewCell cellWithTableView:tableView];
        cell.owner = self;
        return cell;
    }else
    {
        YZOrderSectionStatus *sectionStatus = self.dataArray[indexPath.section];
        YZOrderTableViewCell * cell = [YZOrderTableViewCell cellWithTableView:tableView];
        YZOrderStatus *status = sectionStatus.array[indexPath.row];
        status.index = 1;
        cell.status = status;
        //当是最后一条数据时，不显示分割线
        if (status == sectionStatus.array.lastObject && sectionStatus != self.dataArray.lastObject) {
            cell.line.hidden = YES;
        }else
        {
            cell.line.hidden = NO;
        }
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.schemeList.count == 0) {//没有数据时
        return tableView.height;
    }else
    {
        return 61;
    }
}
//区头
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.schemeList.count == 0)
    {
        return 0;
    }
    return monthViewH;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.schemeList.count == 0) {
        return nil;
    }
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, monthViewH)];
    headerView.backgroundColor = YZColor(246, 245, 250, 1);
    
    //label
    UILabel * monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, screenWidth - 20, monthViewH)];
    YZOrderSectionStatus *sectionStatus = self.dataArray[section];
    monthLabel.text = sectionStatus.title;
    monthLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    monthLabel.textColor = YZColor(60, 59, 59, 1);
    [headerView addSubview:monthLabel];
    
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.schemeList.count == 0) {//没有数据时
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YZOrderSectionStatus *sectionStatus = self.dataArray[indexPath.section];
    YZOrderStatus *status = sectionStatus.array[indexPath.row];
    YZSchemeDetailsViewController *schemeDetail = [[YZSchemeDetailsViewController alloc] init];
    schemeDetail.schemeId = status.schemeId;
    schemeDetail.gameId = status.gameId;
    [self.navigationController pushViewController:schemeDetail animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[UITableView class]]) {//uitableview的偏移量
        CGFloat contentOffsetY = scrollView.contentOffset.y;
        if (contentOffsetY >= 20 * 61) {//大于20条数据才显示
            self.backTopBtn.hidden = NO;
        }else
        {
            self.backTopBtn.hidden = YES;
        }
    }
}

#pragma mark - 初始化
- (NSMutableArray *)schemeList
{
    if(_schemeList == nil)
    {
        _schemeList = [NSMutableArray array];
    }
    return _schemeList;
}
- (NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
