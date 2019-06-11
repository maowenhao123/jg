//
//  YZUnionBuyPlayTypeView.h
//  ez
//
//  Created by 毛文豪 on 2019/5/13.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZTitleButton.h"
NS_ASSUME_NONNULL_BEGIN

@protocol YZUnionBuyPlayTypeViewDelegate <NSObject>

- (void)playTypeDidClick:(UIButton *)btn;

@end

@interface YZUnionBuyPlayTypeView : UIView

@property (nonatomic, strong) YZTitleButton *titleBtn;//头部按钮

@property (nonatomic, weak) id<YZUnionBuyPlayTypeViewDelegate> delegate;

- (void)show;

- (void)hidden;

@end

NS_ASSUME_NONNULL_END
