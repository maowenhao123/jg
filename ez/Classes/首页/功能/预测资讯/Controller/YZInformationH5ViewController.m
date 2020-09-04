//
//  YZInformationH5ViewController.m
//  ez
//
//  Created by 毛文豪 on 2019/3/27.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZInformationH5ViewController.h"
#import "YZForecastDetailViewController.h"
#import "YZTitleButton.h"
#import "YZInformationType.h"
#import "YZWebView.h"

@interface YZInformationH5ViewController ()<WKNavigationDelegate>
{
    BOOL _openTitleMenu;//是否打开title菜单
}
@property (nonatomic, strong) YZTitleButton *titleBtn;//头部按钮
@property (nonatomic,weak) UIView *menuBgView;
@property (nonatomic, weak) YZWebView *webView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic, weak) UIView *progressView;

@end

@implementation YZInformationH5ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"预测资讯";
    [self getData];
    [self setupChilds];
}

#pragma mark - 请求数据
- (void)getData
{
    NSDictionary *dict = @{
                           };
    waitingView
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getAppInformationGameList") params:dict success:^(id json) {
        YZLog(@"getAppInformationGameList:%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            self.dataArray = [YZInformationType objectArrayWithKeyValuesArray:json[@"gameInfos"]];
            
            if (self.dataArray.count == 0) {//没有数据时
                return;
            }
            
            //默认选择第一个
            self.selectedIndex = 0;
            YZInformationType * informationType = self.dataArray.firstObject;
            [self.titleBtn setTitle:informationType.name forState:UIControlStateNormal];
            [self loadWebView];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error)
     {
         YZLog(@"error = %@",error);
         [MBProgressHUD hideHUDForView:self.view];
     }];
}

#pragma mark - 布局视图
- (void)setupChilds
{
    //标题按钮
    self.titleBtn = [[YZTitleButton alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    [self.titleBtn setTitle:@"预测资讯" forState:UIControlStateNormal];
#if JG
    [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
#elif ZC
    [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
#endif
    [self.titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleBtn;
    
    //webView
    YZWebView * webView =  [[YZWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH)];
    self.webView = webView;
    webView.navigationDelegate = self;
    [self.view addSubview:webView];
}

#pragma mark - 头部按钮点击
- (void)titleBtnClick:(UIButton *)sender
{
    if (self.dataArray.count == 0) {//没有数据时
        return;
    }
    
    //选择三角
    [UIView animateWithDuration:animateDuration animations:^{
        if(!_openTitleMenu)
        {
            sender.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        }else
        {
            sender.imageView.transform = CGAffineTransformIdentity;
        }
    }];
    _openTitleMenu = !_openTitleMenu;
    
    //底部背景遮盖
    UIView *menuBgView = [[UIView alloc] init];
    self.menuBgView = menuBgView;
    menuBgView.backgroundColor = YZColor(0, 0, 0, 0);
    menuBgView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.tabBarController.view addSubview:menuBgView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeMenuBgView)];
    [menuBgView addGestureRecognizer:tap];
    
    //菜单view
    UIView *menuView = [[UIView alloc] init];
    menuView.backgroundColor = [UIColor whiteColor];
    menuView.layer.masksToBounds = YES;
    [menuBgView addSubview:menuView];
    
    //游戏玩法按钮
    int maxColums = 3;//每行几个
    CGFloat btnH = 30;
    int padding = 5;
    UIButton *lastBtn;
    NSMutableArray *matchNameBtns = [NSMutableArray array];
    for(NSUInteger i = 0; i < self.dataArray.count; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        YZInformationType * informationType = self.dataArray[i];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitle:informationType.name forState:UIControlStateNormal];//设置按钮文字
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        if (i == self.selectedIndex) {
            btn.selected = YES;
        }else
        {
            btn.selected = NO;
        }
        CGFloat btnW = (screenWidth - maxColums * 2 * padding) / maxColums;
        CGFloat btnX = padding + (i % maxColums) * (btnW + 2 * padding);
        CGFloat btnY = 2 * padding + (i / maxColums) * (btnH + 2 * padding);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn addTarget:self action:@selector(playTypeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:btn];
        [matchNameBtns addObject:btn];
        
        lastBtn = btn;
    }
    
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = YZColor(252, 79, 61, 1);
    separator.frame = CGRectMake(0, CGRectGetMaxY(lastBtn.frame) + 2 * padding, menuBgView.width, 2);
    [menuView addSubview:separator];
    
    CGFloat menuViewH = CGRectGetMaxY(separator.frame);
    menuView.frame = CGRectMake(0, statusBarH + navBarH, screenWidth, 0);
    [UIView animateWithDuration:animateDuration animations:^{
        menuView.height = menuViewH;
    }];
}

- (void)removeMenuBgView
{
    [UIView animateWithDuration:animateDuration animations:^{
        self.titleBtn.imageView.transform = CGAffineTransformIdentity;
    }];
    _openTitleMenu = !_openTitleMenu;
    [self.menuBgView removeFromSuperview];
}

//标题按钮弹出菜单的玩法按钮
- (void)playTypeBtnClick:(UIButton *)btn
{
    self.selectedIndex = btn.tag;
    [self.titleBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
    [self removeMenuBgView];
    
    [self loadWebView];
}

- (void)loadWebView
{
    YZInformationType * informationType = self.dataArray[self.selectedIndex];
    NSString * informationUrl = informationType.informationUrl;
    NSURL* url = [NSURL URLWithString:informationUrl];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [self.webView loadRequest:request];//加载
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSURL *URL = navigationAction.request.URL;
    NSString *urlStr = URL.relativeString;
    if ([urlStr rangeOfString:@"informationdetail"].location != NSNotFound) {
        YZForecastDetailViewController * forecastDetailVC = [[YZForecastDetailViewController alloc] initWithWeb:urlStr];
        [self.navigationController pushViewController:forecastDetailVC animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - 初始化
- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

@end
