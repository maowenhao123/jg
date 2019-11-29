//
//  YZChartSsqPlaytypeView.m
//  ez
//
//  Created by apple on 17/3/10.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZChartSsqPlaytypeView.h"

@interface YZChartSsqPlaytypeView ()

@property (nonatomic, weak) UIView *playtypeView;
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, assign, getter=isDantuo) BOOL dantuo;

@end

@implementation YZChartSsqPlaytypeView

- (instancetype)initWithIsDantuo:(BOOL)isDantuo
{
    self = [super init];
    if (self) {
        self.dantuo = isDantuo;
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    self.frame = KEY_WINDOW.bounds;
    UIView *topView = [KEY_WINDOW.subviews firstObject];
    [topView addSubview:self];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
    
    //palytypeView
    UIView * playtypeView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarH + navBarH, screenWidth, 0)];
    self.playtypeView = playtypeView;
    playtypeView.backgroundColor = YZChartBackgroundColor;
    playtypeView.layer.masksToBounds = YES;
    [self addSubview:playtypeView];
    
    CGFloat buttonH = 30;
    CGFloat buttonW = 105;
    CGFloat padding = playtypeView.width - 2 * buttonW;
    NSArray * buttonTitles = @[@"普通投注",@"胆拖投注"];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(padding * 0.4 + i * (buttonW + padding * 0.2), 15, buttonW, buttonH);
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [button setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [button setTitleColor:YZRedTextColor forState:UIControlStateSelected];
        [button setTitleColor:YZRedTextColor forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"chart_playtype_weixuanzhong"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"chart_playtype_xuanzhong"] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"chart_playtype_xuanzhong"] forState:UIControlStateSelected];
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        //设置选中状态
        if (self.isDantuo && i == 1) {
            button.selected = YES;
            self.selectedButton = button;
        }else if (!self.isDantuo && i == 0)
        {
            button.selected = YES;
            self.selectedButton = button;
        }else
        {
            button.selected = NO;
        }
        [button addTarget:self action:@selector(playtypeBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [playtypeView addSubview:button];
    }
    //红线
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 58.5, self.width, 1.5)];
    line.backgroundColor = YZRedBallColor;
    [playtypeView addSubview:line];
    
    //动画
    [UIView animateWithDuration:animateDuration animations:^{
        self.playtypeView.height = 60;
    }];
}
- (void)playtypeBtnDidClick:(UIButton *)button
{
    if (button.selected) {
        return;
    }
    
    //修改选中状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    [self hide];//关闭视图
    
    //协议
    if (_delegate && [_delegate respondsToSelector:@selector(changePlaytypeIsDantuo:)]) {
        [_delegate changePlaytypeIsDantuo:button.tag];
    }
}
//隐藏
- (void)hide
{
    [UIView animateWithDuration:animateDuration animations:^{
        self.playtypeView.height = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (_delegate && [_delegate respondsToSelector:@selector(closePlaytypeView)]) {
            [_delegate closePlaytypeView];
        }
    }];
}
@end
