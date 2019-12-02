//
//  YZKy481ChartPlayTypeView.h
//  ez
//
//  Created by 毛文豪 on 2019/12/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZChartPlayTypeTitleButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YZKy481ChartPlayTypeViewDelegate <NSObject>

- (void)playTypeDidClickBtn:(UIButton *)btn;

@end

@interface YZKy481ChartPlayTypeView : UIView

- (instancetype)initWithFrame:(CGRect)frame selectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag;

@property (nonatomic, weak) YZChartPlayTypeTitleButton *titleBtn;
@property (nonatomic, weak) id<YZKy481ChartPlayTypeViewDelegate> delegate;

- (void)show;
- (void)hidden;

@end

NS_ASSUME_NONNULL_END
