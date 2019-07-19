//
//  YZRegisterViewController.m
//  ez
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZRegisterViewController.h"
#import "YZRegisterResultViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZStatusCacheTool.h"
#import "YZValidateTool.h"

@interface YZRegisterViewController ()
{
    int oneMinute;
}
@property (nonatomic, weak) UITextField *accountTextField;
@property (nonatomic, weak) UITextField *verificationCodeTextField;
@property (nonatomic, weak) UIButton *codeBtn;
@property (nonatomic, weak) UITextField *pwdTextField;
@property (nonatomic, weak) UIButton *rightbtn;
@property (nonatomic, weak) UIButton *registerbtn;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YZRegisterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"用户注册";
    
    [self setupChilds];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.accountTextField];
}
- (void)setupChilds
{
    //注册界面
    UIView *registerView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, screenWidth, YZCellH * 3)];
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
    //切圆角
    codeBtn.layer.masksToBounds = YES;
    codeBtn.layer.cornerRadius = 2;
    
    //分割线
    UIView *seperator2 = [[UIView alloc] init];
    seperator2.frame = CGRectMake(0, CGRectGetMaxY(verificationCodeTextField.frame), screenWidth, 1);
    seperator2.backgroundColor = YZGrayLineColor;
    [registerView addSubview:seperator2];
    
    //密码输入框:
    UITextField *pwdTextField = [[UITextField alloc]initWithFrame:CGRectMake(YZMargin,CGRectGetMaxY(seperator2.frame),screenWidth - 2 * YZMargin,YZCellH)];
    self.pwdTextField =pwdTextField;
    pwdTextField.borderStyle = UITextBorderStyleNone;
    pwdTextField.placeholder =@"设置密码，4-20位数字、字母组合";
    pwdTextField.secureTextEntry = YES;//密码模式
    pwdTextField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    pwdTextField.textColor = YZBlackTextColor;
    [registerView addSubview:pwdTextField];
    
    //注册
    YZBottomButton * registerbtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.registerbtn = registerbtn;
    registerbtn.y = CGRectGetMaxY(registerView.frame) + 30;
    [registerbtn setTitle:@"确定" forState:UIControlStateNormal];
    [registerbtn addTarget:self action:@selector(registerBtndone) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerbtn];

    //协议
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightbtn = rightbtn;
    [rightbtn setImage:[UIImage imageNamed:@"bet_weixuanzhong"] forState:UIControlStateNormal];
    [rightbtn setImage:[UIImage imageNamed:@"bet_xuanzhong"] forState:UIControlStateSelected];
    [rightbtn setImage:[UIImage imageNamed:@"bet_xuanzhong"] forState:UIControlStateHighlighted];
    rightbtn.selected = YES;
    rightbtn.frame = CGRectMake(YZMargin, CGRectGetMaxY(registerbtn.frame) + 10, 25, 23.2);
    [rightbtn addTarget:self action:@selector(clickrightbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightbtn];
    
    UILabel *labelmeg = [[UILabel alloc] init];
    labelmeg.text = @"我已满18周岁并同意";
    labelmeg.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    labelmeg.textAlignment = NSTextAlignmentLeft;
    labelmeg.textColor = YZColor(134, 134, 134, 1);
    CGSize labelmegSize = [labelmeg.text sizeWithLabelFont:labelmeg.font];
    labelmeg.frame = CGRectMake(CGRectGetMaxX(rightbtn.frame) + 3, CGRectGetMaxY(registerbtn.frame) + 10, labelmegSize.width, 23.2);
    [self.view addSubview:labelmeg];
    
    UIButton *megBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [megBtn setTitle:@"《用户注册协议》" forState:UIControlStateNormal];
    [megBtn setTitleColor:YZBlueBallColor forState:UIControlStateNormal];
    megBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    CGSize megBtnSize = [megBtn.currentTitle sizeWithLabelFont:megBtn.titleLabel.font];
    megBtn.frame = CGRectMake(CGRectGetMaxX(labelmeg.frame), CGRectGetMaxY(registerbtn.frame) + 10, megBtnSize.width, 23.2);
    [megBtn addTarget:self action:@selector(seeAgreement) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:megBtn];
}
#pragma  mark - 获取验证码按钮点击
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
#pragma  mark - 点击加载对应的url
-(void)seeAgreement
{
    YZLoadHtmlFileController *htmlVc = [[YZLoadHtmlFileController alloc] initWithFileName:@"yhfwagreement.htm"];
    htmlVc.title = @"用户注册协议";
    [self.navigationController pushViewController:htmlVc animated:YES];
}
-(void)clickrightbtn:(UIButton *)sender
{
    self.rightbtn.selected = !self.rightbtn.selected;
}
//向服务器注册
- (void)registerBtndone
{
    [self.view endEditing:YES];
    if (YZStringIsEmpty(self.accountTextField.text)) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if (YZStringIsEmpty(self.verificationCodeTextField.text)) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    if (YZStringIsEmpty(self.pwdTextField.text)) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    if(![YZValidateTool validateUserName:self.accountTextField.text])
    {
        [MBProgressHUD showError:@"您输入的用户名格式不对"];
        return;
    }
    if(![YZValidateTool validatePassword:self.pwdTextField.text])
    {
        [MBProgressHUD showError:@"您输入的密码格式不对"];
        return;
    }
    if(!self.rightbtn.selected)
    {
        [MBProgressHUD showError:@"您必须同意用户注册协议"];
        return;
    }
    [MBProgressHUD showMessage:@"正在注册,客官请稍后" toView:self.view];
    NSDictionary *dict = @{
                           @"cmd":@(10610),
                           @"phone":self.accountTextField.text,
                           @"passwd":self.pwdTextField.text,
                           @"verifyCode":self.verificationCodeTextField.text
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"json = %@",json);
        [MBProgressHUD hideHUDForView:self.view];
        //检查账号密码返回数据
        [self checkRegistWith:json];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"账户error");
    }];
}
- (void)checkRegistWith:(id)json
{
    if(SUCCESS)
    {
        //存储userId
        [YZUserDefaultTool saveObject:json[@"userId"] forKey:@"userId"];
        
        //存储账户密码
        [YZUserDefaultTool saveObject:self.accountTextField.text forKey:@"userName"];
        [YZUserDefaultTool saveObject:self.pwdTextField.text forKey:@"userPwd"];

        //账号登录
        [YZUserDefaultTool saveObject:@"accountLogin" forKey:@"loginWay"];
        //发送登录成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:loginSuccessNote object:nil];
        [YZTool setAlias];
        YZRegisterResultViewController *result = [[YZRegisterResultViewController alloc] init];
        [self.navigationController pushViewController:result animated:YES];
    }else
    {   
        ShowErrorView
    }
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
