//
//  YZBasketBallTableViewCell.h
//  ez
//
//  Created by 毛文豪 on 2018/5/28.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZMatchInfosStatus.h"

@protocol YZBasketBallTableViewCellDelegate <NSObject>

@optional
- (void)reloadBottomMidLabelText;

@end

@interface YZBasketBallTableViewCell : UITableViewCell

+ (YZBasketBallTableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZMatchInfosStatus *matchInfosModel;//一个cell的数据模型

@property (nonatomic, weak) id<YZBasketBallTableViewCellDelegate> delegate;

@end
