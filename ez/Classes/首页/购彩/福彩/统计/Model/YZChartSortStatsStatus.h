//
//  YZChartSortStatsStatus.h
//  ez
//
//  Created by apple on 2017/3/17.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZChartSortStatsStatus : NSObject

@property (nonatomic, strong) NSArray * count;//出现次数
@property (nonatomic, strong) NSArray * avgMiss;//平均遗漏
@property (nonatomic, strong) NSArray * maxMiss;//最大遗漏
@property (nonatomic, strong) NSArray * maxSeries;//最大连出

@end
