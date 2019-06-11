//
//  YZChartBallStatus.h
//  ez
//
//  Created by apple on 17/3/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZChartBallStatus : NSObject

@property (nonatomic, copy) NSString * number;//号码
@property (nonatomic, assign, getter = isSelected) BOOL selected;//是否被选中
@property (nonatomic, assign, getter = isBlue) BOOL blue;//是否是蓝球


@end
