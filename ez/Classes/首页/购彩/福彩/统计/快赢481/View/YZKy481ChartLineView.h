//
//  YZKy481ChartLineView.h
//  ez
//
//  Created by dahe on 2019/12/3.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ky481ChartHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZKy481ChartLineView : UIView

@property (nonatomic, assign) KChartCellTag chartCellTag;
@property (nonatomic, strong) NSArray *statusArray;

@end

NS_ASSUME_NONNULL_END
