//
//  YZSchemeSetmealTableViewCell.h
//  ez
//
//  Created by 毛文豪 on 2018/7/11.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZSchemeSetmealModel.h"

@class YZSchemeSetmealTableViewCell;
@protocol YZSchemeSetmealTableViewCellDelegate <NSObject>

- (void)schemeSetmealTableViewCellBuyDidClickCell:(YZSchemeSetmealTableViewCell *)cell;

@end

@interface YZSchemeSetmealTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZSchemeSetmealInfoModel *schemeSetmealInfoModel;

@property (nonatomic, weak) id <YZSchemeSetmealTableViewCellDelegate> delegate;

@end
