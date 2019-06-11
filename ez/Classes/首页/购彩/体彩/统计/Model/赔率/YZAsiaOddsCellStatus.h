//
//  YZAsiaOddsCellStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZOddsCellStatus.h"
#import "YZAsiaOddsStatus.h"

@interface YZAsiaOddsCellStatus : YZOddsCellStatus

@property (nonatomic, strong) YZAsiaOddsStatus *initialOdds;
@property (nonatomic, strong) YZAsiaOddsStatus *realTimeOdds;

@end
