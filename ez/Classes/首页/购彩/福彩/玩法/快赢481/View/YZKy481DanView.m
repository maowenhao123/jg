//
//  YZKy481DanView.m
//  ez
//
//  Created by dahe on 2019/11/5.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481DanView.h"

@interface YZKy481DanView ()<YZBallBtnDelegate>

@property (nonatomic, strong) NSMutableArray *ballButtons;
@property (nonatomic, strong) NSMutableArray *danBallButtons;

@end

@implementation YZKy481DanView

#pragma mark - 布局子视图
- (void)setupChildViews
{
    [super setupChildViews];
    
    //选号
    UILabel *xuanTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YZMargin, CGRectGetMaxY(self.titleLabel.frame) + 10, 50, 30)];
    xuanTitleLabel.text = @"选号";
    xuanTitleLabel.textColor = YZBlackTextColor;
    xuanTitleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [self addSubview:xuanTitleLabel];
    
    CGFloat ballWH = 35;
    CGFloat ballPadding = (screenWidth - 2 * YZMargin - 8 * ballWH) / 7;
    CGFloat danBallWH = 30;
    CGFloat danBallPadding = (screenWidth - 2 * YZMargin - 8 * danBallWH) / 7;
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
        
        UIButton * ballButton = [UIButton buttonWithType:UIButtonTypeCustom];
        ballButton.tag = i;
        ballButton.frame = CGRectMake(YZMargin + (danBallWH + danBallPadding) * (i - 1), CGRectGetMaxY(btn.frame) + 15, danBallWH, danBallWH);
        ballButton.centerX = btn.centerX;
        [ballButton setTitle:@"胆" forState:UIControlStateNormal];
        [ballButton setTitleColor:YZDrayGrayTextColor forState:UIControlStateNormal];
        [ballButton setTitleColor:YZDrayGrayTextColor forState:UIControlStateHighlighted];
        [ballButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [ballButton setBackgroundImage:[UIImage ImageFromColor:YZBackgroundColor] forState:UIControlStateNormal];
        [ballButton setBackgroundImage:[UIImage ImageFromColor:YZBackgroundColor] forState:UIControlStateHighlighted];
        [ballButton setBackgroundImage:[UIImage ImageFromColor:RGBACOLOR(248, 148, 75, 1)] forState:UIControlStateSelected];
        ballButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(34)];
        ballButton.layer.masksToBounds = YES;
        ballButton.layer.cornerRadius = danBallWH / 2;
        ballButton.layer.borderWidth = 1;
        ballButton.layer.borderColor = YZGrayTextColor.CGColor;
        [ballButton addTarget:self action:@selector(danBallButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:ballButton];
        
        [self.danBallButtons addObject:ballButton];
    }
}

- (void)ballDidClick:(YZBallBtn *)btn
{
    YZBallBtn * otherButton = [self viewWithTag:btn.tag - 10];
    if (btn.selected && otherButton.selected) {
        otherButton.selected = NO;
        otherButton.layer.borderWidth = 1;
    }
    
    if([self.delegate  respondsToSelector:@selector(ballDidClick:)])
    {
        [self.delegate ballDidClick:btn];
    }
}

- (void)danBallButtonDidClick:(UIButton *)button
{
    YZBallBtn * otherButton = [self viewWithTag:button.tag + 10];
    if (!otherButton.selected) {
        return;
    }
    
    int selectedCount = 0;
    for (UIButton * danButton in self.danBallButtons) {
        if (danButton.selected && danButton != button) {
            selectedCount ++;
        }
    }
    if (self.selectedPlayTypeBtnTag == 8) {
        if (selectedCount > 0) {
            [MBProgressHUD showError:@"最多能选择1个胆"];
            return;
        }
    }else if (self.selectedPlayTypeBtnTag == 10)
    {
        if (selectedCount > 2) {
            [MBProgressHUD showError:@"最多能选择3个胆"];
            return;
        }
    }
    
    if([self.delegate respondsToSelector:@selector(ballDidClick:)])
    {
        [self.delegate ballDidClick:(YZBallBtn *)button];
    }
    
    button.selected = !button.selected;
    if (button.selected) {
        button.layer.borderWidth = 0;
    }else
    {
        button.layer.borderWidth = 1;
    }
}

#pragma mark - Setting
- (void)setSelStatusArray:(NSMutableArray *)selStatusArray
{
    _selStatusArray = selStatusArray;
    
    [self reloadData];
}

- (void)setRandomSet:(NSMutableSet *)randomSet
{
    _randomSet = randomSet;
    
    NSArray * randomArr = [NSArray arrayWithArray:_randomSet.allObjects];
    for (int i = 0; i < randomArr.count; i++) {
        int number = [randomArr[i] intValue];
        YZBallBtn *btn = [self viewWithTag:number + 10];
        [btn ballClick:btn];
    }
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
        if (i == 0) {
            for (YZBallBtn * button in self.ballButtons) {
                if ([selselButtonTags containsObject:@(button.tag)]) {
                    [button ballChangeToRed];
                }else
                {
                    [button ballChangeToWhite];
                }
            }
        }else if (i == 1)
        {
            for (UIButton * button in self.danBallButtons) {
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
- (NSMutableArray *)ballButtons
{
    if (_ballButtons == nil) {
        _ballButtons = [NSMutableArray array];
    }
    return _ballButtons;
}

- (NSMutableArray *)danBallButtons
{
    if (_danBallButtons == nil) {
        _danBallButtons = [NSMutableArray array];
    }
    return _danBallButtons;
}


@end
