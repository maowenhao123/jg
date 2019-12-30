//
//  YZKy481BaseView.h
//  ez
//
//  Created by dahe on 2019/12/30.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZSelectBallCellStatus.h"
#import "YZBallBtn.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YZKy481ViewDelegate <NSObject>

@optional
- (void)ballDidClick:(UIButton *)btn;

@end

@interface YZKy481BaseView : UIView

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, strong) YZSelectBallCellStatus *status;//数据模型
@property (nonatomic, assign) NSInteger selectedPlayTypeBtnTag;
@property (nonatomic, weak) id<YZKy481ViewDelegate> delegate;

- (void)setupChildViews;
- (void)setSelectedPlayTypeBtnTagWith:(NSInteger)selectedPlayTypeBtnTag;
- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
