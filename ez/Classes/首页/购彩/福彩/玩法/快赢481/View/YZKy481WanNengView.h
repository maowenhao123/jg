//
//  YZKy481WanNengView.h
//  ez
//
//  Created by dahe on 2019/11/5.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZSelectBallCellStatus.h"
#import "YZBallBtn.h"

NS_ASSUME_NONNULL_BEGIN
@protocol YZKy481WanNengViewDelegate <NSObject>

@optional
- (void)ballDidClick:(YZBallBtn *)btn;
@end

@interface YZKy481WanNengView : UIView

@property (nonatomic, strong) YZSelectBallCellStatus *status;//数据模型
@property (nonatomic, copy) NSString * randomTitle;
@property (nonatomic, weak) id<YZKy481WanNengViewDelegate> delegate;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
