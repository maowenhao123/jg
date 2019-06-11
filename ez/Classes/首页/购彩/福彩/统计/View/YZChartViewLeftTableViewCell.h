//
//  YZChartViewLeftTableViewCell.h
//  ez
//
//  Created by apple on 17/3/7.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZChartDataStatus.h"

@interface YZChartViewLeftTableViewCell : UITableViewCell

+ (YZChartViewLeftTableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) UILabel *termIdLabel;
@property (nonatomic, weak) UIView * line;
@property (nonatomic, strong) YZChartDataStatus * dataStatus;

@end
