//
//  YZWinNumberTableViewCell.h
//  ez
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZWinNumberStatusFrame.h"

@interface YZWinNumberTableViewCell : UITableViewCell

@property (nonatomic, strong) YZWinNumberStatusFrame *statusFrame;
@property (nonatomic, weak) UIView *line;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
