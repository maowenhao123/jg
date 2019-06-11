//
//  YZChartViewContentTableViewCell.m
//  ez
//
//  Created by apple on 17/3/7.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define cellH screenWidth / 13

#import "YZChartViewContentTableViewCell.h"

@interface YZChartViewContentTableViewCell ()

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) UILabel * waitLotteryLabel;

@end

@implementation YZChartViewContentTableViewCell

+ (YZChartViewContentTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZChartViewContentTableViewCell";
    YZChartViewContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZChartViewContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    CGFloat padding = 1;
    CGFloat buttonWH = cellH - 2 * padding;
    for (int i = 0; i < 35; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(padding + (buttonWH + 2 * padding) * i, padding, buttonWH, buttonWH);
        button.hidden = YES;
        button.adjustsImageWhenHighlighted = NO;
        [button setTitleColor:YZChartLightGrayColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        [self addSubview:button];
        [self.buttons addObject:button];
        
        //分割线
        UIView * line = [[UIView alloc] init];
        line.frame = CGRectMake(-padding, -padding, 0.8, cellH);
        line.backgroundColor = YZGrayLineColor;
        [button addSubview:line];
    }
    
    UIView * line = [[UIView alloc] init];
    self.line = line;
    line.hidden = YES;
    line.frame = CGRectMake(0, 0, 11 * cellH, 1);
    line.backgroundColor = YZGrayLineColor;
    [self addSubview:line];
    
    UILabel * noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellH * 11, cellH)];
    self.noDataLabel = noDataLabel;
    noDataLabel.text = @"等待开奖";
    noDataLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.textColor = YZChartLightGrayColor;
    noDataLabel.hidden = YES;
    [self addSubview:noDataLabel];
    
    UILabel * waitLotteryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, cellH / 2, cellH * 11, cellH)];
    self.waitLotteryLabel = waitLotteryLabel;
    waitLotteryLabel.text = @"等待开奖后更新";
    waitLotteryLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    waitLotteryLabel.textAlignment = NSTextAlignmentCenter;
    waitLotteryLabel.textColor = YZChartLightGrayColor;
    waitLotteryLabel.hidden = YES;
    [self addSubview:waitLotteryLabel];
    
    UIView * line1 = [[UIView alloc] init];
    line1.frame = CGRectMake(0, 0, 0.8, cellH);
    line1.backgroundColor = YZGrayLineColor;
    [noDataLabel addSubview:line1];
}
- (void)setBallNumber:(NSInteger)ballNumber
{
    _ballNumber = ballNumber;
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton * button = self.buttons[i];
        [button setTitle:nil forState:UIControlStateNormal];
        [button setBackgroundImage:nil forState:UIControlStateNormal];
        if (i < _ballNumber) {
            button.hidden = NO;
        }else
        {
            button.hidden = YES;
        }
    }
    self.line.width = _ballNumber * cellH;
}
- (void)setIsBlue:(BOOL)isBlue
{
    _isBlue = isBlue;
}
//设置数据
- (void)setDataStatus:(YZChartDataStatus *)dataStatus
{
    _dataStatus = dataStatus;
    NSArray * missArray = [NSArray array];
    if (_isBlue) {
        missArray = _dataStatus.missNumber[@"bluemiss"];
    }else
    {
        missArray = _dataStatus.missNumber[@"redmiss"];
    }
    if (_ballNumber != missArray.count) {//数据错误
        for (int i = 0; i < self.buttons.count; i++) {
            UIButton * button = self.buttons[i];
            button.hidden = YES;
        }
        self.noDataLabel.hidden = NO;
        self.waitLotteryLabel.hidden = YES;
        return;
    }
    self.waitLotteryLabel.hidden = YES;
    self.noDataLabel.hidden = YES;
    
    for (int i = 0; i < missArray.count; i++) {
        UIButton * button = self.buttons[i];
        NSString * miss = [NSString stringWithFormat:@"%@", missArray[i]];
        if ([miss intValue] == 0) {//
            [button setTitle:[NSString stringWithFormat:@"%02d", i + 1] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            if (!_isBlue) {
                [button setBackgroundImage:[UIImage imageNamed:@"redBall_flat"] forState:UIControlStateNormal];
            }else
            {
                [button setBackgroundImage:[UIImage imageNamed:@"blueBall_flat"] forState:UIControlStateNormal];
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
- (void)setWaitLottery:(BOOL)waitLottery
{
    _waitLottery = waitLottery;
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton * button = self.buttons[i];
        button.hidden = YES;
    }
}
- (void)setShowWaitLottery:(BOOL)showWaitLottery
{
    _showWaitLottery = showWaitLottery;
    if (_showWaitLottery) {
        self.waitLotteryLabel.hidden = NO;
        self.noDataLabel.hidden = YES;
    }else
    {
        self.waitLotteryLabel.hidden = YES;
    }
}
- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
}
- (void)setTextArray:(NSArray *)textArray
{
    _textArray = textArray;
    self.waitLotteryLabel.hidden = YES;
    self.noDataLabel.hidden = YES;
    if (_ballNumber != _textArray.count) {//数据错误
        return;
    }
    
    for (int i = 0; i < _textArray.count; i++) {
        UIButton * button = self.buttons[i];
        [button setTitle:[NSString stringWithFormat:@"%@",_textArray[i]] forState:UIControlStateNormal];
        [button setTitleColor:_textColor forState:UIControlStateNormal];
        [button setBackgroundImage:nil forState:UIControlStateNormal];
    }
}
#pragma mark - 初始化
- (NSMutableArray *)buttons
{
    if (!_buttons) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

@end
