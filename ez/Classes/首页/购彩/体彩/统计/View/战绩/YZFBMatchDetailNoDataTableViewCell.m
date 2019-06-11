//
//  YZFBMatchDetailNoDataTableViewCell.m
//  ez
//
//  Created by apple on 17/2/20.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define padding 10
#define cellH 35

#import "YZFBMatchDetailNoDataTableViewCell.h"

@interface YZFBMatchDetailNoDataTableViewCell ()

@property (nonatomic, weak) UILabel *contentLabel;
@property (nonatomic, weak) UIView * line_left;
@property (nonatomic, weak) UIView * line_right;
@property (nonatomic, weak) UIView * line_down;

@end

@implementation YZFBMatchDetailNoDataTableViewCell

+ (YZFBMatchDetailNoDataTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FBMatchDetailNoDataTableViewCell";
    YZFBMatchDetailNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZFBMatchDetailNoDataTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
- (void)setupChilds
{
    CGFloat width = screenWidth - 2 * padding;
    
    UILabel * contentLabel = [[UILabel alloc] init];
    self.contentLabel = contentLabel;
    contentLabel.frame = CGRectMake(0, 0, width, cellH);
    contentLabel.backgroundColor = [UIColor whiteColor];
    contentLabel.text = @"暂无数据";
    contentLabel.textColor = YZColor(116, 116, 116, 1);
    contentLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:contentLabel];
    
    //分割线
    UIView * line_left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, cellH)];
    self.line_left = line_left;
    line_left.backgroundColor = YZWhiteLineColor;
    [self addSubview:line_left];
    
    UIView * line_right = [[UIView alloc] initWithFrame:CGRectMake(width - 1, 0, 1, cellH)];
    self.line_right = line_right;
    line_right.backgroundColor = YZWhiteLineColor;
    [self addSubview:line_right];
    
    UIView * line_down = [[UIView alloc] initWithFrame:CGRectMake(0, cellH - 1, width, 1)];
    self.line_down = line_down;
    line_down.backgroundColor = YZWhiteLineColor;
    [self addSubview:line_down];
}
- (void)setOddsCell:(BOOL)oddsCell
{
    _oddsCell = oddsCell;
    if (_oddsCell) {
        CGFloat width = screenWidth * 0.75 - 2 * padding;
        self.contentLabel.width = width;
        self.line_right.x = width - 1;
        self.line_down.width = width;
    }
}
@end
