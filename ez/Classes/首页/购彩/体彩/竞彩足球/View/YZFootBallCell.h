//
//  YZFootBallCell.h
//  ez
//
//  Created by apple on 14-11-20.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define FbCellH0 110
#define FbCellH1 110 - 20 //少一排按钮的我高度
#define FbMatchDetailH 120
#import <UIKit/UIKit.h>
#import "YZMatchInfosStatus.h"
#import "YZFBMatchDetailStatus.h"
@class YZFootBallCell;
@protocol YZFootBallCellDelegate <NSObject>

@optional
- (void)footBallCellOpenBtnDidClick:(UIButton *)btn withCell:(YZFootBallCell *)cell;
- (void)reloadBottomMidLabelText;
- (void)showDetailBtnDidClickWithCell:(YZFootBallCell *)cell;

@end
@interface YZFootBallCell : UITableViewCell

@property (nonatomic, weak) UILabel *Vs1Label;//Vs1Label
@property (nonatomic, weak) UILabel *Vs2Label;//Vs2Label
+ (YZFootBallCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZMatchInfosStatus *matchInfos;//一个cell的数据模型
@property (nonatomic, strong) YZFBMatchDetailStatus *matchDetailStatus;
@property (nonatomic, weak) id<YZFootBallCellDelegate> delegate;

@end
