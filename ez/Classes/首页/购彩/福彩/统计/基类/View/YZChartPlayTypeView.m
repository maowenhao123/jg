//
//  YZChartPlayTypeView.m
//  ez
//
//  Created by 毛文豪 on 2019/12/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZChartPlayTypeView.h"

@interface YZChartPlayTypeView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *playTypeView;
@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, assign) NSInteger selectedPlayTypeBtnTag;

@end

@implementation YZChartPlayTypeView

- (instancetype)initWithFrame:(CGRect)frame gameId:(NSString *)gameId selectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.gameId = gameId;
        self.selectedPlayTypeBtnTag = selectedPlayTypeBtnTag;
        [self setupSonChilds];
    }
    return self;
}

#pragma mark - 布局子视图
- (void)setupSonChilds
{
    self.backgroundColor = YZColor(0, 0, 0, 0.4);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //玩法view
    CGFloat playTypeViewW = 100;
    UIView *playTypeView = [[UIView alloc] initWithFrame:CGRectMake((screenWidth - playTypeViewW) / 2, statusBarH +  navBarH, playTypeViewW, 0)];
    self.playTypeView = playTypeView;
    playTypeView.backgroundColor = [UIColor whiteColor];
    playTypeView.clipsToBounds = YES;
    [self addSubview:playTypeView];
    
    NSArray * playTypeBtnTitles = [NSArray array];
    if ([self.gameId isEqualToString:@"T06"]) {
        playTypeBtnTitles = @[@"任选", @"直选", @"组选"];
    }else if ([self.gameId isEqualToString:@"T05"] || [self.gameId isEqualToString:@"T61"] || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"])
    {
        playTypeBtnTitles = @[@"任选一", @"任选二", @"任选三", @"任选四", @"任选五", @"任选六", @"任选七", @"任选八", @"前二直选", @"前二组选", @"前三直选", @"前三组选"];
    }
    for (int i = 0; i < playTypeBtnTitles.count; i++) {
        UIButton * playTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playTypeButton.tag = i;
        playTypeButton.frame = CGRectMake(0, 40 * i, playTypeViewW, 40);
        [playTypeButton setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [playTypeButton setTitleColor:YZBaseColor forState:UIControlStateSelected];
        [playTypeButton setTitle:playTypeBtnTitles[i] forState:UIControlStateNormal];
        playTypeButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [playTypeButton addTarget:self action:@selector(playTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.gameId isEqualToString:@"T06"]) {
            if (self.selectedPlayTypeBtnTag < 6 && i == 0) {
                playTypeButton.selected = YES;
            }else if (self.selectedPlayTypeBtnTag == 6 && i == 1)
            {
                playTypeButton.selected = YES;
            }else if (self.selectedPlayTypeBtnTag > 6 && i == 2)
            {
                playTypeButton.selected = YES;
            }else
            {
                playTypeButton.selected = NO;
            }
        }else if ([self.gameId isEqualToString:@"T05"] || [self.gameId isEqualToString:@"T61"] || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"])
        {
            NSInteger index = self.selectedPlayTypeBtnTag;
            if (index > 11 && index < 18) {
                index = index - 11;
            }else if (index == 18)
            {
                index = 9;
            }else if (index == 19)
            {
                index = 11;
            }
            if (i == index) {
                playTypeButton.selected = YES;
            }else
            {
                playTypeButton.selected = NO;
            }
        }
        [playTypeView addSubview:playTypeButton];
    }
    
    self.hidden = YES;
}

#pragma mark -  按钮点击
- (void)playTypeBtn:(UIButton *)btn
{
    for (UIView * subView in self.playTypeView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton * otherButton = (UIButton *)subView;
            otherButton.selected = NO;
        }
    }
    btn.selected = YES;
    
    [self hidden];
    if(_delegate && [_delegate respondsToSelector:@selector(playTypeDidClickBtn:)])
    {
        [_delegate playTypeDidClickBtn:btn];
    }
}

- (void)show
{
    self.hidden = NO;
    
    self.playTypeView.height = 0;
    [UIView animateWithDuration:animateDuration animations:^{
        self.titleBtn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        if ([self.gameId isEqualToString:@"T06"]) {
            self.playTypeView.height = 40 * 3;
        }else if ([self.gameId isEqualToString:@"T05"] || [self.gameId isEqualToString:@"T61"] || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"])
        {
            self.playTypeView.height = 40 * 12;
        }
    }];
}

- (void)hidden
{
    [UIView animateWithDuration:animateDuration animations:^{
        self.titleBtn.imageView.transform = CGAffineTransformIdentity;
    }];
    
    self.hidden = YES;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.playTypeView) {
            CGPoint pos = [touch locationInView:self.playTypeView.superview];
            if (CGRectContainsPoint(self.playTypeView.frame, pos)) {
                return NO;
            }
        }
    }
    return YES;
}


@end
