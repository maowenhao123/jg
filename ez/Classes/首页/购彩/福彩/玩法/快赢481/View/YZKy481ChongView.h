//
//  YZKy481ChongView.h
//  ez
//
//  Created by dahe on 2019/11/5.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZSelectBallCellStatus.h"
#import "YZBallBtn.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YZKy481ChongViewDelegate <NSObject>

@optional
- (void)ballDidClick:(YZBallBtn *)btn;
@end

@interface YZKy481ChongView : UIView

@property (nonatomic, strong) YZSelectBallCellStatus *status;//数据模型
@property (nonatomic, assign) NSInteger selectedPlayTypeBtnTag;
@property (nonatomic, strong) NSMutableArray *selStatusArray;
@property (nonatomic, weak) id<YZKy481ChongViewDelegate> delegate;

@property (nonatomic, strong) NSMutableSet *randomSet;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
