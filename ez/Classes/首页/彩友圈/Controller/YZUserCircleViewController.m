//
//  YZUserCircleViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZUserCircleViewController.h"
#import "YZCircleUserInfoHeaderView.h"
#import "YZCircleTableView.h"

@interface YZUserCircleViewController ()<YZCircleTableViewDelegate>

@property (nonatomic, weak) UIView *barView;
@property (nonatomic,weak) UIImageView *barAvatarImageView;
@property (nonatomic, weak) UILabel * barNickNameLabel;
@property (nonatomic, weak) UIButton * backButon;
@property (nonatomic, weak) UIButton *attentionButon;
@property (nonatomic, weak) YZCircleTableView *tableView;

@end

@implementation YZUserCircleViewController

#pragma mark - 控制器的生命周期
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self circleTableViewDidScroll:self.tableView];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChilds];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

#pragma mark - 布局子视图
- (void)setupChilds
{
    YZCircleTableView *tableView = [[YZCircleTableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.tableView = tableView;
    tableView.circleDelegate = self;
    tableView.userId = self.circleModel.userId;
    tableView.type = CircleUserReleaseTopic;
    [self.view addSubview:tableView];
    [tableView getData];
    
    //barView
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)];
    self.barView = barView;
    barView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self.view addSubview:barView];
    
    UILabel *barNickNameLabel = [[UILabel alloc] init];
    self.barNickNameLabel = barNickNameLabel;
    barNickNameLabel.alpha = 0;
    barNickNameLabel.textColor = YZBlackTextColor;
    barNickNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    barNickNameLabel.text = self.circleModel.nickname ? self.circleModel.nickname : self.circleModel.userName;
    [barView addSubview:barNickNameLabel];
    
    UIImageView * barAvatarImageView = [[UIImageView alloc] init];
    self.barAvatarImageView = barAvatarImageView;
    barAvatarImageView.alpha = 0;
    barAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    barAvatarImageView.layer.masksToBounds = YES;
    [barAvatarImageView sd_setImageWithURL:[NSURL URLWithString:self.circleModel.headPortraitUrl] placeholderImage:[UIImage imageNamed:@"avatar_zc"]];
    [barView addSubview:barAvatarImageView];
    
    CGSize barNickNameLabelSize = [barNickNameLabel.text sizeWithLabelFont:barNickNameLabel.font];
    CGFloat barAvatarImageViewWH = 35;
    CGFloat barAvatarImageViewX = (screenWidth - barAvatarImageViewWH - barNickNameLabelSize.width - 2) / 2;
    barAvatarImageView.frame = CGRectMake(barAvatarImageViewX, statusBarH + (navBarH - barAvatarImageViewWH) / 2, barAvatarImageViewWH, barAvatarImageViewWH);
    barAvatarImageView.layer.cornerRadius = barAvatarImageView.width / 2;
    barNickNameLabel.frame = CGRectMake(CGRectGetMaxX(barAvatarImageView.frame) + 2, statusBarH, barNickNameLabelSize.width, navBarH);
    
    //返回
    UIButton * backButon = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backButon = backButon;
    backButon.frame = CGRectMake(5, statusBarH + 6, 34, 30);
    [backButon setImage:[UIImage imageNamed:@"back_btn_flat"] forState:UIControlStateNormal];
    [backButon addTarget:self action:@selector(backButonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:backButon];

    //headerView
    YZCircleUserInfoHeaderView *headerView = [[YZCircleUserInfoHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 212)];
    headerView.circleModel = self.circleModel;
    tableView.tableHeaderView = headerView;
    
    //关注
    UIButton *attentionButon = [UIButton buttonWithType:UIButtonTypeCustom];
    self.attentionButon = attentionButon;
    attentionButon.frame = CGRectMake(screenWidth - 70, statusBarH, 70, 44);
    [attentionButon setTitle:@"关注" forState:UIControlStateNormal];
    [attentionButon setTitle:@"已关注" forState:UIControlStateDisabled];
    [attentionButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    attentionButon.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    attentionButon.layer.masksToBounds = YES;
    attentionButon.layer.cornerRadius = 3;
    [attentionButon addTarget:self action:@selector(attentionButonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:attentionButon];
}

- (void)backButonDidClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)attentionButonDidClick
{
    NSDictionary *dict = @{
                           @"userId": UserId,
                           @"byConcernUserId": self.circleModel.userId,
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/userConcern") params:dict success:^(id json) {
        YZLog(@"userConcern:%@",json);
        if (SUCCESS){
            self.attentionButon.enabled = NO;
        }else
        {
            ShowErrorView
        }
    }failure:^(NSError *error)
    {
        YZLog(@"error = %@",error);
    }];
}

- (void)circleTableViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        CGFloat offsetY = scrollView.contentOffset.y;
        CGFloat scale = offsetY / 100.0;
        scale = scale > 1 ? 1 : scale;
        self.barAvatarImageView.alpha = scale;
        self.barNickNameLabel.alpha = scale;
        //设置bar背景色
        self.barView.backgroundColor = [UIColor colorWithWhite:1 alpha:scale];
        if (offsetY <= 100) {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            [self.backButon setImage:[UIImage imageNamed:@"back_btn_flat"] forState:UIControlStateNormal];
            [self.attentionButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else
        {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            [self.backButon setImage:[UIImage imageNamed:@"black_back_bar"] forState:UIControlStateNormal];
            [self.attentionButon setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        }
    }
}


@end
