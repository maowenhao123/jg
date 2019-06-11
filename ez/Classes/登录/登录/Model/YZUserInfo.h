//
//  YZUserInfo.h
//  ez
//
//  Created by apple on 14-10-28.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZUserInfo : NSObject

@property (nonatomic, copy) NSString *cardno;//身份证号码
@property (nonatomic, copy) NSString *lastdevice;
@property (nonatomic, copy) NSString *lasttime;
@property (nonatomic, copy) NSString *realname;//真实姓名
@property (nonatomic, copy) NSString *registdate;//注册时间
@property (nonatomic, copy) NSString *avatarUrl;//头像url


@end
