//
//  YZSsqChartViewController.m
//  ez
//
//  Created by apple on 17/3/3.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define chartCellH screenWidth / 13

#import "YZSsqChartViewController.h"
#import "YZNavigationController.h"
#import "YZLoadHtmlFileController.h"
#import "YZBetViewController.h"
#import "YZChartSsqPlaytypeView.h"
#import "YZChartPlayTypeTitleButton.h"
#import "YZChartSettingView.h"
#import "YZChartTitleView.h"
#import "YZChartLineView.h"
#import "YZChartSsqLotteryTableViewCell.h"
#import "YZChartViewLeftTableViewCell.h"
#import "YZChartViewContentTableViewCell.h"
#import "YZChartSortButton.h"
#import "YZChartColdHotTableViewCell.h"
#import "YZChartChooseBallView.h"
#import "YZChartSelectedBallView.h"
#import "YZChartBottomView.h"
#import "YZChartStatus.h"
#import "YZDateTool.h"
#import "YZMathTool.h"
#import "YZBetStatus.h"
#import "YZStatusCacheTool.h"
#import "UMMobClick/MobClick.h"

@interface YZSsqChartViewController ()<UITableViewDelegate,UITableViewDataSource,YZChartSsqPlaytypeViewDelegate,YZChartSettingViewDelegate, YZChartTitleViewDelegate,YZChartBottomViewDelegate,YZChartChooseBallViewDelegate>
{
    NSInteger _currentIndex;//当前页
    NSInteger _ballNumber;//号码球数 红:33 蓝:16
    NSInteger _remainSeconds;//本期截止倒计时剩余秒数
    NSInteger _nextOpenRemainSeconds;//下期开奖倒计时剩余秒数
}

@property (nonatomic, assign) BOOL openPlaytypeView;
@property (nonatomic, weak) YZChartPlayTypeTitleButton *titleBtn;
@property (nonatomic, strong) UIBarButtonItem * rightBarButtonItem;
@property (nonatomic, weak) UIView *ballTitleView;
@property (nonatomic, strong) NSMutableArray *ballTitleLabels;
@property (nonatomic, weak) UIView *lotteryView;//开奖视图
@property (nonatomic, weak) UIView *trendView;//开奖视图
@property (nonatomic, weak) UIView *coldHotView;//开奖视图
@property (nonatomic, weak) YZChartSortButton *lotterySortButton;
@property (nonatomic, weak) UITableView *lotteryTableView;//开奖tableview
@property (nonatomic, weak) UITableView *leftTableView;
@property (nonatomic, weak) UITableView * rightTableView;//走势tableview
@property (nonatomic, weak) YZChartLineView * lineView;//分割线
@property (nonatomic, weak) UIScrollView *buttomScrollView;
@property (nonatomic, weak) UITableView *coldHotTableView;//冷热tableview
@property (nonatomic, strong) NSMutableArray *coldHotSortButtons;//冷热排序
@property (nonatomic, weak) YZChartChooseBallView *chooseBallView;
@property (nonatomic, weak) YZChartSelectedBallView *selectedBallView;
@property (nonatomic, weak) YZChartBottomView * bottomView;

@property (nonatomic, strong) NSArray *lotteryStatusArray;
@property (nonatomic, strong) NSMutableArray *redBallStatus;
@property (nonatomic, strong) NSMutableArray *blueBallStatus;
@property (nonatomic, strong) NSArray <YZChartColdHotStatus *> *redColdHotStatus;
@property (nonatomic, strong) NSArray <YZChartColdHotStatus *>*blueColdHotStatus;

@property (nonatomic, strong) YZChartStatus * chartStatus;//数据
@property (nonatomic, strong) NSArray * dataArray;//遗漏集合

@property (nonatomic, strong) NSDictionary *currentTermDict;//当前期的字典信息
@property (nonatomic, strong) NSTimer *getCurrentTermDataTimer;

@end

@implementation YZSsqChartViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 取出appearance对象
    UINavigationBar *navBar = self.navigationController.navigationBar;
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage new]];
    navBar.tintColor = YZBlackTextColor;
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //添加倒计时
    [self addSetDeadlineTimer];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 取出appearance对象
    UINavigationBar *navBar = self.navigationController.navigationBar;
