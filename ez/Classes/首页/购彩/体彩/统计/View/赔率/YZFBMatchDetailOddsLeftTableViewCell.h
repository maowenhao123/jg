//
//  YZFBMatchDetailOddsLeftTableViewCell.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZOddsCellStatus.h"

@interface YZFBMatchDetailOddsLeftTableViewCell : UITableViewCell

+ (YZFBMatchDetailOddsLeftTableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZOddsCellStatus *status;

@end
