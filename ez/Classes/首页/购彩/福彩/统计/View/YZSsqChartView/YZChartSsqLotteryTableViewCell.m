//
//  YZChartSsqLotteryTableViewCell.m
//  ez
//
//  Created by apple on 17/3/9.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define cellH screenWidth / 13

#import "YZChartSsqLotteryTableViewCell.h"

@interface YZChartSsqLotteryTableViewCell ()

@property (nonatomic, strong) NSMutableArray *labels;

@end

@implementation YZChartSsqLotteryTableViewCell

+ (YZChartSsqLotteryTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZChartSsqLotteryTableViewCell";
    YZChartSsqLotteryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZChartSsqLotteryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    NSArray * labelWs = @[@0.2,@0.5,@0.3];
    UILabel * lastLabel;
    for (int i = 0; i < labelWs.count; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, [labelWs[i] floatValue] * screenWidth, cellH)];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        label.textColor = YZChartGrayColor;
        if (i == 1) {
            label.textColor = YZRedBallColor;
        }else if (i == 2)
        {
            label.textColor = YZBlueBallColor;
        }
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [self.labels addObject:label];
        lastLabel = label;
        
        if (i != 0) {
            //分割线
            UIView * line = [[UIView alloc] init];
            line.frame = CGRectMake(0, 0, 0.8, cellH);
            line.backgroundColor = YZGrayLineColor;
            [label addSubview:line];
        }
    }
}
- (void)setIsDlt:(BOOL)isDlt
{
    _isDlt = isDlt;
}
//设置数据
- (void)setDataStatus:(YZChartDataStatus *)dataStatus
{
    _dataStatus = dataStatus;
    
    NSMutableString * winNumberRed = [NSMutableString string];
    NSMutableString * winNumberBlue = [NSMutableString string];
    int blueBallNumber = 1;
    if (self.isDlt) {
        blueBallNumber = 2;
    }
    if (!YZArrayIsEmpty(_dataStatus.winNumber)) {//不为空
        for (int i = 0; i < _dataStatus.winNumber.count - blueBallNumber; i++) {
            [winNumberRed appendFormat:@"%@ ",_dataStatus.winNumber[i]];
        }
        
        for (NSInteger i = _dataStatus.winNumber.count - blueBallNumber; i < _dataStatus.winNumber.count; i++) {
            [winNumberBlue appendFormat:@"%@ ",_dataStatus.winNumber[i]];
        }
    }
    
    for (int i = 0; i < self.labels.count; i++) {
        UILabel * label = self.labels[i];
        if (i == 0) {//期次
            label.text = [NSString stringWithFormat:@"%@期", [_dataStatus.issue substringFromIndex:_dataStatus.issue.length - 3]];
            //label.text = [NSString stringWithFormat:@"%@期", _dataStatus.issue];
        }else if (i == 1)//红球
        {
            label.text = winNumberRed;
        }else if (i == 2)//蓝球
        {
            label.text = winNumberBlue;
        }
        
    }
}
#pragma mark - 初始化
- (NSMutableArray *)labels
{
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

@end
