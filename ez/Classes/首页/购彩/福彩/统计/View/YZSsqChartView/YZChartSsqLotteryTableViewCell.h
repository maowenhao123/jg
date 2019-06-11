//
//  YZChartSsqLotteryTableViewCell.h
//  ez
//
//  Created by apple on 17/3/9.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZChartDataStatus.h"

@interface YZChartSsqLotteryTableViewCell : UITableViewCell

+ (YZChartSsqLotteryTableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZChartDataStatus * dataStatus;
@property (nonatomic, assign) BOOL isDlt;//是大乐透

@end
