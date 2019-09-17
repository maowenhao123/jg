//
//  YZAccountInfoViewController.m
//  ez
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 9ge. All rights reserved.
//
#import "YZAccountInfoViewController.h"
#import "YZPosternViewController.h"
#import "YZNicknameViewController.h"
#import "YZShowNickNameViewController.h"
#import "YZShowPhoneViewController.h"
#import "YZBankCardViewController.h"
#import "YZPassWordChangeViewController.h"
#import "YZValidateTool.h"

@implementation YZAccountInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"个人资料";
    [self setupChilds];
}

- (void)setupChilds
{
    NSArray *titles = @[@"用户名称",@"昵称",@"实名认证",@"手机号码",@"银行卡号",@"修改密码"];
    UIView * lastView;
    for (int i = 0; i < titles.count; i++) {
        CGFloat viewY = 10 + i * YZCellH;
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, viewY, screenWidth, YZCellH);
        button.tag = i;
        button.backgroundColor = [UIColor whiteColor];
        if (i != 0) {
           [button setBackgroundImage:[UIImage ImageFromColor:YZColor(233, 233, 233, 1) WithRect:button.bounds] forState:UIControlStateHighlighted];
        }
        [self.view addSubview:button];
        lastView = button;
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.text = titles[i];
        titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        titleLabel.textColor = YZBlackTextColor;
        CGSize size = [titleLabel.text sizeWithLabelFont:titleLabel.font];
        titleLabel.frame = CGRectMake(YZMargin, 0, size.width, YZCellH);
        [button addSubview:titleLabel];
        
        if (i == 0) {//用户名
            UILabel * desLabel = [[UILabel alloc]init];
            desLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
            desLabel.textColor = YZBlackTextColor;
            YZUser *user = [YZUserDefaultTool user];
            desLabel.text = user.userName;
            desLabel.textAlignment = NSTextAlignmentRight;
            CGSize size = [desLabel.text sizeWithLabelFont:desLabel.font];
            desLabel.frame = CGRectMake(screenWidth - YZMargin - size.width, 0, size.width, YZCellH);
            [button addSubview:desLabel];
        }else
        {
            CGFloat accessoryW = 8;
            CGFloat accessoryH = 11;
            UIImageView * accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 15 - accessoryW, (YZCellH - accessoryH) / 2, accessoryW, accessoryH)];
            accessoryImageView.image = [UIImage imageNamed:@"accessory_dray"];
            [button addSubview:accessoryImageView];

            [button addTarget:self action:@selector(viewTap:) forControlEvents:UIControlEventTouchUpInside];
        }
        //分割线
        if (i != 5) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, YZCellH - 1, screenWidth, 1)];
            line.backgroundColor = YZWhiteLineColor;
            [button addSubview:line];
        }
    }
    
    //footerView
    UILabel * footerLabel = [[UILabel alloc]init];
    footerLabel.text = @"*为了您的账户安全，请您认真完善个人信息";
    footerLabel.textColor = YZGrayTextColor;
    footerLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    CGSize size = [footerLabel.text sizeWithLabelFont:footerLabel.font];
    footerLabel.frame = CGRectMake(YZMargin, CGRectGetMaxY(lastView.frame) + 10, screenWidth - YZMargin * 2, size.height);
    [self.view addSubview:footerLabel];
    
    UITapGestureRecognizer * posternTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(posternTap)];
    posternTap.numberOfTapsRequired = 5;
    footerLabel.userInteractionEnabled = YES;
    [footerLabel addGestureRecognizer:posternTap];
}

//后门
- (void)posternTap
{
    YZPosternViewController * posternVC = [[YZPosternViewController alloc]init];
    [self.navigationController pushViewController:posternVC animated:YES];
}

- (void)viewTap:(UIButton *)button
{
    if (button.tag == 1) {
        if ([YZTool needChangeNickName]) {//未设置昵称
            YZNicknameViewController * nicknameVC = [[YZNicknameViewController alloc]init];
            [self.navigationController pushViewController:nicknameVC animated:YES];
        }else
        {
            YZShowNickNameViewController * showNicknameVC = [[YZShowNickNameViewController alloc]init];
            [self.navigationController pushViewController:showNicknameVC animated:YES];
        }
    }else if (button.tag == 2) {
        YZRealNameViewController * realNameVC = [[YZRealNameViewController alloc]init];
        [self.navigationController pushViewController:realNameVC animated:YES];
    }else if (button.tag == 3)
    {
        YZUser *user = [YZUserDefaultTool user];
        if (user.mobilePhone) {//已绑定手机
            YZShowPhoneViewController * showPhoneVC = [[YZShowPhoneViewController alloc]init];
            [self.navigationController pushViewController:showPhoneVC animated:YES];
        }else
        {
            YZPhoneBindingViewController * phoneBindingVC = [[YZPhoneBindingViewController alloc]init];
            [self.navigationController pushViewController:phoneBindingVC animated:YES];
        }
    }else if (button.tag == 4)
    {
        YZBankCardViewController * bankCardVC = [[YZBankCardViewController alloc]init];
        [self.navigationController pushViewController:bankCardVC animated:YES];
    }else if (button.tag == 5)
    {
        YZPassWordChangeViewController * passWordChangeVC = [[YZPassWordChangeViewController alloc]init];
        [self.navigationController pushViewController:passWordChangeVC animated:YES];
    }
}


@end
