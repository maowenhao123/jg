//
//  YZFBMatchDetailIntegralView.h
//  ez
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZFBMatchDetailIntegralStatus.h"

@interface YZFBMatchDetailIntegralView : UIView

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) YZFBMatchDetailIntegralStatus *integralStatus;
@property (nonatomic, weak) UILabel * noDataLabel;

@end
