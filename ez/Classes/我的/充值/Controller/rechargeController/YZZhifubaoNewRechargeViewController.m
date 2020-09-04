//
//  YZZhifubaoNewRechargeViewController.m
//  ez
//
//  Created by apple on 16/4/19.
//  Copyright (c) 2016年 9ge. All rights reserved.
//
#import "YZZhifubaoNewRechargeViewController.h"
#import "YZLoadHtmlFileController.h"

@interface YZZhifubaoNewRechargeViewController ()

@property (nonatomic, weak) UILabel *accountLabel;

@end

@implementation YZZhifubaoNewRechargeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"支付宝转账";
    self.view.backgroundColor = YZBackgroundColor;
    //初始化子控件
    [self setupChilds];
}
#pragma mark -  布局页面控件视图
- (void)setupChilds{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(YZMargin, 10, screenWidth - 2 * YZMargin, 30)];
    titleLabel.text = @"支付宝账号:";
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    titleLabel.textColor = YZBlackTextColor;
    [self.view addSubview:titleLabel];
    //支付宝账号
    UILabel * accountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, screenWidth, 30)];
    self.accountLabel = accountLabel;
#if JG
    accountLabel.text = @"zengxiaojun@palmlot.com";
#elif ZC
    accountLabel.text = @"zcxd@ezcp.cn";
#endif
    accountLabel.textColor = UIColorFromRGB(0xffec4b4b);
    accountLabel.font = [UIFont systemFontOfSize:YZGetFontSize(36)];
    accountLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:accountLabel];
    //跳转按钮
    UIButton * skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    skipButton.frame = CGRectMake(screenWidth/2 - 60, 100, 120, 40);
    [skipButton setBackgroundImage:[UIImage imageNamed:@"btn_org_states1"] forState:UIControlStateNormal];
    [skipButton setBackgroundImage:[UIImage imageNamed:@"btn_org_states2"] forState:UIControlStateSelected];
    [skipButton setTitle:@"复制账号" forState:UIControlStateNormal];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    skipButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [skipButton addTarget:self action:@selector(pasteAccount) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipButton];
    //分割线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(YZMargin, 160, screenWidth - 2 * YZMargin, 1)];
    lineView.backgroundColor = YZWhiteLineColor;
    [self.view addSubview:lineView];
    //转账说明
    UILabel * explainLabel = [[UILabel alloc]init];
    explainLabel.numberOfLines = 0;
    if (!YZStringIsEmpty(self.intro))
    {
        NSDictionary *optoins = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
        NSData *data = [self.intro dataUsingEncoding:NSUnicodeStringEncoding];
        NSError * error;
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:data options:optoins documentAttributes:nil error:&error];
        if (!error) {
            explainLabel.attributedText = attributeString;
        }
    }else
    {
        explainLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        explainLabel.textColor = YZGrayTextColor;
#if JG
        NSString * string = @"转账说明:\n1、复制以上账户(九歌公司专有支付宝账户)并使用您的个人支付宝为该账户转账即可充值彩金。\n2、为确保彩金顺利到账，转账时“必须”在备注栏中注明您的购彩手机号码。\n3、转账后将由专职人员为您充值彩金，工作日充值时间段为9:30~18:00，当日18点以后的转账请求将顺延到下一工作日。\n4、周末和节假日的充值请求将顺延到之后的第一个工作日。\n5、充值金额不可提现，奖金可以提现。彩金将在您转账后10分钟内到账，如未到账可通过客服QQ、微信或拨打客服电话4007001898查询。";
#elif ZC
        NSString * string = @"转账说明:\n1、复制以上账户(中彩迅达公司专有支付宝账户)并使用您的个人支付宝为该账户转账即可充值彩金。\n2、为确保彩金顺利到账，转账时“必须”在备注栏中注明您的购彩手机号码。\n3、转账后将由专职人员为您充值彩金，工作日充值时间段为9:30~18:00，当日18点以后的转账请求将顺延到下一工作日。\n4、周末和节假日的充值请求将顺延到之后的第一个工作日。\n5、充值金额不可提现，奖金可以提现。彩金将在您转账后10分钟内到账，如未到账可通过客服QQ、微信或拨打客服电话4007001898查询。";
#endif
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:string];
        NSString * redString = @"转账时“必须”在备注栏中注明您的购彩手机号码。";
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:[string rangeOfString:redString]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
        explainLabel.attributedText = attStr;
    }
    CGSize explainSize = [explainLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - 2 * YZMargin, MAXFLOAT) options:0 context:nil].size;
    CGFloat explainH = explainSize.height;
    explainLabel.frame = CGRectMake(YZMargin, 170, screenWidth - 2 * YZMargin, explainH);
    [self.view addSubview:explainLabel];
    
    //充值说明
    if (!YZStringIsEmpty(self.detailUrl)) {
        UIButton * rechargeExplainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rechargeExplainBtn setTitle:@"充值说明（点击查看）" forState:UIControlStateNormal];
        [rechargeExplainBtn setTitleColor:YZBaseColor forState:UIControlStateNormal];
        rechargeExplainBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [rechargeExplainBtn addTarget:self action:@selector(rechargeExplainBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        CGSize rechargeExplainBtnSize = [rechargeExplainBtn.currentTitle sizeWithLabelFont:rechargeExplainBtn.titleLabel.font];
        rechargeExplainBtn.frame = CGRectMake(explainLabel.x, CGRectGetMaxY(explainLabel.frame) + 10, rechargeExplainBtnSize.width, rechargeExplainBtnSize.height);
        [self.view addSubview:rechargeExplainBtn];
    }
}

#pragma mark -  复制账号并跳转到支付宝
- (void)pasteAccount{
    //复制账号
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    NSString *string = self.accountLabel.text;
    [pab setString:string];
    [MBProgressHUD showSuccess:@"复制成功"];
    [self performSelector:@selector(skipAlipay) withObject:self afterDelay:1.0f];
}

- (void)skipAlipay
{
    //跳转到支付宝
    NSURL *alipay_url = [NSURL URLWithString:@"alipay:"];
    if ([[UIApplication sharedApplication] canOpenURL:alipay_url]) {
        [[UIApplication sharedApplication] openURL:alipay_url];
    }else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://auth.alipay.com/login/index.htm"]];
    }
}

- (void)rechargeExplainBtnDidClick
{
    YZLoadHtmlFileController * updataActivityVC = [[YZLoadHtmlFileController alloc] initWithWeb:self.detailUrl];
    [self.navigationController pushViewController:updataActivityVC animated:YES];
}

@end
