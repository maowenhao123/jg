//
//  YZBasketBallAllPlayView.h
//  ez
//
//  Created by 毛文豪 on 2018/5/22.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZMatchInfosStatus.h"

@protocol YZBasketBallAllPlayViewDelegate <NSObject>

- (void)upDateByMatchInfosModel:(YZMatchInfosStatus *)matchInfosModel;

@end

@interface YZBasketBallAllPlayView : UIView

@property (nonatomic, assign) id<YZBasketBallAllPlayViewDelegate> delegate;

@property (nonatomic, strong) YZMatchInfosStatus *matchInfosModel;//一个cell的数据模型

@property (nonatomic, assign) BOOL onlyShowShengfen;

- (instancetype)initWithFrame:(CGRect)frame matchInfosModel:(YZMatchInfosStatus *)matchInfosModel onlyShowShengfen:(BOOL)onlyShowShengfen;

@end
