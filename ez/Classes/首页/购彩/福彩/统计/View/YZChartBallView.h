//
//  YZChartBallView.h
//  ez
//
//  Created by apple on 17/3/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZChartBallStatus.h"

@class YZChartBallView;

@protocol YZChartBallViewDelegate <NSObject>

- (void)ballDidClick:(YZChartBallView *)btn;

@end

@interface YZChartBallView : UIView

@property (nonatomic, strong) UIFont * textFont;//字体大小

@property (nonatomic, strong) YZChartBallStatus *status;

@property (nonatomic, weak) id<YZChartBallViewDelegate> delegate;

@end
