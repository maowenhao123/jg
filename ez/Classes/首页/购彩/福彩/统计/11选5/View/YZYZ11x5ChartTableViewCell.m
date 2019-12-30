//
//  YZYZ11x5ChartTableViewCell.m
//  ez
//
//  Created by dahe on 2019/12/6.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZYZ11x5ChartTableViewCell.h"

@interface YZYZ11x5ChartTableViewCell ()

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) UILabel * noDataLabel;

@end


@implementation YZYZ11x5ChartTableViewCell

+ (YZYZ11x5ChartTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZYZ11x5ChartTableViewCellId";
    YZYZ11x5ChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZYZ11x5ChartTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupChilds];
    }
    return self;
}

- (void)setupChilds
{
    for(int i = 0; i < 12; i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            button.frame = CGRectMake(0, 0, LeftLabelW, CellH);
            [button setTitleColor:YZChartTitleColor forState:UIControlStateNormal];
        }else
        {
            button.frame = CGRectMake(LeftLabelW + CellH * (i - 1), 0, CellH, CellH);
            [button setTitleColor:YZChartLightGrayColor forState:UIControlStateNormal];
        }
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 0.25;
        [self.contentView addSubview:button];
        [self.buttons addObject:button];
    }
    
    UILabel * noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(LeftLabelW, 0, screenWidth - LeftLabelW, CellH)];
    self.noDataLabel = noDataLabel;
    noDataLabel.text = @"等待开奖";
    noDataLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.textColor = YZChartLightGrayColor;
    noDataLabel.hidden = YES;
    [self addSubview:noDataLabel];
}

//设置数据
- (void)setStatus:(YZChartSortStatsStatus *)status
{
    _status = status;
    
    self.noDataLabel.hidden = YES;
    UIButton * button0 = self.buttons[0];
    NSArray * statisticsArray = [NSArray array];
    if (self.chartStatisticsTag == KChartCellTagCount)
    {
        [button0 setTitleColor:YZColor(97, 0, 135, 1) forState:UIControlStateNormal];
        [button0 setTitle:@"出现次数" forState:UIControlStateNormal];
        statisticsArray = _status.count;
    }else if (self.chartStatisticsTag == KChartCellTagAvgMiss)
    {
        [button0 setTitleColor:YZColor(47, 100, 0, 1) forState:UIControlStateNormal];
        [button0 setTitle:@"平均遗漏" forState:UIControlStateNormal];
        statisticsArray = _status.avgMiss;
    }else if (self.chartStatisticsTag == KChartCellTagMaxMiss)
    {
        [button0 setTitleColor:YZColor(108, 18, 0, 1) forState:UIControlStateNormal];
        [button0 setTitle:@"最大遗漏" forState:UIControlStateNormal];
        statisticsArray = _status.maxMiss;
    }else if (self.chartStatisticsTag == KChartCellTagMaxSeries)
    {
        [button0 setTitleColor:YZColor(1, 97, 146, 1) forState:UIControlStateNormal];
        [button0 setTitle:@"最大连出" forState:UIControlStateNormal];
        statisticsArray = _status.maxSeries;
    }
    
    NSArray * missArray = [NSArray array];
    if (self.chartCellTag == KChartCellTagAll) {
         missArray = statisticsArray;
    }else if (self.chartCellTag == KChartCellTagWan)
    {
        missArray = [statisticsArray subarrayWithRange:NSMakeRange(0, 11)];
    }else if (self.chartCellTag == KChartCellTagQian)
    {
        missArray = [statisticsArray subarrayWithRange:NSMakeRange(11, 11)];
    }else if (self.chartCellTag == KChartCellTagBai)
    {
        missArray = [statisticsArray subarrayWithRange:NSMakeRange(22, 11)];
    }
    
    for (int i = 0; i < missArray.count; i++) {
        UIButton * button = self.buttons[i + 1];
        [button setTitle:[NSString stringWithFormat:@"%@", missArray[i]] forState:UIControlStateNormal];
        if (self.chartStatisticsTag == KChartCellTagCount)
        {
            [button setTitleColor:YZColor(97, 0, 135, 1) forState:UIControlStateNormal];
        }else if (self.chartStatisticsTag == KChartCellTagAvgMiss)
        {
            [button setTitleColor:YZColor(47, 100, 0, 1) forState:UIControlStateNormal];
        }else if (self.chartStatisticsTag == KChartCellTagMaxMiss)
        {
            [button setTitleColor:YZColor(108, 18, 0, 1) forState:UIControlStateNormal];
        }else if (self.chartStatisticsTag == KChartCellTagMaxSeries)
        {
            [button setTitleColor:YZColor(1, 97, 146, 1) forState:UIControlStateNormal];
        }
        [button setBackgroundImage:nil forState:UIControlStateNormal];
    }
}

