//
//  YZFbasketBallTool.h
//  ez
//
//  Created by 毛文豪 on 2018/5/29.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZFbasketBallTool : NSObject
//自由过关
+ (NSMutableArray *)computeBetCountAndPrizeRangeWithBetArray:(NSMutableArray *)betArray playWays:(NSArray *)playWayArray selectedPlayType:(int)selectedPlayType;
/**
 *  可选择的玩法
 */
+ (int)getMaxWayCountByStatusArray:(NSArray *)statusArray;

@end
