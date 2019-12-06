//
//  YZKy481ChartRenTableView.m
//  ez
//
//  Created by dahe on 2019/12/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481ChartRenTableView.h"
#import "YZKy481ChartRenTableViewCell.h"

@interface YZKy481ChartRenTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation YZKy481ChartRenTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZBackgroundColor;
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self setEstimatedSectionHeaderHeightAndFooterHeight];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [self reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZKy481ChartRenTableViewCell * cell = [YZKy481ChartRenTableViewCell cellWithTableView:tableView];
    if(indexPath.row % 2 != 0)
    {
        cell.backgroundColor = YZChartBackgroundColor;
    }else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.dataStatus = self.dataArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, CellH2)];
    headerView.backgroundColor = YZChartBackgroundColor;
    for(int i = 0; i < 10; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        if (i == 0) {
            label.frame = CGRectMake(0, 0, LeftLabelW2, CellH1);
            label.text = @"期次";
        }else if (i == 1)
        {
            label.frame = CGRectMake(LeftLabelW2, 0, LeftLabelW1, CellH1);
            label.text = @"奖号";
        }else
        {
            label.frame = CGRectMake(LeftLabelW1 + LeftLabelW2 + CellH1 * (i - 2), 0, CellH1, CellH1);
            label.text = [NSString stringWithFormat:@"%02d", i - 1];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        label.textColor = YZChartTitleColor;
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        label.layer.borderWidth = 0.25;
        [headerView addSubview:label];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellH1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CellH1;
}


@end
