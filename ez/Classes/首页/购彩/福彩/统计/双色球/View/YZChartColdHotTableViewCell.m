//
//  YZChartColdHotTableViewCell.m
//  ez
//
//  Created by apple on 17/3/8.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define cellH screenWidth / 13

#import "YZChartColdHotTableViewCell.h"
#import "YZChartBallView.h"

@interface YZChartColdHotTableViewCell ()

@property (nonatomic, weak) YZChartBallView *ballView;//号码球
@property (nonatomic, strong) NSMutableArray *labels;

@end

@implementation YZChartColdHotTableViewCell

+ (YZChartColdHotTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZChartColdHotTableViewCell";
    YZChartColdHotTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZChartColdHotTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    YZChartBallView * ballView = [[YZChartBallView alloc] init];
    self.ballView = ballView;
    ballView.frame = CGRectMake(0, 2, screenWidth * 0.16, cellH - 4);
    [self addSubview:ballView];
    ballView.textFont = [UIFont systemFontOfSize:YZGetFontSize(24)];
    
    CGFloat labelW = screenWidth * 0.21;
    for (int i = 0; i < 4; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.ballView.frame) + labelW * i, 0, labelW, cellH)];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        label.textColor = YZChartLightGrayColor;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [self.labels addObject:label];
        
        //分割线
        UIView * line = [[UIView alloc] init];
        line.frame = CGRectMake(0, 0, 0.8, cellH);
        line.backgroundColor = YZGrayLineColor;
        [label addSubview:line];
    }
    
    UIView * line = [[UIView alloc] init];
    self.line = line;
    line.frame = CGRectMake(0, cellH - 0.8, screenWidth, 0.8);
    line.backgroundColor = YZGrayLineColor;
    [self addSubview:line];
}
//设置数据
- (void)setDataStatus:(YZChartDataStatus *)dataStatus
{
    _dataStatus = dataStatus;
}
//74NAMS9PFJ
//kkone168@163.com
- (void)setStatus:(YZChartColdHotStatus *)status
{
    _status = status;
    self.ballView.status = _status.ballStatus;
    for (int i = 0; i < self.labels.count; i++) {
        UILabel * label = self.labels[i];
        label.textColor = YZChartGrayColor;
        if (i == 0) {//30期
            NSString * thirty = [NSString stringWithFormat:@"%ld", _status.thirty];
            if (!YZStringIsEmpty(thirty)) {
                label.text = [NSString stringWithFormat:@"%@", thirty];
                if (_status.max_thirty) {
                    label.textColor = YZBaseColor;
                }
            }
        }else if (i == 1)//50期
        {
            NSString * fifty = [NSString stringWithFormat:@"%ld", _status.fifty];
            if (!YZStringIsEmpty(fifty)) {
                label.text = [NSString stringWithFormat:@"%@", fifty];
                if (_status.max_fifty) {
                    label.textColor = YZBaseColor;
                }
            }
        }else if (i == 2)//100期
        {
            NSString * hundred = [NSString stringWithFormat:@"%ld", _status.hundred];
            if (!YZStringIsEmpty(hundred)) {
                label.text = [NSString stringWithFormat:@"%@", hundred];
                if (_status.max_hundred) {
                    label.textColor = YZRedTextColor;
                }
            }
        }else if (i == 3)//遗漏
        {
            NSString * miss = [NSString stringWithFormat:@"%ld", _status.miss];
            if (_status.have_miss_data) {
                label.text = [NSString stringWithFormat:@"%@", miss];
                if (_status.max_miss) {
                    label.textColor = YZRedTextColor;
                }
            }else
            {
                label.text = @"-";
            }
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
