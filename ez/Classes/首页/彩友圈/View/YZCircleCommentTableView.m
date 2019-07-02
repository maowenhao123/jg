//
//  YZCircleCommentTableView.m
//  ez
//
//  Created by dahe on 2019/6/27.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZCircleCommentTableView.h"
#import "YZCircleMineCommentTableViewCell.h"

@interface YZCircleCommentTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) int pageIndex;
@property (nonatomic, weak) MJRefreshGifHeader *headerView;
@property (nonatomic, weak) MJRefreshBackGifFooter *footerView;
@property (nonatomic, strong) NSMutableArray *dataArray;//近期开奖数据

@end

@implementation YZCircleCommentTableView

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
        
        [self getData];
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
    NSString * url = BaseUrlInformation(@"/getMineMessage");
    NSDictionary * dict = @{
             @"pageIndex":@(self.pageIndex),
             @"pageSize":@(10),
             @"userId": UserId
             };
    [[YZHttpTool shareInstance] postWithURL:url params:dict success:^(id json) {
        YZLog(@"getMineMessage:%@",json);
        if (SUCCESS){
            NSArray * dataArray = [YZCircleMineCommentModel objectArrayWithKeyValuesArray:json[@"topicReply"]];
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
         [self reloadData];
         [self.headerView endRefreshing];
         [self.footerView endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZCircleMineCommentTableViewCell* cell = [YZCircleMineCommentTableViewCell cellWithTableView:tableView];
    cell.commentModel = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZCircleMineCommentModel *commentModel = self.dataArray[indexPath.row];
    return commentModel.cellH;
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
