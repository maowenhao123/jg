//
//  YZChartDataStatus.h
//  ez
//
//  Created by apple on 2017/3/17.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZChartDataStatus : NSObject

@property (nonatomic, copy) NSString * issue;//期次
@property (nonatomic, strong) NSArray <NSString *> * winNumber;//开奖号码
@property (nonatomic, strong) NSDictionary * missNumber;//遗漏
@property (nonatomic, strong) NSDictionary * overNumber;//重号个数 11选5有，双色球大乐透没有

@end
