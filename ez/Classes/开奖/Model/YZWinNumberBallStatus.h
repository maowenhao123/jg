//
//  YZWinNumberBallStatus.h
//  ez
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZWinNumberBallStatus : NSObject

@property (nonatomic, copy) NSString *number;//中奖号
@property (nonatomic, assign) int type;//显示的颜色：1.红色球 2.蓝色球 3.绿色球 4.绿色矩形
@property (nonatomic,assign) BOOL isRecommendLottery;//首页推荐彩票用另一种图片

@end
