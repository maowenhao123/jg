//
//  YZFBMatchDetailTypeBtnView.h
//  ez
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZFBMatchDetailTypeBtnViewDelegate <NSObject>

@optional

- (void)typeSegmentControlSelectedIndex:(NSInteger)index;

@end

@interface YZFBMatchDetailTypeBtnView : UIView

@property (nonatomic, weak) UISegmentedControl *segmentedControl;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;
@property (nonatomic, weak) id<YZFBMatchDetailTypeBtnViewDelegate> delegate;

@end
