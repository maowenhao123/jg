//
//  YZFBMatchDetailIntegralTitleTableViewCell.m
//  ez
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define padding 10
#define cellH 35

#import "YZFBMatchDetailIntegralTitleTableViewCell.h"

@implementation YZFBMatchDetailIntegralTitleTableViewCell

+ (YZFBMatchDetailIntegralTitleTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FBMatchDetailIntegralTitleTableViewCell";
    YZFBMatchDetailIntegralTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZFBMatchDetailIntegralTitleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    NSArray * titles = @[@"排名",@"球队",@"已赛",@"胜",@"平",@"负",@"进",@"失",@"净",@"积分"];
    UILabel * lastLabel;
    for (int i = 0; i < titles.count; i++) {
        UILabel * titleLabel = [[UILabel alloc] init];
        if (i == 1) {
            titleLabel.frame = CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, width / (titles.count + 1) * 2, cellH);
        }else
        {
            titleLabel.frame = CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, width / (titles.count + 1), cellH);
        }
        titleLabel.text = titles[i];
        titleLabel.textColor = YZColor(116, 116, 116, 1);
        titleLabel.font = [UIFont systemFontOfSize:10];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
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

@end
