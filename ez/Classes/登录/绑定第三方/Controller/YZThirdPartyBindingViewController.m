//
//  YZThirdPartyBindingViewController.m
//  ez
//
//  Created by apple on 16/12/15.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZThirdPartyBindingViewController.h"
#import "YZValidateTool.h"

@interface YZThirdPartyBindingViewController ()
{
    int oneMinute;
}
@property (nonatomic, weak) UITextField *accountTextField;
@property (nonatomic, weak) UITextField *verificationCodeTextField;
@property (nonatomic, weak) UIButton *codeBtn;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YZThirdPartyBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    self.view.backgroundColor = YZBackgroundColor;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.accountTextField];
    [self setupChilds];
}
- (void)setupChilds
{
    //注册界面
    UIView *registerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, screenWidth, YZCellH * 2)];
    registerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:registerView];
    
    //账号输入框:
    UITextField *accountTextField = [[UITextField alloc]initWithFrame:CGRectMake(YZMargin,0,screenWidth - 2 * YZMargin,YZCellH)];
    self.accountTextField = accountTextField;
    accountTextField.placeholder = @"请输入手机号码";
    accountTextField.textColor = YZBlackTextColor;
    accountTextField.borderStyle = UITextBorderStyleNone;
    accountTextField.keyboardType = UIKeyboardTypeNumberPad;
    accountTextField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [registerView addSubview:accountTextField];
    
    //分割线
    UIView *seperator1 = [[UIView alloc] init];
    seperator1.frame = CGRectMake(0, CGRectGetMaxY(accountTextField.frame), screenWidth, 1);
    seperator1.backgroundColor = YZGrayLineColor;
    [registerView addSubview:seperator1];
    
    //验证码输入框:
    UITextField *verificationCodeTextField = [[UITextField alloc]init];
    self.verificationCodeTextField = verificationCodeTextField;
    verificationCodeTextField.placeholder = @"请输入验证码";
    verificationCodeTextField.borderStyle = UITextBorderStyleNone;
    verificationCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    verificationCodeTextField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [registerView addSubview:verificationCodeTextField];
    
    CGFloat codeBtnH = 31;
    CGFloat codeBtnY = YZCellH + (YZCellH - codeBtnH) / 2;
    YZBottomButton * codeBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.codeBtn = codeBtn;
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    CGSize codeBtnSize = [codeBtn.currentTitle sizeWithLabelFont:codeBtn.titleLabel.font];
    CGFloat codeBtnW = codeBtnSize.width + 10;
    codeBtn.frame = CGRectMake(screenWidth - codeBtnW - YZMargin, codeBtnY, codeBtnW, codeBtnH);
    verificationCodeTextField.frame = CGRectMake(YZMargin, YZCellH, screenWidth - 2 * YZMargin - codeBtnW, YZCellH);
    codeBtn.enabled = NO;//默认不可选
    [codeBtn addTarget:self action:@selector(getCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [registerView addSubview:codeBtn];
    
    //注册
    YZBottomButton *bindingBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    bindingBtn.y = CGRectGetMaxY(registerView.frame) + 30;
    [bindingBtn setTitle:@"开启中奖之旅" forState:UIControlStateNormal];
    [bindingBtn addTarget:self action:@selector(bindingBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bindingBtn];
}

- (void)getCodeBtnPressed
{
    if (![YZValidateTool validateMobile:self.accountTextField.text])//不是手机号码
    {
        [MBProgressHUD showError:@"您输入的手机号格式不对"];
        return;
    }
    NSDictionary *dict = @{
                           @"cmd":@(12001),
                           @"phone":self.accountTextField.text
                           };
    self.codeBtn.enabled = NO;
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
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
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }];
}
- (void)countDown
{
    [self.view endEditing:YES];
    oneMinute = 60;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextSecond) userInfo:nil repeats:YES];
    self.timer =timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)nextSecond
{
    if(oneMinute > 0)
    {
        self.codeBtn.enabled = NO;
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
- (void)bindingBtnDidClick
{
    NSDictionary *dict = @{
                           @"cmd":@(10631),
                           @"phone":self.accountTextField.text,
                           @"verifyCode":self.verificationCodeTextField.text,
                           @"type":self.type,
                           @"param":self.param,
                           @"imei":self.imei
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"json:%@",json);
        if(SUCCESS)
        {
            [YZUserDefaultTool saveObject:json[@"userId"] forKey:@"userId"];
            //用于绑定Alias的
            [YZTool setAlias];
            //第三方的信息
            [YZUserDefaultTool saveObject:@"thirdPartyLogin" forKey:@"loginWay"];
            [YZUserDefaultTool saveThirdPartyStatus:self.thirdPartyStatus];
            //更新自动登录状态
            int autoLoginType = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"autoLogin"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:autoLoginType forKey:@"autoLogin"];
            [defaults synchronize];
            //发送登录成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:loginSuccessNote object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"账户error");
    }];
}
//限制输入字符个数
-(void)textFieldEditChanged:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)notification.object;
    if (textField == self.accountTextField) {
        if(![YZValidateTool validateMobile:self.accountTextField.text])//手机号验证
        {
            self.codeBtn.enabled = NO;
        }else
        {
            self.codeBtn.enabled = YES;
        }
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.accountTextField];
}

@end
