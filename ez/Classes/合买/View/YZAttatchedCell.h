//
//  YZAttatchedCell.h
//  ez
//
//  Created by apple on 15/3/11.
//  Copyright (c) 2015年 9ge. All rights reserved.
//
#define attatchedCellH 40.0f
#import <UIKit/UIKit.h>
#import "YZUnionBuyStatusFrame.h"

@class YZAttatchedCell;
@protocol YZAttatchedCellDelegate <NSObject>

@optional

- (void)attatchedCellDidClickQuickPayBtnWithCell:(YZAttatchedCell *)cell;

@end
@interface YZAttatchedCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak) UITextField *moneyTd;//钱输入框
@property (nonatomic, strong) YZUnionBuyStatusFrame *statusFrame;
@property (nonatomic, weak) id<YZAttatchedCellDelegate> delegate;

@end
