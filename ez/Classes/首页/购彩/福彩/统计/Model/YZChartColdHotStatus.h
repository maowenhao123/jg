//
//  YZChartColdHotStatus.h
//  ez
//
//  Created by apple on 17/3/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZChartBallStatus.h"

@interface YZChartColdHotStatus : NSObject

@property (nonatomic, strong) YZChartBallStatus *ballStatus;//号码球数据
@property (nonatomic ,assign) NSInteger number;//号码
@property (nonatomic ,assign) NSInteger thirty;//30期的
@property (nonatomic ,assign) NSInteger fifty;//50期的
@property (nonatomic ,assign) NSInteger hundred;//100期的
@property (nonatomic ,assign) NSInteger miss;//遗漏

@property (nonatomic, assign) BOOL max_thirty;
@property (nonatomic, assign) BOOL max_fifty;
@property (nonatomic, assign) BOOL max_hundred;
@property (nonatomic, assign) BOOL max_miss;
@property (nonatomic, assign) BOOL have_miss_data;

@end
