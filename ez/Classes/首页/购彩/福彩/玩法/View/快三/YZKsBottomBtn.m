//
//  YZKsBottomBtn.m
//  ez
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZKsBottomBtn.h"

@implementation YZKsBottomBtn

+ (YZKsBottomBtn *)button
{
    YZKsBottomBtn *btn = [YZKsBottomBtn buttonWithType:UIButtonTypeCustom];
    return btn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.33].CGColor;
        self.backgroundColor = YZColor(130, 198, 135, 0.33);
    }
    return self;
}
- (void)btnClick:(UIButton *)button
{
    self.selected = !self.selected;
    if (self.selected) {
        [self btnChangeSelected];
    }else
    {
        [self btnChangeNormal];
    }
}
- (void)btnChangeSelected
{
    self.selected = YES;
    self.layer.borderColor = YZColor(251, 189, 56, 1).CGColor;
    self.backgroundColor = YZColor(16, 61, 49, 0.33);
}
- (void)btnChangeNormal
{
    self.selected = NO;
    self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.33].CGColor;
    self.backgroundColor = YZColor(130, 198, 135, 0.33);
}
- (void)btnChangeState
{
    self.selected = !self.selected;
    if (self.selected) {
        [self btnChangeSelected];
    }else
    {
        [self btnChangeNormal];
    }
}
@end
