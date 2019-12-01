//
//  YZBallBtn.m
//  ez
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#import "YZBallBtn.h"

@implementation YZBallBtn

+ (YZBallBtn *)button
{
    YZBallBtn *btn = [YZBallBtn buttonWithType:UIButtonTypeCustom];
    return btn;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addTarget:self action:@selector(ballClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setImage:[UIImage imageNamed:@"ball_flat"] forState:UIControlStateNormal];
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(34)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)ballClick:(YZBallBtn *)btn
{
    if(self.isSelected)
    {
        [self setImage:[UIImage imageNamed:@"ball_flat"] forState:UIControlStateNormal];
        [self setTitleColor:self.ballTextColor forState:UIControlStateNormal];
        
    }else
    {
        [self setImage:[UIImage imageNamed:self.selImageName] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    //通知代理已点击ballBtn
    if([self.delegate  respondsToSelector:@selector(ballDidClick:)])
    {
        [self.delegate ballDidClick:self];
    }
    
    self.selected = !self.selected;
}

- (void)ballChangeToWhite
{
    [self setImage:[UIImage imageNamed:@"ball_flat"] forState:UIControlStateNormal];
    [self setTitleColor:self.ballTextColor forState:UIControlStateNormal];
    self.selected = NO;
}

- (void)ballChangeToRed
{
    [self setImage:[UIImage imageNamed:@"redBall_flat"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selected = YES;
}

- (void)ballChangeBlue
{
    [self setImage:[UIImage imageNamed:@"blueBall_flat"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.selected = YES;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return contentRect;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return contentRect;
}

@end
