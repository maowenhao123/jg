//
//  YZGameIndosStatus.h
//  ez
//
//  Created by apple on 16/5/9.
//  Copyright (c) 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZGameIndosStatus : NSObject

@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *matchGames;
@property (nonatomic, strong) NSNumber* prizePool;
@property (nonatomic, strong) NSNumber* saleStatus;
@property (nonatomic, strong) NSNumber* termId;

@end
