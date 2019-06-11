//
//  UIViewController+YZNoNetController.m
//  ez
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "UIViewController+YZNoNetController.h"

@implementation UIViewController (YZNoNetController)

- (void)showNonetWork
{
    if (![self hasNonetWorkView]) {
        CGFloat viewH = screenHeight - statusBarH - navBarH;
        CGFloat viewY = 0;
        if (self.navigationController.navigationBarHidden) {
            viewH = screenHeight - statusBarH - navBarH;
            viewY = statusBarH + navBarH;
        }
        YZNoNetView* view = [[YZNoNetView alloc]initWithFrame:CGRectMake(0, viewY, screenWidth, viewH)];
        view.backgroundColor = [UIColor whiteColor];
        view.delegate = self;
        [self.view addSubview:view];
        [self.view bringSubviewToFront:view];//放在最顶部
    }
}
- (void)hiddenNonetWork
{
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[YZNoNetView class]]) {
            [view removeFromSuperview];
        }
    }
}
- (BOOL)hasNonetWorkView
{
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[YZNoNetView class]]) {
            return YES;
        }
    }
    return NO;
}
- (void)reloadNetworkDataSource:(id)sender
{
    if ([self respondsToSelector:@selector(noNetReloadRequest)]) {
        [self performSelector:@selector(noNetReloadRequest)];
    }
}
- (void)noNetReloadRequest
{
    NSLog(@"必须由网络控制器(%@)重写这个方法(%@)，才可以使用再次刷新网络",NSStringFromClass([self class]),NSStringFromSelector(@selector(noNetReloadRequest)));
}

@end
