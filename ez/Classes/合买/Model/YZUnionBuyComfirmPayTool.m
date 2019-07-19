//
//  YZUnionBuyComfirmPayTool.m
//  ez
//
//  Created by 毛文豪 on 2017/7/27.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZUnionBuyComfirmPayTool.h"
#import "YZLoginViewController.h"
#import "YZNavigationController.h"
#import "YZBetSuccessViewController.h"
#import "YZRechargeListViewController.h"
#import "YZBetSuccessViewController.h"
#import "YZStartUnionbuyModel.h"
#import "YZStatusCacheTool.h"
#import "NSObject+SBJSON.h"

@interface YZUnionBuyComfirmPayTool ()<UIAlertViewDelegate>
{
    NSString *_gameId;
    YZStartUnionbuyModel *_param;
}

@property (nonatomic, assign)  BOOL isParticipateUnionBuy;//是参与合买
@property (nonatomic, assign)  BOOL isStartUnionBuy;//是发起合买
@property (nonatomic, weak) UIViewController *sourceController;//源控制器，即是哪个控制器使用本类

@end

@implementation YZUnionBuyComfirmPayTool

+ (YZUnionBuyComfirmPayTool *)shareInstance
{
    static YZUnionBuyComfirmPayTool *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[[self class] alloc] init];
    });
    return shareInstance;
}

