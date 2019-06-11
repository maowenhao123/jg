//
//  YZChartViewContentTableViewCell.h
//  ez
//
//  Created by apple on 17/3/7.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZChartDataStatus.h"

@interface YZChartViewContentTableViewCell : UITableViewCell

+ (YZChartViewContentTableViewCell *)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak) UIView * line;

@property (nonatomic, assign) NSInteger ballNumber;
@property (nonatomic, assign) BOOL isBlue;//是蓝球

@property (nonatomic, strong) YZChartDataStatus * dataStatus;

@property (nonatomic, assign) BOOL waitLottery;
@property (nonatomic, assign) BOOL showWaitLottery;
@property (nonatomic, weak) UILabel * noDataLabel;
@property (nonatomic, strong) UIColor * textColor;
@property (nonatomic, strong) NSArray * textArray;

@end
