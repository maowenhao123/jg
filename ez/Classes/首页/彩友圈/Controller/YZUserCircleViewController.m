//
//  YZUserCircleViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZUserCircleViewController.h"
#import "YZCircleViewAttentionViewController.h"
#import "YZCircleTableView.h"

@interface YZUserCircleViewController ()<YZCircleTableViewDelegate>

@property (nonatomic, weak) UIView *barView;
@property (nonatomic,weak) UIImageView *barAvatarImageView;
@property (nonatomic, weak) UILabel * barNickNameLabel;
@property (nonatomic, weak) UIButton * backButon;
@property (nonatomic, weak) YZCircleTableView *tableView;

@end

@implementation YZUserCircleViewController

#pragma mark - 控制器的生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self circleTableViewDidScroll:self.tableView];
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
    [self.view addSubview:tableView];
    
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
    barNickNameLabel.text = @"昵称";
    [barView addSubview:barNickNameLabel];
    
    UIImageView * barAvatarImageView = [[UIImageView alloc] init];
    self.barAvatarImageView = barAvatarImageView;
    barAvatarImageView.alpha = 0;
    barAvatarImageView.contentMode = UIViewContentModeScaleAspectFill;
    barAvatarImageView.layer.masksToBounds = YES;
    barAvatarImageView.image = [UIImage imageNamed:@"avatar_zc"];
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 202)];
    headerView.backgroundColor = YZRedBallColor;
    
    //头像
    UIImageView * avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake((screenWidth - 55) / 2, 70, 55, 55)];
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = avatarImageView.width / 2;
    avatarImageView.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.3].CGColor;
    avatarImageView.layer.borderWidth = 3;
    avatarImageView.image = [UIImage imageNamed:@"avatar_zc"];
    [headerView addSubview:avatarImageView];
    
    //昵称
    UILabel * nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.textColor = [UIColor whiteColor];
    nickNameLabel.text = @"昵称";
    nickNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(32)];
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    nickNameLabel.frame = CGRectMake(0, CGRectGetMaxY(avatarImageView.frame) + 12, headerView.width, nickNameLabel.font.lineHeight);
    [headerView addSubview:nickNameLabel];
    
    CGFloat buttonPadding = 50;
    CGFloat buttonW = (screenWidth - 2 * buttonPadding) / 2;
    for (int i = 0; i < 2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(buttonPadding + buttonW * i, CGRectGetMaxY(nickNameLabel.frame) + 10, buttonW, 25);
        if (i == 0) {
            [button setTitle:@"粉丝99" forState:UIControlStateNormal];
        }else if (i == 1)
        {
            [button setTitle:@"点赞99" forState:UIControlStateNormal];
        }
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
    }
    
    tableView.tableHeaderView = headerView;
    
}

- (void)backButonDidClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buttonDidClick:(UIButton *)button
{
    YZCircleViewAttentionViewController * attentionVC = [[YZCircleViewAttentionViewController alloc] init];
    if (button.tag == 0) {
        attentionVC.isFans = YES;
    }
    [self.navigationController pushViewController:attentionVC animated:YES];
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
        }else
        {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            [self.backButon setImage:[UIImage imageNamed:@"black_back_bar"] forState:UIControlStateNormal];
        }
    }
}


@end
