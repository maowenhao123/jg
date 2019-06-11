//
//  YZFBMatchDetailOddsRightTitleTableViewCell.m
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define padding 10
#define cellH 35

#import "YZFBMatchDetailOddsRightTitleTableViewCell.h"

@interface YZFBMatchDetailOddsRightTitleTableViewCell ()

@property (nonatomic, strong) NSMutableArray *titleLabels;

@end

@implementation YZFBMatchDetailOddsRightTitleTableViewCell

+ (YZFBMatchDetailOddsRightTitleTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FBMatchDetailOddsRightTitleTableViewCell";
    YZFBMatchDetailOddsRightTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZFBMatchDetailOddsRightTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
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
#pragma mark - 布局视图
- (void)setupChilds
{
    CGFloat width = screenWidth * 0.75 - 2 * padding;
    
    NSArray * titles = @[@"胜",@"平",@"负",@"更新时间"];
    NSArray * labelWs = @[@0.18,@0.27,@0.18,@0.37];
    UILabel * lastLabel;
    for (int i = 0; i < titles.count; i++) {
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, [labelWs[i] floatValue] * width, cellH)];
        titleLabel.text = titles[i];
        titleLabel.textColor = YZColor(116, 116, 116, 1);
        titleLabel.font = [UIFont systemFontOfSize:10];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        [self.titleLabels addObject:titleLabel];
        lastLabel = titleLabel;
    }
    
    //分割线
    UIView * line_left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, cellH)];
    line_left.backgroundColor = YZWhiteLineColor;
    [self addSubview:line_left];
    
    UIView * line_right = [[UIView alloc] initWithFrame:CGRectMake(width - 1, 0, 1, cellH)];
    line_right.backgroundColor = YZWhiteLineColor;
    [self addSubview:line_right];

    UIView * line_up = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 1)];
    line_up.backgroundColor = YZWhiteLineColor;
    [self addSubview:line_up];
    
    UIView * line_down = [[UIView alloc] initWithFrame:CGRectMake(0, cellH - 1, width, 1)];
    line_down.backgroundColor = YZWhiteLineColor;
    [self addSubview:line_down];
}
- (void)setOddsType:(NSInteger)oddsType
{
    _oddsType = oddsType;
    NSArray * titles = [NSArray array];
    if (oddsType == 0) {
        titles = @[@"胜",@"平",@"负",@"更新时间"];
    }else if (oddsType == 1)
    {
        titles = @[@"水位",@"让球",@"水位",@"更新时间"];
    }else if (oddsType == 2)
    {
        titles = @[@"大",@"盘口",@"小",@"更新时间"];
    }
    for (int i = 0; i < self.titleLabels.count; i++) {
        UILabel * titleLabel = self.titleLabels[i];
        titleLabel.text = titles[i];
    }
}
- (NSMutableArray *)titleLabels
{
    if (!_titleLabels) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}
@end
