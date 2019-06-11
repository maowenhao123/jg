//
//  YZPhoneBindingViewController.m
//  ez
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZPhoneBindingViewController.h"
#import "YZValidateTool.h"

@interface YZPhoneBindingViewController ()
{
    int oneMinute;
}

@property (nonatomic, weak) UITextField *phoneTF;
@property (nonatomic, weak) UITextField *codeTF;
@property (nonatomic, weak) UIButton *codeBtn;
@property (nonatomic, weak) UIButton *confirmBtn;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation YZPhoneBindingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"绑定手机";
    [self setupChilds];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.phoneTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.codeTF];
}
- (void)setupChilds
{
    NSArray *placeholders = @[@"请输入手机号码", @"请输入验证码"];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, screenWidth, YZCellH * placeholders.count)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    for (int i = 0; i < placeholders.count; i++) {
        CGFloat viewY = i * YZCellH;
    
        //textField
        UITextField * textField = [[UITextField alloc]init];
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        textField.textColor = YZBlackTextColor;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.placeholder = placeholders[i];
        if (i == 0) {
            UILabel * titleLabel = [[UILabel alloc]init];
            titleLabel.text = @"手机号";
            titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
            titleLabel.textColor = YZBlackTextColor;
            CGSize size = [titleLabel.text sizeWithLabelFont:titleLabel.font];
            titleLabel.frame = CGRectMake(YZMargin, viewY, size.width, YZCellH);
            [backView addSubview:titleLabel];
            
            textField.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame),viewY, screenWidth - CGRectGetMaxX(titleLabel.frame) - YZMargin, YZCellH);
            textField.textAlignment = NSTextAlignmentRight;
            self.phoneTF = textField;
        }else if (i == 1)
        {
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
            textField.frame = CGRectMake(YZMargin, viewY, screenWidth - 2 * YZMargin - codeBtnW, YZCellH);
            codeBtn.enabled = NO;//默认不可选
            [codeBtn addTarget:self action:@selector(getCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:codeBtn];
        }
        [backView addSubview:textField];
        //分割线
        if (i != 1) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, YZCellH * (i + 1) - 1, screenWidth, 1)];
            line.backgroundColor = YZWhiteLineColor;
            [backView addSubview:line];
        }
    }
    
    //确认按钮
    YZBottomButton * confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn = confirmBtn;
    confirmBtn.y = CGRectGetMaxY(backView.frame) + 30;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.enabled = NO;//默认不可选
    [confirmBtn addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    //promptLabel
    UILabel * promptLabel = [[UILabel alloc]init];
    promptLabel.numberOfLines = 0;
    NSString * promptStr = @"说明：\n1.为了您的账户安全，请绑定手机号码\n2.手机号码是您找回密码的唯一常规途径";
    NSMutableAttributedString * promptAttStr = [[NSMutableAttributedString alloc]initWithString:promptStr];
    [promptAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(0, promptAttStr.length)];
    [promptAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, promptAttStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [promptAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, promptAttStr.length)];
    promptLabel.attributedText = promptAttStr;
    CGSize promptSize = [promptLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - YZMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    promptLabel.frame = CGRectMake(confirmBtn.x,  CGRectGetMaxY(confirmBtn.frame) + 10, screenWidth - confirmBtn.x * 2, promptSize.height);
    [self.view addSubview:promptLabel];
}
#pragma mark - UITextFieldNotification
-(void)textFieldEditChanged:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)notification.object;
    if (textField == self.phoneTF) {
        if(![YZValidateTool validateMobile:self.phoneTF.text])//手机号验证
        {
            self.codeBtn.enabled = NO;
        }else
        {
            self.codeBtn.enabled = YES;
        }
    }
    if (self.phoneTF.text.length == 0) {
        self.confirmBtn.enabled = NO;
        return;
    }
    if (self.codeTF.text.length == 0) {
        self.confirmBtn.enabled = NO;
        return;
    }
    self.confirmBtn.enabled = YES;
}
#pragma  mark - 获取验证码按钮点击
- (void)getCodeBtnPressed
{
    [self.view endEditing:YES];
    if (![YZValidateTool validateMobile:self.phoneTF.text])//不是手机号码
    {
        [MBProgressHUD showError:@"您输入的手机号格式不对"];
        return;
    }
    
    NSDictionary *dict = @{
                           @"cmd":@(8009),
                           @"userId":UserId,
                           @"phone":self.phoneTF.text
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
#pragma  mark - 确认按钮点击
- (void)confirmButtonClick
{
    [self.view endEditing:YES];
    
    if (![YZValidateTool validateMobile:self.phoneTF.text])//不是手机号码
    {
        [MBProgressHUD showError:@"您输入的手机号格式不对"];
        return;
    }
    if (self.codeTF.text.length == 0)//不是验证码码
    {
        [MBProgressHUD showError:@"您输入的验证码格式不对"];
        return;
    }
    NSString *mobilePhone = self.phoneTF.text;
    NSDictionary *dict = @{
                           @"cmd":@(8010),
                           @"userId":UserId,
                           @"phone":mobilePhone,
                           @"verifyCode":self.codeTF.text
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            YZUser *user = [YZUserDefaultTool user];
            user.mobilePhone = mobilePhone;
            [YZUserDefaultTool saveUser:user];
            [MBProgressHUD showSuccess:@"绑定手机成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"绑定手机失败"];
    }];
}
#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.phoneTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.codeBtn];
}

@end
