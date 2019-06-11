//
//  YZRechargeRecordTableViewCell.h
//  ez
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZRechargeRecordStatus.h"

@interface YZRechargeRecordTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZRechargeRecordStatus *status;

@end
