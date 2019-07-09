//
//  YZUPPayPluginRechargeViewController.m
//  ez
//
//  Created by apple on 16/7/7.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZUPPayPluginRechargeViewController.h"
#import "UPPaymentControl.h"
#import "JSON.h"

@interface YZUPPayPluginRechargeViewController ()

@end

@implementation YZUPPayPluginRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"银行卡支付";
    self.view.backgroundColor = YZBackgroundColor;

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n1、充值免手续费，充值金额不可提现\n2、交易限额由发卡银行统一设定，若超出限额请更换银行卡\n3、如充值未到账，请及时联系客服"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(0, attStr.length)];
    self.tishiLabel.attributedText = attStr;
    CGSize tishiSize = [self.tishiLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - 2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.tishiLabel.height = tishiSize.height;//改变提示label的高度
    self.rechargeExplainBtn.y = CGRectGetMaxY(self.tishiLabel.frame) + 10;
    
    //接收充值成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoRechargeSuccessVC)
                                                 name:UPayRechargeSuccessNote
                                               object:nil];
}
- (void)rechargeBtnClick
{
    //是否安装银联app
    if ([[UPPaymentControl defaultControl] isPaymentAppInstalled]) {
        YZLog(@"已安装银联app");
    }
    __weak typeof (self) weakSelf = self;
    NSNumber *amount = [NSNumber numberWithFloat:[self.amountTextTield.text floatValue] * 100];
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
        NSDictionary *payResultDic = [json[@"payResult"] JSONValue];
        NSString * tn = payResultDic[@"tn"];
        if (SUCCESS) {
            if (tn != nil && tn.length > 0) {
#if JG
                NSString * scheme = @"EZUPPay";
#elif ZC
                NSString * scheme = @"ZCUPPay";
#elif CS
                NSString * scheme = @"CSUPPay";
#endif
                [[UPPaymentControl defaultControl] startPay:tn
                                                 fromScheme:scheme
                                                       mode:@"00"
                                             viewController:weakSelf];
            }
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"rechargeBtnClick请求error");
    }];
}
- (void)gotoRechargeSuccessVC
{
    YZRechargeSuccessViewController * rechargeSuccessVC = [[YZRechargeSuccessViewController alloc]init];
    rechargeSuccessVC.rechargeSuccessType = UPayRechargeSuccess;
    rechargeSuccessVC.isOrderPay = self.isOrderPay;
    [self.navigationController pushViewController:rechargeSuccessVC animated:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UPayRechargeSuccessNote
                                                 object:nil];
}

@end
