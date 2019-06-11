//
//  YZScoreRowStatus.h
//  ez
//
//  Created by apple on 17/2/17.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZIntegralStatus.h"

@interface YZScoreRowStatus : NSObject

@property (nonatomic, copy) NSString *title;//积分榜title，如:2017法甲积分榜
@property (nonatomic, strong) NSArray <YZIntegralStatus *> *scores;//积分榜对象集合
@property (nonatomic, assign) BOOL close;//是否关闭

@end
