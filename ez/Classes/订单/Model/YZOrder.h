//
//  YZOrder.h
//  ez
//
//  Created by apple on 14/12/27.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZTerm.h"
#import "YZTicketList.h"

@interface YZOrder : NSObject

@property (nonatomic, copy) NSNumber *amount;
@property (nonatomic, strong) NSNumber *bonus;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, strong) NSNumber *hitstatus;
@property (nonatomic, strong) NSNumber *ishit;
@property (nonatomic, strong) NSNumber *multiple;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, strong) NSNumber *refundstatus;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) YZTerm *term;
@property (nonatomic, copy) NSString *winNumber;
@property (nonatomic, copy) NSString *termId;
@property (nonatomic, strong) NSArray *ticketList;
@property (nonatomic, copy) NSString *statusDesc;
@property (nonatomic, copy) NSString *ishitDesc;
@property (nonatomic,assign) BOOL openPrize;//返回true：表示今日开奖，false：表示非今日开奖
@property (nonatomic, copy) NSString *betType;
@property (nonatomic, copy) NSString *codes;
@property (nonatomic, copy) NSString *playType;


@end
