//
//  YZUser.h
//  ez
//
//  Created by apple on 14-10-28.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZUserInfo.h"
#import "YZWeixin.h"
@interface YZUser : NSObject

@property (nonatomic, strong) NSNumber *balance;//彩金
@property (nonatomic, strong) NSNumber *bonus;//奖金
@property (nonatomic, strong) NSNumber *grade;//积分
@property (nonatomic, copy) NSString *mobilePhone;//手机号码
@property (nonatomic, copy) NSString *nickName;//昵称
@property (nonatomic, copy) NSString *userId;//用户id
@property (nonatomic, copy) NSString *userName;//用户名
@property (nonatomic, strong) NSArray *banks;//银行信息
@property (nonatomic, assign) BOOL modifyPwd;//是否已经设置密码
@property (nonatomic, strong) YZUserInfo *userInfo;//用户信息
@property (nonatomic, strong) YZWeixin *weixin;
@end

