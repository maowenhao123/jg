//
//  YZWinNumberBall.h
//  ez
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZWinNumberBallStatus.h"

@interface YZWinNumberBall : UIView

@property (nonatomic, strong) YZWinNumberBallStatus *status;

@property (nonatomic, weak) UILabel *numberLabel;

@end
