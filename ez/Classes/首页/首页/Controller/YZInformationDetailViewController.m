//
//  YZInformationDetailViewController.m
//  ez
//
//  Created by 毛文豪 on 2019/3/27.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZInformationDetailViewController.h"
#import "YZShareView.h"
#import "YZWebView.h"
#import "WXApi.h"

@interface YZInformationDetailViewController ()

@property (nonatomic, weak) YZWebView *webView;

@end

@implementation YZInformationDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.informationModel.title;
    [self setupChilds];
}

- (void)setupChilds
{
    //分享
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"order_share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    
    //webView
    YZWebView * webView =  [[YZWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH)];
    self.webView = webView;
    [self.view addSubview:webView];
    
    //加载
    NSURL* url = [NSURL URLWithString:self.informationModel.detailUrl];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];//加载
}

#pragma mark - 分享
- (void)share
{
    YZShareView * shareView = [[YZShareView alloc]init];
    [shareView show];
    shareView.block = ^(UMSocialPlatformType platformType){//选择平台
        [self shareImageToPlatformType:platformType];
    };
}

- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    NSString * spreadPicsUrlStr = self.informationModel.imgPath;
    UIImageView * imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:spreadPicsUrlStr] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
#if JG
            image = [UIImage imageNamed:@"logo"];
#elif ZC
            image = [UIImage imageNamed:@"logo1"];
#elif CS
            image = [UIImage imageNamed:@"logo1"];
#elif RR
            image = [UIImage imageNamed:@"logo1"];
#endif
        }
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.informationModel.title descr:self.informationModel.intro thumImage:image];
        shareObject.webpageUrl = self.informationModel.detailUrl;
        messageObject.shareObject = shareObject;
#if JG
        [WXApi registerApp:WXAppIdOld withDescription:@"九歌彩票"];
#elif ZC
        [WXApi registerApp:WXAppIdOld withDescription:@"中彩啦"];
#elif CS
        [WXApi registerApp:WXAppIdOld withDescription:@"中彩啦"];
#elif RR
        [WXApi registerApp:WXAppIdOld withDescription:@"中彩啦"];
#endif
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
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
    }];
}


@end
