//
//  YZChongDanView.m
//  ez
//
//  Created by dahe on 2019/12/30.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZChongDanView.h"

@interface YZChongDanView ()

@property (nonatomic, strong) NSMutableArray *chongBallButtons;
@property (nonatomic, strong) NSMutableArray *danBallButtons;

@end

@implementation YZChongDanView

#pragma mark - 布局子视图
- (void)setupChildViews
{
    [super setupChildViews];
    
    CGFloat maxY = CGRectGetMaxY(self.titleLabel.frame) + 10;
    for (int i = 0; i < 2; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        if (i == 0) {
            titleLabel.text = @"重号";
        }else if (i == 1)
        {
            titleLabel.text = @"单号";
        }
        titleLabel.textColor = YZBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        CGSize titleLabelSize = [titleLabel.text sizeWithLabelFont:titleLabel.font];
        titleLabel.frame = CGRectMake(YZMargin, maxY, titleLabelSize.width + 5, titleLabelSize.height + 5);
        [self addSubview:titleLabel];
        maxY = CGRectGetMaxY(titleLabel.frame) + 3;
        
        CGFloat buttonPadding = YZMargin;
        CGFloat buttonH = 40;
        CGFloat buttonW = (screenWidth - CGRectGetMaxX(titleLabel.frame) - 5 * buttonPadding) / 4;
        for (int j = 0; j < 8; j++) {
            UIButton * numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
            numberButton.tag = 100 + i * 10 + j;
            numberButton.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + buttonPadding + (buttonW + buttonPadding) * (j % 4), maxY + (buttonH + buttonPadding) * (j / 4), buttonW, buttonH);
            [numberButton setTitle:[NSString stringWithFormat:@"%d", j + 1] forState:UIControlStateNormal];
            [numberButton setTitleColor:YZBaseColor forState:UIControlStateNormal];
            [numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [numberButton setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [numberButton setBackgroundImage:[UIImage ImageFromColor:YZBaseColor] forState:UIControlStateSelected];
            numberButton.adjustsImageWhenHighlighted = NO;
            numberButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(34)];
            numberButton.layer.masksToBounds = YES;
            numberButton.layer.cornerRadius = 5;
            numberButton.layer.borderWidth = 1;
            numberButton.layer.borderColor = YZGrayLineColor.CGColor;
            [numberButton addTarget:self action:@selector(numberButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:numberButton];
            if (i == 0) {
                [self.chongBallButtons addObject:numberButton];
            }else if (i == 1)
            {
                [self.danBallButtons addObject:numberButton];
            }
            if (j == 7) {
                maxY = CGRectGetMaxY(numberButton.frame);
            }
        }
    }
}

- (void)numberButtonDidClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        button.layer.borderWidth = 0;
    }else
    {
        button.layer.borderWidth = 1;
    }
    if([self.delegate respondsToSelector:@selector(ballDidClick:)])
    {
        [self.delegate ballDidClick:button];
    }
    
    YZBallBtn * otherButton;
    if (button.tag >= 110) {
        otherButton = [self viewWithTag:button.tag - 10];
    }else
    {
        otherButton = [self viewWithTag:button.tag + 10];
    }
    if (otherButton.selected) {
        otherButton.selected = NO;
        otherButton.layer.borderWidth = 1;
        
        if([self.delegate respondsToSelector:@selector(ballDidClick:)])
        {
            [self.delegate ballDidClick:otherButton];
        }
    }
}

#pragma mark - 刷新数据
- (void)reloadData
{
    for (UIButton * button in self.chongBallButtons) {
        button.selected = NO;
        button.layer.borderWidth = 1;
    }
    for (UIButton * button in self.danBallButtons) {
        button.selected = NO;
        button.layer.borderWidth = 1;
    }
}

#pragma mark - 初始化
- (NSMutableArray *)chongBallButtons
{
    if (_chongBallButtons == nil) {
        _chongBallButtons = [NSMutableArray array];
    }
    return _chongBallButtons;
}

- (NSMutableArray *)danBallButtons
{
    if (_danBallButtons == nil) {
        _danBallButtons = [NSMutableArray array];
    }
    return _danBallButtons;
}

@end
