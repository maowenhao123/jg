//
//  YZChangePhoneTypeViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/1/8.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZChangePhoneTypeViewController.h"
#import "YZChangePhonePassWordViewController.h"
#import "YZChangePhoneCardNoViewController.h"

@interface YZChangePhoneTypeViewController ()

@end

@implementation YZChangePhoneTypeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"修改手机号码";
    [self setupChilds];
}

- (void)setupChilds
{
    NSArray *titles = @[@"通过验证登录密码修改", @"通过验证身份信息修改"];
    UIView * lastView;
    for (int i = 0; i < titles.count; i++) {
        CGFloat viewY = 10 + i * YZCellH;
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, viewY, screenWidth, YZCellH);
        button.tag = i;
        button.backgroundColor = [UIColor whiteColor];
        [button setBackgroundImage:[UIImage ImageFromColor:YZColor(233, 233, 233, 1) WithRect:button.bounds] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(viewTap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        lastView = button;
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.text = titles[i];
        titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        titleLabel.textColor = YZBlackTextColor;
        CGSize size = [titleLabel.text sizeWithLabelFont:titleLabel.font];
        titleLabel.frame = CGRectMake(YZMargin, 0, size.width, YZCellH);
        [button addSubview:titleLabel];
        
        CGFloat accessoryW = 8;
        CGFloat accessoryH = 11;
        UIImageView * accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 15 - accessoryW, (YZCellH - accessoryH) / 2, accessoryW, accessoryH)];
        accessoryImageView.image = [UIImage imageNamed:@"accessory_dray"];
        [button addSubview:accessoryImageView];
        
        //分割线
        if (i != 1) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, YZCellH - 1, screenWidth, 1)];
            line.backgroundColor = YZWhiteLineColor;
            [button addSubview:line];
        }
    }
}

- (void)viewTap:(UIButton *)button
{
    if (button.tag == 0) {
        YZChangePhonePassWordViewController * changePhonePassWordVC = [[YZChangePhonePassWordViewController alloc]init];
        [self.navigationController pushViewController:changePhonePassWordVC animated:YES];
    }else if (button.tag == 1)
    {
        YZChangePhoneCardNoViewController * changePhoneCardNoVC = [[YZChangePhoneCardNoViewController alloc]init];
        [self.navigationController pushViewController:changePhoneCardNoVC animated:YES];
    }
}

@end

