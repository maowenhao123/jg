//
//  YZRecentStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZRecentStatus : NSObject

@property (nonatomic, assign) int homeWin;//主队胜数
@property (nonatomic, assign) int homeDraw;//主队平数
@property (nonatomic, assign) int homeLost;//主队负
@property (nonatomic, assign) int awayWin;//客队胜数
@property (nonatomic, assign) int awayDraw;//客队平数
@property (nonatomic, assign) int awayLost;//客队负数

@end
