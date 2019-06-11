//
//  YZWinNumberFBStatus.h
//  ez
//
//  Created by apple on 16/10/25.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZWinNumberFBStatus : NSObject

@property (nonatomic, copy) NSString *roundNum;//场次编号
@property (nonatomic, assign) long roundDate;//场次日期
@property (nonatomic, assign) long matchTime;//比赛时间
@property (nonatomic, copy) NSString *result;//比赛结果串 eg:01|0;02|3;03|11;04|2;05|01;R|1.0;H|0:1;F|1:1
@property (nonatomic, copy) NSString *league;//联队
@property (nonatomic, copy) NSString *leagueShort;//联队简称
@property (nonatomic, copy) NSString *home;//主场
@property (nonatomic, copy) NSString *homeShort;//homeShort
@property (nonatomic, copy) NSString *guest;//客场
@property (nonatomic, copy) NSString *guestShort;//客场简称

//自定义
@property (nonatomic, assign) BOOL open;//打开 关闭

@end
