//
//  YZKy481ChartRenTableViewCell.h
//  ez
//
//  Created by dahe on 2019/12/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ky481ChartHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZKy481ChartRenTableViewCell : UITableViewCell

+ (YZKy481ChartRenTableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZChartDataStatus * dataStatus;

@end

NS_ASSUME_NONNULL_END
