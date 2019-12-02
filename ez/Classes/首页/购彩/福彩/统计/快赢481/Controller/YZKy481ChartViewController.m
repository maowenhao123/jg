//
//  YZKy481ChartViewController.m
//  ez
//
//  Created by dahe on 2019/11/29.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481ChartViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZChartPlayTypeTitleButton.h"
#import "YZKy481ChartRenTableView.h"
#import "YZKy481ChartZhiTableView.h"
#import "YZKy481ChartZuTableView.h"
#import "YZKy481ChartYongTableView.h"
#import "YZChartSettingView.h"
#import "YZKy481ChartPlayTypeView.h"
#import "Ky481ChartHeader.h"
#import "YZDateTool.h"

@interface YZKy481ChartViewController ()<UIScrollViewDelegate, YZChartSettingViewDelegate, YZKy481ChartPlayTypeViewDelegate>
{
    NSInteger _remainSeconds;//本期截止倒计时剩余秒数
    NSInteger _nextOpenRemainSeconds;//下期开奖倒计时剩余秒数
}
@property (nonatomic, weak) YZKy481ChartPlayTypeView * playTypeView;
@property (nonatomic, weak) YZChartSettingView *settingView;//设置
@property (nonatomic, weak) YZChartPlayTypeTitleButton *titleBtn;
@property (nonatomic,weak) UIScrollView *topBackScrollView;
@property (nonatomic, strong) NSMutableArray *topBtns;
@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, weak) UIView *topBtnLine;
@property (nonatomic, weak) UIScrollView *mainScrollView;
@property (nonatomic,weak) YZKy481ChartRenTableView *renTableView;
@property (nonatomic,weak) YZKy481ChartZhiTableView *zhiTableView;
@property (nonatomic,weak) YZKy481ChartZuTableView *zuTableView;
@property (nonatomic, weak) UILabel * timelabel;
@property (nonatomic, assign) int currentIndex;

@property (nonatomic, strong) YZChartStatus * chartStatus;//数据
@property (nonatomic, strong) NSArray * dataArray;//遗漏集合

@property (nonatomic, strong) NSDictionary *currentTermDict;//当前期的字典信息
@property (nonatomic, strong) NSTimer *getCurrentTermDataTimer;

@end

@implementation YZKy481ChartViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //添加倒计时
    [self addSetDeadlineTimer];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //销毁定时器
    [self.getCurrentTermDataTimer invalidate];
    self.getCurrentTermDataTimer = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChilds];
    [self getCurrentTermData];
}

