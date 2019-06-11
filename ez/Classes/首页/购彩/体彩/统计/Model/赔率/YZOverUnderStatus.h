//
//  YZOverUnderStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZOverUnderStatus : NSObject

@property (nonatomic, copy) NSString *up;//上盘
@property (nonatomic, assign) int upTrend;//上盘趋势
@property (nonatomic, copy) NSString *bet;//盘口
@property (nonatomic, copy) NSString *low;//下盘水位
@property (nonatomic, assign) int lowTrend;//下盘趋势
@property (nonatomic, copy) NSString *updateTime;//更新时间

@end
