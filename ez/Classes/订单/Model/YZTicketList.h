//
//  YZTicketList.h
//  ez
//
//  Created by apple on 14/12/27.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZTicketList : NSObject

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, copy) NSString *betType;
@property (nonatomic, strong) NSNumber *bonus;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, strong) NSNumber *ishit;
@property (nonatomic, strong) NSNumber *multiple;
@property (nonatomic, copy) NSString *numbers;
@property (nonatomic, copy) NSString *playType;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy) NSString *ticketId;
@property (nonatomic, copy) NSString *statusDesc;

@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *ticketTime;
@property (nonatomic, copy) NSString *winningNumber;

/**
 返回  周四001 [让球胜(4.000),让球负(3.000)] * 周四001 [让球胜(4.000),让球负(3.000)]
 orderCodes格式："02|201501073001|3@1.430;02|201501073002|3@1.390;02|201501073003|3@1.540"
 */
+ (NSString *)getTicketInfos:(NSArray *)orderCodes numbers:(NSArray *)numbers gameId:(NSString *)gameId;

@end
