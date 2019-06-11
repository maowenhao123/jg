//
//  YZOrderStatus.h
//  ez
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZOrderStatus : NSObject

@property (nonatomic, copy) NSString *amount;//花钱总数
@property (nonatomic, copy) NSString *bonus;//中奖金额
@property (nonatomic, copy) NSString *count;//投注数
@property (nonatomic, copy) NSString *createTime;//时间
@property (nonatomic, copy) NSString *gameId;//玩法名字
@property (nonatomic, copy) NSString *hitstatus;
@property (nonatomic, assign) BOOL ishit;//是否中奖
@property (nonatomic, copy) NSString *multiple;//投注倍数
@property (nonatomic, copy) NSString *orderId;//订单id
@property (nonatomic, copy) NSString *refundstatus;//退款状态
@property (nonatomic, copy) NSString *status;//订单状态
@property (nonatomic, copy) NSString *termId;//期数
@property (nonatomic, copy) NSString *statusDesc;//状态描述
@property (nonatomic, strong) NSNumber *orderType;//0普通 1赠送

@property (nonatomic, copy) NSString *finishedTermCount;//已完成的期数
@property (nonatomic, copy) NSString *pay;//
@property (nonatomic, copy) NSString *schemeId;//追号Id
@property (nonatomic, copy) NSString *termCount;//期数
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL winStop;//中奖后停追

@property (nonatomic,copy) NSString *gameName;
@property (nonatomic,copy) NSString *hitmoney;
@property (nonatomic,strong) NSNumber *money;
@property (nonatomic,copy) NSString *issue;
@property (nonatomic,strong) NSNumber *ticketStatus;
@property (nonatomic, copy) NSString *unionBuyPlanId;
@property (nonatomic, copy) NSString *unionBuyUserId;
@property (nonatomic,strong) NSNumber *userType;
@property (nonatomic,copy) NSString *isHitDesc;
@property (nonatomic,copy) NSString *ticketStatusDesc;
@property (nonatomic,copy) NSString *userTypeDesc;
@property (nonatomic, copy) NSString *noHitDesc;

//自定义
@property (nonatomic, copy) NSString *month;//月份
@property (nonatomic,assign) NSInteger index;

@end
