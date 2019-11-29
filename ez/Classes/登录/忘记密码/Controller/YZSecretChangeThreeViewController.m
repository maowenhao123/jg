//
//  YZSecretChangeThreeViewController.m
//  ez
//
//  Created by apple on 14-9-1.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZSecretChangeThreeViewController.h"
#import "YZValidateTool.h"
#import "YZStatusCacheTool.h"

@interface YZSecretChangeThreeViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) UIButton *confirmButton;
@property (nonatomic, weak) UITextField *passWordTF;
@property (nonatomic, weak) UITextField *passWordValidationTF;

@end

@implementation YZSecretChangeThreeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"重置密码";
    //初始化子控件
    [self setupChilds];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.passWordTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.passWordValidationTF];
}
#pragma  mark - 初始化子控件
- (void)setupChilds
{
    //进度
    UIView *progressBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60)];
    progressBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:progressBackView];
    
    CGFloat progressImageViewWH = 18;
    CGFloat progressImageViewY = (60 - progressImageViewWH) / 2;
    CGFloat arrowImageViewW = 42;
    CGFloat arrowImageViewH = 5;
    CGFloat arrowImageViewY = (60 - arrowImageViewH) / 2;
    NSMutableArray *progressViews = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIView * progressView = [[UIView alloc]init];
        [progressBackView addSubview:progressView];
        
        //图片
        UIImageView * progressImageView = [[UIImageView alloc]init];
        if (i == 0) {
            progressImageView.image = [UIImage imageNamed:@"secretChange1_red"];
        }else if (i == 1)
        {
            progressImageView.image = [UIImage imageNamed:@"secretChange2_red"];
        }else if (i == 2)
        {
            progressImageView.image = [UIImage imageNamed:@"secretChange3_red"];
        }
        [progressView addSubview:progressImageView];
        
        //文字
        UILabel * progressLabel = [[UILabel alloc]init];
        if (i == 0) {
            progressLabel.text = @"验证信息";
        }else if (i == 1)
        {
            progressLabel.text = @"验证手机号";
        }else if (i == 2)
        {
            progressLabel.text = @"重置密码";
        }
        progressLabel.textColor = YZRedTextColor;
        progressLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        [progressView addSubview:progressLabel];
        
        //设置frame
        CGSize progressLabelSize = [progressLabel.text sizeWithLabelFont:progressLabel.font];
        CGFloat progressViewW = progressImageViewWH + 5 + progressLabelSize.width;
        if (i == 0) {
            progressView.frame = CGRectMake(10, 0, progressViewW, progressBackView.height);
        }else if (i == 1)
        {
            progressView.frame = CGRectMake((screenWidth - progressViewW) / 2, 0, progressViewW, progressBackView.height);
        }else if (i == 2)
        {
            progressView.frame = CGRectMake(screenWidth - 10 - progressViewW, 0, progressViewW, progressBackView.height);
        }
        progressImageView.frame = CGRectMake(0, progressImageViewY, progressImageViewWH, progressImageViewWH);
        progressLabel.frame = CGRectMake(progressImageViewWH + 5, 0, progressLabelSize.width, progressView.height);
        [progressViews addObject:progressView];
        
        if (i != 0) {//箭头
            UIImageView * arrowImageView = [[UIImageView alloc]init];
            if (i == 1) {
                arrowImageView.image = [UIImage imageNamed:@"secretChange_arrow_red"];
            }else if (i == 2)
            {
                arrowImageView.image = [UIImage imageNamed:@"secretChange_arrow_red"];
            }
            UIView * progressView1 = progressViews[i - 1];
            UIView * progressView2 = progressViews[i];
            CGFloat distance = CGRectGetMinX(progressView2.frame) - CGRectGetMaxX(progressView1.frame);
            CGFloat arrowImageViewX = CGRectGetMaxX(progressView1.frame) + (distance - arrowImageViewW) / 2;
            arrowImageView.frame = CGRectMake(arrowImageViewX, arrowImageViewY, arrowImageViewW, arrowImageViewH);
            [progressBackView addSubview:arrowImageView];
        }
    }

    //底界面
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(progressBackView.frame) + 15, screenWidth, 2 * YZCellH)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, YZCellH - 1, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [backView addSubview:line];
    
    //新证码输入框:
    for (int i = 0; i < 2; i++) {
        UITextField *SecretTextField = [[UITextField alloc]initWithFrame:CGRectMake(YZMargin,YZCellH * i,screenWidth - 2 * YZMargin,YZCellH)];
        if (i == 0) {
            self.passWordTF = SecretTextField;
            SecretTextField.placeholder = @"请设置新密码";
        }else if (i == 1)
        {
            self.passWordValidationTF = SecretTextField;
            SecretTextField.placeholder = @"请再次输入新密码";
        }
        SecretTextField.borderStyle = UITextBorderStyleNone;
        SecretTextField.secureTextEntry = YES;//密码模式
        SecretTextField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        SecretTextField.textColor = YZBlackTextColor;
        [backView addSubview:SecretTextField];
    }
    
    //确认按钮
    YZBottomButton * confirmButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.confirmButton = confirmButton;
    confirmButton.y = CGRectGetMaxY(backView.frame) + 30;
    [confirmButton setTitle:@"完成" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.enabled = NO;
    [self.view addSubview:confirmButton];
    
    //联系客服按钮
    UILabel * promptLabel = [[UILabel alloc]init];
    promptLabel.text = @"客服电话";
    promptLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    promptLabel.textColor = YZBlackTextColor;
    [self.view addSubview:promptLabel];
    
    UIButton * callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn setTitleColor:YZBlueBallColor forState:UIControlStateNormal];
    [callBtn setTitle:@"4007001898" forState:UIControlStateNormal];
    callBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [callBtn addTarget:self action:@selector(kefuClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callBtn];
    
    CGSize promptLabelSize = [promptLabel.text sizeWithLabelFont:promptLabel.font];
    CGSize callBtnSize = [callBtn.currentTitle sizeWithLabelFont:callBtn.titleLabel.font];
    
    CGFloat promptLabel1X = (screenWidth - promptLabelSize.width - 2 -callBtnSize.width) / 2;
    CGFloat promptLabel1Y = screenHeight - statusBarH - navBarH - [YZTool getSafeAreaBottom] - 30;
    promptLabel.frame = CGRectMake(promptLabel1X, promptLabel1Y, promptLabelSize.width, promptLabelSize.height);
    
    callBtn.frame = CGRectMake(CGRectGetMaxX(promptLabel.frame) + 2, promptLabel1Y, callBtnSize.width, promptLabelSize.height);
}
- (void)kefuClick
{
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSString *telUrl = @"tel://4007001898";
    NSURL *telURL =[NSURL URLWithString:telUrl];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}
