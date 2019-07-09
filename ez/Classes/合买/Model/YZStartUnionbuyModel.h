//
//  YZStartUnionbuyModel.h
//  ez
//
//  Created by 毛文豪 on 2017/7/29.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZStartUnionbuyModel : NSObject

@property (nonatomic, strong) NSNumber *cmd;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, strong) NSNumber *operateType;
@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSNumber *termCount;

//下面是参与合买必须参数
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *unionBuyPlanId;
@property (nonatomic, copy) NSString *planId;
@property (nonatomic, copy) NSNumber *money;
/**
 *  单份金额
 */
@property (nonatomic, copy) NSNumber *singleMoney;
@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, copy) NSString *termId;

//下面是发起合买必须参数
@property (nonatomic, copy) NSNumber *multiple;
@property (nonatomic, copy) NSNumber *amount;
@property (nonatomic, strong) NSArray *ticketList;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
/**
 *  方案提成
 */
@property (nonatomic, copy) NSNumber *commission;
/**
 *  个人保底
 */
@property (nonatomic, copy) NSNumber *deposit;
/**
 *  保密设置
 */
@property (nonatomic, copy) NSNumber *settings;

@property (nonatomic, copy) NSString *unionBuyUserId;

@end
