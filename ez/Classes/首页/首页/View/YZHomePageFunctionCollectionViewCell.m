//
//  YZHomePageFunctionCollectionViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/1/10.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZHomePageFunctionCollectionViewCell.h"
#import "YZHomePageFunctionItemView.h"

@interface YZHomePageFunctionCollectionViewCell ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView * scrollView;
@property (nonatomic,weak) UIPageControl *pageControl;
@property (nonatomic, assign) CGFloat itemViewW;

@end

@implementation YZHomePageFunctionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.itemViewW = self.width / 5;
        [self setupChilds];
    }
    return self;
}

#pragma mark - 布局试图
- (void)setupChilds
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.itemViewW, 84)];
    self.scrollView = scrollView;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.clipsToBounds = NO;
    scrollView.delegate = self;
    [self addSubview:scrollView];
    
    UIPageControl * pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 75, self.width, 10)];
    self.pageControl = pageControl;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = YZRedBallColor;
    [self addSubview:pageControl];
}

- (void)setFunctions:(NSArray *)functions
{
    _functions = functions;
    
    if (_functions.count <= 0) {
        return;
    }else if (_functions.count < 5)
    {
        self.itemViewW = self.width / _functions.count;
    }else
    {
        self.itemViewW = self.width / 5;
    }
    
    self.scrollView.width = self.itemViewW;
    
    if (_functions.count > 5) {
        self.pageControl.hidden = NO;
        self.pageControl.numberOfPages = _functions.count / 5 + 1;
        self.scrollView.contentSize = CGSizeMake(self.itemViewW * (_functions.count - 4), self.scrollView.height);
    }else
    {
        self.pageControl.hidden = YES;
        self.scrollView.contentSize = CGSizeMake(self.itemViewW, self.scrollView.height);
    }
    
    for (UIView * subView in self.scrollView.subviews) {
        [subView removeFromSuperview];
    }

    CGFloat itemViewH = self.scrollView.height;
    for (int i = 0; i < _functions.count; i++) {
        YZHomePageFunctionItemView * functionItemView = [[YZHomePageFunctionItemView alloc] initWithFrame:CGRectMake(self.itemViewW * i, 0, self.itemViewW, itemViewH)];
        functionItemView.functionModel = _functions[i];
        [self.scrollView addSubview:functionItemView];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX == 0) {
        self.pageControl.currentPage = 0;
    }else if (offsetX > 0 && offsetX <= self.width)
    {
        self.pageControl.currentPage = 1;
    }else if (offsetX > 1 && offsetX <= self.width * 2)
    {
        self.pageControl.currentPage = 2;
    }
}

#pragma mark---修改hitTest方法
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isEqual:self.contentView]){
        for (UIView *subview in self.scrollView.subviews){
            CGPoint offset = CGPointMake(point.x - self.scrollView.x + self.scrollView.contentOffset.x - subview.x, point.y - self.scrollView.y + self.scrollView.contentOffset.y - subview.y);
            
            if ((view = [subview hitTest:offset withEvent:event])){
                return view;
            }
        }
        return self.scrollView;
    }
    return view;
}

@end
