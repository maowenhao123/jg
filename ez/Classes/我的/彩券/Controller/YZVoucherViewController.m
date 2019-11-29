
//
//  YZVoucherViewController.m
//  ez
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 9ge. All rights reserved.
//
#import "YZVoucherViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZVoucherTableViewCell.h"
#import "YZNoDataTableViewCell.h"
#import "YZVoucherStatus.h"

@interface YZVoucherViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *respCouponListArray;
@property (nonatomic, assign) int pageIndex1;//未使用
@property (nonatomic, assign) int pageIndex2;//已用完
@property (nonatomic, assign) int pageIndex3;//已失效
@property (nonatomic, assign) int currentPageIndex;//当前的index
@property (nonatomic, strong) NSMutableArray *headerViews;
@property (nonatomic, strong) NSMutableArray *footerViews;

@end

@implementation YZVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的彩券";
    //初始化顶
    [self configurationChilds];
    //彩券说明
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"说明" style:UIBarButtonItemStylePlain target:self action:@selector(couponExplain)];
}
- (void)couponExplain
{
    YZLoadHtmlFileController *htmlVc = [[YZLoadHtmlFileController alloc] initWithFileName:@"couponExplain.htm"];
    htmlVc.title = @"彩券说明";
    [self.navigationController pushViewController:htmlVc animated:YES];
}
#pragma  mark - 初始化
- (void)configurationChilds
{
    //添加btnTitle
    self.btnTitles = @[@"未使用", @"已用完", @"已失效"];
    //添加tableview
    CGFloat scrollViewH = screenHeight-statusBarH-navBarH-topBtnH;
    for(int i = 0; i < self.btnTitles.count; i++)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, scrollViewH) style:UITableViewStyleGrouped];
        tableView.tag = i;
        tableView.backgroundColor = YZBackgroundColor;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
        [self.views addObject:tableView];
        
        //初始化头部刷新控件
        MJRefreshGifHeader *headerView = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
        [YZTool setRefreshHeaderData:headerView];
        [self.headerViews addObject:headerView];
        tableView.mj_header = headerView;
        
        //初始化底部刷新控件
        MJRefreshBackGifFooter *footerView = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshViewBeginRefreshing)];
        [YZTool setRefreshFooterData:footerView];
        [self.footerViews addObject:footerView];
        tableView.mj_footer = footerView;
    }
    //完成配置
    [super configurationComplete];
    waitingView_loadingData;
    [super topBtnClick:self.topBtns[0]];
}
#pragma mark - MJRefresh的代理方法
- (void)headerRefreshViewBeginRefreshing
{
    NSMutableArray *tradeList = self.respCouponListArray[self.currentIndex];
    if(tradeList.count)
    {
        if(self.currentIndex == 0)
        {
            self.pageIndex1 = 0;
            self.currentPageIndex = self.pageIndex1;
        }else if(self.currentIndex == 1)
        {
            self.pageIndex2 = 0;
            self.currentPageIndex = self.pageIndex2;
        }else if(self.currentIndex == 2)
        {
            self.pageIndex3 = 0;
            self.currentPageIndex = self.pageIndex3;
        }
    }
    [self.respCouponListArray[self.currentIndex] removeAllObjects];
    //加载数据
    [self getVoucherDetailDataWithTag:self.currentIndex];
}
- (void)footerRefreshViewBeginRefreshing
{
    if(self.currentIndex == 0)
    {
        self.pageIndex1 += 1;
        self.currentPageIndex = self.pageIndex1;
    }else if(self.currentIndex == 1)
    {
        self.pageIndex2 += 1;
        self.currentPageIndex = self.pageIndex2;
    }else if(self.currentIndex == 2)
    {
        self.pageIndex3 += 1;
        self.currentPageIndex = self.pageIndex3;
    }
    //加载数据
    [self getVoucherDetailDataWithTag:self.currentIndex];
    [self.footerViews[self.currentIndex] endRefreshing];
}
- (void)changeCurrentIndex:(int)currentIndex
{
    //没有数据时加载数据
    NSMutableArray *tradeList = self.respCouponListArray[currentIndex];
    if(tradeList.count == 0)
    {
        [self getVoucherDetailDataWithTag:currentIndex];
    }
}
#pragma  mark - 获取彩卷明细的数据
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self headerRefreshViewBeginRefreshing];
}
- (void)getVoucherDetailDataWithTag:(int)tag
{
    NSString * param;
    if (tag == 0)
    {
        param = @"/getUsableInactiveList";
    }else if (tag == 1)
    {
        param = @"/getFinishedList";
    }else if (tag == 2)
    {
        param = @"/getFailedList";
    }
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"pageIndex":@(self.currentPageIndex),
                           @"pageSize":@(10)
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithURL:BaseUrlCoupon(param) params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        YZLog(@"%@",json);
        UITableView *tableView = self.views[self.currentIndex];
        if (SUCCESS) {;
            NSArray * currrentTradeList = [YZVoucherStatus objectArrayWithKeyValuesArray:json[@"respCouponList"]];
            NSMutableArray *respCouponListArray = self.respCouponListArray[self.currentIndex];
            [respCouponListArray addObjectsFromArray:currrentTradeList];
            [tableView reloadData];
            [self.headerViews[self.currentIndex] endRefreshing];
            if (currrentTradeList.count == 0) {//没有新的数据
                [self.footerViews[self.currentIndex] endRefreshingWithNoMoreData];
            }else
            {
                [self.footerViews[self.currentIndex] endRefreshing];
            }
        }else
        {
            [tableView reloadData];
            [self.headerViews[self.currentIndex] endRefreshing];
            [self.footerViews[self.currentIndex] endRefreshing];
            ShowErrorView;
        }
    } failure:^(NSError *error)
    {
        UITableView *tableView = self.views[self.currentIndex];
        [tableView reloadData];
        [self.headerViews[self.currentIndex] endRefreshing];
        [self.footerViews[self.currentIndex] endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        YZLog(@"error = %@",error);
     }];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *respCouponList = self.respCouponListArray[self.currentIndex];
    return respCouponList.count == 0 ? 1 : respCouponList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *respCouponList = self.respCouponListArray[self.currentIndex];
    if (respCouponList.count == 0) {
        YZNoDataTableViewCell *cell = [YZNoDataTableViewCell cellWithTableView:tableView cellId:@"noVoucherCell"];
        cell.imageName = @"no_voucher";
        cell.noDataStr = @"暂时没有彩券";
        return cell;
    }else
    {
        YZVoucherTableViewCell * cell = [YZVoucherTableViewCell cellWithTableView:tableView];
        YZVoucherStatus * status = respCouponList[indexPath.section];
        cell.index = self.currentIndex + 1;
        cell.status = status;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *respCouponList = self.respCouponListArray[self.currentIndex];
    return respCouponList.count == 0 ? tableView.height * 0.7 : 82;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSArray *respCouponList = self.respCouponListArray[self.currentIndex];
    if (section == respCouponList.count - 1) {
        return 10;
    }
    return 0.01;
}
#pragma mark - 初始化
- (NSMutableArray *)respCouponListArray
{
    if(_respCouponListArray == nil)
    {
        _respCouponListArray = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            NSMutableArray * array = [NSMutableArray array];
            [_respCouponListArray addObject:array];
        }
    }
    return _respCouponListArray;
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

@end
