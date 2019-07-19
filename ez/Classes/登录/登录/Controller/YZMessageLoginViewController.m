//
//  YZMessageLoginViewController.m
//  ez
//
//  Created by 毛文豪 on 2019/4/19.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZMessageLoginViewController.h"
#import "YZRegisterResultViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZStatusCacheTool.h"
#import "YZValidateTool.h"

@interface YZMessageLoginViewController ()
{
    int oneMinute;
}
@property (nonatomic, weak) UITextField *phoneTextField;
@property (nonatomic, weak) UITextField *codeTextField;
@property (nonatomic, weak) UIButton *codeBtn;
@property (nonatomic, weak) UIButton *loginBtn;
@property (nonatomic, strong) NSTimer *timer;
    
@end

@implementation YZMessageLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"短信验证码登录";
    [self setupChilds];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.phoneTextField];
}
- (void)setupChilds
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, screenWidth, YZCellH * 2)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
        
    //账号输入框:
    UITextField *phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(YZMargin,0,screenWidth - 2 * YZMargin,YZCellH)];
    self.phoneTextField = phoneTextField;
    phoneTextField.placeholder = @"请输入手机号码";
    phoneTextField.textColor = YZBlackTextColor;
    phoneTextField.borderStyle = UITextBorderStyleNone;
    phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneTextField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [contentView addSubview:phoneTextField];
        
    //分割线
    UIView *seperator1 = [[UIView alloc] init];
    seperator1.frame = CGRectMake(0, CGRectGetMaxY(phoneTextField.frame), screenWidth, 1);
    seperator1.backgroundColor = YZWhiteLineColor;
    [contentView addSubview:seperator1];
        
    //验证码输入框:
    UITextField *codeTextField = [[UITextField alloc]init];
    self.codeTextField = codeTextField;
    codeTextField.placeholder = @"请输入验证码";
    codeTextField.borderStyle = UITextBorderStyleNone;
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    codeTextField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [contentView addSubview:codeTextField];
        
    CGFloat codeBtnH = 31;
    CGFloat codeBtnY = YZCellH + (YZCellH - codeBtnH) / 2;
    YZBottomButton * codeBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.codeBtn = codeBtn;
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    CGSize codeBtnSize = [codeBtn.currentTitle sizeWithLabelFont:codeBtn.titleLabel.font];
    CGFloat codeBtnW = codeBtnSize.width + 10;
    codeBtn.frame = CGRectMake(screenWidth - codeBtnW - YZMargin, codeBtnY, codeBtnW, codeBtnH);
    codeTextField.frame = CGRectMake(YZMargin, YZCellH, screenWidth - 2 * YZMargin - codeBtnW, YZCellH);
    codeBtn.enabled = NO;//默认不可选
    [codeBtn addTarget:self action:@selector(getCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    codeBtn.layer.masksToBounds = YES;
    codeBtn.layer.cornerRadius = 2;
    [contentView addSubview:codeBtn];
    
    NSString * userName = [YZUserDefaultTool getObjectForKey:@"userName"];
    if ([YZValidateTool validateMobile:userName]) {
        phoneTextField.text = userName;
        codeBtn.enabled = YES;
    }
    
    //登录
    YZBottomButton * loginBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn = loginBtn;
    loginBtn.y = CGRectGetMaxY(contentView.frame) + 30;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}
    
#pragma  mark - 获取验证码按钮点击
- (void)getCodeBtnPressed
{
    if (![YZValidateTool validateMobile:self.phoneTextField.text])//不是手机号码
    {
        [MBProgressHUD showError:@"您输入的手机号格式不对"];
        return;
    }
    NSDictionary *dict = @{
                           @"cmd":@(12013),
                           @"phone":self.phoneTextField.text
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

#pragma mark - 登录
- (void)login
{
    [self.view endEditing:YES];
    if (YZStringIsEmpty(self.phoneTextField.text)) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if(![YZValidateTool validateMobile:self.phoneTextField.text])
    {
        [MBProgressHUD showError:@"您输入的手机号格式不对"];
        return;
    }
    if (YZStringIsEmpty(self.codeTextField.text)) {
        [MBProgressHUD showError:@"请输入验证码"];
        return;
    }
    [MBProgressHUD showMessage:@"正在登录,客官请稍后" toView:self.view];
    NSString * imei = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary *dict = @{
                           @"cmd": @(10637),
                           @"phone": self.phoneTextField.text,
                           @"verifyCode": self.codeTextField.text,
                           @"imei": imei
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"json = %@",json);
        [MBProgressHUD hideHUDForView:self.view];
        //检查账号密码返回数据
        [self checkloginWith:json];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"账户error");
    }];
}
    
- (void)checkloginWith:(id)json
{
    if(SUCCESS)
    {//成功登录
        //保存用户信息
        YZUser *user = [YZUser objectWithKeyValues:json];
        [YZUserDefaultTool saveUser:user];
        //存储userId和userName
        [YZUserDefaultTool saveObject:json[@"userId"] forKey:@"userId"];
        [YZUserDefaultTool saveObject:self.phoneTextField.text forKey:@"userName"];//userAccount
        //发送登录成功通知
        [[NSNotificationCenter defaultCenter] postNotificationName:loginSuccessNote object:nil];
        [self loadUserInfo];
        [YZTool setAlias];
        [self back];
    }else
    {
        ShowErrorView
        [MBProgressHUD hideHUDForView:self.view];
    }
}

- (void)loadUserInfo
{
    if (!UserId)
    {
        return;
    }
    NSDictionary *dict = @{
                           @"cmd":@(8006),
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        YZLog(@"%@",json);
        if (SUCCESS) {
            //存储用户信息
            YZUser *user = [YZUser objectWithKeyValues:json];
            [YZUserDefaultTool saveUser:user];
        }
    } failure:^(NSError *error) {
        YZLog(@"账户error");
    }];
}
    
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
//限制输入字符个数
-(void)textFieldEditChanged:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)notification.object;
    if (textField == self.phoneTextField) {
        if(![YZValidateTool validateMobile:self.phoneTextField.text])//手机号验证
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
                                                 object:self.phoneTextField];
}


@end
