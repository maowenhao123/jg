//
//  YZChangePhonePassWordViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/1/8.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZChangePhonePassWordViewController.h"
#import "YZBingingNewPhoneViewController.h"
#import "YZValidateTool.h"

@interface YZChangePhonePassWordViewController ()

@property (nonatomic,weak) UITextField * textField;

@end

@implementation YZChangePhonePassWordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"验证登录密码";
    [self setupChilds];
}

- (void)setupChilds
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 9, screenWidth, YZCellH)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(YZMargin, 0, screenWidth - 2 * YZMargin, YZCellH)];
    self.textField = textField;
    textField.textColor = YZBlackTextColor;
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    textField.secureTextEntry = YES;
    textField.placeholder = @"请输入登录密码";
    [view addSubview:textField];
    
    //确认按钮
    YZBottomButton * confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.y = CGRectGetMaxY(view.frame) + 30;
    [confirmBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}

- (void)confirmBtnDidClick
{
    [self.view endEditing:YES];
    
    if (YZStringIsEmpty(self.textField.text)) {
        [MBProgressHUD showError:@"您还未输入登录密码"];
        return;
    }
    
    NSDictionary *dict = @{
                           @"cmd":@(8004),
                           @"userName":[YZUserDefaultTool getObjectForKey:@"userName"],
                           @"password":self.textField.text,
                           @"loginType":@(1)
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
        YZLog(@"登录error");
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

@end
