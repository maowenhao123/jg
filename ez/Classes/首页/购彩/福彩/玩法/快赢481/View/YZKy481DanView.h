//
//  YZKy481DanView.h
//  ez
//
//  Created by dahe on 2019/11/5.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZSelectBallCellStatus.h"
#import "YZBallBtn.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YZKy481DanViewDelegate <NSObject>

@optional
- (void)ballDidClick:(YZBallBtn *)btn;
@end

@interface YZKy481DanView : UIView

@property (nonatomic, strong) YZSelectBallCellStatus *status;//数据模型
@property (nonatomic, assign) NSInteger selectedPlayTypeBtnTag;
@property (nonatomic, strong) NSMutableArray *selStatusArray;
@property (nonatomic, weak) id<YZKy481DanViewDelegate> delegate;
@property (nonatomic, strong) NSMutableSet *randomSet;

- (void)reloadData;

@end

NS_ASSUME_NONNULL_END
