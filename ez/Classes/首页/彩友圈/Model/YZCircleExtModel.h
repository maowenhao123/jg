//
//  YZCircleExtModel.h
//  ez
//
//  Created by dahe on 2019/6/25.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZTicketList.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZCircleExtModel : NSObject

@property (nonatomic, strong) NSNumber * commission;
@property (nonatomic, copy) NSString * gameId;
@property (nonatomic, copy) NSString * gameName;
@property (nonatomic, strong) NSNumber * issue;
@property (nonatomic, copy) NSString * matchGames;
@property (nonatomic, strong) NSNumber * money;
@property (nonatomic, strong) NSNumber * multiple;
@property (nonatomic, copy) NSString * orderId;
@property (nonatomic, strong) NSNumber * settings;
@property (nonatomic, copy) NSString * unionBuyUserId;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, strong) NSArray * ticketList;

@end

NS_ASSUME_NONNULL_END
