//
//  YZWeixinPayGuideViewController.m
//  ez
//
//  Created by 毛文豪 on 2017/5/17.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZWeixinPayGuideViewController.h"

@interface YZWeixinPayGuideViewController ()

@end

@implementation YZWeixinPayGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"跳转微信";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChilds];
}

- (void)setupChilds {
    
    //提示
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    NSMutableAttributedString * titleAttStr = [[NSMutableAttributedString alloc] initWithString:@"充值二维码已存入手机相册\n打开微信“扫一扫”扫描该二维码即可充值"];
    [titleAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(35)] range:NSMakeRange(0, 12)];
    [titleAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(12, titleAttStr.length - 12)];
    [titleAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, 12)];
    [titleAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(12, titleAttStr.length - 12)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [titleAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, titleAttStr.length)];
    CGSize titleLabelSize = [titleAttStr boundingRectWithSize:CGSizeMake(screenWidth - 2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    titleLabel.attributedText = titleAttStr;
    titleLabel.frame = CGRectMake(0, 20, screenWidth, titleLabelSize.height + 10);
    [self.view addSubview:titleLabel];
    
    //图片
    CGFloat imageViewW = (screenWidth - 3 * YZMargin) / 2;
    CGFloat imageViewH = imageViewW * 1.778;
    NSArray * labels = @[@"1.点击微信点击扫一扫",@"2.扫描相册中的二维码"];
    UIView * lastView;
    for (int i = 0; i < 2; i++) {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(YZMargin + (imageViewW + YZMargin) * i, CGRectGetMaxY(titleLabel.frame) + 10, imageViewW, imageViewH);
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"weixin_pay_guide%d",i + 1]];
        [self.view addSubview:imageView];
        
        UILabel * label = [[UILabel alloc] init];
        label.frame = CGRectMake(imageView.x, CGRectGetMaxY(imageView.frame), imageView.width, 30);
        label.text = labels[i];
        label.textColor = YZBlackTextColor;
        label.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        [self.view addSubview:label];
        
        lastView = label;
    }
    
    //跳转微信
    YZBottomButton * button = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    button.y = CGRectGetMaxY(lastView.frame) + 30;
    [button setTitle:@"打开微信" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)buttonClick
{
    //跳转到微信
    NSURL *alipay_url = [NSURL URLWithString:@"weixin://"];
    if ([[UIApplication sharedApplication] canOpenURL:alipay_url]) {
        [[UIApplication sharedApplication] openURL:alipay_url];
    }
}

@end
