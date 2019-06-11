//
//  YZShowPhoneViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/1/8.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZShowPhoneViewController.h"
#import "YZChangePhoneTypeViewController.h"

@interface YZShowPhoneViewController ()

@end

@implementation YZShowPhoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"手机号码";
    [self setupChilds];
}
- (void)setupChilds
{
    //修改手机号
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(changePhoneBarDidClick)];
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, screenWidth, YZCellH)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"已绑定手机号码";
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    titleLabel.textColor = YZBlackTextColor;
    CGSize titleSize = [titleLabel.text sizeWithLabelFont:titleLabel.font];
    titleLabel.frame = CGRectMake(YZMargin, 0, titleSize.width, YZCellH);
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
    
//    //footerView
//    UILabel * promptLabel = [[UILabel alloc]init];
//    promptLabel.numberOfLines = 0;
//    promptLabel.textColor = YZGrayTextColor;
//    promptLabel.text = @"修改手机号码请拨打客服电话";
//    promptLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
//    CGSize promptSize = [promptLabel.text sizeWithLabelFont:promptLabel.font];
//    promptLabel.frame = CGRectMake(YZMargin,CGRectGetMaxY(backView.frame) + 10, promptSize.width, promptSize.height);
//    [self.view addSubview:promptLabel];
//    //打电话
//    UIButton * phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [phoneBtn setTitleColor:YZBlueBallColor forState:UIControlStateNormal];
//    [phoneBtn setTitle:@"4007001898" forState:UIControlStateNormal];
//    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
//    CGSize phoneBtnSize = [phoneBtn.currentTitle sizeWithLabelFont:phoneBtn.titleLabel.font];
//    phoneBtn.frame = CGRectMake(CGRectGetMaxX(promptLabel.frame) + 2, promptLabel.y, phoneBtnSize.width, promptLabel.height);
//    [phoneBtn addTarget:self action:@selector(call) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:phoneBtn];
}

- (void)changePhoneBarDidClick
{
    YZChangePhoneTypeViewController * changePhoneTypeVC = [[YZChangePhoneTypeViewController alloc]init];
    [self.navigationController pushViewController:changePhoneTypeVC animated:YES];
}

- (void)call
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-700-1898"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}

@end
