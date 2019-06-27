//
//  YZStatusCacheTool.h
//  ez
//
//  Created by apple on 14-9-15.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZBetStatus.h"

@interface YZStatusCacheTool : NSObject
//存储号码数据数组
+ (void)saveStatuses:(NSArray *)statusArray;
//存储一组号码
+ (void)saveStatus:(YZBetStatus *)status;
+ (void)saveUserStatusWith:(id)object;//存储用户数据为data数据
//获取存储的所有数据
+ (NSArray *)getStatues;//获取存储的号码数据
+ (void)deleteAllStatus;//删除存储的号码数据
+ (void)deleteStatusWithTag:(int)tag;

+ (NSArray *)getUserStatues;//获取用户信息
+ (void)deleteUserStatus;//删除用户数据

@end
