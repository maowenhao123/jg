//
//  YZWithdrawalRecordTableViewCell.h
//  ez
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZWithdrawalRecordStatus.h"

@interface YZWithdrawalRecordTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZWithdrawalRecordStatus *status;

@end
