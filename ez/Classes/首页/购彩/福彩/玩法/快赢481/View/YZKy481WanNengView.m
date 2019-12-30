//
//  YZKy481WanNengView.m
//  ez
//
//  Created by dahe on 2019/11/5.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481WanNengView.h"

@interface YZKy481WanNengView ()

@property (nonatomic, strong) NSMutableArray *ballButtons;

@end

@implementation YZKy481WanNengView

#pragma mark - 布局子视图
- (void)setupChildViews
{
    [super setupChildViews];
    //号码
    CGFloat padding = 1.5;
    CGFloat allballButtonW = screenWidth - 2 * YZMargin;
    CGFloat ballButtonW = (allballButtonW  - 9 * padding) / 10;
    CGFloat ballButtonH = ballButtonW * 1.2;
    UIView * allBallView = [[UIView alloc] initWithFrame:CGRectMake(YZMargin, CGRectGetMaxY(self.titleLabel.frame) + 10, screenWidth - 2 * YZMargin, ballButtonH * 5 + padding * 4)];
    allBallView.backgroundColor = [UIColor whiteColor];
    [self addSubview:allBallView];
    
    NSArray * ballNumbers = @[
                             @[@"0", @"28", @"37", @"46", @"55"],
                             @[@"1", @"38", @"47", @"56", @""],
                             @[@"2", @"11", @"48", @"57", @"66"],
                             @[@"3", @"12", @"58", @"67", @""],
                             @[@"4", @"13", @"22", @"68", @"77"],
                             @[@"5", @"14", @"23", @"78", @""],
                             @[@"6", @"15", @"24", @"33", @"88"],
                             @[@"7", @"16", @"25", @"34", @""],
                             @[@"8", @"17", @"26", @"35", @"44"],
                             @[@"9", @"18", @"27", @"36", @"45"]
                             ];
    for (int i = 0; i < ballNumbers.count; i++) {
        NSArray *ballNumbers_ = ballNumbers[i];
        NSMutableArray * ballButtons = [NSMutableArray array];
        for (int j = 0; j < ballNumbers_.count; j++) {
            NSString * ballNumber = ballNumbers_[j];
            UIButton * ballButton = [UIButton buttonWithType:UIButtonTypeCustom];
            ballButton.tag = i;
            if (j == 0) {
                ballButton.frame = CGRectMake((ballButtonW + padding) * i, (ballButtonH + padding) * j, ballButtonW, ballButtonW);
                [ballButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                if (i % 2 == 0) {
                    [ballButton setBackgroundImage:[UIImage ImageFromColor:RGBACOLOR(103, 193, 229, 1)] forState:UIControlStateNormal];
                }else
                {
                    [ballButton setBackgroundImage:[UIImage ImageFromColor:RGBACOLOR(236, 173, 127, 1)] forState:UIControlStateNormal];
                }
                ballButton.layer.masksToBounds = YES;
                ballButton.layer.cornerRadius = ballButtonW / 2;
                
                UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake((ballButtonW + padding) * i, (ballButtonH + padding) * j + ballButtonW * 0.5, ballButtonW, ballButtonH - ballButtonW * 0.5)];
                if (i % 2 == 0) {
                    bgView.backgroundColor = RGBACOLOR(185, 219, 229, 1);
                }else
                {
                    bgView.backgroundColor = RGBACOLOR(228, 217, 176, 1);
                }
                [allBallView addSubview:bgView];
            }else
            {
                ballButton.frame = CGRectMake((ballButtonW + padding) * i, (ballButtonH + padding) * j, ballButtonW, ballButtonH);
                [ballButton setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
                if (i % 2 == 0) {
                    [ballButton setBackgroundImage:[UIImage ImageFromColor:RGBACOLOR(185, 219, 229, 1)] forState:UIControlStateNormal];
                    [ballButton setBackgroundImage:[UIImage ImageFromColor:RGBACOLOR(185, 219, 229, 1)] forState:UIControlStateDisabled];
                }else
                {
                    [ballButton setBackgroundImage:[UIImage ImageFromColor:RGBACOLOR(228, 217, 176, 1)] forState:UIControlStateNormal];
                    [ballButton setBackgroundImage:[UIImage ImageFromColor:RGBACOLOR(228, 217, 176, 1)] forState:UIControlStateDisabled];
                }
            }
            [ballButton setTitle:ballNumber forState:UIControlStateNormal];
            [ballButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [ballButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [ballButton setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
            [ballButton setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
            ballButton.adjustsImageWhenHighlighted = NO;
            ballButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
            if (!YZStringIsEmpty(ballButton.currentTitle)) {
                ballButton.enabled = YES;
                [ballButton addTarget:self action:@selector(ballButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
            }else
            {
                ballButton.enabled = NO;
            }
            [allBallView addSubview:ballButton];
            
            [ballButtons addObject:ballButton];
        }
        [self.ballButtons addObject:ballButtons];
    }
    
    //温馨提示
    UILabel * footerLabel = [[UILabel alloc]init];
    footerLabel.numberOfLines = 0;
    NSString * footerStr =  @"      万能两码说明：从投注卡0-9下方数字选择1组号码，开奖号码若包含您所选择的2位号码即中奖！";
    NSMutableAttributedString * footerAttStr = [[NSMutableAttributedString alloc]initWithString:footerStr];
    [footerAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(0, footerAttStr.length)];
    [footerAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, footerAttStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [footerAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, footerAttStr.length)];
    footerLabel.attributedText = footerAttStr;
    CGSize size = [footerLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - 2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    footerLabel.frame = CGRectMake(YZMargin, CGRectGetMaxY(allBallView.frame) + 10, size.width, size.height);
    [self addSubview:footerLabel];
}

- (void)ballButtonDidClick:(UIButton *)button
{
    button.selected = !button.selected;
    
    NSMutableArray * ballButtons = self.ballButtons[button.tag];
    if ([button.currentTitle intValue] < 10) {
        for (UIButton * ballButton in ballButtons) {
            if (!YZStringIsEmpty(ballButton.currentTitle)) {
                if (ballButton.selected != button.selected) {
                    ballButton.selected = button.selected;
                    if([self.delegate respondsToSelector:@selector(ballDidClick:)])
                    {
                        [self.delegate ballDidClick:(YZBallBtn *)ballButton];
                    }
                }
            }
        }
    }else
    {
        if([self.delegate respondsToSelector:@selector(ballDidClick:)])
        {
            [self.delegate ballDidClick:(YZBallBtn *)button];
        }
        
        UIButton * ballButton0 = ballButtons[0];
        BOOL allSelected = YES;
        for (int i = 1; i < ballButtons.count; i++) {
            UIButton * ballButton = ballButtons[i];
            if (!ballButton.selected && !YZStringIsEmpty(ballButton.currentTitle)) {
                allSelected = NO;
                break;
            }
        }
        ballButton0.selected = allSelected;
    }
}

#pragma mark - Setting
- (void)setRandomTitle:(NSString *)randomTitle
{
    _randomTitle = randomTitle;
    
    for (NSArray * ballButtons in self.ballButtons) {
        for (UIButton * button in ballButtons) {
            if ([button.currentTitle isEqualToString:_randomTitle]) {
                [self ballButtonDidClick:button];
            }
        }
    }
}

- (void)reloadData
{
    for (NSArray * ballButtons in self.ballButtons) {
        for (UIButton * button in ballButtons) {
            button.selected = NO;
        }
    }
}

#pragma mark - 初始化
- (NSMutableArray *)ballButtons
{
    if (_ballButtons == nil) {
        _ballButtons = [NSMutableArray array];
    }
    return _ballButtons;
}

@end
