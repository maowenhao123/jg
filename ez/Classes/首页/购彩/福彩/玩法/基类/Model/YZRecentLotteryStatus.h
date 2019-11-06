//
//  YZRecentLotteryStatus.h
//  ez
//
//  Created by apple on 14-11-17.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    KhistoryCellTagWan = 10000,
    KhistoryCellTagQian = 1000,
    KhistoryCellTagBai = 100,
    KhistoryCellTagZero = 0
}KhistoryCellTag;

@interface YZRecentLotteryStatus : NSObject

@property (nonatomic, copy) NSString *termId;
@property (nonatomic, copy) NSString *winNumber;
@property (nonatomic, assign) KhistoryCellTag cellTag;

@end
