//
//  YZZhifubaoRechargeViewController.m
//  ez
//
//  Created by apple on 14-10-28.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZZhifubaoRechargeViewController.h"
#import "YZRechargeSuccessViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZAliPayOrder.h"
#import "JSON.h"

@interface YZZhifubaoRechargeViewController ()<UIWebViewDelegate>

@end

@implementation YZZhifubaoRechargeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"支付宝充值";

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n1、充值免手续费，充值金额不可提现\n2、如充值未到账，请及时联系客服"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
    self.tishiLabel.attributedText = attStr;
    CGSize tishiSize = [attStr boundingRectWithSize:CGSizeMake(screenWidth-2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.tishiLabel.height = tishiSize.height;//改变提示label的高度
    self.rechargeExplainBtn.y = CGRectGetMaxY(self.tishiLabel.frame) + 10;
    
    //接收支付宝充值成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoRechargeSuccessVC)
                                                 name:AliPayRechargeSuccessNote
                                               object:nil];
}
- (void)rechargeBtnClick
{
    NSNumber *amount = [NSNumber numberWithFloat:[self.amountTextTield.text floatValue] * 100];
    if ([self.clientId isEqualToString:@"jiuge_alipay_qr"] || [self.clientId isEqualToString:@"jiuge_lftpay_alipay_qr"]) {//跳转浏览器
        NSString * payInfoJson = [@{@"clientType":@(1)} JSONRepresentation];
        NSDictionary *dict = @{
                               @"cmd":@(8041),
                               @"userId":UserId,
                               @"amount":amount,
                               @"payType":self.paymentId,
                               @"payInfo":payInfoJson
                               };
        [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
            YZLog(@"json = %@",json);
            if (SUCCESS) {
                if ([self.clientId isEqualToString:@"jiuge_lftpay_alipay_qr"]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:json[@"payResult"]]];
                }else
                {
                    [self loadWebViewWithUrlStr:json[@"payResult"]];
                }
            }else
            {
                ShowErrorView
            }
        } failure:^(NSError *error) {
            YZLog(@"rechargeBtnClick请求error");
        }];
    }else if ([self.clientId isEqualToString:@"plbpay_alipay_h5"])//h5支付
    {
        NSString * payInfoJson = [@{@"clientType":@(1)} JSONRepresentation];
        NSString * web = [NSString stringWithFormat:@"%@?userId=%@&amount=%@&payType=%@&payInfo=%@&channel=%@&childChannel=%@", self.url, UserId, amount, self.paymentId, payInfoJson, mainChannel, childChannel];
        web = [web stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:web]];
    }else
    {
        [YZAliPayOrder AliPayOrderAmount:amount paymentId:self.paymentId clientId:self.clientId];
    }
}
//支付成功
- (void)gotoRechargeSuccessVC
{
    YZRechargeSuccessViewController * rechargeSuccessVC = [[YZRechargeSuccessViewController alloc]init];
    rechargeSuccessVC.rechargeSuccessType = AliPayRechargeSuccess;
    rechargeSuccessVC.isOrderPay = self.isOrderPay;
    [self.navigationController pushViewController:rechargeSuccessVC animated:YES];
}
//webView
- (void)loadWebViewWithUrlStr:(NSString *)urlStr
{
    UIWebView * webView =  [[UIWebView alloc] init];
    webView.delegate = self;
    [self.view addSubview:webView];
    NSURL* url = [NSURL URLWithString:urlStr];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [webView loadRequest:request];//加载
    waitingView;
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    YZLog(@"%@",request.URL.absoluteString);
    if ([request.URL.absoluteString hasPrefix:@"alipay"]) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
            [[UIApplication sharedApplication] openURL:request.URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @NO} completionHandler:^(BOOL success) {
                    //支付结果
                    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"充值结果" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"支付异常" style:UIAlertActionStyleCancel handler:nil];
                    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"支付完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        //去个人中心
                        NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [self.navigationController popToRootViewControllerAnimated:NO];
                            });
                        }];
                        NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
                            dispatch_sync(dispatch_get_main_queue(), ^{
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"ToMine" object:nil];
                            });
                        }];
                        [op2 addDependency:op1];
                        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                        [queue waitUntilAllOperationsAreFinished];
                        [queue addOperation:op1];
                        [queue addOperation:op2];
                    }];
                    [alertController addAction:alertAction1];
                    [alertController addAction:alertAction2];
                    [self presentViewController:alertController animated:YES completion:nil];
            }];
        }else
        {
            YZLog(@"未安装支付宝");
        }
    }
    return YES;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.view];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:AliPayRechargeSuccessNote
                                                 object:nil];
}

@end
