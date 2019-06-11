//
//  YZRechargeSuccessViewController.h
//  ez
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 9ge. All rights reserved.
//

typedef enum : NSUInteger {
    WinXinRechargeSuccess = 0,//微信充值成功
    AliPayRechargeSuccess = 1,//支付宝充值成功
    PhoneCardRechargeSuccess = 2,//手机卡充值成功
    BonusCardRechargeSuccess = 3,//彩金卡充值成功
    UPayRechargeSuccess = 4,//银联充值成功
    BankCardRechargeSuccess = 5,//银行卡充值成功
} RechargeSuccessType;

#import "YZBaseViewController.h"

@interface YZRechargeSuccessViewController : YZBaseViewController

@property (nonatomic, assign) RechargeSuccessType rechargeSuccessType;

@property (nonatomic, assign) BOOL isOrderPay;//订单支付跳转来的

@end
