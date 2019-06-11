//
//  YZChartStatus.m
//  ez
//
//  Created by apple on 2017/3/17.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZChartStatus.h"

@implementation YZChartStatus

- (NSArray <YZChartDataStatus *> *)data
{
    if (!_data) {
        _data = [NSArray array];
    }
    return _data;
}

@end
