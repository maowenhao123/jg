//
//  YZRecommendRowStatus.h
//  ez
//
//  Created by apple on 17/3/1.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZRecommendRowStatus : NSObject

@property (nonatomic, copy) NSString *home;//主队名
@property (nonatomic, copy) NSString *away;//客队名
@property (nonatomic, copy) NSString *homeRecent;//主队近期走势
@property (nonatomic, copy) NSString *awayRecent;//客队近期走势
@property (nonatomic, copy) NSString *homePanlv;//主队盘路
@property (nonatomic, copy) NSString *awayPanlv;//客队盘路
@property (nonatomic, copy) NSString *recommend;//推荐结果
@property (nonatomic, assign) int win;//胜数
@property (nonatomic, assign) int draw;//平数
@property (nonatomic, assign) int lost;//负数
@property (nonatomic, copy) NSString *text;//评价
@property (nonatomic, assign) int confidence;//信心指数

@end
