//
//  YZFBMatchDetailStandingsStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZRoundStatus.h"
#import "YZMatchStatus.h"
#import "YZMatchFutureStatus.h"

@interface YZFBMatchDetailStandingsStatus : NSObject

@property (nonatomic, strong) YZRoundStatus *round;//交战双方信息
@property (nonatomic, strong) YZMatchStatus *history;//历史交锋
@property (nonatomic, strong) YZMatchStatus *homeRecent;//主队近期战绩
@property (nonatomic, strong) YZMatchStatus *awayRecent;//客队近期战绩
@property (nonatomic, strong) NSArray <YZMatchFutureStatus *>*homeFuture;//主队未来赛事
@property (nonatomic, strong) NSArray <YZMatchFutureStatus *>*awayFuture;//客队未来赛事
@property (nonatomic, assign) BOOL getData;//是否请求过数据
@property (nonatomic, assign) BOOL historyClose;//是否关闭(历史交锋)
@property (nonatomic, assign) BOOL recentClose;//是否关闭(近期战绩)
@property (nonatomic, assign) BOOL futureClose;//是否关闭(未来赛事)

@end
