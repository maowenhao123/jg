//
//  YZSanBuChongDanView.m
//  ez
//
//  Created by dahe on 2020/1/17.
//  Copyright © 2020 9ge. All rights reserved.
//

#import "YZSanBuChongDanView.h"

@interface YZSanBuChongDanView ()

@property (nonatomic, strong) NSMutableArray *tuoBallButtons;
@property (nonatomic, strong) NSMutableArray *danBallButtons;

@end

@implementation YZSanBuChongDanView

#pragma mark - 布局子视图
- (void)setupChildViews
{
    [super setupChildViews];
    
    CGFloat maxY = CGRectGetMaxY(self.titleLabel.frame) + 10;
    for (int i = 0; i < 2; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        if (i == 0) {
            titleLabel.attributedText = [self getAttributedStringWithBlackText:@"胆码" grayText:@"（至少选1个，最多选2个）"];
        }else if (i == 1)
        {
            titleLabel.attributedText = [self getAttributedStringWithBlackText:@"拖码" grayText:@"（拖码、胆码之和大于3个）"];
        }
        titleLabel.frame = CGRectMake(YZMargin, maxY + 10, screenWidth - 2 * YZMargin, 20);
        [self addSubview:titleLabel];
        maxY = CGRectGetMaxY(titleLabel.frame) + 5;
        
        CGFloat buttonPadding = YZMargin;
        CGFloat buttonH = 40;
        CGFloat buttonW = (screenWidth - 50 - 5 * buttonPadding) / 4;
        for (int j = 0; j < 8; j++) {
            UIButton * numberButton = [UIButton buttonWithType:UIButtonTypeCustom];
            numberButton.tag = 100 + i * 10 + j;
            numberButton.frame = CGRectMake(50 + buttonPadding + (buttonW + buttonPadding) * (j % 4), maxY + (buttonH + buttonPadding) * (j / 4), buttonW, buttonH);
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
                [self.danBallButtons addObject:numberButton];
            }else if (i == 1)
            {
                [self.tuoBallButtons addObject:numberButton];
            }
            if (j == 7) {
                maxY = CGRectGetMaxY(numberButton.frame) + 5;
            }
        }
    }
}

- (void)numberButtonDidClick:(UIButton *)button
{
    int selectedDanCount = 0;
    for (UIButton * danBallButton in self.danBallButtons) {
        if (danBallButton.selected) {
            selectedDanCount ++;
        }
    }
    if (!button.selected && button.tag < 110 && selectedDanCount >= 2) {
        [MBProgressHUD showError:@"胆码最多选择2个"];
        return;
    }
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
    for (UIButton * button in self.tuoBallButtons) {
        button.selected = NO;
        button.layer.borderWidth = 1;
    }
    for (UIButton * button in self.danBallButtons) {
        button.selected = NO;
        button.layer.borderWidth = 1;
    }
}

#pragma mark - 初始化
- (NSMutableArray *)danBallButtons
{
    if (_danBallButtons == nil) {
        _danBallButtons = [NSMutableArray array];
    }
    return _danBallButtons;
}

- (NSMutableArray *)tuoBallButtons
{
    if (_tuoBallButtons == nil) {
        _tuoBallButtons = [NSMutableArray array];
    }
    return _tuoBallButtons;
}

#pragma mark - 富文本
- (NSMutableAttributedString *)getAttributedStringWithBlackText:(NSString *)blackText grayText:(NSString *)grayText
{
    NSString * string = [NSString stringWithFormat:@"%@ %@", blackText, grayText];
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc]initWithString:string];
    [attString addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:[attString.string rangeOfString:blackText]];
    [attString addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:[attString.string rangeOfString:grayText]];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:[attString.string rangeOfString:blackText]];
    [attString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:[attString.string rangeOfString:grayText]];
    return attString;
}

@end
