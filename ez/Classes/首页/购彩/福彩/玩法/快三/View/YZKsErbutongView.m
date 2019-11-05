//
//  YZKsErbutongView.m
//  ez
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height

#import "YZKsErbutongView.h"

@interface YZKsErbutongView ()

@property (nonatomic, strong) NSMutableArray *btns;

@end

@implementation YZKsErbutongView

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
    //标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KWidth - 20, 30)];
    NSString * titleStr = @"选两个不同号码，猜中开奖的任意2位，即中8元";
    titleLabel.font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString * titleAttStr = [[NSMutableAttributedString alloc]initWithString:titleStr];
    [titleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(183, 183, 183, 1) range:NSMakeRange(0, titleStr.length - 2)];
    [titleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(254, 210, 90, 1) range:NSMakeRange(titleStr.length - 2, 2)];
    titleLabel.attributedText = titleAttStr;
    [self addSubview:titleLabel];
    
    //选号按钮
    CGFloat padding1 = 10;
    CGFloat padding2 = 2;
    CGFloat btnW = (KWidth - 2 * padding1 - 5 * padding2) / 6;
    CGFloat btnH = btnW;
    CGFloat btnY = CGRectGetMaxY(titleLabel.frame);
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
    [self setContentSizeByMaxY:CGRectGetMaxY(lastBtn.frame)];
}
#pragma mark - 按钮点击
- (void)btnClick:(YZKsBtn *)btn
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
    if (_erbutongDelegate && [_erbutongDelegate respondsToSelector:@selector(erbutongViewSelectedButttons:)]) {
        [_erbutongDelegate erbutongViewSelectedButttons:selArray];
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
    }
}


@end
