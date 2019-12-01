//
//  YZChartColdHotTableViewCell.h
//  ez
//
//  Created by apple on 17/3/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZChartColdHotStatus.h"
#import "YZChartDataStatus.h"

@interface YZChartColdHotTableViewCell : UITableViewCell

+ (YZChartColdHotTableViewCell *)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) YZChartColdHotStatus *status;
@property (nonatomic, strong) YZChartDataStatus * dataStatus;
@property (nonatomic, weak) UIView * line;

@end
