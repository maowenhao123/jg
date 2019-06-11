//
//  YZEuropeOddsStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZEuropeOddsStatus : NSObject

@property (nonatomic, copy) NSString *win;//胜赔
@property (nonatomic, assign) int winTrend;//胜赔趋势
@property (nonatomic, copy) NSString *draw;//平赔
@property (nonatomic, assign) int drawTrend;//平赔趋势
@property (nonatomic, copy) NSString *loss;//负赔
@property (nonatomic, assign) int lossTrend;//负赔趋势
@property (nonatomic, copy) NSString *updateTime;//更新时间

@end
