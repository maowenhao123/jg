//
//  YZYZ11x5ChartTableViewCell.h
//  ez
//
//  Created by dahe on 2019/12/6.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZ11x5ChartHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZYZ11x5ChartTableViewCell : UITableViewCell

+ (YZYZ11x5ChartTableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) KChartCellTag chartCellTag;
@property (nonatomic, strong) YZChartDataStatus * dataStatus;

@property (nonatomic, assign) KChartStatisticsTag chartStatisticsTag;
@property (nonatomic, strong) YZChartSortStatsStatus * status;

@end

NS_ASSUME_NONNULL_END
