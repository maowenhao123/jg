//
//  YZFbBetCell.h
//  ez
//
//  Created by apple on 14-12-3.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZFbBetCellStatus.h"
#import "YZBtnsView.h"

@class YZFbBetCell;
@protocol YZFbBetCellDelegate <NSObject>

@optional
- (void)fbBetCellDidClickDeleteBtn:(UIButton *)btn inCell:(YZFbBetCell *)cell;
- (void)fbBetCellDidClickDanBtn:(UIButton *)btn inCell:(YZFbBetCell *)cell;
- (void)fbBetCellDidClickOddsInfoBtn:(UIButton *)btn inBtnsView:(UIView *)btnsView inCell:(YZFbBetCell *)cell;
@end
@interface YZFbBetCell : UITableViewCell
+ (YZFbBetCell *)cellWithTableView:(UITableView *)tableView andIndexpath:(NSIndexPath *)indexPath;
@property (nonatomic, weak) id<YZFbBetCellDelegate> delegate;
@property (nonatomic, strong) YZFbBetCellStatus *status;//数据模型
@end
