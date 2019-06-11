//
//  YZScjqCell.h
//  ez
//
//  Created by apple on 14-12-15.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define scjqCellH 70

#import <UIKit/UIKit.h>
#import "YZScjqCellStatus.h"

@class  YZScjqCell;

@protocol YZScjqCellDelegate <NSObject>

@optional
- (void)scjqCellOddsInfoBtnDidClick:(UIButton *)btn withCell:(YZScjqCell *)cell;

@end
@interface YZScjqCell : UITableViewCell
+ (YZScjqCell *)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak) id<YZScjqCellDelegate> delegate;
@property (nonatomic, strong) YZScjqCellStatus *status;//数据模型
@property (nonatomic, strong) YZScjqCellStatus *betStatus;//投注接界面数据模型
//赔率按钮点击
- (void)oddInfoBtnClick:(UIButton *)btn;
@end
