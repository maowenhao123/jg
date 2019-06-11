//
//  YZWinNumberBall.m
//  ez
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZWinNumberBall.h"

#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height

@interface YZWinNumberBall ()

@property (nonatomic, weak) UIImageView *backgroundView;

@end

@implementation YZWinNumberBall

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupChilds];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChilds];
    }
    return self;
}

- (void)setStatus:(YZWinNumberBallStatus *)status
{
    _status = status;
    
    if (_status.type == 1)
    {
        if (_status.isRecommendLottery) {
            self.backgroundView.image = [UIImage imageNamed:@"recommend_lottery_redBall"];
        }else
        {
            self.backgroundView.image = [UIImage imageNamed:@"winNumber_redBall"];
        }
    }else if (self.status.type == 2)
    {
        if (_status.isRecommendLottery) {
            self.backgroundView.image = [UIImage imageNamed:@"recommend_lottery_blueBall"];
        }else
        {
            self.backgroundView.image = [UIImage imageNamed:@"winNumber_blueBall"];
        }
    }else if (self.status.type == 3)
    {
        self.backgroundView.image = [UIImage imageNamed:@"winNumber_greenBall"];
    }else if (self.status.type == 4)
    {
        self.backgroundView.image = [UIImage imageNamed:@"winNumber_greenRectangle"];
    }
    
    if (_status.isRecommendLottery && _status.type == 1) {
        self.numberLabel.textColor = YZColor(238, 55, 47, 1);
    }else if (_status.isRecommendLottery && _status.type == 2)
    {
        self.numberLabel.textColor = YZColor(32, 146, 241, 1);
    }else
    {
        self.numberLabel.textColor = [UIColor whiteColor];
    }
    self.numberLabel.text = _status.number;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundView.frame = self.bounds;
    self.numberLabel.frame = self.bounds;
}
#pragma mark - 布局子控件
- (void)setupChilds
{
    UIImageView * backgroundView = [[UIImageView alloc]init];
    self.backgroundView = backgroundView;
    backgroundView.image = [UIImage imageNamed:@"choose_number_ball_placeholder"];
    [self addSubview:backgroundView];
    
    UILabel *numberLabel = [[UILabel alloc] init];
    self.numberLabel = numberLabel;
    numberLabel.textColor = [UIColor whiteColor];
    numberLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:numberLabel];
}


@end
