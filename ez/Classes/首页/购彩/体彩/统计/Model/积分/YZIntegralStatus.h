//
//  YZIntegralStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZIntegralStatus : NSObject

@property (nonatomic, assign) int ranking;//排名
@property (nonatomic, copy) NSString * teamName;//球队名
@property (nonatomic, assign) int finished;//已比赛场数
@property (nonatomic, assign) int win;//胜场数
@property (nonatomic, assign) int draw;//平场数
@property (nonatomic, assign) int loss;//负场数
@property (nonatomic, assign) int goal;//得(进)球数
@property (nonatomic, assign) int lossGoal;//失球数
@property (nonatomic, assign) int pureGoal;//净胜球数
@property (nonatomic, assign) int score;//积分

@end
