//
//  YZFCOrderDetailTableViewCell.h
//  ez
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZFCOrderDetailStatus.h"

@interface YZFCOrderDetailTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy) NSString *winNumber;
@property (nonatomic, strong) YZFCOrderDetailStatus *status;

@end
