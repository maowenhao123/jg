//
//  YZShareIncomeTableViewCell.h
//  ez
//
//  Created by 毛文豪 on 2017/5/23.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZShareIncomeStatus.h"

@interface YZShareIncomeTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZShareIncomeStatus *status;

@property (nonatomic,weak) UIView * line;

@end
