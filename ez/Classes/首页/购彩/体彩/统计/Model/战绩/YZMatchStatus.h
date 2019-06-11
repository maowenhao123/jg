//
//  YZMatchStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZMatchCellStatus.h"

@interface YZMatchStatus : NSObject

@property (nonatomic, assign) int num;//近几次交锋
@property (nonatomic, copy) NSString *name;//队名
@property (nonatomic, assign) int win;//胜数
@property (nonatomic, assign) int draw;//平数
@property (nonatomic, assign) int lost;//负数
@property (nonatomic, strong) NSArray <YZMatchCellStatus *>*matches;//近几场比赛

@end
