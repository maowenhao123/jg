//
//  YZMatchFutureStatus.h
//  ez
//
//  Created by apple on 17/2/13.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZMatchFutureStatus : NSObject

@property (nonatomic, copy) NSString *matchName;//赛事
@property (nonatomic, copy) NSString *home;//主队名
@property (nonatomic, copy) NSString *away;//客队名
@property (nonatomic, assign) long matchTime;//比赛时间
@property (nonatomic, assign) long apartDay;//相隔天数

@end
