//
//  YZAliPayOrder.h
//  ez
//
//  Created by apple on 16/11/21.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZAliPayOrder : NSObject

+ (void)AliPayOrderAmount:(NSNumber *)amount paymentId:(NSString *)paymentId clientId:(NSString *)clientId;

@end
