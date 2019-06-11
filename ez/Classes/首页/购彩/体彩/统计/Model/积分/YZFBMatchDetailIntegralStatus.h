//
//  YZFBMatchDetailIntegralStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZRoundStatus.h"
#import "YZScoreRowStatus.h"

@interface YZFBMatchDetailIntegralStatus : NSObject

@property (nonatomic, strong) YZRoundStatus *round;//交战双方信息
@property (nonatomic, strong) NSArray <YZScoreRowStatus *> *totalScores;//总积分
@property (nonatomic, strong) NSArray <YZScoreRowStatus *> *homeScores;//主场积分
@property (nonatomic, strong) NSArray <YZScoreRowStatus *> *awayScores;//客场积分

@end
