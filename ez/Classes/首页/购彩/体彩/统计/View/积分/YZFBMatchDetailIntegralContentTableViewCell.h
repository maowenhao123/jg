//
//  YZFBMatchDetailIntegralContentTableViewCell.h
//  ez
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZIntegralStatus.h"

@interface YZFBMatchDetailIntegralContentTableViewCell : UITableViewCell

+ (YZFBMatchDetailIntegralContentTableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZIntegralStatus * integralStatus;
@property (nonatomic, strong) NSArray *teamNames;

@end
