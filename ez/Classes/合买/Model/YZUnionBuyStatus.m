//
//  YZUnionBuyStatus.m
//  ez
//
//  Created by apple on 15/3/13.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import "YZUnionBuyStatus.h"
#import "MJExtension.h"

@implementation YZUnionBuyStatus
@synthesize followMoney;
- (NSDictionary *)objectClassInArray
{
    return @{@"tickets" : [YZTicketList class]};
}
- (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"desc" : @"description"};
}

MJCodingImplementation

@end
