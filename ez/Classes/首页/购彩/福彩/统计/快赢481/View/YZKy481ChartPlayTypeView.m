//
//  YZKy481ChartPlayTypeView.m
//  ez
//
//  Created by 毛文豪 on 2019/12/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481ChartPlayTypeView.h"

@interface YZKy481ChartPlayTypeView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView *playTypeView;
@property (nonatomic, assign) NSInteger selectedPlayTypeBtnTag;

@end

@implementation YZKy481ChartPlayTypeView

- (instancetype)initWithFrame:(CGRect)frame selectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag
{
    self = [super initWithFrame:frame];
    if (self) {
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
    
    NSArray * playTypeBtnTitles = @[@"任选", @"直选", @"组选"];
    for (int i = 0; i < 3; i++) {
        UIButton * playTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playTypeButton.tag = i;
        playTypeButton.frame = CGRectMake(0, 40 * i, playTypeViewW, 40);
        [playTypeButton setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [playTypeButton setTitleColor:YZBaseColor forState:UIControlStateSelected];
        [playTypeButton setTitle:playTypeBtnTitles[i] forState:UIControlStateNormal];
        playTypeButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [playTypeButton addTarget:self action:@selector(playTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
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
        self.playTypeView.height = 120;
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
