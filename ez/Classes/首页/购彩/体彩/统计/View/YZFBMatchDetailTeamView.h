//
//  YZFBMatchDetailTeamView.h
//  ez
//
//  Created by apple on 17/1/12.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZRoundStatus.h"

@interface YZFBMatchDetailTeamView : UIView

@property (nonatomic, weak) UILabel *scoreLabel;//比分
@property (nonatomic, strong) YZRoundStatus *round;//交战双方信息

@end
