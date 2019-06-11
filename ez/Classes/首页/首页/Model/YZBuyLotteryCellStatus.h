//
//  YZBuyLotteryCellStatus.h
//  ez
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZBuyLotteryCellStatus : NSObject

@property (nonatomic, copy) NSString *resId;//主键
@property (nonatomic, copy) NSString *gameId;//游戏id
@property (nonatomic, copy) NSString *gameName;//游戏名称
@property (nonatomic, strong) NSDictionary *icon;//图标
@property (nonatomic, strong) NSDictionary *title;//描述
@property (nonatomic, strong) NSDictionary *sup;//角标

@property (nonatomic, copy) NSString *gameDescription;//游戏描述
@property (nonatomic, assign) BOOL isToday;//是否今日开奖

@end
