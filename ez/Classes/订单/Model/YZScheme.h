//
//  YZScheme.h
//  ez
//
//  Created by apple on 14/12/31.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZOrder.h"

@interface YZScheme : NSObject

@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *bonus;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, strong) NSNumber *finishedTermCount;
@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, strong) NSNumber *pay;
@property (nonatomic, copy) NSString *schemeId;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *termCount;
@property (nonatomic, strong) NSNumber *multiple;
@property (nonatomic, strong) NSMutableArray *ticketList;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, strong) NSNumber *winStop;
@property (nonatomic, copy) NSString *statusDesc;
@property (nonatomic, copy) NSString *ishitDesc;
@property (nonatomic, copy) NSString *noHitDesc;

@end
