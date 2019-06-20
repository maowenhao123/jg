//
//  YZCircleViewAttentionViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleViewAttentionViewController.h"
#import "YZCircleViewAttentionTableViewCell.h"

@interface YZCircleViewAttentionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) MJRefreshGifHeader *header;
@property (nonatomic, weak) MJRefreshBackGifFooter *footer;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) int pageIndex;

@end

@implementation YZCircleViewAttentionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.isFans) {
        self.title = @"我的粉丝";
    }else
    {
        self.title = @"我关注的人";
    }
    [self setupChilds];
    waitingView_loadingData;
    self.pageIndex = 0;
    [self getData];
}

#pragma mark - 请求数据
- (void)getData
{
    NSNumber * status = self.isFans ? @(1) : @(2);
    NSDictionary *dict = @{
                           @"userId": UserId,
                           @"status": status,
                           @"pageIndex": @(self.pageIndex),
                           @"pageSize": @(10)
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlCircle(@"/getByConcernMineUser") params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"getByConcernMineUser:%@",json);
        if (SUCCESS){
            NSArray * dataArray = json[@"users"];
            [self.dataArray addObjectsFromArray:dataArray];
            //结束刷新
            [self.tableView reloadData];
            [self.header endRefreshing];
            if (dataArray.count == 0) {//没有新的数据
                [self.footer endRefreshingWithNoMoreData];
            }else
            {
                [self.footer endRefreshing];
            }
        }else
        {
            ShowErrorView
            [self.tableView reloadData];
            [self.header endRefreshing];
            [self.footer endRefreshing];
        }
    }failure:^(NSError *error)
    {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"error = %@",error);
        [self.tableView reloadData];
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}

#pragma mark - 布局子视图
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
}

#pragma  mark - 刷新
- (void)headerRefreshViewBeginRefreshing
{
    //清空数据
    self.pageIndex = 0;
    [self.dataArray removeAllObjects];
    [self getData];
}

- (void)footerRefreshViewBeginRefreshing
{
    self.pageIndex++;
    [self getData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //    return self.dataArray.count;
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZCircleViewAttentionTableViewCell * cell = [YZCircleViewAttentionTableViewCell cellWithTableView:tableView];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 初始化
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
