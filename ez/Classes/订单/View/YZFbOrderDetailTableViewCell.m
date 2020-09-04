//
//  YZFbOrderDetailTableViewCell.m
//  ez
//
//  Created by apple on 16/10/11.
//  Copyright © 2016年 9ge. All rights reserved.
//
#import "YZFbOrderDetailTableViewCell.h"

@interface YZFbOrderDetailTableViewCell ()

@property (nonatomic, weak) UILabel *teamMessageLabel;
@property (nonatomic, weak) UIView *resultsView;
@property (nonatomic, weak) UIView *betView;
@property (nonatomic, weak) UIView * line0;
@property (nonatomic, weak) UIView * line1;
@property (nonatomic, weak) UIView * line2;
@property (nonatomic, weak) UIView * line3;
@property (nonatomic, weak) UIView * line;
@end

@implementation YZFbOrderDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FbOrderDetailTableViewCell";
    YZFbOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell)
    {
        cell = [[YZFbOrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIView * line0 = [[UIView alloc]init];
    self.line0 = line0;
    line0.backgroundColor = YZGrayTextColor;
    [self addSubview:line0];
    
    //球队
    UILabel * teamMessageLabel = [[UILabel alloc]init];
    self.teamMessageLabel = teamMessageLabel;
    teamMessageLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    teamMessageLabel.textColor = YZBlackTextColor;
    teamMessageLabel.textAlignment = NSTextAlignmentCenter;
    teamMessageLabel.numberOfLines = 0;
    [self addSubview:teamMessageLabel];
    
    UIView * line1 = [[UIView alloc]init];
    self.line1 = line1;
    line1.backgroundColor = YZGrayTextColor;
    [self addSubview:line1];
    
    //赛果
    UIView *resultsView = [[UIView alloc]init];
    self.resultsView = resultsView;
    resultsView.backgroundColor = [UIColor whiteColor];
    [self addSubview:resultsView];
    
    UIView * line2 = [[UIView alloc]init];
    self.line2 = line2;
    line2.backgroundColor = YZGrayTextColor;
    [self addSubview:line2];
    
    //投注
    UIView *betView = [[UIView alloc]init];
    self.betView = betView;
    betView.backgroundColor = [UIColor whiteColor];
    [self addSubview:betView];
    
    UIView * line3 = [[UIView alloc]init];
    self.line3 = line3;
    line3.backgroundColor = YZGrayTextColor;
    [self addSubview:line3];
    
    UIView * line = [[UIView alloc]init];
    self.line = line;
    line.backgroundColor = YZGrayTextColor;
    [self addSubview:line];
}

#pragma mark - 设置数据
- (void)setStatus:(YZFBOrderStatus *)status
{
    _status = status;
    
    self.line0.frame = CGRectMake(0, 0, lineWidth, status.cellH);
    
    //球队
    self.teamMessageLabel.frame = CGRectMake(0, 0, screenWidth * 0.5, status.cellH);
    self.teamMessageLabel.attributedText = status.teamMessage;
    self.line1.frame = CGRectMake(CGRectGetMaxX(self.teamMessageLabel.frame) - lineWidth, 0, lineWidth, status.cellH);
   
    //赛果
    for (UIView * subview in self.resultsView.subviews) {//先删除之前的label
        if ([subview isKindOfClass:[UILabel class]]) {
            [subview removeFromSuperview];
        }
    }
    
    UILabel * lastResultsLabel;
    for (int i = 0; i < status.betArray.count; i++) {
        CGFloat labelH = [_status.labelHArray[i] floatValue];
        UILabel * resultsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastResultsLabel.frame), screenWidth * 0.2, labelH)];
        if (i < status.resultsArray.count) {//有开奖
            resultsLabel.attributedText = status.resultsArray[i];
        }else
        {
            resultsLabel.attributedText = nil;
        }
        resultsLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        resultsLabel.textColor = YZBlackTextColor;
        resultsLabel.numberOfLines = 0;
        [self.resultsView addSubview:resultsLabel];
        lastResultsLabel = resultsLabel;
        if (i != status.betArray.count - 1) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, labelH - lineWidth, screenWidth * 0.2, lineWidth)];
            line.backgroundColor = YZGrayTextColor;
            [resultsLabel addSubview:line];
        }
    }
    self.resultsView.frame = CGRectMake(screenWidth * 0.5, 0, screenWidth * 0.2, CGRectGetMaxY(lastResultsLabel.frame));
    self.line2.frame = CGRectMake(CGRectGetMaxX(self.resultsView.frame) - lineWidth, 0, lineWidth, status.cellH);
    
    //投注
    for (UIView * subview in self.betView.subviews) {//先删除之前的label
        if ([subview isKindOfClass:[UILabel class]]) {
            [subview removeFromSuperview];
        }
    }
    
    UILabel * lastBetLabel;
    for (int i = 0; i < status.betArray.count; i++) {
        CGFloat labelH = [_status.labelHArray[i] floatValue];
        UILabel * betLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastBetLabel.frame), screenWidth * 0.3, labelH)];
        betLabel.textColor = YZBlackTextColor;
        betLabel.attributedText = status.betArray[i];
        betLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        betLabel.numberOfLines = 0;
        [self.betView addSubview:betLabel];
        lastBetLabel = betLabel;
        if (i != status.betArray.count - 1) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, labelH - lineWidth, screenWidth * 0.3, lineWidth)];
            line.backgroundColor = YZGrayTextColor;
            [betLabel addSubview:line];
        }
    }
    self.betView.frame = CGRectMake(screenWidth * 0.7, 0, screenWidth * 0.3, CGRectGetMaxY(lastBetLabel.frame));
    self.line3.frame = CGRectMake(screenWidth - lineWidth, 0, lineWidth, status.cellH);
    self.line.frame = CGRectMake(0, status.cellH - lineWidth, screenWidth, lineWidth);
}

@end
