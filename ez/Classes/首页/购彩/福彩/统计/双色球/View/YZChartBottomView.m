//
//  YZChartBottomView.m
//  ez
//
//  Created by apple on 17/3/3.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZChartBottomView.h"

@interface YZChartBottomView ()

@property (nonatomic, weak) UIButton *button;

@end

@implementation YZChartBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    //分割线
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [self addSubview:line];
 
    //确认按钮
    YZBottomButton *confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.button = confirmBtn;
    CGFloat confirmBtnH = 30;
    CGFloat confirmBtnW = 75;
    confirmBtn.frame = CGRectMake(screenWidth - confirmBtnW - YZMargin, (self.height - confirmBtnH) / 2, confirmBtnW, confirmBtnH);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.layer.cornerRadius = 2;
    [self addSubview:confirmBtn];
    
    //时间label
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(YZMargin, 0, confirmBtn.x - 5 * 2, self.height)];
    self.label = label;
    label.text = @"未能获取彩期";
    label.textColor = YZBlackTextColor;
    label.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [self addSubview:label];
}
- (void)confirmBtnClick:(UIButton *)button
{
    //协议
    if (_delegate && [_delegate respondsToSelector:@selector(confirmBuy)]) {
        [_delegate confirmBuy];
    }
}
- (void)setCanBuy:(BOOL)canBuy
{
    _canBuy = canBuy;
    if (!_canBuy && (self.label.centerX != self.centerX || self.button.alpha == 1)) {//label居中 button 隐藏
        [UIView animateWithDuration:animateDuration
                         animations:^{
                             self.label.centerX = self.centerX;
                             self.label.textAlignment = NSTextAlignmentCenter;
                             self.button.alpha = 0;
                         }];
    }else if (_canBuy && (self.label.x != 5 || self.button.alpha == 0))//靠左  button 显示
    {
        [UIView animateWithDuration:animateDuration
                         animations:^{
                             self.label.x = YZMargin;
                             self.label.textAlignment = NSTextAlignmentLeft;
                             self.button.alpha = 1;
                         }];
    }
}

@end
