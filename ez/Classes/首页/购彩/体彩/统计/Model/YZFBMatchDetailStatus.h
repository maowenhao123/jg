//
//  YZFBMatchDetailStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZRecordStatus.h"
#import "YZRecentStatus.h"
#import "YZLeagueRankStatus.h"
#import <Foundation/Foundation.h>

@interface YZFBMatchDetailStatus : NSObject

@property (nonatomic, strong) YZRecordStatus *record;//历史交锋
@property (nonatomic, strong) YZRecentStatus *recent;//近期战绩
@property (nonatomic, strong) YZLeagueRankStatus *leagueRank;//联赛排名

@end
