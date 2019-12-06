//
//  YZBaseChartViewController.m
//  ez
//
//  Created by dahe on 2019/12/6.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZBaseChartViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZChartSettingView.h"
#import "YZTitleButton.h"
#import "YZDateTool.h"

@interface YZBaseChartViewController ()<YZChartSettingViewDelegate, YZChartPlayTypeViewDelegate>
{
    NSInteger _remainSeconds;//本期截止倒计时剩余秒数
    NSInteger _nextOpenRemainSeconds;//下期开奖倒计时剩余秒数
}
@property (nonatomic, weak) YZChartPlayTypeView * playTypeView;
@property (nonatomic, weak) YZChartSettingView *settingView;//设置
@property (nonatomic, weak) UILabel * timelabel;

@property (nonatomic, strong) NSDictionary *currentTermDict;//当前期的字典信息
@property (nonatomic, strong) NSTimer *getCurrentTermDataTimer;

@end

@implementation YZBaseChartViewController

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
    waitingView_loadingData
    [self getCurrentTermData];
}

#pragma mark - 请求数据
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
        if (SUCCESS) {
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
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                self.timelabel.text = @"当前期已截止销售";
            }
        }else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"getCurrentTermData - error = %@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
   
    if(_remainSeconds > 0)//当前期正在销售
    {
        NSString * deltaTime;
        deltaTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)deltaDate.hour,(long)deltaDate.minute, (long)deltaDate.second];
        attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距%@期截止:%@",termId,deltaTime]];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:NSMakeRange(13, attStr.length - 13)];
    }else if (_remainSeconds <= 0 && _nextOpenRemainSeconds > 0)//当前期已截止销售,下期还未开始
    {
        NSString * deltaTime;
        deltaTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)nextOpenDeltaDate.hour,(long)nextOpenDeltaDate.minute, (long)nextOpenDeltaDate.second];
        attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距%@期开始:%@",nextTermId,deltaTime]];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:NSMakeRange(13, attStr.length - 13)];
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
        @"gameId":self.gameId,
        @"issueId":termId
    };
    [[YZHttpTool shareInstance] postWithURL:[NSString stringWithFormat:@"%@%@",baseUrl,@"/misstrend/getMissNumber"] params:dict success:^(id json) {
        YZLog(@"%@", json);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (SUCCESS) {
            [self setTrendDataByJson:json];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"getMissNumber - error = %@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    YZTitleButton *titleBtn = [[YZTitleButton alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    self.titleBtn = titleBtn;
    #if JG
        [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    #elif ZC
        [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
    #elif CS
        [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
    #endif
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
    UIBarButtonItem * settingBar = [UIBarButtonItem itemWithIcon:@"chart_setting" highIcon:@"chart_setting" target:self action:@selector(setting)];
    UIBarButtonItem * refreshBar = [UIBarButtonItem itemWithIcon:@"chart_refresh" highIcon:@"chart_refresh" target:self action:@selector(refreshData)];
    self.navigationItem.rightBarButtonItems = @[settingBar, refreshBar];
    
    //选择玩法类型
    YZChartPlayTypeView * playTypeView = [[YZChartPlayTypeView alloc] initWithFrame:KEY_WINDOW.bounds gameId:self.gameId selectedPlayTypeBtnTag:self.selectedPlayTypeBtnTag];
    self.playTypeView = playTypeView;
    playTypeView.titleBtn = titleBtn;
    playTypeView.delegate = self;
    [KEY_WINDOW addSubview:playTypeView];
    
    //时间label
    UILabel * timelabel = [[UILabel alloc] initWithFrame:CGRectMake(YZMargin, screenHeight - statusBarH - navBarH - bottomViewH - [YZTool getSafeAreaBottom], screenWidth - 2 * YZMargin, bottomViewH)];
    self.timelabel = timelabel;
    timelabel.text = @"未能获取彩期";
    timelabel.textColor = YZBlackTextColor;
    timelabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    timelabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:timelabel];
}

//选择玩法
- (void)titleBtnClick:(YZTitleButton *)button
{
    [self.playTypeView show];
}

//子类实现
- (void)playTypeDidClickBtn:(UIButton *)btn
{
    
}

- (void)refreshData
{
    if (!YZDictIsEmpty(self.currentTermDict)) {
        NSDictionary *json = self.currentTermDict;
        NSString *termId = [json[@"game"][@"termList"] lastObject][@"termId"];
        [self getTrendDataByTermId:termId];
    }else
    {
        [self getCurrentTermData];
    }
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
}

@end
