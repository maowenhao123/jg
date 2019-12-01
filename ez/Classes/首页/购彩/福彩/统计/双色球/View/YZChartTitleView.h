//
//  YZChartTitleView.h
//  ez
//
//  Created by apple on 17/3/3.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZChartTitleViewDelegate <NSObject>

- (void)scrollViewScrollIndex:(NSInteger)index;

@end

@interface YZChartTitleView : UIView

@property (nonatomic, assign) id<YZChartTitleViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;

- (void)changeSelectedBtnIndex:(NSInteger)index;

@end