#if JG
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:YZBaseColor WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    navBar.tintColor = [UIColor whiteColor];
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
#elif ZC
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    navBar.tintColor = YZBlackTextColor;
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
#elif CS
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    navBar.tintColor = YZBlackTextColor;
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
#endif
    [navBar setShadowImage:nil];
    //销毁定时器
    [self.getCurrentTermDataTimer invalidate];
    self.getCurrentTermDataTimer = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _ballNumber = 33;
    if (self.isDlt) {
        _ballNumber = 35;
    }
    _remainSeconds = 0;
    _nextOpenRemainSeconds = 0;
    [self setupChilds];
    [self getCurrentTermData];//获取当前期信息，获得截止时间
    //统计次数
    if (self.isDlt) {
        [MobClick event:@"trendchart_click_statistic_t01"];
    }else
    {
        [MobClick event:@"trendchart_click_statistic_f01"];
    }
}
#pragma mark - 布局视图
- (void)setupChilds
{
    //bar
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"chart_back" highIcon:@"chart_back" target:self action:@selector(back)];
    
    self.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"chart_setting" highIcon:@"chart_setting" target:self action:@selector(setting)];
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    //title
    YZChartPlayTypeTitleButton *titleBtn = [[YZChartPlayTypeTitleButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    self.titleBtn = titleBtn;
    [titleBtn setImage:[UIImage imageNamed:@"chart_down_arrow"] forState:UIControlStateNormal];
    if (self.isDlt) {
        if (self.isDantuo) {
            [titleBtn setTitle:@"大乐透胆拖" forState:UIControlStateNormal];
        }else
        {
            [titleBtn setTitle:@"大乐透" forState:UIControlStateNormal];
        }
    }else
    {
        if (self.isDantuo) {
            [titleBtn setTitle:@"双色球胆拖" forState:UIControlStateNormal];
        }else
        {
            [titleBtn setTitle:@"双色球" forState:UIControlStateNormal];
        }
    }
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
    //标题
    NSArray * titleArray = @[@"开奖",@"红球走势",@"蓝球走势",@"红球冷热",@"蓝球冷热"];
    if (self.isDlt) {
        titleArray = @[@"开奖",@"前区走势",@"后区走势",@"前区冷热",@"后区冷热"];
    }
    YZChartTitleView * titleView = [[YZChartTitleView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 35) titleArray:titleArray];
    titleView.delegate = self;
    [self.view addSubview:titleView];
    
    CGFloat bottomViewH = 45;
    CGFloat selectedBallH = 30;
    CGFloat ballViewH = 30;
    CGFloat viewY = CGRectGetMaxY(titleView.frame);
    CGFloat viewH = screenHeight - statusBarH - navBarH - viewY - bottomViewH - ballViewH - selectedBallH - [YZTool getSafeAreaBottom];
    //开奖
    UIView * lotteryView = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, screenWidth, viewH + ballViewH + selectedBallH)];
    self.lotteryView = lotteryView;
    lotteryView.backgroundColor = YZChartBackgroundColor;
    [self.view addSubview:lotteryView];
    
    NSArray * lotteryTitleViewWs = @[@0.2,@0.5,@0.3];
    NSArray * lotteryTitles = @[@"期号",@"红球",@"蓝球"];
    UIView * lastLotteryTitleView;
    YZChartSortButton * lotterySortButton = [[YZChartSortButton alloc] init];
    self.lotterySortButton = lotterySortButton;
    lotterySortButton.frame = CGRectMake(0, 0, [lotteryTitleViewWs[0] floatValue] * screenWidth, chartCellH);
    lotterySortButton.text = lotteryTitles[0];
    lotterySortButton.hiddenLine = YES;
    NSString *lotterySortMode = [YZTool getChartSettingByTitle:@"排列"];
    if ([lotterySortMode isEqualToString:@"倒序排列"]) {//降序
        lotterySortButton.sortMode = SortModeDescending;
    }else//升序
    {
        lotterySortButton.sortMode = SortModeAscending;
    }
    [lotterySortButton addTarget:self action:@selector(lotterySortButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [lotteryView addSubview:lotterySortButton];
    
    lastLotteryTitleView = lotterySortButton;
    
    
    for (int i = 0; i < 2; i++) {
        UILabel * lotteryTitleLabel = [[UILabel alloc] initWithFrame: CGRectMake(CGRectGetMaxX(lastLotteryTitleView.frame), 0, [lotteryTitleViewWs[i + 1] floatValue] * screenWidth, chartCellH)];
        lotteryTitleLabel.text = lotteryTitles[i + 1];
        lotteryTitleLabel.textColor = YZChartGrayColor;
        lotteryTitleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        lotteryTitleLabel.textAlignment = NSTextAlignmentCenter;
        [lotteryView addSubview:lotteryTitleLabel];
        lastLotteryTitleView = lotteryTitleLabel;
        
        UIView * line = [[UIView alloc] init];
        line.frame = CGRectMake(0, 0, 0.8, lotteryView.height);
        line.backgroundColor = YZGrayLineColor;
        [lotteryTitleLabel addSubview:line];
    }
    
    UITableView * lotteryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastLotteryTitleView.frame), screenWidth, lotteryView.height - CGRectGetMaxY(lastLotteryTitleView.frame))];
    self.lotteryTableView = lotteryTableView;
    lotteryTableView.backgroundColor = [UIColor whiteColor];
    lotteryTableView.dataSource = self;
    lotteryTableView.delegate = self;
    lotteryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [lotteryTableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [lotteryView addSubview:lotteryTableView];
    
    //走势
    UIView * trendView = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, screenWidth, viewH)];
    self.trendView = trendView;
    trendView.backgroundColor = YZChartBackgroundColor;
    [self.view addSubview:trendView];
    //滚动视图
    CGFloat ballTitleLabelW = chartCellH;
    UIView * termTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  chartCellH * 2, chartCellH)];
    termTitleView.backgroundColor = YZChartBackgroundColor;
    [trendView addSubview:termTitleView];
    
    UIView * ballTitleView = [[UIView alloc] initWithFrame:CGRectMake(ballTitleLabelW * 2, 0, chartCellH * 35, chartCellH)];
    self.ballTitleView = ballTitleView;
    ballTitleView.hidden = YES;
    ballTitleView.backgroundColor = YZChartBackgroundColor;
    [trendView addSubview:ballTitleView];
    [trendView bringSubviewToFront:termTitleView];
    
    for (int i = 0; i < 35; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(ballTitleLabelW * i, 0, ballTitleLabelW, chartCellH)];
        label.hidden = YES;
        label.text = [NSString stringWithFormat:@"%02d",i + 1];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        label.textColor = YZChartGrayColor;
        label.textAlignment = NSTextAlignmentCenter;
        [ballTitleView addSubview:label];
        [self.ballTitleLabels addObject:label];
        
        //分割线
        UIView * line = [[UIView alloc] init];
        line.frame = CGRectMake(0, 0, 0.8, ballTitleView.height);
        line.backgroundColor = YZGrayLineColor;
        [label addSubview:line];
    }
    [self setBallTitle];
    
    CGFloat tableViewY = CGRectGetMaxY(ballTitleView.frame);
    CGFloat tableViewH = trendView.height - tableViewY;
    CGFloat leftTableViewW = chartCellH * 2;
    UITableView * leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, leftTableViewW, tableViewH)];
    self.leftTableView = leftTableView;
    leftTableView.backgroundColor = [UIColor whiteColor];
    leftTableView.dataSource = self;
    leftTableView.delegate = self;
    leftTableView.showsVerticalScrollIndicator = NO;
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [leftTableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [trendView addSubview:leftTableView];
    
    UITableView * rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _ballNumber * chartCellH, tableViewH)];
    self.rightTableView = rightTableView;
    rightTableView.backgroundColor = [UIColor whiteColor];
    rightTableView.dataSource = self;
    rightTableView.delegate = self;
    [rightTableView setEstimatedSectionHeaderHeightAndFooterHeight];
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIScrollView * buttomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftTableViewW, tableViewY, screenWidth - leftTableViewW, tableViewH)];
    self.buttomScrollView = buttomScrollView;
    buttomScrollView.backgroundColor = [UIColor whiteColor];
    buttomScrollView.contentSize = CGSizeMake(rightTableView.width, 0);
    buttomScrollView.delegate = self;
    buttomScrollView.showsHorizontalScrollIndicator = NO;
    buttomScrollView.bounces = NO;
    [trendView addSubview:buttomScrollView];
    [buttomScrollView addSubview:rightTableView];
    
    YZChartLineView * lineView = [[YZChartLineView alloc] init];
    self.lineView = lineView;
    lineView.backgroundColor = [UIColor clearColor];
    [rightTableView addSubview:lineView];
    
    //冷热
    UIView * coldHotView = [[UIView alloc] initWithFrame:CGRectMake(0, viewY, screenWidth, viewH)];
    self.coldHotView = coldHotView;
    coldHotView.backgroundColor = YZChartBackgroundColor;
    [self.view addSubview:coldHotView];
    
    NSArray * coldHotSortTitles = @[@"号码",@"30期",@"50期",@"100期",@"遗漏"];
    NSArray * coldHotSortTitleViewWs = @[@0.16,@0.21,@0.21,@0.21,@0.21];
    UIView * lastSortButton;
    for (int i = 0; i < coldHotSortTitles.count; i++) {
        YZChartSortButton * sortButton = [[YZChartSortButton alloc] init];
        sortButton.tag = i;
        sortButton.frame = CGRectMake(CGRectGetMaxX(lastSortButton.frame), 0, [coldHotSortTitleViewWs[i] floatValue] * screenWidth, chartCellH);
        sortButton.backgroundColor = YZChartBackgroundColor;
        sortButton.text = coldHotSortTitles[i];
        if (i == 0) {
            sortButton.hiddenLine = YES;
        }else
        {
            sortButton.hiddenLine = NO;
        }
        [sortButton addTarget:self action:@selector(coldHotSortButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [coldHotView addSubview:sortButton];
        [self.coldHotSortButtons addObject:sortButton];
        lastSortButton = sortButton;
        NSString *coldHotSortMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"ssq_coldHot_sortMode"];
        if (i == 0) {//号码球
            if (YZStringIsEmpty(coldHotSortMode)|| [coldHotSortMode isEqualToString:@"ssq_coldHot_number_ascending"]) {//默认
                sortButton.sortMode = SortModeAscending;
            }else if ([coldHotSortMode isEqualToString:@"ssq_coldHot_number_descending"])
            {
                sortButton.sortMode = SortModeDescending;
            }
        }else if (i == 1) {//30期
            if ([coldHotSortMode isEqualToString:@"ssq_coldHot_stat30_ascending"]) {
                sortButton.sortMode = SortModeAscending;
            }else if ([coldHotSortMode isEqualToString:@"ssq_coldHot_stat30_descending"])
            {
                sortButton.sortMode = SortModeDescending;
            }
        }else if (i == 2) {//50期
            if ([coldHotSortMode isEqualToString:@"ssq_coldHot_stat50_ascending"]) {
                sortButton.sortMode = SortModeAscending;
            }else if ([coldHotSortMode isEqualToString:@"ssq_coldHot_stat50_descending"])
            {
                sortButton.sortMode = SortModeDescending;
            }
        }else if (i == 3) {//100期
            if ([coldHotSortMode isEqualToString:@"ssq_coldHot_stat100_ascending"]) {
                sortButton.sortMode = SortModeAscending;
            }else if ([coldHotSortMode isEqualToString:@"ssq_coldHot_stat100_descending"])
            {
                sortButton.sortMode = SortModeDescending;
            }
        }else if (i == 4) {//30期
            if ([coldHotSortMode isEqualToString:@"ssq_coldHot_yilou_ascending"]) {
                sortButton.sortMode = SortModeAscending;
            }else if ([coldHotSortMode isEqualToString:@"ssq_coldHot_yilou_descending"])
            {
                sortButton.sortMode = SortModeDescending;
            }
        }
    }
    
    CGFloat coldHotTableViewY = CGRectGetMaxY(lastSortButton.frame);
    CGFloat coldHotTableViewH = coldHotView.height - tableViewY;
    UITableView * coldHotTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, coldHotTableViewY, screenWidth, coldHotTableViewH)];
    self.coldHotTableView = coldHotTableView;
    coldHotTableView.backgroundColor = [UIColor whiteColor];
    coldHotTableView.delegate = self;
    coldHotTableView.dataSource = self;
    coldHotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [coldHotTableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [coldHotView addSubview:coldHotTableView];
    
    //选号
    CGFloat ballViewY = screenHeight - statusBarH - navBarH - bottomViewH - selectedBallH - ballViewH - [YZTool getSafeAreaBottom];
    
    YZChartChooseBallView *chooseBallView = [[YZChartChooseBallView alloc] initWithFrame:CGRectMake(0, ballViewY, screenWidth, ballViewH)];
    self.chooseBallView = chooseBallView;
    chooseBallView.backgroundColor = [UIColor whiteColor];
    chooseBallView.delegate = self;
    chooseBallView.ballStatuss = self.redBallStatus;
    [self.view addSubview:chooseBallView];
    
    //已选
    CGFloat selectedBallY = screenHeight - statusBarH - navBarH - bottomViewH - selectedBallH - [YZTool getSafeAreaBottom];
    
    YZChartSelectedBallView *selectedBallView = [[YZChartSelectedBallView alloc] initWithFrame:CGRectMake(0, selectedBallY, screenWidth, selectedBallH)];
    self.selectedBallView = selectedBallView;
    selectedBallView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:selectedBallView];
    
    //底栏
    CGFloat bottomViewY = screenHeight - bottomViewH - statusBarH - navBarH - [YZTool getSafeAreaBottom];
    YZChartBottomView *bottomView = [[YZChartBottomView alloc] initWithFrame:CGRectMake(0, bottomViewY, screenWidth, bottomViewH)];
    self.bottomView = bottomView;
    bottomView.delegate = self;
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    //默认是红球走势
    if (self.isRecentOpenLottery) {
        [self scrollViewScrollIndex:0];
        [titleView changeSelectedBtnIndex:0];
    }else
    {
        [self scrollViewScrollIndex:1];
        [titleView changeSelectedBtnIndex:1];
    }
    
    [self setViewByDantuo];//设置胆拖
    [self setSelectedNumberBall];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setting
{
    NSArray * titleArray = [NSArray array];
    if (_currentIndex == 0) {
        titleArray = @[@"期数",@"排列"];
    }else if (_currentIndex == 1) {
        titleArray = @[@"期数",@"遗漏",@"统计"];
    }else if (_currentIndex == 2 && !self.isDlt) {
        titleArray = @[@"期数",@"折线",@"遗漏",@"统计"];
    }else if (_currentIndex == 2 && self.isDlt) {
        titleArray = @[@"期数",@"遗漏",@"统计"];
    }
    YZChartSettingView * settingView = [[YZChartSettingView alloc] initWithTitleArray:titleArray];
    settingView.delegate = self;
}
- (void)titleBtnClick:(YZChartPlayTypeTitleButton *)button
{
    self.openPlaytypeView = !self.openPlaytypeView;
    [self setTitleButtonImageView];
    //玩法
    YZChartSsqPlaytypeView *playtypeView = [[YZChartSsqPlaytypeView alloc] initWithIsDantuo:self.dantuo];
    playtypeView.delegate = self;
}
- (void)setTitleButtonImageView
{
    [UIView animateWithDuration:animateDuration animations:^{
        if(self.openPlaytypeView)
        {
            self.titleBtn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        }else
        {
            self.titleBtn.imageView.transform = CGAffineTransformIdentity;
        }
    }];
}
#pragma mark - 设置视图
//是否是胆拖
- (void)setViewByDantuo
{
    [self setCanBuy];
    CGFloat viewH;//改变视图的高度
    if (self.dantuo) {//胆拖
        viewH = self.lotteryView.height;
    }else
    {
        viewH = self.lotteryView.height - 30 * 2;
    }
    self.trendView.height = viewH ;
    self.leftTableView.height = viewH - chartCellH;
    self.rightTableView.height = viewH - chartCellH;
    self.buttomScrollView.height = viewH - chartCellH;
    self.coldHotView.height = viewH;
    self.coldHotTableView.height = viewH - chartCellH;
}
//设置bar
- (void)setSettingBar
{
    if (_currentIndex == 0) {
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    }else if (_currentIndex == 1)
    {
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    }else if (_currentIndex == 2)
    {
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    }else
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
}
//设置视图的显示和隐藏
- (void)setViewShowOrHidden
{
    self.lotteryView.hidden = YES;
    self.trendView.hidden = YES;
    self.coldHotView.hidden = YES;
    if (_currentIndex == 0) {//开奖
        self.lotteryView.hidden = NO;
    }else if (_currentIndex == 1 || _currentIndex == 2)//走势
    {
        self.trendView.hidden = NO;
        self.lineView.hidden = YES;
        
        NSString * showLineStr = [YZTool getChartSettingByTitle:@"折线"];
        if (_currentIndex == 2 && [showLineStr isEqualToString:@"显示折线"] && !self.isDlt) {//蓝球走势才显示
            self.lineView.hidden = NO;
        }
    }else if (_currentIndex == 3 || _currentIndex == 4)//冷热
    {
        self.coldHotView.hidden = NO;
        [self.coldHotTableView reloadData];
    }
}
//设置试图大小
- (void)setViewSize
{
    NSString * termCountStr = [YZTool getChartSettingByTitle:@"期数"];
    NSInteger termCount = [[termCountStr substringWithRange:NSMakeRange(1, termCountStr.length - 2)] integerValue];
    termCount = termCount < self.chartStatus.data.count ? termCount : self.chartStatus.data.count;
    //设置大小
    NSString * tongjiStr = [YZTool getChartSettingByTitle:@"统计"];
    if ([tongjiStr isEqualToString:@"显示统计"]) {//显示统计
        termCount += 4;
    }
    self.buttomScrollView.contentSize = CGSizeMake(chartCellH * _ballNumber, 0);
    self.rightTableView.width = self.buttomScrollView.mj_contentW;
    self.lineView.frame = CGRectMake(0, 0, self.rightTableView.width, termCount * chartCellH);
}
//设置是否可以购买
- (void)setCanBuy
{
    //是否可以购买
    if (_currentIndex == 0 || self.isDantuo) {//不可购买
        self.bottomView.canBuy = NO;
        self.chooseBallView.hidden = YES;
        self.selectedBallView.hidden = YES;
    }else
    {
        self.bottomView.canBuy = YES;
        self.chooseBallView.hidden = NO;
        self.selectedBallView.hidden = NO;
    }
}
//设置球
- (void)setBall
{
    //红球或蓝球
    if (_currentIndex == 1 || _currentIndex == 3)
    {
        self.chooseBallView.ballStatuss = self.redBallStatus;
        self.chooseBallView.scrollView.mj_offsetX = 0;
    }else if (_currentIndex == 2 || _currentIndex == 4)
    {
        self.chooseBallView.ballStatuss = self.blueBallStatus;
        self.chooseBallView.scrollView.mj_offsetX = 0;
    }
    
    //球数改变
    if (_currentIndex == 1 || _currentIndex == 2) {
        if (self.isDlt) {
            if (_currentIndex == 1) {
                _ballNumber = 35;
            }else
            {
                _ballNumber = 12;
            }
        }else
        {
            if (_currentIndex == 1) {
                _ballNumber = 33;
            }else
            {
                _ballNumber = 16;
            }
        }
        self.rightTableView.width = chartCellH * _ballNumber;
        self.buttomScrollView.mj_contentW = self.rightTableView.width;
        [self setBallTitle];
        [self.rightTableView reloadData];
    }
}
//设置号码球title
- (void)setBallTitle
{
    self.ballTitleView.hidden = YES;
    if (_currentIndex == 1 || _currentIndex == 2) {
        self.ballTitleView.hidden = NO;
        self.ballTitleView.width = chartCellH * self.ballTitleLabels.count;
        for (int i = 0; i < self.ballTitleLabels.count; i++) {
            UILabel * label = self.ballTitleLabels[i];
            if (i < _ballNumber) {
                label.hidden = NO;
            }else
            {
                label.hidden = YES;
            }
        }
    }
}
- (void)setSelectedNumberBall
{
    NSMutableString * redStr = [NSMutableString string];
    for (YZChartBallStatus * ballStatsus in self.redBallStatus) {
        if (ballStatsus.isSelected) {
            [redStr appendFormat:@"%@ ",ballStatsus.number];
        }
    }
    NSMutableString * blueStr = [NSMutableString string];
    for (YZChartBallStatus * ballStatsus in self.blueBallStatus) {
        if (ballStatsus.isSelected) {
            [blueStr appendFormat:@"%@ ",ballStatsus.number];
        }
    }
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",redStr,blueStr]];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:NSMakeRange(0, redStr.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(redStr.length + 1, blueStr.length)];
    self.selectedBallView.numberLabel.attributedText = attStr;
}
#pragma mark - 协议
- (void)changePlaytypeIsDantuo:(BOOL)isDantuo
{
    self.dantuo = isDantuo;
    if (self.isDlt) {
        if (self.isDantuo) {
            [self.titleBtn setTitle:@"大乐透胆拖" forState:UIControlStateNormal];
        }else
        {
            [self.titleBtn setTitle:@"大乐透" forState:UIControlStateNormal];
        }
    }else
    {
        if (self.isDantuo) {
            [self.titleBtn setTitle:@"双色球胆拖" forState:UIControlStateNormal];
        }else
        {
            [self.titleBtn setTitle:@"双色球" forState:UIControlStateNormal];
        }
    }
    [self setViewByDantuo];
}
- (void)closePlaytypeView
{
    self.openPlaytypeView = NO;
    [self setTitleButtonImageView];
}
- (void)settingGotoHelpVC
{
    YZLoadHtmlFileController * webVC = [[YZLoadHtmlFileController alloc]initWithFileName:@"chart_help_F01_T01.html"];
#if JG
    webVC.title = @"九歌彩票";
#elif ZC
    webVC.title = @"中彩啦";
#elif CS
    webVC.title = @"中彩啦";
#endif
    [self.navigationController pushViewController:webVC animated:YES];
}
- (void)settingConfirm
{
    [self setSettingData];
}
- (void)scrollViewScrollIndex:(NSInteger)index
{
    _currentIndex = index;
    if (index == 1 || index == 2) {
        //设置偏移量
        if (self.dataArray.count > 0) {
            [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
    [self setSettingBar];
    [self setViewShowOrHidden];
    [self setCanBuy];
    [self setBall];
    [self setBallTitle];
}
- (void)ballDidClick:(YZChartBallView *)ballView
{
    NSMutableArray * ballStatuss;
    if (_currentIndex == 1 || _currentIndex == 3)
    {
        ballStatuss = self.redBallStatus;
    }else if (_currentIndex == 2 || _currentIndex == 4)
    {
        ballStatuss = self.blueBallStatus;
    }
    
    YZChartBallStatus * ballStatus = ballStatuss[ballView.tag];
    ballStatus.selected = !ballStatus.selected;//状态取反
    self.chooseBallView.ballStatuss = ballStatuss;
    [self setSelectedNumberBall];
}
- (void)ballViewDidScroll:(CGFloat)offsetX
{
    self.buttomScrollView.mj_offsetX = offsetX;
}
- (void)confirmBuy
{
    NSMutableArray * selectedRedBalls = [NSMutableArray array];
    NSMutableArray * selectedBlueBalls = [NSMutableArray array];
    for (YZChartBallStatus * status in self.redBallStatus) {
        if (status.isSelected) {
            [selectedRedBalls addObject:status.number];
        }
    }
    for (YZChartBallStatus * status in self.blueBallStatus) {
        if (status.isSelected) {
            [selectedBlueBalls addObject:status.number];
        }
    }
    if (self.isDlt) {
        if(selectedRedBalls.count < 5 || selectedBlueBalls.count < 2)
        {//没有一注
            [MBProgressHUD showError:@"红球至少选5个，蓝球至少选2个"];
            return;
        }
        int redComposeCount = [YZMathTool getCountWithN:(int)selectedRedBalls.count andM:5];
        int blueComposeCount = [YZMathTool getCountWithN:(int)selectedBlueBalls.count andM:2];
        int betCount = redComposeCount * blueComposeCount;
        if(betCount * 2 > 20000)
        {
            [MBProgressHUD showError:@"单注金额不能超过2万元"];
            return;
        }
        [self commitlBetWithRedBalls:selectedRedBalls blueBalls:selectedBlueBalls betCount:betCount];
    }else
    {
        if(selectedRedBalls.count < 6 || selectedBlueBalls.count < 1)
        {//没有一注
            [MBProgressHUD showError:@"红球至少选6个，蓝球至少选1个"];
            return;
        }
        int redComposeCount = [YZMathTool getCountWithN:(int)selectedRedBalls.count andM:6];
        int blueComposeCount = (int)selectedBlueBalls.count;
        int betCount = redComposeCount * blueComposeCount;
        if(betCount * 2 > 20000)
        {
            [MBProgressHUD showError:@"单注金额不能超过2万元"];
            return;
        }
        [self commitlBetWithRedBalls:selectedRedBalls blueBalls:selectedBlueBalls betCount:betCount];
    }
    YZBetViewController *bet = [[YZBetViewController alloc] init];//投注控制器
    bet.gameId = self.gameId;
    bet.isChartVC = YES;
    [self.navigationController pushViewController: bet animated:YES];
    
    //清空数据
    for (YZChartBallStatus * status in self.redBallStatus) {
        if (status.isSelected) {
            status.selected = NO;
        }
    }
    for (YZChartBallStatus * status in self.blueBallStatus) {
        if (status.isSelected) {
            status.selected = NO;
        }
    }
    //红球或蓝球
    if (_currentIndex == 1 || _currentIndex == 3)
    {
        self.chooseBallView.ballStatuss = self.redBallStatus;
    }else if (_currentIndex == 2 || _currentIndex == 4)
    {
        self.chooseBallView.ballStatuss = self.blueBallStatus;
    }
    [self setSelectedNumberBall];
}
#pragma mark - 请求数据
//添加计时器
- (void)addSetDeadlineTimer
{
    if(self.getCurrentTermDataTimer == nil)//空才创建
    {
        self.getCurrentTermDataTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(setDeadlineTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.getCurrentTermDataTimer forMode:NSRunLoopCommonModes];
        [self.getCurrentTermDataTimer fire];
    }
}
//获取当前期信息
- (void)getCurrentTermData
{
    if(_nextOpenRemainSeconds > 0) return;
    NSDictionary *dict = @{
                           @"cmd":@(8026),
                           @"gameId":self.gameId
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"%@",json);
        self.currentTermDict = json;
        NSArray *termList = json[@"game"][@"termList"];
        if(termList.count)//当前期次正在销售
        {
            NSString * endTime = [json[@"game"][@"termList"] lastObject][@"endTime"];
            NSString * nextOpenTime = [json[@"game"][@"termList"] lastObject][@"nextOpenTime"];
            NSString * sysTime = json[@"sysTime"];
            //彩种截止时间
            NSDateComponents *deltaDate = [YZDateTool getDeltaDateFromDateString:sysTime fromFormat:@"yyyy-MM-dd HH:mm:ss" toDateString:endTime ToFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDateComponents *nextOpenDeltaDate = [YZDateTool getDeltaDateFromDateString:sysTime fromFormat:@"yyyy-MM-dd HH:mm:ss" toDateString:nextOpenTime ToFormat:@"yyyy-MM-dd HH:mm:ss"];
            _remainSeconds = deltaDate.day * 24 * 60 * 60 + deltaDate.hour * 60 * 60 + deltaDate.minute * 60 + deltaDate.second;
            _nextOpenRemainSeconds = nextOpenDeltaDate.day * 24 * 60 * 60 + nextOpenDeltaDate.hour * 60 * 60 + nextOpenDeltaDate.minute * 60 + nextOpenDeltaDate.second;
            NSString *termId = [json[@"game"][@"termList"] lastObject][@"termId"];
            [self getTrendDataByTermId:termId];
        }else
        {
            self.bottomView.label.text = @"当前期已截止销售";
        }
    } failure:^(NSError *error) {
        YZLog(@"getCurrentTermData - error = %@",error);
    }];
}
//设置时间label
- (void)setDeadlineTime
{
    if(_nextOpenRemainSeconds <= 0 && _remainSeconds <= 0 && ([self.gameId isEqualToString:@"T05"] || [self.gameId isEqualToString:@"T61"] || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"]))
    {
        [self getCurrentTermData];//重新获取所有彩种信息
        return;
    }
    _remainSeconds--;
    _nextOpenRemainSeconds--;
    NSDictionary *json = self.currentTermDict;
    NSString *termId = [json[@"game"][@"termList"] lastObject][@"termId"];
    NSString * nextTermId = [json[@"game"][@"termList"] lastObject][@"nextTermId"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
    NSDateComponents *deltaDate = [YZDateTool getDateComponentsBySeconds:_remainSeconds];
    NSDateComponents *nextOpenDeltaDate = [YZDateTool getDateComponentsBySeconds:_nextOpenRemainSeconds];
    //截取期数
    termId = [termId substringFromIndex:termId.length - 3];
    nextTermId = [nextTermId substringFromIndex:nextTermId.length - 3];
    
    if(_remainSeconds > 0)//当前期正在销售
    {
        NSString * deltaTime;
        deltaTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)deltaDate.hour,(long)deltaDate.minute, (long)deltaDate.second];
        attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距%@期截止:%@",termId,deltaTime]];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:NSMakeRange(8, attStr.length - 8)];
    }else if (_remainSeconds <= 0 && _nextOpenRemainSeconds > 0)//当前期已截止销售,下期还未开始
    {
        NSString * deltaTime;
        deltaTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)nextOpenDeltaDate.hour,(long)nextOpenDeltaDate.minute, (long)nextOpenDeltaDate.second];
        attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"•距%@期开始:%@",nextTermId,deltaTime]];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:NSMakeRange(8, attStr.length - 8)];
    }else//为0的时候，重新刷新数据
    {
        attStr = [[NSMutableAttributedString alloc]initWithString:@"获取新期次中..."];
        _nextOpenRemainSeconds = 0;
    }
    self.bottomView.label.attributedText = attStr;
}
//获取走势图数据
- (void)getTrendDataByTermId:(NSString *)termId
{
    NSDictionary *dict = @{
                           @"gameId":self.gameId,
                           @"issueId":termId
                           };
    [[YZHttpTool shareInstance] postWithURL:[NSString stringWithFormat:@"%@%@",baseUrl,@"/misstrend/getMissNumber"] params:dict success:^(id json) {
        if (SUCCESS) {
            [self setTrendDataByJson:json];
        }
    } failure:^(NSError *error) {
        YZLog(@"getMissNumber - error = %@",error);
    }];
}

