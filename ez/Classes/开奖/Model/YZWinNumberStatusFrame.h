//
//  YZWinNumberStatusFrame.h
//  ez
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 9ge. All rights reserved.
//

#define YZLotteryNameFont [UIFont systemFontOfSize:YZGetFontSize(26)]
#define YZLotteryPeriodFont [UIFont systemFontOfSize:YZGetFontSize(22)]
#define YZLotteryTimeFont [UIFont systemFontOfSize:YZGetFontSize(22)]
#define YZLotteryDetailFont [UIFont systemFontOfSize:YZGetFontSize(24)]

#import <Foundation/Foundation.h>
#import "YZWinNumberStatus.h"
#import "YZWinNumberBallStatus.h"

@interface YZWinNumberStatusFrame : NSObject
/**
 *  背景图片的frame
 */
@property (nonatomic, assign, readonly) CGRect bgImageViewF;
/**
 *  图片的frame
 */
@property (nonatomic, assign, readonly) CGRect imageF;
/**
 *  名字的frame
 */
@property (nonatomic, assign, readonly) CGRect nameF;
/**
 *  开奖日期的frame
 */
@property (nonatomic, assign, readonly) CGRect periodF;
/**
 *  今日开奖时间的frame
 */
@property (nonatomic, assign, readonly) CGRect timeF;
/**
 *  开奖号码frame
 */
@property (nonatomic, assign, readonly) CGRect numberViewF;
/*
 查看比赛结果
 */
@property (nonatomic, assign, readonly) CGRect detailF;
/*
 accessory
 */
@property (nonatomic, assign, readonly) CGRect accessoryF;

@property (nonatomic, strong) YZWinNumberStatus *status;

//cell的高度
@property (nonatomic, assign) CGFloat cellH;

@end
