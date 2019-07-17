//
//  YZServiceTableViewCell.h
//  ez
//
//  Created by dahe on 2019/7/15.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZServiceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZServiceTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZServiceModel *serviceModel;

@end

NS_ASSUME_NONNULL_END
