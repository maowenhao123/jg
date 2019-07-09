//
//  YZKsViewController.m
//  ez
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZKsViewController.h"
#import "YZTitleButton.h"
#import "YZKsDiceAnimationView.h"
#import "YZKsPlayTypeView.h"
#import "YZBetViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZKsHistoryTableView.h"
#import "YZKsBottomView.h"
#import "YZKsBaseView.h"
#import "YZKsHezhiView.h"
#import "YZKsSantongView.h"
#import "YZKsErtongView.h"
#import "YZKsSanbutongView.h"
#import "YZKsErbutongView.h"
#import "YZKsDiceView.h"
#import "YZRecentLotteryStatus.h"
#import "YZMathTool.h"
#import "YZCommitTool.h"
#import "YZDateTool.h"

@interface YZKsViewController ()<UIGestureRecognizerDelegate,KsBottomViewDelegate,KsHistoryViewDelegate,KsPlayTypeViewDelegate,KsHezhiViewDelegate,KsSantongViewDelegate,KsSanbutongViewDelegate,KsErtongViewDelegate,KsErbutongViewDelegate>
{
    BOOL _openTitleMenu;//是否打开选择玩法视图
    int _selectedPlayTypeBtnTag;//选中的玩法的tag
    NSInteger _remainSeconds;//本期截止倒计时剩余秒数
    NSInteger _nextOpenRemainSeconds;//下期开奖倒计时剩余秒数
    BOOL _panEnable;//pan手势是否激活
    CGFloat lastTranslationY;
}
@property (nonatomic, weak) YZKsDiceAnimationView * diceAnimationView;//摇骰子的动画
@property (nonatomic, strong) NSDictionary *currentTermDict;//当前期的字典信息
@property (nonatomic, strong) NSTimer *getCurrentTermDataTimer;//倒计时
@property (nonatomic, weak) YZTitleButton *titleBtn;//title按钮
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, weak) UIView *playTypeBackView;//玩法背景view
@property (nonatomic, weak) YZKsPlayTypeView *playTypeView;//玩法视图
@property (nonatomic, weak) UILabel *recentLabel;
@property (nonatomic, weak) UILabel * endTimeLabel;
@property (nonatomic, strong) NSMutableArray *diceViews;
@property (nonatomic, weak) YZKsBottomView *bottomView;
@property (nonatomic, weak) UIView *mainView;
@property (nonatomic, weak) UIView *alphaChangeView;
@property (nonatomic, weak) YZKsHistoryTableView * historyTableView;
@property (nonatomic, weak) YZKsHezhiView * hezhiView;
@property (nonatomic, weak) YZKsSantongView * santongView;
@property (nonatomic, weak) YZKsErtongView * ertongView;
@property (nonatomic, weak) YZKsSanbutongView * sanbutongView;
@property (nonatomic, weak) YZKsErbutongView * erbutongView;
@property (nonatomic, weak) UILabel *promptLabel;
@property (nonatomic, strong) NSMutableArray *allSelNumbersArray;//所有选中的号码对象数组
@property (nonatomic, assign) int betCount;//注数

@end

@implementation YZKsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UINavigationBar *navBar = [UINavigationBar appearance];
    // 设置navBar背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:YZColor(40, 40, 40, 1) WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    //设置颜色
    navBar.tintColor = [UIColor whiteColor];

    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 取出appearance对象
    UINavigationBar *navBar = [UINavigationBar appearance];
#if JG
    //设置颜色
    navBar.tintColor = [UIColor whiteColor];
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:textAttrs];
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:YZBaseColor WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
#elif ZC
    //设置颜色
    navBar.tintColor = YZBlackTextColor;
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = YZBlackTextColor;
    [navBar setTitleTextAttributes:textAttrs];
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
#elif CS
    //设置颜色
    navBar.tintColor = YZBlackTextColor;
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = YZBlackTextColor;
    [navBar setTitleTextAttributes:textAttrs];
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _panEnable = NO;
    //让本控制器支持摇动感应
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    //找出历史选择的玩法
    _selectedPlayTypeBtnTag = [YZUserDefaultTool getIntForKey:@"KsSelectedPlayTypeBtnTag"];
    //布局视图
    [self setupChilds];
    [self setupPlayTypeView];
    
     //获取当前期信息，获得截止时间
     _remainSeconds = 0;
     _nextOpenRemainSeconds = 0;
     [self addSetDeadlineTimer];//倒计时
     [self getCurrentTermData];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefreshCountdownNotification) name:RefreshCountdownNote object:nil];
}

