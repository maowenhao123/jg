//
//  YZGameIdViewController.h
//  ez
//
//  Created by apple on 15/1/14.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface YZGameIdViewController : YZBaseViewController

@property (nonatomic, copy) NSString *gameId;

- (instancetype)initWithGameId:(NSString *)gameId;

- (void)openMenuView;

@end
