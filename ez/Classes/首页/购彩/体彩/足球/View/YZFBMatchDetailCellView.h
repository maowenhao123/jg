//
//  YZFBMatchDetailCellView.h
//  ez
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZFBMatchDetailStatus.h"

@protocol YZFBMatchDetailCellViewDelegate <NSObject>

@optional
- (void)showDetailBtnDidClick;
@end

@interface YZFBMatchDetailCellView : UIView

@property (nonatomic, strong) YZFBMatchDetailStatus *matchDetailStatus;
@property (nonatomic, weak) id<YZFBMatchDetailCellViewDelegate> delegate;

@end