- (void)RefreshCountdownNotification
{
    if (_nextOpenRemainSeconds > 0) {//倒计时运行时才刷新
        self.endTimeLabel.text = @"获取期次中...";
        _remainSeconds = 0;
        _nextOpenRemainSeconds = 0;
        [self getCurrentTermData];
    }
}

- (void)buyCartBtnClick
{
    YZBetViewController *bet = [[YZBetViewController alloc] init];//投注控制器
    bet.gameId = self.gameId;
    bet.selectedPlayTypeBtnTag = _selectedPlayTypeBtnTag;
    [self.navigationController pushViewController: bet animated:YES];
}

- (void)recentOpenLotteryBtnClick
{
    if(self.mainView.y == 30)
    {
        [self openTableViewWithAnimation];
    }else
    {
        [self closeTableViewWithAnimation];
    }
}

#pragma mark - 布局子视图
- (void)setupChilds
{
    //摇筛子的动画视图
    YZKsDiceAnimationView * diceAnimationView = [[YZKsDiceAnimationView alloc]initWithFrame:KEY_WINDOW.bounds];
    self.diceAnimationView = diceAnimationView;
    diceAnimationView.hidden = YES;
    [KEY_WINDOW addSubview:diceAnimationView];
    //titleBtn
    YZTitleButton *titleBtn = [[YZTitleButton alloc] initWithFrame:CGRectMake(0, 12, 0, 20)];
    self.titleBtn = titleBtn;
    [titleBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [titleBtn setTitle:self.titles[_selectedPlayTypeBtnTag] forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
    //顶部视图
    CGFloat topViewH = 30;
    UIImageView * topView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, topViewH)];
    topView.image = [UIImage imageNamed:@"ks_bg"];
    [self.view addSubview:topView];
    
    UIView * coverView1 = [[UIView alloc]initWithFrame:topView.bounds];
    coverView1.backgroundColor = YZColor(3, 36, 21, 0.33);
    [topView addSubview:coverView1];
    
    UILabel * recentLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 70, topViewH)];
    self.recentLabel = recentLabel;
    recentLabel.textColor = YZColor(218, 218, 218, 1);
    recentLabel.font = [UIFont systemFontOfSize:13];
    [topView addSubview:recentLabel];
    
    CGFloat diceViewY = 4;
    CGFloat diceViewWH = topViewH - 2 * diceViewY;
    UIView * lastDiceView;
    for (int i = 0; i < 3; i++) {
        CGFloat diceViewX = CGRectGetMaxX(recentLabel.frame) + i * (diceViewWH + 5);
        YZKsDiceView * diceView = [[YZKsDiceView alloc]initWithFrame:CGRectMake(diceViewX, diceViewY, diceViewWH, diceViewWH)];
        [topView addSubview:diceView];
        lastDiceView = diceView;
        [self.diceViews addObject:diceView];
    }
    
    //倒计时
    CGFloat endTimeLabelX = CGRectGetMaxX(lastDiceView.frame);
    UILabel * endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(endTimeLabelX, 0, screenWidth - endTimeLabelX - 5, topViewH)];
    self.endTimeLabel = endTimeLabel;
    endTimeLabel.textAlignment = NSTextAlignmentRight;
    endTimeLabel.font = [UIFont systemFontOfSize:13];
    endTimeLabel.textColor = YZColor(218, 218, 218, 1);
    endTimeLabel.text = @"未能获取当前期号";
    [topView addSubview:endTimeLabel];
    
    //历史中奖号码
    YZKsHistoryTableView * historyTableView = [[YZKsHistoryTableView alloc]initWithFrame:CGRectMake(0, 30, screenWidth, 275)];
    self.historyTableView = historyTableView;
    historyTableView.historyDelegate = self;
    [self.view addSubview:historyTableView];
    
    [self addPanGestureToView:historyTableView];
    
    UIView *alphaChangeView = [[UIView alloc] init];
    self.alphaChangeView = alphaChangeView;
    alphaChangeView.userInteractionEnabled = NO;
    alphaChangeView.frame = historyTableView.frame;
    [self.view insertSubview:alphaChangeView aboveSubview:historyTableView];
    
    //选择号码视图
    CGFloat bottomViewH = 49 + [YZTool getSafeAreaBottom];
    UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0, topViewH, screenWidth, screenHeight - navBarH - statusBarH - topViewH)];
    self.mainView = mainView;
    mainView.backgroundColor = [UIColor lightGrayColor];
    [self.view insertSubview:mainView aboveSubview:alphaChangeView];
    [self.view bringSubviewToFront:topView];
    
    //加阴影
    mainView.clipsToBounds = NO;
    mainView.layer.shadowColor = [UIColor blackColor].CGColor;
    mainView.layer.shadowOffset = CGSizeMake(0, -2);
    mainView.layer.shadowRadius = 5;
    mainView.layer.shadowOpacity = 1;
    
    [self addPanGestureToView:mainView];

    //摇一摇机选
    CGFloat autoChooseViewH = 25;
    UIImageView * autoChooseView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, autoChooseViewH)];
    autoChooseView.image = [UIImage imageNamed:@"ks_bg"];
    [mainView addSubview:autoChooseView];
    
    UIView * coverView2 = [[UIView alloc]initWithFrame:autoChooseView.bounds];
    coverView2.backgroundColor = YZColor(3, 36, 21, 0.33);
    [autoChooseView addSubview:coverView2];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    line.backgroundColor = YZColor(46, 77, 55, 1);
    [autoChooseView addSubview:line];
    
    //机选图片
    UIImageView *autoChooseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"autoChoose"]];
    autoChooseImageView.frame = CGRectMake(5, 1, 20, 23);
    [autoChooseView addSubview:autoChooseImageView];
    
    //机选文字
    UILabel *autoChooseLabel = [[UILabel alloc] init];
    autoChooseLabel.backgroundColor = [UIColor clearColor];
    autoChooseLabel.text = @"摇一摇机选";
    autoChooseLabel.textColor = YZColor(183, 183, 183, 1);
    autoChooseLabel.font = [UIFont systemFontOfSize:13];
    CGSize autoChooseLabelSize = [autoChooseLabel.text sizeWithFont:autoChooseLabel.font maxSize:CGSizeMake(screenWidth, screenHeight)];
    CGFloat autoChooseLabelW = autoChooseLabelSize.width;
    CGFloat autoChooseLabelH = autoChooseLabelSize.height;
    autoChooseLabel.frame = CGRectMake(CGRectGetMaxX(autoChooseImageView.frame) + 5, 0, autoChooseLabelW, autoChooseLabelH);
    autoChooseLabel.center = CGPointMake(autoChooseLabel.center.x, autoChooseImageView.center.y);
    [autoChooseView addSubview:autoChooseLabel];
    
    //选择号码视图
    YZKsHezhiView * hezhiView = [[YZKsHezhiView alloc]initWithFrame:CGRectMake(0, 25, screenWidth, mainView.height)];
    self.hezhiView = hezhiView;
    hezhiView.hezhiDelegate = self;
    [mainView addSubview:hezhiView];
    
    YZKsSantongView * santongView = [[YZKsSantongView alloc]initWithFrame:CGRectMake(0, 25, screenWidth, mainView.height)];
    self.santongView = santongView;
    santongView.santongDelegate = self;
    [mainView addSubview:santongView];
    
    YZKsErtongView * ertongView = [[YZKsErtongView alloc]initWithFrame:CGRectMake(0, 25, screenWidth, mainView.height)];
    self.ertongView = ertongView;
    ertongView.ertongDelegate = self;
    [mainView addSubview:ertongView];
    
    YZKsSanbutongView * sanbutongView = [[YZKsSanbutongView alloc]initWithFrame:CGRectMake(0, 25, screenWidth, mainView.height)];
    self.sanbutongView = sanbutongView;
    sanbutongView.sanbutongDelegate = self;
    [mainView addSubview:sanbutongView];
    
    YZKsErbutongView * erbutongView = [[YZKsErbutongView alloc]initWithFrame:CGRectMake(0, 25, screenWidth, mainView.height)];
    self.erbutongView = erbutongView;
    erbutongView.erbutongDelegate = self;
    [mainView addSubview:erbutongView];
    
    [self setMainViewShow];
    
    //底栏
    CGFloat bottomViewY = screenHeight - statusBarH - navBarH - bottomViewH;
    YZKsBottomView *bottomView = [[YZKsBottomView alloc] initWithFrame:CGRectMake(0, bottomViewY, screenWidth, bottomViewH)];
    self.bottomView = bottomView;
    bottomView.delegate = self;
    [self.view addSubview:bottomView];
    
    //下面提示的label
    UILabel *promptLabel = [[UILabel alloc] init];
    self.promptLabel = promptLabel;
    promptLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.4];
    promptLabel.font = [UIFont systemFontOfSize:13];
    promptLabel.textColor = [UIColor whiteColor];
    self.promptLabel.frame = CGRectMake(0, self.bottomView.y, screenWidth, 25);
    [self.view insertSubview:promptLabel belowSubview:bottomView];
}
- (void)historyViewRecentStatus:(NSArray *)recentStatus
{
    if (recentStatus.count > 0) {
        _panEnable = YES;
        self.historyTableView.height = (recentStatus.count + 1) * 25;
        YZRecentLotteryStatus * status = [recentStatus firstObject];
        self.recentLabel.text = [NSString stringWithFormat:@"%@期开奖：",[status.termId substringFromIndex:status.termId.length - 2]];
        
        NSMutableArray * winNumbers = [NSMutableArray arrayWithArray:[status.winNumber componentsSeparatedByString:@","]];
        if (winNumbers.count < 3) return;
        NSMutableArray * winNumbers_ = [self sortBallsArray:winNumbers];
        for (YZKsDiceView * diceView in self.diceViews) {
            int index = (int)[self.diceViews indexOfObject:diceView];
            [diceView setNumber:[winNumbers_[index] intValue] count:index + 1];
        }
    }
}
- (void)addPanGestureToView:(UIView *)view
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewPan:)];
    pan.delegate = self;
    [view addGestureRecognizer:pan];
}
#pragma mark - 标题
- (void)titleBtnClick:(YZTitleButton *)btn
{
    [self closeTableViewWithAnimation];
    _openTitleMenu = !_openTitleMenu;
    //三角动画
    [UIView animateWithDuration:animateDuration animations:^{
        if(_openTitleMenu)
        {
            btn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        }else
        {
            btn.imageView.transform = CGAffineTransformIdentity;
        }
    }];
    //选择玩法的视图
    if (_openTitleMenu) {
        self.playTypeBackView.hidden = NO;
    }
    [UIView animateWithDuration:animateDuration animations:^{
        if (_openTitleMenu) {
            self.playTypeView.height = 200;
        }else
        {
            self.playTypeView.height = 0;
        }
    }completion:^(BOOL finished) {
        if (!_openTitleMenu) {
            self.playTypeBackView.hidden = YES;
        }
    }];
}
- (void)setupPlayTypeView
{
    //底部背景遮盖
    UIView *playTypeBackView = [[UIView alloc] init];
    playTypeBackView.hidden = YES;
    self.playTypeBackView = playTypeBackView;
    playTypeBackView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePlayTypeBackView)];
    [playTypeBackView addGestureRecognizer:tap];
    tap.delegate = self;
    [self.navigationController.view addSubview:playTypeBackView];
    
    //玩法view
    YZKsPlayTypeView *playTypeView = [[YZKsPlayTypeView alloc] initWithFrame:CGRectMake(0, statusBarH + navBarH, screenWidth, 0)];
    self.playTypeView = playTypeView;
    playTypeView.layer.masksToBounds = YES;
    playTypeView.delegate = self;
    [playTypeBackView addSubview:playTypeView];
}
- (void)closePlayTypeBackView
{
    [UIView animateWithDuration:animateDuration animations:^{
        self.titleBtn.imageView.transform = CGAffineTransformIdentity;
    }];
    //选择玩法的视图
    [UIView animateWithDuration:animateDuration animations:^{
        self.playTypeView.height = 0;
    }completion:^(BOOL finished) {
        self.playTypeBackView.hidden = YES;
        _openTitleMenu = NO;
    }];
}
- (void)KsPlayTypeViewButttonClick:(UIButton *)button
{
    [self bottomViewDeleteBtnClick];
    _selectedPlayTypeBtnTag = (int)button.tag;
    [self.titleBtn setTitle:self.titles[_selectedPlayTypeBtnTag] forState:UIControlStateNormal];
    [self closePlayTypeBackView];
    [self setMainViewShow];
    [self.historyTableView reloadData];
    [self computeAmountMoney];
}
- (void)setMainViewShow
{
    if (_selectedPlayTypeBtnTag == 0) {
        [self.mainView bringSubviewToFront:self.hezhiView];
    }else if (_selectedPlayTypeBtnTag == 1)
    {
        [self.mainView bringSubviewToFront:self.santongView];
    }else if (_selectedPlayTypeBtnTag == 2)
    {
        [self.mainView bringSubviewToFront:self.ertongView];
    }else if (_selectedPlayTypeBtnTag == 3)
    {
        [self.mainView bringSubviewToFront:self.sanbutongView];
    }else if (_selectedPlayTypeBtnTag == 4)
    {
        [self.mainView bringSubviewToFront:self.erbutongView];
    }
}
#pragma mark - 选择号码的协议
- (void)hezhiViewSelectedButttons:(NSMutableArray *)selectedButttons
{
    [self numberClickWithSelectedButttons:selectedButttons];
}
- (void)santongViewSelectedButttons:(NSMutableArray *)selectedButttons
{
    [self numberClickWithSelectedButttons:selectedButttons];
}
- (void)ertongViewSelectedButttons:(NSMutableArray *)selectedButttons
{
    [self numberClickWithSelectedButttons:selectedButttons];
}
- (void)sanbutongViewSelectedButttons:(NSMutableArray *)selectedButttons
{
    [self numberClickWithSelectedButttons:selectedButttons];
}
- (void)erbutongViewSelectedButttons:(NSMutableArray *)selectedButttons
{
    [self numberClickWithSelectedButttons:selectedButttons];
}
- (void)numberClickWithSelectedButttons:(NSMutableArray *)selectedButttons
{
    int tag = _selectedPlayTypeBtnTag;
    NSMutableArray *statusArray = self.allSelNumbersArray[tag];
    statusArray = selectedButttons;
    self.allSelNumbersArray[tag] = statusArray;
    [self computeAmountMoney];
}
#pragma mark - 底部按钮点击
- (void)bottomViewDeleteBtnClick
{
    int tag = _selectedPlayTypeBtnTag;
    if (tag == 2)
    {
        for (NSMutableArray * muArr in self.allSelNumbersArray[tag]) {
            [muArr removeAllObjects];
        }
    }else
    {
        [self.allSelNumbersArray[tag] removeAllObjects];
    }
    
    [self computeAmountMoney];
    if (tag == 0) {
        [self.hezhiView deleteAllSelectedNumbersState];
    }else if (tag == 1)
    {
        [self.santongView deleteAllSelectedNumbersState];
    }else if (tag == 2)
    {
        [self.ertongView deleteAllSelectedNumbersState];
    }else if (tag == 3)
    {
        [self.sanbutongView deleteAllSelectedNumbersState];
    }else if (tag == 4)
    {
        [self.erbutongView deleteAllSelectedNumbersState];
    }
}
- (void)bottomViewConfirmBtnClick
{
    int tag = _selectedPlayTypeBtnTag;
    NSMutableArray *statusArray = self.allSelNumbersArray[tag];
    //把信息存入数据库
    [YZCommitTool commitKsBetWithNumbers:statusArray selectedPlayTypeBtnTag:tag];
   
    if (self.betCount < 1) {
        [MBProgressHUD showError:@"请至少选择一注"];
    }
    if ([YZStatusCacheTool getStatues].count > 0) {
        YZBetViewController *bet = [[YZBetViewController alloc] init];//投注控制器
        bet.gameId = self.gameId;
        bet.selectedPlayTypeBtnTag = _selectedPlayTypeBtnTag;
        [self.navigationController pushViewController: bet animated:YES];
    }
    //删除所有的
    [self bottomViewDeleteBtnClick];
}
#pragma mark - 查看历史开奖号码
- (void)tableViewPan:(UIPanGestureRecognizer *)pan
{
    if(!_panEnable) return;
    UIView *mainView = self.mainView;
    CGFloat endTimeBgMaxY = 30;
    CGPoint translation = [pan translationInView:mainView];
    CGFloat endY = self.historyTableView.height + 30;
    if(pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged)
    {
        if(((mainView.y+ translation.y) > endTimeBgMaxY)|| (translation.y < 0 && mainView.y > endTimeBgMaxY) || (translation.y > 0 && mainView.y < endY))//向上且y值大于endTimeBg的最大Y值，或者，向下且y值小于下面固定的某一值
        {
            [mainView setCenter:CGPointMake(mainView.center.x, mainView.center.y + translation.y)];
            [pan setTranslation:CGPointZero inView:mainView];
        }
        if(translation.y < 0 && mainView.y < endTimeBgMaxY)//向上且y值小于endTimeBg的最大Y值
        {
            mainView.y = endTimeBgMaxY;
        }else if(translation.y > 0 && mainView.y > endY)//向下且y值大于下面固定的某一值
        {
            mainView.y = endY;
        }
        lastTranslationY = translation.y;
    }

    if(pan.state == UIGestureRecognizerStateEnded)
    {
        [UIView beginAnimations:@"panTableview" context:nil];
        [UIView setAnimationDuration:animateDuration];
        if(lastTranslationY > 2)//有向下滑的趋势
        {
            mainView.y = endY;
        }else if (lastTranslationY < -2)//有向上滑的趋势
        {
            mainView.y = endTimeBgMaxY;
        }else//无趋势
        {
            if(mainView.y < endTimeBgMaxY)//tableview在endTimeBg上面了就归位
            {
                mainView.y = endTimeBgMaxY;
            }
            if(mainView.y <= endTimeBgMaxY + self.historyTableView.height / 2)//y值中间的一半以内，也归位
            {
                mainView.y = endTimeBgMaxY;
            }
            if(mainView.y >= endTimeBgMaxY + self.historyTableView.height / 2)//y值中间的一半以外，下去
            {
                mainView.y = endY;
            }
            if(mainView.y > self.bottomView.y)//y值大于下面一栏的y值就归位下去
            {
                mainView.y = endY;
            }
        }
        [UIView commitAnimations];
    }else if (pan.state == UIGestureRecognizerStateCancelled)
    {
        [UIView animateWithDuration:animateDuration animations:^{
            
            mainView.y = endTimeBgMaxY;
        }];
    }
    //设置透明度
    CGFloat layerScale = (mainView.y - 30) / (endY - 30);
    self.alphaChangeView.layer.backgroundColor = YZColor(0, 0, 0, 0.7*(1 - layerScale)).CGColor;
}
- (void)openTableViewWithAnimation
{
    if(!_panEnable) return;
    if(self.mainView.y == 30)
    {
        self.alphaChangeView.layer.backgroundColor = YZColor(0, 0, 0, 0.7).CGColor;
        [UIView animateWithDuration:animateDuration animations:^{
            self.alphaChangeView.layer.backgroundColor = YZColor(0, 0, 0, 0).CGColor;
            self.mainView.y = self.historyTableView.height + 30;
        }];
    }
}
- (void)closeTableViewWithAnimation
{
    if(self.mainView.y != 30)
    {
        self.alphaChangeView.layer.backgroundColor = YZColor(0, 0, 0, 0).CGColor;
        [UIView animateWithDuration:animateDuration animations:^{
            self.alphaChangeView.layer.backgroundColor = YZColor(0, 0, 0, 0.7).CGColor;
            self.mainView.y = 30;
        }];
    }
}
#pragma mark - 计算注数和金额
- (void)computeAmountMoney
{
    int tag = _selectedPlayTypeBtnTag;
    NSMutableArray *statusArray = self.allSelNumbersArray[tag];
    if (tag == 0 || tag == 1) {
        self.betCount = (int)statusArray.count;
    }else if (tag == 2)
    {
        NSArray * btns1 = statusArray[0];
        NSArray * btns2 = statusArray[1];
        NSArray * btns3 = statusArray[2];
        if (btns1.count == 0 || btns2.count == 0) {
            self.betCount = (int)btns3.count;
        }
        self.betCount = (int)(btns1.count * btns2.count + btns3.count);
    }else if (tag == 3)
    {
        if ([statusArray containsObject:@(6)]) {
            self.betCount = [YZMathTool getCountWithN:(int)statusArray.count - 1 andM:3] + 1;
        }else
        {
            self.betCount = [YZMathTool getCountWithN:(int)statusArray.count andM:3];
        }
    }else if (tag == 4)
    {
        self.betCount = [YZMathTool getCountWithN:(int)statusArray.count andM:2];
    }else
    {
        self.betCount = 0;
    }
    if(self.betCount > 0)
    {
        [self setPromptLabelText];
        [UIView animateWithDuration:animateDuration
                         animations:^{
                             self.promptLabel.y = self.bottomView.y - self.promptLabel.height;
                         }];
    }else
    {
        [UIView animateWithDuration:animateDuration
                         animations:^{
                             self.promptLabel.y = self.bottomView.y;
                         }];
    }
}
//设置注数
- (void)setBetCount:(int)betCount
{
    _betCount = betCount;
    [self.bottomView setBetCount:betCount];
}
#pragma mark - 设置下面提示label的文字
- (void)setPromptLabelText
{
    int tag = _selectedPlayTypeBtnTag;
    NSMutableArray *statusArray = self.allSelNumbersArray[tag];
    NSRange prize = [YZMathTool getKsPrizeWithTag:tag selectNumbers:statusArray];
    
    int minPrize = (int)prize.location;
    int maxPrize = (int)prize.length;
    int minProfit = minPrize - self.betCount * 2;
    int maxProfit = maxPrize - self.betCount * 2;
    UIColor * color = YZColor(254, 210, 90, 1);
    if (minPrize == maxPrize) {
        NSString *text = [NSString stringWithFormat:@"  若中奖：奖金%d元，盈利%d元",minPrize,minProfit];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange jinRange = [text rangeOfString:@"金"];
        NSRange yuanRange = [text rangeOfString:@"元"];
        NSRange liRange = [text rangeOfString:@"利"];
        NSRange douRange = [text rangeOfString:@"，"];
        NSRange subRange = NSMakeRange(douRange.location, text.length-douRange.location);
        NSRange yuan1Range = [text rangeOfString:@"元" options:0 range:subRange];
        
        [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(jinRange.location+1, yuanRange.location-jinRange.location-1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(liRange.location+1, yuan1Range.location-liRange.location-1)];
        self.promptLabel.attributedText = attStr;

    }else
    {
        NSString *text = [NSString stringWithFormat:@"  若中奖：奖金%d至%d元，盈利%d至%d元",minPrize,maxPrize,minProfit,maxProfit];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange jinRange = [text rangeOfString:@"金"];
        NSRange zhiRange = [text rangeOfString:@"至"];
        NSRange yuanRange = [text rangeOfString:@"元"];
        NSRange liRange = [text rangeOfString:@"利"];
        NSRange douRange = [text rangeOfString:@"，"];
        NSRange subRange = NSMakeRange(douRange.location, text.length-douRange.location);
        NSRange zhi1Range = [text rangeOfString:@"至" options:0 range:subRange];
        NSRange yuan1Range = [text rangeOfString:@"元" options:0 range:subRange];
        
        [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(jinRange.location+1, zhiRange.location-jinRange.location-1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(zhiRange.location+1, yuanRange.location-zhiRange.location-1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(liRange.location+1, zhi1Range.location-liRange.location-1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(zhi1Range.location+1, yuan1Range.location-zhi1Range.location-1)];
        
        self.promptLabel.attributedText = attStr;
    }
}
#pragma mark - 摇一摇机选
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSString * allowShake = [YZUserDefaultTool getObjectForKey:@"allowShake"];
    if ([allowShake isEqualToString:@"0"]) return;
    
    if (self.diceAnimationView.isAnimating) return;//如果当前正在进行动画 就return
    
//    [self closeMenuBackView];
    [self closePlayTypeBackView];
    [self closeTableViewWithAnimation];
    //删除已选的
    [self bottomViewDeleteBtnClick];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
    
    self.diceAnimationView.hidden = NO;
 
    int tag = _selectedPlayTypeBtnTag;
    if (tag == 0) {//和值
        [self.diceAnimationView startDiceAnimationWithPlayType:tag showView:self.hezhiView];
    }else if (tag == 1)//三同号
    {
        [self.diceAnimationView startDiceAnimationWithPlayType:tag showView:self.santongView];
    }else if (tag == 2)//二同
    {
        [self.diceAnimationView startDiceAnimationWithPlayType:tag showView:self.ertongView];
    }else if (tag == 3)//三不同
    {
        [self.diceAnimationView startDiceAnimationWithPlayType:tag showView:self.sanbutongView];
    }else if (tag == 4)//二不同
    {
        [self.diceAnimationView startDiceAnimationWithPlayType:tag showView:self.erbutongView];
    }
}
#pragma mark - UIGestureRecognizerDelegate
//支持多手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return  YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint pos = [touch locationInView:self.playTypeView.superview];
        if (CGRectContainsPoint(self.playTypeView.frame, pos)) {
            return NO;
        }
    }
    return YES;
}
#pragma mark - 获取当前期信息
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
            }else
            {
                self.endTimeLabel.text = @"当前期已截止销售";
            }
        }
    } failure:^(NSError *error) {
        YZLog(@"%@",error);
    }];
}
- (void)addSetDeadlineTimer
{
    if(self.getCurrentTermDataTimer == nil)//空才创建
    {
        self.getCurrentTermDataTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(setDeadlineTime) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.getCurrentTermDataTimer forMode:NSRunLoopCommonModes];
        [self.getCurrentTermDataTimer fire];
    }
}
#pragma mark - 设置时间label
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
    NSString * termId = [json[@"game"][@"termList"] lastObject][@"termId"];
    NSString * nextTermId = [json[@"game"][@"termList"] lastObject][@"nextTermId"];
    //截取期数
    termId = [termId substringFromIndex:termId.length - 2];
    nextTermId = [nextTermId substringFromIndex:nextTermId.length - 2];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]init];
    NSDateComponents *deltaDate = [YZDateTool getDateComponentsBySeconds:_remainSeconds];
    NSDateComponents *nextOpenDeltaDate = [YZDateTool getDateComponentsBySeconds:_nextOpenRemainSeconds];
    if(_remainSeconds > 0)//当前期正在销售
    {
        NSString * deltaTime = [NSString stringWithFormat:@"%ld分%ld秒", (long)deltaDate.minute, (long)deltaDate.second];
        attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距%@期截止:%@",termId,deltaTime]];
    }else if (_remainSeconds <= 0 && _nextOpenRemainSeconds > 0)//当前期已截止销售,下期还未开始
    {
        NSString * deltaTime = [NSString stringWithFormat:@"%ld分%ld秒", (long)nextOpenDeltaDate.minute, (long)nextOpenDeltaDate.second];
        attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"距%@期开始:%@",nextTermId,deltaTime]];
    }else//为0的时候，重新刷新数据
    {
        attStr = [[NSMutableAttributedString alloc]initWithString:@"获取新期次中..."];
        _nextOpenRemainSeconds = 0;
    }
    NSRange qiRange = [[attStr string] rangeOfString:@":"];
    NSRange fenRange = [[attStr string] rangeOfString:@"分"];
    NSRange miaoRange = [[attStr string] rangeOfString:@"秒"];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZColor(218, 218, 218, 1) range:NSMakeRange(0, attStr.length)];
    if (fenRange.location != NSNotFound)//分、秒
    {
        UIColor * color  = YZColor(254, 210, 90, 1);
        [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(qiRange.location+1, fenRange.location-qiRange.location-1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(fenRange.location+1, miaoRange.location-fenRange.location-1)];
    }
    self.endTimeLabel.attributedText = attStr;
}
#pragma mark - 初始化
- (NSArray *)titles
{
    if (_titles == nil) {
        _titles = @[@"和值",@"三同号",@"二同号",@"三不同",@"二不同"];
    }
    return _titles;
}
- (NSMutableArray *)allSelNumbersArray
{
    if (_allSelNumbersArray == nil) {
        _allSelNumbersArray = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            [_allSelNumbersArray addObject:[NSMutableArray array]];
            if (i == 2) {//二不同里包含三个数组
                [_allSelNumbersArray[i] addObject:[NSMutableArray array]];
                [_allSelNumbersArray[i] addObject:[NSMutableArray array]];
                [_allSelNumbersArray[i] addObject:[NSMutableArray array]];
            }
        }
    }
    return _allSelNumbersArray;
}
- (NSMutableArray  *)diceViews
{
    if (_diceViews == nil) {
        _diceViews = [NSMutableArray array];
    }
    return _diceViews;
}
#pragma  mark - 工具
//冒泡排序球数组
- (NSMutableArray *)sortBallsArray:(NSMutableArray *)mutableArray
{
    if(mutableArray.count == 1) return mutableArray;
    for(int i = 0;i < mutableArray.count;i++)
    {
        for(int j = i + 1;j <mutableArray.count;j++)
        {
            NSNumber *num1 = @([mutableArray[i] intValue]);
            NSNumber *num2 = @([mutableArray[j] intValue]);
            if([num1 intValue] > [num2 intValue])
            {
                [mutableArray replaceObjectAtIndex:i withObject:num2];
                [mutableArray replaceObjectAtIndex:j withObject:num1];
            }
        }
    }
    return mutableArray;
}
#pragma  mark - 销毁对象
- (void)dealloc
{
    [self removeSetDeadlineTimer];
}
- (void)removeSetDeadlineTimer
{
    [self.getCurrentTermDataTimer invalidate];
    self.getCurrentTermDataTimer = nil;
}
@end
