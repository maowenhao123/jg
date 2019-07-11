//
//  YZMoneyDetailViewController.m
//  ez
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define tableViewCount 3

#import "YZMoneyDetailViewController.h"
#import "YZMoneyDetailTableViewCell.h"
#import "YZNoDataTableViewCell.h"
#import "YZMoneyDetail.h"

@interface YZMoneyDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *tradeListArray;
@property (nonatomic, assign) int pageIndex1;//彩金的页数
@property (nonatomic, assign) int pageIndex2;//奖金的页数
@property (nonatomic, assign) int pageIndex3;//积分的页数
@property (nonatomic, assign) int currentPageIndex;//当前的页数
@property (nonatomic, strong) NSMutableArray *headerViews;
@property (nonatomic, strong) NSMutableArray *footerViews;

@end

@implementation YZMoneyDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"资金明细";
    //初始化顶
    [self configurationChilds];
}
#pragma  mark - 初始化
- (void)configurationChilds
{
    //添加3个btnTitle
    self.btnTitles = @[@"彩金", @"奖金", @"积分"];
    //添加3个tableview
    CGFloat scrollViewH = screenHeight - statusBarH - navBarH - topBtnH;
    for(int i = 0;i < tableViewCount;i++)
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
    [super topBtnClick:self.topBtns[self.currentIndex]];
}
- (void)changeCurrentIndex:(int)currentIndex
{
    //没有数据时加载数据
    NSMutableArray *tradeList = self.tradeListArray[currentIndex];
    if(tradeList.count == 0)
    {
        [self getAccountDetailDataWithTag:currentIndex];
    }
}
#pragma mark - MJRefresh的代理方法
- (void)headerRefreshViewBeginRefreshing
{
    NSMutableArray *tradeList = self.tradeListArray[self.currentIndex];
    if(tradeList.count)
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
        }
        self.currentPageIndex = 0;
    }
    [self.tradeListArray[self.currentIndex] removeAllObjects];
    //加载数据
    [self getAccountDetailDataWithTag:self.currentIndex];
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
    [self getAccountDetailDataWithTag:self.currentIndex];
}
#pragma  mark - 获取账户明细的数据
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self headerRefreshViewBeginRefreshing];
}
- (void)getAccountDetailDataWithTag:(int)tag
{
    int type = tag + 1;
    if (tag == 2) {
        type += 1;
    }
    NSDictionary *dict = @{
                           @"cmd":@(8029),
                           @"userId":UserId,
                           @"type":@(type),
                           @"pageIndex":@(self.currentPageIndex),
                           @"pageSize":@(10)
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UITableView *tableView = self.views[self.currentIndex];
        if (SUCCESS) {
            NSArray * tradeList_data = json[@"tradeList"];
            NSMutableArray *currrentTradeList = self.tradeListArray[self.currentIndex];
            NSArray * tradeList = [YZMoneyDetail objectArrayWithKeyValuesArray:tradeList_data];//转模型数组
            [currrentTradeList addObjectsFromArray:tradeList];
            [tableView reloadData];//刷新
            [self.headerViews[self.currentIndex] endRefreshing];
            if (tradeList.count == 0) {//没有新的数据
                [self.footerViews[self.currentIndex] endRefreshingWithNoMoreData];
            }else
            {
                [self.footerViews[self.currentIndex] endRefreshing];
            }
        }else
        {
            [tableView reloadData];//刷新
            [self.headerViews[self.currentIndex] endRefreshing];
            [self.footerViews[self.currentIndex] endRefreshing];
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UITableView *tableView = self.views[self.currentIndex];
        [tableView reloadData];//刷新
        [self.headerViews[self.currentIndex] endRefreshing];
        [self.footerViews[self.currentIndex] endRefreshing];
        YZLog(@"getAccountDetailData请求error");
    }];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *tradeList = self.tradeListArray[self.currentIndex];
    return tradeList.count > 0 ? tradeList.count : 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tradeList = self.tradeListArray[self.currentIndex];
    if (tradeList.count == 0) {//没有数据时
        YZNoDataTableViewCell *cell = [YZNoDataTableViewCell cellWithTableView:tableView cellId:@"noMessageCell"];
        cell.imageName = @"no_recharge";
        cell.noDataStr = [NSString stringWithFormat:@"暂时没有%@记录",self.btnTitles[self.currentIndex]];
        return cell;
    }else
    {
        YZMoneyDetailTableViewCell * cell = [YZMoneyDetailTableViewCell cellWithTableView:tableView];
        cell.type = self.currentIndex + 1;
        YZMoneyDetail * status = tradeList[indexPath.row];
        cell.status = status;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *tradeList = self.tradeListArray[self.currentIndex];
    return tradeList.count == 0 ? tableView.height * 0.7 : 65;
}
#pragma mark - 初始化
- (NSMutableArray *)tradeListArray
{
    if(_tradeListArray == nil)
    {
        _tradeListArray = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            NSMutableArray * array = [NSMutableArray array];
            [_tradeListArray addObject:array];
        }
    }
    return _tradeListArray;
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
