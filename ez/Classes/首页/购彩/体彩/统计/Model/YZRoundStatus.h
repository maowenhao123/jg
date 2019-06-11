//
//  YZRoundStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZTeamStatus.h"

@interface YZRoundStatus : NSObject

@property (nonatomic, assign) long time;//比赛时间
@property (nonatomic, strong) YZTeamStatus *home;//主队排名
@property (nonatomic, strong) YZTeamStatus *away;//客队排名

@end
