//
//  YZBankCardRechargeViewController.m
//  ez
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZBankCardRechargeViewController.h"
#import "YZRechargeSuccessViewController.h"
#import "YZLoadHtmlFileController.h"
#import "LLPaySdk.h"//连连支付
#import "YZValidateTool.h"
#import "JSON.h"
#import "YZCardNoTextField.h"
#import "YZDecimalTextField.h"

@interface YZBankCardRechargeViewController ()<UIGestureRecognizerDelegate,UITextFieldDelegate,LLPaySdkDelegate>

@property (nonatomic, weak) UITextField *nameTF;
@property (nonatomic, weak) UITextField *cardNoTF;
@property (nonatomic, weak) UITextField *amountTextTield;
@property (nonatomic, strong) LLPaySdk *sdk;

@end

@implementation YZBankCardRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"银行卡支付";
    [self setupChilds];
}
- (void)setupChilds
{
    //背景view
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    CGFloat backViewH = 3 * YZCellH;
    backView.frame = CGRectMake(0, 10, screenWidth, backViewH);
    [self.view addSubview:backView];
    
    NSArray * titles = @[@"真实姓名",@"身份证号",@"充值金额(元)"];
    for (int i = 0; i < titles.count; i++) {
        CGFloat viewY = i * YZCellH;
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        titleLabel.textColor = YZBlackTextColor;
        titleLabel.text = titles[i];
        CGSize size = [titleLabel.text sizeWithLabelFont:titleLabel.font];
        titleLabel.frame = CGRectMake(15, viewY, size.width, YZCellH);
        [backView addSubview:titleLabel];
        
        //textField
        UITextField * textField;
        if (i == 1) {
            textField = [[YZCardNoTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame),viewY, screenWidth - CGRectGetMaxX(titleLabel.frame) - YZMargin, YZCellH)];
        }else if(i == 2)//自定义的小数键盘
        {
            textField = [[YZDecimalTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame),viewY, screenWidth - CGRectGetMaxX(titleLabel.frame) - YZMargin, YZCellH)];
            if (!supportPenny) {
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }
        }else
        {
            textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame),viewY, screenWidth - CGRectGetMaxX(titleLabel.frame) - YZMargin, YZCellH)];
        }
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        textField.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:textField];
        if (i == 0) {
            textField.placeholder = @"请输入真实姓名";
            self.nameTF = textField;
        }else if (i == 1)
        {
            textField.placeholder = @"请输入身份证号码";
            self.cardNoTF = textField;
        }else if (i == 2)
        {
            textField.placeholder = @"请输入充值金额";
            self.amountTextTield = textField;
        }
        [backView addSubview:textField];
        //分割线
        if (i != 0) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, viewY - 1, screenWidth, 1)];
            line.backgroundColor = YZWhiteLineColor;
            [backView addSubview:line];
        }
    }
