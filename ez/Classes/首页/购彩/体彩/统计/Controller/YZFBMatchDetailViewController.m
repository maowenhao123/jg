//
//  YZFBMatchDetailViewController.m
//  ez
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZFBMatchDetailViewController.h"
#import "YZFBMatchDetailTopView.h"
#import "YZFBMatchDetailMainView.h"
#import "YZFBMatchDetailTeamView.h"
#import "UMMobClick/MobClick.h"

@interface YZFBMatchDetailViewController ()<UIScrollViewDelegate,YZFBMatchDetailMainViewDelegate>
{
    CGFloat _oldContentOffsetY;
    NSInteger _currentIndex;
}
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) YZFBMatchDetailTeamView *teamView;
@property (nonatomic, weak) YZFBMatchDetailTopView *topView;
@property (nonatomic, weak) YZFBMatchDetailMainView * mainView;
@property (nonatomic, weak) MJRefreshGifHeader *header;

@end

@implementation YZFBMatchDetailViewController

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //统计次数
    [MobClick event:@"t51_clickanalyze"];
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = YZBackgroundColor;
    [self setupChildViews];
    [self setupNavigationbar];
    if (@available(iOS 11.0, *)) {
        self.mainView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self getStandingsData];
}
#pragma mark - 布局视图
- (void)setupNavigationbar
{
    UIView *navigationbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)];
    [self.view addSubview:navigationbarView];
    [self.view bringSubviewToFront:self.teamView];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:navigationbarView.bounds];
    imageView.image = [YZTool getFBNavImage];
    [navigationbarView addSubview:imageView];

    //标题
    UILabel * titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"赛事";
    CGSize titleLabelSize = [titleLabel.text sizeWithFont:titleLabel.font maxSize:CGSizeMake(screenWidth, screenHeight)];
    titleLabel.frame = CGRectMake(screenWidth / 2 - titleLabelSize.width / 2, statusBarH + (navBarH - titleLabelSize.height) / 2, titleLabelSize.width, titleLabelSize.height);
    [navigationbarView addSubview:titleLabel];
    
    //返回
    CGFloat padding =  10;
    UIButton * backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(16 - padding, statusBarH + 12 - padding, 11 + 2 * padding, 19 + 2 * padding);
    [backButton setImage:[UIImage imageNamed:@"back_btn_flat"]  forState:UIControlStateNormal];
    //增大点击区域
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(padding, padding, padding, padding)];//这里设置图片和frame外框之间的间隙
    [backButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    [navigationbarView addSubview:backButton];
}
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupChildViews
{
    //主要的滚动视图
    YZFBMatchDetailMainView * mainView = [[YZFBMatchDetailMainView alloc]initWithFrame:CGRectMake(0, statusBarH + navBarH, screenWidth, screenHeight - statusBarH + navBarH)];
    mainView.contentInset = UIEdgeInsetsMake(135, 0 , 0, 0);
    [mainView setContentOffset:CGPointMake(0, -135)];
    self.mainView = mainView;
    mainView.delegate = self;
    mainView.mainViewDelegate = self;
    [self.view addSubview:mainView];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshViewBeginRefreshing)];
    header.ignoredScrollViewContentInsetTop = 135;
    [YZTool setRefreshHeaderData:header];
    self.header = header;
    mainView.mj_header = header;
    
    //顶部的视图
    YZFBMatchDetailTopView *topView = [[YZFBMatchDetailTopView alloc]initWithFrame:CGRectMake(0, statusBarH + navBarH, screenWidth, 135)];
    self.topView = topView;
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    //球队信息的视图
    YZFBMatchDetailTeamView * teamView = [[YZFBMatchDetailTeamView alloc]initWithFrame:CGRectMake(0, statusBarH + navBarH + 5, screenWidth, 80)];
    self.teamView = teamView;
    [self.view addSubview:teamView];
}
- (void)refreshViewBeginRefreshing
{
    if (_currentIndex == 0) {
        self.mainView.standingsView.standingsStatus = nil;
        [self getStandingsData];
    }else if (_currentIndex == 1)
    {
        self.mainView.integralView.integralStatus = nil;
        [self getIntegralStatus];
    }else if (_currentIndex == 2)
    {
        self.mainView.oddsView.oddsStatus = nil;
        [self getOddsStatus];
    }else if (_currentIndex == 3)
    {
        self.mainView.recommendView.recommendRowStatus = nil;
        [self getRecommendStatus];
    }
}
- (void)indexChangeCurrentIndexIsIndex:(NSInteger)index
{
    _currentIndex = index;
    if (_currentIndex == 0) {
        [self getStandingsData];
    }else if (_currentIndex == 1)
    {
        [self getIntegralStatus];
    }else if (_currentIndex == 2)
    {
        [self getOddsStatus];
    }else if (_currentIndex == 3)
    {
        [self getRecommendStatus];
    }
}
#pragma mark - 请求数据
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self indexChangeCurrentIndexIsIndex:_currentIndex];
}
- (void)getStandingsData
{
    if (self.mainView.standingsView.standingsStatus.getData) {
        return;
    }
    [MBProgressHUD showNoBackgroundViewMessage:nil toView:self.mainView.standingsView point:CGPointMake(0, -100)];
    NSDictionary *dict = @{
                           @"roundNum":self.roundNum
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithURL:BaseUrlFootball(@"/getRecord") params:dict success:^(id json) {
        YZLog(@"getRecord - json = %@",json);
        [MBProgressHUD hideHUDForView:self.mainView.standingsView];
        if(SUCCESS)
        {
            YZFBMatchDetailStandingsStatus * standingsStatus = [YZFBMatchDetailStandingsStatus objectWithKeyValues:json];
            self.mainView.standingsView.standingsStatus = standingsStatus;
            //给数组赋值
            NSArray * historyMatches = [YZMatchCellStatus objectArrayWithKeyValuesArray:json[@"history"][@"matches"]];
            self.mainView.standingsView.standingsStatus.history.matches = historyMatches;
            NSArray * homeRecentMatches = [YZMatchCellStatus objectArrayWithKeyValuesArray:json[@"homeRecent"][@"matches"]];
            self.mainView.standingsView.standingsStatus.homeRecent.matches = homeRecentMatches;
            NSArray * awayRecentMatches = [YZMatchCellStatus objectArrayWithKeyValuesArray:json[@"awayRecent"][@"matches"]];
            self.mainView.standingsView.standingsStatus.awayRecent.matches = awayRecentMatches;
            NSArray * homeFuture = [YZMatchFutureStatus objectArrayWithKeyValuesArray:json[@"homeFuture"]];
            self.mainView.standingsView.standingsStatus.homeFuture = homeFuture;
            NSArray * awayFuture = [YZMatchFutureStatus objectArrayWithKeyValuesArray:json[@"awayFuture"]];
            self.mainView.standingsView.standingsStatus.awayFuture = awayFuture;
            //刷新
            [self.mainView.standingsView.tableView reloadData];
            //设置球队信息
            self.topView.round = standingsStatus.round;
            self.teamView.round = standingsStatus.round;
            //结束刷新
            [self.header endRefreshing];
            self.mainView.standingsView.standingsStatus.getData = YES;
        }else
        {
            ShowErrorView
            //结束刷新
            [self.header endRefreshing];
        }
    } failure:^(NSError *error) {
        //结束刷新
        [self.header endRefreshing];
        [MBProgressHUD hideHUDForView:self.mainView.standingsView];
        YZLog(@"getMatchStat - error = %@",error);
    }];
}
- (void)getIntegralStatus
{
    if (self.mainView.integralView.integralStatus) {
        return;
    }
    [MBProgressHUD showNoBackgroundViewMessage:nil toView:self.mainView.integralView point:CGPointMake(0, -100)];
    NSDictionary *dict = @{
                           @"roundNum":self.roundNum
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithURL:BaseUrlFootball(@"/getScore") params:dict success:^(id json) {
        YZLog(@"getScore - json = %@",json);
        [MBProgressHUD hideHUDForView:self.mainView.integralView];
        if(SUCCESS)
        {
            YZFBMatchDetailIntegralStatus * integralStatus = [YZFBMatchDetailIntegralStatus objectWithKeyValues:json];
            
            NSArray * totalScores = [YZScoreRowStatus objectArrayWithKeyValuesArray:json[@"totalScores"]];
            for (YZScoreRowStatus * status in totalScores) {
                status.scores = [YZIntegralStatus objectArrayWithKeyValuesArray:status.scores];
            }
            integralStatus.totalScores = totalScores;
            
            NSArray * homeScores = [YZScoreRowStatus objectArrayWithKeyValuesArray:json[@"homeScores"]];
            for (YZScoreRowStatus * status in homeScores) {
                status.scores = [YZIntegralStatus objectArrayWithKeyValuesArray:status.scores];
            }
            integralStatus.homeScores = homeScores;
            
            NSArray * awayScores = [YZScoreRowStatus objectArrayWithKeyValuesArray:json[@"awayScores"]];
            for (YZScoreRowStatus * status in awayScores) {
                status.scores = [YZIntegralStatus objectArrayWithKeyValuesArray:status.scores];
            }
            integralStatus.awayScores = awayScores;
            
            self.mainView.integralView.integralStatus = integralStatus;
            //刷新
            [self.mainView.integralView.tableView reloadData];
            if (integralStatus.totalScores.count == 0) {//没有数据时
                self.mainView.integralView.noDataLabel.hidden = NO;
            }else
            {
                self.mainView.integralView.noDataLabel.hidden = YES;
            }
            //设置球队信息
            self.topView.round = integralStatus.round;
            self.teamView.round = integralStatus.round;
            //结束刷新
            [self.header endRefreshing];
        }else
        {
            ShowErrorView
            //结束刷新
            [self.header endRefreshing];
        }
    } failure:^(NSError *error) {
        //结束刷新
        [self.header endRefreshing];
        [MBProgressHUD hideHUDForView:self.mainView.integralView];
        YZLog(@"getMatchStat - error = %@",error);
    }];
}
- (void)getOddsStatus
{
    if (self.mainView.oddsView.oddsStatus.getData) {
        return;
    }
    [MBProgressHUD showNoBackgroundViewMessage:nil toView:self.mainView.oddsView point:CGPointMake(0, -100)];
    NSDictionary *dict = @{
                           @"roundNum":self.roundNum
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithURL:BaseUrlFootball(@"/getOdds") params:dict success:^(id json) {
        YZLog(@"getOdds - json = %@",json);
        [MBProgressHUD hideHUDForView:self.mainView.oddsView];
        if(SUCCESS)
        {
            YZFBMatchDetailOddsStatus * oddsStatus = [YZFBMatchDetailOddsStatus objectWithKeyValues:json];
            self.mainView.oddsView.oddsStatus = oddsStatus;
            //给数组赋值
            NSArray * europeOddsCells = [YZEuropeOddsCellStatus objectArrayWithKeyValuesArray:json[@"europeOddsCells"]];
            for (YZOddsCellStatus * oddsCellStatus in europeOddsCells) {
                oddsCellStatus.oddsType = 0;
            }
            self.mainView.oddsView.oddsStatus.europeOddsCells = europeOddsCells;
            
            NSArray * asiaOddsCells = [YZAsiaOddsCellStatus objectArrayWithKeyValuesArray:json[@"asiaOddsCells"]];
            for (YZOddsCellStatus * oddsCellStatus in asiaOddsCells) {
                oddsCellStatus.oddsType = 1;
            }
            self.mainView.oddsView.oddsStatus.asiaOddsCells = asiaOddsCells;
            
            NSArray * overUnderCells = [YZOverUnderCellStatus objectArrayWithKeyValuesArray:json[@"overUnderCells"]];
            for (YZOddsCellStatus * oddsCellStatus in overUnderCells) {
                oddsCellStatus.oddsType = 2;
            }
            self.mainView.oddsView.oddsStatus.overUnderCells = overUnderCells;
            self.mainView.oddsView.roundNum = self.roundNum;
            //刷新
            [self.mainView.oddsView.tableView reloadData];
            //设置球队信息
            self.topView.round = oddsStatus.round;
            self.teamView.round = oddsStatus.round;
            //结束刷新
            [self.header endRefreshing];
            self.mainView.oddsView.oddsStatus.getData = YES;
        }else
        {
            ShowErrorView
            //结束刷新
            [self.header endRefreshing];
        }
    } failure:^(NSError *error) {
        //结束刷新
        [self.header endRefreshing];
        [MBProgressHUD hideHUDForView:self.mainView.oddsView];
        YZLog(@"getMatchStat - error = %@",error);
    }];
}
- (void)getRecommendStatus
{
    if (self.mainView.recommendView.recommendRowStatus) {
        return;
    }
    [MBProgressHUD showNoBackgroundViewMessage:nil toView:self.mainView.recommendView point:CGPointMake(0, -100)];
    NSDictionary *dict = @{
                           @"roundNum":self.roundNum
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithURL:BaseUrlFootball(@"/getRecommend") params:dict success:^(id json) {
        YZLog(@"getRecommend - json = %@",json);
        [MBProgressHUD hideHUDForView:self.mainView.recommendView];
        //结束刷新
        [self.header endRefreshing];
        if(SUCCESS)
        {
            YZFBMatchDetailRecommendStatus * recommendStatus = [YZFBMatchDetailRecommendStatus objectWithKeyValues:json];
            self.mainView.recommendView.recommendRowStatus = recommendStatus.recommendRow;
            //设置球队信息
            self.topView.round = recommendStatus.round;
            self.teamView.round = recommendStatus.round;
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        //结束刷新
        [self.header endRefreshing];
        [MBProgressHUD hideHUDForView:self.mainView.recommendView];
        YZLog(@"getMatchStat - error = %@",error);
    }];
}
#pragma mark - UIScrollViewDelegate
//开始拖拽视图
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == self.mainView) {
        _oldContentOffsetY = scrollView.mj_offsetY + 135;
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mainView) {
        CGFloat offsetY = scrollView.mj_offsetY + 135;
        if (offsetY > _oldContentOffsetY)//向上滚动
        {
            if (offsetY < 135) { //向上移动时子视图不能移动
                self.mainView.standingsView.tableView.mj_offsetY = 0;
                self.mainView.integralView.tableView.mj_offsetY = 0;
                self.mainView.oddsView.tableView.mj_offsetY = 0;
                self.mainView.recommendView.scrollView.mj_offsetY = 0;
            }
        }else if (offsetY <= _oldContentOffsetY)//向下滚动
        {
            if (self.mainView.standingsView.tableView.mj_offsetY != 0 && _currentIndex == 0) {//向下移动时父视图不能移动
                self.mainView.mj_offsetY = 0;
                return;
            }
            if (self.mainView.integralView.tableView.mj_offsetY != 0 && _currentIndex == 1) {//向下移动时父视图不能移动
                self.mainView.mj_offsetY = 0;
                return;
            }
            if (self.mainView.oddsView.tableView.mj_offsetY != 0 && _currentIndex == 2) {//向下移动时父视图不能移动
                self.mainView.mj_offsetY = 0;
                return;
            }
            if (self.mainView.recommendView.scrollView.mj_offsetY != 0 && _currentIndex == 3) {//向下移动时父视图不能移动
                self.mainView.mj_offsetY = 0;
                return;
            }
        }
        
        CGFloat topH = statusBarH + navBarH;
        //移动时的动画
        if (offsetY >= 135) {//最多的偏移量
            self.mainView.mj_offsetY = 0;
        }
        self.topView.y = topH - offsetY;
        
        if (self.teamView.y >= topH + 5)//向下滚动
        {
            self.teamView.y = topH + 5 - offsetY;
        }else
        {
            CGFloat moveScale = offsetY / 100;//移动的比例
            if (moveScale >= 1) {//最多1
                moveScale = 1;
            }
            if (moveScale < 0) {//禁止往下滚动时的动画
                moveScale = 0;
            }
            self.teamView.y = topH + 5 - (64 + 5 - 22) * moveScale;
            self.teamView.scoreLabel.textColor = [UIColor colorWithWhite:moveScale alpha:1];
            CGFloat scale = 1 - moveScale * 0.55;
            self.teamView.transform = CGAffineTransformMakeScale(scale, scale);
            
            self.titleLabel.alpha = 1 - moveScale;
        }
    }
}

@end
