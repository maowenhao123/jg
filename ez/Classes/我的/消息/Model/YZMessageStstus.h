//
//  YZMessageStstus.h
//  ez
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZMessageType.h"

@interface YZMessageStstus : NSObject

@property (nonatomic, copy) NSString *jpushMessageId;//id
@property (nonatomic, copy) NSString *title;//标题
@property (nonatomic, copy) NSString *intro;//简介
@property (nonatomic, strong) YZMessageType *type;//类型
@property (nonatomic, copy) NSString *ext;//扩展信息
@property (nonatomic, assign) long long createTime;//创建时间
@property (nonatomic, assign) int status;//状态 2:已读;4:未读

@end
