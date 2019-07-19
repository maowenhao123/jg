//
//  YZOrderViewController.m
//  ez
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define monthViewH 30

#import "YZOrderViewController.h"
#import "YZFCOrderDetailViewController.h"
#import "YZFBOrderDetailViewController.h"
#import "YZSchemeDetailsViewController.h"
#import "YZUnionBuyDetailViewController.h"
#import "YZOrderTableViewCell.h"
#import "YZNoOrderTableViewCell.h"
#import "YZOrderSectionStatus.h"
#import "YZOrderStatus.h"
#import "YZDateTool.h"
#import "NSDate+YZ.h"

@interface YZOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UIButton * backTopBtn;
@property (nonatomic, assign) int pageIndex1;//投注
@property (nonatomic, assign) int pageIndex2;//追号
@property (nonatomic, assign) int pageIndex3;//中奖
@property (nonatomic, assign) int pageIndex4;//合买
@property (nonatomic, strong) NSMutableArray *headerViews;
@property (nonatomic, strong) NSMutableArray *footerViews;
@property (nonatomic, strong) NSMutableArray *orderListArray;
@property (nonatomic, strong) NSMutableArray *orderSectionListArray;

@end

@implementation YZOrderViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //初始化
        self.pageIndex1 = 0;
        self.pageIndex2 = 0;
        self.pageIndex3 = 0;
        self.pageIndex4 = 0;
        [self configurationChilds];
        [self setupChilds];
        //接收登录成功通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:loginSuccessNote object:nil];
        //接收需要刷新账户中心的纪录的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRecord:) name:RefreshRecordNote object:nil];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的订单";
}
#pragma  mark - 接到通知
- (void)loginSuccess
{
    //初始化
    self.pageIndex1 = 0;
    self.pageIndex2 = 0;
    self.pageIndex3 = 0;
    self.pageIndex4 = 0;
    for (NSMutableArray * orderArray in self.orderListArray) {
        [orderArray removeAllObjects];
    }
    [self getRecordList];
}
//刷新我的投注记录、追号记录、中奖记录
- (void)refreshRecord:(NSNotification *)note
{
    NSInteger index = [note.object integerValue];
    //删除数据
    [self.orderListArray[index] removeAllObjects];
    if(index == 0)
    {
        self.pageIndex1 = 0;
    }else if(index == 1)
    {
        self.pageIndex2 = 0;
    }else if(index == 2)
    {
        self.pageIndex3 = 0;
    }else if(index == 3)
    {
        self.pageIndex4 = 0;
    }

    if(self.currentIndex != index)
    {
        [super topBtnClick:self.topBtns[index]];
        [self.scrollView setContentOffset:CGPointMake(index * screenWidth, 0) animated:YES];
    }else
    {
        [self getRecordList];
    }
    
    //移动到最顶部
    [self.views[index] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}
#pragma  mark - 初始化
- (void)configurationChilds
{
    //添加btnTitle
    self.btnTitles = @[@"投注记录", @"追号记录", @"中奖记录", @"合买记录"];
    //添加tableview
    CGFloat scrollViewH = screenHeight - statusBarH - navBarH - tabBarH - topBtnH;
    for(int i = 0; i < self.btnTitles.count; i++)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, scrollViewH)];
        tableView.tag = i;
        tableView.backgroundColor = YZBackgroundColor;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
        [self.views addObject:tableView];
        
        //初始化头部刷新控件
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
        [YZTool setRefreshHeaderData:header];
        [self.headerViews addObject:header];
        tableView.mj_header = header;
        
        //初始化底部刷新控件
        MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshViewBeginRefreshing)];
        [YZTool setRefreshFooterData:footer];
        [self.footerViews addObject:footer];
        tableView.mj_footer = footer;
    }
    //完成配置
    [super configurationComplete];
    [super topBtnClick:self.topBtns[self.currentIndex]];
}
#pragma mark - MJRefresh的代理方法
- (void)headerRefreshViewBeginRefreshing
{
    if(self.currentIndex == 0)
    {
        self.pageIndex1 = 0;
    }else if(self.currentIndex == 1)
    {
        self.pageIndex2 = 0;
    }else if(self.currentIndex == 2)
    {
        self.pageIndex3 = 0;
    }else if(self.currentIndex == 3)
    {
        self.pageIndex4 = 0;
    }
    //清空数据
    NSMutableArray *orderList = self.orderListArray[self.currentIndex];
    [orderList removeAllObjects];
    //加载数据
    [self getRecordList];
}
- (void)footerRefreshViewBeginRefreshing
{
    if(self.currentIndex == 0)
    {
        self.pageIndex1 += 1;
    }else if(self.currentIndex == 1)
    {
        self.pageIndex2 += 1;
    }else if(self.currentIndex == 2)
    {
        self.pageIndex3 += 1;
    }else if(self.currentIndex == 3)
    {
        self.pageIndex4 += 1;
    }
    //加载数据
    [self getRecordList];
}
- (void)setupChilds
{
    //回到顶部按钮
    UIButton * backTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backTopBtn = backTopBtn;
    CGFloat backTopBtnW = 27;
    CGFloat backTopBtnH = 83;
    CGFloat backTopBtnX = screenWidth - backTopBtnW - 20;
    CGFloat backTopBtnY = screenHeight - statusBarH - navBarH - tabBarH - backTopBtnH - 20;
    backTopBtn.frame = CGRectMake(backTopBtnX, backTopBtnY, backTopBtnW, backTopBtnH);
    backTopBtn.hidden = YES;
    [backTopBtn setBackgroundImage:[UIImage imageNamed:@"order_backTop"] forState:UIControlStateNormal];
    [backTopBtn addTarget:self action:@selector(backTopBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backTopBtn];
}
- (void)backTopBtnDidClick
{
    UITableView *tableView = self.views[self.currentIndex];
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
- (void)changeCurrentIndex:(int)currentIndex
{
     //没有数据时加载数据
    if([self getDataCount] == 0)
    {
        [self getRecordList];
    }
    UITableView *tableView = self.views[self.currentIndex];
    CGFloat contentOffsetY = tableView.contentOffset.y;
    if (contentOffsetY >= 20 * 61) {
        self.backTopBtn.hidden = NO;
    }else
    {
        self.backTopBtn.hidden = YES;
    }
}
#pragma  mark - 获取我的投注记录、追号记录、合买记录的数据
- (void)getRecordList
{
    MJRefreshGifHeader *header = self.headerViews[self.currentIndex];
    MJRefreshAutoGifFooter *footer = self.footerViews[self.currentIndex];

    if (!UserId)//没有登录时
    {
        //结束刷新
        [header endRefreshing];
        [footer endRefreshing];
        return;
    }
    
    NSNumber *cmd = nil;
    NSNumber *pageIndex = nil;
    if(self.currentIndex == 0)
    {
        cmd = @(8021);//投注记录
        pageIndex = @(self.pageIndex1);
    }else if(self.currentIndex == 1)
    {
        cmd = @(8023);//追号记录
        pageIndex = @(self.pageIndex2);
    }else if(self.currentIndex == 2)
    {
        cmd = @(10810);//中奖记录
        pageIndex = @(self.pageIndex3);
    }else
    {
        cmd = @(8123);//合买记录
        pageIndex = @(self.pageIndex4);
    }
    NSDictionary *dict = @{
                           @"cmd":cmd,
                           @"userId":UserId,
                           @"pageIndex":pageIndex,
                           @"pageSize":@(10)
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        UITableView *tableView = self.views[self.currentIndex];
        if (SUCCESS) {
            NSMutableArray *oldOrderList = self.orderListArray[self.currentIndex];
            NSArray *orderList = [NSArray array];
            if (self.currentIndex == 0) {
                orderList = [YZOrderStatus objectArrayWithKeyValuesArray:json[@"orderList"]];
                [oldOrderList addObjectsFromArray:orderList];
            }else if (self.currentIndex == 1)
            {
                orderList = [YZOrderStatus objectArrayWithKeyValuesArray:json[@"schemeList"]];
                [oldOrderList addObjectsFromArray:orderList];
            }else if (self.currentIndex == 2)
            {
                orderList = [YZOrderStatus objectArrayWithKeyValuesArray:json[@"orderList"]];
                [oldOrderList addObjectsFromArray:orderList];
            }else if (self.currentIndex == 3)
            {
                orderList = [YZOrderStatus objectArrayWithKeyValuesArray:json[@"unionBuys"]];
                [oldOrderList addObjectsFromArray:orderList];
            }
            [self setMonthStatus];
            
            if ([self getDataCount] == 0) {//有数据才能滑动
                tableView.scrollEnabled = NO;
            }else
            {
                tableView.scrollEnabled = YES;
            }
            [tableView reloadData];//刷新数据
            if (orderList.count == 0) {//没有新的数据
                [footer endRefreshingWithNoMoreData];
            }else
            {
                [footer endRefreshing];
            }
            //结束刷新
            [header endRefreshing];
        }else
        {
            ShowErrorView;
            [tableView reloadData];
            //结束刷新
            [header endRefreshing];
            [footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        UITableView *tableView = self.views[self.currentIndex];
        [tableView reloadData];
        //结束刷新
        [header endRefreshing];
        [footer endRefreshing];
        YZLog(@"getOrderList请求error");
    }];
}
- (void)setMonthStatus
{
    if ([self getDataCount] == 0) return;//没有数据就return
    NSCalendar *calendar = [NSCalendar currentCalendar];
    //获得当前时间的月份
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    NSMutableArray *orderList = self.orderListArray[self.currentIndex];
    for (int i = 0; i < orderList.count; i++) {//月份
        YZOrderStatus *status = orderList[i];
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
        status.index = self.currentIndex;
    }
    //对数据进行时间分组后的数组，元素是数组，元素数组的元素的时间是同一月
    NSMutableArray *timeSortedStatusArray = [NSMutableArray array];
    for(int i = 0;i < orderList.count;i++)
    {
        YZOrderStatus *status = orderList[i];
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
    NSMutableArray *orderSectionList = self.orderSectionListArray[self.currentIndex];
    [orderSectionList removeAllObjects];//先清空之前的数据
    for(int i = 0;i < timeSortedStatusArray.count;i++)
    {
        YZOrderSectionStatus *sectionStatus = [[YZOrderSectionStatus alloc] init];
        sectionStatus.array = timeSortedStatusArray[i];//比赛信息
        YZOrderStatus *status = [sectionStatus.array firstObject];
        sectionStatus.title = status.month;//section标题
        [orderSectionList addObject:sectionStatus];
    }
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self getDataCount] == 0) {//没有数据时
        return 1;
    }
    NSMutableArray *orderSectionList = self.orderSectionListArray[self.currentIndex];
    return orderSectionList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self getDataCount] == 0) {//没有数据时
        return 1;
    }
    NSMutableArray *orderSectionList = self.orderSectionListArray[self.currentIndex];
    YZOrderSectionStatus *sectionStatus = orderSectionList[section];
    return sectionStatus.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self getDataCount] == 0) {
        YZNoOrderTableViewCell * cell = [YZNoOrderTableViewCell cellWithTableView:tableView];
        cell.owner = self;
        return cell;
    }else
    {
        NSMutableArray *orderSectionList = self.orderSectionListArray[self.currentIndex];
        YZOrderSectionStatus *sectionStatus = orderSectionList[indexPath.section];
        YZOrderTableViewCell * cell = [YZOrderTableViewCell cellWithTableView:tableView];
        YZOrderStatus *status = sectionStatus.array[indexPath.row];
        cell.status = status;
        cell.index = self.currentIndex + 1;
        //当是最后一条数据时，不显示分割线
        if (status == sectionStatus.array.lastObject && sectionStatus != orderSectionList.lastObject) {
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
    if ([self getDataCount] == 0) {//没有数据时
        return tableView.height;
    }else
    {
        return 66;
    }
}
//区头
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self getDataCount] == 0)
    {
        return 0;
    }
    return monthViewH;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self getDataCount] == 0) {
        return nil;
    }
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, monthViewH)];
    headerView.backgroundColor = YZColor(246, 245, 250, 1);
    
    //label
    UILabel * monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, screenWidth - 20, monthViewH)];
    NSMutableArray *orderSectionList = self.orderSectionListArray[self.currentIndex];
    YZOrderSectionStatus *sectionStatus = orderSectionList[section];
    monthLabel.text = sectionStatus.title;
    monthLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    monthLabel.textColor = YZColor(60, 59, 59, 1);
    [headerView addSubview:monthLabel];
    
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self getDataCount] == 0) {//没有数据时
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableArray *orderSectionList = self.orderSectionListArray[self.currentIndex];
    YZOrderSectionStatus *sectionStatus = orderSectionList[indexPath.section];
    YZOrderStatus *status = sectionStatus.array[indexPath.row];
    if(tableView.tag == 0 || tableView.tag == 2)
    {
        NSString * gameId = status.gameId;
        NSString * orderId = status.orderId;
        if ([gameId isEqualToString:@"T51"] || [gameId isEqualToString:@"T52"]) {//竞彩
            YZFBOrderDetailViewController *FBOrderDetailVc = [[YZFBOrderDetailViewController alloc] init];
            FBOrderDetailVc.orderId = orderId;
            [self.navigationController pushViewController:FBOrderDetailVc animated:YES];
        }else
        {
            YZFCOrderDetailViewController *FCOrderDetailVc = [[YZFCOrderDetailViewController alloc] init];
            FCOrderDetailVc.gameId = gameId;
            FCOrderDetailVc.orderId = orderId;
            [self.navigationController pushViewController:FCOrderDetailVc animated:YES];
        }
    }else if(tableView.tag == 1)
    {
        YZSchemeDetailsViewController *schemeDetail = [[YZSchemeDetailsViewController alloc] init];
        schemeDetail.schemeId = status.schemeId;
        schemeDetail.gameId = status.gameId;
        [self.navigationController pushViewController:schemeDetail animated:YES];
    }else if (tableView.tag == 3)
    {
        YZUnionBuyDetailViewController *unionBuyDetail = [[YZUnionBuyDetailViewController alloc] initWithUnionBuyUserId:status.unionBuyUserId unionBuyPlanId:status.unionBuyPlanId gameId:status.gameId];
        unionBuyDetail.title = @"合买详情";
        [self.navigationController pushViewController:unionBuyDetail animated:YES];
    }
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
- (NSMutableArray *)orderListArray
{
    if(_orderListArray == nil)
    {
        _orderListArray = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            NSMutableArray * array = [NSMutableArray array];
            [_orderListArray addObject:array];
        }
    }
    return _orderListArray;
}
- (NSMutableArray *)orderSectionListArray
{
    if(_orderSectionListArray == nil)
    {
        _orderSectionListArray = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            NSMutableArray * array = [NSMutableArray array];
            [_orderSectionListArray addObject:array];
        }
    }
    return _orderSectionListArray;
}
- (NSMutableArray *)headerViews
{
    if(_headerViews == nil)
    {
        _headerViews = [NSMutableArray array];
    }
    return _headerViews;
}
- (NSMutableArray *)footerViews
{
    if(_footerViews == nil)
    {
        _footerViews = [NSMutableArray array];
    }
    return _footerViews;
}
#pragma mark - 工具
//计算当前的数据数
- (int)getDataCount
{
    NSMutableArray *orderList = self.orderListArray[self.currentIndex];
    return (int)orderList.count;
}
@end
