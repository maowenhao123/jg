//
//  YZUnionBuyFollowUserCellStatusFrame.h
//  ez
//
//  Created by apple on 15/3/23.
//  Copyright (c) 2015年 9ge. All rights reserved.
//
#define  bigFont [UIFont systemFontOfSize:YZGetFontSize(28)]
#define  smallFont [UIFont systemFontOfSize:YZGetFontSize(24)]

#import <Foundation/Foundation.h>
#import "YZUnionBuyStatus.h"

@interface YZUnionBuyFollowUserCellStatusFrame : NSObject

@property (nonatomic, strong) YZUnionBuyStatus *status;//数据模型
/**
 *  参与者label的frame
 */
@property (nonatomic, assign) CGRect userNameF;
/**
 *  创建时间label的frame
 */
@property (nonatomic, assign) CGRect createTimeF;
/**
 *  参与金额label的frame
 */
@property (nonatomic, assign) CGRect moneyF;
/**
 *  占方案总金额label的frame
 */
@property (nonatomic, assign) CGRect moneyOfTotalF;
/**
 *  cell的高度
 */
@property (nonatomic, assign) CGFloat cellH;

@end
