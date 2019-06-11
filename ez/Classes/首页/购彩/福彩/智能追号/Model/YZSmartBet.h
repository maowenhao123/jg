//
//  YZSmartBet.h
//  ez
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZSmartBet : NSObject

@property (nonatomic, copy) NSString *termId;//期号
@property (nonatomic, copy) NSString *multiple;//倍数
@property (nonatomic, copy) NSString *total;//累计
@property (nonatomic, copy) NSString *bonus;//奖金
@property (nonatomic, copy) NSString *profit;//盈利
@property (nonatomic, assign) BOOL isTomorrow;//是否是明天的
@property (nonatomic, copy) NSString *week;
@property (nonatomic, copy) NSString *dateStr;

@end
