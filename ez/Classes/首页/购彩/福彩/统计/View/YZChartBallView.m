//
//  YZChartBallView.m
//  ez
//
//  Created by apple on 17/3/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZChartBallView.h"

@interface YZChartBallView ()

@property (nonatomic, weak) UIButton *ballView;

@end

@implementation YZChartBallView

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
- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat ballViewWH = self.width < self.height ? self.width : self.height;
    self.ballView.frame = CGRectMake(0, 0, ballViewWH, ballViewWH);
    self.ballView.center = CGPointMake(self.width / 2, self.height / 2);
}
- (void)setupChilds
{
    UIButton * ballView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ballView = ballView;
    ballView.adjustsImageWhenHighlighted = NO;
    [ballView setBackgroundImage:[UIImage imageNamed:@"ball_flat"] forState:UIControlStateNormal];
    [ballView setTitleColor:YZRedBallColor forState:UIControlStateNormal];
    ballView.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [ballView addTarget:self action:@selector(ballDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:ballView];
}
- (void)ballDidClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(ballDidClick:)]) {
        [_delegate ballDidClick:self];
    }
}
- (void)setStatus:(YZChartBallStatus *)status
{
    _status = status;
    [self.ballView setTitle:status.number forState:UIControlStateNormal];
    if (status.selected) {
        [self.ballView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (status.isBlue) {
            [self.ballView setBackgroundImage:[UIImage imageNamed:@"blueBall_flat"] forState:UIControlStateNormal];
        }else
        {
            [self.ballView setBackgroundImage:[UIImage imageNamed:@"redBall_flat"] forState:UIControlStateNormal];
        }
    }else
    {
        if (status.isBlue) {
            [self.ballView setTitleColor:YZBlueBallColor forState:UIControlStateNormal];
        }else
        {
            [self.ballView setTitleColor:YZRedBallColor forState:UIControlStateNormal];
        }
        [self.ballView setBackgroundImage:[UIImage imageNamed:@"ball_flat"] forState:UIControlStateNormal];
    }
}
- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    self.ballView.titleLabel.font = _textFont;
}
@end
