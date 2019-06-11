//
//  YZOverUnderCellStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZOddsCellStatus.h"
#import "YZOverUnderStatus.h"

@interface YZOverUnderCellStatus : YZOddsCellStatus

@property (nonatomic, strong) YZOverUnderStatus *initialOdds;
@property (nonatomic, strong) YZOverUnderStatus *realTimeOdds;

@end
