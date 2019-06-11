//
//  YZChartStatus.h
//  ez
//
//  Created by apple on 2017/3/17.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZChartDataStatus.h"
#import "YZChartStatsStatus.h"

@interface YZChartStatus : NSObject

@property (nonatomic, copy) NSString * issueId;//期次

@property (nonatomic, strong) NSArray <YZChartDataStatus * > *data;//遗漏集合

@property (nonatomic, strong) YZChartStatsStatus * stats;//统计集合

@end
