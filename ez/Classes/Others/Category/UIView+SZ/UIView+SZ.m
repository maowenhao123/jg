//
//  UIView+LayerEffect.m
//
//  Created by Gxq on 14-6-26.
//  Copyright (c) 2014年 jf. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "UIView+SZ.h"

@implementation UIView (SZ)

//适配xcode12tablecell问题
+ (void)load
{
    Method originalMethod = class_getInstanceMethod([self class], @selector(addSubview:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(addSubviewS:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)addSubviewS:(UIView *)view
{
    if ([self isKindOfClass:[UITableViewCell class]]) {
        //cell自己添加contentView不可以更改
        if([view isKindOfClass:[NSClassFromString(@"UITableViewCellContentView") class]]){
            [self addSubviewS:view];
        }else
        {
            //如果是cell自己添加view则改用它的contentView添加
            UITableViewCell *cell = (UITableViewCell *)self;
            [cell.contentView addSubview:view];
            
        }
    }else
    {
        [self addSubviewS:view];
    }
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
