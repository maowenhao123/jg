//
//  YZCycleScrollView.m
//  demo
//
//  Created by apple on 16/12/22.
//  Copyright © 2016年 JG. All rights reserved.
//
#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height

#import "YZCycleScrollView.h"

@interface YZCycleScrollView ()<UIScrollViewDelegate>

@property (nonatomic , weak) UIScrollView *mainScrollView;//滚动视图
@property (nonatomic , assign) NSTimeInterval animationDuration;//每次滚动的时间间距
@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic, strong) NSMutableArray *contentViews;//包含2个label
@property (nonatomic , assign) NSInteger currentPageIndex;//当前滚动到第几个

@end

@implementation YZCycleScrollView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
                   titleArray:(NSArray *)titleArray
            animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (self) {
        //布局子视图
        UIScrollView * mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
        self.mainScrollView = mainScrollView;
        mainScrollView.delegate = self;
        mainScrollView.contentSize = CGSizeMake(KWidth, 2 * KHeight);
        mainScrollView.contentOffset = CGPointMake(0,-KHeight);
        mainScrollView.scrollEnabled = NO;
        mainScrollView.pagingEnabled = YES;
        [self addSubview:mainScrollView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [mainScrollView addGestureRecognizer:tap];
        
        self.animationDuration = animationDuration;
        self.titleArray = titleArray;
        
    }
    return self;
}
- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    //移除子视图
    for (UIView * subView in self.mainScrollView.subviews) {
        [subView removeFromSuperview];
    }
    //清空计时器
    [self removeAnimationTimerTimer];
    self.currentPageIndex = 0;
    if (_titleArray.count == 0) {//没有标题，不显示
        return;
    }else if (_titleArray.count == 1)//只有一个，显示但不滚动
    {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
        label.text = self.titleArray[0];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        label.textColor = YZColor(106, 106, 106, 1);
        [self.mainScrollView addSubview:label];
        self.mainScrollView.contentOffset = CGPointMake(0, 0);
    }else if (_titleArray.count > 1)//大于一个，显示并滚动
    {
        //显示的2个label
        self.contentViews = [NSMutableArray array];
        for (int i = 0; i < 2; i++) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, KHeight * i, KWidth, KHeight)];
            label.text = self.titleArray[i];
            label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
            label.textColor = YZColor(106, 106, 106, 1);
            [self.mainScrollView addSubview:label];
            
            [self.contentViews addObject:label];
        }
        
        self.currentPageIndex = 0;
        //添加计时器
        if (self.animationDuration > 0 && !self.animationTimer) {
            self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration)
                                                                   target:self
                                                                 selector:@selector(animationTimerDidFired:)
                                                                 userInfo:nil
                                                                  repeats:YES];
            [[NSRunLoop mainRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
            [self.animationTimer fire];
        }
        self.mainScrollView.contentOffset = CGPointMake(0,-KHeight);
    }
}
#pragma mark - 倒计时
- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(0, self.mainScrollView.contentOffset.y + KHeight);
    CGFloat newOffsetY = round(newOffset.y / KHeight) * KHeight;
    newOffset = CGPointMake(0, newOffsetY);
    [self.mainScrollView setContentOffset:newOffset animated:YES];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetY = scrollView.contentOffset.y;
    if(contentOffsetY >= KHeight) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        [self configContentViews];
    }
}
#pragma mark - 私有方法
- (void)configContentViews
{
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    for (int i = 0; i < self.contentViews.count; i++) {
        UILabel * label = self.contentViews[i];
        if (i == 0)
        {
            label.text = self.titleArray[self.currentPageIndex];
        }else if (i == 1)
        {
            label.text = self.titleArray[rearPageIndex];
        }
    }
    [self.mainScrollView setContentOffset:CGPointMake(0, 0)];
}
- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if (currentPageIndex == self.titleArray.count) {
        return 0;
    } else
    {
        return currentPageIndex;
    }
}
- (void)tapAction
{
    if (self.TapActionBlock) {
        if (self.titleArray.count) {
            self.TapActionBlock(self.currentPageIndex);
        }
    }
}
#pragma mark - dealloc
- (void)dealloc
{
    [self removeAnimationTimerTimer];
}
- (void)removeAnimationTimerTimer
{
    if (self.animationTimer) {
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
}
@end
