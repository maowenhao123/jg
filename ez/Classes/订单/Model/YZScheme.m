//
//  YZScheme.m
//  ez
//
//  Created by apple on 14/12/31.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZScheme.h"
#import "YZTicketList.h"
#import "YZOrder.h"

@implementation YZScheme
- (NSDictionary *)objectClassInArray
{
    return @{@"ticketList" : [YZTicketList class],@"orderList" : [YZOrder class]};
}
MJCodingImplementation
@end
