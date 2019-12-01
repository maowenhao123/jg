//
//  YZLoadHtmlFileController.m
//  ez
//
//  Created by apple on 14-9-24.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZLoadHtmlFileController.h"
#import "YZLoginViewController.h"
#import "YZNavigationController.h"
#import "YZShareProfitsViewController.h"
#import "YZWebView.h"

@interface YZLoadHtmlFileController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, weak) YZWebView *webView;

@end

@implementation YZLoadHtmlFileController

- (instancetype)initWithFileName:(NSString *)fileName
{
    if(self = [super init])
    {
        self.fileName = fileName;
    }
    return  self;
}
- (instancetype)initWithWeb:(NSString *)web
{
    if(self = [super init])
    {
        self.web = web;
    }
    return  self;
}
- (instancetype)initWithHtmlStr:(NSString *)htmlStr
{
    if(self = [super init])
    {
        self.htmlStr = htmlStr;
    }
    return  self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:@"goBrowser"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChilds];
}

- (void)setupChilds
{
    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithIcon:@"back_btn_flat" highIcon:@"back_btn_flat" target:self action:@selector(back)];
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addScriptMessageHandler:self name:@"goBrowser"];
    configuration.userContentController = userContentController;
    
    YZWebView * webView =  [[YZWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH) configuration:configuration];
    self.webView = webView;
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    webView.allowsBackForwardNavigationGestures = YES;
    [self.view addSubview:webView];
    [self loadWebView];
    
    [webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)back
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else
    {
        if (self.navigationController.viewControllers.count == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma  mark - 加载HTML文件
- (void)loadWebView
{
    if (self.fileName) {
        NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
        NSString *filePath  = [resourcePath stringByAppendingPathComponent:self.fileName];
        NSString *htmlstring = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        [self.webView loadHTMLString:htmlstring baseURL:[NSURL fileURLWithPath: [[NSBundle mainBundle] bundlePath]]];
    }else if (self.web)
    {
        NSURL* url = [NSURL URLWithString:self.web];//创建URL
        NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
        [self.webView loadRequest:request];//加载
    }else if (self.htmlStr)
    {
        [self.webView loadHTMLString:self.htmlStr baseURL:nil];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    [webView reload];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    NSString * urlStr = URL.relativeString;
    NSLog(@"urlStr：%@", urlStr);
    if ([urlStr isEqualToString:@"self://promotion/getUpgradeCoupon"]) {//领券
        [self handleCustomAction:URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([urlStr isEqualToString:@"self://shareMakeMoney"]) {//分享活动
        YZShareProfitsViewController * shareVC = [[YZShareProfitsViewController alloc] init];
        [self.navigationController pushViewController:shareVC animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([urlStr isEqualToString:@"self://weixinPublishCode"]) {//跳转微信
        [self skipWeixin];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }else if ([urlStr isEqualToString:@"ezcp://personalCenter"]) {//html充值成功
        NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
        }];
        NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:HtmlRechargeSuccessNote object:nil];
            });
        }];
        [op2 addDependency:op1];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue waitUntilAllOperationsAreFinished];
        [queue addOperation:op1];
        [queue addOperation:op2];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {//需要跨域跳转的去浏览器里
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }

    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)handleCustomAction:(NSURL *)url
{
    if (!UserId) {
        YZLoginViewController *login = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    NSDictionary *dict = @{
                           @"userId":UserId,
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlShare(@"/getUpgradeCoupon") params:dict success:^(id json) {
        YZLog(@"getGuide:%@",json);
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"领券成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
    }];
}
- (void)skipWeixin
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"weixin://"]];
}

#pragma mark - 进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"title"]) {
        if (self.navigationController.navigationBarHidden == NO) {
            self.title = self.webView.title;
        }
    }
}

#pragma mark - WKUIDelegate
//此方法作为js的alert方法接口的实现，默认弹出窗口应该只有提示信息及一个确认按钮，当然可以添加更多按钮以及其他内容，但是并不会起到什么作用
//点击确认按钮的相应事件需要执行completionHandler，这样js才能继续执行
////参数 message为  js 方法 alert(<message>) 中的<message>
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

//作为js中confirm接口的实现，需要有提示信息以及两个相应事件， 确认及取消，并且在completionHandler中回传相应结果，确认返回YES， 取消返回NO
//参数 message为  js 方法 confirm(<message>) 中的<message>
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

//作为js中prompt接口的实现，默认需要有一个输入框一个按钮，点击确认按钮回传输入值
//当然可以添加多个按钮以及多个输入框，不过completionHandler只有一个参数，如果有多个输入框，需要将多个输入框中的值通过某种方式拼接成一个字符串回传，js接收到之后再做处理

//参数 prompt 为 prompt(<message>, <defaultValue>);中的<message>
//参数defaultText 为 prompt(<message>, <defaultValue>);中的 <defaultValue>
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(alertController.textFields[0].text?:@"");
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"goBrowser"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:message.body[@"url"]]];
    }
}


#pragma mark - dealloc
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"title"];
}

@end
