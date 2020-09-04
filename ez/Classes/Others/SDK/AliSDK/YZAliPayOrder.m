//
//  YZAliPayOrder.m
//  ez
//
//  Created by apple on 16/11/21.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZAliPayOrder.h"
#import <AlipaySDK/AlipaySDK.h>
#import "JSON.h"

@implementation YZAliPayOrder

+ (void)AliPayOrderAmount:(NSNumber *)amount paymentId:(NSString *)paymentId clientId:(NSString *)clientId
{
    [self alipayWithAmount:amount paymentId:paymentId];
}
+ (void)alipayWithAmount:(NSNumber *)amount paymentId:(NSString *)paymentId
{
    NSURL * url = [NSURL URLWithString:@"alipay:"];//没有安装支付宝
    if (![[UIApplication sharedApplication] canOpenURL:url]) {
        [MBProgressHUD showError:@"请安装支付宝客户端"];
        return;
    }
    
    NSString * payInfoJson = [@{@"clientType":@(1)} JSONRepresentation];
    NSDictionary *dict = @{
                           @"cmd":@(8041),
                           @"userId":UserId,
                           @"amount":amount,
                           @"payType":paymentId,
                           @"payInfo":payInfoJson
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"json = %@",json);
        if (SUCCESS) {
            //Base64解码
            NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:json[@"payResult"] options:0];
            NSString *orderString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
            YZLog(@"%@",orderString);
            if (orderString != nil) {
                //应用注册scheme,在AliSDKDemo-Info.plist定义URL types
#if JG
                NSString * appScheme = @"EZAlipay";
#elif ZC
                NSString * appScheme = @"ZCAlipay";
#endif
                // NOTE: 调用支付结果开始支付
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
            }
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"rechargeBtnClick请求error");
    }];
}

@end
