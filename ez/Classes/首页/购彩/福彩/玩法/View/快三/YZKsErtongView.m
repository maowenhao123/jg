//
//  YZKsErtongView.m
//  ez
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height

#import "YZKsErtongView.h"

@interface YZKsErtongView ()

@property (nonatomic, strong) NSMutableArray *btns;

@end

@implementation YZKsErtongView

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
    //单选
    UIButton * danTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    danTitleBtn.frame = CGRectMake(10, 9, 50, 22);
    danTitleBtn.userInteractionEnabled = NO;
    [danTitleBtn setBackgroundImage:[UIImage imageNamed:@"s1x5SelIcon"] forState:UIControlStateNormal];
    [danTitleBtn setTitle:@"单选 " forState:UIControlStateNormal];
    [danTitleBtn setTitleColor:YZColor(37, 124, 90, 1) forState:UIControlStateNormal];
    danTitleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:danTitleBtn];
    
    UILabel * danTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(danTitleBtn.frame) + 5, 10, KWidth, 20)];
    danTitleLabel.font = [UIFont systemFontOfSize:12];
    NSString * danTitleStr = @"猜对子号(2个号相同)奖金80元";
    NSMutableAttributedString * danTitleAttStr = [[NSMutableAttributedString alloc]initWithString:danTitleStr];
    [danTitleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(183, 183, 183, 1) range:NSMakeRange(0, danTitleStr.length - 3)];
    [danTitleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(254, 210, 90, 1) range:NSMakeRange(danTitleStr.length - 3, 3)];
    danTitleLabel.attributedText = danTitleAttStr;
    [self addSubview:danTitleLabel];
    
    //同号
    UILabel * tongTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(danTitleLabel.frame), KWidth, 35)];
    tongTitleLabel.text = @"同号";
    tongTitleLabel.textColor = [UIColor whiteColor];
    tongTitleLabel.font = [UIFont systemFontOfSize:15];
    tongTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tongTitleLabel];
    
    //选号按钮
    CGFloat padding1 = 10;
    CGFloat padding2 = 2;
    CGFloat btnW = (KWidth - 2 * padding1 - 5 * padding2) / 6;
    CGFloat btnH = btnW;
    CGFloat btnY = CGRectGetMaxY(tongTitleLabel.frame);
    YZKsBtn * lastBtn;
    NSMutableArray * tongBtns = self.btns[0];
    for (int i = 1; i < 7; i++) {
        CGFloat btnX = padding1 + (btnW + padding2) * (i - 1);
        YZKsBtn * btn = [[YZKsBtn alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn.tag = 101 + i - 1;
        NSString * btnTitle = [NSString stringWithFormat:@"%d%d",i,i];
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        lastBtn = btn;
        [tongBtns addObject:btn];
    }
    self.btns[0] = tongBtns;
    
    //不同号
    UILabel * butongTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lastBtn.frame), KWidth, 35)];
    butongTitleLabel.text = @"不同号";
    butongTitleLabel.textColor = [UIColor whiteColor];
    butongTitleLabel.font = [UIFont systemFontOfSize:15];
    butongTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:butongTitleLabel];
    
    //选号按钮
    btnY = CGRectGetMaxY(butongTitleLabel.frame);
    NSMutableArray * butongBtns = self.btns[1];
    for (int i = 1; i < 7; i++) {
        CGFloat btnX = padding1 + (btnW + padding2) * (i - 1);
        YZKsBtn * btn = [[YZKsBtn alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        btn.tag = 101 + 100 + i - 1;
        NSString * btnTitle = [NSString stringWithFormat:@"%d",i];
        [btn setTitle:btnTitle forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        lastBtn = btn;
        [butongBtns addObject:btn];
    }
    self.btns[1] = butongBtns;

    //复选
    UIButton * fuTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fuTitleBtn.frame = CGRectMake(10,CGRectGetMaxY(lastBtn.frame) + 9, 50, 22);
    fuTitleBtn.userInteractionEnabled = NO;
    [fuTitleBtn setBackgroundImage:[UIImage imageNamed:@"s1x5SelIcon"] forState:UIControlStateNormal];
    [fuTitleBtn setTitle:@"复选 " forState:UIControlStateNormal];
    [fuTitleBtn setTitleColor:YZColor(37, 124, 90, 1) forState:UIControlStateNormal];
    fuTitleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:fuTitleBtn];
    
    UILabel * fuTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(fuTitleBtn.frame) + 5, CGRectGetMaxY(lastBtn.frame), KWidth, 40)];
    fuTitleLabel.font = [UIFont systemFontOfSize:12];
    NSString * fuTitleStr = @"猜对子号(2个号相同)，奖金15元";
    NSMutableAttributedString * fuTitleAttStr = [[NSMutableAttributedString alloc]initWithString:fuTitleStr];
    [fuTitleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(183, 183, 183, 1) range:NSMakeRange(0, fuTitleStr.length - 3)];
    [fuTitleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(254, 210, 90, 1) range:NSMakeRange(fuTitleStr.length - 3, 3)];
    fuTitleLabel.attributedText = fuTitleAttStr;
    [self addSubview:fuTitleLabel];
    
    //选号按钮
    CGFloat paddingFu1 = 10;
    CGFloat paddingFu2 = 10;
    CGFloat btnFuW = (KWidth - 4 * paddingFu1) / 3;
    CGFloat btnFuH = btnFuW * 2.4 / 5;
    NSMutableArray * fuBtns = self.btns[2];
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            CGFloat btnX = paddingFu1 + (btnFuW + paddingFu1) * j;
            CGFloat btnY = CGRectGetMaxY(fuTitleLabel.frame) + (btnFuH + paddingFu2) * i;
            YZKsBtn * btn = [[YZKsBtn alloc]initWithFrame:CGRectMake(btnX, btnY, btnFuW, btnFuH)];
            btn.tag = 101 + i * 3 + j + 200;
            NSString * btnTitle = [NSString stringWithFormat:@"%d%d*",i * 3 + j + 1,i * 3 + j + 1];
            [btn setTitle:btnTitle forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            lastBtn = btn;
            [fuBtns addObject:btn];
        }
    }
    self.btns[2] = fuBtns;
    
    [self setContentSizeByMaxY:CGRectGetMaxY(lastBtn.frame)];
}
- (void)btnClick:(YZKsBtn *)btn
{
    NSInteger tag = btn.tag;
    if (tag < 100 + 101) {//同号
        YZKsBtn * btn = (YZKsBtn *)[self viewWithTag:tag + 100];
        if (btn.selected) {
            [btn btnChangeNormal];
        }
    }else if (tag >= 100 + 101 && tag < 200 + 101)//不同号
    {
        YZKsBtn * btn = (YZKsBtn *)[self viewWithTag:tag - 100];
        if (btn.selected) {
            [btn btnChangeNormal];
        }
    }
    [self setSelectedButtons];
}
- (void)setSelectedButtons
{
    NSMutableArray * selectedArray = [NSMutableArray array];
    for (NSArray * btns in self.btns) {
        NSInteger index = [self.btns indexOfObject:btns];
        NSMutableArray * selArray = [NSMutableArray array];
        for (YZKsBtn * btn in btns) {
            if (btn.selected) {
                [selArray addObject:@(btn.tag - 100 * index - 101)];
            }
        }
        [selectedArray addObject:selArray];
    }
    if (_ertongDelegate && [_ertongDelegate respondsToSelector:@selector(ertongViewSelectedButttons:)]) {
        [_ertongDelegate ertongViewSelectedButttons:selectedArray];
    }
}
#pragma mark - 初始化
- (NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            [_btns addObject:[NSMutableArray array]];
        }
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
    for (NSArray * btns in self.btns) {
        for (YZKsBtn * btn in btns) {
            if (btn.selected) {
                [btn btnChangeNormal];
            }
        }
    }
}
@end
