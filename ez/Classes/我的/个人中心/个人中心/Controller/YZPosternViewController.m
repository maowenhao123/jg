
//
//  YZPosternViewController.m
//  ez
//
//  Created by dahe on 2019/9/10.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZPosternViewController.h"
#import "YZStatusCacheTool.h"

@interface YZPosternViewController ()

@property (nonatomic, weak) UITextField * textField1;
@property (nonatomic, weak) UITextField * textField2;
@property (nonatomic, weak) UITextField * textField3;

@end

@implementation YZPosternViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置接口地址、渠道";
    [self setupChilds];
}

- (void)setupChilds
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, screenWidth, YZCellH * 3)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    for (int i = 0; i < 3; i++) {
        UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(YZMargin, YZCellH * i, screenWidth - 2 * YZMargin, YZCellH)];
        textField.textColor = YZBlackTextColor;
        textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        if (i == 0) {
            self.textField1 = textField;
            textField.placeholder = @"请输入接口地址";
            NSString *posternBaseUrl = [YZUserDefaultTool getObjectForKey:@"PosternBaseUrl"];
            if (YZStringIsEmpty(posternBaseUrl)) {
                posternBaseUrl = mcpUrl;
            }
            textField.text = posternBaseUrl;
        }else if (i == 1)
        {
            self.textField2 = textField;
            textField.placeholder = @"请输入主渠道";
            NSString *posternMainChannel = [YZUserDefaultTool getObjectForKey:@"PosternMainChannel"];
            if (YZStringIsEmpty(posternMainChannel)) {
                posternMainChannel = mainChannel;
            }
            textField.text = posternMainChannel;
        }else if (i == 2)
        {
            self.textField3 = textField;
            textField.placeholder = @"请输入子渠道";
            NSString *posternChildChannel = [YZUserDefaultTool getObjectForKey:@"PosternChildChannel"];
            if (YZStringIsEmpty(posternChildChannel)) {
                posternChildChannel = childChannel;
            }
            textField.text = posternChildChannel;
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
    confirmBtn.y = CGRectGetMaxY(backView.frame) + 30;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}

- (void)confirmButtonClick
{
    [self.view endEditing:YES];
    
    [YZUserDefaultTool saveObject:self.textField1.text forKey:@"PosternBaseUrl"];
    [YZUserDefaultTool saveObject:self.textField2.text forKey:@"PosternMainChannel"];
    [YZUserDefaultTool saveObject:self.textField3.text forKey:@"PosternChildChannel"];
    
    [MBProgressHUD showSuccess:@"设置成功"];
    //删除用户的个人数据
    [YZUserDefaultTool removeObjectForKey:@"userId"];
    [YZUserDefaultTool removeObjectForKey:@"userPwd"];
    [YZStatusCacheTool deleteUserStatus];//删除用户信息数据表
    [YZTool logoutAlias];
    //取消自动登录
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:1 forKey:@"autoLogin"];
    [defaults synchronize];
    
    dispatch_time_t poptime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(poptime, dispatch_get_main_queue(), ^{
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ToBuyLottery" object:nil];
    });
}

@end
