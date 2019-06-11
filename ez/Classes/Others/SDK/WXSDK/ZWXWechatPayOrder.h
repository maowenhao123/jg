//
//  WechatPayOrder.h
//  ez
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWXWechatPayOrder : NSObject

+ (void)ZWXWechatPayOrderAmount:(NSNumber *)amount paymentId:(NSString *)paymentId;

@end
