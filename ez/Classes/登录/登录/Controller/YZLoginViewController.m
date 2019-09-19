//
//  YZLoginViewController.m
//  ez
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#define historyAccountViewY 119

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

#import <TencentOpenAPI/TencentOAuth.h>
#import <TYRZSDK/TYRZSDK.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>
#import "YZLoginViewController.h"
#import "YZRegisterViewController.h"
#import "YZSecretChangeViewController.h"
#import "YZLoginAccountTableViewCell.h"
#import "YZStatusCacheTool.h"
#import "YZMessageLoginViewController.h"
#import "YZThirdPartyBindingViewController.h"
#import "YZLeftViewTextField.h"
#import "YZValidateTool.h"
#import "UIButton+YZ.h"
#import "YZThirdPartyStatus.h"
#import "JSON.h"
#import "WXApi.h"

@interface YZLoginViewController ()

@property (nonatomic, weak) YZLeftViewTextField *accountTextField;
@property (nonatomic, weak) YZLeftViewTextField *pwdTextField;
@property (nonatomic, weak) UIButton *loginbutton;
@property (nonatomic,weak) UIButton * showPasswordButton;
@property (nonatomic, weak) UIButton *switchbtn;

@end

@implementation YZLoginViewController

#pragma mark - 控制器的生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"用户登录";
#if JG
    //初始化界面
    [self setupChildViews];
    self.view.backgroundColor = YZBackgroundColor;
#elif ZC
    //初始化界面
    [self setupZCChildViews];
    self.view.backgroundColor = [UIColor whiteColor];
#elif CS
    //初始化界面
    [self setupZCChildViews];
    self.view.backgroundColor = [UIColor whiteColor];
#elif RR
    //初始化界面
    [self setupZCChildViews];
    self.view.backgroundColor = [UIColor whiteColor];
