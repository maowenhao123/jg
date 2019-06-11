//
//  YZFBMatchDetailStandingsView.h
//  ez
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZFBMatchDetailStandingsStatus.h"

@interface YZFBMatchDetailStandingsView : UIView

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) YZFBMatchDetailStandingsStatus *standingsStatus;

@end
