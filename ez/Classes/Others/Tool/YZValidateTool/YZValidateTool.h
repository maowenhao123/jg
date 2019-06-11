//
//  YZValidateTool.h
//  ez
//
//  Created by apple on 14-10-15.
//  Copyright (c) 2014年 9ge. All rights reserved.

//  验证各种号码工具类
#import <Foundation/Foundation.h>

@interface YZValidateTool : NSObject
//纯数字
+ (BOOL)validateNumber:(NSString*)number;

//银行卡号码
+ (BOOL) validateCardNumber:(NSString *)cardNumber;

//邮箱
+ (BOOL) validateEmail:(NSString *)email;

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;


//用户名
+ (BOOL) validateUserName:(NSString *)name;


//密码
+ (BOOL) validatePassword:(NSString *)passWord;

//昵称
+ (BOOL) validateNickname:(NSString *)nickname;

//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

@end
