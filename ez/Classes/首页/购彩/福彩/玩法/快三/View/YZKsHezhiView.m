//
//  YZKsHezhiView.m
//  ez
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height

#import "YZKsHezhiView.h"

@interface YZKsHezhiView ()

@property (nonatomic, strong) NSMutableArray *btnTitles;
@property (nonatomic, strong) NSMutableArray *fastBtnTitles;
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *fastBtns;

@end

@implementation YZKsHezhiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChilds];
    }
    return self;
}
#pragma mark - 布局视图
- (void)setupChilds
{
    //标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KWidth - 20, 30)];
    NSString * titleStr = @"猜中开奖号码相加之和，奖金9-240元";
    titleLabel.font = [UIFont systemFontOfSize:12];
    NSMutableAttributedString * titleAttStr = [[NSMutableAttributedString alloc]initWithString:titleStr];
    [titleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(183, 183, 183, 1) range:NSMakeRange(0, titleStr.length - 6)];
    [titleAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(254, 210, 90, 1) range:NSMakeRange(titleStr.length - 6, 6)];
    titleLabel.attributedText = titleAttStr;
    [self addSubview:titleLabel];
    
    //选号按钮
    CGFloat padding1 = 10;
    CGFloat padding2 = 8;
    CGFloat btnW = (KWidth - 5 * padding1) / 4;
    CGFloat btnH = btnW * 3 / 5;
    YZKsBtn * lastBtn;
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            CGFloat btnX = padding1 + (btnW + padding1) * j;
            CGFloat btnY = CGRectGetMaxY(titleLabel.frame) + (btnH + padding2) * i;
            YZKsBtn * btn = [[YZKsBtn alloc]initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
            btn.tag = i * 4 + j + 3 + 101;
            [btn setAttributedTitle:self.btnTitles[i * 4 + j] forState:UIControlStateNormal];
            btn.titleLabel.numberOfLines = 0;
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            lastBtn = btn;
            [self.btns addObject:btn];
        }
    }
    
    //快速选号
    UILabel * fastTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lastBtn.frame) + 10, KWidth, 35)];
    fastTitleLabel.text = @"快速选号";
    fastTitleLabel.textColor = [UIColor whiteColor];
    fastTitleLabel.font = [UIFont systemFontOfSize:15];
    fastTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:fastTitleLabel];
    
    //快速投注按钮
    YZKsBottomBtn * lastBottomBtn;
    for (int i = 0; i < 4; i++) {
        YZKsBottomBtn * button = [YZKsBottomBtn button];
        button.tag = i + 201;
        CGFloat btnX = padding1 + (btnW + padding1) * i;
        CGFloat btnY = CGRectGetMaxY(fastTitleLabel.frame);
        button.frame = CGRectMake(btnX, btnY, btnW, btnH);

        [button setAttributedTitle:self.fastBtnTitles[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(fastBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.fastBtns addObject:button];
        lastBottomBtn = button;
    }
    
    [self setContentSizeByMaxY:CGRectGetMaxY(lastBottomBtn.frame)];
}
#pragma mark - 按钮点击
- (void)btnClick:(YZKsBtn *)button
{
    [self setFastBtnSelected];
    [self setSelectedButtons];
}
- (void)fastBtnClick:(UIButton *)button
{
    //取消对应的选择
    if (button.tag - 201 == 0) {
        YZKsBottomBtn * button2 = self.fastBtns[1];
        if (button2.selected) {
            [button2 btnChangeNormal];
        }
    }else if (button.tag - 201 == 1)
    {
        YZKsBottomBtn * button1 = self.fastBtns[0];
        if (button1.selected) {
            [button1 btnChangeNormal];
        }
    }else if (button.tag - 201 == 2)
    {
        YZKsBottomBtn * button4 = self.fastBtns[3];
        if (button4.selected) {
            [button4 btnChangeNormal];
        }
    }else if (button.tag - 201 == 3)
    {
        YZKsBottomBtn * button3 = self.fastBtns[2];
        if (button3.selected) {
            [button3 btnChangeNormal];
        }
    }
    
    //选择对应的号码
    YZKsBottomBtn * button1 = self.fastBtns[0];
    YZKsBottomBtn * button2 = self.fastBtns[1];
    YZKsBottomBtn * button3 = self.fastBtns[2];
    YZKsBottomBtn * button4 = self.fastBtns[3];
    for (YZKsBtn * btn in self.btns) {
        //先都选择
        [btn btnChangeSelected];
        NSInteger index = [self.btns indexOfObject:btn];
        //如果选择过滤条件，就取消对应的按钮
        if (button1.selected) {
            if (index < 8) {
                [btn btnChangeNormal];
            }
        }
        if (button2.selected)
        {
            if (index > 7) {
                [btn btnChangeNormal];
            }
        }
        if (button3.selected)
        {
            if (index % 2 != 0) {
                [btn btnChangeNormal];
            }
        }
        if (button4.selected)
        {
            if (index % 2 == 0) {
                [btn btnChangeNormal];
            }
        }
        //如果都没有选择类型就都都取消
        if (!button1.selected && !button2.selected && !button3.selected && !button4.selected) {
            [btn btnChangeNormal];
        }
    }
    [self setSelectedButtons];
}
- (void)setFastBtnSelected
{
    //先都不选择
    for (YZKsBottomBtn * btn in self.fastBtns) {
        [btn btnChangeNormal];
    }
    //如果有符合条件的，就选择对应的按钮
    YZKsBottomBtn * button1 = self.fastBtns[0];
    YZKsBottomBtn * button2 = self.fastBtns[1];
    YZKsBottomBtn * button3 = self.fastBtns[2];
    YZKsBottomBtn * button4 = self.fastBtns[3];
    //只有大
    NSArray * daArray = @[@(11),@(12),@(13),@(14),@(15),@(16),@(17),@(18)];
    if ([self onlySelectedButtonArray:daArray]) {
        [button1 btnChangeSelected];
        return;
    }
    //只有小
    NSArray * xiaoArray = @[@(3),@(4),@(5),@(6),@(7),@(8),@(9),@(10)];
    if ([self onlySelectedButtonArray:xiaoArray]) {
        [button2 btnChangeSelected];
        return;
    }
    //只有单
    NSArray * danArray = @[@(3),@(5),@(7),@(9),@(11),@(13),@(15),@(17)];
    if ([self onlySelectedButtonArray:danArray]) {
        [button3 btnChangeSelected];
        return;
    }
    //只有双
    NSArray * shuangArray = @[@(4),@(6),@(8),@(10),@(12),@(14),@(16),@(18)];
    if ([self onlySelectedButtonArray:shuangArray]) {
        [button4 btnChangeSelected];
        return;
    }
    //大单
    NSArray * dadanArray = @[@(11),@(13),@(15),@(17)];
    if ([self onlySelectedButtonArray:dadanArray]) {
        [button1 btnChangeSelected];
        [button3 btnChangeSelected];
        return;
    }
    //大双
    NSArray * dashuangArray = @[@(12),@(14),@(16),@(18)];
    if ([self onlySelectedButtonArray:dashuangArray]) {
        [button1 btnChangeSelected];
        [button4 btnChangeSelected];
        return;
    }
    //小单
    NSArray * xiaodanArray = @[@(3),@(5),@(7),@(9)];
    if ([self onlySelectedButtonArray:xiaodanArray]) {
        [button2 btnChangeSelected];
        [button3 btnChangeSelected];
        return;
    }
    //小双
    NSArray * xiaoshuangArray = @[@(4),@(6),@(8),@(10)];
    if ([self onlySelectedButtonArray:xiaoshuangArray]) {
        [button2 btnChangeSelected];
        [button4 btnChangeSelected];
        return;
    }
}
//只有btns中的按钮被选择
- (BOOL)onlySelectedButtonArray:(NSArray *)numbers
{
    BOOL onlySel = YES;
    NSMutableArray * selArray = [NSMutableArray array];
    NSMutableArray * norArray = [NSMutableArray array];
    for (YZKsBtn * btn in self.btns) {
        NSNumber * number = [NSNumber numberWithInteger:btn.tag - 101];
        if ([numbers containsObject:number]) {
            [selArray addObject:btn];
        }else
        {
            [norArray addObject:btn];
        }
    }
    //被选中的按钮中有没有被选中的
    for (YZKsBtn * btn in selArray) {
        if (!btn.selected) {
            return NO;
        }
    }
    //正常按钮中有被选中的
    for (YZKsBtn * btn in norArray) {
        if (btn.selected) {
            return NO;
        }
    }
    return onlySel;
}
- (void)setSelectedButtons
{
    NSMutableArray * selArray = [NSMutableArray array];
    for (YZKsBtn * btn in self.btns) {
        if (btn.selected) {
            [selArray addObject:@(btn.tag - 3 - 101)];
        }
    }
    if (_hezhiDelegate && [_hezhiDelegate respondsToSelector:@selector(hezhiViewSelectedButttons:)]) {
        [_hezhiDelegate hezhiViewSelectedButttons:selArray];
    }
}
#pragma mark - 初始化
- (NSMutableArray *)btnTitles
{
    if (_btnTitles == nil) {
        _btnTitles = [NSMutableArray array];
        NSArray * btnTitles2 = @[@"￥240",@"￥80",@"￥40",@"￥25",@"￥16",@"￥12",@"￥10",@"￥9"];
        for (int i = 0; i < 16; i++) {
            NSString * btnTitle1 = [NSString stringWithFormat:@"%d",i + 3];
            NSString * btnTitle2;
            if (i < 8) {
                btnTitle2 = btnTitles2[i];
            }else
            {
                 btnTitle2 = btnTitles2[15 - i];
            }
            NSString * btnTitleStr = [NSString stringWithFormat:@"%@\n%@",btnTitle1,btnTitle2];
            NSMutableAttributedString * btnTitleAttStr = [[NSMutableAttributedString alloc]initWithString:btnTitleStr];
            [btnTitleAttStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, btnTitle1.length)];
            [btnTitleAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(btnTitle1.length,btnTitleStr.length - btnTitle1.length)];
            [btnTitleAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, btnTitleStr.length)];
            [_btnTitles addObject:btnTitleAttStr];
        }
    }
    return _btnTitles;
}
- (NSMutableArray *)fastBtnTitles
{
    if (_fastBtnTitles == nil) {
        _fastBtnTitles = [NSMutableArray array];
        NSArray * fastBtnTitles1 = @[@"大",@"小",@"单",@"双"];
        NSArray * fastBtnTitles2 = @[@"11-18",@"3-10",@"奇数",@"偶数"];
        for (int i = 0; i < 4; i++) {
            NSString * fastBtnTitle1 = fastBtnTitles1[i];
            NSString * fastBtnTitle2 = fastBtnTitles2[i];
            NSString * fastBtnTitleStr = [NSString stringWithFormat:@"%@\n%@",fastBtnTitle1,fastBtnTitle2];
            NSMutableAttributedString * fastBtnTitleAttStr = [[NSMutableAttributedString alloc]initWithString:fastBtnTitleStr];
            [fastBtnTitleAttStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, fastBtnTitle1.length)];
            [fastBtnTitleAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(fastBtnTitle1.length,fastBtnTitleStr.length - fastBtnTitle1.length)];
            [fastBtnTitleAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, fastBtnTitleStr.length)];
            [_fastBtnTitles addObject:fastBtnTitleAttStr];
        }
    }
    return _fastBtnTitles;
}
- (NSMutableArray *)btns
{
    if (_btns == nil) {
        _btns = [NSMutableArray array];
    }
    return _btns;
}
- (NSMutableArray *)fastBtns
{
    if (_fastBtns == nil) {
        _fastBtns = [NSMutableArray array];
    }
    return _fastBtns;
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
    for (YZKsBtn * btn in self.btns) {
        if (btn.selected) {
            [btn btnChangeNormal];
        }
    }
    for (YZKsBottomBtn * btn in self.fastBtns) {
        if (btn.selected) {
            [btn btnChangeNormal];
        }
    }
}
@end
