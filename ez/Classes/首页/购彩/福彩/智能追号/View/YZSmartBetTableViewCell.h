//
//  YZSmartBetTableViewCell.h
//  ez
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZSmartBet.h"

@interface YZSmartBetTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL showLine;
@property (nonatomic, weak) UITextField *multipleTextField;
@property (nonatomic, weak) YZSmartBet *status;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
