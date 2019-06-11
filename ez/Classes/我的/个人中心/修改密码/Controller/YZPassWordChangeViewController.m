//
//  YZPassWordChangeViewController.m
//  ez
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZPassWordChangeViewController.h"
#import "YZNavigationController.h"
#import "YZLoginViewController.h"
#import "YZValidateTool.h"
#import "YZStatusCacheTool.h"

@interface YZPassWordChangeViewController ()

@property (nonatomic, weak) UITextField *oldPassWordTF;
@property (nonatomic, weak) UITextField *passWordTF;
@property (nonatomic, weak) UITextField *passWordValidationTF;
@property (nonatomic, weak) YZBottomButton *confirmBtn;

@end

@implementation YZPassWordChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"修改密码";
    [self setupChilds];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.oldPassWordTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.passWordTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.passWordValidationTF];
    
}
- (void)setupChilds
{
    NSArray *titles = @[@"原密码",@"新密码",@"确认密码"];
    NSArray *placeholders = @[@"请输入旧密码",@"4-20位数字或字母",@"4-20位数字或字母"];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, screenWidth, YZCellH * titles.count)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    for (int i = 0; i < titles.count; i++) {
        CGFloat viewY = i * YZCellH;
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.text = titles[i];
        titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        titleLabel.textColor = YZBlackTextColor;
        CGSize size = [titleLabel.text sizeWithLabelFont:titleLabel.font];
        titleLabel.frame = CGRectMake(YZMargin, viewY, size.width, YZCellH);
        [backView addSubview:titleLabel];
        
        //textField
        UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame),viewY, screenWidth - CGRectGetMaxX(titleLabel.frame) - YZMargin, YZCellH)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.secureTextEntry = YES;//密码模式
        textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        textField.textColor = YZBlackTextColor;
        textField.textAlignment = NSTextAlignmentRight;
        textField.placeholder = placeholders[i];
        [backView addSubview:textField];
        if (i == 0) {
            self.oldPassWordTF = textField;
        }else if (i == 1)
        {
            self.passWordTF = textField;
        }else if (i == 2)
        {
            self.passWordValidationTF = textField;
        }
        [backView addSubview:textField];
        //分割线
        if (i != 2) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, YZCellH * (i + 1) - 1, screenWidth, 1)];
            line.backgroundColor = YZWhiteLineColor;
            [backView addSubview:line];
        }
    }
    
    //确认按钮
    YZBottomButton * confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn = confirmBtn;
    confirmBtn.y = CGRectGetMaxY(backView.frame) + 40;
    [confirmBtn setTitle:@"确定修改" forState:UIControlStateNormal];
    confirmBtn.enabled = NO;//默认不可选
    [confirmBtn addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}
#pragma mark - 保存
- (void)confirmButtonClick
{
    if(![YZValidateTool validatePassword:self.oldPassWordTF.text])
    {
        [MBProgressHUD showError:@"您输入的原始密码格式不对"];
        return;
    }
    if (![YZValidateTool validatePassword:self.passWordTF.text])
    {
        [MBProgressHUD showError:@"您输入的密码格式不对"];
        return;
    }
    if (![self.passWordTF.text isEqualToString:self.passWordValidationTF.text])
    {
        [MBProgressHUD showError:@"两次输入密码不一样"];
        return;
    }
    if ([self.passWordTF.text isEqualToString:self.oldPassWordTF.text])
    {
        [MBProgressHUD showError:@"新旧密码一样"];
        return;
    }
    NSDictionary *dict = @{
                           @"cmd":@(8008),
                           @"userId":UserId,
                           @"oldPassword":self.oldPassWordTF.text,
                           @"newPassword":self.passWordTF.text
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            [MBProgressHUD showSuccess:@"修改密码成功"];
            [self goLoginVC];
        }else
        {
            ShowErrorView
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"修改密码失败"];
    }];
}
//退出登录，去登录页面
- (void)goLoginVC
{
    //删除用户的个人数据
    [YZUserDefaultTool removeObjectForKey:@"userId"];
    [YZUserDefaultTool removeObjectForKey:@"userPwd"];
    [YZStatusCacheTool deleteUserStatus];//删除用户信息数据表
    [YZTool logoutAlias];
    //退出登录，发送返回购彩大厅通知
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:NO];
        });
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ToMine" object:nil];
        });
    }];
    [op2 addDependency:op1];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue waitUntilAllOperationsAreFinished];
    [queue addOperation:op1];
    [queue addOperation:op2];
}
#pragma mark - UITextFieldNotification
//限制输入字符个数
-(void)textFieldEditChanged:(NSNotification *)notification
{
    if(self.oldPassWordTF.text.length == 0)
    {
        self.confirmBtn.enabled = NO;
        return;
    }
    if (self.passWordTF.text.length == 0)
    {
        self.confirmBtn.enabled = NO;
        return;
    }
    if (self.passWordValidationTF.text.length == 0)
    {
        self.confirmBtn.enabled = NO;
        return;
    }
    self.confirmBtn.enabled = YES;
}
#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.oldPassWordTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.passWordTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.passWordValidationTF];
}


@end
