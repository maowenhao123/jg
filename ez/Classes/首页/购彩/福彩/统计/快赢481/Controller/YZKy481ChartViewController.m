//
//  YZKy481ChartViewController.m
//  ez
//
//  Created by dahe on 2019/11/29.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481ChartViewController.h"
#import "YZKy481ChartRenTableView.h"
#import "YZKy481ChartZhiTableView.h"
#import "YZKy481ChartZuTableView.h"
#import "YZKy481ChartYongTableView.h"
#import "Ky481ChartHeader.h"

@interface YZKy481ChartViewController ()<UIScrollViewDelegate>

@property (nonatomic,weak) UIScrollView *topBackScrollView;
@property (nonatomic, strong) NSMutableArray *topBtns;
@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, weak) UIScrollView *mainScrollView;
@property (nonatomic,weak) YZKy481ChartRenTableView *renTableView;
@property (nonatomic,weak) YZKy481ChartZhiTableView *zhiTableView;
@property (nonatomic,weak) YZKy481ChartZuTableView *zuTableView;

@end

@implementation YZKy481ChartViewController

#pragma mark - 布局子控件
- (void)setupChilds
{
    [super setupChilds];
    
    //顶部的view
    UIScrollView *topBackScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, topBtnH)];
    self.topBackScrollView = topBackScrollView;
    topBackScrollView.backgroundColor = [UIColor whiteColor];
    topBackScrollView.showsVerticalScrollIndicator = NO;
    topBackScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:topBackScrollView];
    
    NSArray * topBtnTitles = @[@"综合", @"自由泳", @"仰泳", @"蛙泳", @"蝶泳"];
    CGFloat topBtnW = topBackScrollView.width / topBtnTitles.count;
    for(int i = 0; i < topBtnTitles.count; i++)
    {
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topBtn.tag = i;
        [topBtn setTitle:topBtnTitles[i] forState:UIControlStateNormal];
        topBtn.frame = CGRectMake(5 + i * topBtnW, 0, topBtnW, topBtnH);
        topBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        topBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [topBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [topBtn setTitleColor:YZColor(233, 116, 61, 1.0) forState:UIControlStateSelected];
        [topBtn setBackgroundImage:[UIImage imageNamed:@"button_underline"] forState:UIControlStateSelected];
        [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if(i == 0)
        {
            topBtn.selected = YES;
            self.selectedBtn = topBtn;
        }
        [topBackScrollView addSubview:topBtn];
        [self.topBtns addObject:topBtn];
    }
    
    //统计
    CGFloat scrollViewH = screenHeight - statusBarH - navBarH - topBtnH - bottomViewH - [YZTool getSafeAreaBottom];
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBtnH, screenWidth, scrollViewH)];
    self.mainScrollView = mainScrollView;
    mainScrollView.delegate = self;
    mainScrollView.contentSize = CGSizeMake(screenWidth * topBtnTitles.count, scrollViewH);
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.bounces = NO;
    mainScrollView.pagingEnabled = YES;
    [self.view addSubview:mainScrollView];
    
    for(int i = 0; i < topBtnTitles.count; i++)
    {
        if (i == 0) {
            //任选
            YZKy481ChartRenTableView *renTableView = [[YZKy481ChartRenTableView alloc] initWithFrame:CGRectMake(mainScrollView.width * i, 0, mainScrollView.width, scrollViewH)];
            self.renTableView = renTableView;
            renTableView.hidden = YES;
            [mainScrollView addSubview:renTableView];
            
            //直选
            YZKy481ChartZhiTableView *zhiTableView = [[YZKy481ChartZhiTableView alloc] initWithFrame:CGRectMake(mainScrollView.width * i, 0, mainScrollView.width, scrollViewH)];
            self.zhiTableView = zhiTableView;
            zhiTableView.hidden = YES;
            [mainScrollView addSubview:zhiTableView];
            
            YZKy481ChartZuTableView *zuTableView = [[YZKy481ChartZuTableView alloc] initWithFrame:CGRectMake(mainScrollView.width * i, 0, mainScrollView.width, scrollViewH)];
            self.zuTableView = zuTableView;
            zuTableView.hidden = YES;
            [mainScrollView addSubview:zuTableView];
            
            if (self.selectedPlayTypeBtnTag < 6) {
                renTableView.hidden = NO;
                [self.titleBtn setTitle:@"任选" forState:UIControlStateNormal];
            }else if (self.selectedPlayTypeBtnTag == 6)
            {
                zhiTableView.hidden = NO;
                [self.titleBtn setTitle:@"直选" forState:UIControlStateNormal];
            }else if (self.selectedPlayTypeBtnTag > 6)
            {
                zuTableView.hidden = NO;
                [self.titleBtn setTitle:@"组选" forState:UIControlStateNormal];
            }
        }else
        {
            YZKy481ChartYongTableView *yongTableView = [[YZKy481ChartYongTableView alloc] initWithFrame:CGRectMake(mainScrollView.width * i, 0, mainScrollView.width, scrollViewH)];
            if (i == 1) {
                yongTableView.chartCellTag = KChartCellTagZiyou;
            }else if (i == 2)
            {
                yongTableView.chartCellTag = KChartCellTagYang;
            }else if (i == 3)
            {
                yongTableView.chartCellTag = KChartCellTagWa;
            }else if (i == 4)
            {
                yongTableView.chartCellTag = KChartCellTagDie;
            }
            [mainScrollView addSubview:yongTableView];
        }
    }
}

