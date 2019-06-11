//
//  YZFBMatchDetailMainView.h
//  ez
//
//  Created by apple on 17/1/12.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZFBMatchDetailStandingsView.h"
#import "YZFBMatchDetailIntegralView.h"
#import "YZFBMatchDetailOddsView.h"
#import "YZFBMatchDetailRecommendView.h"

@protocol YZFBMatchDetailMainViewDelegate <NSObject>

- (void)indexChangeCurrentIndexIsIndex:(NSInteger)index;

@end

@interface YZFBMatchDetailMainView : UIScrollView

@property (nonatomic, weak) YZFBMatchDetailStandingsView * standingsView;
@property (nonatomic, weak) YZFBMatchDetailIntegralView *integralView;
@property (nonatomic, weak) YZFBMatchDetailOddsView * oddsView;
@property (nonatomic, weak) YZFBMatchDetailRecommendView * recommendView;
@property (nonatomic, weak) id<YZFBMatchDetailMainViewDelegate> mainViewDelegate;

@end
