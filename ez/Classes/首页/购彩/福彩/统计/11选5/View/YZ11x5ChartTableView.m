//
//  YZ11x5ChartTableView.m
//  ez
//
//  Created by dahe on 2019/12/6.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZ11x5ChartTableView.h"
#import "YZYZ11x5ChartTableViewCell.h"
#import "YZ11x5ChartLineView.h"

@interface YZ11x5ChartTableView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) YZ11x5ChartLineView * lineView;//线

@end

@implementation YZ11x5ChartTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZBackgroundColor;
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self setEstimatedSectionHeaderHeightAndFooterHeight];
        
        YZ11x5ChartLineView * lineView = [[YZ11x5ChartLineView alloc] init];
        self.lineView = lineView;
        lineView.backgroundColor = [UIColor clearColor];
        [self addSubview:lineView];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    [self reloadData];
    
    self.lineView.hidden = YES;
    if (self.chartCellTag != KChartCellTagAll) {
        NSString * showLineStr = [YZTool getChartSettingByTitle:@"折线"];
        if ([showLineStr isEqualToString:@"显示折线"]) {
            self.lineView.hidden = NO;
        }
        self.lineView.chartCellTag = self.chartCellTag;
        self.lineView.frame = CGRectMake(LeftLabelW, CellH, screenWidth, CellH * _dataArray.count);
        self.lineView.statusArray = _dataArray;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * tongjiStr = [YZTool getChartSettingByTitle:@"统计"];
    NSInteger tongjiCount = 0;
    if ([tongjiStr isEqualToString:@"显示统计"]) {//显示统计
        tongjiCount = 4;
    }
    return self.dataArray.count > 0 ? (self.dataArray.count + tongjiCount) : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZYZ11x5ChartTableViewCell * cell = [YZYZ11x5ChartTableViewCell cellWithTableView:tableView];
    if(indexPath.row % 2 != 0)
    {
        cell.backgroundColor = YZChartBackgroundColor;
    }else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.chartCellTag = self.chartCellTag;
    NSString * termCountStr = [YZTool getChartSettingByTitle:@"期数"];
    int termCount = [[termCountStr substringWithRange:NSMakeRange(1, termCountStr.length - 2)] intValue];
    if (indexPath.row < self.dataArray.count) {
        cell.dataStatus = self.dataArray[indexPath.row];
    }else
    {
        if (indexPath.row == self.dataArray.count)
        {
            cell.chartStatisticsTag = KChartCellTagCount;
        }else if (indexPath.row == self.dataArray.count + 1)
        {
            cell.chartStatisticsTag = KChartCellTagAvgMiss;
        }else if (indexPath.row == self.dataArray.count + 2)
        {
            cell.chartStatisticsTag = KChartCellTagMaxMiss;
        }else if (indexPath.row == self.dataArray.count + 3)
        {
            cell.chartStatisticsTag = KChartCellTagMaxSeries;
        }
        YZChartSortStatsStatus *stats;
        if (self.chartCellTag == KChartCellTagAll) {
            if (termCount == 30) {
                stats = self.stats.renxuan.stat30;
            }else if (termCount == 50)
            {
                stats = self.stats.renxuan.stat50;
            }else if (termCount == 100)
            {
                stats = self.stats.renxuan.stat100;
            }else if (termCount == 200)
            {
                stats = self.stats.renxuan.stat200;
            }
        }else
        {
            if (termCount == 30) {
                stats = self.stats.qian3_zhixuan.stat30;
            }else if (termCount == 50)
            {
                stats = self.stats.qian3_zhixuan.stat50;
            }else if (termCount == 100)
            {
                stats = self.stats.qian3_zhixuan.stat100;
            }else if (termCount == 200)
            {
                stats = self.stats.qian3_zhixuan.stat200;
            }
        }
        cell.status = stats;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, CellH)];
    headerView.backgroundColor = YZChartBackgroundColor;
    for(int i = 0; i < 12; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        if (i == 0) {
            label.frame = CGRectMake(0, 0, LeftLabelW, CellH);
            label.text = @"期次";
        }else
        {
            label.frame = CGRectMake(LeftLabelW + CellH * (i - 1), 0, CellH, CellH);
            label.text = [NSString stringWithFormat:@"%02d", i];
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
    return CellH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CellH;
}


@end