#endif
}
- (void)back
{
    UIViewController *controller = self;
    while(controller.presentingViewController != nil){
        controller = controller.presentingViewController;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}
- (void)setupChildViews
{
    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithIcon:@"back_btn_flat" highIcon:@"back_btn_flat" target:self action:@selector(back)];
    
    //登录界面
    UIView *loginview = [[UIView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, YZCellH * 2)];
    loginview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:loginview];

    //账号输入框:
    YZLeftViewTextField *accountTextField = [[YZLeftViewTextField alloc]initWithFrame:CGRectMake(YZMargin, 0, screenWidth - 2 * YZMargin, YZCellH)];
    self.accountTextField = accountTextField;
    accountTextField.placeholder = @"用户名/手机号";
    accountTextField.borderStyle = UITextBorderStyleNone;
    accountTextField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    accountTextField.textColor = YZBlackTextColor;
    accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [loginview addSubview:accountTextField];
    
    //分割线
    UIView *seperator = [[UIView alloc] init];
    seperator.frame = CGRectMake(0, YZCellH - 1, screenWidth, 1);
    seperator.backgroundColor = YZWhiteLineColor;
    [loginview addSubview:seperator];
    
    //密码输入框:
    YZLeftViewTextField *pwdTextField = [[YZLeftViewTextField alloc]initWithFrame:CGRectMake(YZMargin, YZCellH, screenWidth - 2 * YZMargin, YZCellH)];
    self.pwdTextField = pwdTextField;
    pwdTextField.borderStyle = UITextBorderStyleNone;
    pwdTextField.placeholder = @"登录密码";
    pwdTextField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    pwdTextField.textColor = YZBlackTextColor;
    pwdTextField.secureTextEntry = YES;
    pwdTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [loginview addSubview:pwdTextField];
    
    UIImageView * leftImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
    leftImageView2.image = [UIImage imageNamed:@"login_passWord_icon"];
    pwdTextField.leftView = leftImageView2;
    pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    
    //自动登录按钮
    UIButton *switchbtn = [[UIButton alloc] init];
    self.switchbtn = switchbtn;
    [switchbtn setImage:[UIImage imageNamed:@"bet_weixuanzhong"] forState:UIControlStateNormal];
    [switchbtn setImage:[UIImage imageNamed:@"bet_xuanzhong"] forState:UIControlStateSelected];
    [switchbtn setImage:[UIImage imageNamed:@"bet_xuanzhong"] forState:UIControlStateHighlighted];
    switchbtn.selected = YES;
    [switchbtn setTitle:@"自动登录" forState:UIControlStateNormal];
    [switchbtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    switchbtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    switchbtn.frame = CGRectMake(YZMargin, CGRectGetMaxY(loginview.frame) + 10, 85, 20);
    [switchbtn setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:5];
    int autoLoginType = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"autoLogin"];
    if (autoLoginType == 0) {//默认自动登录
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:2 forKey:@"autoLogin"];
        [defaults synchronize];
    }
    if(autoLoginType == 1)
    {
        switchbtn.selected = NO;
    }else
    {
        switchbtn.selected = YES;//默认值或者设置位自动
    }
    [switchbtn addTarget:self action:@selector(clickswitch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchbtn];
    
    //忘记密码
    UIButton *keybutton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat keybuttonY = CGRectGetMaxY(loginview.frame) + 10;
    keybutton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [keybutton setTitleColor:YZBlueBallColor forState:UIControlStateNormal];
    [keybutton setTitle:@"忘记密码" forState:UIControlStateNormal];
    CGSize keybuttonSize = [keybutton.currentTitle sizeWithLabelFont:keybutton.titleLabel.font];
    keybutton.frame = CGRectMake(screenWidth - YZMargin - keybuttonSize.width, keybuttonY, keybuttonSize.width, 20);
    [keybutton addTarget:self action:@selector(ketbtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:keybutton];

    //登录按钮
    YZBottomButton *loginbutton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.loginbutton = loginbutton;
    loginbutton.y = CGRectGetMaxY(loginview.frame) + 60;
    [loginbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginbutton setTitle:@"登录" forState:UIControlStateNormal];
    [loginbutton addTarget:self action:@selector(loginBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginbutton];
    
    //注册按钮
    UIButton *registerbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerbtn.frame = CGRectMake(loginbutton.x, CGRectGetMaxY(loginbutton.frame) + 20, screenWidth - loginbutton.x * 2, 40);
    registerbtn.backgroundColor = [UIColor whiteColor];
    [registerbtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    [registerbtn setTitle:@"注册" forState:UIControlStateNormal];
    registerbtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [registerbtn addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
    registerbtn.layer.masksToBounds = YES;
    registerbtn.layer.cornerRadius = 3;
    registerbtn.layer.borderWidth = 0.8;
    registerbtn.layer.borderColor = YZGrayLineColor.CGColor;
    [self.view addSubview:registerbtn];
    
    UIButton * messageLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    messageLoginButton.tag = 1;
    [messageLoginButton setTitle:@"短信验证码登录" forState:UIControlStateNormal];
    [messageLoginButton setTitleColor:YZColor(83, 83, 83, 1) forState:UIControlStateNormal];
    messageLoginButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    CGSize messageLoginButtonSize = [messageLoginButton.currentTitle sizeWithLabelFont:messageLoginButton.titleLabel.font];
    CGFloat messageLoginButtonW = messageLoginButtonSize.width;
    CGFloat messageLoginButtonH = messageLoginButtonSize.height;
    CGFloat messageLoginButtonX = screenWidth - messageLoginButtonW - loginbutton.x;
    CGFloat messageLoginButtonY = CGRectGetMaxY(registerbtn.frame) + 20;
    messageLoginButton.frame = CGRectMake(messageLoginButtonX, messageLoginButtonY, messageLoginButtonW, messageLoginButtonH);
    [messageLoginButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:messageLoginButton];
    
    //第三方登录
    CGFloat thirdPartyBtnWH = 35;
    
    UILabel * promptLabel = [[UILabel alloc]init];
    promptLabel.text = @"合作账户登录";
    promptLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    promptLabel.textColor = YZColor(134, 134, 134, 1);
    CGSize promptSize = [promptLabel.text sizeWithLabelFont:promptLabel.font];
    CGFloat promptLabelX = (screenWidth - promptSize.width) / 2;
    CGFloat promptLabelY = screenHeight - statusBarH - navBarH - [YZTool getSafeAreaBottom] - thirdPartyBtnWH - 40 - promptSize.height;
    promptLabel.frame = CGRectMake(promptLabelX, promptLabelY, promptSize.width, promptSize.height);
    [self.view addSubview:promptLabel];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(50, 0, promptLabel.x - 50 - 10, 1)];
    line1.center = CGPointMake(line1.center.x, promptLabel.center.y);
    line1.backgroundColor = YZGrayLineColor;
    [self.view addSubview:line1];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(promptLabel.frame) + 10, 0, screenWidth - CGRectGetMaxX(promptLabel.frame) - 10 - 50, 1)];
    line2.center = CGPointMake(line2.center.x, promptLabel.center.y);
    line2.backgroundColor = YZGrayLineColor;
    [self.view addSubview:line2];

    //登录按钮
    NSMutableArray *thirdPartyBtnImages = [NSMutableArray array];
    NSMutableArray *thirdPartyBtnSelectedImages = [NSMutableArray array];
    if ([WXApi isWXAppInstalled]) {//如果安装微信
        [thirdPartyBtnImages addObject:@"login_weixin_icon"];
        [thirdPartyBtnSelectedImages addObject:@"login_weixin_icon_selected"];
    }

    if ([TencentOAuth iphoneQQInstalled]) {//如果安装QQ
        [thirdPartyBtnImages addObject:@"login_qq_icon"];
        [thirdPartyBtnSelectedImages addObject:@"login_qq_icon_selected"];
    }
    //微博
    [thirdPartyBtnImages addObject:@"login_sina_icon"];
    [thirdPartyBtnSelectedImages addObject:@"login_sina_icon_selected"];
    
    CGFloat padding = (screenWidth - thirdPartyBtnImages.count * thirdPartyBtnWH) / (thirdPartyBtnImages.count + 1);//边距
    UIButton * lastThirdPartyBtn;
    for (int i = 0; i < thirdPartyBtnImages.count; i++) {
        CGFloat thirdPartyBtnY = screenHeight  - [YZTool getSafeAreaBottom] - thirdPartyBtnWH - statusBarH - navBarH - 25;
        UIButton *thirdPartyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        thirdPartyBtn.frame = CGRectMake(CGRectGetMaxX(lastThirdPartyBtn.frame) + padding, thirdPartyBtnY, thirdPartyBtnWH, thirdPartyBtnWH);
        [thirdPartyBtn setImage:[UIImage imageNamed:thirdPartyBtnImages[i]] forState:UIControlStateNormal];
        [thirdPartyBtn setImage:[UIImage imageNamed:thirdPartyBtnSelectedImages[i]] forState:UIControlStateHighlighted];
        if ([thirdPartyBtnImages[i] isEqual:@"login_weixin_icon"]) {
            thirdPartyBtn.tag = 101;
        }else if ([thirdPartyBtnImages[i] isEqual:@"login_qq_icon"])
        {
            thirdPartyBtn.tag = 102;
        }else if ([thirdPartyBtnImages[i] isEqual:@"login_sina_icon"])
        {
            thirdPartyBtn.tag = 103;
        }
        [thirdPartyBtn addTarget:self action:@selector(thirdPartyBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:thirdPartyBtn];
        lastThirdPartyBtn = thirdPartyBtn;
    }

    //如果记住了账号密码,就显示密码
    accountTextField.text = [YZUserDefaultTool getObjectForKey:@"userName"];
    if([YZUserDefaultTool getObjectForKey:@"userPwd"])
    {
        pwdTextField.text = [YZUserDefaultTool getObjectForKey:@"userPwd"];
    }
}

- (void)setupZCChildViews
{
    //close
    UIButton * closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat closeButtonWH = 30;
    closeButton.frame = CGRectMake(screenWidth - closeButtonWH - 15, statusBarH + 10, closeButtonWH, closeButtonWH);
    [closeButton setBackgroundImage:[UIImage imageNamed:@"login_close_icon"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    //login
    UIImageView * logoImageView = [[UIImageView alloc] init];
    CGFloat logoImageViewW = 197;
    CGFloat logoImageViewH = 107;
    logoImageView.frame = CGRectMake((screenWidth - logoImageViewW) / 2, statusBarH + 50, logoImageViewW, logoImageViewH);
#if ZC
    logoImageView.image = [UIImage imageNamed:@"login_ad_zc"];
#elif CS
    logoImageView.image = [UIImage imageNamed:@"login_ad_cs"];
#elif RR
    logoImageView.image = [UIImage imageNamed:@"login_ad_rr"];
#endif
    [self.view addSubview:logoImageView];
    
    UIView * lastView;
    //输入框
    NSArray * placeholders = @[@"用户名/手机号", @"登录密码"];
    CGFloat textFieldH = 52;
    
    for (int i = 0; i < 2; i++) {
        YZLeftViewTextField * textField = [[YZLeftViewTextField alloc] init];
        textField.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
        textField.textColor = YZBlackTextColor;
        textField.placeholder = placeholders[i];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.borderStyle = UITextBorderStyleNone;
        CGFloat textFieldX = YZMargin;
        CGFloat textFieldY = CGRectGetMaxY(logoImageView.frame) + 34;
        CGFloat textFieldW = screenWidth - 2 * textFieldX;
        if (i == 0) {//账号
            self.accountTextField = textField;
        }else//密码
        {
            self.pwdTextField = textField;
            textFieldX += 30;
            textFieldY = CGRectGetMaxY(lastView.frame);
            textFieldW -= 2 * 30;
            textField.secureTextEntry = YES;
        }
        textField.frame = CGRectMake(textFieldX, textFieldY, textFieldW, textFieldH);
        [self.view addSubview:textField];
        lastView = textField;
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(YZMargin, CGRectGetMaxY(textField.frame) - 1, screenWidth - 2 * YZMargin, 1)];
        line.backgroundColor = YZWhiteLineColor;
        [self.view addSubview:line];
    }
    self.accountTextField.text = [YZUserDefaultTool getObjectForKey:@"userName"];
    
    UIButton * showPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.showPasswordButton = showPasswordButton;
    CGFloat showPasswordButtonWH = 20;
    showPasswordButton.frame = CGRectMake(screenWidth - showPasswordButtonWH - YZMargin, 0, showPasswordButtonWH, showPasswordButtonWH);
    showPasswordButton.centerY = self.pwdTextField.centerY;
    [showPasswordButton setBackgroundImage:[UIImage imageNamed:@"login_password_invisible"] forState:UIControlStateNormal];
    [showPasswordButton setBackgroundImage:[UIImage imageNamed:@"login_password_visible"] forState:UIControlStateSelected];
    [showPasswordButton addTarget:self action:@selector(showPasswordButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showPasswordButton];
    
    //登录按钮
    YZBottomButton * loginBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.loginbutton = loginBtn;
    loginBtn.y = CGRectGetMaxY(lastView.frame) + 30;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = loginBtn.height / 2;
    [loginBtn addTarget:self action:@selector(loginBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //注册按钮
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registerBtn.frame = CGRectMake(loginBtn.x, CGRectGetMaxY(loginBtn.frame) + 20, screenWidth - 2 * loginBtn.x, 40);
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:YZRedTextColor forState:UIControlStateNormal];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    registerBtn.layer.masksToBounds = YES;
    registerBtn.layer.cornerRadius = loginBtn.height / 2;
    registerBtn.layer.borderColor = YZBaseColor.CGColor;
    registerBtn.layer.borderWidth = 1;
#if ZC
    [registerBtn addTarget:self action:@selector(quickLoginDidClick:) forControlEvents:UIControlEventTouchUpInside];
#elif CS
    [registerBtn addTarget:self action:@selector(quickLoginDidClick:) forControlEvents:UIControlEventTouchUpInside];
#elif RR
    [registerBtn addTarget:self action:@selector(gotoRegister) forControlEvents:UIControlEventTouchUpInside];
#endif
    [self.view addSubview:registerBtn];
    lastView = registerBtn;
    
    //忘记密码
    for (int i = 0; i < 2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:@"忘记密码?" forState:UIControlStateNormal];
        if (i == 1)
        {
            [button setTitle:@"短信验证码登录" forState:UIControlStateNormal];
        }
        [button setTitleColor:YZColor(83, 83, 83, 1) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        CGSize buttonSize = [button.currentTitle sizeWithLabelFont:button.titleLabel.font];
        CGFloat buttonW = buttonSize.width;
        CGFloat buttonH = buttonSize.height;
        CGFloat buttonX = loginBtn.x;
        if (i == 1)
        {
            buttonX = screenWidth - buttonW - buttonX;
        }
        CGFloat buttonY = CGRectGetMaxY(lastView.frame) + 20;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
    
    //默认自动登录
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:2 forKey:@"autoLogin"];
    [defaults synchronize];
    
    //第三方登录
#if ZC
    [self setupThirdPartyLogin];
#elif CS
    [self setupThirdPartyLogin];
#elif RR
    
#endif
}

- (void)setupThirdPartyLogin
{
    UIView *thirdPartyView = [[UIView alloc] initWithFrame:CGRectMake(0, screenHeight - [YZTool getSafeAreaBottom] - 83, screenWidth, 83)];
    thirdPartyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:thirdPartyView];
    
    UILabel * promptLabel = [[UILabel alloc]init];
    promptLabel.text = @"or";
    promptLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    promptLabel.textColor = YZDrayGrayTextColor;
    CGSize promptSize = [promptLabel.text sizeWithLabelFont:promptLabel.font];
    CGFloat promptLabelX = (screenWidth - promptSize.width) / 2;
    promptLabel.frame = CGRectMake(promptLabelX, 0, promptSize.width, promptSize.height);
    [thirdPartyView addSubview:promptLabel];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(10, 0, promptLabel.x - 10 - 10, 1)];
    line1.centerY = promptLabel.centerY;
    line1.backgroundColor = YZWhiteLineColor;
    [thirdPartyView addSubview:line1];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(promptLabel.frame) + 10, 0, screenWidth - CGRectGetMaxX(promptLabel.frame) - 10 - 10, 1)];
    line2.centerY = promptLabel.centerY;
    line2.backgroundColor = YZWhiteLineColor;
    [thirdPartyView addSubview:line2];
    
    CGFloat thirdPartyBtnWH = 38;
    CGFloat thirdPartyBtnY = thirdPartyView.height - 17 - thirdPartyBtnWH;
    NSArray *thirdPartyBtnImages = @[@"phone_faster_login", @"login_weixin_icon", @"login_qq_icon", @"login_sina_icon"];
    CGFloat thirdPartyBtnPadding = (screenWidth - thirdPartyBtnWH * thirdPartyBtnImages.count) / (thirdPartyBtnImages.count + 1);
    if (thirdPartyBtnImages.count == 0) {
        thirdPartyView.hidden = YES;
    }
    for (int i = 0; i < thirdPartyBtnImages.count; i++) {
        UIButton * thirdPartyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        thirdPartyBtn.frame = CGRectMake(thirdPartyBtnPadding + (thirdPartyBtnWH + thirdPartyBtnPadding) * i, thirdPartyBtnY, thirdPartyBtnWH, thirdPartyBtnWH);
        if ([thirdPartyBtnImages[i] isEqualToString:@"login_qq_icon"]) {
            thirdPartyBtn.tag = 102;
        }else if ([thirdPartyBtnImages[i] isEqualToString:@"login_weixin_icon"]) {
            thirdPartyBtn.tag = 101;
        }else if ([thirdPartyBtnImages[i] isEqualToString:@"login_sina_icon"]) {
            thirdPartyBtn.tag = 103;
        }else if ([thirdPartyBtnImages[i] isEqualToString:@"phone_faster_login"]) {
            thirdPartyBtn.tag = 100;
        }
        [thirdPartyBtn setBackgroundImage:[UIImage imageNamed:thirdPartyBtnImages[i]] forState:UIControlStateNormal];
        [thirdPartyBtn addTarget:self action:@selector(thirdPartyBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [thirdPartyView addSubview:thirdPartyBtn];
    }
}
#pragma mark - 点击按钮
- (void)buttonDidClick:(UIButton *)button
{
    if (button.tag == 0) {//忘记密码?
        [self ketbtnPressed];
    }else//短信验证码登录
    {
        [self messageLogin];
    }
}
    
- (void)showPasswordButtonDidClick:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        self.pwdTextField.secureTextEntry = NO;
    } else
    {
        self.pwdTextField.secureTextEntry = YES;
    }
}

- (void)clickswitch:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self setLoginType:btn.selected];
}
- (void)setLoginType:(BOOL)isSelected
{
    int autoLoginType = 0;
    if(isSelected)
    {
        autoLoginType = 2;
    }else
    {
        autoLoginType = 1;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:autoLoginType forKey:@"autoLogin"];
    [defaults synchronize];
}
#pragma mark - 点击短信验证码登录
-(void)messageLogin
{
    YZMessageLoginViewController *messageLoginVC = [[YZMessageLoginViewController alloc] init];
    [self.navigationController pushViewController:messageLoginVC animated:YES];
}
    