#pragma mark - 请求数据
//获取当前期信息
- (void)getCurrentTermData
{
    if(_nextOpenRemainSeconds > 0) return;
    NSDictionary *dict = @{
        @"cmd":@(8026),
        @"gameId":@"T06"
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
            self.timelabel.text = @"当前期已截止销售";
        }
    } failure:^(NSError *error) {
        YZLog(@"getCurrentTermData - error = %@",error);
    }];
}
//设置时间label
- (void)setDeadlineTime
{
    if(_nextOpenRemainSeconds <= 0 && _remainSeconds <= 0)
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
        attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距%@期开始:%@",nextTermId,deltaTime]];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:NSMakeRange(8, attStr.length - 8)];
    }else//为0的时候，重新刷新数据
    {
        attStr = [[NSMutableAttributedString alloc]initWithString:@"获取新期次中..."];
        _nextOpenRemainSeconds = 0;
    }
    self.timelabel.attributedText = attStr;
}
//获取走势图数据
- (void)getTrendDataByTermId:(NSString *)termId
{
    NSDictionary *dict = @{
        @"gameId":@"T06",
        @"issueId":termId
    };
    [[YZHttpTool shareInstance] postWithURL:[NSString stringWithFormat:@"%@%@",baseUrl,@"/misstrend/getMissNumber"] params:dict success:^(id json) {
        YZLog(@"%@", json);
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
    [self setSettingData];
}

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

#pragma mark - 布局子控件
- (void)setupChilds
{
    //title
    YZChartPlayTypeTitleButton *titleBtn = [[YZChartPlayTypeTitleButton alloc] initWithFrame:CGRectMake(0, 0, 0, 30)];
    self.titleBtn = titleBtn;
    [titleBtn setTitle:@"任选" forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"chart_down_arrow"] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"chart_setting" highIcon:@"chart_setting" target:self action:@selector(setting)];
    
    //选择玩法类型
    YZKy481ChartPlayTypeView * playTypeView = [[YZKy481ChartPlayTypeView alloc] initWithFrame:KEY_WINDOW.bounds selectedPlayTypeBtnTag:self.selectedPlayTypeBtnTag];
    self.playTypeView = playTypeView;
    playTypeView.titleBtn = titleBtn;
    playTypeView.delegate = self;
    [KEY_WINDOW addSubview:playTypeView];
    
    //顶部的view
    UIScrollView *topBackScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, topBtnH)];
    self.topBackScrollView = topBackScrollView;
    topBackScrollView.backgroundColor = [UIColor whiteColor];
    topBackScrollView.showsVerticalScrollIndicator = NO;
    topBackScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:topBackScrollView];
    
    NSArray * topBtnTitles = @[@"综合", @"自由泳", @"仰泳", @"蛙泳", @"蝶泳"];
    CGFloat topBtnW = (topBackScrollView.width - 10) / topBtnTitles.count;
    for(int i = 0; i < topBtnTitles.count; i++)
    {
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topBtn.tag = i;
        [topBtn setTitle:topBtnTitles[i] forState:UIControlStateNormal];
        topBtn.frame = CGRectMake(5 + i * topBtnW, 0, topBtnW, topBtnH - 2);
        topBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        topBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [topBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [topBtn setTitleColor:YZBaseColor forState:UIControlStateSelected];
        [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topBackScrollView addSubview:topBtn];
        [self.topBtns addObject:topBtn];
    }
    //底部线
    UIView * topBtnLine = [[UIView alloc] init];
    self.topBtnLine = topBtnLine;
    topBtnLine.frame = CGRectMake(5 + 5, topBtnH - 2, topBtnW - 5 * 2, 2);
    topBtnLine.backgroundColor = YZBaseColor;
    [topBackScrollView addSubview:topBtnLine];
    
    //统计
    CGFloat bottomViewH = 45;
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
            }else if (self.selectedPlayTypeBtnTag == 6)
            {
                zhiTableView.hidden = NO;
            }else if (self.selectedPlayTypeBtnTag > 6)
            {
                zuTableView.hidden = NO;
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
    
    //时间label
    UILabel * timelabel = [[UILabel alloc] initWithFrame:CGRectMake(YZMargin, CGRectGetMaxY(mainScrollView.frame), screenWidth - 2 * YZMargin, bottomViewH)];
    self.timelabel = timelabel;
    timelabel.text = @"未能获取彩期";
    timelabel.textColor = YZBlackTextColor;
    timelabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    timelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timelabel];
}

//选择玩法
- (void)titleBtnClick:(YZChartPlayTypeTitleButton *)button
{
    [self.playTypeView show];
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

- (void)setting
{
    //设置
    YZChartSettingView * settingView = [[YZChartSettingView alloc] initWithTitleArray:@[@"期数", @"折线", @"遗漏", @"统计"]];
    settingView.delegate = self;
}

- (void)settingGotoHelpVC
{
    YZLoadHtmlFileController * webVC = [[YZLoadHtmlFileController alloc] initWithFileName:@"chart_help_F01_T01.html"];
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

- (void)setSettingData
{
    //设置期数数据
    NSString * termCountStr = [YZTool getChartSettingByTitle:@"期数"];
    NSInteger termCount = [[termCountStr substringWithRange:NSMakeRange(1, termCountStr.length - 2)] integerValue];
    termCount = termCount < self.chartStatus.data.count ? termCount : self.chartStatus.data.count;
    NSArray * dataArray = [self.chartStatus.data subarrayWithRange:NSMakeRange(self.chartStatus.data.count - termCount, termCount)];
    self.dataArray = dataArray;
    
    self.renTableView.dataArray = dataArray;
    for (UIView * subView in self.mainScrollView.subviews) {
        if ([subView isKindOfClass:[YZKy481ChartYongTableView class]]) {
            YZKy481ChartYongTableView *yongTableView = (YZKy481ChartYongTableView *)subView;
            yongTableView.stats = self.chartStatus.stats;
            yongTableView.dataArray = dataArray;
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
    //红线动画
    [UIView animateWithDuration:animateDuration
                     animations:^{
        self.topBtnLine.center = CGPointMake(btn.center.x, self.topBtnLine.center.y);
    }];
    self.currentIndex = (int)btn.tag;
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
