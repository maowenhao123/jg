//
//  YZKy481RecentLotteryCell.h
//  ez
//
//  Created by dahe on 2019/11/6.
//  Copyright © 2019 9ge. All rights reserved.
//

typedef enum {
    KhistoryCellTagZongHe = 1,
    KhistoryCellTagZiyou = 2,
    KhistoryCellTagYang = 3,
    KhistoryCellTagWa = 4,
    KhistoryCellTagDie = 5,
    KhistoryCellTagWanNeng = 6,
    KhistoryCellTagZu = 7,
    KhistoryCellTag283 = 8,
}KhistoryCellTag;

#import <UIKit/UIKit.h>
#import "YZRecentLotteryStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZKy481RecentLotteryCell : UITableViewCell

+ (YZKy481RecentLotteryCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) YZRecentLotteryStatus *status;//数据
@property (nonatomic, assign) KhistoryCellTag cellTag;

@end

NS_ASSUME_NONNULL_END
