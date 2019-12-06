//
//  YZChartPlayTypeView.h
//  ez
//
//  Created by 毛文豪 on 2019/12/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZTitleButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YZChartPlayTypeViewDelegate <NSObject>

- (void)playTypeDidClickBtn:(UIButton *)btn;

@end

@interface YZChartPlayTypeView : UIView

- (instancetype)initWithFrame:(CGRect)frame gameId:(NSString *)gameId selectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag;

@property (nonatomic, weak) YZTitleButton *titleBtn;
@property (nonatomic, weak) id<YZChartPlayTypeViewDelegate> delegate;

- (void)show;
- (void)hidden;

@end

NS_ASSUME_NONNULL_END
