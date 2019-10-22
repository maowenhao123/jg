//
//  YZSegementView.m
//  ez
//
//  Created by dahe on 2019/6/27.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZSegementView.h"

@interface YZSegementView ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *topBackScrollView;
@property (nonatomic, weak) UIButton *selectedBtn;//被选中的顶部按钮
@property (nonatomic, weak) UIView *topBtnLine;//顶部按钮的下划线
@property (nonatomic, assign) int tableViewCount;//一个有几个视图

@end

@implementation YZSegementView

- (instancetype)initWithFrame:(CGRect)frame btnTitles:(NSArray *)btnTitles views:(NSMutableArray *)views
{
    self = [super initWithFrame:frame];
    if (self) {
        self.btnTitles = btnTitles;
        self.views = views;
        if (self.btnTitles.count == self.views.count) {//顶部按钮必须和视图数保持一致
            self.tableViewCount = (int)self.btnTitles.count;
            if (self.maxViewCount == 0) {
                self.maxViewCount = 4;
            }
            [self setupChildViews];
        }
    }
    return self;
}
#pragma mark - 布局子视图
- (void)setupChildViews
{
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    //顶部的view
    UIScrollView *topBackScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, topBtnH)];
    self.topBackScrollView = topBackScrollView;
    topBackScrollView.backgroundColor = [UIColor whiteColor];
    topBackScrollView.showsVerticalScrollIndicator = NO;
    topBackScrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:topBackScrollView];
    
    //顶部按钮
    CGFloat topBtnW = (screenWidth - 10) / self.tableViewCount;
    topBackScrollView.contentSize = CGSizeMake(screenWidth, topBtnH);
    if (self.tableViewCount > self.maxViewCount) {
        topBtnW = (screenWidth - 10) / self.maxViewCount;
        topBackScrollView.contentSize = CGSizeMake(topBtnW * self.tableViewCount, topBtnH);
    }
    for(int i = 0;i < self.tableViewCount;i++)
    {
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topBtn.tag = i;
        [topBtn setTitle:self.btnTitles[i] forState:UIControlStateNormal];
        topBtn.frame = CGRectMake(5 + i*topBtnW, 0, topBtnW, 36);
        topBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        topBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [topBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [topBtn setTitleColor:YZBaseColor forState:UIControlStateSelected];
        [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topBackScrollView addSubview:topBtn];
        [self.topBtns addObject:topBtn];
    }
    //底部线
    UIView * topBtnLine = [[UIView alloc]init];
    self.topBtnLine = topBtnLine;
    topBtnLine.frame = CGRectMake(5 + 5, topBtnH - 2, topBtnW - 5 * 2, 2);
    topBtnLine.backgroundColor = YZBaseColor;
    [topBackScrollView addSubview:topBtnLine];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    UIView * view = [self.views firstObject];
    CGFloat scrollViewH = view.height;
    scrollView.frame = CGRectMake(0, topBtnH, screenWidth, scrollViewH);
    [self addSubview:scrollView];
    
    //设置属性
    scrollView.contentSize = CGSizeMake(screenWidth * self.tableViewCount, scrollViewH);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    
    //添加view
    for(int i = 0;i < self.tableViewCount;i++)
    {
        UIView * view = self.views[i];
        [scrollView addSubview:view];
    }
}
#pragma mark - 视图滑动
- (void)topBtnClick:(UIButton *)btn
{
    //滚动到指定页码
    [self.scrollView setContentOffset:CGPointMake(btn.tag * screenWidth, 0) animated:YES];
    [self changeSelectedBtn:btn];
    
    //所选按钮居中显示
    if (self.btnTitles.count > self.maxViewCount) {
        NSInteger index = btn.tag;
        CGFloat buttonW = btn.width;
        CGFloat offsetX;
        if (index <= 1) {
            offsetX = 0;
        }else if (index > 1 && index < self.btnTitles.count - 2) {
            offsetX = (index - 1.5) * buttonW;
        }else
        {
            offsetX = self.topBackScrollView.contentSize.width - screenWidth;
        }
        [self.topBackScrollView setContentOffset:CGPointMake(offsetX, self.scrollView.mj_offsetY) animated:YES];
    }
}
- (void)changeSelectedBtn:(UIButton *)btn
{
    self.selectedBtn.selected = NO;
    self.selectedBtn.userInteractionEnabled = YES;
    btn.userInteractionEnabled = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    //红线动画
    [UIView animateWithDuration:animateDuration
                     animations:^{
                         self.topBtnLine.center = CGPointMake(btn.center.x, self.topBtnLine.center.y);
                     }];
    //赋值
    self.currentIndex = (int)btn.tag;
    //当前页面切换，子类实现
    [self changeCurrentIndex:self.currentIndex];
}
#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(![scrollView isKindOfClass:[UITableView class]])
    {
        // 1.取出水平方向上滚动的距离
        CGFloat offsetX = scrollView.contentOffset.x;
        // 2.求出页码
        double pageDouble = offsetX / scrollView.frame.size.width;
        int pageInt = (int)(pageDouble + 0.5);
        //3.切换按钮
        [self changeSelectedBtn:self.topBtns[pageInt]];
    }
}
- (void)changeCurrentIndex:(int)currentIndex
{
    //子类实现
}
#pragma mark - 初始化
- (NSArray *)btnTitles
{
    if(_btnTitles == nil)
    {
        _btnTitles = [NSArray array];
    }
    return _btnTitles;
}
- (NSMutableArray *)views
{
    if(_views == nil)
    {
        _views = [NSMutableArray array];
    }
    return _views;
}
- (NSMutableArray *)topBtns
{
    if (_topBtns == nil) {
        _topBtns = [NSMutableArray array];
    }
    return _topBtns;
}
@end
