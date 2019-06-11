//
//  YZWinNumberStatus.h
//  ez
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZWinNumberStatus : NSObject

@property (nonatomic, copy) NSString *lotteryImage;//彩票图片
@property (nonatomic, copy) NSString *lotteryName;//彩票名字
@property (nonatomic, copy) NSString *lotteryPeriod;//彩票期数
@property (nonatomic, copy) NSString *lotteryTime;//开奖时间
@property (nonatomic, copy) NSString *lotteryNumber;//开奖号码
@property (nonatomic, strong) NSMutableArray *lotteryNumberInfos;//开奖号码信息数组
@property (nonatomic, copy) NSString *gameId;

@end
