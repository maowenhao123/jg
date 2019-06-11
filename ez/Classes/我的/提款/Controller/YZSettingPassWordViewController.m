//
//  YZSettingPassWordViewController.m
//  ez
//
//  Created by apple on 16/12/16.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZSettingPassWordViewController.h"
#import "YZValidateTool.h"

@interface YZSettingPassWordViewController ()
{
    int oneMinute;
}
@property (nonatomic, weak) UITextField *phoneTF;
@property (nonatomic, weak) UITextField *codeTF;
@property (nonatomic, weak) UIButton *codeBtn;
@property (nonatomic, weak) UITextField *passWordTF;
@property (nonatomic, weak) UIButton *confirmBtn;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YZSettingPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"设置密码";
    [self setupChilds];
}

- (void)setupChilds
{
    //背景
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, screenWidth, YZCellH * 3)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    //电话
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"已绑定手机";
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    titleLabel.textColor = YZBlackTextColor;
    CGSize titleLabelSize = [titleLabel.text sizeWithLabelFont:titleLabel.font];
    titleLabel.frame = CGRectMake(YZMargin, 0, titleLabelSize.width, YZCellH);
    [backView addSubview:titleLabel];
    
    UILabel * phoneLabel = [[UILabel alloc]init];
    YZUser *user = [YZUserDefaultTool user];
    if (user.mobilePhone.length > 8) {
        NSString *phoneNo = [user.mobilePhone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"*****"];
        phoneLabel.text = phoneNo;
    }else
    {
        phoneLabel.text = user.mobilePhone;
    }
    phoneLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    phoneLabel.textColor = YZColor(180, 180, 180, 180);
    phoneLabel.textAlignment = NSTextAlignmentRight;
    CGSize phoneSize = [phoneLabel.text sizeWithLabelFont:phoneLabel.font];
    phoneLabel.frame = CGRectMake(screenWidth - YZMargin - phoneSize.width, 0, phoneSize.width, 44);
    [backView addSubview:phoneLabel];
    
    //输入框
    NSArray *placeholders = @[@"请输入验证码",@"设置密码，4-20位数字、字母组合"];
    for (int i = 0; i < placeholders.count; i++) {
        CGFloat viewY = (i + 1) * YZCellH;
        
        //textField
        UITextField * textField = [[UITextField alloc]init];
        textField.frame = CGRectMake(YZMargin, viewY, screenWidth - 2 * YZMargin, YZCellH);
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        textField.textColor = YZBlackTextColor;
        textField.placeholder = placeholders[i];
        if (i == 0)
        {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            
            CGFloat codeBtnH = 31;
            CGFloat codeBtnY = viewY + (YZCellH - codeBtnH) / 2;
            self.codeTF = textField;
            
            YZBottomButton * codeBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
            self.codeBtn = codeBtn;
            [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            codeBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
            CGSize codeBtnSize = [codeBtn.currentTitle sizeWithLabelFont:codeBtn.titleLabel.font];
            CGFloat codeBtnW = codeBtnSize.width + 10;
            codeBtn.frame = CGRectMake(screenWidth - codeBtnW - YZMargin, codeBtnY, codeBtnW, codeBtnH);
            textField.width = screenWidth - 2 * YZMargin - codeBtnW;
            [codeBtn addTarget:self action:@selector(getCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:codeBtn];
        }else if (i == 1)
        {
            self.passWordTF = textField;
            textField.secureTextEntry = YES;//密码模式
        }
        [backView addSubview:textField];
        //分割线
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, YZCellH * (i + 1) - 1, screenWidth, 1)];
        line.backgroundColor = YZWhiteLineColor;
        [backView addSubview:line];
    }
    
    //确认按钮
    YZBottomButton * confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn = confirmBtn;
    confirmBtn.y = CGRectGetMaxY(backView.frame) + 30;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    //提示
    UILabel * promptLabel = [[UILabel alloc]init];
    promptLabel.numberOfLines = 0;
    NSMutableAttributedString * promptAttStr = [[NSMutableAttributedString alloc]initWithString:@"温馨提示：\n1、首次提款需设置登录密码\n2、为了您的资金安全，每次提款均需验证密码\n3、设置密码后，使用手机号码和登录密码也可登录购彩账户"];
    [promptAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(0, promptAttStr.length)];
    [promptAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, promptAttStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [promptAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, promptAttStr.length)];
    promptLabel.attributedText = promptAttStr;
    CGSize promptLabelSize = [promptLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - 2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    promptLabel.frame = CGRectMake(confirmBtn.x, CGRectGetMaxY(confirmBtn.frame) + 10, screenWidth - 2 * confirmBtn.x, promptLabelSize.height);
    [self.view addSubview:promptLabel];
}
- (void)getCodeBtnPressed
{
    [self.view endEditing:YES];
    YZUser *user = [YZUserDefaultTool user];
    NSDictionary *dict = @{
                           @"cmd":@(12001),
                           @"phone":user.mobilePhone
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
- (void)confirmButtonClick
{
    if (![YZValidateTool validatePassword:self.passWordTF.text])
    {
        [MBProgressHUD showError:@"您输入的密码格式不对"];
        return;
    }
    YZUser *user = [YZUserDefaultTool user];
    NSDictionary *dict = @{
                           @"cmd":@(10620),
                           @"phone":user.mobilePhone,
                           @"verifyCode":self.codeTF.text,
                           @"passwd":self.passWordTF.text
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            [MBProgressHUD showSuccess:@"设置密码成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"设置密码请求error");
    }];

}
@end
