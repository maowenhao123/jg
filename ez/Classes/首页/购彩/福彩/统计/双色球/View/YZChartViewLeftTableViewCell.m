//
//  YZChartViewLeftTableViewCell.m
//  ez
//
//  Created by apple on 17/3/7.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define cellH screenWidth / 13

#import "YZChartViewLeftTableViewCell.h"

@implementation YZChartViewLeftTableViewCell

+ (YZChartViewLeftTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZChartViewLeftTableViewCell";
    YZChartViewLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZChartViewLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    UILabel * termIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cellH * 2, cellH)];
    self.termIdLabel = termIdLabel;
    termIdLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    termIdLabel.textColor = YZChartGrayColor;
    termIdLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:termIdLabel];
    
    UIView * line = [[UIView alloc] init];
    self.line = line;
    line.frame = CGRectMake(0, 0, cellH * 2, 1);
    line.backgroundColor = YZGrayLineColor;
    [self addSubview:line];
}
//设置数据
- (void)setDataStatus:(YZChartDataStatus *)dataStatus
{
    _dataStatus = dataStatus;
    self.termIdLabel.textColor = YZChartGrayColor;
    self.termIdLabel.text = [NSString stringWithFormat:@"%@期", [_dataStatus.issue substringFromIndex:_dataStatus.issue.length - 3]];
}

@end
