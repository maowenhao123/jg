//
//  YZKy481PlayTypeView.h
//  ez
//
//  Created by dahe on 2019/11/5.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZTitleButton.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YZKy481PlayTypeViewDelegate <NSObject>

- (void)playTypeDidClickBtn:(UIButton *)btn;

@end

@interface YZKy481PlayTypeView : UIView

- (instancetype)initWithFrame:(CGRect)frame selectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag;

@property (nonatomic, weak) id<YZKy481PlayTypeViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectedPlayTypeBtnTag;
@property (nonatomic, weak) YZTitleButton *titleBtn;

- (void)show;
- (void)hidden;

@end

NS_ASSUME_NONNULL_END
