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
{
    int oneMinute;
}
@property (nonatomic,weak) UIView * backView;
@property (nonatomic, weak) UITextField * textField;
@property (nonatomic, weak) UIButton *codeBtn;
@property (nonatomic, weak) UIButton *forgetPwdButton;
@property (nonatomic, weak) UIButton *changeButton;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) int type;//1密码 2验证码

@end

@implementation YZWithdrawalPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.type = 1;
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    self.backgroundColor = YZColor(0, 0, 0, 0.4);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    CGFloat backViewW = screenWidth * 0.85;
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
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(titleLabel.frame) + 20, backView.width - 30, 40)];
    self.textField = textField;
    textField.textColor = YZBlackTextColor;
    textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    textField.placeholder = @"请输入登录密码";
    textField.secureTextEntry = YES;
    textField.backgroundColor = YZColor(236, 236, 236, 1);
    textField.borderStyle = UITextBorderStyleNone;
    textField.layer.masksToBounds = YES;
    textField.layer.cornerRadius = 4;
    [backView addSubview:textField];
    
    //获取验证码
    YZBottomButton * codeBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.codeBtn = codeBtn;
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:YZBlueBallColor forState:UIControlStateNormal];
    [codeBtn setBackgroundImage:[UIImage ImageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];//正常
    [codeBtn setBackgroundImage:[UIImage ImageFromColor:[UIColor clearColor]] forState:UIControlStateHighlighted];//高亮
    [codeBtn setBackgroundImage:[UIImage ImageFromColor:[UIColor clearColor]] forState:UIControlStateDisabled];//不可选
    CGSize codeBtnSize = [codeBtn.currentTitle sizeWithLabelFont:codeBtn.titleLabel.font];
    CGFloat codeBtnW = codeBtnSize.width;
    codeBtn.frame = CGRectMake(textField.width - codeBtnW - YZMargin, 0, codeBtnW, textField.height);
    codeBtn.hidden = YES;
    [codeBtn addTarget:self action:@selector(getCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [textField addSubview:codeBtn];
    
    //切换按钮
    CGFloat buttonY = CGRectGetMaxY(textField.frame) + 10;
    UIButton *changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changeButton = changeButton;
    changeButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [changeButton setTitleColor:YZBlueBallColor forState:UIControlStateNormal];
    [changeButton setTitle:@"使用短信验证" forState:UIControlStateNormal];
    CGSize changeButtonSize = [changeButton.currentTitle sizeWithLabelFont:changeButton.titleLabel.font];
    changeButton.frame = CGRectMake(15, buttonY, changeButtonSize.width, 20);
    [changeButton addTarget:self action:@selector(changeButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:changeButton];
    
    //忘记密码
    UIButton *forgetPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forgetPwdButton = forgetPwdButton;
    forgetPwdButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [forgetPwdButton setTitleColor:YZBlueBallColor forState:UIControlStateNormal];
    [forgetPwdButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    CGSize forgetPwdButtonSize = [forgetPwdButton.currentTitle sizeWithLabelFont:forgetPwdButton.titleLabel.font];
    forgetPwdButton.frame = CGRectMake(backView.width - forgetPwdButtonSize.width - 15, buttonY, forgetPwdButtonSize.width, 20);
    [forgetPwdButton addTarget:self action:@selector(forgetPwdButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:forgetPwdButton];
    
    CGFloat buttonW = backView.width / 2;
    CGFloat buttonH = 42;
    //分割线
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(forgetPwdButton.frame) + 20, backView.width, 1)];
    line1.backgroundColor = YZWhiteLineColor;
    [backView addSubview:line1];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(buttonW, CGRectGetMaxY(forgetPwdButton.frame) + 20, 1, buttonH)];
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
    [confirmBtn setTitleColor:YZBaseColor forState:UIControlStateNormal];
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

- (void)changeButtonDidClick
{
    [self endEditing:YES];
    self.textField.text = @"";
    if (self.type == 1) {
        self.type = 2;
        [self.changeButton setTitle:@"使用密码验证" forState:UIControlStateNormal];
        self.forgetPwdButton.hidden = YES;
        self.textField.secureTextEntry = NO;
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.codeBtn.hidden = NO;
    }else
    {
        self.type = 1;
        [self.changeButton setTitle:@"使用短信验证" forState:UIControlStateNormal];
        self.forgetPwdButton.hidden = NO;
        self.textField.secureTextEntry = YES;
        self.textField.keyboardType = UIKeyboardTypeDefault;
        self.codeBtn.hidden = YES;
    }
}

- (void)forgetPwdButtonDidClick
{
    YZSecretChangeViewController *secretVc = [[YZSecretChangeViewController alloc] init];
    [self.viewController.navigationController pushViewController:secretVc animated:YES];
}

- (void)confirmBtnClick
{
    if (YZStringIsEmpty(self.textField.text)) {
        if (self.type == 1) {
            [MBProgressHUD showError:@"您还未输入密码"];
        }else
        {
            [MBProgressHUD showError:@"您还未输入验证码"];
        }
        return;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(withDrawalWithPassWord:type:)]) {
        [_delegate withDrawalWithPassWord:self.textField.text type:self.type];
    }
    [self removeFromSuperview];
}

- (void)getCodeBtnPressed
{
    [self endEditing:YES];
    
    NSDictionary *dict = @{
                           @"cmd": @(12002),
                           @"userId": UserId
                           };
    self.codeBtn.enabled = NO;
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            YZUser *user = [YZUserDefaultTool user];
            [MBProgressHUD showSuccess:[NSString stringWithFormat:@"验证码已发送至%@", user.mobilePhone]];
            //倒计时
            [self countDown];
        }else
        {
            ShowErrorView
            //倒计时失效
            self.codeBtn.enabled = YES;
            [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.timer invalidate];
            self.timer = nil;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"获取验证码失败"];
        //倒计时失效
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }];
}

- (void)countDown
{
    oneMinute = 60;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextSecond) userInfo:nil repeats:YES];
    self.timer =timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)nextSecond
{
    self.codeBtn.enabled = NO;
    if(oneMinute > 0)
    {
        oneMinute--;
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%d秒",oneMinute] forState:UIControlStateNormal];
    }else
    {
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
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
