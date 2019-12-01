//
//  YZSfcCell.h
//  ez
//
//  Created by apple on 14-12-12.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#define sfcCellH 70
#import <UIKit/UIKit.h>
#import "YZSfcCellStatus.h"
@class YZSfcCell;

@protocol YZSfcCellDelegate <NSObject>

@optional
- (void)sfcCellOddsInfoBtnDidClick:(UIButton *)btn withCell:(YZSfcCell *)cell;

@end
@interface YZSfcCell : UITableViewCell
@property (nonatomic, strong) YZSfcCellStatus *status;//数据模型
@property (nonatomic, strong) YZSfcCellStatus *betStatus;//投注接界面数据模型
+ (YZSfcCell *)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak) id<YZSfcCellDelegate> delegate;//赔率按钮点击
- (void)oddInfoBtnClick:(UIButton *)btn;
@end