//    YZUser *user = [YZUserDefaultTool user];
//    if(user.userInfo.realname && user.userInfo.cardno)//如果已经实名，就显示出来
//    {
//        self.nameTF.text = user.userInfo.realname;
//        self.cardNoTF.text = user.userInfo.cardno;
//    }
    
    //立即充值按钮
    YZBottomButton *rechargeBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    rechargeBtn.y = CGRectGetMaxY(backView.frame) + 30;
    [rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rechargeBtn];
    
    //温馨提示
    UILabel *tishi = [[UILabel alloc] init];
    tishi.numberOfLines = 0;
    if (!YZStringIsEmpty(self.intro))
    {
        NSDictionary *optoins = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
        NSData *data = [self.intro dataUsingEncoding:NSUnicodeStringEncoding];
        NSError * error;
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:data options:optoins documentAttributes:nil error:&error];
        if (!error) {
            tishi.attributedText = attributeString;
        }
    }else
    {
        tishi.textColor = YZGrayTextColor;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n1、充值免手续费，充值金额不可提现\n 2、交易限额由发卡银行统一设定，若超出限额请更换银行卡\n3、如充值未到账，请及时联系客服"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(0, attStr.length)];
        tishi.attributedText = attStr;
    }
    CGFloat tishiW = screenWidth - 2 * YZMargin;
    CGSize tishiSize = [tishi.attributedText boundingRectWithSize:CGSizeMake(tishiW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat tishiY = CGRectGetMaxY(rechargeBtn.frame) + 10;
    tishi.frame = CGRectMake(YZMargin, tishiY, tishiW, tishiSize.height);
    [self.view addSubview:tishi];
    
    //充值说明
    if (!YZStringIsEmpty(self.detailUrl)) {
        UIButton * rechargeExplainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rechargeExplainBtn setTitle:@"充值说明（点击查看）" forState:UIControlStateNormal];
        [rechargeExplainBtn setTitleColor:YZBaseColor forState:UIControlStateNormal];
        rechargeExplainBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [rechargeExplainBtn addTarget:self action:@selector(rechargeExplainBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        CGSize rechargeExplainBtnSize = [rechargeExplainBtn.currentTitle sizeWithLabelFont:rechargeExplainBtn.titleLabel.font];
        rechargeExplainBtn.frame = CGRectMake(tishi.x, CGRectGetMaxY(tishi.frame) + 10, rechargeExplainBtnSize.width, rechargeExplainBtnSize.height);
        [self.view addSubview:rechargeExplainBtn];
    }
}

- (void)rechargeExplainBtnDidClick
{
    YZLoadHtmlFileController * updataActivityVC = [[YZLoadHtmlFileController alloc] initWithWeb:self.detailUrl];
    [self.navigationController pushViewController:updataActivityVC animated:YES];
}


- (void)rechargeBtnClick
{
    if(![YZValidateTool validateNickname:self.nameTF.text])
    {
        [MBProgressHUD showError:@"您输入的姓名不正确"];
        return;
    }
    if(![YZValidateTool validateIdentityCard:self.cardNoTF.text])//身份证号验证
    {
        [MBProgressHUD showError:@"您输入的身份证号码不正确"];
        return;
    }
    if(self.amountTextTield.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入充值金额"];
        return;
    }
    //充值金额是否可用
    BOOL moneyValid = NO;
    if (supportPenny) {//支持1分充值
        moneyValid = [self.amountTextTield.text floatValue] * 100 >= 1;
    }else
    {
        moneyValid = [self.amountTextTield.text intValue] >= 1;
    }
    if(!moneyValid)
    {
        [MBProgressHUD showError:@"您输入的金额不正确"];
        return;
    }
    NSDictionary *payInfo = @{
                              @"ClientType":@(1),
                              @"PersonalId":self.cardNoTF.text,
                              @"Name":self.nameTF.text
                              };
    NSString *payInfoJsonStr = [payInfo JSONRepresentation];
    NSNumber *amount = [NSNumber numberWithFloat:[self.amountTextTield.text floatValue] * 100];
    NSDictionary *dict = @{
                           @"cmd":@(8041),
                           @"userId":UserId,
                           @"amount":amount,
                           @"payType":self.paymentId,
                           @"payInfo":payInfoJsonStr
                           };
    YZLog(@"dict = %@",dict);
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"json = %@",json);
        if (SUCCESS) {
            NSDictionary *dict = [json[@"payResult"] JSONValue];
            NSDictionary *dict1 = [dict[@"req_data"] JSONValue];
            [self lianlianPay:dict1];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        YZLog(@"rechargeBtnClick请求error");
    }];
}
- (void)lianlianPay:(NSDictionary *)dict
{
    LLPaySdk *sdk = [[LLPaySdk alloc] init];
    self.sdk = sdk;
    sdk.sdkDelegate = self;
    [sdk presentLLPaySDKInViewController:self
                             withPayType:LLPayTypeQuick
                           andTraderInfo:dict];
}
//支付结束回调
- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic
{
    if (resultCode == kLLPayResultSuccess) {
        NSString* result_pay = dic[@"result_pay"];
        if ([result_pay isEqualToString:@"SUCCESS"])
        {
            YZRechargeSuccessViewController * rechargeSuccessVC = [[YZRechargeSuccessViewController alloc]init];
            rechargeSuccessVC.rechargeSuccessType = BankCardRechargeSuccess;
            rechargeSuccessVC.isOrderPay = self.isOrderPay;
            [self.navigationController pushViewController:rechargeSuccessVC animated:YES];
        }
    }
}
@end
