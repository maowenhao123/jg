//
//  YZCommitTool.h
//  ez
//
//  Created by apple on 16/5/11.
//  Copyright (c) 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZBallBtn.h"

@interface YZCommitTool : NSObject

#pragma mark - 排列三
//排三普通
+ (void)commitPisNormalBetWithBaiBalls:(NSMutableArray *)baiBalls shiBalls:(NSMutableArray *)shiBalls geBalls:(NSMutableArray *)geBalls betCount:(int)betCount playType:(NSString *)playTypeCode;
//排三和值
+ (void)commitPisHezhiBetWithBalls:(NSMutableArray *)balls betCount:(int)betCount playType:(NSString *)playTypeCode;
//提交排三组合的数据
+ (void)commitPisZuheBetWithBalls:(NSMutableArray *)balls betCount:(int)betCount playType:(NSString *)playTypeCode;
//排三组选
+ (void)commitPisZuxuanBetWithBalls:(NSMutableArray *)balls andBetCount:(int)betCount andPlayType:(NSString *)playTypeCode;
//提交排三直选三单式的数据
+ (void)commitPisSanDanBetWithDanBall:(YZBallBtn *)danBall chongBall:(YZBallBtn *)chongBall betCount:(int)betCount playType:(NSString *)playTypeCode;
//提交排三直选三复式的数据
+ (void)commitPisSanFuBetWithBalls:(NSMutableArray *)balls andBetCount:(int)betCount andPlayType:(NSString *)playTypeCode;
//提交排三直选六复式的数据
+ (void)commitPisLiuBetWithBalls:(NSMutableArray *)balls BetCount:(int)betCount PlayType:(NSString *)playTypeCode;
#pragma mark - 大乐透
//提交大乐透普通投注的数据
+ (void)commitDltNormalBetWithRedBalls:(NSMutableArray *)redBalls blueBalls:(NSMutableArray *)blueBalls betCount:(int)betCount;
//提交胆拖投注的数据
+ (void)commitDltBileBetWithRedBalls1:(NSMutableArray *)redBalls1 blueBalls1:(NSMutableArray *)blueBalls1 redBalls2:(NSMutableArray *)redBalls2 blueBalls2:(NSMutableArray *)blueBalls2 betCount:(int)betCount;
#pragma mark - 11选5
//提交11选5的数据
+ (void)commit1x5BetWithBalls:(NSMutableArray *)balls betCount:(int)betCount playType:(NSString *)playTypeCode currentTitle:(NSString *)currentTitle selectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag;
#pragma mark - 快赢481
+ (void)commitKy481BetWithBalls:(NSMutableArray *)balls betCount:(int)betCount playType:(NSString *)playTypeCode currentTitle:(NSString *)currentTitle selectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag;
#pragma mark - 快三
+ (void)commitKsBetWithNumbers:(NSMutableArray *)numbers selectedPlayTypeBtnTag:(NSInteger)tag;

@end
