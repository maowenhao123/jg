//
//  YZFbBetSuccessViewController.m
//  ez
//
//  Created by apple on 14-12-16.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define  padding 10

#import "YZFbBetSuccessViewController.h"
#import "YZSfcViewController.h"
#import "UIButton+YZ.h"

@interface YZFbBetSuccessViewController ()
{
    float _amount;//投注金额
    float _bonus;//账户余额
    BOOL _isJC;//是否是竞彩
}
@end

@implementation YZFbBetSuccessViewController

- (instancetype)initWithAmount:(float)amount bonus:(float)bonus isJC:(BOOL)isJC
{
    if(self = [super init])
    {
        _amount = amount;
        _bonus = bonus;
        _isJC = isJC;
    }
    return  self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor whiteColor];
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:textAttrs];
    // 设置navBar背景
    [navBar setBackgroundImage:[YZTool getFBNavImage] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 取出appearance对象
    UINavigationBar *navBar = self.navigationController.navigationBar;
#if JG
    //设置颜色
    navBar.tintColor = [UIColor whiteColor];
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:textAttrs];
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:YZBaseColor WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
#elif ZC
    //设置颜色
    navBar.tintColor = YZBlackTextColor;
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = YZBlackTextColor;
    [navBar setTitleTextAttributes:textAttrs];
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
#elif CS
    //设置颜色
    navBar.tintColor = YZBlackTextColor;
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = YZBlackTextColor;
    [navBar setTitleTextAttributes:textAttrs];
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
#elif RR
    navBar.translucent = NO;//取消透明度
    if (IsBangIPhone) {
        // 设置背景
        [navBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_rr_88"] forBarMetrics:UIBarMetricsDefault];
    }else
    {
        // 设置背景
        [navBar setBackgroundImage:[UIImage imageNamed:@"nav_bg_rr_64"] forBarMetrics:UIBarMetricsDefault];
    }
    navBar.shadowImage = nil;
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //设置颜色
    navBar.tintColor = [UIColor whiteColor];
    
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];;
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [navBar setTitleTextAttributes:textAttrs];
#endif
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"下单成功";
    self.view.backgroundColor = YZBackgroundColor;
    [self setupChilds];
}

-(void)setupChilds
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"success_green_icon"] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:YZGetFontSize(35)]];
    [button setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    if (_isJC) {
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]initWithString:@"订单成功,正在出票\n所选赔率以实际出票为准"];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(9, attStr.length - 9)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZColor(150, 150, 150, 1) range:NSMakeRange(9, attStr.length - 9)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
        button.titleLabel.numberOfLines = 0;
        [button setAttributedTitle:attStr forState:UIControlStateNormal];
    }else
    {
        [button setTitle:@"订单成功,正在出票" forState:UIControlStateNormal];
    }
    button.frame = CGRectMake(0, screenHeight * 0.15, screenWidth, 50);
    [button setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:10];
    button.userInteractionEnabled = NO;
    [self.view addSubview:button];
    
    UILabel * detailLabel = [[UILabel alloc] init];
    detailLabel.numberOfLines = 0;
    NSMutableAttributedString * detailAttStr = [[NSMutableAttributedString alloc]initWithString:@"出票状态显示为“出票成功”方为购买成功，请留意该订单的出票状态，祝您中奖！"];
    [detailAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(0, detailAttStr.length)];
    [detailAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(150, 150, 150, 1) range:NSMakeRange(0, detailAttStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [detailAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, detailAttStr.length)];
    detailLabel.attributedText = detailAttStr;
    CGFloat detailLabelX = 20;
    CGFloat detailLabelW = screenWidth - 2 * detailLabelX;
    CGSize detailLabelSize = [detailLabel.attributedText boundingRectWithSize:CGSizeMake(detailLabelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    detailLabel.frame = CGRectMake(detailLabelX, CGRectGetMaxY(button.frame) + 15, detailLabelW, detailLabelSize.height);
    [self.view addSubview:detailLabel];
    
    //继续投注
    YZBottomButton * againBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    againBtn.y = CGRectGetMaxY(detailLabel.frame) + 50;
    [againBtn setTitle:@"继续投注" forState:UIControlStateNormal];
    [againBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(88, 148, 34, 1) WithRect:againBtn.bounds] forState:UIControlStateNormal];
    [againBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(88, 148, 34, 1) WithRect:againBtn.bounds] forState:UIControlStateHighlighted];
    [againBtn addTarget:self action:@selector(backToBuyLottery) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:againBtn];
    
    //查看投注记录
    YZBottomButton * lookBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    lookBtn.y = CGRectGetMaxY(againBtn.frame) + 20;
    [lookBtn setTitle:@"查看投注记录" forState:UIControlStateNormal];
    [lookBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    [lookBtn setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:lookBtn.bounds] forState:UIControlStateNormal];
    [lookBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(216, 216, 216, 1) WithRect:lookBtn.bounds] forState:UIControlStateHighlighted];
    [lookBtn addTarget:self action:@selector(lookBetRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lookBtn];
}

- (void)lookBetRecord
{
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self.navigationController popToRootViewControllerAnimated:NO];
        });
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:RefreshRecordNote object:@(AccountRecordTypeMyBet)];
        });
    }];
    [op2 addDependency:op1];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue waitUntilAllOperationsAreFinished];
    [queue addOperation:op1];
    [queue addOperation:op2];
}

- (void)backToBuyLottery
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
