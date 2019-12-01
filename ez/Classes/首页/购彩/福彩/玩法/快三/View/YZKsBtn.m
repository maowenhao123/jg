//
//  YZKsBtn.m
//  ez
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height

#import "YZKsBtn.h"

@interface YZKsBtn ()

@property (nonatomic, weak) UIImageView *chipView;

@end

@implementation YZKsBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.33].CGColor;
        self.backgroundColor = YZColor(130, 198, 135, 0.33);
        
        UIImageView * chipView = [[UIImageView alloc]initWithFrame:CGRectMake(KWidth - 16.5, 3.5, 13, 9)];
        self.chipView = chipView;
        chipView.image = [UIImage imageNamed:@"ks_chip"];
        chipView.hidden = YES;
        [self addSubview:chipView];
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
    self.chipView.hidden = NO;
}
- (void)btnChangeNormal
{
    self.selected = NO;
    self.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.33].CGColor;
    self.backgroundColor = YZColor(130, 198, 135, 0.33);
    self.chipView.hidden = YES;
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
