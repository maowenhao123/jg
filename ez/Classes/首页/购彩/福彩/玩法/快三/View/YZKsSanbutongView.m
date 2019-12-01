//
//  YZKsSanbutongView.m
//  ez
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height

#import "YZKsSanbutongView.h"

@interface YZKsSanbutongView ()

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, weak) YZKsBottomBtn *bottomBtn;

@end

@implementation YZKsSanbutongView

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
    //三不同号
    UIButton * butongTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    butongTitleBtn.frame = CGRectMake(10, 9, 70, 22);
    butongTitleBtn.userInteractionEnabled = NO;
    [butongTitleBtn setBackgroundImage:[UIImage resizedImageWithName:@"s1x5SelIcon" left:0.7 top:0] forState:UIControlStateNormal];
    [butongTitleBtn setTitle:@"三不同号 " forState:UIControlStateNormal];
    [butongTitleBtn setTitleColor:YZColor(37, 124, 90, 1) forState:UIControlStateNormal];
    butongTitleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:butongTitleBtn];
    
    UILabel * butongTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(butongTitleBtn.frame) + 5, 0, KWidth, 40)];
    butongTitleLabel.font = [UIFont systemFontOfSize:12];
    NSString * butongTitleStr = @"选3个不同号码，与开奖相同奖金40元";
    NSMutableAttributedString * butongTitleAttStr = [[NSMutableAttributedString alloc]initWithString:butongTitleStr];
    [butongTitleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(183, 183, 183, 1) range:NSMakeRange(0, butongTitleStr.length - 3)];
    [butongTitleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(254, 210, 90, 1) range:NSMakeRange(butongTitleStr.length - 3, 3)];
    butongTitleLabel.attributedText = butongTitleAttStr;
    [self addSubview:butongTitleLabel];
    
    //选号按钮
    CGFloat padding1 = 10;
    CGFloat padding2 = 2;
    CGFloat btnW = (KWidth - 2 * padding1 - 5 * padding2) / 6;
    CGFloat btnH = btnW;
    CGFloat btnY = CGRectGetMaxY(butongTitleLabel.frame);
    YZKsBtn * lastBtn;
    for (int i = 1; i < 7; i++) {
        CGFloat btnX = padding1 + (btnW + padding2) * (i - 1);
        YZKsBtn * btn = [[YZKsBtn alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn.tag = i - 1 + 101;
        NSString * btnTitle = [NSString stringWithFormat:@"%d",i];
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        lastBtn = btn;
        [self.btns addObject:btn];

    }
    
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lastBtn.frame) + btnH, screenWidth, 1)];
    line.backgroundColor = YZColor(46, 77, 55, 1);
    [self addSubview:line];
    
    //三连号通选
    UIButton * lianTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    lianTitleBtn.frame = CGRectMake(10,CGRectGetMaxY(line.frame) + 8, 80, 24);
    lianTitleBtn.userInteractionEnabled = NO;
    [lianTitleBtn setBackgroundImage:[UIImage resizedImageWithName:@"s1x5SelIcon" left:0.7 top:0] forState:UIControlStateNormal];
    [lianTitleBtn setTitle:@"三连号通选 " forState:UIControlStateNormal];
    [lianTitleBtn setTitleColor:YZColor(37, 124, 90, 1) forState:UIControlStateNormal];
    lianTitleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:lianTitleBtn];
    
    UILabel * lianTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lianTitleBtn.frame) + 5, CGRectGetMaxY(line.frame), KWidth, 40)];
    lianTitleLabel.font = [UIFont systemFontOfSize:12];
    NSString * lianTitleStr = @"选3个不同号码，与开奖相同奖金40元";
    NSMutableAttributedString * lianTitleAttStr = [[NSMutableAttributedString alloc]initWithString:lianTitleStr];
    [lianTitleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(183, 183, 183, 1) range:NSMakeRange(0, lianTitleStr.length - 3)];
    [lianTitleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(254, 210, 90, 1) range:NSMakeRange(lianTitleStr.length - 3, 3)];
    lianTitleLabel.attributedText = lianTitleAttStr;
    [self addSubview:lianTitleLabel];
    
    //三连号通选按钮
    YZKsBottomBtn *bottomBtn = [YZKsBottomBtn button];
    self.bottomBtn = bottomBtn;
    bottomBtn.tag = lastBtn.tag + 1;
    bottomBtn.frame = CGRectMake(padding1, CGRectGetMaxY(lianTitleLabel.frame), KWidth - 2 * padding1, 45);
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomBtn setTitle:@"123、234、345、456" forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bottomBtn];
    [self.btns addObject:bottomBtn];
    
    [self setContentSizeByMaxY:CGRectGetMaxY(bottomBtn.frame)];

}
#pragma mark - 按钮点击
- (void)btnClick:(YZKsBtn *)btn
{
    [self setSelectedButtons];
}
- (void)bottomBtnClick:(YZKsBottomBtn *)btn
{
    [self setSelectedButtons];
}
- (void)setSelectedButtons
{
    NSMutableArray * selArray = [NSMutableArray array];
    for (UIButton * btn in self.btns) {
        if (btn.selected) {
            [selArray addObject:@(btn.tag - 101)];
        }
    }
    if (_sanbutongDelegate && [_sanbutongDelegate respondsToSelector:@selector(sanbutongViewSelectedButttons:)]) {
        [_sanbutongDelegate sanbutongViewSelectedButttons:selArray];
    }
}
#pragma mark - 初始化
- (NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}
#pragma mark - 选择对应的按钮
- (void)chooseNumberByTags:(NSMutableArray *)tags
{
    for (NSNumber * number in tags) {
        YZKsBtn * ksBtn = [self viewWithTag:[number integerValue]];
        [ksBtn btnChangeSelected];
    }
    [self setSelectedButtons];
}

#pragma mark - 删除所有按钮的选中状态
- (void)deleteAllSelectedNumbersState
{
    for (id obj in self.btns) {
        if ([obj isKindOfClass:[YZKsBtn class]]) {
            YZKsBtn * btn = obj;
            if (btn.selected) {
                [btn btnChangeNormal];
            }
        }
        if ([obj isKindOfClass:[YZKsBottomBtn class]]) {
            YZKsBottomBtn * btn = obj;
            if (btn.selected) {
                [btn btnChangeNormal];
            }
        }
    }
}

@end
