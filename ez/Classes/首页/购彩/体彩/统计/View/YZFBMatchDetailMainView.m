//
//  YZFBMatchDetailMainView.m
//  ez
//
//  Created by apple on 17/1/12.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZFBMatchDetailMainView.h"
#import "YZFBMatchDetailTitleView.h"

@interface YZFBMatchDetailMainView ()<UIGestureRecognizerDelegate,UIScrollViewDelegate,YZFBMatchDetailTitleViewDelegate>

@property (nonatomic, weak) YZFBMatchDetailTitleView *titleView;
@property (nonatomic, weak) UIScrollView *mainScrollView;

@end

@implementation YZFBMatchDetailMainView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZBackgroundColor;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.contentSize = CGSizeMake(screenWidth, screenHeight - (statusBarH + navBarH));
        self.panGestureRecognizer.delegate = self;
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    NSArray *titleArray = @[@"战绩",@"积分",@"赔率",@"推荐"];
    YZFBMatchDetailTitleView *titleView = [[YZFBMatchDetailTitleView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 40) titleArray:titleArray];
    self.titleView = titleView;
    titleView.delegate = self;
    [self addSubview:titleView];
    
    //下面的四个view
    UIScrollView * mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), self.width, self.height - CGRectGetMaxY(titleView.frame))];
    self.mainScrollView = mainScrollView;
    mainScrollView.backgroundColor = YZBackgroundColor;
    mainScrollView.contentSize = CGSizeMake(self.width * titleArray.count, self.height - CGRectGetMaxY(titleView.frame));
    mainScrollView.pagingEnabled = YES;
    mainScrollView.bounces = NO;
    mainScrollView.delegate = self;
    mainScrollView.showsVerticalScrollIndicator = NO;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:mainScrollView];
    
    for (int i = 0; i < titleArray.count; i++) {
        if (i == 0) {
            YZFBMatchDetailStandingsView * standingsView = [[YZFBMatchDetailStandingsView alloc] initWithFrame:CGRectMake(i * self.width, 0, mainScrollView.width, mainScrollView.height)];
            self.standingsView = standingsView;
            [mainScrollView addSubview:standingsView];
        }else if (i == 1)
        {
            YZFBMatchDetailIntegralView * integralView = [[YZFBMatchDetailIntegralView alloc] initWithFrame:CGRectMake(i * self.width, 0, mainScrollView.width, mainScrollView.height)];
            self.integralView = integralView;
            [mainScrollView addSubview:integralView];
        }else if (i == 2)
        {
            YZFBMatchDetailOddsView * oddsView = [[YZFBMatchDetailOddsView alloc] initWithFrame:CGRectMake(i * self.width, 0, mainScrollView.width, mainScrollView.height)];
            self.oddsView = oddsView;
            [mainScrollView addSubview:oddsView];
        }else if (i == 3)
        {
            YZFBMatchDetailRecommendView * recommendView = [[YZFBMatchDetailRecommendView alloc] initWithFrame:CGRectMake(i * self.width, 0, mainScrollView.width, mainScrollView.height)];
            self.recommendView = recommendView;
            [mainScrollView addSubview:recommendView];
        }
    }
    [self bringSubviewToFront:titleView];
}
#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 1.取出水平方向上滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    // 2.求出页码
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    //3.切换按钮
    [self.titleView changeSelectedBtnIndex:pageInt];
}
#pragma mark - YZFBMatchDetailTitleViewDelegate代理方法
- (void)scrollViewScrollIndex:(NSInteger)index
{
    //滚动到指定页码
    [self.mainScrollView setContentOffset:CGPointMake(index * screenWidth, 0) animated:YES];
    self.standingsView.tableView.mj_offsetY = 0;
    self.integralView.tableView.mj_offsetY = 0;
    self.oddsView.tableView.mj_offsetY = 0;
    self.recommendView.scrollView.mj_offsetY = 0;
    if (_mainViewDelegate && [_mainViewDelegate respondsToSelector:@selector(indexChangeCurrentIndexIsIndex:)]) {
        [_mainViewDelegate indexChangeCurrentIndexIsIndex:index];
    }
}
#pragma mark - 多手势识别
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
