//
//  YZBetSuccessViewController.h
//  ez
//
//  Created by apple on 14-9-19.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
typedef enum : NSUInteger {
    BetTypeNormal = 1,//1：正常
    BetTypeFastBet = 2,//2：快速投注
    BetTypeSmartBet = 3,//3：智能追号
    BetTypeStartUnionBuyBet = 4,//4：发起合买
    BetTypeParticipateUnionBuyBet = 5,//4：参与合买
} PayVcType;

#import "YZBaseViewController.h"
#import "YZStartUnionbuyModel.h"

@interface YZBetSuccessViewController : YZBaseViewController

@property (nonatomic, assign) PayVcType payVcType;
@property (nonatomic, strong) YZStartUnionbuyModel *unionbuyModel;
@property (nonatomic, assign) int isDismissVC;
@property (nonatomic, assign) int termCount;

@end
