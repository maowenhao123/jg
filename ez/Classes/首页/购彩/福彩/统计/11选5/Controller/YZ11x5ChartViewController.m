//
//  YZ11x5ChartViewController.m
//  ez
//
//  Created by dahe on 2019/12/6.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZ11x5ChartViewController.h"
#import "YZ11x5ChartTableView.h"

@interface YZ11x5ChartViewController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIView * allView;
@property (nonatomic, weak) YZ11x5ChartTableView * allTableView;
@property (nonatomic, weak) UIView * weiView;
@property (nonatomic,weak) UIScrollView *topBackScrollView;
@property (nonatomic, strong) NSMutableArray *topBtns;
@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, weak) UIScrollView *mainScrollView;

@end

@implementation YZ11x5ChartViewController

#pragma mark - 布局子控件
- (void)setupChilds
{
    [super setupChilds];
    
    NSArray * playTypeBtnTitles = @[@"任选一", @"任选二", @"任选三", @"任选四", @"任选五", @"任选六", @"任选七", @"任选八", @"前二直选", @"前二组选", @"前三直选", @"前三组选"];
    NSInteger index = self.selectedPlayTypeBtnTag;
    if (index > 11 && index < 18) {
        index = index - 11;
    }else if (index == 18)
    {
        index = 9;
    }else if (index == 19)
    {
        index = 11;
    }
    [self.titleBtn setTitle:playTypeBtnTitles[index] forState:UIControlStateNormal];
    
    //开奖号码
    CGFloat viewH = screenHeight - statusBarH - navBarH - bottomViewH - [YZTool getSafeAreaBottom];
    UIView *allView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, viewH)];
    self.allView = allView;
    [self.view addSubview:allView];
    
    UIButton *allTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allTopBtn setTitle:@"开奖号码" forState:UIControlStateNormal];
    allTopBtn.frame = CGRectMake(0, 0, screenWidth, topBtnH);
    allTopBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [allTopBtn setTitleColor:YZColor(233, 116, 61, 1.0) forState:UIControlStateNormal];
    [allTopBtn setBackgroundImage:[UIImage imageNamed:@"button_underline"] forState:UIControlStateNormal];
    [allView addSubview:allTopBtn];
    
    YZ11x5ChartTableView *allTableView = [[YZ11x5ChartTableView alloc] initWithFrame:CGRectMake(0, topBtnH, screenWidth, viewH - topBtnH)];
    self.allTableView = allTableView;
    allTableView.chartCellTag = KChartCellTagAll;
    [allView addSubview:allTableView];
    
    //含千百万的
    UIView *weiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, viewH)];
    self.weiView = weiView;
    [self.view addSubview:weiView];
    
    UIScrollView *topBackScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, topBtnH)];
    self.topBackScrollView = topBackScrollView;
    topBackScrollView.backgroundColor = [UIColor whiteColor];
    topBackScrollView.showsVerticalScrollIndicator = NO;
    topBackScrollView.showsHorizontalScrollIndicator = NO;
    [weiView addSubview:topBackScrollView];
    
    NSArray * topBtnTitles = @[@"万位", @"千位", @"百位"];
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
    
    UIScrollView *mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBtnH, screenWidth, viewH - topBtnH)];
    self.mainScrollView = mainScrollView;
    mainScrollView.delegate = self;
    mainScrollView.contentSize = CGSizeMake(screenWidth * topBtnTitles.count, viewH - topBtnH);
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.bounces = NO;
    mainScrollView.pagingEnabled = YES;
    [weiView addSubview:mainScrollView];
    
    for(int i = 0; i < topBtnTitles.count; i++)
    {
        YZ11x5ChartTableView *weiTableView = [[YZ11x5ChartTableView alloc] initWithFrame:CGRectMake(mainScrollView.width * i, 0, mainScrollView.width, viewH - topBtnH)];
        if (i == 0) {
            weiTableView.chartCellTag = KChartCellTagWan;
        }else if (i == 1)
        {
            weiTableView.chartCellTag = KChartCellTagQian;
        }else if (i == 2)
        {
            weiTableView.chartCellTag = KChartCellTagBai;
        }
        [mainScrollView addSubview:weiTableView];
    }
    
    if(self.selectedPlayTypeBtnTag == 8 || self.selectedPlayTypeBtnTag == 10)
    {
        allView.hidden = YES;
        weiView.hidden = NO;
    }else//没有千百万的
    {
        allView.hidden = NO;
        weiView.hidden = YES;
    }
}

- (void)playTypeDidClickBtn:(UIButton *)btn
{
    [self.titleBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
    
    if(btn.tag == 8 || btn.tag == 10)
    {
        self.allView.hidden = YES;
        self.weiView.hidden = NO;
    }else//没有千百万的
    {
        self.allView.hidden = NO;
        self.weiView.hidden = YES;
    }
}

- (void)setSettingData
{
    [super setSettingData];
    
    self.allTableView.stats = self.chartStatus.stats;
    self.allTableView.dataArray = self.dataArray;
    for (UIView * subView in self.mainScrollView.subviews) {
        if ([subView isKindOfClass:[YZ11x5ChartTableView class]]) {
            YZ11x5ChartTableView *weiTableView = (YZ11x5ChartTableView *)subView;
            weiTableView.stats = self.chartStatus.stats;
            weiTableView.dataArray = self.dataArray;
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
