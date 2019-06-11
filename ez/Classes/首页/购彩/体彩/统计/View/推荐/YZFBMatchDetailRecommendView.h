//
//  YZFBMatchDetailRecommendView.h
//  ez
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZFBMatchDetailRecommendStatus.h"

@interface YZFBMatchDetailRecommendView : UIView

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, strong) YZRecommendRowStatus *recommendRowStatus;

@end
