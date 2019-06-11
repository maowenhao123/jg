//
//  YZForecastDetailViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/3/2.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZForecastDetailViewController.h"
#import "YZGameIdViewController.h"
#import "YZShareView.h"
#import "YZWebView.h"
#import "WXApi.h"

@interface YZForecastDetailViewController ()

@property (nonatomic, copy) NSString *web;
@property (nonatomic, weak) YZWebView *webView;
@property (nonatomic, strong) YZInformationModel *informationModel;

@end

@implementation YZForecastDetailViewController

- (instancetype)initWithWeb:(NSString *)web
{
    if(self = [super init])
    {
        self.web = web;
    }
    return  self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"咨询详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChilds];
    [self getData];
}

#pragma mark - 请求数据
- (void)getData
{
    NSArray * urlArr = [self.web componentsSeparatedByString:@"?id="];
    NSString *forecastId = urlArr.lastObject;
    if (YZStringIsEmpty(forecastId)) {
        return;
    }
    
    NSDictionary *dict = @{
                           @"id":forecastId,
                           @"sequence":[YZTool uuidString],
                           };
    waitingView;
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getAppInformationDetail") params:dict success:^(id json) {
        YZLog(@"getAppInformationDetail:%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            self.informationModel = [YZInformationModel objectWithKeyValues:json[@"appInformationDetail"]];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error)
    {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"error = %@",error);
    }];
}

#pragma mark - 布局视图
- (void)setupChilds
{
    //分享
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"order_share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
    
    //webView
    CGFloat betButtonH = 40;
    YZWebView * webView =  [[YZWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH - betButtonH - [YZTool getSafeAreaBottom])];
    self.webView = webView;
    [self.view addSubview:webView];
    
    //加载
    NSURL* url = [NSURL URLWithString:self.web];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];//加载
    
    //立即投注
    UIButton * betButton = [UIButton buttonWithType:UIButtonTypeCustom];
    betButton.frame = CGRectMake(0, screenHeight - statusBarH - navBarH - betButtonH - [YZTool getSafeAreaBottom], screenWidth, betButtonH);
    betButton.backgroundColor = [UIColor whiteColor];
    [betButton setTitle:@"去投注" forState:UIControlStateNormal];
    betButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [betButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [betButton setBackgroundImage:[UIImage ImageFromColor:YZBaseColor WithRect:betButton.bounds] forState:UIControlStateNormal];//正常
    [betButton setBackgroundImage:[UIImage ImageFromColor:YZColor(163, 32, 27, 1) WithRect:betButton.bounds] forState:UIControlStateHighlighted];//高亮
    [betButton addTarget:self action:@selector(betButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:betButton];
}

- (void)betButtonClick
{
    NSString * gameId = self.informationModel.game;
    YZGameIdViewController *destVc = (YZGameIdViewController *)[[[YZTool gameDestClassDict][gameId] alloc] initWithGameId:gameId];
    [self.navigationController pushViewController:destVc animated:YES];
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
#endif
        }
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:self.informationModel.title descr:self.informationModel.intro thumImage:image];
        shareObject.webpageUrl = self.web;
        messageObject.shareObject = shareObject;
#if JG
        [WXApi registerApp:WXAppIdOld withDescription:@"九歌彩票"];
#elif ZC
        [WXApi registerApp:WXAppIdOld withDescription:@"中彩啦"];
#elif CS
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
