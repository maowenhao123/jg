//
//  YZBbOrderDetailTableViewCell.h
//  ez
//
//  Created by 毛文豪 on 2018/5/31.
//  Copyright © 2018年 9ge. All rights reserved.
//
#define lineWidth 0.8

#import <UIKit/UIKit.h>
#import "YZFBOrderStatus.h"

@interface YZBbOrderDetailTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZFBOrderStatus *status;

@end
