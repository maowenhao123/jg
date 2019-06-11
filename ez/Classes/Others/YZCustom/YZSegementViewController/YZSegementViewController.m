//
//  YZSegementViewController.m
//  ez
//
//  Created by apple on 16/9/29.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZSegementViewController.h"

@interface YZSegementViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIButton *selectedBtn;//被选中的顶部按钮
@property (nonatomic, weak) UIView *topBtnLine;//顶部按钮的下划线
@property (nonatomic, assign) int tableViewCount;//一个有几个视图

@end

@implementation YZSegementViewController

- (void)configurationComplete
{
    if (self.btnTitles.count == self.views.count) {//顶部按钮必须和视图数保持一致
        self.tableViewCount = (int)self.btnTitles.count;
        [self setupChildViews];
    }
}
#pragma mark - 布局子视图
- (void)setupChildViews
{
    //底部的view
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, topBtnH)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    //顶部按钮
    CGFloat topBtnW = (screenWidth - 10) / self.tableViewCount;
    for(int i = 0;i < self.tableViewCount;i++)
    {
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topBtn.tag = i;
        [topBtn setTitle:self.btnTitles[i] forState:UIControlStateNormal];
        topBtn.frame = CGRectMake(5 + i*topBtnW, 0, topBtnW, topBtnH - 2);
        topBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        topBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [topBtn setTitleColor:YZColor(134, 134, 134, 1) forState:UIControlStateNormal];
        [topBtn setTitleColor:YZColor(246, 53, 80, 1) forState:UIControlStateSelected];
        [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:topBtn];
        [self.topBtns addObject:topBtn];
    }
    //底部红线
    UIView * topBtnLine = [[UIView alloc]init];
    self.topBtnLine = topBtnLine;
    topBtnLine.frame = CGRectMake(5, topBtnH - 2, topBtnW, 2);
    topBtnLine.backgroundColor = YZColor(246, 53, 80, 1);
    [backView addSubview:topBtnLine];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    UIView * view = [self.views firstObject];
    CGFloat scrollViewH = view.height;
    scrollView.frame = CGRectMake(0, topBtnH, screenWidth, scrollViewH);
    [self.view addSubview:scrollView];
    
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
