//
//  YZMoneyDetailTableViewCell.h
//  ez
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZMoneyDetail.h"

@interface YZMoneyDetailTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZMoneyDetail *status;
@property (nonatomic, assign) int type;//1.彩金 2.奖金 3.红包 4.积分

@end
