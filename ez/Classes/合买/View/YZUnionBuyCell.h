//
//  YZUnionBuyCell.h
//  ez
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZUnionBuyStatusFrame.h"
#import "YZCircleChart.h"

@class YZUnionBuyCell;

@protocol YZUnionBuyCellDelegate <NSObject>

@optional
- (void)unionBuyCellAccessoryBtnDidClick:(UIButton *)btn cell:(YZUnionBuyCell *)cell;
@end

@interface YZUnionBuyCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZUnionBuyStatusFrame *statusFrame;
@property (nonatomic, weak) YZCircleChart *circleChart;
@property (nonatomic, weak) UIButton *accessoryBtn;
@property (nonatomic, weak) id<YZUnionBuyCellDelegate> delegate;

@end
