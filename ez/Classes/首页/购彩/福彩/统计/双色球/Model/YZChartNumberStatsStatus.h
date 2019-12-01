//
//  YZChartNumberStatsStatus.h
//  ez
//
//  Created by apple on 2017/3/17.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZChartSortStatsStatus.h"

@interface YZChartNumberStatsStatus : NSObject

@property (nonatomic, strong) YZChartSortStatsStatus * stat30;//近30期
@property (nonatomic, strong) YZChartSortStatsStatus * stat50;//近50期
@property (nonatomic, strong) YZChartSortStatsStatus * stat100;//近100期
@property (nonatomic, strong) YZChartSortStatsStatus * stat200;//近200期

@end
