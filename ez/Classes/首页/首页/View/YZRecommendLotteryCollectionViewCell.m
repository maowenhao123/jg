//
//  YZRecommendLotteryCollectionViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/1/10.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZRecommendLotteryCollectionViewCell.h"
#import "YZQuickStakeGamesView.h"
#import "YZQuickUnionBuyView.h"

@interface YZRecommendLotteryCollectionViewCell ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView * scrollView;
@property (nonatomic, weak) YZQuickStakeGamesView * quickStakeGamesView;
@property (nonatomic, weak) YZQuickUnionBuyView * quickUnionBuyView;
@property (nonatomic, weak) UIButton *leftButton;
@property (nonatomic, weak) UIButton *rightButton;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YZRecommendLotteryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupChilds];
        [self addTimer];
    }
    return self;
}

#pragma mark - 布局试图
- (void)setupChilds
{
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.frame = CGRectMake(0, 0, screenWidth, 115);
    scrollView.contentSize = CGSizeMake(screenWidth * 2, scrollView.height);
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    
    //内容视图
    YZQuickStakeGamesView * quickStakeGamesView = [[YZQuickStakeGamesView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, scrollView.height)];
    self.quickStakeGamesView = quickStakeGamesView;
    [scrollView addSubview:quickStakeGamesView];
    
    YZQuickUnionBuyView * quickUnionBuyView = [[YZQuickUnionBuyView alloc] initWithFrame:CGRectMake(screenWidth, 0, screenWidth, scrollView.height)];
    self.quickUnionBuyView = quickUnionBuyView;
    [scrollView addSubview:quickUnionBuyView];
    
    //左右图标
    CGFloat buttonW = 20;
    CGFloat buttonH = 52;
    CGFloat buttonY = 14 + (88 - buttonH) / 2;
    for (int i = 0; i < 2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        if (i == 0) {
            self.leftButton = button;
            button.frame = CGRectMake(0, buttonY, buttonW, buttonH);
            [button setTitle:@"<" forState:UIControlStateNormal];
            button.hidden = YES;
        }else
        {
            self.rightButton = button;
            button.frame = CGRectMake(self.width - buttonW, buttonY, buttonW, buttonH);
            [button setTitle:@">" forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:YZGetFontSize(35)];
        [self addSubview:button];
    }
}

#pragma mark - 增加定时器
- (void)addTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(animationTimerDidFired:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGFloat offsetX = self.scrollView.contentOffset.x;
    if (offsetX < screenWidth) {
        [self.scrollView setContentOffset:CGPointMake(screenWidth, 0) animated:YES];
    }else if (offsetX >= screenWidth && offsetX < 2 * screenWidth)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (void)buttonDidClick:(UIButton *)button
{
    [self.scrollView setContentOffset:CGPointMake(button.tag * screenWidth, 0) animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX < screenWidth) {
        self.leftButton.hidden = YES;
        self.rightButton.hidden = NO;
    }else if (offsetX >= screenWidth && offsetX < 2 * screenWidth)
    {
        self.leftButton.hidden = NO;
        self.rightButton.hidden = YES;
    }
}

#pragma mark - 设置数据
- (void)setGameModel:(YZQuickStakeGameModel *)gameModel
{
    _gameModel = gameModel;
    
    self.quickStakeGamesView.gameModel = _gameModel;
}

- (void)setUnionBuyStatus:(YZUnionBuyStatus *)unionBuyStatus
{
    _unionBuyStatus = unionBuyStatus;
    
    YZUnionBuyStatusFrame *statusFrame = [[YZUnionBuyStatusFrame alloc] init];
    statusFrame.status = _unionBuyStatus;
    self.quickUnionBuyView.statusFrame = statusFrame;
}

#pragma mark - dealloc
- (void)dealloc
{
    [self removeTimer];
}
- (void)removeTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
