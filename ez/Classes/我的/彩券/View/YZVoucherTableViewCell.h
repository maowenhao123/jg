//
//  YZVoucherTableViewCell.h
//  ez
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZVoucherStatus.h"

@interface YZVoucherTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZVoucherStatus *status;
@property (nonatomic, weak) UIButton * goButton;
@property (nonatomic, assign) int index;

@end
