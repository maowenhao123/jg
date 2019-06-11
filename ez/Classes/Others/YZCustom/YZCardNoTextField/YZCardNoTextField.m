//
//  YZCardNoTextField.m
//  ez
//
//  Created by apple on 16/12/1.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZCardNoTextField.h"
#import "UITextField+YZTextFieldSelected.h"

@interface YZCardNoTextField ()
/** X按钮 */
@property (nonatomic, strong) UIButton *XButton;

@property (nonatomic, assign) BOOL willShowKeyboard;

@property (nonatomic, assign) BOOL displayingKeyboard;
@end

@implementation YZCardNoTextField

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.adjustTextFeildH = YES;
    self.keyboardType = UIKeyboardTypeNumberPad;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeginShow:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillEndShow:) name:UITextFieldTextDidEndEditingNotification object:nil];
}

- (void)dealloc {
    //注销通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillBeginShow:(NSNotification *)notification {
    if (self.keyboardType != UIKeyboardTypeNumberPad) return;
    self.willShowKeyboard = notification.object == self;
}


- (void)keyboardWillEndShow:(NSNotification *)notification {
    if (self.keyboardType != UIKeyboardTypeNumberPad) return;
    self.willShowKeyboard = NO;
    NSDictionary *userInfo = [notification userInfo];
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    NSInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    // 添加动画
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    self.XButton.transform = CGAffineTransformIdentity;
    [self.XButton removeFromSuperview];
    [UIView commitAnimations];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (self.keyboardType != UIKeyboardTypeNumberPad) return;
    if (!self.willShowKeyboard) {
        self.displayingKeyboard = YES;
        return;
    }
    [self.XButton removeFromSuperview];
    self.XButton = nil;
    
    NSDictionary *userInfo = [notification userInfo];
    // 动画时间
    CGFloat animationDuration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    // 键盘的Frame
    CGRect kbEndFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat kbHeight = kbEndFrame.size.height;
    
    // 获取到最上层的window,这句代码很关键
    UIWindow *tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    
    if (iOS9) {
        tempWindow = [[[UIApplication sharedApplication] windows] lastObject];
    }
    
    // 通过图层查看系统的键盘有UIKeyboardAutomatic这个View，第三方的对应位置的view为_UISizeTrackingView
    if (![self ff_foundViewInView:tempWindow clazzName:@"UIKeyboardAutomatic"]) return;
    
    // 这里因为用了第三方的键盘顶部，所有加了44
    if (self.adjustTextFeildH) {
        kbHeight = kbEndFrame.size.height - 44;
    }
    
    // 动画的轨迹
    NSInteger animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    // 按钮的位置计算
    CGFloat XButtonX = 0;
    CGFloat XButtonW = 0;
    CGFloat XButtonH = 0;
    // 为了适配不同屏幕
    if (screenWidth == 320) {
        XButtonW = (screenWidth - 6) / 3;
        XButtonH = (kbHeight - 2) / 4;
    } else if (screenWidth == 375) {
        XButtonW = (screenWidth - 8) / 3;
        XButtonH = (kbHeight - 2) / 4;
    } else if (screenWidth == 414) {
        XButtonW = (screenWidth - 7) / 3;
        XButtonH = kbHeight / 4;
    }
    CGFloat doneButtonY = 0;
    if (self.displayingKeyboard) {
        doneButtonY = screenHeight - XButtonH;
    } else {
        doneButtonY = screenHeight + kbHeight - XButtonH;
    }
    UIButton *XButton = [[UIButton alloc] initWithFrame:CGRectMake(XButtonX, doneButtonY, XButtonW, XButtonH)];
    XButton.titleLabel.font = [UIFont systemFontOfSize:27];
    [XButton setTitle:@"X" forState:(UIControlStateNormal)];
    [XButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [XButton setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:XButton.bounds] forState:UIControlStateHighlighted];
    [XButton addTarget:self action:@selector(XButton:) forControlEvents:UIControlEventTouchUpInside];
    self.XButton = XButton;
    // 添加按钮
    [tempWindow addSubview:XButton];
    
    if (!self.displayingKeyboard) {
        // 添加动画
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        XButton.transform = CGAffineTransformTranslate(XButton.transform, 0, -kbHeight);
        [UIView commitAnimations];
    }
    self.displayingKeyboard = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.keyboardType != UIKeyboardTypeNumberPad) return;
    self.displayingKeyboard = NO;
}

#pragma mark - 私有方法
/**
 *  X按钮点击
 */
- (void)XButton:(UIButton *)doneButton{
    // 获得光标所在的位置
    NSUInteger insertIndex = [self selectedRange].location;
    
    NSMutableString *string = [NSMutableString stringWithString:self.text];
    
    [string insertString:doneButton.currentTitle atIndex:insertIndex];
    
    // 重新赋值
    self.text = string;
    
    // 让光标回到插入文字后面
    [self setSelectedRange:NSMakeRange(insertIndex + 1, 0)];
}
/**
 *  输出所有子控件
 */
- (UIView *)ff_foundViewInView:(UIView *)view clazzName:(NSString *)clazzName {
    // 递归出口
    if ([view isKindOfClass:NSClassFromString(clazzName)]) {
        return view;
    }
    // 遍历所有子视图
    for (UIView *subView in view.subviews) {
        UIView *foundView = [self ff_foundViewInView:subView clazzName:clazzName];
        if (foundView) {
            return foundView;
        }
    }
    return nil;
}

@end