- (void)playTypeDidClickBtn:(UIButton *)btn
{
    if (btn.tag == 0) {
        self.renTableView.hidden = NO;
        self.zhiTableView.hidden = YES;
        self.zuTableView.hidden = YES;
    }else if (btn.tag == 1)
    {
        self.renTableView.hidden = YES;
        self.zhiTableView.hidden = NO;
        self.zuTableView.hidden = YES;
    }else if (btn.tag == 2)
    {
        self.renTableView.hidden = YES;
        self.zhiTableView.hidden = YES;
        self.zuTableView.hidden = NO;
    }
    [self.titleBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
}

- (void)setSettingData
{
    [super setSettingData];
    
    self.renTableView.dataArray = self.dataArray;
    self.zhiTableView.dataArray = self.dataArray;
    self.zuTableView.stats = self.chartStatus.stats;
    self.zuTableView.dataArray = self.dataArray;
    for (UIView * subView in self.mainScrollView.subviews) {
        if ([subView isKindOfClass:[YZKy481ChartYongTableView class]]) {
            YZKy481ChartYongTableView *yongTableView = (YZKy481ChartYongTableView *)subView;
            yongTableView.stats = self.chartStatus.stats;
            yongTableView.dataArray = self.dataArray;
        }
    }
}

#pragma mark - 视图滑动
- (void)topBtnClick:(UIButton *)btn
{
    //滚动到指定页码
    [self.mainScrollView setContentOffset:CGPointMake(btn.tag * screenWidth, 0) animated:YES];
    [self changeSelectedBtn:btn];
}

- (void)changeSelectedBtn:(UIButton *)btn
{
    self.selectedBtn.selected = NO;
    self.selectedBtn.userInteractionEnabled = YES;
    btn.userInteractionEnabled = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
}

#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == self.mainScrollView)
    {
        CGFloat offsetX = scrollView.contentOffset.x;
        double pageDouble = offsetX / scrollView.frame.size.width;
        int pageInt = (int)(pageDouble + 0.5);
        [self topBtnClick:self.topBtns[pageInt]];
    }
}

#pragma mark - 初始化
- (NSMutableArray *)topBtns
{
    if (_topBtns == nil) {
        _topBtns = [NSMutableArray array];
    }
    return _topBtns;
}


@end
