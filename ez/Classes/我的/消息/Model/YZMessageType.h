//
//  YZMessageType.h
//  ez
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZMessageType : NSObject

@property (nonatomic, assign) int type;//类型 1:消息;3:通知
@property (nonatomic, copy) NSString *name;//名称
@property (nonatomic, copy) NSString *url;//图片url

@end
