//
//  YZKy481ChartZuTableViewCell.h
//  ez
//
//  Created by dahe on 2019/12/3.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ky481ChartHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZKy481ChartZuTableViewCell : UITableViewCell

+ (YZKy481ChartZuTableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZChartDataStatus * dataStatus;

@property (nonatomic, assign) KChartStatisticsTag chartStatisticsTag;
@property (nonatomic, strong) YZChartSortStatsStatus * status;

@end

NS_ASSUME_NONNULL_END
