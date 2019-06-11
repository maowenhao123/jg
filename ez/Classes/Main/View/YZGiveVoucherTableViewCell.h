//
//  YZGiveVoucherTableViewCell.h
//  ez
//
//  Created by 孔琪琪 on 2018/3/29.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGiveVoucherModel.h"

@protocol YZGiveVoucherTableViewCellDelegate <NSObject>

- (void)receiveVoucher;
- (void)useVoucher;

@end

@interface YZGiveVoucherTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, copy) NSString *promotionId;

@property (nonatomic,strong) CouponRedPackage *couponRedPackage;

@property (nonatomic, weak) id <YZGiveVoucherTableViewCellDelegate> delegate;

@end
