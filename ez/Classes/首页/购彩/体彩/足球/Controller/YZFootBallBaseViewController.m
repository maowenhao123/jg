//
//  YZFootBallBaseViewController.m
//  ez
//
//  Created by apple on 14-11-19.
//  Copyright (c) 2014年 9ge. All rights reserved.
//  竞彩基类

#import "YZFootBallBaseViewController.h"
#import "YZMatchInfosStatus.h"
#import "YZGameIndosStatus.h"

@interface YZFootBallBaseViewController ()

@property (nonatomic, weak) UIView *loadFailBgView;

@end

@implementation YZFootBallBaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor whiteColor];
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:textAttrs];
    // 设置navBar背景
    [navBar setBackgroundImage:[YZTool getFBNavImage] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 取出appearance对象
    UINavigationBar *navBar = self.navigationController.navigationBar;
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
#elif RR
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

    [self setupChilds];

    waitingView_loadingData
    
    [self getCurrentMatchInfo];//获取竞彩对阵球队信息
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 获取比赛信息
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self getCurrentMatchInfo];
}

- (void)getCurrentMatchInfo
{
    NSDictionary *dict = [NSDictionary dictionary];
    //T53胜负彩  T54四场进球
    if ([self.gameId isEqualToString:@"T53"] || [self.gameId isEqualToString:@"T54"]) {
        dict = @{
                 @"cmd":@(8026),
                 @"gameId":self.gameId,
                 };
    }else{//竞彩足球
        NSArray *oddsCode = [[NSArray alloc] initWithObjects:@"CN", nil];
        NSArray *playTypeCode = [[NSArray alloc] initWithObjects:@"01", @"02", @"03", @"04", @"05",nil];
        dict = @{
                 @"cmd":@(8028),
                 @"gameId":self.gameId,
                 @"oddsCode":oddsCode,
                 @"playTypeCode":playTypeCode,
                };

    }
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        YZLog(@"getCurrentMatchInfo - json = %@",json);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if([json[@"retCode"] intValue] == 0)
        {
            if ([self.gameId isEqualToString:@"T53"] || [self.gameId isEqualToString:@"T54"]) {
                NSDictionary *gameDic = json[@"game"];
                NSArray *termList = gameDic[@"termList"];
                if (termList.count > 0) {
                    self.matchInfosStatusArray = [YZGameIndosStatus objectArrayWithKeyValuesArray:termList];//转模型数组
                }else
                {
                    self.matchInfosStatusArray = [NSArray array];
                }
            }else
            {
                NSArray *matchInfosStatusArray = json[@"matchInfos"];
                if (matchInfosStatusArray.count > 0) {
                    self.matchInfosStatusArray = [YZMatchInfosStatus objectArrayWithKeyValuesArray:json[@"matchInfos"]];//转模型数组
                }else
                {
                    self.matchInfosStatusArray = [NSArray array];
                }
            }
            [self getCurrentMatchInfoEnded];//子类要重写的方法
            if(self.matchInfosStatusArray.count > 0)
            {
                [self removeLoadFailView];
            }else
            {
                [self addLoadFailView:@"暂时没有销售期次信息"];
            }
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [self getCurrentMatchInfoFailed];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(!self.loadFailBgView && !self.matchInfosStatusArray.count)
        {
            [self addLoadFailView:@"亲~~~网络不给力..."];
        }
        YZLog(@"getCurrentMatchInfo - error = %@",error);
    }];
}
- (void)getCurrentMatchInfoFailed
{
    //子类重写
}
- (void)addLoadFailView:(NSString *)title
{
    UIView *loadFailBgView = [[UIView alloc] init];
    self.loadFailBgView = loadFailBgView;
    loadFailBgView.bounds = CGRectMake(0, 0, self.tableView.width, self.tableView.height / 2);
    loadFailBgView.center = self.tableView.center;
    [self.tableView addSubview:loadFailBgView];
    //图片
    UIImage *loadFailImage = [UIImage imageNamed:@"loadFailImage"];
    UIImageView *loadFailImageView = [[UIImageView alloc] initWithImage:loadFailImage];
    CGFloat loadFailImageViewW = loadFailImage.size.width;
    CGFloat loadFailImageViewH = loadFailImage.size.height;
    loadFailImageView.bounds = CGRectMake(0, 0, loadFailImageViewW, loadFailImageViewH);
    loadFailImageView.centerX = loadFailBgView.centerX;
    [loadFailBgView addSubview:loadFailImageView];
    
    //加载失败文字
    UILabel *loadFailLabel = [[UILabel alloc] init];
    loadFailLabel.textColor = [UIColor darkGrayColor];
    loadFailLabel.font = [UIFont systemFontOfSize:YZGetFontSize(38)];
    loadFailLabel.text = title;//@"亲~~~网络不给力...";
    loadFailLabel.textAlignment = NSTextAlignmentCenter;
    CGSize loadFailLabelSize = [loadFailLabel.text sizeWithLabelFont:loadFailLabel.font];
    loadFailLabel.frame = CGRectMake(0, CGRectGetMaxY(loadFailImageView.frame) + 30, loadFailBgView.width, loadFailLabelSize.height);
    [loadFailBgView addSubview:loadFailLabel];
}

