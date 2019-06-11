//
//  YZConsumableVoucherViewController.h
//  ez
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"
#import "YZVoucherStatus.h"

@protocol YZConsumableVoucherDelegate <NSObject>

- (void)chooseVoucherStstus:(YZVoucherStatus *)voucherStatus;
- (void)cancelUseVoucher;

@end

@interface YZConsumableVoucherViewController : YZBaseViewController

@property (nonatomic, weak) id<YZConsumableVoucherDelegate> delegate;
@property (nonatomic, copy) NSString *gameId;//游戏id
@property (nonatomic, assign) float amountMoney;//金额

@end
