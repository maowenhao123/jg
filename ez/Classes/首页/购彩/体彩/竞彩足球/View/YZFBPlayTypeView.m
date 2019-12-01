//
//  YZFBPlayTypeView.m
//  ez
//
//  Created by 毛文豪 on 2019/5/10.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZFBPlayTypeView.h"

@interface YZFBPlayTypeView ()<UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSInteger selectedPlayTypeBtnTag;
@property (nonatomic, weak) UIView *playTypeView;

@end

@implementation YZFBPlayTypeView

- (instancetype)initWithFrame:(CGRect)frame selectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedPlayTypeBtnTag = selectedPlayTypeBtnTag; 
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    self.backgroundColor = YZColor(0, 0, 0, 0.4);
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    //玩法view
    UIView *playTypeView = [[UIView alloc] init];
    self.playTypeView = playTypeView;
    playTypeView.backgroundColor = [UIColor whiteColor];
    playTypeView.layer.masksToBounds = YES;
    playTypeView.layer.cornerRadius = 8;
    [self addSubview:playTypeView];
    
    CGFloat playTypeViewW = screenWidth - 20;
    
    NSArray *playTypeBtnTitles = @[@"混合过关", @"胜平负", @"让球胜平负", @"二选一", @"半全场", @"比分", @"总进球",@"混合过关", @"胜平负", @"让球胜平负", @"半全场", @"比分", @"总进球"];
    int maxColums = 3;//每行几个
    CGFloat btnH = 40;
    int padding = 8;
    int btnCount = (int)playTypeBtnTitles.count;
    int guoguanBtnCount = 7;
    UIButton *lastBtn;
    UILabel *lastLabel;
    for(int i = 0; i < btnCount;i++)
    {
        if (i == 0 || i == guoguanBtnCount) {
            UILabel * titleLabel = [[UILabel alloc]init];
            titleLabel.frame = CGRectMake(0, CGRectGetMaxY(lastBtn.frame) + 2 * padding, playTypeViewW, btnH);
            titleLabel.backgroundColor = YZColor(240, 240, 240, 1);
            if (i == 0) {
                titleLabel.text = @"过关";
            }else
            {
                titleLabel.text = @"单关";
            }
            titleLabel.font = [UIFont systemFontOfSize:16.0f];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [playTypeView addSubview:titleLabel];
            lastLabel = titleLabel;
        }
        
        //玩法按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitle:playTypeBtnTitles[i] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        CGFloat btnW = (playTypeViewW - 10) / maxColums;
        CGFloat btnX;
        CGFloat btnY;
        if (i < guoguanBtnCount) {
            btnX = 5 + (i % maxColums) * btnW;
            btnY = CGRectGetMaxY(lastLabel.frame) + 2 * padding + (i / maxColums) * (btnH + padding);
        }else
        {
            btnX = 5 + ((i - guoguanBtnCount) % maxColums) * btnW;
            btnY = CGRectGetMaxY(lastLabel.frame) + 2 * padding + ((i - guoguanBtnCount)/ maxColums) * (btnH + padding);
        }
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        lastBtn = btn;
        [playTypeView addSubview:btn];
        [btn addTarget:self action:@selector(playTypeDidClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        if(self.selectedPlayTypeBtnTag == i)//有就选择相应地按钮
        {
            btn.selected = YES;
        }
    }
    CGFloat playTypeViewH = CGRectGetMaxY(lastBtn.frame) + 2 * padding;
    playTypeView.bounds = CGRectMake(0, 0, playTypeViewW, playTypeViewH);
    playTypeView.center = self.center;
    
    self.hidden = YES;
}

- (void)playTypeDidClickBtn:(UIButton *)btn
{
    if(btn.tag == _selectedPlayTypeBtnTag)//一样就不动
    {
        [self hidden];
        return;
    }
    
    for (UIView *subView in self.playTypeView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton * button = (UIButton *)subView;
            button.selected = NO;
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
    
    self.playTypeView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        self.titleBtn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        self.playTypeView.transform = CGAffineTransformMakeScale(1, 1);
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