- (void)setTrendDataByJson:(id)json
{
    YZChartStatus * chartStatus = [YZChartStatus objectWithKeyValues:json];
    if (!chartStatus) {//没有数据
        return;
    }
    self.chartStatus = chartStatus;
    NSArray * data = [YZChartDataStatus objectArrayWithKeyValuesArray:json[@"data"]];
    chartStatus.data = data;
    [self setColdHotData];
    [self setSettingData];
}
- (void)setColdHotData
{
    YZChartDataStatus * dataStatus = self.chartStatus.data.lastObject;
    
    //红球冷热
    for (int i = 0; i < self.redColdHotStatus.count; i++) {
        YZChartColdHotStatus * status = self.redColdHotStatus[i];
        status.thirty = [self.chartStatus.stats.redstat.stat30.count[i] integerValue];
        status.fifty = [self.chartStatus.stats.redstat.stat50.count[i] integerValue];
        status.hundred = [self.chartStatus.stats.redstat.stat100.count[i] integerValue];
        status.miss = [dataStatus.missNumber[@"redmiss"][i] integerValue];
        if (dataStatus.missNumber[@"redmiss"]) {
            status.have_miss_data = YES;
        }else
        {
            status.have_miss_data = NO;
        }
    }
    //蓝球冷热
    for (int i = 0; i < self.blueColdHotStatus.count; i++) {
        YZChartColdHotStatus * status = self.blueColdHotStatus[i];
        status.thirty = [self.chartStatus.stats.bluestat.stat30.count[i] integerValue];
        status.fifty = [self.chartStatus.stats.bluestat.stat50.count[i] integerValue];
        status.hundred = [self.chartStatus.stats.bluestat.stat100.count[i] integerValue];
        status.miss = [dataStatus.missNumber[@"bluemiss"][i] integerValue];
        if (dataStatus.missNumber[@"bluemiss"]) {
            status.have_miss_data = YES;
        }else
        {
            status.have_miss_data = NO;
        }
    }
    
    //红球数据中的最大值
    NSArray * red_thirty_array = [self.redColdHotStatus valueForKeyPath:@"thirty"];
    NSInteger red_thirty_max = [[red_thirty_array valueForKeyPath:@"@max.intValue"] integerValue];
    NSArray * red_fifty_array = [self.redColdHotStatus valueForKeyPath:@"fifty"];
    NSInteger red_fifty_max = [[red_fifty_array valueForKeyPath:@"@max.intValue"] integerValue];
    NSArray * red_hundred_array = [self.redColdHotStatus valueForKeyPath:@"hundred"];
    NSInteger red_hundred_max = [[red_hundred_array valueForKeyPath:@"@max.intValue"] integerValue];
    NSArray * red_miss_array = [self.redColdHotStatus valueForKeyPath:@"miss"];
    NSInteger red_miss_max = [[red_miss_array valueForKeyPath:@"@max.intValue"] integerValue];
    
    for (YZChartColdHotStatus * coldHotStatus in self.redColdHotStatus) {
        coldHotStatus.max_thirty = NO;
        if (coldHotStatus.thirty == red_thirty_max) {
            coldHotStatus.max_thirty = YES;
        }
        coldHotStatus.max_fifty = NO;
        if (coldHotStatus.fifty == red_fifty_max) {
            coldHotStatus.max_fifty = YES;
        }
        coldHotStatus.max_hundred = NO;
        if (coldHotStatus.hundred  == red_hundred_max) {
            coldHotStatus.max_hundred = YES;
        }
        coldHotStatus.max_miss = NO;
        if (coldHotStatus.miss == red_miss_max) {
            coldHotStatus.max_miss = YES;
        }
    }
    
    //蓝球数据中的最大值
    NSArray * blue_thirty_array = [self.blueColdHotStatus valueForKeyPath:@"thirty"];
    NSInteger blue_thirty_max = [[blue_thirty_array valueForKeyPath:@"@max.intValue"] integerValue];
    NSArray * blue_fifty_array = [self.blueColdHotStatus valueForKeyPath:@"fifty"];
    NSInteger blue_fifty_max = [[blue_fifty_array valueForKeyPath:@"@max.intValue"] integerValue];
    NSArray * blue_hundred_array = [self.blueColdHotStatus valueForKeyPath:@"hundred"];
    NSInteger blue_hundred_max = [[blue_hundred_array valueForKeyPath:@"@max.intValue"] integerValue];
    NSArray * blue_miss_array = [self.blueColdHotStatus valueForKeyPath:@"miss"];
    NSInteger blue_miss_max = [[blue_miss_array valueForKeyPath:@"@max.intValue"] integerValue];
    
    for (YZChartColdHotStatus * coldHotStatus in self.blueColdHotStatus) {
        coldHotStatus.max_thirty = NO;
        if (coldHotStatus.thirty == blue_thirty_max) {
            coldHotStatus.max_thirty = YES;
        }
        coldHotStatus.max_fifty = NO;
        if (coldHotStatus.fifty == blue_fifty_max) {
            coldHotStatus.max_fifty = YES;
        }
        coldHotStatus.max_hundred = NO;
        if (coldHotStatus.hundred == blue_hundred_max) {
            coldHotStatus.max_hundred = YES;
        }
        coldHotStatus.max_miss = NO;
        if (coldHotStatus.miss == blue_miss_max) {
            coldHotStatus.max_miss = YES;
        }
    }
}
- (void)setSettingData
{
    //设置期数数据
    NSString * termCountStr = [YZTool getChartSettingByTitle:@"期数"];
    NSInteger termCount = [[termCountStr substringWithRange:NSMakeRange(1, termCountStr.length - 2)] integerValue];
    termCount = termCount < self.chartStatus.data.count ? termCount : self.chartStatus.data.count;
    NSArray * dataArray = [self.chartStatus.data subarrayWithRange:NSMakeRange(self.chartStatus.data.count - termCount, termCount)];
    self.dataArray = dataArray;
    //设置试图的现实隐藏
    [self setViewShowOrHidden];
    //设置大小
    [self setViewSize];
    //设置排序
    [self setLotterySort];
    //刷新
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
    //设置折线数据
    if (!self.isDlt) {
        self.lineView.statusArray = self.dataArray;
    }
    
    //设置偏移量
    if (self.dataArray.count > 0) {
        [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
#pragma mark - 设置排序
//开奖排序
- (void)lotterySortButtonDidClick:(YZChartSortButton *)button
{
    if (button.sortMode == SortModeAscending) {
        button.sortMode = SortModeDescending;
        [YZTool setChartSettingWithTitle:@"排列" string:@"倒序排列"];
    }else
    {
        button.sortMode = SortModeAscending;
        [YZTool setChartSettingWithTitle:@"排列" string:@"顺序排列"];
    }
    [self setLotterySort];
}
- (void)setLotterySort
{
    BOOL ascending = YES;
    NSString *lotterySortMode = [YZTool getChartSettingByTitle:@"排列"];
    if ([lotterySortMode isEqualToString:@"倒序排列"]) {//降序
        ascending = NO;
        self.lotterySortButton.sortMode = SortModeDescending;
    }else
    {
        self.lotterySortButton.sortMode = SortModeAscending;
    }
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"issue" ascending:ascending];
    self.lotteryStatusArray = [self.dataArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self.lotteryTableView reloadData];
}
//冷热排序
- (void)coldHotSortButtonDidClick:(YZChartSortButton *)button
{
    //先清空其他的
    for (int i = 0; i < self.coldHotSortButtons.count; i++) {
        if (i != button.tag) {
            YZChartSortButton * sortButton = self.coldHotSortButtons[i];
            sortButton.sortMode = SortModeNormal;
        }
    }
    
    //重新赋值
    if (button.tag == 0) {//号码球 正常变降序
        if (button.sortMode == SortModeNormal || button.sortMode == SortModeDescending) {
            button.sortMode = SortModeAscending;
            [[NSUserDefaults standardUserDefaults] setObject:@"ssq_coldHot_number_ascending" forKey:@"ssq_coldHot_sortMode"];
        }else
        {
            button.sortMode = SortModeDescending;
            [[NSUserDefaults standardUserDefaults] setObject:@"ssq_coldHot_number_descending" forKey:@"ssq_coldHot_sortMode"];
        }
    }else//其他 正常变升序
    {
        if (button.sortMode == SortModeNormal || button.sortMode == SortModeAscending) {
            button.sortMode = SortModeDescending;
        }else
        {
            button.sortMode = SortModeAscending;
        }
        
        if (button.tag == 1) {//30期
            if (button.sortMode == SortModeDescending) {
                [[NSUserDefaults standardUserDefaults] setObject:@"ssq_coldHot_stat30_descending" forKey:@"ssq_coldHot_sortMode"];
            }else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"ssq_coldHot_stat30_ascending" forKey:@"ssq_coldHot_sortMode"];
            }
        }if (button.tag == 2) {//50期
            if (button.sortMode == SortModeDescending) {
                [[NSUserDefaults standardUserDefaults] setObject:@"ssq_coldHot_stat50_descending" forKey:@"ssq_coldHot_sortMode"];
            }else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"ssq_coldHot_stat50_ascending" forKey:@"ssq_coldHot_sortMode"];
            }
        }if (button.tag == 3) {//100期
            if (button.sortMode == SortModeDescending) {
                [[NSUserDefaults standardUserDefaults] setObject:@"ssq_coldHot_stat100_descending" forKey:@"ssq_coldHot_sortMode"];
            }else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"ssq_coldHot_stat100_ascending" forKey:@"ssq_coldHot_sortMode"];
            }
        }if (button.tag == 4) {//遗漏
            if (button.sortMode == SortModeDescending) {
                [[NSUserDefaults standardUserDefaults] setObject:@"ssq_coldHot_yilou_descending" forKey:@"ssq_coldHot_sortMode"];
            }else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"ssq_coldHot_yilou_ascending" forKey:@"ssq_coldHot_sortMode"];
            }
        }
    }
    [self setColdHotSort];
}
- (void)setColdHotSort
{
    NSString *coldHotSortMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"ssq_coldHot_sortMode"];
    NSSortDescriptor *sortDescriptor;
    if (YZStringIsEmpty(coldHotSortMode)|| [coldHotSortMode isEqualToString:@"ssq_coldHot_number_ascending"])
    {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:YES];
    }
    else if ([coldHotSortMode isEqualToString:@"ssq_coldHot_number_descending"])
    {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:NO];
    }
    else if ([coldHotSortMode isEqualToString:@"ssq_coldHot_stat30_ascending"])
    {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"thirty" ascending:YES];
    }
    else if ([coldHotSortMode isEqualToString:@"ssq_coldHot_stat30_descending"])
    {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"thirty" ascending:NO];
    }
    else if ([coldHotSortMode isEqualToString:@"ssq_coldHot_stat50_ascending"])
    {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"fifty" ascending:YES];
    }
    else if ([coldHotSortMode isEqualToString:@"ssq_coldHot_stat50_descending"])
    {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"fifty" ascending:NO];
    }
    else if ([coldHotSortMode isEqualToString:@"ssq_coldHot_stat100_ascending"])
    {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"hundred" ascending:YES];
    }else if ([coldHotSortMode isEqualToString:@"ssq_coldHot_stat100_descending"])
    {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"hundred" ascending:NO];
    }
    else if ([coldHotSortMode isEqualToString:@"ssq_coldHot_yilou_ascending"])
    {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"miss" ascending:YES];
    }
    else if ([coldHotSortMode isEqualToString:@"ssq_coldHot_yilou_descending"])
    {
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"miss" ascending:NO];
    }
    self.redColdHotStatus = [self.redColdHotStatus sortedArrayUsingDescriptors:@[sortDescriptor]];
    self.blueColdHotStatus = [self.blueColdHotStatus sortedArrayUsingDescriptors:@[sortDescriptor]];
    [self.coldHotTableView reloadData];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString * tongjiStr = [YZTool getChartSettingByTitle:@"统计"];
    NSInteger tongjiCount = 0;
    if ([tongjiStr isEqualToString:@"显示统计"]) {//显示统计
        tongjiCount = 4;
    }
    if (tableView == self.leftTableView || self.rightTableView == tableView) {//走势
        return self.dataArray.count > 0 ? (self.dataArray.count + tongjiCount) : 0;
    }else if (tableView == self.coldHotTableView)//冷热
    {
        if (_currentIndex == 3) {
            return self.redColdHotStatus.count;
        }else if (_currentIndex == 4)
        {
            return self.blueColdHotStatus.count;
        }
        return 0;
    }
    return self.lotteryStatusArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.lotteryTableView) {
        YZChartSsqLotteryTableViewCell * cell = [YZChartSsqLotteryTableViewCell cellWithTableView:tableView];
        if(indexPath.row % 2 != 0)
        {
            cell.backgroundColor = YZChartBackgroundColor;
        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.isDlt = self.isDlt;
        cell.dataStatus = self.lotteryStatusArray[indexPath.row];
        return cell;
    }else if (tableView == self.leftTableView) {
        YZChartViewLeftTableViewCell * cell = [YZChartViewLeftTableViewCell cellWithTableView:tableView];
        if(indexPath.row % 2 != 0)
        {
            cell.backgroundColor = YZChartBackgroundColor;
        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        if (indexPath.row < self.dataArray.count) {
            cell.dataStatus = self.dataArray[indexPath.row];
        }else if (indexPath.row == self.dataArray.count)
        {
            cell.termIdLabel.textColor = YZColor(97, 0, 135, 1);
            cell.termIdLabel.text = @"出现次数";
        }else if (indexPath.row == self.dataArray.count + 1)
        {
            cell.termIdLabel.textColor = YZColor(47, 100, 0, 1);
            cell.termIdLabel.text = @"平均遗漏";
        }else if (indexPath.row == self.dataArray.count + 2)
        {
            cell.termIdLabel.textColor = YZColor(108, 18, 0, 1);
            cell.termIdLabel.text = @"最大遗漏";
        }else if (indexPath.row == self.dataArray.count + 3)
        {
            cell.termIdLabel.textColor = YZColor(1, 97, 146, 1);
            cell.termIdLabel.text = @"最大连出";
        }
        if (indexPath.row == self.dataArray.count) {
            cell.line.hidden = NO;
        }else
        {
            cell.line.hidden = YES;
        }
        return cell;
    }else if (tableView == self.rightTableView)
    {
        YZChartViewContentTableViewCell * cell = [YZChartViewContentTableViewCell cellWithTableView:tableView];
        if(indexPath.row % 2 != 0)
        {
            cell.backgroundColor = YZChartBackgroundColor;
        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        if (indexPath.row == self.dataArray.count) {
            cell.line.hidden = NO;
        }else
        {
            cell.line.hidden = YES;
        }
        cell.ballNumber = _ballNumber;
        NSString * termCountStr = [YZTool getChartSettingByTitle:@"期数"];
        int termCount = [[termCountStr substringWithRange:NSMakeRange(1, termCountStr.length - 2)] intValue];
        if (indexPath.row < self.dataArray.count) {
            if (_currentIndex == 1) {
                cell.isBlue = NO;
            }else{
                cell.isBlue = YES;
            }
            cell.dataStatus = self.dataArray[indexPath.row];;
        }else
        {
            cell.noDataLabel.hidden = YES;
            BOOL haveEmpty = NO;
            for (YZChartDataStatus *dataStatus in self.dataArray) {
                NSArray * missArray = [NSArray array];
                if (_currentIndex == 2) {
                    missArray = dataStatus.missNumber[@"bluemiss"];
                }else
                {
                    missArray = dataStatus.missNumber[@"redmiss"];
                }
                if (missArray == 0) {
                    haveEmpty = YES;
                }
            }
            YZChartSortStatsStatus *stats;
            if (_currentIndex == 1) {
                if (termCount == 30) {
                    stats = self.chartStatus.stats.redstat.stat30;
                }else if (termCount == 50)
                {
                    stats = self.chartStatus.stats.redstat.stat50;
                }else if (termCount == 100)
                {
                    stats = self.chartStatus.stats.redstat.stat100;
                }else if (termCount == 200)
                {
                    stats = self.chartStatus.stats.redstat.stat200;
                }
            }else if (_currentIndex == 2)
            {
                if (termCount == 30) {
                    stats = self.chartStatus.stats.bluestat.stat30;
                }else if (termCount == 50)
                {
                    stats = self.chartStatus.stats.bluestat.stat50;
                }else if (termCount == 100)
                {
                    stats = self.chartStatus.stats.bluestat.stat100;
                }else if (termCount == 200)
                {
                    stats = self.chartStatus.stats.bluestat.stat200;
                }
            }
            cell.showWaitLottery = YES;
            if (haveEmpty) {
                cell.backgroundColor = [UIColor whiteColor];
                cell.waitLottery = YES;
                if (indexPath.row == self.dataArray.count + 1) {
                    cell.showWaitLottery = YES;
                }else
                {
                    cell.showWaitLottery = NO;
                }
            }else
            {
                if (indexPath.row == self.dataArray.count)
                {
                    cell.textColor = YZColor(97, 0, 135, 1);
                    cell.textArray = stats.count;
                }else if (indexPath.row == self.dataArray.count + 1)
                {
                    cell.textColor = YZColor(47, 100, 0, 1);
                    cell.textArray = stats.avgMiss;
                }else if (indexPath.row == self.dataArray.count + 2)
                {
                    cell.textColor = YZColor(108, 18, 0, 1);
                    cell.textArray = stats.maxMiss;
                }else if (indexPath.row == self.dataArray.count + 3)
                {
                    cell.textColor = YZColor(1, 97, 146, 1);
                    cell.textArray = stats.maxSeries;
                }
            }
        }
        return cell;
    }else if (tableView == self.coldHotTableView)
    {
        YZChartColdHotTableViewCell * cell = [YZChartColdHotTableViewCell cellWithTableView:tableView];
        if(indexPath.row % 2 != 0)
        {
            cell.backgroundColor = YZChartBackgroundColor;
        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        if (_currentIndex == 3) {
            cell.status = self.redColdHotStatus[indexPath.row];
            if (indexPath.row == self.redColdHotStatus.count - 1) {
                cell.line.hidden = NO;
            }else
            {
                cell.line.hidden = YES;
            }
        }else if (_currentIndex == 4)
        {
            cell.status = self.blueColdHotStatus[indexPath.row];
            if (indexPath.row == self.blueColdHotStatus.count - 1) {
                cell.line.hidden = NO;
            }else
            {
                cell.line.hidden = YES;
            }
        }
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return chartCellH;
}
#pragma mark - tableView联动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.leftTableView) {
        self.rightTableView.mj_offsetY = self.leftTableView.mj_offsetY;
    }else if (scrollView == self.buttomScrollView){
        self.ballTitleView.x = chartCellH * 2 - self.buttomScrollView.mj_offsetX;
        self.chooseBallView.scrollView.mj_offsetX = self.buttomScrollView.mj_offsetX;
    }else if (scrollView == self.rightTableView){
        self.leftTableView.mj_offsetY = self.rightTableView.mj_offsetY;
    }
}
#pragma mark - 初始化
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)ballTitleLabels
{
    if (!_ballTitleLabels) {
        _ballTitleLabels = [NSMutableArray array];
    }
    return _ballTitleLabels;
}
- (NSArray *)lotteryStatusArray
{
    if (!_lotteryStatusArray) {
        _lotteryStatusArray = [NSArray array];
    }
    return _lotteryStatusArray;
}
- (NSMutableArray *)redBallStatus
{
    if (!_redBallStatus) {
        _redBallStatus = [NSMutableArray array];
        NSMutableArray * selectedRedBalls = self.selectedBalls[0];
        int number = 33;
        if (self.isDlt) {
            number = 35;
        }
        for (int i = 0; i < number; i++) {
            YZChartBallStatus * status = [[YZChartBallStatus alloc] init];
            status.blue = NO;
            status.selected = NO;
            status.number = [NSString stringWithFormat:@"%02d",i + 1];
            if ([selectedRedBalls containsObject:status.number]) {
                status.selected = YES;
            }
            [_redBallStatus addObject:status];
        }
    }
    return _redBallStatus;
}
- (NSMutableArray *)blueBallStatus
{
    if (!_blueBallStatus) {
        _blueBallStatus = [NSMutableArray array];
        NSMutableArray * selectedBlueBalls = self.selectedBalls[1];
        int number = 16;
        if (self.isDlt) {
            number = 12;
        }
        for (int i = 0; i < number; i++) {
            YZChartBallStatus * status = [[YZChartBallStatus alloc] init];
            status.blue = YES;
            status.selected = NO;
            status.number = [NSString stringWithFormat:@"%02d",i + 1];
            if ([selectedBlueBalls containsObject:status.number]) {
                status.selected = YES;
            }
            [_blueBallStatus addObject:status];
        }
    }
    return _blueBallStatus;
}
- (NSArray *)redColdHotStatus
{
    if (!_redColdHotStatus) {
        NSMutableArray * redColdHotStatus = [NSMutableArray array];
        int number = 33;
        if (self.isDlt) {
            number = 35;
        }
        for (int i = 0; i < number; i++) {
            YZChartColdHotStatus * status = [[YZChartColdHotStatus alloc] init];
            YZChartBallStatus * ballStatus = [[YZChartBallStatus alloc] init];
            ballStatus.blue = NO;
            ballStatus.number = [NSString stringWithFormat:@"%02d",i + 1];
            status.number = [ballStatus.number intValue];
            status.ballStatus = ballStatus;
            [redColdHotStatus addObject:status];
        }
        _redColdHotStatus = [NSArray arrayWithArray:redColdHotStatus];
    }
    return _redColdHotStatus;
}
- (NSArray *)blueColdHotStatus
{
    if (!_blueColdHotStatus) {
        NSMutableArray * blueColdHotStatus = [NSMutableArray array];
        int number = 16;
        if (self.isDlt) {
            number = 12;
        }
        for (int i = 0; i < number; i++) {
            YZChartColdHotStatus * status = [[YZChartColdHotStatus alloc] init];
            YZChartBallStatus * ballStatus = [[YZChartBallStatus alloc] init];
            ballStatus.blue = YES;
            ballStatus.number = [NSString stringWithFormat:@"%02d",i + 1];
            status.number = [ballStatus.number integerValue];
            status.ballStatus = ballStatus;
            [blueColdHotStatus addObject:status];
        }
        _blueColdHotStatus = [NSArray arrayWithArray:blueColdHotStatus];
    }
    return _blueColdHotStatus;
}
- (NSMutableArray *)coldHotSortButtons
{
    if (!_coldHotSortButtons) {
        _coldHotSortButtons = [NSMutableArray array];
    }
    return _coldHotSortButtons;
}
#pragma mark - 提交数据
- (void)commitlBetWithRedBalls:(NSMutableArray *)redBalls blueBalls:(NSMutableArray *)blueBalls betCount:(int)betCount
{
    YZBetStatus *status = [[YZBetStatus alloc] init];
    NSMutableString *str = [NSMutableString string];
    //对球数组排序
    redBalls = [self sortBallsArray:redBalls];
    for(NSString *selectedRedBall in redBalls)
    {
        [str appendFormat:@"%@,",selectedRedBall];
    }
    [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
    [str appendString:@"|"];
    //对球数组排序
    blueBalls = [self sortBallsArray:blueBalls];
    for(NSString *selectedBlueBall in blueBalls)
    {
        [str appendFormat:@"%@,",selectedBlueBall];
    }
    [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
    if(betCount == 1)
    {
        [str appendString:@"[单式1注]"];
    }else
    {
        [str appendString:[NSString stringWithFormat:@"[复式%d注]",betCount]];
    }
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSRange range1 = [str rangeOfString:@"|"];//17
    NSRange range2 = [str rangeOfString:@"["];//20
    NSRange range3 = [str rangeOfString:@"]"];//25
    [attStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:NSMakeRange(0, range1.location)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, 1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(range1.location + 1, blueBalls.count * 3 - 1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range2.location, range3.location - range2.location + 1)];
    status.labelText = attStr;
    status.betCount = betCount;
    CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
    status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
    //存储一组号码数据
    [YZStatusCacheTool saveStatus:status];
    
}
//冒泡排序球数组
- (NSMutableArray *)sortBallsArray:(NSMutableArray *)mutableArray
{
    if(mutableArray.count == 1) return mutableArray;
    for(int i = 0;i < mutableArray.count;i++)
    {
        for(int j = i + 1;j <mutableArray.count;j++)
        {
            NSString *string1 = mutableArray[i];
            NSString *string2 = mutableArray[j];
            if([string1 intValue] > [string2 intValue])
            {
                [mutableArray replaceObjectAtIndex:i withObject:string2];
                [mutableArray replaceObjectAtIndex:j withObject:string1];
            }
        }
    }
    return mutableArray;
}
@end