#pragma mark - 点击注册按钮
-(void)quickLoginDidClick:(UIButton *)button
{
    UACustomModel *model = [[UACustomModel alloc]init];
    model.navReturnImg = [UIImage imageNamed:@"black_back_bar"];
    model.navColor = [UIColor whiteColor];
    model.navText = [[NSAttributedString alloc]initWithString:@"一键登录" attributes:@{NSForegroundColorAttributeName:YZBlackTextColor,NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}];
    [TYRZUILogin customUIWithParams:model customViews:^(UIView *customAreaView) {

    }];
    waitingView
    [TYRZUILogin getAuthorizationWithController:self timeout:8000 complete:^(id sender) {
        NSLog(@"%@", sender);
        NSString *resultCode = sender[@"resultCode"];
        if ([resultCode isEqualToString:@"103000"]) {
            [self quickLoginWithToken:sender[@"token"]];
        }else//失败去注册页面
        {
            [MBProgressHUD hideHUDForView:self.view];
            if ([button.currentTitle isEqualToString:@"注册"]) {
                [self gotoRegister];
            }else
            {
                [MBProgressHUD showError:sender[@"desc"]];
            }
        }
    }];
}

- (void)gotoRegister
{
    YZRegisterViewController *registerVc = [[YZRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVc animated:YES];
}

- (void)quickLoginWithToken:(NSString *)token
{
    NSString * imei = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString * IP = [self getIPAddress:NO];
    if ([IP isEqualToString:@"0.0.0.0"]) {
        IP = [self getIPAddress:YES];
    }
    NSDictionary *dict = @{
                           @"cmd":@(10638),
                           @"version": @"0.0.1",
                           @"ip": IP,
                           @"imei":imei,
                           @"token": token
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"json = %@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            //保存用户信息
            YZUser *user = [YZUser objectWithKeyValues:json];
            [YZUserDefaultTool saveUser:user];
            [YZUserDefaultTool saveObject:@"accountLogin" forKey:@"loginWay"];
            //存储userId和userName
            [YZUserDefaultTool saveObject:json[@"userId"] forKey:@"userId"];
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
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
#pragma mark - 点击忘记密码按钮
-(void)ketbtnPressed
{
    YZSecretChangeViewController *secretVc = [[YZSecretChangeViewController alloc] init];
    [self.navigationController pushViewController:secretVc animated:YES];
}

#pragma  mark - 点击登录按钮
- (void)loginBtnPressed
{
    [self.view endEditing:YES];
    if (YZStringIsEmpty(self.accountTextField.text)) {
        [MBProgressHUD showError:@"请输入用户名"];
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
    [MBProgressHUD showMessage:@"正在登录,客官请稍后" toView:self.view];
    NSDictionary *dict = @{
                           @"cmd":@(8004),
                           @"userName":self.accountTextField.text,
                           @"password":self.pwdTextField.text,
                           @"loginType":@(1)
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"json = %@",json);
        [MBProgressHUD hideHUDForView:self.view];
        //检查账号密码返回数据
        [self checkloginWith:json];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}
- (void)checkloginWith:(id)json
{
    if(SUCCESS)
    {//成功登录
        //保存用户信息
        YZUser *user = [YZUser objectWithKeyValues:json];
        [YZUserDefaultTool saveUser:user];
        [YZUserDefaultTool saveObject:@"accountLogin" forKey:@"loginWay"];
        //存储userId和userName
        [YZUserDefaultTool saveObject:json[@"userId"] forKey:@"userId"];
        
        //根据保存密码按钮状态，保存密码
        [YZUserDefaultTool saveObject:self.accountTextField.text forKey:@"userName"];//userAccount
        //更新自动登录状态
        int autoLoginType = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"autoLogin"];
        if(autoLoginType == 2)
        {
            [YZUserDefaultTool saveObject:self.pwdTextField.text forKey:@"userPwd"];
        }else
        {
            [YZUserDefaultTool removeObjectForKey:@"userPwd"];
        }
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

#pragma mark - 第三方登录
- (void)thirdPartyBtnDidClick:(UIButton *)btn
{
    if (btn.tag == 100) {//手机号一键登录
        [self quickLoginDidClick:btn];
        return;
    }
    //微信注册
#if JG
    [WXApi registerApp:WXAppIdOld withDescription:@"九歌彩票"];
#elif ZC
    [WXApi registerApp:WXAppIdOld withDescription:@"中彩啦"];
#elif CS
    [WXApi registerApp:WXAppIdOld withDescription:@"财多多"];
#elif RR
    [WXApi registerApp:WXAppIdOld withDescription:@"人人彩"];
#endif
    UMSocialPlatformType platformType;
    if (btn.tag == 101)
    {
        platformType = UMSocialPlatformType_WechatSession;
    }else if (btn.tag == 102)
    {
        platformType = UMSocialPlatformType_QQ;
    }else {
        platformType = UMSocialPlatformType_Sina;
    }
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error) {
        if (!error) {
            [self getBindStatusWithUserInfoResponse:result platformType:platformType];
        }else
        {
            [MBProgressHUD showError:@"授权失败"];
        }
    }];
}
//获取绑定信息
- (void)getBindStatusWithUserInfoResponse:(UMSocialUserInfoResponse *)resp  platformType:(UMSocialPlatformType)platformType
{
    if (!resp || !resp.uid || !resp.openid) {
        return;
    }
    NSString * paramJson;
    NSNumber *type;
    if (platformType == UMSocialPlatformType_WechatSession) {
        paramJson = [@{@"uId":resp.uid,@"openId":resp.openid} JSONRepresentation];
        type = @(2);
    }else if (platformType == UMSocialPlatformType_QQ)
    {
        paramJson = [@{@"uId":resp.uid,@"openId":resp.openid} JSONRepresentation];
        type = @(1);
    }else if (platformType == UMSocialPlatformType_Sina)//微博登录只需uid
    {
        paramJson = [@{@"uId":resp.uid} JSONRepresentation];
        type = @(3);
    }
    NSString * imei = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    waitingView
    NSDictionary *dict = @{
                           @"cmd":@(10630),
                           @"type":type,
                           @"param":paramJson,
                           @"imei":imei
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"json = %@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            [self checkThirdPartyLoginWithUserInfoResponse:resp json:json type:type param:paramJson imei:imei];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)checkThirdPartyLoginWithUserInfoResponse:(UMSocialUserInfoResponse *)resp json:(id)json type:(NSNumber *)type param:(NSString *)param imei:(NSString *)imei
{
    if (SUCCESS) {
        YZThirdPartyStatus *thirdPartyStatus = [[YZThirdPartyStatus alloc]init];
        thirdPartyStatus.name = resp.name;
        thirdPartyStatus.iconurl = resp.iconurl;
        thirdPartyStatus.gender = resp.gender;
        thirdPartyStatus.uid = resp.uid;
        thirdPartyStatus.openid = resp.openid;
        thirdPartyStatus.refreshToken = resp.refreshToken;
        thirdPartyStatus.expiration = resp.expiration;
        thirdPartyStatus.accessToken = resp.accessToken;
        thirdPartyStatus.platformType = resp.platformType;
        thirdPartyStatus.originalResponse = resp.originalResponse;
        if([json[@"bindStatus"] isEqualToNumber:@(0)])//未绑定
        {
            //检查账号密码返回数据
            YZThirdPartyBindingViewController * thirdPartyBindingVC = [[YZThirdPartyBindingViewController alloc]init];
            thirdPartyBindingVC.type = type;
            thirdPartyBindingVC.param = param;
            thirdPartyBindingVC.imei = imei;
            thirdPartyBindingVC.thirdPartyStatus = thirdPartyStatus;
            [self.navigationController pushViewController:thirdPartyBindingVC animated:YES];
        }else
        {
            [YZUserDefaultTool saveObject:json[@"userId"] forKey:@"userId"];
            [YZUserDefaultTool saveObject:@"thirdPartyLogin" forKey:@"loginWay"];
            [YZUserDefaultTool saveThirdPartyStatus:thirdPartyStatus];
            //更新自动登录状态
            int autoLoginType = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"autoLogin"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:autoLoginType forKey:@"autoLogin"];
            [defaults synchronize];
            //用于绑定Alias的
            [YZTool setAlias];
            //发送登录成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:loginSuccessNote object:nil];
            [self loadUserInfo];
            [self back];
        }
    }else
    {
        ShowErrorView;
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

#pragma mark - 获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    NSDictionary *addresses = [self getIPAddresses];
    NSLog(@"addresses: %@", addresses);
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

- (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            return YES;
        }
    }
    return NO;
}

- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


@end
