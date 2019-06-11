//
//  YZFBPlayTypeView.h
//  ez
//
//  Created by 毛文豪 on 2019/5/10.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZTitleButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YZFBPlayTypeViewDelegate <NSObject>

- (void)playTypeDidClickBtn:(UIButton *)btn;

@end

@interface YZFBPlayTypeView : UIView

- (instancetype)initWithFrame:(CGRect)frame selectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag;

@property (nonatomic, weak) YZTitleButton *titleBtn;

- (void)show;

- (void)hidden;

@property (nonatomic, weak) id<YZFBPlayTypeViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
