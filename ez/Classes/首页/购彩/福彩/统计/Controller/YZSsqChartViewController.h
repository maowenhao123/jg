//
//  YZSsqChartViewController.h
//  ez
//
//  Created by apple on 17/3/3.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"
#import "YZNavigationController.h"

@interface YZSsqChartViewController : YZBaseViewController

@property (nonatomic, copy) NSString * gameId;//游戏Id
@property (nonatomic, assign) BOOL isDlt;//是大乐透
@property (nonatomic, assign) BOOL isRecentOpenLottery;
@property (nonatomic, assign, getter = isDantuo) BOOL dantuo;//是胆拖
@property (nonatomic, strong) NSMutableArray * selectedBalls;//选中的号码球

@end
