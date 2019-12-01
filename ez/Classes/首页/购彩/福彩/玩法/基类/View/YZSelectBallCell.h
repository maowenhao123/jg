//
//  YZSelectBallCell.h
//  ez
//
//  Created by apple on 14-9-9.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZSelectBallCellStatus.h"
#import "YZLotteryButton.h"
#import "YZBallBtn.h"

@protocol YZSelectBallCellDelegate <NSObject>

@optional
- (void)randomCountBtnDidClick:(YZLotteryButton *)btn;
- (void)randomBtnDidClick:(YZLotteryButton *)btn;

@end

@interface YZSelectBallCell : UITableViewCell

+ (YZSelectBallCell *)cellWithTableView:(UITableView *)tableView andIndexpath:(NSIndexPath *)indexPath;

@property (nonatomic, strong) YZSelectBallCellStatus *status;//数据模型
@property (nonatomic, strong) NSMutableArray *ballsArray;//球的数组
@property (nonatomic, weak) id<YZSelectBallCellDelegate,YZBallBtnDelegate> delegate;
@property (nonatomic, weak) YZLotteryButton *randomBtn;
@property (nonatomic, weak) YZLotteryButton *randomCountBtn;
@property (nonatomic, assign) int ballsCount;//初始化几个球
@property (nonatomic, strong) id owner;//属于谁
@property (nonatomic, assign) NSInteger index;

- (void)randomBtnClick:(YZLotteryButton *)btn;

@end
