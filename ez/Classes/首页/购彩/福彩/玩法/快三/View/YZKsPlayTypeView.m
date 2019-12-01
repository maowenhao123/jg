//
//  YZKsPlayTypeView.m
//  ez
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define KWidth screenWidth
#define KHeight 200
#import "YZKsPlayTypeView.h"

@interface YZKsPlayTypeView()

@property (nonatomic, strong) NSArray *btnTitles;
@property (nonatomic, strong) NSArray *btnSelTitles;
@property (nonatomic, weak) UIButton *selButton;

@end

@implementation YZKsPlayTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    CGFloat padding = 5;
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding * 2, 15, screenWidth - padding * 4, 30)];
    titleLabel.text = @"  普通投注";
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(32)];
    titleLabel.backgroundColor = YZColor(0, 0, 0, 0.05);
    [self addSubview:titleLabel];
    
    for (int i = 0; i < 5; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        
        CGFloat buttonW = (KWidth - 6 * padding) / 3;
        CGFloat buttonH = 60;
        if (i == 0) {
            buttonH = buttonH * 2 + padding;
        }
        CGFloat buttonX = 2 * padding;
        if (i == 1 || i == 3) {
            buttonX = 3 * padding + buttonW;
        }else if (i == 2 || i == 4)
        {
            buttonX = 4 * padding + 2 * buttonW;
        }
        CGFloat buttonY = CGRectGetMaxY(titleLabel.frame) + 2 * padding;
        if (i == 3 || i == 4) {
            buttonY = CGRectGetMaxY(titleLabel.frame) + 3 * padding + buttonH;
        }
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
        [button setAttributedTitle:self.btnTitles[i] forState:UIControlStateNormal];
        [button setAttributedTitle:self.btnSelTitles[i] forState:UIControlStateSelected];
        [button setAttributedTitle:self.btnSelTitles[i] forState:UIControlStateHighlighted];
        button.titleLabel.numberOfLines = 2;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 0.8;
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        int KsSelectedPlayTypeBtnTag = [YZUserDefaultTool getIntForKey:@"KsSelectedPlayTypeBtnTag"];
        if (i == KsSelectedPlayTypeBtnTag) {
            self.selButton = button;
            button.selected = YES;
        }else
        {
            button.selected = NO;
        }
    }
}
- (void)buttonClick:(UIButton *)button
{
    if (self.selButton == button) {
        return;
    }
    self.selButton.selected = NO;
    button.selected = YES;
    self.selButton = button;
    [YZUserDefaultTool saveInt:(int)button.tag forKey:@"KsSelectedPlayTypeBtnTag"];
    if (_delegate && [_delegate respondsToSelector:@selector(KsPlayTypeViewButttonClick:)]) {
        [_delegate KsPlayTypeViewButttonClick:button];
    }
}
- (NSArray *)btnTitles
{
    if (_btnTitles == nil) {
        NSMutableAttributedString * attStr1 = [[NSMutableAttributedString alloc]initWithString:@"和值\n奖金9-240元"];
        [attStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(2, attStr1.length - 2)];
        [attStr1 addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, attStr1.length)];
        
        NSMutableAttributedString * attStr2 = [[NSMutableAttributedString alloc]initWithString:@"三同号\n奖金40-240元"];
        [attStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(3, attStr2.length - 3)];
        [attStr2 addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, attStr2.length)];
        
        NSMutableAttributedString * attStr3 = [[NSMutableAttributedString alloc]initWithString:@"二同号\n奖金15-80元"];
        [attStr3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(3, attStr3.length - 3)];
        [attStr3 addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, attStr3.length)];
        
        NSMutableAttributedString * attStr4 = [[NSMutableAttributedString alloc]initWithString:@"三不同号\n奖金10-40元"];
        [attStr4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(4, attStr4.length - 4)];
        [attStr4 addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, attStr4.length)];
        
        NSMutableAttributedString * attStr5 = [[NSMutableAttributedString alloc]initWithString:@"二不同号\n奖金8元"];
        [attStr5 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(4, attStr5.length - 4)];
        [attStr5 addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, attStr5.length)];
        
        _btnTitles = [NSArray arrayWithObjects:attStr1,attStr2,attStr3,attStr4,attStr5, nil];
        
    }
    return _btnTitles;
}
- (NSArray *)btnSelTitles
{
    if (_btnSelTitles == nil) {
        NSMutableAttributedString * attStr1 = [[NSMutableAttributedString alloc]initWithString:@"和值\n奖金9-240元"];
        [attStr1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(2, attStr1.length - 2)];
        [attStr1 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr1.length)];
        
        NSMutableAttributedString * attStr2 = [[NSMutableAttributedString alloc]initWithString:@"三同号\n奖金40-240元"];
        [attStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(3, attStr2.length - 3)];
        [attStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr2.length)];
        
        NSMutableAttributedString * attStr3 = [[NSMutableAttributedString alloc]initWithString:@"二同号\n奖金15-80元"];
        [attStr3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(3, attStr3.length - 3)];
        [attStr3 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr3.length)];
        
        NSMutableAttributedString * attStr4 = [[NSMutableAttributedString alloc]initWithString:@"三不同号\n奖金10-40元"];
        [attStr4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(4, attStr4.length - 4)];
        [attStr4 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr4.length)];
        
        NSMutableAttributedString * attStr5 = [[NSMutableAttributedString alloc]initWithString:@"二不同号\n奖金8元"];
        [attStr5 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(4, attStr5.length - 4)];
        [attStr5 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attStr5.length)];
        
        _btnSelTitles = [NSArray arrayWithObjects:attStr1,attStr2,attStr3,attStr4,attStr5, nil];
        
    }
    return _btnSelTitles;
}
@end
