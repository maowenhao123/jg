//
//  UIView+LayerEffect.h
//
//  Created by Gxq on 14-6-26.
//  Copyright (c) 2014年 jf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SZ)
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;
/**
 Returns the view's view controller (may be nil).
 */
@property (nullable, nonatomic, readonly) UIViewController *viewController;




@end
