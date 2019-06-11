//
//  YZFBMatchDetailTitleView.h
//  ez
//
//  Created by apple on 17/1/12.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZFBMatchDetailTitleViewDelegate <NSObject>

- (void)scrollViewScrollIndex:(NSInteger)index;

@end

@interface YZFBMatchDetailTitleView : UIView

@property (nonatomic, assign) id<YZFBMatchDetailTitleViewDelegate> delegate;
- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;
- (void)changeSelectedBtnIndex:(NSInteger)index;

@end
