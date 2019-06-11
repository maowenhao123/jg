//
//  YZFBMatchDetailOddsTitleTableViewCell.m
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define padding 10
#define cellH 35

#import "YZFBMatchDetailOddsTitleTableViewCell.h"

@interface YZFBMatchDetailOddsTitleTableViewCell ()

@property (nonatomic, strong) NSMutableArray *titleLabels;

@end

@implementation YZFBMatchDetailOddsTitleTableViewCell

+ (YZFBMatchDetailOddsTitleTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FBMatchDetailOddsTitleTableViewCell";
    YZFBMatchDetailOddsTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZFBMatchDetailOddsTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    CGFloat width = screenWidth - 2 * padding;
    NSArray * titles = @[@"公司",@"初始赔率",@"即时赔率"];
    NSArray * labelWs = @[@0.19,@0.36,@0.45];
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
    //竖直分割线
    UIView * lastLine;
    for (int i = 0; i < labelWs.count - 1; i++) {
        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lastLine.frame) + [labelWs[i] floatValue] * width - 1, 0, 1, cellH)];
        line1.backgroundColor = YZWhiteLineColor;
        [self addSubview:line1];
        lastLine = line1;
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
    NSArray * titles = @[@"公司",@"初始赔率",@"即时赔率"];
    if (oddsType != 0) {
        titles = @[@"公司",@"初始盘口",@"即时盘口"];
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
