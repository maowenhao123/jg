//
//  YZKy481BaView.m
//  ez
//
//  Created by dahe on 2019/12/27.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481BaView.h"

@interface YZKy481BaView ()

@property (nonatomic, strong) NSMutableArray *numberButtons;

@end

@implementation YZKy481BaView

#pragma mark - 布局子视图
- (void)setupChildViews
{
    [super setupChildViews];
    
    CGFloat buttonW = 110;
    CGFloat buttonH = 36;
    CGFloat buttonPadding = (screenWidth - 2 * buttonW) / 3;
    for (int i = 0; i < 8; i++) {
        UIButton * numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
        numberButton.tag = i;
        numberButton.frame = CGRectMake(buttonPadding + (buttonW + buttonPadding) * (i % 2), CGRectGetMaxY(self.titleLabel.frame) + 20 + (buttonH + buttonH) * (i / 2), buttonW, buttonH);
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
        numberButton.hidden = YES;
        [numberButton addTarget:self action:@selector(numberButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:numberButton];
        
        [self.numberButtons addObject:numberButton];
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
}

#pragma mark - Setting
- (void)setSelectedPlayTypeBtnTagWith:(NSInteger)selectedPlayTypeBtnTag
{
    for (int i = 0; i < self.numberButtons.count; i++) {
        UIButton * numberButton = self.numberButtons[i];
        CGFloat buttonW = 110;
        CGFloat buttonH = 36;
        CGFloat buttonPadding = (screenWidth - 2 * buttonW) / 3;
        numberButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(34)];
        if (selectedPlayTypeBtnTag == 19) {
            numberButton.hidden = i > 1;
            if (i < 2) {
                numberButton.frame = CGRectMake(buttonPadding + (buttonW + buttonPadding) * (i % 2), CGRectGetMaxY(self.titleLabel.frame) + 20 + (buttonH + buttonH) * (i / 2), buttonW, buttonH);
            }
            if (i == 0) {
                [numberButton setTitle:@"组4形态(4)" forState:UIControlStateNormal];
            }else if (i == 1)
            {
                [numberButton setTitle:@"组6形态(6)" forState:UIControlStateNormal];
            }
            numberButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
        }else if (selectedPlayTypeBtnTag == 20)
        {
            numberButton.hidden = i > 0;
            if (i < 1) {
                numberButton.y = CGRectGetMaxY(self.titleLabel.frame) + 40;
                numberButton.centerX = self.centerX;
                [numberButton setTitle:@"拖拉机" forState:UIControlStateNormal];
            }
        }else
        {
            numberButton.hidden = NO;
            numberButton.frame = CGRectMake(buttonPadding + (buttonW + buttonPadding) * (i % 2), CGRectGetMaxY(self.titleLabel.frame) + 20 + (buttonH + buttonH) * (i / 2), buttonW, buttonH);
            if (selectedPlayTypeBtnTag == 11 || selectedPlayTypeBtnTag == 15 || selectedPlayTypeBtnTag == 16 || selectedPlayTypeBtnTag == 17) {
                [numberButton setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
            }else if (selectedPlayTypeBtnTag == 13)
            {
                [numberButton setTitle:[NSString stringWithFormat:@"%d%dX", i + 1, i + 1] forState:UIControlStateNormal];
            }else if (selectedPlayTypeBtnTag == 14)
            {
                [numberButton setTitle:[NSString stringWithFormat:@"%dXX", i + 1] forState:UIControlStateNormal];
            }else if (selectedPlayTypeBtnTag == 18)
            {
                [numberButton setTitle:[NSString stringWithFormat:@"豹子%d", i + 1] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - 初始化
- (NSMutableArray *)numberButtons
{
    if (_numberButtons == nil) {
        _numberButtons = [NSMutableArray array];
    }
    return _numberButtons;
}

@end
