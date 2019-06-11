//
//  YZMineFunctionTableViewCell.h
//  ez
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZFunctionStatus.h"

@interface YZMineFunctionTableViewCell : UITableViewCell

@property (nonatomic, weak) UIImageView *redDot;
@property (nonatomic, weak) UIView * line;
@property (nonatomic, strong) YZFunctionStatus *status;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
