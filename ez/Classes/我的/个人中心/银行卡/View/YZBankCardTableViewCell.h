//
//  YZBankCardTableViewCell.h
//  ez
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZBankCardStatus.h"

@interface YZBankCardTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, strong) YZBankCardStatus *status;

@end
