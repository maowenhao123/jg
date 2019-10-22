
//
//  YZRRHomePageViewController.m
//  ez
//
//  Created by dahe on 2019/10/15.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZRRHomePageViewController.h"
#import "YZGameIdViewController.h"
#import "YZMessageViewController.h"
#import "YZLoginViewController.h"
#import "YZNavigationController.h"
#import "YZBuyLotteryCollectionView.h"
#import "YZCustomerServiceViewController.h"
#import "YZServiceListViewController.h"

@interface YZRRHomePageViewController ()<YZBuyLotteryCollectionViewDelegate>

@property (nonatomic, weak) UIImageView * backView;
@property (nonatomic, weak) UIButton * messageButton;
@property (nonatomic, weak) YZBuyLotteryCollectionView *buyLotteryCollectionView;
@property (nonatomic, weak) MJRefreshGifHeader *header;

@end

@implementation YZRRHomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupChilds];
    [self getMessageCount];
    if (@available(iOS 11.0, *)) {
        self.buyLotteryCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //接收刷新是否有新消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageCount) name:@"upDataHaveNewMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessageCount) name:loginSuccessNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerRefreshViewBeginRefreshing) name:loginSuccessNote object:nil];
}

- (void)setupChilds
{
    //背景
    UIImageView * backView = [[UIImageView alloc] init];
    self.backView = backView;
    backView.frame = CGRectMake(0, 0, screenWidth, 155);
    backView.image = [UIImage imageNamed:@"mine_top_bg_rr"];
    [self.view addSubview:backView];
    
    //buyLotteryCollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0.0;//列间距
    layout.minimumLineSpacing = 0.0;//行间距
    
    YZBuyLotteryCollectionView *buyLotteryCollectionView = [[YZBuyLotteryCollectionView alloc]initWithFrame:CGRectMake(YZMargin, 0, screenWidth - 2 * YZMargin, screenHeight - tabBarH) collectionViewLayout:layout];
    self.buyLotteryCollectionView = buyLotteryCollectionView;
    buyLotteryCollectionView.buyLotteryDelegate = self;
    buyLotteryCollectionView.showsVerticalScrollIndicator = NO;
    buyLotteryCollectionView.contentInset = UIEdgeInsetsMake(statusBarH + navBarH, 0, 10, 0);
    [self.view addSubview:buyLotteryCollectionView];
    
    //初始化头部刷新控件
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderGif:header];
    self.header= header;
    buyLotteryCollectionView.mj_header = header;
    
    //标题
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((screenWidth - 100) / 2, statusBarH - (statusBarH + navBarH), 80, navBarH)];
    titleLabel.text = @"人人彩";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    [buyLotteryCollectionView addSubview:titleLabel];
    
    //消息
    UIButton * messageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.messageButton = messageButton;
    messageButton.frame = CGRectMake(buyLotteryCollectionView.width - 60, statusBarH - (statusBarH + navBarH), 60, navBarH);
    [messageButton setImage:[UIImage imageNamed:@"message_btn"] forState:UIControlStateNormal];
    [messageButton addTarget:self action:@selector(messageButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [buyLotteryCollectionView addSubview:messageButton];
}

- (void)messageButtonDidClick
{
    if (!UserId) {
        YZLoginViewController *login = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    YZMessageViewController * messageVC = [[YZMessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}

- (void)headerRefreshViewBeginRefreshing
{
    [self.buyLotteryCollectionView headerRefreshViewBeginRefreshingWith:self.header];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.backView.y = - scrollView.mj_offsetY - (statusBarH + navBarH);
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
            UIImage * message_bar = [UIImage imageNamed:@"message_btn"];
            if (countUnReadMessage > 0) {//有消息
                UIImage * message_bar_none = [UIImage ImageFromColor:[UIColor clearColor] WithRect:CGRectMake(0, 0, 20, 20)];
                NSArray *images = @[message_bar, message_bar_none];
                [self.messageButton setImage:[UIImage animatedImageWithImages:images duration:1] forState:UIControlStateNormal];
            }else
            {
                [self.messageButton setImage:[UIImage imageNamed:@"message_btn"] forState:UIControlStateNormal];
            }
        }
    } failure:^(NSError *error)
     {
         YZLog(@"error = %@",error);
     }];
}

@end
