//
//  YZKy481ChartYongTableView.h
//  ez
//
//  Created by dahe on 2019/12/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZKy481ChartYongTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZKy481ChartYongTableView : UITableView

@property (nonatomic, assign) KChartCellTag chartCellTag;
@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) YZChartStatsStatus * stats;

@end

NS_ASSUME_NONNULL_END
