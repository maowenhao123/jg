//
//  YZFBMatchDetailOddsRightContentTableViewCell.m
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define padding 10
#define cellH 35

#import "YZFBMatchDetailOddsRightContentTableViewCell.h"
#import "YZFBMatchDetailOddsTrendView.h"

@interface YZFBMatchDetailOddsRightContentTableViewCell ()

@property (nonatomic, strong) NSMutableArray *oddsTrendViews;//即时赔率

@end

@implementation YZFBMatchDetailOddsRightContentTableViewCell

+ (YZFBMatchDetailOddsRightContentTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FBMatchDetailOddsRightContentTableViewCell";
    YZFBMatchDetailOddsRightContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZFBMatchDetailOddsRightContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    
    NSArray * labelWs = @[@0.18,@0.27,@0.18,@0.37];
    YZFBMatchDetailOddsTrendView * lastView;
    for (int i = 0; i < labelWs.count; i++) {
        YZFBMatchDetailOddsTrendView * oddsTrendView = [[YZFBMatchDetailOddsTrendView alloc] init];
        oddsTrendView.frame = CGRectMake(CGRectGetMaxX(lastView.frame), 0, [labelWs[i] floatValue] * width, 35);
        [self addSubview:oddsTrendView];
        lastView = oddsTrendView;
        [self.oddsTrendViews addObject:oddsTrendView];
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
- (void)setStatus:(id)status
{
    _status = status;
    if ([_status isKindOfClass:[YZEuropeOddsStatus class]]) {//欧赔
        YZEuropeOddsStatus * europeOddsStatus = (YZEuropeOddsStatus *)_status;
        for (int i = 0; i < self.oddsTrendViews.count; i++) {
            YZFBMatchDetailOddsTrendView * oddsTrendView = self.oddsTrendViews[i];
            if (i == 0) {
                oddsTrendView.odds = europeOddsStatus.win;
                oddsTrendView.trend = europeOddsStatus.winTrend;
            }else if (i == 1)
            {
                oddsTrendView.odds = europeOddsStatus.draw;
                oddsTrendView.trend = europeOddsStatus.drawTrend;
            }else if (i == 2)
            {
                oddsTrendView.odds = europeOddsStatus.loss;
                oddsTrendView.trend = europeOddsStatus.lossTrend;
            }else if (i == 3)
            {
                oddsTrendView.odds = europeOddsStatus.updateTime;
            }
        }
    }else if ([_status isKindOfClass:[YZAsiaOddsStatus class]])//亚盘
    {
        YZAsiaOddsStatus * asiaOddsStatus = (YZAsiaOddsStatus *)_status;
        for (int i = 0; i < self.oddsTrendViews.count; i++) {
            YZFBMatchDetailOddsTrendView * oddsTrendView = self.oddsTrendViews[i];
            if (i == 0) {
                oddsTrendView.odds = asiaOddsStatus.above;
                oddsTrendView.trend = asiaOddsStatus.aboveTrend;
            }else if (i == 1)
            {
                oddsTrendView.odds = asiaOddsStatus.bet;
            }else if (i == 2)
            {
                oddsTrendView.odds = asiaOddsStatus.below;
                oddsTrendView.trend = asiaOddsStatus.belowTrend;
            }else if (i == 3)
            {
                oddsTrendView.odds = asiaOddsStatus.updateTime;
            }
        }
    }else if ([_status isKindOfClass:[YZOverUnderStatus class]])//大小盘
    {
        YZOverUnderStatus * overUnderStatus = (YZOverUnderStatus *)_status;
        for (int i = 0; i < self.oddsTrendViews.count; i++) {
            YZFBMatchDetailOddsTrendView * oddsTrendView = self.oddsTrendViews[i];
            if (i == 0) {
                oddsTrendView.odds = overUnderStatus.up;
                oddsTrendView.trend = overUnderStatus.upTrend;
            }else if (i == 1)
            {
                oddsTrendView.odds = overUnderStatus.bet;
            }else if (i == 2)
            {
                oddsTrendView.odds = overUnderStatus.low;
                oddsTrendView.trend = overUnderStatus.lowTrend;
            }else if (i == 3)
            {
                oddsTrendView.odds = overUnderStatus.updateTime;
            }
        }
    }
}
#pragma mark - 初始化
- (NSMutableArray *)oddsTrendViews
{
    if (!_oddsTrendViews) {
        _oddsTrendViews = [NSMutableArray array];
    }
    return _oddsTrendViews;
}
@end
