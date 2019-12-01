//
//  YZMenuView.m
//  ez
//
//  Created by 毛文豪 on 2018/12/11.
//  Copyright © 2018 9ge. All rights reserved.
//

#import "YZMenuView.h"

@interface YZMenuView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView * menuView;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSMutableArray *buttonArray;

@end

@implementation YZMenuView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleArray = titleArray;
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    self.backgroundColor = YZColor(0, 0, 0, 0.1);
    self.hidden = YES;
    
    //添加点击事件
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //背景
    CGFloat buttonH = 40;
    CGFloat menuViewW = 120;
    CGFloat menuImageViewX;
    if (self.left) {
        menuImageViewX = 5;
    }else
    {
        menuImageViewX = screenWidth - menuViewW;
    }
    UIView * menuView = [[UIView alloc] init];
    self.menuView = menuView;
    menuView.frame = CGRectMake(menuImageViewX, statusBarH + navBarH, menuViewW, 0);
    menuView.backgroundColor = [UIColor whiteColor];
    [self addSubview:menuView];
    
    menuView.layer.masksToBounds = YES;
    menuView.layer.cornerRadius = 2;
    menuView.layer.borderColor = YZGrayLineColor.CGColor;
    menuView.layer.borderWidth = 0.8;
    
    //菜单按钮
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(0, i * buttonH, menuViewW, buttonH);
        [button setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [button setTitleColor:YZBaseColor forState:UIControlStateSelected];
        [button setTitleColor:YZBaseColor forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:button];
        [self.buttonArray addObject:button];
        
        //分割线
        if (i != self.titleArray.count - 1) {
            UIView * line = [[UIView alloc] initWithFrame:CGRectMake(2, button.height - 1, button.width - 4, 1)];
            line.backgroundColor = YZGrayLineColor;
            [button addSubview:line];
        }
    }
}

- (void)tapDidClick
{
    [UIView animateWithDuration:animateDuration animations:^{
        self.menuView.height = 0;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

- (void)show
{
    CGFloat buttonH = 40;
    CGFloat menuViewH = buttonH * self.titleArray.count;
    self.hidden = NO;
    self.menuView.height = 0;
    [UIView animateWithDuration:animateDuration animations:^{
        self.menuView.height = menuViewH;
    }];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint pos = [touch locationInView:self.menuView.superview];
        if (CGRectContainsPoint(self.menuView.frame, pos)) {
            return NO;
        }
    }
    return YES;
}

- (void)buttonDidClick:(UIButton *)button
{
    [self tapDidClick];
    if (_delegate && [_delegate respondsToSelector:@selector(menuViewButtonDidClick:)]) {
        [_delegate menuViewButtonDidClick:button];
    }
}

- (NSMutableArray *)buttonArray
{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

@end
