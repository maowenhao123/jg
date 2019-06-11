//
//  YZWithdrawalRecordStatus.h
//  ez
//
//  Created by apple on 16/10/19.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZWithdrawalRecordStatus : NSObject

@property (nonatomic, copy) NSString *userId;//用户ID
@property (nonatomic, copy) NSString *accountName;//
@property (nonatomic, copy) NSString *accountNumber;//银行卡号
@property (nonatomic, copy) NSString *bank;
@property (nonatomic, copy) NSString *createTime;//创建时间
@property (nonatomic, strong) NSNumber *money;//提现金额
@property (nonatomic, copy) NSString *petitionId;
@property (nonatomic, copy) NSString *status;//状态
@property (nonatomic, copy) NSString *statusDesc;//状态描述
@property (nonatomic, copy) NSString *endTime;

@end
