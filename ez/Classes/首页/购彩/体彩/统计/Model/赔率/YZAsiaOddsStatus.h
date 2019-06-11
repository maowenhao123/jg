//
//  YZAsiaOddsStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZAsiaOddsStatus : NSObject

@property (nonatomic, copy) NSString *above;//主队水位
@property (nonatomic, assign) int aboveTrend;//主队水位趋势
@property (nonatomic, copy) NSString *bet;//盘口
@property (nonatomic, copy) NSString *below;//客队水位
@property (nonatomic, assign) int belowTrend;//客队水位趋势
@property (nonatomic, copy) NSString *updateTime;//更新时间

@end
