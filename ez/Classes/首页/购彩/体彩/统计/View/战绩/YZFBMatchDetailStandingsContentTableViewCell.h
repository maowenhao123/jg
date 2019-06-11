//
//  YZFBMatchDetailStandingsContentTableViewCell.h
//  ez
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZMatchCellStatus.h"
#import "YZMatchFutureStatus.h"

@interface YZFBMatchDetailStandingsContentTableViewCell : UITableViewCell

+ (YZFBMatchDetailStandingsContentTableViewCell *)cellWithTableView:(UITableView *)tableView;
@property (nonatomic, copy) NSString *homeTeam;
@property (nonatomic, strong) YZMatchCellStatus *matchCellStatus;
@property (nonatomic, strong) YZMatchFutureStatus *matchFutureStatus;

@end
