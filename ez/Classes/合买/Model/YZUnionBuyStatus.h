//
//  YZUnionBuyStatus.h
//  ez
//
//  Created by apple on 15/3/13.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZTerm.h"
#import "YZTicketList.h"

@interface YZUnionBuyStatus : NSObject

@property (nonatomic, strong) NSNumber *deposit;//个人保底
@property (nonatomic, copy) NSString *desc;//合买方案描述
@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, copy) NSString *gameName;
@property (nonatomic, strong) NSNumber *grade;//战绩
@property (nonatomic, copy) NSString *issue;
@property (nonatomic, copy) NSString *planId;//合买方案ID
@property (nonatomic, strong) NSNumber *putTop;//手工置顶
@property (nonatomic, strong) NSNumber *schedule;//进度
@property (nonatomic, strong) NSNumber *settings;//保密设置
@property (nonatomic, strong) NSNumber *singleMoney;//单份金额
@property (nonatomic, strong) NSNumber *surplusMoney;//剩余金额
@property (nonatomic, copy) NSString *title;//合买方案标题
@property (nonatomic, strong) NSNumber *totalAmount;//合买方案总金额
@property (nonatomic, copy) NSString *unionBuyPlanId;
@property (nonatomic, copy) NSString *userName;//用户名
@property (nonatomic, copy) NSString *betType;
@property (nonatomic, strong) NSNumber *commission;//佣金
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *sysTime;
@property (nonatomic, strong) NSNumber *multiple;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *systemDeposit;//系统保底
@property (nonatomic, strong) YZTerm *term;
@property (nonatomic, strong) NSNumber *ticketStatus;
@property (nonatomic, strong) NSArray *tickets;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) NSNumber *userType;
@property (nonatomic, copy) NSString *unionBuyUserId;
@property (nonatomic, strong) NSNumber *money;
@property (nonatomic,strong) NSNumber *hitMoney;
@property (nonatomic,copy) NSString *statusDesc;
@property (nonatomic,copy) NSString *isHitDesc;
@property (nonatomic,copy) NSString *ticketStatusDesc;
@property (nonatomic,copy) NSString *userTypeDesc;
@property (nonatomic,copy) NSString *winNumber;

//自定义
@property (nonatomic,assign) BOOL search;
@property (nonatomic, assign,getter=isAccessoryBtnSelected) BOOL accessoryBtnSelected;//accessoryBtn的选中状态
@property (nonatomic, copy) NSString *followMoney;//参与金额
@property (nonatomic, copy) NSString *moneyOfTotal;///占方案总金额

@end
