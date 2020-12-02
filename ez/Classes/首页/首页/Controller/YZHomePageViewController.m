//
//  YZHomePageViewController.m
//  ez
//
//  Created by apple on 16/9/27.
//  Copyright © 2016年 9ge. All rights reserved.
//
#import "YZHomePageViewController.h"
#import "YZGameIdViewController.h"
#import "YZWinViewController.h"
#import "YZMessageViewController.h"
#import "YZLoginViewController.h"
#import "YZNavigationController.h"
#import "YZBuyLotteryCollectionView.h"
#import "YZCustomerServiceViewController.h"
#import "YZServiceListViewController.h"
#import "YZChatViewController.h"
#import "YZShopInfoViewController.h"
#import "YZShopModel.h"

@interface YZHomePageViewController ()<YZBuyLotteryCollectionViewDelegate>

@property (nonatomic, weak) YZBuyLotteryCollectionView *buyLotteryCollectionView;
@property (nonatomic, weak) MJRefreshGifHeader *header;
@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *signLabel;
@property (nonatomic, weak) UILabel *badgeLabel;
@property (nonatomic, weak) UIButton *messageButton;
@property (nonatomic, strong) YZShopModel * shopModel;

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
#endif
- (void)viewDidLoad
{
    [super viewDidLoad];
    //标题
#if JG
    self.navigationItem.title = @"九歌彩票";
#elif ZC
    self.navigationItem.title = @"中彩啦";
#endif
    [self setupChilds];
    [self getShopInfo];
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

#pragma mark - 请求数据
- (void)getShopInfo
{
    
    NSDictionary *dict = @{
    };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlSalesManager(@"/getStoreInfo") params:dict success:^(id json) {
        YZLog(@"%@",json);
        if (SUCCESS) {
            YZShopModel *shopModel = [YZShopModel objectWithKeyValues:json[@"store"]];
            shopModel.payList = [YZShopPayModel objectArrayWithKeyValuesArray:json[@"store"][@"payList"]];
            self.shopModel = shopModel;
        }
    } failure:^(NSError *error) {
        YZLog(@"error：%@", error);
    }];
}

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
            UIImage * messageImage = [UIImage imageNamed:@"home_shop_chat"];
            if (countUnReadMessage > 0) {//有消息
                UIImage * messageImageNone = [UIImage ImageFromColor:[UIColor clearColor] WithRect:CGRectMake(0, 0, 20, 20)];
                NSArray *images = @[messageImage, messageImageNone];
                [self.messageButton setBackgroundImage:[UIImage animatedImageWithImages:images duration:1] forState:UIControlStateNormal];
            }else
            {
                [self.messageButton setBackgroundImage:messageImage forState:UIControlStateNormal];
            }
        }
    } failure:^(NSError *error)
     {
        YZLog(@"error = %@",error);
    }];
}

#pragma mark - Setting
- (void)setShopModel:(YZShopModel *)shopModel
{
    _shopModel = shopModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_shopModel.headUrl] placeholderImage:[UIImage imageNamed:@"avatar_zc"]];
    self.nameLabel.text = _shopModel.name;
    NSString *notice = _shopModel.notice;
    if (YZStringIsEmpty(notice)) {
        notice = @"暂无公告";
    }
    self.signLabel.text = notice;
    
    if (!YZStringIsEmpty(_shopModel.name)) {
        [YZUserDefaultTool saveObject:_shopModel.name forKey:@"shopName"];
    }
}

