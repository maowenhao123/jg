//
//  YZKsSantongView.m
//  ez
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height

#import "YZKsSantongView.h"

@interface YZKsSantongView ()

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, weak) YZKsBottomBtn *bottomBtn;

@end

@implementation YZKsSantongView

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
    
    UILabel * danTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(danTitleBtn.frame) + 5, 0, KWidth, 40)];
    danTitleLabel.font = [UIFont systemFontOfSize:12];
    NSString * danTitleStr = @"猜豹子号(三个号相同)即中240元";
    NSMutableAttributedString * danTitleAttStr = [[NSMutableAttributedString alloc]initWithString:danTitleStr];
    [danTitleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(183, 183, 183, 1) range:NSMakeRange(0, danTitleStr.length - 4)];
    [danTitleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(254, 210, 90, 1) range:NSMakeRange(danTitleStr.length - 4, 4)];
    danTitleLabel.attributedText = danTitleAttStr;
    [self addSubview:danTitleLabel];
    
    //选号按钮
    CGFloat padding1 = 10;
    CGFloat padding2 = 10;
    CGFloat btnW = (KWidth - 4 * padding1) / 3;
    CGFloat btnH = btnW * 2.4 / 5;
    YZKsBtn * lastBtn;
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            CGFloat btnX = padding1 + (btnW + padding1) * j;
            CGFloat btnY = CGRectGetMaxY(danTitleLabel.frame) + (btnH + padding2) * i;
            YZKsBtn * btn = [[YZKsBtn alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
            btn.tag = i * 3 + j + 101;
            NSString * btnTitle = [NSString stringWithFormat:@"%d%d%d",i * 3 + j + 1,i * 3 + j + 1,i * 3 + j + 1];
            [btn setTitle:btnTitle forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            lastBtn = btn;
            [self.btns addObject:btn];
        }
    }
    
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lastBtn.frame) + btnH, screenWidth, 1)];
    line.backgroundColor = YZColor(46, 77, 55, 1);
    [self addSubview:line];
    
    //通选
    UIButton * tongTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tongTitleBtn.frame = CGRectMake(10,CGRectGetMaxY(line.frame) + 9, 50, 22);
    tongTitleBtn.userInteractionEnabled = NO;
    [tongTitleBtn setBackgroundImage:[UIImage imageNamed:@"s1x5SelIcon"] forState:UIControlStateNormal];
    [tongTitleBtn setTitle:@"通选 " forState:UIControlStateNormal];
    [tongTitleBtn setTitleColor:YZColor(37, 124, 90, 1) forState:UIControlStateNormal];
    tongTitleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:tongTitleBtn];
    
    UILabel * tongTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tongTitleBtn.frame) + 5, CGRectGetMaxY(line.frame), KWidth, 40)];
    tongTitleLabel.font = [UIFont systemFontOfSize:12];
    NSString * tongTitleStr = @"任意一个豹子开出，即中40元";
    NSMutableAttributedString * tongTitleAttStr = [[NSMutableAttributedString alloc]initWithString:tongTitleStr];
    [tongTitleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(183, 183, 183, 1) range:NSMakeRange(0, tongTitleStr.length - 3)];
    [tongTitleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(254, 210, 90, 1) range:NSMakeRange(tongTitleStr.length - 3, 3)];
    tongTitleLabel.attributedText = tongTitleAttStr;
    [self addSubview:tongTitleLabel];
    
    //通选按钮
    YZKsBottomBtn *bottomBtn = [YZKsBottomBtn button];
    self.bottomBtn = bottomBtn;
    bottomBtn.tag = lastBtn.tag + 1;
    bottomBtn.frame = CGRectMake(padding1, CGRectGetMaxY(tongTitleLabel.frame), KWidth - 2 * padding1, 45);
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomBtn setTitle:@"包含所有三同号" forState:UIControlStateNormal];
    bottomBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bottomBtn];
    [self.btns addObject:bottomBtn];
    
    [self setContentSizeByMaxY:CGRectGetMaxY(bottomBtn.frame)];
}
#pragma mark - 按钮点击
- (void)btnClick:(YZKsBtn *)button
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
    if (_santongDelegate && [_santongDelegate respondsToSelector:@selector(santongViewSelectedButttons:)]) {
        [_santongDelegate santongViewSelectedButttons:selArray];
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
