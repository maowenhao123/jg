//
//  YZUserDefaultTool.h
//  ez
//
//  Created by apple on 14-9-1.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZWeixinStatus.h"
@class YZUser;
@class YZThirdPartyStatus;

@interface YZUserDefaultTool : NSObject

+ (void)saveObject:(NSString *)object forKey:(NSString *)key;//保存键值
+ (NSString *)getObjectForKey:(NSString *)key;//取出值

+ (void)saveInt:(int)integer forKey:(NSString *)key;//保存整型
+ (int)getIntForKey:(NSString *)key;//取出整型

+ (void)removeObjectForKey:(NSString *)key;//移除键值

+ (void)saveUser:(YZUser *)user;//存储用户所有信息

+ (YZUser *)user;//取出用户所有信息

+ (void)saveThirdPartyStatus:(YZThirdPartyStatus *)thirdPartyStatus;//存储第三方的所有信息

+ (YZThirdPartyStatus *)thirdPartyStatus;//取出第三方所有信息

@end
