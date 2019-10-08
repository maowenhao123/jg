//
//  YZHomePageFunctionItemView.m
//  ez
//
//  Created by 毛文豪 on 2018/1/31.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZHomePageFunctionItemView.h"
#import "YZInitiateUnionBuyViewController.h"
#import "YZLoginViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZIntegralConversionViewController.h"
#import "YZInformationH5ViewController.h"
#import "YZRechargeListViewController.h"
#import "YZVoucherViewController.h"
#import "YZServiceListViewController.h"
#import "YZCircleViewController.h"
#import "UIImageView+WebCache.h"

@interface YZHomePageFunctionItemView ()

@property (nonatomic, weak) UIImageView *logoImageView;//logo
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation YZHomePageFunctionItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChilds];
    }
    return self;
}

- (void)setupChilds
{
    //logo
    CGFloat logoWH = 27;
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - logoWH) / 2, 18, logoWH, logoWH)];
    self.logoImageView = logoImageView;
    [self addSubview:logoImageView];
    
    //玩法
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(logoImageView.frame) + 7, self.width, [UIFont systemFontOfSize:YZGetFontSize(24)].lineHeight)];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    titleLabel.textColor = YZBlackTextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self addGestureRecognizer:tap];
}

- (void)setFunctionModel:(YZHomePageFunctionModel *)functionModel
{
    _functionModel = functionModel;
    
    NSDictionary * imageNameDic = @{
                                    @"POINT":@"home_integral_conversion",
                                    @"INFORMATION":@"home_forecast",
                                    @"PROMOTION":@"home_activity",
                                    @"HIT":@"home_lottery",
                                    @"GIFT":@"home_red_packet",
                                    @"OTHERS":@"home_other",
                                    };
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:_functionModel.iconUrl] placeholderImage:[UIImage imageNamed:imageNameDic[_functionModel.type]]];
    self.titleLabel.text = _functionModel.name;
}

- (void)didTap:(UITapGestureRecognizer *)tap
{
    if ([self.functionModel.type isEqualToString:@"POINT"]) {//积分兑换
        if (!UserId) {
            YZLoginViewController *login = [[YZLoginViewController alloc] init];
            YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:login];
            [self.viewController presentViewController:nav animated:YES completion:nil];
            return;
        }
        YZIntegralConversionViewController * integralConversionVC = [[YZIntegralConversionViewController alloc] init];
        [self.viewController.navigationController pushViewController:integralConversionVC animated:YES];
    }else if ([self.functionModel.type isEqualToString:@"INFORMATION"])//预测资讯
    {
        YZInformationH5ViewController * informationVC = [[YZInformationH5ViewController alloc] init];
        [self.viewController.navigationController pushViewController:informationVC animated:YES];
    }else if ([self.functionModel.type isEqualToString:@"HIT"] || [self.functionModel.type isEqualToString:@"PROMOTION"] || [self.functionModel.type isEqualToString:@"GIFT"] || [self.functionModel.type isEqualToString:@"OTHERS"])//活动中心 中奖专区 其他
    {
        YZLoadHtmlFileController * webVC = [[YZLoadHtmlFileController alloc] initWithWeb:self.functionModel.url];
        webVC.title = self.functionModel.name;
        [self.viewController.navigationController pushViewController:webVC animated:YES];
    }else if ([self.functionModel.type isEqualToString:@"PAYMENT"])//充值
    {
        if (!UserId) {
            YZLoginViewController *login = [[YZLoginViewController alloc] init];
            YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:login];
            [self.viewController presentViewController:nav animated:YES completion:nil];
            return;
        }
        YZRechargeListViewController * rechargeVC = [[YZRechargeListViewController alloc] init];
        [self.viewController.navigationController pushViewController:rechargeVC animated:YES];
    }else if ([self.functionModel.type isEqualToString:@"COUPON"])//彩券
    {
        if (!UserId) {
            YZLoginViewController *login = [[YZLoginViewController alloc] init];
            YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:login];
            [self.viewController presentViewController:nav animated:YES completion:nil];
            return;
        }
        YZVoucherViewController * voucherVC = [[YZVoucherViewController alloc] init];
        [self.viewController.navigationController pushViewController:voucherVC animated:YES];
    }else if ([self.functionModel.type isEqualToString:@"UNIONPLAN"])//发起合买
    {
        YZInitiateUnionBuyViewController * initiateUnionBuyVC = [[YZInitiateUnionBuyViewController alloc] init];
        [self.viewController.navigationController pushViewController:initiateUnionBuyVC animated:YES];
    }else if ([self.functionModel.type isEqualToString:@"COMMUNITY"])//彩友圈
    {
        if (!UserId) {
            YZLoginViewController *login = [[YZLoginViewController alloc] init];
            YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:login];
            [self.viewController presentViewController:nav animated:YES completion:nil];
            return;
        }
        YZCircleViewController * messageVC = [[YZCircleViewController alloc] init];
        [self.viewController.navigationController pushViewController:messageVC animated:YES];
    }else if ([self.functionModel.type isEqualToString:@"KEFU"])//在线客服列表
    {
        if (!UserId) {
            YZLoginViewController *login = [[YZLoginViewController alloc] init];
            YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:login];
            [self.viewController presentViewController:nav animated:YES completion:nil];
            return;
        }
        YZServiceListViewController * contactServiceVC = [[YZServiceListViewController alloc]init];
        [self.viewController.navigationController pushViewController:contactServiceVC animated:YES];
    }else if ([self.functionModel.type isEqualToString:@"ORDER"])//订单列表
    {
        NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.viewController.navigationController popToRootViewControllerAnimated:NO];
            });
        }];
        NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshRecordNote object:@(0)];
            });
        }];
        [op2 addDependency:op1];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue waitUntilAllOperationsAreFinished];
        [queue addOperation:op1];
        [queue addOperation:op2];
    }
}

@end
