//
//  YZAdjustNumberView.m
//  ez
//
//  Created by 毛文豪 on 2018/5/29.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZAdjustNumberView.h"

@interface YZAdjustNumberView ()<UITextFieldDelegate>
{
    UIButton *_decreaseBtn;
    UIButton *_increaseBtn;
    UIImageView * _backgroundImageView;
}

@end

@implementation YZAdjustNumberView


- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    [self commonSetup];
}

- (void)setCurrentNum:(NSString *)currentNum{
    self.textField.text = currentNum;
    if ([currentNum intValue] == 1)//为1时 不能减
    {
        _decreaseBtn.enabled = NO;
    }else
    {
        _decreaseBtn.enabled = YES;
    }
}

- (NSString *)currentNum{
    return self.textField.text;
}

- (instancetype)init{
    if (self = [super init]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    
    self.frame = CGRectMake(0, 0, 90, 27);
    
    _backgroundImageView = [[UIImageView alloc] init];
    _backgroundImageView.image = [UIImage imageNamed:@"shoppingcar_addmin_background"];
    [self addSubview:_backgroundImageView];
    
    _decreaseBtn = [[UIButton alloc] init];
    [self setupButton:_decreaseBtn normalImage:@"shoppingcar_min" HighlightImage:@"shoppingcar_min" disabledImage:@"shoppingcar_min_gray"];
    [self addSubview:_decreaseBtn];
    
    _increaseBtn = [[UIButton alloc] init];
    [self setupButton:_increaseBtn normalImage:@"shoppingcar_add" HighlightImage:@"shoppingcar_add" disabledImage:@"shoppingcar_add"];
    [self addSubview:_increaseBtn];
    
    UITextField * textField = [[UITextField alloc] init];
    self.textField = textField;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    textField.textColor = YZBlackTextColor;
    textField.delegate = self;
    [self addSubview:textField];
    // 监听textField文字改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:self.textField];
    //监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self commonSetup];
}

- (void)commonSetup{
    CGFloat viewH = self.frame.size.height;
    CGFloat viewW = self.frame.size.width;
    
    _backgroundImageView.frame = CGRectMake(0, 0, viewW, viewH);
    _decreaseBtn.frame = CGRectMake(0, 0, viewH, viewH);
    _increaseBtn.frame = CGRectMake(viewW - viewH, 0, viewH, viewH);
    _textField.frame = CGRectMake(viewH, 0, viewW - viewH * 2, viewH);
}

- (void)setupButton:(UIButton *)btn normalImage:(NSString *)norImage HighlightImage:(NSString *)highImage disabledImage:(NSString *)disImage{
    [btn setImage:[UIImage imageNamed:norImage] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:disImage] forState:UIControlStateDisabled];
    [btn addTarget:self action:@selector(btnTouchDown:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnTouchDown:(UIButton *)btn{
    
    if (btn == _increaseBtn) {
        [self increase];
    } else {
        [self decrease];
    }
}

- (void)increase{
    if (self.textField.text.length == 0) {
        self.textField.text = @"1";
    }
    if([self.textField.text intValue] >= self.max)//最大值
    {
        self.textField.text = [NSString stringWithFormat:@"%ld",self.max];
    }
    if([self.textField.text intValue] <= self.min && self.min != 0)//最小值
    {
        self.textField.text = [NSString stringWithFormat:@"%ld",self.min];
    }
    
    int newNum = [self.textField.text intValue] + 1;
    if (newNum > 0 && newNum <= self.max) {
        self.textField.text = [NSString stringWithFormat:@"%i", newNum];
        if (_delegate && [_delegate respondsToSelector:@selector(adjustNumbeView:currentNumber:)]) {
            [_delegate adjustNumbeView:self currentNumber:self.textField.text];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(increaseNumberAdjustNumbeView:currentNumber:)]) {
            [_delegate increaseNumberAdjustNumbeView:self currentNumber:self.textField.text];
        }
        _decreaseBtn.enabled = YES;
    }
}

- (void)decrease{
    if (self.textField.text.length == 0) {
        self.textField.text = @"1";
    }
    if([self.textField.text intValue] <= self.min && self.min != 0)//最小值
    {
        self.textField.text = [NSString stringWithFormat:@"%ld",self.min];
        return;
    }
    int newNum = [self.textField.text intValue] -1;
    if (newNum > 0) {
        self.textField.text = [NSString stringWithFormat:@"%i", newNum];
        if (_delegate && [_delegate respondsToSelector:@selector(adjustNumbeView:currentNumber:)]) {
            [_delegate adjustNumbeView:self currentNumber:self.textField.text];
        }
        if (_delegate && [_delegate respondsToSelector:@selector(decreaseNumberAdjustNumbeView:currentNumber:)]) {
            [_delegate decreaseNumberAdjustNumbeView:self currentNumber:self.textField.text];
        }
    }
    if (newNum == 1) {//为1时 不能减
        _decreaseBtn.enabled = NO;
    }
}

- (void)textFieldDidChange
{
    if([self.textField.text intValue] > self.max)//最大值
    {
        self.textField.text = [NSString stringWithFormat:@"%ld",self.max];
    }
}

- (void)keyboardWillHide:(NSNotification *)note
{
    if([self.textField.text isEqualToString:@""])//没有值时 显示1
    {
        self.textField.text = @"1";
    }
    if ([self.textField.text intValue] == 1)//为1时 不能减
    {
        _decreaseBtn.enabled = NO;
    }else
    {
        _decreaseBtn.enabled = YES;
    }
    
    if([self.textField.text intValue] <= self.min && self.min != 0)//最小值
    {
        self.textField.text = [NSString stringWithFormat:@"%ld",self.min];
    }
}
- (void)keyboardDidHide:(NSNotification *)note
{
    if (_delegate && [_delegate respondsToSelector:@selector(adjustNumbeView:currentNumber:)]) {
        [_delegate adjustNumbeView:self currentNumber:self.textField.text];
    }
}
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView * view = [super hitTest:point withEvent:event];
//    if (view == nil) {
//        for (UIView * subView in self.subviews) {
//            // 将坐标系转化为自己的坐标系
//            CGPoint tp = [subView convertPoint:point fromView:self];
//            if (CGRectContainsPoint(subView.bounds, tp)) {
//                view = subView;
//            }
//        }
//    }
//    return view;
//}
#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.textField];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}


@end
