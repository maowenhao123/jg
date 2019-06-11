//
//  YZNoOrderTableViewCell.h
//  ez
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZNoOrderTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UIViewController * owner;//属于谁

@end
