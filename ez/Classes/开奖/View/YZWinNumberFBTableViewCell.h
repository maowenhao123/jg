//
//  YZWinNumberFBTableViewCell.h
//  ez
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZWinNumberFBStatus.h"

@interface YZWinNumberFBTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZWinNumberFBStatus *status;

@property (nonatomic, assign) BOOL isBasketBall;

@end
