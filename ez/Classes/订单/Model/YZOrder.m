//
//  YZOrder.m
//  ez
//
//  Created by apple on 14/12/27.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZOrder.h"
#import "YZTicketList.h"
#import "YZMatchInfosStatus.h"

@implementation YZOrder
- (NSDictionary *)objectClassInArray
{
    return @{@"ticketList" : [YZTicketList class]};
}
MJCodingImplementation
@end
