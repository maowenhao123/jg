//
//  YZFBChoosePlayView.h
//  ez
//
//  Created by apple on 16/5/18.
//  Copyright (c) 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZMatchInfosStatus.h"

@protocol YZFBChoosePlayViewDelegate <NSObject>

- (void)selRateSet:(NSMutableArray *)rateArr;

@end

@interface YZFBChoosePlayView : UIView

@property (nonatomic, assign) int playType;
@property (nonatomic, strong) YZMatchInfosStatus *matchInfos;//一个cell的数据模型
@property (nonatomic, assign) id<YZFBChoosePlayViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame playType:(int)playType;

@end
