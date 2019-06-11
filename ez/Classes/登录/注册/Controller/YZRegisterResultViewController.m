//
//  YZRegisterResultViewController.m
//  ez
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZRegisterResultViewController.h"
#import "YZRealNameViewController.h"
#import "YZNavigationController.h"
#import "UIButton+YZ.h"

@interface YZRegisterResultViewController ()

@end

@implementation YZRegisterResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithIcon:@"back_btn_flat" highIcon:@"back_btn_flat" target:self action:@selector(backToRegist)];
    self.title = @"注册成功";
    self.view.backgroundColor = YZBackgroundColor;
   
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"success_icon"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:YZGetFontSize(35)]];
    [button setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:@"恭喜，注册成功\n实名认证让购彩更安全"];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(7, attStr.length - 7)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(7, attStr.length - 7)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
    button.titleLabel.numberOfLines = 2;
    [button setAttributedTitle:attStr forState:UIControlStateNormal];
    button.frame = CGRectMake(0, screenHeight * 0.15, screenWidth, 30);
    [button setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:10];
    button.userInteractionEnabled = NO;
    [self.view addSubview:button];
    
    //继续投注
    YZBottomButton * againBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    againBtn.tag = 0;
    againBtn.y = CGRectGetMaxY(button.frame) + 50;
    [againBtn setTitle:@"开启中奖之旅" forState:UIControlStateNormal];
    [againBtn addTarget:self action:@selector(registerBtndone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:againBtn];
    
    //查看投注记录
    YZBottomButton * lookBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    lookBtn.tag = 1;
    lookBtn.y = CGRectGetMaxY(againBtn.frame) + 20;
    [lookBtn setTitle:@"实名认证" forState:UIControlStateNormal];
    [lookBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    [lookBtn setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:lookBtn.bounds] forState:UIControlStateNormal];
    [lookBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(216, 216, 216, 1) WithRect:lookBtn.bounds] forState:UIControlStateHighlighted];
    [lookBtn addTarget:self action:@selector(registerBtndone:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lookBtn];
}
- (void)backToRegist
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//返回购彩
- (void)registerBtndone:(UIButton *)btn
{
    if(btn.tag == 1)
    {
        YZRealNameViewController *realNameVC = [[YZRealNameViewController alloc] init];
        [self.navigationController pushViewController:realNameVC animated:YES];
    }else
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        //注册成功，发送返回购彩大厅通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ToBuyLottery" object:nil];
    }
}


@end