#pragma mark - 布局视图
- (void)setupChilds
{
    //顶部nav
    UIView * navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, statusBarH + 60)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navView];
    
    //头像
    UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(YZMargin, statusBarH + 5, 45, 45)];
    self.avatarImageView = avatarImageView;
    avatarImageView.image = [UIImage imageNamed:@"avatar_zc"];
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = avatarImageView.width / 2;
    avatarImageView.userInteractionEnabled = YES;
    [avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goShopInfo)]];
    [navView addSubview:avatarImageView];
    
    //店铺名
    UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + 5, statusBarH + 5, navView.width - (CGRectGetMaxX(avatarImageView.frame) + 5) - 120, 28)];
    self.nameLabel = nameLabel;
    nameLabel.textColor = YZBlackTextColor;
    nameLabel.font = [UIFont boldSystemFontOfSize:YZGetFontSize(35)];
    nameLabel.userInteractionEnabled = YES;
    [nameLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goShopInfo)]];
    [navView addSubview:nameLabel];
    
    //签名
    UILabel * signLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + 5, CGRectGetMaxY(nameLabel.frame), navView.width - (CGRectGetMaxX(avatarImageView.frame) + 5) - 10, 20)];
    self.signLabel = signLabel;
    signLabel.textColor = YZGrayTextColor;
    signLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [navView addSubview:signLabel];
    
    //按钮
    CGFloat navButtonWH = 22;
    for (int i = 0; i < 3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(navView.width - 5 - (navButtonWH + 20) * (i + 1), statusBarH + 7, navButtonWH, navButtonWH);
        if (i == 0) {
            self.messageButton = button;
            [button setBackgroundImage:[UIImage imageNamed:@"home_shop_chat"] forState:UIControlStateNormal];
        }else if (i == 1)
        {
            [button setBackgroundImage:[UIImage imageNamed:@"home_shop_phone"] forState:UIControlStateNormal];
        }else if (i == 2)
        {
            [button setBackgroundImage:[UIImage imageNamed:@"home_shop_erCode"] forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(navButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [navView addSubview:button];
        
        if (i == 0) {
            UILabel * badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(navButtonWH - 9.5, -6, 16, 16)];
            self.badgeLabel = badgeLabel;
            badgeLabel.textColor = [UIColor whiteColor];
            badgeLabel.backgroundColor = UIColorFromRGB(0XFA585D);
            badgeLabel.textAlignment = NSTextAlignmentCenter;
            badgeLabel.font = [UIFont systemFontOfSize:10];
            badgeLabel.layer.cornerRadius = badgeLabel.width / 2;
            badgeLabel.layer.masksToBounds = YES;
            badgeLabel.hidden = YES;
            [button addSubview:badgeLabel];
        }
    }
    
    //内容CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0.0;//列间距
    layout.minimumLineSpacing = 0.0;//行间距
    
    YZBuyLotteryCollectionView *buyLotteryCollectionView = [[YZBuyLotteryCollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(navView.frame), screenWidth, screenHeight - CGRectGetMaxY(navView.frame) - tabBarH) collectionViewLayout:layout];
    self.buyLotteryCollectionView = buyLotteryCollectionView;
    buyLotteryCollectionView.buyLotteryDelegate = self;
    [self.view addSubview:buyLotteryCollectionView];
    
    //初始化头部刷新控件
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderGif:header];
    buyLotteryCollectionView.mj_header = header;
}

#pragma mark - 点击事件
- (void)navButtonDidClick:(UIButton *)button
{
    if(!UserId)
    {
        YZLoginViewController *login = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    if (button.tag == 0) {
        YZMessageViewController * messageVC = [[YZMessageViewController alloc] init];
        [self.navigationController pushViewController:messageVC animated:YES];
    }else if (button.tag == 1)
    {
        YZServiceListViewController * contactServiceVC = [[YZServiceListViewController alloc]init];
        [self.navigationController pushViewController:contactServiceVC animated:YES];
    }else if (button.tag == 2)
    {
        [self goShopInfo];
    }
}

- (void)goShopInfo
{
    [self.navigationController pushViewController:[[YZWinViewController alloc] init] animated:YES];
    return;
    
    if(!UserId)
    {
        YZLoginViewController *login = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    [self.navigationController pushViewController:[[YZShopInfoViewController alloc] init] animated:YES];
}

- (void)headerRefreshViewBeginRefreshing
{
    [self.buyLotteryCollectionView headerRefreshViewBeginRefreshingWith:(MJRefreshGifHeader *)self.buyLotteryCollectionView.mj_header];
}

@end
