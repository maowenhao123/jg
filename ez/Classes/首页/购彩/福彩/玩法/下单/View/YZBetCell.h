//
//  YZBetCell.h
//  ez
//
//  Created by apple on 14-9-14.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZBetStatus.h"

@interface YZBetCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, weak) UIButton *deleteBtn;
@property (nonatomic, strong) YZBetStatus *status;
@property (nonatomic, weak) UILabel *label;

@end
