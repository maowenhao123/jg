//
//  YZUnionBuyRecord.h
//  ez
//
//  Created by apple on 15/3/30.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZUnionBuyRecord : NSObject
/**
 createTime = "2015-03-25 17:18:33";
 gameId = F01;
 gameName = "\U53cc\U8272\U7403";
 hitmoney = 0;
 ishit = 10;
 issue = 2015034;
 money = 100;
 status = 10;
 ticketStatus = 10;
 unionBuyPlanId = 150325171833010000032;
 unionBuyUserId = 150325171833010000041;
 userType = 1;
 */
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, copy) NSString *gameName;
@property (nonatomic, strong) NSNumber *hitmoney;
@property (nonatomic, strong) NSNumber *ishit;
@property (nonatomic, copy) NSString *issue;
@property (nonatomic, strong) NSNumber *money;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy) NSNumber *ticketStatus;
@property (nonatomic, copy) NSString *unionBuyPlanId;
@property (nonatomic, copy) NSString *unionBuyUserId;
@property (nonatomic, strong) NSNumber *userType;
@end
