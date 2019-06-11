//
//  YZUnionBuyFollowUserCell.h
//  ez
//
//  Created by apple on 15/3/23.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZUnionBuyFollowUserCellStatusFrame.h"

@interface YZUnionBuyFollowUserCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZUnionBuyFollowUserCellStatusFrame *statusFrame;
@end
