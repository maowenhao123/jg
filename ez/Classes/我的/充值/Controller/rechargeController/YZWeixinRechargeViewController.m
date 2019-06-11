//
//  YZWeixinRechargeViewController.m
//  ez
//
//  Created by apple on 14-10-28.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#import "YZWeixinRechargeViewController.h"
#import "ZWXWechatPayOrder.h"
#import "YZLoadHtmlFileController.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "YZWeixinPayGuideViewController.h"

@implementation YZWeixinRechargeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"微信充值";
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n1、充值免手续费，充值金额不可提现\n2、交易限额由发卡银行统一设定，若超出限额请更换银行卡\n3、如充值未到账，请及时联系客服"];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
    self.tishiLabel.attributedText = attStr;
    CGSize tishiSize = [self.tishiLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - 2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.tishiLabel.height = tishiSize.height;//改变提示label的高度

    //限额说明
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"限额说明" style:UIBarButtonItemStylePlain target:self action:@selector(limitBtnClick)];
    //接收微信充值成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoRechargeSuccessVC)
                                                 name:WeiXinRechargeSuccessNote
                                               object:nil];
}
//父类方法
- (void)rechargeBtnClick
{
    NSNumber *amount = [NSNumber numberWithFloat:[self.amountTextTield.text floatValue] * 100];
    if ([self.clientId isEqualToString:@"jiuge_lftpay_weixin_qr"]) {//跳转浏览器
        waitingView;
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
            [MBProgressHUD hideHUDForView:self.view];
            if (SUCCESS) {
                //保存二维码
                NSDictionary * payResultDic = [self dictionaryWithJsonString:json[@"payResult"]];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:payResultDic[@"codeImgUrl"]]];
                UIImage *image = [UIImage imageWithData:data]; // 取得图片
                UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            }else
            {
                ShowErrorView
            }
        } failure:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view];
            YZLog(@"rechargeBtnClick请求error");
        }];
    }else if ([self.clientId isEqualToString:@"plbpay_weixin_h5"])//h5支付
    {
        NSString * payInfoJson = [@{@"clientType":@(1)} JSONRepresentation];
        NSString * web = [NSString stringWithFormat:@"%@?userId=%@&amount=%@&payType=%@&payInfo=%@&channel=%@&childChannel=%@", self.url, UserId, amount, self.paymentId, payInfoJson, mainChannel, childChannel];
        web = [web stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:web]];
    }else
    {
        //梓微兴微信支付
        [ZWXWechatPayOrder ZWXWechatPayOrderAmount:amount paymentId:self.paymentId];
    }
}
#pragma mark -- <保存到相册>
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error)
    {
        [MBProgressHUD showError:@"保存失败"];
        return;
    }
    BOOL goto_weixin = [YZUserDefaultTool getIntForKey:@"first_weixin_pay"];
    [MBProgressHUD showSuccess:@"二维码保存成功，请在微信内调用扫一扫功能进行支付！"];
    if (goto_weixin) {
        //跳转微信
        [self performSelector:@selector(gotoWeiXin) withObject:self afterDelay:1.2f];
    }else//首次微信支付
    {
        [YZUserDefaultTool saveInt:1 forKey:@"first_weixin_pay"];
        YZWeixinPayGuideViewController * guideVC = [[YZWeixinPayGuideViewController alloc] init];
        [self.navigationController pushViewController:guideVC animated:YES];
    }
}

- (void)gotoWeiXin
{
    //跳转到微信
    NSURL *alipay_url = [NSURL URLWithString:@"weixin://"];
    if ([[UIApplication sharedApplication] canOpenURL:alipay_url]) {
        [[UIApplication sharedApplication] openURL:alipay_url];
    }
}
- (void)gotoRechargeSuccessVC
{
    YZRechargeSuccessViewController * rechargeSuccessVC = [[YZRechargeSuccessViewController alloc]init];
    rechargeSuccessVC.rechargeSuccessType = WinXinRechargeSuccess;
    rechargeSuccessVC.isOrderPay = self.isOrderPay;
    [self.navigationController pushViewController:rechargeSuccessVC animated:YES];
}
- (void)limitBtnClick
{
    NSString *fileName = [NSString stringWithFormat:@"weixin.html"];
    YZLoadHtmlFileController *htmlVc = [[YZLoadHtmlFileController alloc] initWithFileName:fileName];
    htmlVc.title = @"微信支付限额说明";
    [self.navigationController pushViewController:htmlVc animated:YES];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:WeiXinRechargeSuccessNote
                                                 object:nil];
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}
@end
