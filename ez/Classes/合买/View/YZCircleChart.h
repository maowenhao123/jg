//
//  YZCircleChart.h
//  ez
//
//  Created by apple on 15/3/11.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZCircleChart : UIView

@property (nonatomic, strong) NSNumber * selfBuyRatio;//自购比例
@property (nonatomic, strong) NSNumber * guaranteeRatio;//保底比例

- (void)strokeChart;

@end
