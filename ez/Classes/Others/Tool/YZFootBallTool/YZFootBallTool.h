//
//  YZFootBallTool.h
//  ez
//
//  Created by apple on 14-12-9.
//  Copyright (c) 2014年 9ge. All rights reserved.
//  竞彩足球工具类

#import <Foundation/Foundation.h>

@interface YZFootBallTool : NSObject
/**
 * @param betArray 需要的已经选择的原始数组
 * @param playWays 单串过关方式m串1的m
 * @param danArray 选了胆的场次的数组
 * @param selectedPlayType 选择的玩法
 * @return 返回结果是含注数、最小奖金、最大奖金的一个数组
 */
+ (NSMutableArray *)computeBetCountAndPrizeRangeWithBetArray:(NSMutableArray *)betArray
                                                    playWays:(NSArray *)playWayArray
                                                    danArray:(NSMutableArray *)danArray
                                            selectedPlayType:(int)selectedPlayType;
/**
 *  胜负彩的任九场的注数算法
 * @a 数组放每场所选的赔率个数
 *  @num 至少选多少场
 */
+ (int)getRenjiuBetCount:(NSArray *)a :(int)num;
/**
 *  二选一转化成胜平负
 */
+ (NSMutableArray *)changeCN06ToCN01AndCN02BySelMatchArray:(NSMutableArray *)selMatchArray;
/**
 *  多串过关方式的字典
 */
+ (NSDictionary *)getMorePassWayDict;
/**
 *  判断是否中奖
 */
+ (BOOL)isHitByWinNumber:(NSString *)winNumber andCode:(NSString *)code;
/**
 获取竞彩足球的赛果
 */
+ (NSString *)getJCMatchResultByWinningNumber:(NSString *)winningNumber playType:(NSString *)playType;
/**
 获取playType
 */
+ (NSString *)getPlayTypeByCode:(NSString *)code;
/**
 *  可选择的玩法
 */
+ (int)getMaxWayCountByStatusArray:(NSArray *)statusArray;
@end
