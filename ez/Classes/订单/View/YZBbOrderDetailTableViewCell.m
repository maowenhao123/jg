//
//  YZBbOrderDetailTableViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/5/31.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZBbOrderDetailTableViewCell.h"

@interface YZBbOrderDetailTableViewCell ()

@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, weak) UILabel *teamMessageLabel;
@property (nonatomic, weak) UILabel *scoreLabel;
@property (nonatomic, weak) UILabel *betLabel;
@property (nonatomic, weak) UIView * line1;
@property (nonatomic, weak) UIView *line2;

@end

@implementation YZBbOrderDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZBbOrderDetailTableViewCellId";
    YZBbOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell)
    {
        cell = [[YZBbOrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    NSArray * labelWs = @[@0.5,@0.2,@0.3];
    UILabel * lastLabel;
    for (int i = 0; i < 3; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, [labelWs[i] floatValue] * screenWidth, 0)];
        if (i == 0) {
            self.teamMessageLabel = label;
        }else if (i == 1)
        {
            self.scoreLabel = label;
        }else if (i == 2)
        {
            self.betLabel = label;
        }
        label.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        label.textColor = YZBlackTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [self addSubview:label];
        [self.labels addObject:label];
        lastLabel = label;
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastLabel.frame) - lineWidth, 0, lineWidth, 0)];
        line.backgroundColor = YZGrayTextColor;
        [self.lines addObject:line];
        [self addSubview:line];
    }
   
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, lineWidth)];
    self.line1 = line1;
    line1.backgroundColor = YZGrayTextColor;
    [self addSubview:line1];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, lineWidth, 0)];
    self.line2 = line2;
    line2.backgroundColor = YZGrayTextColor;
    [self addSubview:line2];
}
#pragma mark - 设置数据
- (void)setStatus:(YZFBOrderStatus *)status
{
    _status = status;
   
    for (UILabel * label in self.labels) {
        label.height = status.bBCellH;
    }
    for (UIView * line in self.lines) {
        line.height = status.bBCellH;
    }
    self.line1.y = status.bBCellH - lineWidth;
    self.line2.height = status.bBCellH - lineWidth;
    
    //球队
    self.teamMessageLabel.attributedText = status.bBTeamMessageAttStr;
    
    //比分
    self.scoreLabel.text = status.score;
    
    //投注
    self.betLabel.attributedText = status.bBBetAttStr;
}

#pragma mark - 初始化
- (NSMutableArray *)labels
{
    if (_labels == nil) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}
- (NSMutableArray *)lines
{
    if (_lines == nil) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}

@end
