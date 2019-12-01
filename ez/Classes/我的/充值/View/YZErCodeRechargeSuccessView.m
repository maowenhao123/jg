//
//  YZErCodeRechargeSuccessView.m
//  ez
//
//  Created by dahe on 2019/11/11.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZErCodeRechargeSuccessView.h"
#import "YZLoadHtmlFileController.h"

@interface YZErCodeRechargeSuccessView ()<UIGestureRecognizerDelegate>

@property (nonatomic,weak) UIView * backView;
@property (nonatomic, copy) NSString *clientId;

@end

@implementation YZErCodeRechargeSuccessView

- (instancetype)initWithFrame:(CGRect)frame clientId:(NSString *)clientId
{
    self = [super initWithFrame:frame];
    if (self) {
        self.clientId = clientId;
        [self setupChilds];
    }
    return self;
}

- (void)setupChilds
{
    self.backgroundColor = YZColor(0, 0, 0, 0.4);
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeFromSuperview)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    CGFloat backViewW = screenWidth * 0.85;
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, backViewW, 0)];
    self.backView = backView;
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    UILabel * contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    NSString * contentStr = @"";
    if ([self.clientId isEqualToString:@"jiuge_lftpay_weixin_qr"]) {
        contentStr = @"本次支付二维码已保存到你的手机相册，请打开微信“扫一扫”扫描该二维码进行支付";
    }else if ([self.clientId isEqualToString:@"alipay_img_qr"])
    {
        contentStr = @"本次支付二维码已保存到你的手机相册，请打开支付宝“扫一扫”扫描该二维码进行支付";
    }
    NSMutableAttributedString * contentAttStr = [[NSMutableAttributedString alloc]initWithString:contentStr];
    [contentAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(28)] range:NSMakeRange(0, contentAttStr.length)];
    [contentAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, contentAttStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 3;
    [contentAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentAttStr.length)];
    contentLabel.attributedText = contentAttStr;
    CGSize contentSize = [contentLabel.attributedText boundingRectWithSize:CGSizeMake(backView.width - YZMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    contentLabel.frame = CGRectMake(YZMargin, 25, contentSize.width, contentSize.height);
    [backView addSubview:contentLabel];
    
    UIButton * showButton = [UIButton buttonWithType:UIButtonTypeSystem];
    showButton.frame = CGRectMake(YZMargin, CGRectGetMaxY(contentLabel.frame) + 12, backView.width - YZMargin * 2, 30);
    [showButton setTitle:@"查看支付演示" forState:UIControlStateNormal];
    showButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [showButton addTarget:self action:@selector(showButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:showButton];
    
    UIButton * skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.frame = CGRectMake(0, CGRectGetMaxY(showButton.frame) + 12, backView.width, 44);
    skipButton.backgroundColor = YZBaseColor;
    if ([self.clientId isEqualToString:@"jiuge_lftpay_weixin_qr"]) {
        [skipButton setTitle:@"打开微信" forState:UIControlStateNormal];
    }else if ([self.clientId isEqualToString:@"alipay_img_qr"])
    {
        [skipButton setTitle:@"打开支付宝" forState:UIControlStateNormal];
    }
    skipButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [skipButton addTarget:self action:@selector(skipButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:skipButton];
    
    backView.height = CGRectGetMaxY(skipButton.frame);
    backView.center = self.center;
    backView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        backView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)showButtonDidClick
{
    NSString * web = @"";
    if ([self.clientId isEqualToString:@"jiuge_lftpay_weixin_qr"]) {
        web = [NSString stringWithFormat:@"%@/zhongcai/html/alipay.html", baseH5Url];
    }else if ([self.clientId isEqualToString:@"alipay_img_qr"])
    {
        web = [NSString stringWithFormat:@"%@/zhongcai/html/wx-saoma.html", baseH5Url];
    }
    YZLoadHtmlFileController * showVC = [[YZLoadHtmlFileController alloc] initWithWeb:web];
    [self.ower.navigationController pushViewController:showVC animated:YES];
}

- (void)skipButtonDidClick
{
    if ([self.clientId isEqualToString:@"jiuge_lftpay_weixin_qr"]) {
        NSURL *alipay_url = [NSURL URLWithString:@"weixin://"];
        if ([[UIApplication sharedApplication] canOpenURL:alipay_url]) {
            [[UIApplication sharedApplication] openURL:alipay_url];
        }else
        {
            [MBProgressHUD showError:@"打开微信失败"];
        }
    }else if ([self.clientId isEqualToString:@"alipay_img_qr"])
    {
        NSURL *alipay_url = [NSURL URLWithString:@"alipay://"];
        if ([[UIApplication sharedApplication] canOpenURL:alipay_url]) {
            [[UIApplication sharedApplication] openURL:alipay_url];
        }else
        {
            [MBProgressHUD showError:@"打开支付宝失败"];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint pos = [touch locationInView:self.backView.superview];
        if (CGRectContainsPoint(self.backView.frame, pos)) {
            return NO;
        }
    }
    return YES;
}


@end
