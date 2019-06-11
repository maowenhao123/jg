//
//  YZNamePhoneBindingViewController.m
//  ez
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZNamePhoneBindingViewController.h"
#import "YZValidateTool.h"
#import "YZCardNoTextField.h"

@interface YZNamePhoneBindingViewController ()
{
    int oneMinute;
}

@property (nonatomic, weak) UITextField *nameTF;
@property (nonatomic, weak) UITextField *cardNoTF;
@property (nonatomic, weak) UITextField *phoneTF;
@property (nonatomic, weak) UITextField *codeTF;
@property (nonatomic, weak) UIButton *codeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) UIButton *confirmBtn;

@end

@implementation YZNamePhoneBindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"实名认证";
    [self setupChilds];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.nameTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.cardNoTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.phoneTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.codeTF];
}
#pragma mark - 布局子视图
- (void)setupChilds
{
    NSArray *titles = @[@"真实姓名",@"身份证号码",@"手机号码"];
    NSArray *placeholders = @[@"请输入真实姓名",@"请输入身份证号码",@"请输入手机号码",@"请输入验证码"];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, screenWidth, YZCellH * placeholders.count)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    for (int i = 0; i < placeholders.count; i++) {
        CGFloat viewY = i * YZCellH;
        
        //textField
        UITextField * textField;
        if (i == 1) {//身份证键盘
            textField = [[YZCardNoTextField alloc]init];
        }else
        {
            textField = [[UITextField alloc]init];
        }
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        textField.textColor = YZBlackTextColor;
        if (i == 2 || i == 3) {//数字键盘
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
        textField.placeholder = placeholders[i];
        if (i != 3) {//有标题
            UILabel * titleLabel = [[UILabel alloc]init];
            titleLabel.text = titles[i];
            titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
            titleLabel.textColor = YZBlackTextColor;
            CGSize size = [titleLabel.text sizeWithLabelFont:titleLabel.font];
            titleLabel.frame = CGRectMake(YZMargin, viewY, size.width, YZCellH);
            [backView addSubview:titleLabel];
            
            textField.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame),viewY, screenWidth - CGRectGetMaxX(titleLabel.frame) - YZMargin, YZCellH);
            textField.textAlignment = NSTextAlignmentRight;
            if (i == 0) {
                self.nameTF = textField;
            }else if (i == 1)
            {
                self.cardNoTF = (YZCardNoTextField *)textField;
            }else if (i == 2)
            {
                self.phoneTF = textField;
            }
        }else if (i == 3)
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
        if (i != 3) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, YZCellH * (i + 1) - 1, screenWidth, 1)];
            line.backgroundColor = YZWhiteLineColor;
            [backView addSubview:line];
        }
    }
    
    //确认按钮
    YZBottomButton * confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn = confirmBtn;
    confirmBtn.y = CGRectGetMaxY(backView.frame) + 30;
    [confirmBtn setTitle:@"提交认证" forState:UIControlStateNormal];
    confirmBtn.enabled = NO;//默认不可选
    [confirmBtn addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    //温馨提示
    UILabel * footerLabel = [[UILabel alloc]init];
    footerLabel.numberOfLines = 0;
    NSString * footerStr =  @"温馨提示：\n1. 姓名和身份证信息提交后不可修改。\n2. 姓名必须与您的银行卡开户姓名保持一致。\n3.身份证号是大奖提款的唯一凭证，请认真填写。";
    NSMutableAttributedString * footerAttStr = [[NSMutableAttributedString alloc]initWithString:footerStr];
    [footerAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(0, footerAttStr.length)];
    [footerAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, footerAttStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [footerAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, footerAttStr.length)];
    footerLabel.attributedText = footerAttStr;
    CGSize size = [footerLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - 2 * 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    footerLabel.frame = CGRectMake(20, CGRectGetMaxY(confirmBtn.frame) + 10, size.width, size.height);
    [self.view addSubview:footerLabel];
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
   
    if(self.nameTF.text.length == 0)//姓名验证
    {
        self.confirmBtn.enabled = NO;
        return;
    }
    if(self.cardNoTF.text.length == 0)//身份证号验证
    {
        self.confirmBtn.enabled = NO;
        return;
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
#pragma mark - 提交
- (void)confirmButtonClick
{
    [self.view endEditing:YES];
    
    if(![YZValidateTool validateNickname:self.nameTF.text])
    {
        [MBProgressHUD showError:@"您输入的姓名不正确"];
        return;
    }
    if(![YZValidateTool validateIdentityCard:self.cardNoTF.text])//身份证号验证
    {
        [MBProgressHUD showError:@"您输入的身份证号码不正确"];
        return;
    }
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
    //弹框
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"确认信息" message:[NSString stringWithFormat:@"真实姓名：%@\n身份证号：%@",self.nameTF.text,self.cardNoTF.text] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self confirmMessage];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)confirmMessage
{
    if(![YZValidateTool validateNickname:self.nameTF.text])
    {
        [MBProgressHUD showError:@"您输入的姓名不正确"];
        return;
    }
    if(![YZValidateTool validateIdentityCard:self.cardNoTF.text])//身份证号验证
    {
        [MBProgressHUD showError:@"您输入的身份证号码不正确"];
        return;
    }
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
                           @"cmd":@(8007),
                           @"userId":UserId,
                           @"realname":self.nameTF.text,
                           @"cardNo":self.cardNoTF.text,//身份证号码
                           @"phone":mobilePhone,
                           @"verifyCode":self.codeTF.text
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            YZUser *user = [YZUserDefaultTool user];
            YZUserInfo *userInfo = [YZUserInfo objectWithKeyValues:json[@"userInfo"]];
            user.userInfo.cardno = userInfo.cardno;
            user.userInfo.realname = userInfo.realname;
            [YZUserDefaultTool saveUser:user];
            [MBProgressHUD showSuccess:@"实名绑定成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"实名绑定失败"];
    }];
}
#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.nameTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.cardNoTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.phoneTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.codeTF];
}
@end
