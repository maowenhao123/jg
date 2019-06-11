//
//  YZOrderTableViewCell.h
//  ez
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZOrderStatus.h"
@interface YZOrderTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZOrderStatus *status;
@property (nonatomic, assign) int index;
@property (nonatomic, weak) UIView * line;

@end
