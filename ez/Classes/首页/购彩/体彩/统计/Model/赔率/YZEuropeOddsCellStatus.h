//
//  YZEuropeOddsCellStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZOddsCellStatus.h"
#import "YZEuropeOddsStatus.h"

@interface YZEuropeOddsCellStatus : YZOddsCellStatus

@property (nonatomic, strong) YZEuropeOddsStatus *initialOdds;
@property (nonatomic, strong) YZEuropeOddsStatus *realTimeOdds;

@end
