//
//  YZMathTool.h
//  ez
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZSmartBet.h"

@interface YZMathTool : NSObject
/**
 从n个元素中任选m个的可能
 */
+ (int)getCountWithN:(int)n andM:(int)m;
/**
 11选5 获取胆拖投注的最大最小奖金
 */
+ (NSRange)get11x5Prize_dantuoWithTag:(int)tag danballscount:(int)danballscount tuoballscount:(int)tuoballscount betCount:(int)betCount;
/**
 11选5 获取普通投注的最大最小奖金
 */
+ (NSRange)get11x5Prize_putongWithTag:(int)tag selectballcount:(int)selectballcount betCount:(int)betCount;
/**
 智能追号 按照累计盈利不低于百分比进行计算
 */
+ (NSMutableArray *)get_yinglilvSmartBetArrayByBasemoney:(int)basemoney baseminprize:(int)baseminprize_value basemaxprize:(int)basemaxprize_value yinglilv:(int)yinglilv qihao:(int)qihao currentTermId:(NSString *)currentTermId qishu:(int)qishu firstbeishu:(int)firstbeishu currentleiji:(long)currentleiji;
/**
 智能追号 按照前 m 期 盈利 n百分比，之后盈利 x 百分比
 */
+ (NSMutableArray *)get_changeSmartBetArrayByBasemoney:(int)basemoney baseminprize:(int)baseminprize_value basemaxprize:(int)basemaxprize_value firstqishu:(int)firstqishu firstyinglilv:(int)firstyinglilv secondyinglilv:(int)secondyinglilv qihao:(int)qihao currentTermId:(NSString *)currentTermId qishu:(int)qishu firstbeishu:(int)firstbeishu currentleiji:(long)currentleiji;
/**
 智能追号 累计盈利不低于 m 元
 */
+ (NSMutableArray *)get_lessSmartBetArrayByBasemoney:(int)basemoney baseminprize:(int)baseminprize_value basemaxprize:(int)basemaxprize_value qihao:(int)qihao currentTermId:(NSString *)currentTermId qishu:(int)qishu firstbeishu:(int)firstbeishu lessyingli:(int)lessyingli currentleiji:(long)currentleiji;
/**
 智能追号 当玩家改变赔率时
 */
+ (NSMutableArray *)get_changeBeishuSmartBetArrayBySmartBetArray:(NSMutableArray *)smartBetArray itemnum:(int)itemnum beishu:(int)beishu;
/**
 快三 计算奖金
 */
+ (NSRange)getKsPrizeWithTag:(int)tag selectNumbers:(NSArray *)selectNumbers;

@end
