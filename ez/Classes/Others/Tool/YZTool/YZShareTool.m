//
//  YZShareTool.m
//  zc
//
//  Created by dahe on 2020/5/25.
//  Copyright © 2020 9ge. All rights reserved.
//

#import "YZShareTool.h"
#import "YZShareView.h"

@implementation YZShareTool

+ (void)UMShareWithTitle:(NSString *)title content:(NSString *)content webpageUrl:(NSString *)webpageUrl thumImage:(id)thumImage
{
    YZShareView * shareView = [[YZShareView alloc]init];
    [shareView show];
    shareView.block = ^(UMSocialPlatformType platformType){//选择平台
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:thumImage];
        shareObject.webpageUrl = webpageUrl;
        messageObject.shareObject = shareObject;
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:KEY_WINDOW.rootViewController completion:^(id data, NSError *error) {
            if (error) {
                NSInteger errorCode = error.code;
                if (errorCode == 2003) {
                    [MBProgressHUD showError:@"分享失败"];
                }else if (errorCode == 2008)
                {
                    [MBProgressHUD showError:@"应用未安装"];
                }else if (errorCode == 2010)
                {
                    [MBProgressHUD showError:@"网络异常"];
                }
            }
        }];
    };
}

@end
