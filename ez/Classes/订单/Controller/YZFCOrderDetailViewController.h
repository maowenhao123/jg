//
//  YZFCOrderDetailViewController.h
//  ez
//
//  Created by apple on 16/9/30.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"
#import "YZOrder.h"

@interface YZFCOrderDetailViewController : YZBaseViewController

@property (nonatomic, copy) NSString *gameId;//玩法ID
@property (nonatomic, copy) NSString *orderId;//订单ID
@property (nonatomic, strong) YZOrder * order;//订单

@end
