//
//  YZWithdrawalPasswordView.m
//  ez
//
//  Created by 毛文豪 on 2018/5/22.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZWithdrawalPasswordView.h"
#import "YZSecretChangeViewController.h"

@interface YZWithdrawalPasswordView ()<UIGestureRecognizerDelegate>

@property (nonatomic,weak) UIView * backView;
@property (nonatomic, weak) UITextField * textField;

@end

@implementation YZWithdrawalPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    self.backgroundColor = YZColor(0, 0, 0, 0.4);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidClick)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    CGFloat backViewW = 300;
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backViewW, 0)];
    self.backView = backView;
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    //标题
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"为了您的账户安全";
    titleLabel.textColor = YZBlackTextColor;
    titleLabel.font = [UIFont boldSystemFontOfSize:YZGetFontSize(30)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    CGSize titleLabelSize = [titleLabel.text sizeWithLabelFont:titleLabel.font];
    titleLabel.frame = CGRectMake(0, 30, backView.width, titleLabelSize.height);
    [backView addSubview:titleLabel];
    
    //内容
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame) + 25, backView.width - 30, 37)];
    self.textField = textField;
    textField.backgroundColor = YZBackgroundColor;
    textField.textColor = YZBlackTextColor;
    textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    textField.placeholder = @"请输入登录密码";
    textField.secureTextEntry = YES;
    textField.layer.cornerRadius = 3;
    textField.layer.masksToBounds = YES;
    textField.layer.borderWidth = 0.8;
    textField.layer.borderColor = YZGrayLineColor.CGColor;
    [backView addSubview:textField];
    
    //忘记密码
    UIButton *keybutton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat keybuttonY = CGRectGetMaxY(textField.frame) + 10;
    keybutton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [keybutton setTitleColor:YZBlueBallColor forState:UIControlStateNormal];
    [keybutton setTitle:@"忘记密码" forState:UIControlStateNormal];
    CGSize keybuttonSize = [keybutton.currentTitle sizeWithLabelFont:keybutton.titleLabel.font];
    keybutton.frame = CGRectMake(15, keybuttonY, keybuttonSize.width, 20);
    [keybutton addTarget:self action:@selector(ketbtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:keybutton];
    
    CGFloat buttonW = backView.width / 2;
    CGFloat buttonH = 42;
    //分割线
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(keybutton.frame) + 20, backView.width, 1)];
    line1.backgroundColor = YZWhiteLineColor;
    [backView addSubview:line1];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(buttonW, CGRectGetMaxY(keybutton.frame) + 20, 1, buttonH)];
    line2.backgroundColor = YZWhiteLineColor;
    [backView addSubview:line2];
    
    //取消按钮
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(line1.frame), buttonW, buttonH);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [cancelBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:cancelBtn];
    
    //确定按钮
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(buttonW, CGRectGetMaxY(line1.frame), buttonW, buttonH);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:YZRedTextColor forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:confirmBtn];
    
    self.backView.height = CGRectGetMaxY(confirmBtn.frame);
    backView.center = self.center;
    //动画
    backView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration
                     animations:^{
                         backView.transform = CGAffineTransformMakeScale(1, 1);
     }];
}

- (void)tapDidClick
{
    [self removeFromSuperview];
}

- (void)ketbtnPressed
{
    YZSecretChangeViewController *secretVc = [[YZSecretChangeViewController alloc] init];
    [self.viewController.navigationController pushViewController:secretVc animated:YES];
}

- (void)confirmBtnClick
{
    if (YZStringIsEmpty(self.textField.text)) {
        [MBProgressHUD showError:@"您还未输入密码"];
        return;
    }
    
    [self removeFromSuperview];
    
    if (_delegate && [_delegate respondsToSelector:@selector(withDrawalWithPassWord:)]) {
        [_delegate withDrawalWithPassWord:self.textField.text];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint pos = [touch locationInView:self.backView.superview];
        if (CGRectContainsPoint(self.backView.frame, pos)) {
            return NO;
        }
    }
    return YES;
}

@end
