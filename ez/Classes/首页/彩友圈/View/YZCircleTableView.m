//
//  YZCircleTableView.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleTableView.h"
#import "YZCircleTableViewCell.h"
#import "YZNoDataTableViewCell.h"

@interface YZCircleTableView ()<UITableViewDelegate, UITableViewDataSource, CircleTableViewCellwDelegate>

@property (nonatomic, assign) int pageIndex;
@property (nonatomic, weak) MJRefreshGifHeader *headerView;
@property (nonatomic, weak) MJRefreshBackGifFooter *footerView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation YZCircleTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZBackgroundColor;
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self setEstimatedSectionHeaderHeightAndFooterHeight];
        self.pageIndex = 0;
        
        //初始化头部刷新控件
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
        [YZTool setRefreshHeaderData:header];
        self.headerView = header;
        self.mj_header = header;
        
        //初始化底部刷新控件
        MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshViewBeginRefreshing)];
        [YZTool setRefreshFooterData:footer];
        self.footerView = footer;
        self.mj_footer = footer;
    }
    return self;
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

#pragma mark - 请求数据
- (void)getData
{
    NSDictionary *dict = [NSDictionary dictionary];
    NSString * url = @"";
    if (self.type == CircleNewTopic) {
        url = BaseUrlInformation(@"/getTopicList");
        dict = @{
                 @"pageIndex":@(self.pageIndex),
                 @"pageSize":@(10)
                 };
    }else if (self.type == CircleCommunityTopic)
    {
        url = BaseUrlInformation(@"/getCommunityTopicList");
        if (YZStringIsEmpty(self.playTypeId)) {
            dict = @{
                     @"pageIndex":@(self.pageIndex),
                     @"pageSize":@(10),
                     @"communityId": self.communityId
                     };
        }else
        {
            dict = @{
                     @"pageIndex":@(self.pageIndex),
                     @"pageSize":@(10),
                     @"communityId": self.communityId,
                     @"playTypeId": self.playTypeId
                     };
        }
    }else if (self.type == CircleConcernTopic)
    {
        url = BaseUrlInformation(@"/getConcernTopicList");
        dict = @{
                 @"pageIndex":@(self.pageIndex),
                 @"pageSize":@(10),
                 @"userId": UserId
                 };
    }else if (self.type == CircleUserReleaseTopic)
    {
        url = BaseUrlInformation(@"/getUserReleaseTopicList");
        dict = @{
                 @"pageIndex":@(self.pageIndex),
                 @"pageSize":@(10),
                 @"beViewedUserId": self.userId,
                 @"userId": UserId
                 };
    }else if (self.type == CircleMineTopic)
    {
        url = BaseUrlInformation(@"/getMineTopicList");
        dict = @{
                 @"pageIndex":@(self.pageIndex),
                 @"pageSize":@(10),
                 @"userId": UserId
                 };
    }
    [MBProgressHUD showMessage:@"客官请稍后" toView:self];
    [[YZHttpTool shareInstance] postWithURL:url params:dict success:^(id json) {
        YZLog(@"getTopicList:%@",json);
        [MBProgressHUD hideHUDForView:self];
        if (SUCCESS){
            NSArray * dataArray = [YZCircleModel objectArrayWithKeyValuesArray:json[@"topics"]];
            for (YZCircleModel * circleModel in dataArray) {
                if (self.type == CircleNewTopic || self.type == CircleConcernTopic) {
                    circleModel.circleTableViewType = CircleTableViewList;
                }else if (self.type == CircleMineTopic)
                {
                    circleModel.circleTableViewType = CircleTableViewMine;
                }else if (self.type == CircleUserReleaseTopic)
                {
                    circleModel.circleTableViewType = CircleTableViewUser;
                }
                NSInteger index = [dataArray indexOfObject:circleModel];
                NSDictionary * extInfo = json[@"topics"][index][@"extInfo"];
                if (!YZDictIsEmpty(extInfo)) {
                    NSArray * ticketList = extInfo[@"ticketList"];
                    if (!YZArrayIsEmpty(ticketList) && [ticketList isKindOfClass:[NSArray class]]) {
                        circleModel.extInfo.description_ = extInfo[@"description"];
                        circleModel.extInfo.ticketList = [YZTicketList objectArrayWithKeyValuesArray:extInfo[@"ticketList"]];
                    }
                }
            }
            [self.dataArray addObjectsFromArray:dataArray];
            [self reloadData];
            [self.headerView endRefreshing];
            
            if (dataArray.count == 0) {//没有新的数据
                [self.footerView endRefreshingWithNoMoreData];
            }else
            {
                [self.footerView endRefreshing];
            }
        }else
        {
            ShowErrorView
            [self reloadData];
            [self.headerView endRefreshing];
            [self.footerView endRefreshing];
        }
    }failure:^(NSError *error)
    {
        YZLog(@"error = %@",error);
        [MBProgressHUD hideHUDForView:self];
        [self reloadData];
        [self.headerView endRefreshing];
        [self.footerView endRefreshing];
    }];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count == 0 ? 1 : self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        YZNoDataTableViewCell *cell = [YZNoDataTableViewCell cellWithTableView:tableView cellId:@"noCircleCell"];
        cell.imageName = @"no_recharge";
        cell.noDataStr = @"暂无数据";
        return cell;
    }else
    {
        YZCircleTableViewCell * cell = [YZCircleTableViewCell cellWithTableView:tableView];
        cell.circleModel = self.dataArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        return tableView.height * 0.7;
    }
    YZCircleModel *circleModel = self.dataArray[indexPath.row];
    return circleModel.cellH;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_circleDelegate && [_circleDelegate respondsToSelector:@selector(circleTableViewDidScroll:)]) {
        [_circleDelegate circleTableViewDidScroll:scrollView];
    }
}

- (void)circleTableViewCellDeleteButtonDidClickWithCell:(YZCircleTableViewCell *)cell
{
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认删除该帖子？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        YZCircleModel * circleModel = self.dataArray[indexPath.row];
        NSDictionary *dict = @{
                               @"userId": UserId,
                               @"topicId": circleModel.id,
                               };
        [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/deleteMineTopic") params:dict success:^(id json) {
            YZLog(@"deleteMineTopic:%@",json);
            if (SUCCESS){
                [self.dataArray removeObjectAtIndex:indexPath.row];
                if (self.dataArray.count == 0) {
                    [self reloadData];
                }else
                {
                    [self deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
    [self.viewController presentViewController:alertController animated:YES completion:nil];
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
