//
//  YZWinNumberDetailViewController.m
//  ez
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZWinNumberDetailViewController.h"
#import "YZGameIdViewController.h"
#import "YZWinNumberGradeTableViewCell.h"
#import "YZWinNumberBall.h"
#import "YZTerm.h"
#import "YZGrade.h"
#import "JSON.h"

@interface YZWinNumberDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YZTerm *term;
@property (nonatomic, weak) MJRefreshGifHeader *header;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView * headerView;
@property (nonatomic, weak) UIImageView *lotteryImageView;
@property (nonatomic, weak) UILabel *lotteryPeriodLabel;
@property (nonatomic, weak) UILabel *lotteryTimeLabel;
@property (nonatomic, weak) UIView *lotteryNumberView;

@end

@implementation YZWinNumberDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"开奖详情";
    [self setupChilds];
    waitingView_loadingData;
    [self loadOpenLotteryDetail];
}
- (void)setupChilds
{
    //tableview
    CGFloat betButtonH = 40;
    CGFloat tableViewH = screenHeight - statusBarH - navBarH - 10 * 2 - betButtonH - [YZTool getSafeAreaBottom];
    if (IsBangIPhone) {
        tableViewH = screenHeight - statusBarH - navBarH - 10 - betButtonH - [YZTool getSafeAreaBottom];
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, tableViewH)];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    
    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderData:header];
    self.header = header;
    tableView.mj_header = header;
    
    //headerview
    UIView * headerView = [[UIView alloc]init];
    self.headerView = headerView;
    headerView.backgroundColor = [UIColor whiteColor];
    //1.彩票图片
    UIImageView *lotteryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YZMargin, 15.5, 39, 39)];
    [headerView addSubview:lotteryImageView];
    self.lotteryImageView = lotteryImageView;
    
    //2开奖期数
    UILabel *lotteryPeriodLabel = [[UILabel alloc] init];
    lotteryPeriodLabel.textColor = YZBlackTextColor;
    lotteryPeriodLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [headerView addSubview:lotteryPeriodLabel];
    self.lotteryPeriodLabel = lotteryPeriodLabel;
    
    //3开奖时间
    UILabel *lotteryTimeLabel = [[UILabel alloc] init];
    lotteryTimeLabel.textColor = YZGrayTextColor;
    lotteryTimeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [headerView addSubview:lotteryTimeLabel];
    self.lotteryTimeLabel = lotteryTimeLabel;
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 70, screenWidth, 10)];
    line.backgroundColor = YZBackgroundColor;
    [headerView addSubview:line];
    
    headerView.frame = CGRectMake(0, 0, screenWidth, 80);
    tableView.tableHeaderView = headerView;
    
    //立即投注
    YZBottomButton * betButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    betButton.y = CGRectGetMaxY(tableView.frame) + 10;
    [betButton setTitle:@"立即投注" forState:UIControlStateNormal];
    [betButton addTarget:self action:@selector(betButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:betButton];
}
// 开始进入刷新状态就会调用
- (void)refreshViewBeginRefreshing
{
    [self loadOpenLotteryDetail];
}
#pragma mark - 请求历史开奖数据
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self loadOpenLotteryDetail];
}
- (void)loadOpenLotteryDetail
{
    NSDictionary *dict = @{
                           @"cmd":@(8019),
                           @"gameId":self.gameId,
                           @"termId":self.termId
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            NSMutableDictionary *termDict = [json[@"term"] mutableCopy];
            NSMutableDictionary *detailDict = [termDict[@"details"] JSONValue];
            if (![detailDict isKindOfClass:[NSDictionary class]]) {
                return;
            }
            [termDict setValue:detailDict forKey:@"details"];
            YZTerm *term = [YZTerm objectWithKeyValues:termDict];
            self.term = term;
        }else
        {
            ShowErrorView;
        }
        [self.tableView reloadData];
        [self.header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.tableView reloadData];
        [self.header endRefreshing];
        YZLog(@"开奖error = %@",error);
    }];
}
- (void)setTerm:(YZTerm *)term
{
    _term = term;
#if JG
    //设置图片
    UIImage *lotteryImage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",term.gameId]];
#elif ZC
    //设置图片
    UIImage *lotteryImage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_zc",term.gameId]];
#endif
    self.lotteryImageView.image = lotteryImage;
    
    //设置期次
    NSString *termId = [NSString stringWithFormat:@"%@期",_term.termId];
    self.lotteryPeriodLabel.text = termId;
    CGSize termSize = [self.lotteryPeriodLabel.text sizeWithLabelFont:self.lotteryPeriodLabel.font];
    self.lotteryPeriodLabel.frame = CGRectMake(CGRectGetMaxX(self.lotteryImageView.frame) + YZMargin, 10, termSize.width , 20);
    
    //设置开奖时间
    if (term.openWinTime.length > 16) {
        NSString * time = [term.openWinTime substringToIndex:16];
        self.lotteryTimeLabel.text = time;
    }else
    {
        self.lotteryTimeLabel.text = term.openWinTime;
    }
    CGSize timeSize = [self.lotteryTimeLabel.text sizeWithLabelFont:self.lotteryTimeLabel.font];
    self.lotteryTimeLabel.frame = CGRectMake(screenWidth - timeSize.width - YZMargin, 10, timeSize.width , 20);
    //设置获奖球
    [self.lotteryNumberView removeFromSuperview];
    
    UIView * lotteryNumberView = [[UIView alloc]init];
    self.lotteryNumberView = lotteryNumberView;
    lotteryNumberView.frame = CGRectMake(self.lotteryPeriodLabel.x, CGRectGetMaxY(self.lotteryPeriodLabel.frame) + 5, screenWidth - self.lotteryPeriodLabel.x, 25);
    [self.headerView addSubview:lotteryNumberView];
    
    //开奖号码
    NSString *winNumberStr = [term.winNumber stringByReplacingOccurrencesOfString:@"|" withString:@","];
    NSArray *winNumbers = [winNumberStr componentsSeparatedByString:@","];
    NSMutableArray * lotteryNumberInfos = [NSMutableArray array];
    for (int k = 0; k < winNumbers.count; k++) {
        NSString * winNumber = winNumbers[k];
        YZWinNumberBallStatus * winNumberBallStatus = [[YZWinNumberBallStatus alloc]init];
        winNumberBallStatus.number = winNumber;
        winNumberBallStatus.type = 1;//默认红色
        if (k > (winNumbers.count - [self getBlueBallCount:self.gameId] - 1)) {
            winNumberBallStatus.type = 2;
        }
        if([self.gameId isEqualToString:@"T54"])//四场进球显示绿色
        {
            winNumberBallStatus.type = 3;
        }else if([self.gameId isEqualToString:@"T53"])
        {
             winNumberBallStatus.type = 4;
        }
        [lotteryNumberInfos addObject:winNumberBallStatus];
    }
    
    //号码球的显示
    for (YZWinNumberBallStatus * winNumberBallStatus in lotteryNumberInfos) {
        NSInteger index = [lotteryNumberInfos indexOfObject:winNumberBallStatus];
        YZWinNumberBall * winNumberBall = [[YZWinNumberBall alloc]init];
        if ([self.gameId isEqualToString:@"T53"]) {
            winNumberBall.frame = CGRectMake(16 * index, 0, 15, 25);
        }else
        {
            winNumberBall.frame = CGRectMake(26 * index, 0, 25, 25);
        }
        winNumberBall.status = winNumberBallStatus;
        [lotteryNumberView addSubview:winNumberBall];
    }
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.term.details.grades.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZWinNumberGradeTableViewCell * cell = [YZWinNumberGradeTableViewCell cellWithTableView:tableView];
    if(indexPath.row % 2 == 0)
    {
        cell.backgroundColor = UIColorFromRGB(0xFFE7E7E7);
    }else
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    cell.gameId = self.gameId;
    cell.grade = self.term.details.grades[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 35)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    if ([self.gameId isEqualToString:@"F04"] || [self.gameId isEqualToString:@"T05"] || [self.gameId isEqualToString:@"T61"] || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"]) {//快三和11选5不显示注数
        for (int i = 0; i < 2; i++) {
            UILabel * label = [[UILabel alloc]init];
            label.frame = CGRectMake(screenWidth / 2 * i, 0, screenWidth / 2, 35);
            label.textColor = YZBlackTextColor;
            label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
            label.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:label];
            
            if (i == 0) {
                label.text = @"奖项";
            }else if (i == 1)
            {
                label.text = @"每注奖金(元)";
            }
        }
    }else
    {
        for (int i = 0; i < 3; i++) {
            UILabel * label = [[UILabel alloc]init];
            label.frame = CGRectMake(screenWidth / 3 * i, 0, screenWidth / 3, 35);
            label.textColor = YZBlackTextColor;
            label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
            label.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:label];
            
            if (i == 0) {
                label.text = @"奖项";
            }else if (i == 1)
            {
                label.text = @"中奖注数";
            }else if (i == 2)
            {
                label.text = @"每注奖金(元)";
            }
        }
    }
    return headerView;
}
#pragma mark - 立即投注
- (void)betButtonClick
{
    YZGameIdViewController *destVc = (YZGameIdViewController *)[[[YZTool gameDestClassDict][self.gameId] alloc] initWithGameId:self.gameId];
    [self.navigationController pushViewController:destVc animated:YES];
}
#pragma mark - 工具
- (NSInteger)getBlueBallCount:(NSString *)gameId
{
    NSInteger blueBallCount = 0;
    if([gameId isEqualToString:@"T01"])
    {
        blueBallCount = 2;
    }else if([gameId isEqualToString:@"F01"])
    {
        blueBallCount = 1;
    }else if([gameId isEqualToString:@"F03"])
    {
        blueBallCount = 1;
    }else
    {
        blueBallCount = 0;
    }
    return blueBallCount;
}
@end
