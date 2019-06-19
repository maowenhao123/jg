//
//  YZMultipleKeyboardView.m
//  ez
//
//  Created by 毛文豪 on 2018/7/11.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZMultipleKeyboardView.h"

@interface YZMultipleKeyboardView ()

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UILabel *multipleLabel;
@property (nonatomic, copy) NSString *multiple;

@end


@implementation YZMultipleKeyboardView

- (instancetype)initWithMultiple:(NSString *)multiple
{
    self = [super init];
    if (self) {
        self.multiple = multiple;
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = YZColor(0, 0, 0, 0.3);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight, screenWidth, 0)];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
 
    //倍数
    UILabel * multipleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 40)];
    self.multipleLabel = multipleLabel;
    multipleLabel.text = @"投1倍";
    multipleLabel.textColor = YZBlackTextColor;
    multipleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(32)];
    multipleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:multipleLabel];
    
    UIImageView * arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 15, 15)];
    arrowImageView.image = [UIImage imageNamed:@"down_arrow_black"];
    [contentView addSubview:arrowImageView];
    
    //分割线
    UIView * line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(multipleLabel.frame), screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [contentView addSubview:line];
    
    //倍数按钮
    NSArray * multipleButonTitles = @[@"5倍", @"10倍", @"20倍", @"50倍", @"100倍"];
    CGFloat multipleButonPadding = 12;
    CGFloat multipleButtonW = (screenWidth - (multipleButonTitles.count + 1) * multipleButonPadding) / multipleButonTitles.count;
    CGFloat multipleButtonH = 35;
    UIView * lastView;
    for (int i = 0; i < multipleButonTitles.count; i++) {
        UIButton * multipleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        multipleButton.backgroundColor = YZBackgroundColor;
        multipleButton.frame = CGRectMake(multipleButonPadding + (multipleButonPadding + multipleButtonW) * i, CGRectGetMaxY(line.frame) + 7, multipleButtonW, multipleButtonH);
        [multipleButton setTitle:multipleButonTitles[i] forState:UIControlStateNormal];
        [multipleButton setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        multipleButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        multipleButton.layer.masksToBounds = YES;
        multipleButton.layer.cornerRadius = 2;
        [multipleButton addTarget:self action:@selector(multipleButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:multipleButton];
        
        lastView = multipleButton;
    }
    
    //自定义倍数
    NSArray * numberButonTitles = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"退格", @"0", @"确定"];
    CGFloat numberButtonW = screenWidth / 3;
    CGFloat numberButtonH = 50;
    for (int i = 0; i < numberButonTitles.count; i++) {
        UIButton * numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        numberButton.backgroundColor = [UIColor whiteColor];
        numberButton.frame = CGRectMake(numberButtonW * (i % 3), CGRectGetMaxY(lastView.frame) + 7 + numberButtonH * (i / 3), numberButtonW, numberButtonH);
        [numberButton setTitle:numberButonTitles[i] forState:UIControlStateNormal];
        [numberButton setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        if ([numberButton.currentTitle isEqualToString:@"确定"] || [numberButton.currentTitle isEqualToString:@"退格"]) {
            numberButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
        }else
        {
            numberButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(35)];
        }
        numberButton.layer.borderWidth = 0.8;
        numberButton.layer.borderColor = YZWhiteLineColor.CGColor;
        [numberButton addTarget:self action:@selector(numberButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:numberButton];
        
        if (i == numberButonTitles.count - 1) {
            lastView = numberButton;
        }
    }
    
    contentView.height = CGRectGetMaxY(lastView.frame) + [YZTool getSafeAreaBottom];
}

- (void)multipleButtonDidClick:(UIButton *)button
{
    self.multiple = [button.currentTitle stringByReplacingOccurrencesOfString:@"倍" withString:@""];
}

- (void)numberButtonDidClick:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"确定"]) {
        [self hide];
        return;
    }
    
    if ([button.currentTitle isEqualToString:@"退格"]) {
        if (self.multiple.length == 1 || self.multiple.length == 0) {
            self.multiple = @"";
        }else
        {
            self.multiple = [self.multiple substringToIndex:self.multiple.length - 1];
        }
        return;
    }
    
    NSString * multiple = [NSString stringWithFormat:@"%@%@", self.multiple, button.currentTitle];
    if ([multiple longLongValue] > 10000) {
        multiple = @"10000";
    }
    self.multiple = multiple;
}

- (void)setMultiple:(NSString *)multiple
{
    _multiple = multiple;
    
    if (_multiple.length == 0) {
        self.multipleLabel.text = @"投1倍";
        if (_delegate && [_delegate respondsToSelector:@selector(multipleKeyboardViewDidChangeMultiple:)]) {
            [_delegate multipleKeyboardViewDidChangeMultiple:@"1"];
        }
    }else
    {
        self.multipleLabel.text = [NSString stringWithFormat:@"投%@倍", _multiple];
        if (_delegate && [_delegate respondsToSelector:@selector(multipleKeyboardViewDidChangeMultiple:)]) {
            [_delegate multipleKeyboardViewDidChangeMultiple:_multiple];
        }
    }
}

- (void)show{
    UIView *topView = [KEY_WINDOW.subviews firstObject];
    [topView addSubview:self];
    
    [UIView animateWithDuration:animateDuration animations:^{
        self.contentView.y = screenHeight - self.contentView.height;
    }];
}

- (void)hide{
    [UIView animateWithDuration:animateDuration animations:^{
        self.alpha = 0;
        self.contentView.y = screenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
