//
//  YZTerm.h
//  ez
//
//  Created by apple on 14-11-26.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZGrades.h"

@interface YZTerm : NSObject
@property (nonatomic, strong) NSNumber *prizePool;
@property (nonatomic, copy) NSString *openWinTime;
@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, copy) NSString *winNumber;
@property (nonatomic, strong) NSNumber *saleStatus;
@property (nonatomic, strong) YZGrades *details;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *termId;

@property (nonatomic, copy) NSString *matchGames;
@end
