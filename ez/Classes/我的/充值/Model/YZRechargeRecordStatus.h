//
//  YZRechargeRecordStatus.h
//  ez
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZRechargeRecordStatus : NSObject

@property (nonatomic, copy) NSString *chargeId;
@property (nonatomic, copy) NSString *fund;//ALIPAY
@property (nonatomic, copy) NSString *fundName;//支付宝, 前端使用此值给用户展示即可
@property (nonatomic, strong) NSNumber *money;
@property (nonatomic, copy) NSString *status;//状态
@property (nonatomic, copy) NSString * createTime;//发起充值时间
@property (nonatomic, copy) NSString *statusDesc;

@end
