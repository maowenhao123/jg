//
//  YZBetViewController.h
//  ez
//
//  Created by apple on 14-9-12.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"
#import "YZStatusCacheTool.h"

@interface YZBetViewController : YZBaseViewController

@property (nonatomic, weak) UILabel *amountLabel;//注数、倍数、金额总数
@property (nonatomic, copy) NSString *gameId;//游戏id
@property (nonatomic, strong) NSMutableArray *statusArray;//数据的数组
@property (nonatomic, assign) int selectedPlayTypeBtnTag;//11选5 快三玩法需要给定的参数,用于判断哪种玩法，是否可以机选
@property (nonatomic, assign) int multiple;
@property (nonatomic, assign) int isDismissVC;
@property (nonatomic, assign) int isChartVC;
- (instancetype)initWithPlayType:(NSString *)playType;

@end
