//
//  YZKsDiceAnimationView.m
//  ez
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height
#define imageViewWH 100
#define padding 10

#import "YZKsDiceAnimationView.h"
#import <AVFoundation/AVFoundation.h>
#import "YZKsDiceView.h"

@interface YZKsDiceAnimationView ()
{
    AVAudioPlayer * avAudioPlayer;
}

@property (nonatomic, weak) YZKsDiceView *diceView1;
@property (nonatomic, weak) YZKsDiceView *diceView2;
@property (nonatomic, weak) YZKsDiceView *diceView3;
@property (nonatomic, strong) NSMutableArray *diceViews;//三个筛子的
@property (nonatomic, strong) NSMutableArray *randomGifs;//每次都是最新的gif图顺序
@property (nonatomic, strong) NSMutableArray *randoms;//随机数数组
@property (nonatomic, strong) NSMutableArray *selectedButttonTags;//按钮tags

@end

@implementation YZKsDiceAnimationView

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
    [self.diceViews removeAllObjects];
    YZKsDiceView * diceView1 = [[YZKsDiceView alloc]initWithFrame:CGRectMake(KWidth / 2 - imageViewWH - padding, KHeight / 2 - imageViewWH - padding, imageViewWH, imageViewWH)];
    self.diceView1 = diceView1;
    [self addSubview:diceView1];
    [self.diceViews addObject:diceView1];
    
    YZKsDiceView * diceView2 = [[YZKsDiceView alloc]initWithFrame:CGRectMake(KWidth / 2 + padding, KHeight / 2 - imageViewWH - padding, imageViewWH, imageViewWH)];
    self.diceView2 = diceView2;
    [self addSubview:diceView2];
    [self.diceViews addObject:diceView2];
    
    YZKsDiceView * diceView3 = [[YZKsDiceView alloc]initWithFrame:CGRectMake(KWidth / 2 - imageViewWH / 2, KHeight / 2 + padding, imageViewWH, imageViewWH)];
    self.diceView3 = diceView3;
    [self addSubview:diceView3];
    [self.diceViews addObject:diceView3];
}
#pragma mark - 获取tags和randoms
- (void)startDiceAnimationWithPlayType:(int)playType showView:(YZKsBaseView *)showView
{
    _playType = playType;
    _showView = showView;
    //初始化
    self.diceView3.hidden = NO;
    for (int i = 0; i < 3; i++) {
        YZKsDiceView * diceView = self.diceViews[i];
        diceView.alpha = 1;
        diceView.transform = CGAffineTransformIdentity;
        if (i == 0) {
            diceView.frame = CGRectMake(KWidth / 2 - imageViewWH - padding, KHeight / 2 - imageViewWH - padding, imageViewWH, imageViewWH);
        }else if (i == 1)
        {
            diceView.frame = CGRectMake(KWidth / 2 + padding, KHeight / 2 - imageViewWH - padding, imageViewWH, imageViewWH);
        }else if (i == 2)
        {
            diceView.frame = CGRectMake(KWidth / 2 - imageViewWH / 2, KHeight / 2 + padding, imageViewWH, imageViewWH);
        }
    }
    [self.randoms removeAllObjects];
    [self.selectedButttonTags removeAllObjects];
    //播放声音
    [self playSoundByName:@"rotate"];
    NSMutableArray * randoms = [NSMutableArray array];
    NSMutableArray * selectedButttonTags = [NSMutableArray array];
    //和值
    if (playType == 0) {
        int random1 = arc4random() % 6;
        int random2 = arc4random() % 6;
        int random3 = arc4random() % 6;
        
        NSNumber * number = @(random1 + random2 + random3 + 3 + 101);
        [selectedButttonTags addObject:number];
        [selectedButttonTags addObject:number];
        [selectedButttonTags addObject:number];
        
        randoms = [NSMutableArray arrayWithObjects:@(random1 + 1),@(random2 + 1),@(random3 + 1),nil];
    }else if (playType == 1)//三同号
    {
        int random = arc4random() % 6;
        
        NSNumber * number = @(random + 101);
        [selectedButttonTags addObject:number];
        [selectedButttonTags addObject:number];
        [selectedButttonTags addObject:number];
        
        [randoms addObject:@(random + 1)];
        [randoms addObject:@(random + 1)];
        [randoms addObject:@(random + 1)];
    }else if (playType == 2)//二同
    {
        NSMutableSet *set = [NSMutableSet set];
        while (set.count < 2) {//至少2个
            int random = arc4random() % 6;
            NSNumber * number = @(random + 101);
            [set addObject:number];
        }
        NSArray * array = [[set allObjects] mutableCopy];
        
        for (int i = 0; i < 2; i++) {
            NSNumber * number = array[i];
            if (i == 0) {
                [randoms addObject:@([number intValue] - 100)];
                [randoms addObject:@([number intValue] - 100)];
                [selectedButttonTags addObject:number];
                [selectedButttonTags addObject:number];
            }else
            {
                [randoms addObject:@([number intValue] - 100)];
                [selectedButttonTags addObject:@([number intValue] + 100)];
            }
        }
    }else if (playType == 3)//三不同
    {
        NSMutableSet *set = [NSMutableSet set];
        while (set.count < 3) {//至少3个
            int random = arc4random() % 6;
            NSNumber * number = @(random + 101);
            [set addObject:number];
        }
        NSArray * array = [[set allObjects] mutableCopy];
        for (int i = 0; i < 3; i++) {
            NSNumber * number = array[i];
            [randoms addObject:@([number intValue] - 100)];
            [selectedButttonTags addObject:number];
        }
    }else if (playType == 4)//二不同
    {
        self.diceView3.hidden = YES;
        NSMutableSet *set = [NSMutableSet set];
        while (set.count < 2) {//至少2个
            int random = arc4random() % 6;
            NSNumber * number = @(random + 101);
            [set addObject:number];
        }
        NSArray * array = [[set allObjects] mutableCopy];
        for (int i = 0; i < 2; i++) {
            NSNumber * number = array[i];
            [randoms addObject:@([number intValue] - 100)];
            [selectedButttonTags addObject:number];
        }
    }
//    self.randoms = [self sortArray:randoms];
//    self.selectedButttonTags = [self sortArray:selectedButttonTags];
    self.randoms = randoms;
    self.selectedButttonTags = selectedButttonTags;
    [self gifAnimation];
}
#pragma mark - 动画
//gif动画
- (void)gifAnimation
{
    self.isAnimating = YES;
    NSTimeInterval duration = 1;
    NSInteger repeatCount1 = 1;
    NSInteger repeatCount2 = 2;
    for (int i = 0; i < self.randoms.count; i++) {
        YZKsDiceView * diceView = self.diceViews[i];
        diceView.animationImages = self.randomGifs;
        int number = [self.randoms[i] intValue];
        diceView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ks_dice_%d",number]];
        diceView.animationDuration = duration;
        diceView.animationRepeatCount = repeatCount1 + repeatCount2;
        [diceView startAnimating];
    }
    [self performSelector:@selector(dicePostionAnimation) withObject:nil afterDelay:duration * repeatCount1];
    [self performSelector:@selector(showDice) withObject:nil afterDelay:duration * (repeatCount1 + repeatCount2)];
}
- (void)dicePostionAnimation
{
    for (int i = 0; i < self.randoms.count; i++) {
        YZKsDiceView * diceView = self.diceViews[i];
        [diceView diceRandomPostionAnimationWithCount:10 index:i];
    }
}
//展示筛子
- (void)showDice
{
    NSTimeInterval showTime = 1.5;//展示筛子号码的时间
    for (int i = 0; i < self.randoms.count; i++) {
        YZKsDiceView * diceView = self.diceViews[i];
        [UIView animateWithDuration:animateDuration animations:^{//回到原位置
            if (i == 0) {
                diceView.frame = CGRectMake(KWidth / 2 - imageViewWH - padding, KHeight / 2 - imageViewWH - padding, imageViewWH, imageViewWH);
            }else if (i == 1)
            {
                diceView.frame = CGRectMake(KWidth / 2 + padding, KHeight / 2 - imageViewWH - padding, imageViewWH, imageViewWH);
            }else if (i == 2)
            {
                diceView.frame = CGRectMake(KWidth / 2 - imageViewWH / 2, KHeight / 2 + padding, imageViewWH, imageViewWH);
            }
        }];
    }
    [self performSelector:@selector(diceAnimation) withObject:nil afterDelay:showTime];
}
//筛子向按钮移动
- (void)diceAnimation
{
    [self playSoundByName:@"location"];
    for (int i = 0; i < self.randoms.count; i++) {
        YZKsDiceView * diceView = self.diceViews[i];
        NSInteger tag = [self.selectedButttonTags[i] integerValue];
        CGPoint point = [_showView viewWithTag:tag].center;
        [UIView animateWithDuration:1
                         animations:^{
                             CGFloat centerY = point.y + statusBarH + navBarH + 30 + 25 - _showView.contentOffset.y;
                             diceView.center = CGPointMake(point.x, centerY);
                             diceView.alpha = 0.3;
                             diceView.transform = CGAffineTransformMakeScale(0.3, 0.3);
                         } completion:^(BOOL finished) {
                             self.hidden = YES;
                             self.isAnimating = NO;
                             if (_playType == 0) {
                                 int random1 = [self.randoms[0] intValue];
                                 int random2 = [self.randoms[1] intValue];
                                 int random3 = [self.randoms[2] intValue];
                                 [MBProgressHUD showSuccess:[NSString stringWithFormat:@"%d+%d+%d=%d",random1,random2,random3,random1+random2+random3]];
                             }
                             [_showView chooseNumberByTags:self.selectedButttonTags];
                         }];
    }
}
- (void)playSoundByName:(NSString *)name
{
    NSString *string = [[NSBundle mainBundle] pathForResource:name ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:string];
    avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    avAudioPlayer.volume = 0.5f;
    [avAudioPlayer play];
}
#pragma mark - 初始化
- (NSMutableArray *)randomGifs
{
    //每次都是新的
    _randomGifs = [NSMutableArray array];
    NSMutableOrderedSet *orderedSet = [NSMutableOrderedSet orderedSet];
    while (orderedSet.count < 6) {//6个
        int random = arc4random() % 6 + 1;
        [orderedSet addObject:@(random)];
    }
    for (NSNumber * number in orderedSet) {
        UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"ks_dice_gif_%d",[number intValue]]];
        [_randomGifs addObject:image];
    }
    return _randomGifs;
}
- (NSMutableArray *)diceViews
{
    if (_diceViews == nil) {
        _diceViews = [NSMutableArray array];
    }
    return _diceViews;
}
- (NSMutableArray *)selectedButttonTags
{
    if (_selectedButttonTags == nil) {
        _selectedButttonTags = [NSMutableArray array];
    }
    return _selectedButttonTags;
}
- (NSMutableArray *)randoms
{
    if (_randoms == nil) {
        _randoms = [NSMutableArray array];
    }
    return _randoms;
}
#pragma mark - 排序
- (NSMutableArray *)sortArray:(NSMutableArray *)array
{
    if(array.count == 1) return array;
    for(int i = 0;i < array.count;i++)
    {
        for(int j = i + 1;j <array.count;j++)
        {
            int number1 = [array[i] intValue];
            int number2 = [array[j] intValue];
            if(number1 > number2)
            {
                [array exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return array;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
