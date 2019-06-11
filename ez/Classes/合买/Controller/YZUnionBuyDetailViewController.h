//
//  YZUnionBuyDetailViewController.h
//  ez
//
//  Created by apple on 15/3/20.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"

@interface YZUnionBuyDetailViewController : YZBaseViewController

- (instancetype)initWithUnionBuyPlanId:(NSString *)unionBuyPlanId gameId:(NSString *)gameId;

- (instancetype)initWithUnionBuyUserId:(NSString *)unionBuyUserId unionBuyPlanId:(NSString *)unionBuyPlanId gameId:(NSString *)gameId;

@end
