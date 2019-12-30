//
//  YZKy481ChongView.m
//  ez
//
//  Created by dahe on 2019/11/5.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481ChongView.h"

@interface YZKy481ChongView ()<YZBallBtnDelegate>

@property (nonatomic, strong) NSMutableArray *chongBallButtons;
@property (nonatomic, strong) NSMutableArray *ballButtons;

@end

@implementation YZKy481ChongView

#pragma mark - 布局子视图
- (void)setupChildViews
{
    [super setupChildViews];
    
    //重号
    UILabel *chongTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YZMargin, CGRectGetMaxY(self.titleLabel.frame) + 10, 50, 30)];
    chongTitleLabel.text = @"重号";
    chongTitleLabel.textColor = YZBlackTextColor;
    chongTitleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [self addSubview:chongTitleLabel];
    
    CGFloat ballWH = 35;
    CGFloat ballPadding = (screenWidth - 2 * YZMargin - 8 * ballWH) / 7;
    for (int i = 1; i < 9; i++) {
        UIButton * ballButton = [UIButton buttonWithType:UIButtonTypeCustom];
        ballButton.tag = i;
        ballButton.frame = CGRectMake(YZMargin + (ballWH + ballPadding) * (i - 1), CGRectGetMaxY(chongTitleLabel.frame) + 10, ballWH, ballWH);
        [ballButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        [ballButton setTitleColor:YZDrayGrayTextColor forState:UIControlStateNormal];
        [ballButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [ballButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [ballButton setBackgroundImage:[UIImage ImageFromColor:YZBackgroundColor] forState:UIControlStateNormal];
        [ballButton setBackgroundImage:[UIImage ImageFromColor:RGBACOLOR(67, 174, 73, 1)] forState:UIControlStateHighlighted];
        [ballButton setBackgroundImage:[UIImage ImageFromColor:RGBACOLOR(67, 174, 73, 1)] forState:UIControlStateSelected];
        ballButton.adjustsImageWhenHighlighted = NO;
        ballButton.adjustsImageWhenDisabled = NO;
        ballButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(34)];
        ballButton.layer.masksToBounds = YES;
        ballButton.layer.cornerRadius = ballWH / 2;
        ballButton.layer.borderWidth = 1;
        ballButton.layer.borderColor = YZGrayTextColor.CGColor;
        [ballButton addTarget:self action:@selector(chongBallButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ballButton];
        
        [self.chongBallButtons addObject:ballButton];
    }
    
    //选号
    UILabel *xuanTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YZMargin, CGRectGetMaxY(chongTitleLabel.frame) + ballWH + 20, 50, 30)];
    xuanTitleLabel.text = @"选号";
    xuanTitleLabel.textColor = YZBlackTextColor;
    xuanTitleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [self addSubview:xuanTitleLabel];
    
    for (int i = 1; i < 9; i++) {
        YZBallBtn *btn = [YZBallBtn button];
        btn.frame = CGRectMake(YZMargin + (ballWH + ballPadding) * (i - 1), CGRectGetMaxY(xuanTitleLabel.frame) + 10, ballWH, ballWH);
        btn.tag = 10 + i;
        btn.owner = self;
        btn.delegate = self;
        [btn setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        NSString *image = @"redBall_flat";
        btn.selImageName = image;
        btn.ballTextColor = YZRedBallColor;
        [btn setTitleColor:btn.ballTextColor forState:UIControlStateNormal];
        [self addSubview:btn];
        
        [self.ballButtons addObject:btn];
    }
}

- (void)chongBallButtonDidClick:(UIButton *)button
{
    if (button.selected) {
        button.layer.borderWidth = 1;
    }else
    {
        button.layer.borderWidth = 0;
    }
    if([self.delegate respondsToSelector:@selector(ballDidClick:)])
    {
        [self.delegate ballDidClick:(YZBallBtn *)button];
    }
    
    button.selected = !button.selected;
    
    YZBallBtn * otherButton = [self viewWithTag:button.tag + 10];
    if (otherButton.selected) {
        if([self.delegate respondsToSelector:@selector(ballDidClick:)])
        {
            [self.delegate ballDidClick:otherButton];
        }
        [otherButton ballChangeToWhite];
    }
}

- (void)ballDidClick:(YZBallBtn *)btn
{
    if([self.delegate respondsToSelector:@selector(ballDidClick:)])
    {
        [self.delegate ballDidClick:(YZBallBtn *)btn];
    }
    YZBallBtn * otherButton = [self viewWithTag:btn.tag - 10];
    if (otherButton.selected) {
        if([self.delegate respondsToSelector:@selector(ballDidClick:)])
        {
            [self.delegate ballDidClick:otherButton];
        }
        otherButton.selected = NO;
        otherButton.layer.borderWidth = 1;
    }
}

- (void)setRandomSet:(NSMutableSet *)randomSet
{
    _randomSet = randomSet;
    
    NSArray * randomArr = [NSArray arrayWithArray:_randomSet.allObjects];
    for (int i = 0; i < randomArr.count; i++) {
        int number = [randomArr[i] intValue];
        if (i == 0) {
            UIButton * ballButton = [self viewWithTag:number];
            [self chongBallButtonDidClick:ballButton];
        }else
        {
            YZBallBtn *btn = [self viewWithTag:number + 10];
            [btn ballClick:btn];
        }
    }
}

#pragma mark - Setting
- (void)setSelStatusArray:(NSMutableArray *)selStatusArray
{
    _selStatusArray = selStatusArray;
    
    [self reloadData];
}

#pragma mark - 刷新数据
- (void)reloadData
{
    for (int i = 0; i < self.selStatusArray.count; i++) {
        NSArray * cellSelStatusArray = self.selStatusArray[i];
        NSMutableArray * selselButtonTags = [NSMutableArray array];
        for (UIButton * selButton in cellSelStatusArray) {
            [selselButtonTags addObject:@(selButton.tag)];
        }
        if (i == 1) {
            for (YZBallBtn * button in self.ballButtons) {
                if ([selselButtonTags containsObject:@(button.tag)]) {
                    [button ballChangeToRed];
                }else
                {
                    [button ballChangeToWhite];
                }
            }
        }else if (i == 0)
        {
            for (UIButton * button in self.chongBallButtons) {
                button.selected = [selselButtonTags containsObject:@(button.tag)];
                if (button.selected) {
                    button.layer.borderWidth = 0;
                }else
                {
                    button.layer.borderWidth = 1;
                }
            }
        }
    }
}

#pragma mark - 初始化
- (NSMutableArray *)chongBallButtons
{
    if (_chongBallButtons == nil) {
        _chongBallButtons = [NSMutableArray array];
    }
    return _chongBallButtons;
}

- (NSMutableArray *)ballButtons
{
    if (_ballButtons == nil) {
        _ballButtons = [NSMutableArray array];
    }
    return _ballButtons;
}


@end
