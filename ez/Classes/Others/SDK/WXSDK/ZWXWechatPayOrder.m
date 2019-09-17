//
//  WechatPayOrder.m
//  ez
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "ZWXWechatPayOrder.h"
#import "WXApi.h"
#import "NSString+SBJSON.h"
#import "JSON.h"

@implementation ZWXWechatPayOrder

+ (void)ZWXWechatPayOrderAmount:(NSNumber *)amount paymentId:(NSString *)paymentId
{
    if(![WXApi isWXAppInstalled])
    {
        [MBProgressHUD showError:@"请安装微信客户端"];
        return;
    }
    if(![WXApi isWXAppSupportApi])
    {
        [MBProgressHUD showError:@"请升级微信至最新版"];
        return;
    }
    //微信注册
#if JG
    [WXApi registerApp:WXAppIdNew withDescription:@"九歌彩票"];
#elif ZC
    [WXApi registerApp:WXAppIdNew withDescription:@"中彩啦"];
#elif CS
    [WXApi registerApp:WXAppIdNew withDescription:@"财多多"];
#elif RR
    [WXApi registerApp:WXAppIdNew withDescription:@"人人彩"];
#endif

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
            NSDictionary *dict = [json[@"payResult"] JSONValue];
            
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = dict[@"partnerId"];
            request.prepayId = dict[@"prepayId"];
            request.package = dict[@"package"];
            request.nonceStr = dict[@"nonceStr"];
            request.timeStamp = [dict[@"timeStamp"] unsignedIntValue];
            request.sign = dict[@"sign"];

            [WXApi sendReq:request];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"rechargeBtnClick请求error");
    }];
}


@end
