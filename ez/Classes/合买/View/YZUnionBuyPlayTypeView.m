//
//  YZUnionBuyPlayTypeView.m
//  ez
//
//  Created by 毛文豪 on 2019/5/13.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZUnionBuyPlayTypeView.h"

@interface YZUnionBuyPlayTypeView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *menuView;
@property (nonatomic, strong) NSArray *menuBtnTitles;
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, assign) CGFloat menuViewH;

@end

@implementation YZUnionBuyPlayTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //菜单view
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarH + navBarH, screenWidth, 0)];
    self.menuView = menuView;
    menuView.backgroundColor = [UIColor whiteColor];
    menuView.layer.masksToBounds = YES;
    [self addSubview:menuView];
    
    //游戏玩法按钮
    int maxColums = 3;//每行几个
    CGFloat btnH = 30;
    int padding = 5;
    UIButton *lastBtn;
    NSMutableArray *matchNameBtns = [NSMutableArray array];
    for(NSUInteger i = 0; i < self.menuBtnTitles.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        lastBtn = btn;
        btn.tag = i;
        [matchNameBtns addObject:btn];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitle:self.menuBtnTitles[i] forState:UIControlStateNormal];//设置按钮文字
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        CGFloat btnW = (screenWidth - maxColums * 2 * padding) / maxColums;
        CGFloat btnX = padding + (i % maxColums) * (btnW + 2 * padding);
        CGFloat btnY = 2 * padding + (i / maxColums) * (btnH + 2 * padding);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn addTarget:self action:@selector(playTypeDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btn];
    }
    
    //全部彩种按钮
    UIButton *allPlayTypeBtn = [[UIButton alloc] init];
    CGFloat allPlayTypeBtnX = 2 * padding;
    CGFloat allPlayTypeBtnY = CGRectGetMaxY(lastBtn.frame) + 15;
    CGFloat allPlayTypeBtnW = screenWidth - 2 * allPlayTypeBtnX;
    allPlayTypeBtn.frame = CGRectMake(allPlayTypeBtnX, allPlayTypeBtnY, allPlayTypeBtnW, btnH * 1.2);
    [allPlayTypeBtn setTitle:@"全部彩种" forState:UIControlStateNormal];
    [allPlayTypeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    allPlayTypeBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(32)];
    [allPlayTypeBtn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateNormal];
    [allPlayTypeBtn addTarget:self action:@selector(playTypeDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [menuView addSubview:allPlayTypeBtn];
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = YZColor(252, 79, 61, 1);
    separator.frame = CGRectMake(0, CGRectGetMaxY(allPlayTypeBtn.frame) + 2 * padding, self.width, 2);
    [menuView addSubview:separator];
    
    self.menuViewH = CGRectGetMaxY(separator.frame);
    
    self.hidden = YES;
}

- (void)playTypeDidClick:(UIButton *)btn
{
    btn.selected = YES;
    self.selectedButton.selected = NO;
    self.selectedButton = btn;
    
    [self hidden];
    
    if(_delegate && [_delegate respondsToSelector:@selector(playTypeDidClick:)])
    {
        [_delegate playTypeDidClick:btn];
    }
}

- (void)show
{
    self.hidden = NO;
    [UIView animateWithDuration:animateDuration animations:^{
        self.titleBtn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        self.menuView.height = self.menuViewH;
    }];
}

- (void)hidden
{
    [UIView animateWithDuration:animateDuration animations:^{
        self.titleBtn.imageView.transform = CGAffineTransformIdentity;
        self.menuView.height = 0;
    }completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - 初始化
- (NSArray *)menuBtnTitles
{
    if(_menuBtnTitles == nil)
    {
        _menuBtnTitles = @[@"双色球", @"大乐透", @"福彩3D", @"排列三", @"七星彩", @"胜负/任九", @"排列五", @"七乐彩", @"进球彩"];
    }
    return  _menuBtnTitles;
}

@end
