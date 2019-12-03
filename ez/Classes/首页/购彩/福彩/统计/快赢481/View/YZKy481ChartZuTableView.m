//
//  YZKy481ChartZuTableView.m
//  ez
//
//  Created by 毛文豪 on 2019/12/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481ChartZuTableView.h"

@interface YZKy481ChartZuTableView ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation YZKy481ChartZuTableView

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
    YZKy481ChartZuTableViewCell * cell = [YZKy481ChartZuTableViewCell cellWithTableView:tableView];
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
    NSArray * labelTexts = @[@"组4", @"组6", @"组12", @"组24", @"和值", @"跨度"];
    CGFloat labelW = (screenWidth - LeftLabelW1 - LeftLabelW2) / labelTexts.count;
    for(int i = 0; i < 2 + labelTexts.count; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        if (i == 0) {
            label.frame = CGRectMake(0, 0, LeftLabelW2, CellH2);
            label.text = @"期次";
        }else if (i == 1)
        {
            label.frame = CGRectMake(LeftLabelW2, 0, LeftLabelW1, CellH2);
            label.text = @"奖号";
        }else
        {
            label.frame = CGRectMake(LeftLabelW1 + LeftLabelW2 + labelW * (i - 2), 0, labelW, CellH2);
            label.text = labelTexts[i - 2];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        label.textColor = YZChartGrayColor;
        label.layer.borderColor = [UIColor lightGrayColor].CGColor;
        label.layer.borderWidth = 0.25;
        [headerView addSubview:label];
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellH2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CellH2;
}


@end
