//
//  YZFBAllPlayView.h
//  ez
//
//  Created by apple on 16/5/18.
//  Copyright (c) 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZMatchInfosStatus.h"

@protocol YZFBAllPlayViewDelegate <NSObject>

- (void)upDateByMatchInfos:(YZMatchInfosStatus *)matchInfos;

@end

@interface YZFBAllPlayView : UIView

@property (nonatomic, strong) YZMatchInfosStatus *matchInfos;//一个cell的数据模型
@property (nonatomic, assign) id<YZFBAllPlayViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame matchInfos:(YZMatchInfosStatus *)matchInfos;

@end
