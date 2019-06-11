//
//  YZRechargeSuccessViewController.m
//  ez
//
//  Created by apple on 16/7/13.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZRechargeSuccessViewController.h"

@implementation YZRechargeSuccessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"充值成功";
    [self setupChilds];
    [self loadUserInfo];//充值成功，刷新个人信息
    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithIcon:@"back_btn_flat" highIcon:@"back_btn_flat" target:self action:@selector(backToBet)];
}
//获取用户个人信息
- (void)loadUserInfo
{
    NSDictionary *dict = @{
                           @"cmd":@(8006),
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        //存储用户信息
        if (SUCCESS) {
            YZUser *user = [YZUser objectWithKeyValues:json];
            [YZUserDefaultTool saveUser:user];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"账户error");
    }];
}
- (void)setupChilds
{
    //提示
    UILabel * rechargeSuccessLabel1 = [[UILabel alloc]init];
    rechargeSuccessLabel1.font = [UIFont systemFontOfSize:YZGetFontSize(35)];
    rechargeSuccessLabel1.textColor = YZBlackTextColor;
    rechargeSuccessLabel1.textAlignment = NSTextAlignmentCenter;
    rechargeSuccessLabel1.numberOfLines = 0;
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc]init];
    if (self.rechargeSuccessType == PhoneCardRechargeSuccess) {//电话卡充值成功
        attStr = [[NSMutableAttributedString alloc]initWithString:@"等待运营商反馈\n预计充值金额1-5分钟到账"];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(7, attStr.length - 7)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(7, attStr.length - 7)];
    }else//微信充值或支付宝
    {
        attStr = [[NSMutableAttributedString alloc]initWithString:@"账户充值交易已完成\n请返回个人中心刷余额"];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(9, attStr.length - 9)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(9, attStr.length - 9)];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
    CGSize rechargeSuccessLabel1Size = [attStr boundingRectWithSize:CGSizeMake(screenWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    rechargeSuccessLabel1.attributedText = attStr;
    rechargeSuccessLabel1.frame = CGRectMake(0, screenHeight * 0.15, screenWidth, rechargeSuccessLabel1Size.height + 10);
    [self.view addSubview:rechargeSuccessLabel1];
    
    //按钮
    YZBottomButton * accountBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    accountBtn.y = CGRectGetMaxY(rechargeSuccessLabel1.frame) + 50;
    if (self.isOrderPay) {
        [accountBtn setTitle:@"支付订单" forState:UIControlStateNormal];
    }else
    {
        [accountBtn setTitle:@"我的账号" forState:UIControlStateNormal];
    }
    [accountBtn addTarget:self action:@selector(accountBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:accountBtn];
    
    YZBottomButton * buyLotteryBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    buyLotteryBtn.y = CGRectGetMaxY(accountBtn.frame) + 20;
    [buyLotteryBtn setTitle:@"购彩大厅" forState:UIControlStateNormal];
    [buyLotteryBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    [buyLotteryBtn setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:buyLotteryBtn.bounds] forState:UIControlStateNormal];
    [buyLotteryBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(216, 216, 216, 1) WithRect:buyLotteryBtn.bounds] forState:UIControlStateHighlighted];
    [buyLotteryBtn addTarget:self action:@selector(buyLotteryClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buyLotteryBtn];
    
    //温馨提示
    UILabel * footerLabel = [[UILabel alloc]init];
    footerLabel.numberOfLines = 0;
    NSString * footerStr = @"温馨提示：\n1、一般情况下充值为即时到账，当充值成功后，请再次查看账户的余额，若长时间未到账请咨询客服。";
    NSMutableAttributedString * footerAttStr = [[NSMutableAttributedString alloc]initWithString:footerStr];
    [footerAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(0, footerAttStr.length)];
    [footerAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, footerAttStr.length)];
    NSMutableParagraphStyle *footerParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    [footerParagraphStyle setLineSpacing:5];
    [footerAttStr addAttribute:NSParagraphStyleAttributeName value:footerParagraphStyle range:NSMakeRange(0, footerAttStr.length)];
    footerLabel.attributedText = footerAttStr;
    CGSize size = [footerLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - 2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    footerLabel.frame = CGRectMake(YZMargin, CGRectGetMaxY(buyLotteryBtn.frame) + 10, size.width, size.height);
    [self.view addSubview:footerLabel];
    
    UILabel * callLabel = [[UILabel alloc]init];
    callLabel.text = @"2、客服电话:";
    callLabel.textColor = YZGrayTextColor;
    callLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    CGFloat labelY = CGRectGetMaxY(footerLabel.frame) + 5;
    CGSize callLabelSize = [callLabel.text sizeWithFont:callLabel.font maxSize:CGSizeMake(screenWidth - 2 * YZMargin, MAXFLOAT)];
    callLabel.frame = CGRectMake(YZMargin, labelY, callLabelSize.width, callLabelSize.height);
    [self.view addSubview:callLabel];
    
    UIButton * callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn setTitleColor:YZBlueBallColor forState:UIControlStateNormal];
    [callBtn setTitle:@"400-700-1898" forState:UIControlStateNormal];
    callBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    CGSize callBtnSize = [callBtn.currentTitle sizeWithLabelFont:callBtn.titleLabel.font];
    callBtn.frame = CGRectMake(CGRectGetMaxX(callLabel.frame) + 3, labelY, callBtnSize.width, callLabelSize.height);
    [callBtn addTarget:self action:@selector(kefuClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callBtn];    
}
- (void)kefuClick
{
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSString *telUrl = @"tel://4007001898";
    NSURL *telURL =[NSURL URLWithString:telUrl];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}

- (void)backToBet
{
    [self accountBtnClick];
}
- (void)accountBtnClick
{
    if (self.isOrderPay) {
        [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
    }else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
- (void)buyLotteryClick
{
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ToBuyLottery" object:nil];
            
        });
    }];
    [op1 addDependency:op2];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:op1];
    [queue addOperation:op2];
}

@end
