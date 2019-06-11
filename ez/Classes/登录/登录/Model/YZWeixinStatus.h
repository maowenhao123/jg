//
//  YZWeixinStatus.h
//  ez
//
//  Created by apple on 15/3/6.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZWeixin.h"


@interface YZWeixinStatus : NSObject

@property (nonatomic, strong) NSNumber *giftMoney;
@property (nonatomic, strong) NSNumber *grade;
@property (nonatomic, strong) NSNumber *balance;
@property (nonatomic, strong) NSNumber *bindStatus;//绑定状态,0 未绑定，1已绑定
@property (nonatomic, strong) NSNumber *bonus;
@property (nonatomic, strong) YZWeixin *weixin;

@property (nonatomic, copy) NSString *code;//自定义，非返回数据
@property (nonatomic, copy) NSString *userId;
@end
