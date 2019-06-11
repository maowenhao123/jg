//
//  YZChartChooseBallView.h
//  ez
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZChartBallView.h"

@protocol YZChartChooseBallViewDelegate <NSObject>

- (void)ballDidClick:(YZChartBallView *)ballView;
- (void)ballViewDidScroll:(CGFloat)offsetX;

@end

@interface YZChartChooseBallView : UIView

@property (nonatomic, weak) UIScrollView *scrollView;//滚动视图

@property (nonatomic, strong) NSMutableArray * ballStatuss;//号码球数组

@property (nonatomic, weak) id<YZChartChooseBallViewDelegate> delegate;


@end
