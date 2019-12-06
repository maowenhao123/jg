//
//  YZ11x5ChartLineView.h
//  ez
//
//  Created by dahe on 2019/12/6.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZ11x5ChartHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZ11x5ChartLineView : UIView

@property (nonatomic, assign) KChartCellTag chartCellTag;
@property (nonatomic, strong) NSArray *statusArray;

@end

NS_ASSUME_NONNULL_END
