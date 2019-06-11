//
//  YZRecentLotteryCell.h
//  ez
//
//  Created by apple on 14-11-17.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define btnWH screenWidth / 13

#import <UIKit/UIKit.h>
#import "YZRecentLotteryStatus.h"

@interface YZRecentLotteryCell : UITableViewCell

+ (YZRecentLotteryCell *)cellWithTableView:(UITableView *)tableView;
//@property (nonatomic, strong) NSArray *winNumbers;
@property (nonatomic, strong) YZRecentLotteryStatus *status;//数据

@end
