//
//  YZSecretChangeViewController.m
//  ez
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZSecretChangeViewController.h"
#import "YZSecretChangeTwoViewController.h"
#import "YZValidateTool.h"

@interface YZSecretChangeViewController ()

@property (nonatomic, weak) UITextField *accountTextField;
@property (nonatomic, weak) UIButton * nextButton;

@end

@implementation YZSecretChangeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"验证信息";
    self.view.backgroundColor = YZBackgroundColor;

    //初始化子控件
    [self setupChilds];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.accountTextField];
}
#pragma  mark - 初始化子控件
- (void)setupChilds
{
    //进度
    UIView *progressBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 60)];
    progressBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:progressBackView];
    
    CGFloat progressImageViewWH = 18;
    CGFloat progressImageViewY = (60 - progressImageViewWH) / 2;
    CGFloat arrowImageViewW = 42;
    CGFloat arrowImageViewH = 5;
    CGFloat arrowImageViewY = (60 - arrowImageViewH) / 2;
    NSMutableArray *progressViews = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIView * progressView = [[UIView alloc]init];
        [progressBackView addSubview:progressView];
        
        //图片
        UIImageView * progressImageView = [[UIImageView alloc]init];
        if (i == 0) {
            progressImageView.image = [UIImage imageNamed:@"secretChange1_red"];
        }else if (i == 1)
        {
            progressImageView.image = [UIImage imageNamed:@"secretChange2_gray"];
        }else if (i == 2)
        {
            progressImageView.image = [UIImage imageNamed:@"secretChange3_gray"];
        }
        [progressView addSubview:progressImageView];
        
        //文字
        UILabel * progressLabel = [[UILabel alloc]init];
        if (i == 0) {
            progressLabel.text = @"验证信息";
            progressLabel.textColor = YZBaseColor;
        }else if (i == 1)
        {
            progressLabel.text = @"验证手机号";
            progressLabel.textColor = YZBaseColor;
        }else if (i == 2)
        {
            progressLabel.text = @"重置密码";
            progressLabel.textColor = YZBaseColor;
        }
        progressLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        [progressView addSubview:progressLabel];
        
        //设置frame
        CGSize progressLabelSize = [progressLabel.text sizeWithLabelFont:progressLabel.font];
        CGFloat progressViewW = progressImageViewWH + 5 + progressLabelSize.width;
        if (i == 0) {
            progressView.frame = CGRectMake(10, 0, progressViewW, progressBackView.height);
        }else if (i == 1)
        {
            progressView.frame = CGRectMake((screenWidth - progressViewW) / 2, 0, progressViewW, progressBackView.height);
        }else if (i == 2)
        {
            progressView.frame = CGRectMake(screenWidth - 10 - progressViewW, 0, progressViewW, progressBackView.height);
        }
        progressImageView.frame = CGRectMake(0, progressImageViewY, progressImageViewWH, progressImageViewWH);
        progressLabel.frame = CGRectMake(progressImageViewWH + 5, 0, progressLabelSize.width, progressView.height);
        [progressViews addObject:progressView];
        
        if (i != 0) {//箭头
            UIImageView * arrowImageView = [[UIImageView alloc]init];
            if (i == 1) {
                arrowImageView.image = [UIImage imageNamed:@"secretChange_arrow_red"];
            }else if (i == 2)
            {
                arrowImageView.image = [UIImage imageNamed:@"secretChange_arrow_gray"];
            }
            UIView * progressView1 = progressViews[i - 1];
            UIView * progressView2 = progressViews[i];
            CGFloat distance = CGRectGetMinX(progressView2.frame) - CGRectGetMaxX(progressView1.frame);
            CGFloat arrowImageViewX = CGRectGetMaxX(progressView1.frame) + (distance - arrowImageViewW) / 2;
            arrowImageView.frame = CGRectMake(arrowImageViewX, arrowImageViewY, arrowImageViewW, arrowImageViewH);
            [progressBackView addSubview:arrowImageView];
        }
    }
    
    //账户底界面
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(progressBackView.frame) + 15, screenWidth, 44)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    //账号输入框:
    UITextField *accountTextField = [[UITextField alloc]initWithFrame:CGRectMake(YZMargin,0,screenWidth - 2 * YZMargin, YZCellH)];
    self.accountTextField = accountTextField;
    accountTextField.textColor = YZBlackTextColor;
    accountTextField.placeholder = @"请输入注册用户名或手机号码";
    accountTextField.borderStyle = UITextBorderStyleNone;
    accountTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    accountTextField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    accountTextField.returnKeyType = UIReturnKeyDone;
    [backView addSubview:accountTextField];
    
    //下一步按钮
    YZBottomButton * nextButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.nextButton = nextButton;
    nextButton.y = CGRectGetMaxY(backView.frame) + 30;
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    nextButton.enabled = NO;//默认不可选
    [self.view addSubview:nextButton];

    //联系客服按钮
    UILabel * promptLabel = [[UILabel alloc]init];
    promptLabel.text = @"客服电话";
    promptLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    promptLabel.textColor = YZBlackTextColor;
    [self.view addSubview:promptLabel];
    
    UIButton * callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [callBtn setTitleColor:YZBlueBallColor forState:UIControlStateNormal];
    [callBtn setTitle:@"4007001898" forState:UIControlStateNormal];
    callBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [callBtn addTarget:self action:@selector(kefuClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:callBtn];
    
    CGSize promptLabelSize = [promptLabel.text sizeWithLabelFont:promptLabel.font];
    CGSize callBtnSize = [callBtn.currentTitle sizeWithLabelFont:callBtn.titleLabel.font];
    
    CGFloat promptLabel1X = (screenWidth - promptLabelSize.width - 2 -callBtnSize.width) / 2;
    CGFloat promptLabel1Y = screenHeight - statusBarH - navBarH - [YZTool getSafeAreaBottom] - 30;
    promptLabel.frame = CGRectMake(promptLabel1X, promptLabel1Y, promptLabelSize.width, promptLabelSize.height);
    
    callBtn.frame = CGRectMake(CGRectGetMaxX(promptLabel.frame) + 2, promptLabel1Y, callBtnSize.width, promptLabelSize.height);
}
- (void)kefuClick
{
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSString *telUrl = @"tel://4007001898";
    NSURL *telURL =[NSURL URLWithString:telUrl];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}
- (void)nextBtnPressed
{
    if(![YZValidateTool validateUserName:self.accountTextField.text] || ![YZValidateTool validateMobile:self.accountTextField.text])
    {
        [MBProgressHUD showError:@"您输入的格式不正确"];
        return;
    }
    NSDictionary *dict = @{
                           @"cmd":@(10601),
                           @"userName":self.accountTextField.text
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"json = %@",json);
        if(SUCCESS)
        {
            NSString *phoneStr = json[@"phone"];
            if (phoneStr.length == 11) {
                YZSecretChangeTwoViewController *secretChangeTwo = [[YZSecretChangeTwoViewController alloc] init];
                secretChangeTwo.phoneStr = phoneStr;
                [self.navigationController pushViewController:secretChangeTwo animated:YES];
            }
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        YZLog(@"忘记密码第一步请求error");
    }];
}
//限制输入字符个数
-(void)textFieldEditChanged:(NSNotification *)notification
{
    if(self.accountTextField.text.length == 0)
    {
        self.nextButton.enabled = NO;
        return;
    }
    self.nextButton.enabled = YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.accountTextField];
}
@end
