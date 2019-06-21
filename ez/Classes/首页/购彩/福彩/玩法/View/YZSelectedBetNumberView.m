//
//  YZSelectedBetNumberView.m
//  ez
//
//  Created by 毛文豪 on 2017/12/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZSelectedBetNumberView.h"

@interface YZSelectedBetNumberView ()<UIGestureRecognizerDelegate>

@property (nonatomic,weak) UIView *contentView;

@end

@implementation YZSelectedBetNumberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    CGFloat contentViewH = 62;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - (49 + [YZTool getSafeAreaBottom]) - contentViewH, screenWidth, contentViewH)];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    
    //按钮
    CGFloat buttonH = 30;
    CGFloat buttonY = (contentViewH - buttonH) / 2;
    CGFloat buttonX = 25;
    CGFloat buttonW = 80;
    CGFloat buttonPadding = (self.width - 2 * buttonX - 3 * buttonW) / 2;
    NSArray * buttonTitles = @[@"1注", @"5注", @"10注"];
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(buttonX + (buttonW + buttonPadding) * i, buttonY, buttonW, buttonH);
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        [button setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:button.bounds] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage ImageFromColor:YZColor(238, 238, 238, 1) WithRect:button.bounds] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.borderColor = YZColor(213, 213, 213, 1).CGColor;
        button.layer.borderWidth = 1;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2;
        [contentView addSubview:button];
    }
}

- (void)buttonDidClick:(UIButton *)button
{
    [self hiddenView];
    NSArray * numbers = @[@"1", @"5", @"10"];
    if([_delegate respondsToSelector:@selector(selectedBetNumberViewSelectedNumber:)])
    {
        [_delegate selectedBetNumberViewSelectedNumber:[numbers[button.tag] integerValue]];
    }
}

- (void)hiddenView
{
    [UIView animateWithDuration:animateDuration animations:^{
        self.contentView.frame = CGRectMake(0, self.height - tabBarH, screenWidth, 0);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint pos = [touch locationInView:self.contentView.superview];
        if (CGRectContainsPoint(self.contentView.frame, pos)) {
            return NO;
        }
    }
    return YES;
}

@end
