//
//  YZFBMatchDetailOddsView.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZFBMatchDetailOddsStatus.h"

@interface YZFBMatchDetailOddsView : UIView

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) YZFBMatchDetailOddsStatus *oddsStatus;
@property (nonatomic, copy) NSString *roundNum;

@end
