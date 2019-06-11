//
//  YZBtnsView.h
//  ez
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#define btnsViewH 17
#import <UIKit/UIKit.h>
#import "YZFbBetCellStatus.h"
#import "YZCN.h"

@protocol YZBtnsViewDelegate <NSObject>

@optional
- (void)btnsViewDidClickOddInfoBtn:(UIButton *)btn inBtnsView:(UIView *)btnsView;

@end
@interface YZBtnsView : UIView
@property (nonatomic, strong) NSArray *rates;//按钮的标题
@property (nonatomic, weak) id<YZBtnsViewDelegate> delegate;
@property (nonatomic, strong) YZFbBetCellStatus *status;//数据模型
@property (nonatomic, copy) NSString *CNStr;
@end
