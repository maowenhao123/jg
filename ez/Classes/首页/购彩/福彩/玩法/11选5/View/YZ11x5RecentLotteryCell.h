//
//  YZ11x5RecentLotteryCell.h
//  ez
//
//  Created by apple on 14-11-17.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define btnWH screenWidth / 13

typedef enum {    
    KhistoryCellTagWan = 10000,
    KhistoryCellTagQian = 1000,
    KhistoryCellTagBai = 100,
    KhistoryCellTagZero = 1
}KhistoryCellTag;

#import <UIKit/UIKit.h>
#import "YZRecentLotteryStatus.h"

@interface YZ11x5RecentLotteryCell : UITableViewCell

+ (YZ11x5RecentLotteryCell *)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) YZRecentLotteryStatus *status;//数据
@property (nonatomic, assign) KhistoryCellTag cellTag;

@end
