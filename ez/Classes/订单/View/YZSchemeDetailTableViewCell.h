//
//  YZSchemeDetailTableViewCell.h
//  ez
//
//  Created by apple on 16/10/8.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZOrder.h"

@interface YZSchemeDetailTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) UILabel *noLabel;//序号
@property (nonatomic, strong) YZOrder *status;

@end
