//
//  YZFBMatchDetailStandingsTitleTableViewCell.m
//  ez
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define padding 10
#define cellH 35

#import "YZFBMatchDetailStandingsTitleTableViewCell.h"

@interface YZFBMatchDetailStandingsTitleTableViewCell ()

@property (nonatomic, strong) NSMutableArray *titleLabels;

@end

@implementation YZFBMatchDetailStandingsTitleTableViewCell

+ (YZFBMatchDetailStandingsTitleTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FBMatchDetailStandingsTitleTableViewCell";
    YZFBMatchDetailStandingsTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZFBMatchDetailStandingsTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    NSArray * titles = @[@"赛事",@"日期",@"主队",@"比分",@"客队",@"胜负"];
    NSArray * labelWs = @[@0.18,@0.18,@0.21,@0.11,@0.21,@0.11];
    UILabel * lastLabel;
    for (int i = 0; i < titles.count; i++) {
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, [labelWs[i] floatValue] * width, cellH);
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
    
    UIView * line_down = [[UIView alloc] initWithFrame:CGRectMake(0, cellH - 1, width, 1)];
    line_down.backgroundColor = YZWhiteLineColor;
    [self addSubview:line_down];
}
- (void)setIsFuture:(BOOL)isFuture
{
    _isFuture = isFuture;
    NSArray * titles = [NSArray array];
    if (_isFuture) {
        titles = @[@"赛事",@"日期",@"主队",@"",@"客队",@"相隔"];
    }else
    {
       titles = @[@"赛事",@"日期",@"主队",@"比分",@"客队",@"胜负"];
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