- (void)removeLoadFailView
{
    if(self.loadFailBgView)
    {
        [self.loadFailBgView removeFromSuperview];
        self.loadFailBgView = nil;
    }
}
//获取到了比赛信息后调用
- (void)getCurrentMatchInfoEnded
{
    //子类重写
}
- (void)setupChilds
{
    //底栏
    CGFloat bottomViewW = screenWidth;
    CGFloat bottomViewH = 49;
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = screenHeight - bottomViewH - statusBarH - navBarH - [YZTool getSafeAreaBottom];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH)];
    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    //删除按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat deleteBtnWH = 20;
    CGFloat deleteBtnY = (bottomViewH - deleteBtnWH) / 2;
    deleteBtn.frame = CGRectMake(YZMargin, deleteBtnY, deleteBtnWH, deleteBtnWH);
    [deleteBtn setImage:[UIImage imageNamed:@"buyLottery_deleteBtn_flat"] forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"buyLottery_deleteBtn_pressed_flat"] forState:UIControlStateHighlighted];
    [bottomView addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //分割线
    UIView * deleteBtnLineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxY(deleteBtn.frame) + YZMargin, 12, 1, bottomViewH - 2 * 12)];
    deleteBtnLineView.backgroundColor = YZWhiteLineColor;
    [bottomView addSubview:deleteBtnLineView];
    
    //确认按钮
    CGFloat confirmBtnH = 30;
    CGFloat confirmBtnW = 75;
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(screenWidth - confirmBtnW - 15, (bottomViewH - confirmBtnH) / 2, confirmBtnW, confirmBtnH);
    [confirmBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(80, 148, 35, 1) WithRect:confirmBtn.bounds] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [bottomView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.layer.cornerRadius = 2;
    
    //底部中间的label，显示选择多少场比赛
    UILabel *bottomMidLabel = [[UILabel alloc] init];
    self.bottomMidLabel = bottomMidLabel;
    bottomMidLabel.contentMode = UIViewContentModeCenter;
    bottomMidLabel.backgroundColor = [UIColor whiteColor];
    bottomMidLabel.textColor = YZBlackTextColor;
    bottomMidLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    CGFloat bottomMidLabelX = CGRectGetMaxX(deleteBtn.frame) + 22;
    CGFloat bottomMidLabelW = bottomViewW - CGRectGetMaxX(deleteBtnLineView.frame) - 15 - confirmBtnW - 15;
    CGFloat bottomMidLabelH = 25;
    bottomMidLabel.frame = CGRectMake(bottomMidLabelX, 0, bottomMidLabelW, bottomMidLabelH);
    bottomMidLabel.center = CGPointMake(bottomMidLabel.center.x, bottomViewH/2);
    [bottomView addSubview:bottomMidLabel];
    
    //分割线
    UIView * bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    bottomLineView.backgroundColor = YZGrayLineColor;
    [bottomView addSubview:bottomLineView];
}

#pragma mark - 子类重写方法
- (void)confirmBtnClick
{
    
}

- (void)deleteBtnClick
{
    
}


@end
