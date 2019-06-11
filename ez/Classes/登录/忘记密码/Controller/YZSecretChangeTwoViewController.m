//
//  YZSecretChangeTwoViewController.m
//  ez
//
//  Created by apple on 14-9-1.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZSecretChangeTwoViewController.h"
#import "YZSecretChangeThreeViewController.h"
#import "YZValidateTool.h"

@interface YZSecretChangeTwoViewController ()
{
    int oneMinute;
}
@property (nonatomic, weak) UITextField *verifyCodeTextField;
@property (nonatomic, weak) UIButton *codeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, weak) UIButton * nextButton;

@end

@implementation YZSecretChangeTwoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"验证手机号";
    //初始化子控件
    [self setupChilds];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.verifyCodeTextField];

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
            progressImageView.image = [UIImage imageNamed:@"secretChange2_red"];
        }else if (i == 2)
        {
            progressImageView.image = [UIImage imageNamed:@"secretChange3_gray"];
        }
        [progressView addSubview:progressImageView];
        
        //文字
        UILabel * progressLabel = [[UILabel alloc]init];
        if (i == 0) {
            progressLabel.text = @"验证信息";
            progressLabel.textColor = YZRedTextColor;
        }else if (i == 1)
        {
            progressLabel.text = @"验证手机号";
            progressLabel.textColor = YZRedTextColor;
        }else if (i == 2)
        {
            progressLabel.text = @"重置密码";
            progressLabel.textColor = YZGrayTextColor;
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
                arrowImageView.image = [UIImage imageNamed:@"secretChange_arrow_red"];
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
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(progressBackView.frame) + 15, screenWidth, 2 * YZCellH)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    //手机号
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    titleLabel.textColor = YZBlackTextColor;
    titleLabel.text = @"已绑定手机";
    CGSize titleLabelSize = [titleLabel.text sizeWithLabelFont:titleLabel.font];
    titleLabel.frame = CGRectMake(YZMargin, 0, titleLabelSize.width, YZCellH);
    [backView addSubview:titleLabel];
    
    UILabel * phoneLabel = [[UILabel alloc]init];
    phoneLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    phoneLabel.textColor = YZGrayTextColor;
    NSString * phoneStr = [self.phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    phoneLabel.text = phoneStr;
    CGSize phoneLabelSize = [phoneLabel.text sizeWithLabelFont:phoneLabel.font];
    phoneLabel.frame = CGRectMake(screenWidth -  phoneLabelSize.width - YZMargin, 0, phoneLabelSize.width, YZCellH);
    [backView addSubview:phoneLabel];
    
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, YZCellH - 1, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [backView addSubview:line];
    
    //验证码输入框:
    UITextField *verifyCodeTextField = [[UITextField alloc]init];
    self.verifyCodeTextField = verifyCodeTextField;
    verifyCodeTextField.textColor = YZBlackTextColor;
    verifyCodeTextField.placeholder = @"输入验证码";
    verifyCodeTextField.borderStyle = UITextBorderStyleNone;
    verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    verifyCodeTextField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    verifyCodeTextField.returnKeyType = UIReturnKeyDone;
    [backView addSubview:verifyCodeTextField];
    
    //获取验证码的按钮
    CGFloat codeBtnH = 31;
    CGFloat codeBtnY = YZCellH + (YZCellH - codeBtnH) / 2;
    YZBottomButton * codeBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.codeBtn = codeBtn;
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    CGSize codeBtnSize = [codeBtn.currentTitle sizeWithLabelFont:codeBtn.titleLabel.font];
    CGFloat codeBtnW = codeBtnSize.width + 10;
    codeBtn.frame = CGRectMake(screenWidth - codeBtnW - YZMargin, codeBtnY, codeBtnW, codeBtnH);
    verifyCodeTextField.frame = CGRectMake(YZMargin, YZCellH, screenWidth - 2 * YZMargin - codeBtnW, YZCellH);
    [codeBtn addTarget:self action:@selector(getCodeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:codeBtn];
    
    //下一步按钮
    YZBottomButton * nextButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.nextButton = nextButton;
    nextButton.y = CGRectGetMaxY(backView.frame) + 30;
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextButton.enabled = NO;//默认不可选
    [nextButton addTarget:self action:@selector(nextButtonPressed) forControlEvents:UIControlEventTouchUpInside];
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
#pragma  mark - 获取验证码按钮点击
- (void)getCodeBtnPressed
{
    [self.view endEditing:YES];
    NSDictionary *dict = @{
                           @"cmd":@(12001),
                           @"phone":self.phoneStr
                           };
    self.codeBtn.enabled = NO;
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            //倒计时
            [self countDown];
        }else
        {
            ShowErrorView
            //倒计时失效
            self.codeBtn.enabled = YES;
            [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            [self.timer invalidate];
            self.timer = nil;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"获取验证码失败"];
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }];
}
- (void)countDown
{
    oneMinute = 60;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextSecond) userInfo:nil repeats:YES];
    self.timer =timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)nextSecond
{
    if(oneMinute > 0)
    {
        self.codeBtn.enabled = NO;
        oneMinute--;
        [self.codeBtn setTitle:[NSString stringWithFormat:@"%d秒",oneMinute] forState:UIControlStateNormal];
    }else
    {
        self.codeBtn.enabled = YES;
        [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timer invalidate];
        self.timer = nil;
    }
}
#pragma  mark - 提交按钮点击
- (void)nextButtonPressed
{
    
    NSDictionary *dict = @{
                           @"cmd":@(12011),
                           @"phone":self.phoneStr,
                           @"verifyCode":self.verifyCodeTextField.text,
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"json = %@",json);
        if(SUCCESS)
        {
            //跳转到找回密码的界面
            YZSecretChangeThreeViewController *three = [[YZSecretChangeThreeViewController alloc] init];
            three.phoneStr = self.phoneStr;
            three.verifyCode = self.verifyCodeTextField.text;
            [self.navigationController pushViewController:three animated:YES];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        
        YZLog(@"忘记密码下一步请求error");
    }];
}
//限制输入字符个数
-(void)textFieldEditChanged:(NSNotification *)notification
{
    if(self.verifyCodeTextField.text.length == 0)
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
                                                 object:self.verifyCodeTextField];
}
@end
