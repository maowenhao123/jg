//
//  YZRechargeTableViewCell.h
//  ez
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZRechargeStatus.h"

@interface YZRechargeTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) YZRechargeStatus *status;
@property (nonatomic, weak) UIView *line;

@end