- (void)setDataStatus:(YZChartDataStatus *)dataStatus
{
    _dataStatus = dataStatus;
    
    UIButton * button0 = self.buttons[0];
    NSString * issue = [NSString stringWithFormat:@"%@", _dataStatus.issue];
    issue = [issue substringWithRange:NSMakeRange(issue.length - 2, 2)];
    [button0 setTitleColor:YZChartTitleColor forState:UIControlStateNormal];
    [button0 setTitle:[NSString stringWithFormat:@"%@期", issue] forState:UIControlStateNormal];
    
    NSArray * missArray = [NSArray array];
    NSArray * zhixuanMissArray = _dataStatus.missNumber[@"qian3_zhixuan"];
    if (self.chartCellTag == KChartCellTagAll) {
        missArray = _dataStatus.missNumber[@"renxuan"];
    }else if (self.chartCellTag == KChartCellTagWan)
    {
        missArray = [zhixuanMissArray subarrayWithRange:NSMakeRange(0, 11)];
    }else if (self.chartCellTag == KChartCellTagQian)
    {
        missArray = [zhixuanMissArray subarrayWithRange:NSMakeRange(11, 11)];
    }else if (self.chartCellTag == KChartCellTagBai)
    {
        missArray = [zhixuanMissArray subarrayWithRange:NSMakeRange(22, 11)];
    }
    
    self.noDataLabel.hidden = YES;
    if (11 != missArray.count) {//数据错误
        for (int i = 1; i < self.buttons.count; i++) {
            UIButton * button = self.buttons[i];
            button.hidden = YES;
        }
        self.noDataLabel.hidden = NO;
        return;
    }
    
    for (int i = 0; i < missArray.count; i++) {
        UIButton * button = self.buttons[i + 1];
        button.hidden = NO;
        NSString * miss = [NSString stringWithFormat:@"%@", missArray[i]];
        if ([miss intValue] == 0) {//
            [button setTitle:[NSString stringWithFormat:@"%02d", i + 1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if (self.chartCellTag == KChartCellTagQian)
            {
                [button setBackgroundImage:[UIImage imageNamed:@"greenBg"] forState:UIControlStateNormal];
            }else if (self.chartCellTag == KChartCellTagBai)
            {
                [button setBackgroundImage:[UIImage imageNamed:@"blueBg"] forState:UIControlStateNormal];
            }else
            {
                [button setBackgroundImage:[UIImage imageNamed:@"redBg"] forState:UIControlStateNormal];
            }
        }else
        {
            NSString * yilouStr = [YZTool getChartSettingByTitle:@"遗漏"];
            if ([yilouStr isEqualToString:@"显示遗漏"]) {//显示统计
                [button setTitle:miss forState:UIControlStateNormal];
            }else
            {
                [button setTitle:nil forState:UIControlStateNormal];
            }
            [button setTitleColor:YZChartLightGrayColor forState:UIControlStateNormal];
            [button setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
}

#pragma mark - 初始化
- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

@end
