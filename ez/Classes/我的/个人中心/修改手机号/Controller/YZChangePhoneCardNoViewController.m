//
//  YZChangePhoneCardNoViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/1/8.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZChangePhoneCardNoViewController.h"
#import "YZRealNameViewController.h"
#import "YZBingingNewPhoneViewController.h"
#import "YZCardNoTextField.h"
#import "YZValidateTool.h"

@interface YZChangePhoneCardNoViewController ()

@property (nonatomic,weak) YZCardNoTextField * textField;

@end

@implementation YZChangePhoneCardNoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"验证身份信息";
    [self setupChilds];
}

- (void)setupChilds
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 9, screenWidth, YZCellH)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    YZCardNoTextField * textField = [[YZCardNoTextField alloc]initWithFrame:CGRectMake(YZMargin, 0, screenWidth - 2 * YZMargin, YZCellH)];
    self.textField = textField;
    textField.textColor = YZBlackTextColor;
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    textField.placeholder = @"请输入身份证号码";
    [view addSubview:textField];
   
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"未实名认证?" forState:UIControlStateNormal];
    [button setTitleColor:YZBlueBallColor forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    CGSize buttonSize = [button.currentTitle sizeWithLabelFont:button.titleLabel.font];
    CGFloat buttonW = buttonSize.width;
    CGFloat buttonH = buttonSize.height;
    CGFloat buttonX = screenWidth - YZMargin - buttonW;
    CGFloat buttonY = CGRectGetMaxY(view.frame) + 10;
    button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    [button addTarget:self action:@selector(buttonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //确认按钮
    YZBottomButton * confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.y = CGRectGetMaxY(button.frame) + 30;
    [confirmBtn setTitle:@"下一步" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [confirmBtn addTarget:self action:@selector(confirmBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}

- (void)buttonDidClick
{
    YZRealNameViewController * realNameVC = [[YZRealNameViewController alloc]init];
    [self.navigationController pushViewController:realNameVC animated:YES];
}

- (void)confirmBtnDidClick
{
    [self.view endEditing:YES];
    
    if(![YZValidateTool validateIdentityCard:self.textField.text])//身份证号验证
    {
        [MBProgressHUD showError:@"您输入的身份证号码不正确"];
        return;
    }
    
    NSDictionary *dict = @{
                           @"cmd":@(12200),
                           @"userId":UserId,
                           @"cardNo":self.textField.text,
                           };
    waitingView
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            YZBingingNewPhoneViewController * bingingNewPhoneVC = [[YZBingingNewPhoneViewController alloc]init];
            [self.navigationController pushViewController:bingingNewPhoneVC animated:YES];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"身份验证error");
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

@end
