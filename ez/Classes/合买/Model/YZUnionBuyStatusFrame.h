//
//  YZUnionStatusFrame.h
//  ez
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015年 9ge. All rights reserved.
//
typedef enum : NSUInteger {
    KCellTypeUnionBuyCell = 0,
    KCellTypeAttatchedCell = 1,
} KCellType;

#define bigFont [UIFont systemFontOfSize:YZGetFontSize(30)]
#define smallFont [UIFont systemFontOfSize:YZGetFontSize(24)]
#define  circleChartWH 55.0f

#import <Foundation/Foundation.h>
#import "YZUnionBuyStatus.h"

@interface YZUnionBuyStatusFrame : NSObject

@property (nonatomic, strong) YZUnionBuyStatus *status;
@property (nonatomic, assign) CGRect gameNameFrame;
@property (nonatomic, assign) CGRect iconFrame;
@property (nonatomic, assign) CGRect userNameFrame;
@property (nonatomic, assign) CGRect seperatorFrame;
@property (nonatomic, assign) CGRect circleChartFrame;
@property (nonatomic, assign) CGRect grayLineFrame;
@property (nonatomic, assign) CGFloat cellH;
@property (nonatomic, assign) KCellType cellType;

@end
