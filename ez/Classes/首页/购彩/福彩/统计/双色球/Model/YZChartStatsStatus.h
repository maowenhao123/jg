//
//  YZChartStatsStatus.h
//  ez
//
//  Created by apple on 2017/3/17.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZChartNumberStatsStatus.h"

@interface YZChartStatsStatus : NSObject

@property (nonatomic, strong) YZChartNumberStatsStatus * redstat;//红球统计
@property (nonatomic, strong) YZChartNumberStatsStatus * bluestat;//蓝球统计
@property (nonatomic, strong) YZChartNumberStatsStatus * renxuan;//任选统计

@end
