//
//  YZFBMatchDetailOddsContentTableViewCell.m
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define cellH 35
#define padding 5
#define padding1 10

#import "YZFBMatchDetailOddsContentTableViewCell.h"
#import "YZEuropeOddsCellStatus.h"
#import "YZAsiaOddsCellStatus.h"
#import "YZOverUnderCellStatus.h"
#import "YZFBMatchDetailOddsTrendView.h"

@interface YZFBMatchDetailOddsContentTableViewCell ()

@property (nonatomic, weak) UILabel *companyLabel;//公司
@property (nonatomic, strong) NSMutableArray *initialOddLabels;//初始赔率
@property (nonatomic, strong) NSMutableArray *oddsTrendViews;//即时赔率

@end

@implementation YZFBMatchDetailOddsContentTableViewCell

+ (YZFBMatchDetailOddsContentTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FBMatchDetailOddsContentTableViewCell";
    YZFBMatchDetailOddsContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZFBMatchDetailOddsContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    CGFloat width = screenWidth - 2 * padding1;
    NSArray * viewWs = @[@0.19,@0.36,@0.42,@0.03];
    //公司
    UILabel * companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [viewWs[0] floatValue] * width, cellH)];
    self.companyLabel = companyLabel;
    companyLabel.font = [UIFont systemFontOfSize:10];
    companyLabel.textColor = YZBlackTextColor;
    companyLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:companyLabel];
    
    //初始赔率
    UIView * initialOddView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(companyLabel.frame), 0, [viewWs[1] floatValue] * width, cellH)];
    [self addSubview:initialOddView];
    
    CGFloat initialOddW = initialOddView.width - 2 * padding;
    NSArray * initialOddLabelWs = @[@0.29,@0.42,@0.29];
    UILabel * lastInitialOddLabel;
    for (int i = 0; i < 3; i++) {
        CGFloat padding_ = padding;
        if (i != 0) {
            padding_ = CGRectGetMaxX(lastInitialOddLabel.frame);
        }
        UILabel * initialOddLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding_, 0, [initialOddLabelWs[i] floatValue] * initialOddW, cellH)];
        initialOddLabel.font = [UIFont systemFontOfSize:10];
        initialOddLabel.textAlignment = NSTextAlignmentCenter;
        initialOddLabel.textColor = YZBlackTextColor;
        initialOddLabel.numberOfLines = 0;
        [initialOddView addSubview:initialOddLabel];
        lastInitialOddLabel = initialOddLabel;
        [self.initialOddLabels addObject:initialOddLabel];
    }
    
    //即时赔率
    UIView * realTimeOddView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(initialOddView.frame), 0, [viewWs[2] floatValue] * width, cellH)];
    [self addSubview:realTimeOddView];
    
    CGFloat realTimeOddW = realTimeOddView.width - 2 * padding;
    NSArray * realTimeOddLabelWs = @[@0.3,@0.4,@0.3];
    YZFBMatchDetailOddsTrendView * lastRealTimeOddTrendView;
    for (int i = 0; i < 3; i++) {
        CGFloat padding_ = padding;
        if (i != 0) {
            padding_ = CGRectGetMaxX(lastRealTimeOddTrendView.frame);
        }
        YZFBMatchDetailOddsTrendView * oddsTrendView = [[YZFBMatchDetailOddsTrendView alloc] init];
        oddsTrendView.frame = CGRectMake(padding_, 0, [realTimeOddLabelWs[i] floatValue] * realTimeOddW, cellH);
        [realTimeOddView addSubview:oddsTrendView];
        lastRealTimeOddTrendView = oddsTrendView;
        [self.oddsTrendViews addObject:oddsTrendView];
    }
    
    //角标
    UIImageView *accessoryImageView = [[UIImageView alloc] init];
    accessoryImageView.image = [UIImage imageNamed:@"fb_detail_odds_accessory"];
    accessoryImageView.frame = CGRectMake(0, 0, 6, 10);
    CGFloat accessoryImageViewCenterX = [viewWs[2] floatValue] * width + [viewWs[3] floatValue] * width / 2 - 4;
    accessoryImageView.center = CGPointMake(accessoryImageViewCenterX, cellH / 2);
    [realTimeOddView addSubview:accessoryImageView];
    
    //竖直分割线
    UIView * lastLine;
    for (int i = 0; i < viewWs.count - 2; i++) {
        UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lastLine.frame) + [viewWs[i] floatValue] * width - 1, 0, 1, cellH)];
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

    UIView * line_down = [[UIView alloc] initWithFrame:CGRectMake(0, cellH - 1, width, 1)];
    line_down.backgroundColor = YZWhiteLineColor;
    [self addSubview:line_down];
}
- (void)setOddsCellStatus:(YZOddsCellStatus *)oddsCellStatus
{
    _oddsCellStatus = oddsCellStatus;
    self.companyLabel.text = _oddsCellStatus.companyName;
    if (_oddsCellStatus.oddsType == 0) {//欧赔
        YZEuropeOddsCellStatus * europeOddsCellStatus = (YZEuropeOddsCellStatus *)_oddsCellStatus;
        //初始赔率
        for (int i = 0; i < self.initialOddLabels.count; i++) {
            UILabel * initialOddLabel = self.initialOddLabels[i];
            if (i == 0) {
                initialOddLabel.text = europeOddsCellStatus.initialOdds.win;
            }else if (i == 1)
            {
                initialOddLabel.text = europeOddsCellStatus.initialOdds.draw;
            }else if (i == 2)
            {
                initialOddLabel.text = europeOddsCellStatus.initialOdds.loss;
            }
        }
        //即时赔率
        for (int i = 0; i < self.oddsTrendViews.count; i++) {
            YZFBMatchDetailOddsTrendView * oddsTrendView = self.oddsTrendViews[i];
            if (i == 0) {
                oddsTrendView.odds = europeOddsCellStatus.realTimeOdds.win;
                oddsTrendView.trend = europeOddsCellStatus.realTimeOdds.winTrend;
            }else if (i == 1)
            {
                oddsTrendView.odds = europeOddsCellStatus.realTimeOdds.draw;
                oddsTrendView.trend = europeOddsCellStatus.realTimeOdds.drawTrend;
            }else if (i == 2)
            {
                oddsTrendView.odds = europeOddsCellStatus.realTimeOdds.loss;
                oddsTrendView.trend = europeOddsCellStatus.realTimeOdds.lossTrend;
            }
        }
    }else if (_oddsCellStatus.oddsType == 1)//亚盘
    {
        YZAsiaOddsCellStatus * asiaOddsCellStatus = (YZAsiaOddsCellStatus *)_oddsCellStatus;
        //初始赔率
        for (int i = 0; i < self.initialOddLabels.count; i++) {
            UILabel * initialOddLabel = self.initialOddLabels[i];
            if (i == 0) {
                initialOddLabel.text = asiaOddsCellStatus.initialOdds.above;
            }else if (i == 1)
            {
                initialOddLabel.text = asiaOddsCellStatus.initialOdds.bet;
            }else if (i == 2)
            {
                initialOddLabel.text = asiaOddsCellStatus.initialOdds.below;
            }
        }
        //即时赔率
        for (int i = 0; i < self.oddsTrendViews.count; i++) {
            YZFBMatchDetailOddsTrendView * oddsTrendView = self.oddsTrendViews[i];
            if (i == 0) {
                oddsTrendView.odds = asiaOddsCellStatus.realTimeOdds.above;
                oddsTrendView.trend = asiaOddsCellStatus.realTimeOdds.aboveTrend;
            }else if (i == 1)
            {
                oddsTrendView.odds = asiaOddsCellStatus.realTimeOdds.bet;
                oddsTrendView.trend = 0;
            }else if (i == 2)
            {
                oddsTrendView.odds = asiaOddsCellStatus.realTimeOdds.below;
                oddsTrendView.trend = asiaOddsCellStatus.realTimeOdds.belowTrend;
            }
        }
    }else if (_oddsCellStatus.oddsType == 2)//大小盘
    {
        YZOverUnderCellStatus * overUnderCellStatus = (YZOverUnderCellStatus *)_oddsCellStatus;
        //初始赔率
        for (int i = 0; i < self.initialOddLabels.count; i++) {
            UILabel * initialOddLabel = self.initialOddLabels[i];
            if (i == 0) {
                initialOddLabel.text = overUnderCellStatus.initialOdds.up;
            }else if (i == 1)
            {
                initialOddLabel.text = overUnderCellStatus.initialOdds.bet;
            }else if (i == 2)
            {
                initialOddLabel.text = overUnderCellStatus.initialOdds.low;
            }
        }
        //即时赔率
        for (int i = 0; i < self.oddsTrendViews.count; i++) {
            YZFBMatchDetailOddsTrendView * oddsTrendView = self.oddsTrendViews[i];
            if (i == 0) {
                oddsTrendView.odds = overUnderCellStatus.realTimeOdds.up;
                oddsTrendView.trend = overUnderCellStatus.realTimeOdds.upTrend;
            }else if (i == 1)
            {
                oddsTrendView.odds = overUnderCellStatus.realTimeOdds.bet;
                oddsTrendView.trend = 0;
            }else if (i == 2)
            {
                oddsTrendView.odds = overUnderCellStatus.realTimeOdds.low;
                oddsTrendView.trend = overUnderCellStatus.realTimeOdds.lowTrend;
            }
        }
    }
}
#pragma mark - 初始化
- (NSMutableArray *)initialOddLabels
{
    if (!_initialOddLabels) {
        _initialOddLabels = [NSMutableArray array];
    }
    return _initialOddLabels;
}
- (NSMutableArray *)oddsTrendViews
{
    if (!_oddsTrendViews) {
        _oddsTrendViews = [NSMutableArray array];
    }
    return _oddsTrendViews;
}
@end
