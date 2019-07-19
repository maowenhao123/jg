//
//  YZCircleViewAttentionViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleViewAttentionViewController.h"
#import "YZCircleViewAttentionTableViewCell.h"
#import "YZNoDataTableViewCell.h"

@interface YZCircleViewAttentionViewController ()<UITableViewDelegate, UITableViewDataSource, YZCircleViewAttentionTableViewCellDelegate>

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
        self.title = @"粉丝列表";
    }else
    {
        self.title = @"关注列表";
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
                           @"userId": self.userId,
                           @"status": status,
                           @"pageIndex": @(self.pageIndex),
                           @"pageSize": @(10)
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getByConcernMineUser") params:dict success:^(id json) {
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
    return self.dataArray.count == 0 ? 1 : self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        YZNoDataTableViewCell *cell = [YZNoDataTableViewCell cellWithTableView:tableView cellId:@"noShareIncomeCell"];
        cell.imageName = @"no_recharge";
        cell.noDataStr = @"暂无数据";
        return cell;
    }else
    {
        YZCircleViewAttentionTableViewCell * cell = [YZCircleViewAttentionTableViewCell cellWithTableView:tableView];
        cell.dic = self.dataArray[indexPath.row];
        if (self.isFans || UserId != self.userId) {
            cell.cancelAttentionButon.hidden = YES;
        }else
        {
            cell.cancelAttentionButon.hidden = NO;
        }
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataArray.count == 0 ? tableView.height * 0.7 : 60;
}

- (void)circleViewAttentionTableViewCellAttentionBtnDidClick:(YZCircleViewAttentionTableViewCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSDictionary * dic = self.dataArray[indexPath.row];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"取消关注%@？", dic[@"nickname"]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *dict = @{
                               @"userId": UserId,
                               @"cancelUserId": dic[@"userId"],
                               };
        [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/cancelUserConcern") params:dict success:^(id json) {
            YZLog(@"cancelUserConcern:%@",json);
            if (SUCCESS){
                [self.dataArray removeObjectAtIndex:indexPath.row];
                if (self.dataArray.count == 0) {
                    [self.tableView reloadData];
                }else
                {
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            }else
            {
                ShowErrorView
            }
        }failure:^(NSError *error)
        {
            YZLog(@"error = %@",error);
        }];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
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
