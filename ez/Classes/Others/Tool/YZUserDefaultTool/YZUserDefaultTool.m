//
//  YZUserDefaultTool.m
//  ez
//
//  Created by apple on 14-9-1.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZUserDefaultTool.h"

#define YZUserFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"user.data"]
#define YZThirdPartyFile [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"thirdParty.data"]

@implementation YZUserDefaultTool

+ (void)saveObject:(NSString *)object forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}
+ (NSString *)getObjectForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return  [defaults stringForKey:key];
}
+ (void)saveInt:(int)integer forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:integer forKey:key];
    [defaults synchronize];
}
+ (int)getIntForKey:(NSString *)key//取出整型
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return (int)[defaults integerForKey:key];
}
+ (void)removeObjectForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}
+ (void)saveUser:(YZUser *)user
{
     [NSKeyedArchiver archiveRootObject:user toFile:YZUserFile];
}
+ (YZUser *)user
{
    YZUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:YZUserFile];
    return user;
}
+ (void)saveThirdPartyStatus:(YZThirdPartyStatus *)thirdPartyStatus
{
    [NSKeyedArchiver archiveRootObject:thirdPartyStatus toFile:YZThirdPartyFile];
}
+ (YZThirdPartyStatus *)thirdPartyStatus
{
    YZThirdPartyStatus *thirdPartyStatus = [NSKeyedUnarchiver unarchiveObjectWithFile:YZThirdPartyFile];
    return thirdPartyStatus;
}

@end