#pragma mark - 发起合买
- (void)startUnionBuyOfAllWithParam:(YZStartUnionbuyModel *)param sourceController:(UIViewController *)sourceController
{
    self.isStartUnionBuy = YES;
    [self unionBuyOfAllWithParam:param sourceController:sourceController];
}
#pragma mark - 参与合买
- (void)participateUnionBuyOfAllWithParam:(YZStartUnionbuyModel *)param sourceController:(UIViewController *)sourceController
{
    self.isParticipateUnionBuy = YES;
    [self unionBuyOfAllWithParam:param sourceController:sourceController];
}
- (void)unionBuyOfAllWithParam:(YZStartUnionbuyModel *)param sourceController:(UIViewController *)sourceController
{
    _param = param;
    self.sourceController = sourceController;
    if(!UserId)//没登录
    {
        YZLoginViewController *loginVc = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:loginVc];
        [self.sourceController presentViewController:nav animated:YES completion:nil];
        return;
    }else
    {
        [self showComfirmPayAlertViewWithMoney:[_param.money integerValue] / 100];
    }
}
- (void)showComfirmPayAlertViewWithMoney:(NSInteger)money
{
    BOOL hasEnoughMoney = [YZTool hasEnoughMoneyWithAmountMoney:money];
    if (hasEnoughMoney) {
        NSString * message = [YZTool getAlertViewTextWithAmountMoney:money];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"支付确认" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getCurrentTermData];//当前期次的信息
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self.sourceController presentViewController:alertController animated:YES completion:nil];
    }else
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"余额不足" message:@"对不起，余额不足，请充值。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gotoRecharge];
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self.sourceController presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)//账户支付
    {
        if([YZTool hasEnoughMoneyWithAmountMoney:[_param.amount integerValue] / 100])
        {
            [self getCurrentTermData];//当前期次的信息
        }else
        {
            [self gotoRecharge];
        }
    }
}
- (void)gotoRecharge
{
    YZRechargeListViewController *rechargeVc = [[YZRechargeListViewController alloc] init];
    [self.sourceController.navigationController pushViewController:rechargeVc animated:YES];
}
//获取当前期信息
- (void)getCurrentTermData
{
    NSDictionary *dict = @{
                           @"cmd":@(8026),
                           @"gameId":_param.gameId
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        
        YZLog(@"getCurrentTermData - json = %@",json);
        if(SUCCESS)
        {
            NSArray *termList = json[@"game"][@"termList"];
            if(_isStartUnionBuy && !termList.count)//发起合买才检查期号，参与合买不检查
            {
                [MBProgressHUD showError:text_sailStop];
                return ;
            }
            NSString *currentTermId = [termList lastObject][@"termId"];
            _param.termId = currentTermId;
            if(!Jump)//不跳
            {
                [MBProgressHUD showMessage:text_paying toView:nil];
                if(self.isParticipateUnionBuy)//参与合买
                {
                    [self comfirmPaticipateUnionBuy];
                }else if(self.isStartUnionBuy)//发起合买
                {
                    [self comfirmStartUnionBuy];
                }
            }else //跳转网页
            {
                [MBProgressHUD hideHUD];
            }
        }else
        {
            ShowErrorView
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.sourceController.view];
        [MBProgressHUD showError:@"亲！网络不给力"];
        YZLog(@"getCurrentTermData - error = %@",error);
    }];
}
#pragma  mark - 发起合买支付接口
- (void)comfirmStartUnionBuy
{
    NSString *phone = [YZUserDefaultTool user].mobilePhone.length ? [YZUserDefaultTool user].mobilePhone : @"";
    YZUser *user = [YZUserDefaultTool user];
    NSDictionary *dict = @{
                           @"cmd":@(8128),
                           @"userId":UserId,
                           @"gameId":_param.gameId,
                           @"userName":user.userName,
                           @"phone":phone,
                           @"termId":_param.termId,
                           @"multiple":_param.multiple,
                           @"amount":_param.amount,
                           @"ticketList":_param.ticketList,
                           @"payType":@"ACCOUNT",
                           @"title":_param.title,
                           @"description":_param.desc,
                           @"commission":_param.commission,
                           @"money":_param.money,
                           @"deposit":_param.deposit,
                           @"systemDeposit":@(1),
                           @"settings":_param.settings,
                           @"singleMoney":@(100),
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {

        YZLog(@"comfirmStartUnionBuy - json = %@",json);
        if(SUCCESS)
        {
            [MBProgressHUD hideHUD];
            //删除数据库中得所有号码球数据
            [YZStatusCacheTool deleteAllStatus];
            YZBetSuccessViewController *betSuccessVc = [[YZBetSuccessViewController alloc] init];
            betSuccessVc.payVcType = BetTypeStartUnionBuyBet;
            betSuccessVc.termCount = 1;
            _param.unionBuyUserId = [NSString stringWithFormat:@"%@", json[@"unionBuyUserId"]];
            _param.unionBuyPlanId = [NSString stringWithFormat:@"%@", json[@"unionBuyPlanId"]];
            betSuccessVc.unionbuyModel = _param;
            //跳转
            [self.sourceController.navigationController pushViewController:betSuccessVc animated:YES];
        }else
        {
            [MBProgressHUD hideHUD];//隐藏正在支付的弹框
            ShowErrorView
        }
    } failure:^(NSError *error) {

        [MBProgressHUD hideHUD];
        YZLog(@"comfirmStartUnionBuy - error = %@",error);
    }];
}
#pragma  mark - 参与合买支付接口
- (void)comfirmPaticipateUnionBuy
{
    NSString *phone = [YZUserDefaultTool user].mobilePhone.length ? [YZUserDefaultTool user].mobilePhone : @"";
    NSDictionary *dict = @{
                           @"cmd":@(8129),
                           @"userId":UserId,
                           @"payType":@"ACCOUNT",
                           @"phone":phone,
                           @"userName":_param.userName,
                           @"unionBuyPlanId":_param.unionBuyPlanId,
                           @"planId":_param.planId,
                           @"money":_param.money,
                           @"singleMoney":_param.singleMoney,
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        
        YZLog(@"comfirmPaticipateUnionBuy - json = %@",json);
        if(SUCCESS)
        {
            [MBProgressHUD hideHUD];
            //删除数据库中得所有号码球数据
            [YZStatusCacheTool deleteAllStatus];
            YZBetSuccessViewController *betSuccessVc = [[YZBetSuccessViewController alloc] init];
            _param.unionBuyUserId = [NSString stringWithFormat:@"%@", json[@"unionBuyUserId"]];
            _param.unionBuyPlanId = [NSString stringWithFormat:@"%@", json[@"unionBuyPlanId"]];
            betSuccessVc.payVcType = BetTypeParticipateUnionBuyBet;
            betSuccessVc.termCount = 1;
            betSuccessVc.unionbuyModel = _param;
            //跳转
            [self.sourceController.navigationController pushViewController:betSuccessVc animated:YES];
        }else
        {
            [MBProgressHUD hideHUD];//隐藏正在支付的弹框
            ShowErrorView
        }
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUD];
        YZLog(@"comfirmPaticipateUnionBuy - error = %@",error);
    }];
}
- (void)setIsParticipateUnionBuy:(BOOL)isParticipateUnionBuy
{
    _isParticipateUnionBuy = isParticipateUnionBuy;
    _isStartUnionBuy = !isParticipateUnionBuy;
}
- (void)setIsStartUnionBuy:(BOOL)isStartUnionBuy
{
    _isStartUnionBuy = isStartUnionBuy;
    _isParticipateUnionBuy = !isStartUnionBuy;
}

@end
