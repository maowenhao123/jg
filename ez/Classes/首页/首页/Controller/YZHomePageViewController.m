//
//  YZHomePageViewController.m
//  ez
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 9ge. All rights reserved.
//
#import "YZHomePageViewController.h"
#import "YZGameIdViewController.h"
#import "YZMessageViewController.h"
#import "YZLoginViewController.h"
#import "YZNavigationController.h"
#import "YZShareViewController.h"
#import "YZBuyLotteryCollectionView.h"
#import "YZCircleViewController.h"
#import "YZContactCustomerServiceViewController.h"

@interface YZHomePageViewController ()<YZBuyLotteryCollectionViewDelegate>

@property (nonatomic, strong) UIBarButtonItem * messageBarButtonItem;
@property (nonatomic, weak) YZBuyLotteryCollectionView *buyLotteryCollectionView;
@property (nonatomic, weak) MJRefreshGifHeader *header;

@end

@implementation YZHomePageViewController

#pragma mark - 控制器的生命周期
#if JG
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 取出appearance对象
    UINavigationBar *navBar = self.navigationController.navigationBar;
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:YZBaseColor WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
}

#elif ZC
#elif CS
#endif
- (void)viewDidLoad
{
    [super viewDidLoad];
    //标题
#if JG
    self.navigationItem.title = @"九歌彩票";
#elif ZC
    self.navigationItem.title = @"中彩啦";
#elif CS
    self.navigationItem.title = @"财多多";
#endif
    [self setupChilds];
    [self getMessageCount];
    if (@available(iOS 11.0, *)) {
        self.buyLotteryCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //接收刷新是否有新消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageCount) name:@"upDataHaveNewMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageCount) name:loginSuccessNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRefreshViewBeginRefreshing) name:loginSuccessNote object:nil];
}

- (void)setupChilds
{
    self.messageBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"message_bar"] style:UIBarButtonItemStylePlain target:self action:@selector(messageBarDidClick)];
    UIBarButtonItem * serviceBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"service_white_bar"] style:UIBarButtonItemStylePlain target:self action:@selector(serviceBarDidClick)];
#if JG
    self.navigationItem.rightBarButtonItem = self.messageBarButtonItem;
#elif ZC
    self.navigationItem.rightBarButtonItems = @[self.messageBarButtonItem, serviceBarButtonItem];
#elif CS
    self.navigationItem.rightBarButtonItems = @[self.messageBarButtonItem, serviceBarButtonItem];
#endif
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0.0;//列间距
    layout.minimumLineSpacing = 0.0;//行间距
    
     YZBuyLotteryCollectionView *buyLotteryCollectionView = [[YZBuyLotteryCollectionView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH - tabBarH) collectionViewLayout:layout];
    self.buyLotteryCollectionView = buyLotteryCollectionView;
    buyLotteryCollectionView.buyLotteryDelegate = self;
    [self.view addSubview:buyLotteryCollectionView];
    
    //初始化头部刷新控件
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderGif:header];
    self.header= header;
    buyLotteryCollectionView.mj_header = header;
}

- (void)messageBarDidClick
{
    if (!UserId) {
        YZLoginViewController *login = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    YZCircleViewController * messageVC = [[YZCircleViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
//    YZMessageViewController * messageVC = [[YZMessageViewController alloc] init];
//    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)serviceBarDidClick
{
    if (!UserId) {
        YZLoginViewController *login = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    YZContactCustomerServiceViewController * contactServiceVC = [[YZContactCustomerServiceViewController alloc]init];
    [self.navigationController pushViewController:contactServiceVC animated:YES];
}

- (void)headerRefreshViewBeginRefreshing
{
    [self.buyLotteryCollectionView headerRefreshViewBeginRefreshingWith:self.header];
}

#pragma mark - message
- (void)getMessageCount
{
    if (!UserId) {
        return;
    }
    NSDictionary *dict = @{
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlJiguang(@"/countUnRead") params:dict success:^(id json) {
        YZLog(@"countUnReadMessage:%@",json);
        if (SUCCESS) {
            int countUnReadMessage = [json[@"count"] intValue];
#if JG
            UIImage * message_bar = [UIImage imageNamed:@"white_message_bar"];
#elif ZC
            UIImage * message_bar = [UIImage imageNamed:@"black_message_bar"];
#elif CS
            UIImage * message_bar = [UIImage imageNamed:@"black_message_bar"];
#endif
            if (countUnReadMessage > 0) {//有消息
                UIImage * message_bar_none = [UIImage ImageFromColor:[UIColor clearColor] WithRect:CGRectMake(0, 0, 20, 20)];
                NSArray *images = @[message_bar, message_bar_none];
                self.messageBarButtonItem.image = [UIImage animatedImageWithImages:images duration:1];
            }else
            {
                self.messageBarButtonItem.image = message_bar;
            }
        }
    } failure:^(NSError *error)
    {
        YZLog(@"error = %@",error);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

@end
