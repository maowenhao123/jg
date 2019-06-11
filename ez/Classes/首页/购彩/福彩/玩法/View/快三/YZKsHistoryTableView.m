//
//  YZKsHistoryTableView.m
//  ez
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZKsHistoryTableView.h"
#import "YZKsHistoryTableViewCell.h"

#define cellH 25

@interface YZKsHistoryTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *recentStatus;//近期开奖数据

@end

@implementation YZKsHistoryTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self getDataArray];
    }
    return self;
}
- (void)getDataArray
{
    NSDictionary *dict = @{
                           @"cmd":@(8018),
                           @"gameId":@"F04",
                           @"pageIndex":@(0),
                           @"pageSize":@(10)
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            NSArray * termList = json[@"termList"];
            //倒序
            NSArray * recentStatus = [YZRecentLotteryStatus objectArrayWithKeyValuesArray:termList];
            self.recentStatus = [[recentStatus reverseObjectEnumerator] allObjects];
            [self reloadData];
            if (_historyDelegate && [_historyDelegate respondsToSelector:@selector(historyViewRecentStatus:)]) {
                [_historyDelegate historyViewRecentStatus:recentStatus];
            }
        }
    } failure:^(NSError *error) {

    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recentStatus.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZKsHistoryTableViewCell * cell = [YZKsHistoryTableViewCell cellWithTableView:tableView];
    if(indexPath.row % 2 != 0)
    {
        cell.backgroundColor = UIColorFromRGB(0xFFE7E7E7);
    }else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    YZRecentLotteryStatus *status = self.recentStatus[indexPath.row];
    cell.status = status;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return cellH;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
    headerView.backgroundColor = UIColorFromRGB(0xFFE7E7E7);
    
    CGFloat termLabelW = (screenWidth - 6 * cellH) * 2 / 8;
    CGFloat codeLabelW = (screenWidth - 6 * cellH) * 3 / 8;
    CGFloat typeLabelW = (screenWidth - 6 * cellH) * 3 / 8;
    
    UILabel * termLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, termLabelW, cellH)];
    termLabel.text = @"期";
    termLabel.font = [UIFont systemFontOfSize:13];
    termLabel.textAlignment = NSTextAlignmentCenter;
    termLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    termLabel.layer.borderWidth = 0.25;
    [headerView addSubview:termLabel];
    
    UILabel * codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(termLabel.frame), 0, codeLabelW, cellH)];
    codeLabel.text = @"奖号";
    codeLabel.font = [UIFont systemFontOfSize:13];
    codeLabel.textAlignment = NSTextAlignmentCenter;
    codeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    codeLabel.layer.borderWidth = 0.25;
    [headerView addSubview:codeLabel];
    
    for (int i = 1; i < 7; i++) {
        UILabel * winNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(codeLabel.frame) + (i - 1) * cellH, 0, cellH, cellH)];
        winNumberLabel.text = [NSString stringWithFormat:@"%d",i];
        winNumberLabel.font = [UIFont systemFontOfSize:13];
        winNumberLabel.textAlignment = NSTextAlignmentCenter;
        winNumberLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        winNumberLabel.layer.borderWidth = 0.25;
        [headerView addSubview:winNumberLabel];
    }
    
    UILabel * typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - typeLabelW, 0, typeLabelW, cellH)];
    int KsSelectedPlayTypeBtnTag = [YZUserDefaultTool getIntForKey:@"KsSelectedPlayTypeBtnTag"];
    if (KsSelectedPlayTypeBtnTag == 0) {
        typeLabel.text = @"和值";
    }else
    {
        typeLabel.text = @"类型";
    }
    typeLabel.font = [UIFont systemFontOfSize:13];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    typeLabel.layer.borderWidth = 0.25;
    [headerView addSubview:typeLabel];
    return headerView;
}
- (NSArray *)recentStatus
{
    if (_recentStatus == nil) {
        _recentStatus = [NSArray array];
    }
    return _recentStatus;
}
@end
