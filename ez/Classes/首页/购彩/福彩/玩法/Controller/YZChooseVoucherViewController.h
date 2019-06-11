//
//  YZChooseVoucherViewController.h
//  ez
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"

@interface YZChooseVoucherViewController : YZBaseViewController

@property (nonatomic, copy) NSString *gameId;//游戏id
@property (nonatomic, assign) float amountMoney;//金额
@property (nonatomic, assign) int betCount;//注数
@property (nonatomic, assign) int multiple;//倍数
@property (nonatomic, strong) NSMutableArray *ticketList;//票的信息
//竞彩
@property (nonatomic, copy) NSString *betType;//玩法
@property (nonatomic, copy) NSString *playType;
@property (nonatomic, copy) NSString *numbers;//选择比赛的信息
@property (nonatomic, assign) BOOL isJC;//是否是竞彩
//胜负彩
@property (nonatomic, assign) BOOL isSFC;//是否是胜负彩
@property (nonatomic, copy) NSString *termId;
@end
