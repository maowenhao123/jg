//
//  YZKsDiceAnimationView.h
//  ez
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZKsBaseView.h"

@interface YZKsDiceAnimationView : UIView

@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) int playType;
@property (nonatomic, weak) YZKsBaseView *showView;
- (void)startDiceAnimationWithPlayType:(int)playType showView:(YZKsBaseView *)showView;

@end
