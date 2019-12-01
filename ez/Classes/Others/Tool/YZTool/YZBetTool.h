//
//  YZBetTool.h
//  ez
//
//  Created by apple on 16/5/11.
//  Copyright (c) 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZBetTool : NSObject

//机选11选5
+ (void)autoChoose11x5WithPlayType:(NSString *)playType andSelectedPlayTypeBtnTag:(int)tag;
//快赢481
+ (void)autoChooseKy481WithPlayType:(NSString *)playType andSelectedPlayTypeBtnTag:(int)tag;
//机选快三
+ (void)autoChooseKsWithSelectedPlayTypeBtnTag:(int)tag;
//机选大乐透
+ (void)autoChooseDlt;
//机选福彩3D
+ (void)autoChoosefc;
//机选七乐彩
+ (void)autoChooseQlc;
//机选双色球
+ (void)autoChooseSsq;
//机选七星彩
+ (void)autoChooseQxc;
//机选排列五
+ (void)autoChoosePlw;
//机选排列三
+ (void)autoChoosePls;

//获取排三的ticketList
+ (NSMutableArray *)getPlsTicketList;
//获取11选5的ticketList
+ (NSMutableArray *)getS1x5TicketList;
//获取福彩3D的ticketList
+ (NSMutableArray *)getFcTicketList;
//获取双色球的ticketList
+ (NSMutableArray *)getSsqTicketList;
//获取七乐彩的ticketList
+ (NSMutableArray *)getQlcTicketList;
//获取大乐透的ticketList
+ (NSMutableArray *)getDltTicketListWithZhuijia:(BOOL)zhuijia;
//获取七星彩的ticketList
+ (NSMutableArray *)getQxcTicketList;
//获取排五的ticketList
+ (NSMutableArray *)getPlwTicketList;
//获取快三的ticketList
+ (NSMutableArray *)getKsTicketList;
//获取快赢481的ticketList
+ (NSMutableArray *)getKy481TicketList;

@end
