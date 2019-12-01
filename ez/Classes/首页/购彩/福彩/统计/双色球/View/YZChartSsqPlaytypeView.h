//
//  YZChartSsqPlaytypeView.h
//  ez
//
//  Created by apple on 17/3/10.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZChartSsqPlaytypeViewDelegate <NSObject>

- (void)changePlaytypeIsDantuo:(BOOL)isDantuo;
- (void)closePlaytypeView;

@end

@interface YZChartSsqPlaytypeView : UIView

- (instancetype)initWithIsDantuo:(BOOL)isDantuo;

@property (nonatomic, weak) id<YZChartSsqPlaytypeViewDelegate> delegate;

@end
