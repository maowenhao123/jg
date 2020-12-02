//
//  YZWinRankingTableViewCell.h
//  zc
//
//  Created by dahe on 2020/5/18.
//  Copyright © 2020 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZWinModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZWinRankingTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZWinModel *winModel;
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
