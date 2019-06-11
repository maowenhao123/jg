//
//  UIViewController+YZNoNetController.h
//  ez
//
//  Created by apple on 16/10/27.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZNoNetView.h"

@interface UIViewController (YZNoNetController)<YZNoNetViewDelegate>

/**
 *  为控制器扩展方法，刷新网络时候执行，建议必须实现
 */
- (void)noNetReloadRequest;

/**
 *  显示没有网络
 */
- (void)showNonetWork;

/**
 *  隐藏没有网络
 */
- (void)hiddenNonetWork;

@end
