//
//  YZBankCardRechargeViewController.h
//  ez
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"

@interface YZBankCardRechargeViewController : YZBaseViewController

@property (nonatomic, copy) NSString *paymentId;//支付方式
@property (nonatomic, assign) BOOL isOrderPay;//订单支付跳转来的
@property (nonatomic, copy) NSString *detailUrl;
@property (nonatomic, copy) NSString *intro;//说明

@end
