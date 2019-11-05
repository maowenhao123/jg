//
//  YZBaseViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/12/3.
//  Copyright © 2018 9ge. All rights reserved.
//

#import "YZBaseViewController.h"

@interface YZBaseViewController ()<UIGestureRecognizerDelegate>
{
    id<UIGestureRecognizerDelegate> _delegate;
}

@end

@implementation YZBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.navigationController.viewControllers.count > 1) {
        self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithIcon:@"back_btn_flat" highIcon:@"back_btn_flat" target:self action:@selector(back)];
        // 记录系统返回手势的代理
        _delegate = self.navigationController.interactivePopGestureRecognizer.delegate;
        // 设置系统返回手势的代理为当前控制器
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 设置系统返回手势的代理为我们刚进入控制器的时候记录的系统的返回手势代理
    self.navigationController.interactivePopGestureRecognizer.delegate = _delegate;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.navigationController.childViewControllers.count > 1;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return self.navigationController.viewControllers.count > 1;
}

@end
