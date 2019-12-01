//
//  YZRechargeBaseViewController.h
//  ez
//
//  Created by apple on 14-10-28.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"
#import "JSON.h"
#import "YZRechargeSuccessViewController.h"
#import "YZDecimalTextField.h"

@interface YZRechargeBaseViewController : YZBaseViewController

@property (nonatomic, weak) YZDecimalTextField *amountTextTield;
@property (nonatomic, weak) UILabel *tishiLabel;
@property (nonatomic, weak) UIButton * rechargeExplainBtn;
@property (nonatomic, assign) BOOL isOrderPay;//订单支付跳转来的
@property (nonatomic, copy) NSString *paymentId;//支付方式
@property (nonatomic, copy) NSString *detailUrl;
@property (nonatomic, copy) NSString *intro;//说明

@end
