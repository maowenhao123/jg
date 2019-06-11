//
//  YZFBMatchDetailOddsRightContentTableViewCell.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZEuropeOddsStatus.h"
#import "YZAsiaOddsStatus.h"
#import "YZOverUnderStatus.h"

@interface YZFBMatchDetailOddsRightContentTableViewCell : UITableViewCell

+ (YZFBMatchDetailOddsRightContentTableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) id status;

@end