- (void)confirmButtonPressed
{
    [self.view endEditing:YES];
    
    if (![YZValidateTool validatePassword:self.passWordTF.text])
    {
        [MBProgressHUD showError:@"您输入的密码格式不对"];
        return;
    }else if (![self.passWordTF.text isEqualToString:self.passWordValidationTF.text])
    {
        [MBProgressHUD showError:@"两次输入密码不一样"];
        return;
    }
    NSDictionary *dict = @{
                           @"cmd":@(10620),
                           @"phone":self.phoneStr,
                           @"verifyCode":self.verifyCode,
                           @"passwd":self.passWordTF.text
                           };
    [MBProgressHUD showMessage:@"修改密码中..." toView:self.view];
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            [self accountLogin];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"忘记密码下一步请求error");
    }];
}

- (void)accountLogin
{
    NSDictionary *dict = @{
                           @"cmd":@(8004),
                           @"userName":self.phoneStr,
                           @"password":self.passWordTF.text,
                           @"loginType":@(1)
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        //检查账号密码返回数据
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            [MBProgressHUD showSuccess:@"修改密码成功"];
            //存储账户到数据库
            [YZUserDefaultTool saveObject:json[@"userId"] forKey:@"userId"];
            [YZUserDefaultTool saveObject:self.passWordTF.text forKey:@"userPwd"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [YZUserDefaultTool saveObject:@"accountLogin" forKey:@"loginWay"];
            [defaults setInteger:2 forKey:@"autoLogin"];
            
            //发送登录成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:loginSuccessNote object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showVoucherLoginSuccessNote" object:nil];
            [YZTool setAlias];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self loadUserInfo];
        }
    } failure:^(NSError *error) {
        YZLog(@"自动登录error");
        [MBProgressHUD hideHUDForView:self.view];
    }];
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

#pragma mark - UITextFieldNotification
//限制输入字符个数
-(void)textFieldEditChanged:(NSNotification *)notification
{
    if (self.passWordTF.text.length == 0)
    {
        self.confirmButton.enabled = NO;
        return;
    }
    if (self.passWordValidationTF.text.length == 0)
    {
        self.confirmButton.enabled = NO;
        return;
    }
    self.confirmButton.enabled = YES;
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.passWordTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.passWordValidationTF];
}


@end
