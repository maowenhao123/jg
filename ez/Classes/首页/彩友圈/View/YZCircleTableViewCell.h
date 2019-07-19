//
//  YZCircleTableViewCell.h
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZCircleModel.h"

@class YZCircleTableViewCell;

@protocol CircleTableViewCellwDelegate <NSObject>

@optional
- (void)circleTableViewCellDeleteButtonDidClickWithCell:(YZCircleTableViewCell *)cell;

@end

@interface YZCircleTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<CircleTableViewCellwDelegate> delegate;

@property (nonatomic, strong) YZCircleModel *circleModel;

@end
