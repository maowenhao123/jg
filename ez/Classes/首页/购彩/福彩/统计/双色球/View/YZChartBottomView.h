//
//  YZChartBottomView.h
//  ez
//
//  Created by apple on 17/3/3.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZChartBottomViewDelegate <NSObject>

- (void)confirmBuy;

@end

@interface YZChartBottomView : UIView

@property (nonatomic, assign) id<YZChartBottomViewDelegate> delegate;

@property (nonatomic, weak) UILabel *label;

@property (nonatomic, assign) BOOL canBuy;//是否可以购买

@end
