//
//  YZKsHistoryTableViewCell.h
//  ez
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZRecentLotteryStatus.h"

@interface YZKsHistoryTableViewCell : UITableViewCell

@property (nonatomic, strong) YZRecentLotteryStatus *status;

+ (YZKsHistoryTableViewCell *)cellWithTableView:(UITableView *)tableView;

@end
