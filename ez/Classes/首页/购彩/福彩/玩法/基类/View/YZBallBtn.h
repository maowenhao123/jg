//
//  YZBallBtn.h
//  ez
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YZBallBtn;

@protocol YZBallBtnDelegate <NSObject>

@optional
- (void)ballDidClick:(YZBallBtn *)btn;
@end

@interface YZBallBtn : UIButton

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *selImageName;
@property (nonatomic, strong) UIColor *ballTextColor;
@property (nonatomic, strong) UIColor *ballSelTextColor;
@property (nonatomic, assign) BOOL isBlue;
@property (nonatomic, strong) id owner;//button属于谁
+ (YZBallBtn *)button;
- (void)ballClick:(YZBallBtn *)btn;//有动画的点击
- (void)ballChangeToWhite;
- (void)ballChangeToRed;
- (void)ballChangeBlue;
@property (nonatomic, weak) id<YZBallBtnDelegate> delegate;

@end
