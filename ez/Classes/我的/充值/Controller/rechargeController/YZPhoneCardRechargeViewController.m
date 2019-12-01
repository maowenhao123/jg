//
//  YZPhoneCardRechargeViewController.m
//  ez
//
//  Created by apple on 14-10-23.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZPhoneCardRechargeViewController.h"
#import "YZRechargeSuccessViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZBottomPickerView.h"
#import "YZDecimalTextField.h"

@interface YZPhoneCardRechargeViewController ()
{
    NSInteger _cardTypeCombine;
}
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UITextField *cardTypeTextField;//卡类型
@property (nonatomic, weak) UITextField *snTextField;//序号
@property (nonatomic, weak) UITextField *passwordTextField;//密码
@property (nonatomic, weak) UITextField *chargeMoneyTextField;//钱
@property (nonatomic, weak) UIView *backView;

@end

@implementation YZPhoneCardRechargeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"手机充值卡充值";
    [self setupChilds];
}
- (void)setupChilds
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH);
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    //输入框的背景view
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    CGFloat backViewY = 10;
    CGFloat backViewW = screenWidth;
    CGFloat backViewH = 4 * YZCellH;
    backView.frame = CGRectMake(0, backViewY, backViewW, backViewH);
    [scrollView addSubview:backView];
    
    NSArray * titleArray = @[@"运营商",@"序号",@"密码",@"金额(元)"];
    //四个label、textfield
    for(int i = 0;i < 4;i++)
    {
        //四个label
        UILabel *label = [[UILabel alloc] init];
        label.text = titleArray[i];
        label.textColor = YZBlackTextColor;
        label.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        CGFloat labelX = YZMargin;
        CGFloat labelY = i * YZCellH;
        CGSize labelSize = [label.text sizeWithLabelFont:label.font];
        CGFloat labelW = labelSize.width;
        label.frame = CGRectMake(labelX, labelY, labelW, YZCellH);
        [backView addSubview:label];
        
        //四个textfield
        UITextField *textfield = [[UITextField alloc] init];
        if (i == 3 && supportPenny) {
            textfield = [[YZDecimalTextField alloc] init];
        }
        textfield.keyboardType = UIKeyboardTypeNumberPad;
        textfield.textColor = YZBlackTextColor;
        textfield.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        textfield.textAlignment = NSTextAlignmentRight;
        CGFloat textfieldX = CGRectGetMaxX(label.frame);
        CGFloat textfieldY = labelY;
        CGFloat textfieldW = backViewW - YZMargin - CGRectGetMaxX(label.frame);
        CGFloat textfieldH = YZCellH;
        textfield.frame = CGRectMake(textfieldX, textfieldY, textfieldW, textfieldH);
        [backView addSubview:textfield];
        
        if(i == 0)
        {
            self.cardTypeTextField = textfield;
            textfield.text = @"中国移动";
            textfield.width = textfield.width - 8 - 5;
            textfield.userInteractionEnabled = NO;
            //隐形按钮，遮盖输入框
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = textfield.frame;
            [btn addTarget:self action:@selector(selectMobileOperator) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:btn];
            
            //accessory
            CGFloat accessoryW = 8;
            CGFloat accessoryH = 11;
            UIImageView * accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - YZMargin - accessoryW, (YZCellH - accessoryH) / 2, accessoryW, accessoryH)];
            accessoryImageView.image = [UIImage imageNamed:@"accessory_dray"];
            [backView addSubview:accessoryImageView];
        }else if(i == 1)
        {
            self.snTextField = textfield;
            textfield.placeholder = @"请输入序号";
        }else if (i == 2)
        {
            self.passwordTextField = textfield;
            textfield.secureTextEntry = YES;//密码模式
            textfield.placeholder = @"请输入密码";
        }else if (i == 3)
        {
            self.chargeMoneyTextField = textfield;
            textfield.placeholder = @"请输入金额";
            if (!supportPenny) {
                textfield.keyboardType = UIKeyboardTypeNumberPad;
            }else
            {
                textfield.keyboardType = UIKeyboardTypeDecimalPad;
            }
        }
        //分割线
        if (i != 3) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, YZCellH * (i + 1) - 1, screenWidth, 1)];
            line.backgroundColor = YZWhiteLineColor;
            [backView addSubview:line];
        }
    }
    //充值按钮
    YZBottomButton *rechargeBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    rechargeBtn.y = CGRectGetMaxY(backView.frame) + 30;
    [rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:rechargeBtn];
    
    //提示文字
    UILabel *promptLabel = [[UILabel alloc] init];
    promptLabel.numberOfLines = 0;
    if (!YZStringIsEmpty(self.intro))
    {
        NSDictionary *optoins = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
        NSData *data = [self.intro dataUsingEncoding:NSUnicodeStringEncoding];
        NSError * error;
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:data options:optoins documentAttributes:nil error:&error];
        if (!error) {
            promptLabel.attributedText = attributeString;
        }
    }else
    {
        promptLabel.textColor = YZGrayTextColor;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n1、运营商收取充值卡面额3%的服务费，在充值金额中直接扣除；\n2、请务必选择与充值卡面额相同的金额，否则会导致支付不成功，或资金丢失。（如：使用面额100元的充值卡但选择50元，高于50元部分不返还）\n3、充值金额不可提现，奖金可以提现。\n\n全国通用的移动卡（序列号17位，密码18位）\n全国通用的联通卡（序列号15位，密码19位）\n全国通用的电信卡（序列号19位，密码18位）\n福建地方的移动卡（序列号16位，密码17位）\n浙江地方的移动卡（序列号10位，密码8位）\n江苏地方的移动卡（序列号16位，密码17位）\n辽宁地方的移动卡（序列号18位，密码21位"];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(0, attStr.length)];
        promptLabel.attributedText = attStr;
    }
    CGFloat labelY = CGRectGetMaxY(rechargeBtn.frame) + 10;
    CGFloat labelW = screenWidth - 2 * YZMargin;
    CGSize labelSize = [promptLabel.attributedText boundingRectWithSize:CGSizeMake(labelW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    promptLabel.frame = CGRectMake(YZMargin, labelY, labelSize.width, labelSize.height);
    [scrollView addSubview:promptLabel];
    
    //充值说明
    if (!YZStringIsEmpty(self.detailUrl)) {
        UIButton * rechargeExplainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rechargeExplainBtn setTitle:@"充值说明（点击查看）" forState:UIControlStateNormal];
        [rechargeExplainBtn setTitleColor:YZBaseColor forState:UIControlStateNormal];
        rechargeExplainBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [rechargeExplainBtn addTarget:self action:@selector(rechargeExplainBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        CGSize rechargeExplainBtnSize = [rechargeExplainBtn.currentTitle sizeWithLabelFont:rechargeExplainBtn.titleLabel.font];
        rechargeExplainBtn.frame = CGRectMake(promptLabel.x, CGRectGetMaxY(promptLabel.frame) + 10, rechargeExplainBtnSize.width, rechargeExplainBtnSize.height);
        [self.view addSubview:rechargeExplainBtn];
        
        scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(rechargeExplainBtn.frame) + YZMargin);
    }else
    {
        scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(promptLabel.frame) + YZMargin);
    }
}

- (void)rechargeExplainBtnDidClick
{
    YZLoadHtmlFileController * updataActivityVC = [[YZLoadHtmlFileController alloc] initWithWeb:self.detailUrl];
    [self.navigationController pushViewController:updataActivityVC animated:YES];
}

#pragma mark - 选择运营商
- (void)selectMobileOperator
{
    [self.view endEditing:YES];
    //选择银行
    NSArray * mobileOperators = @[@"中国移动",@"中国联通",@"中国电信"];
    YZBottomPickerView * chooseMobileOperatorView = [[YZBottomPickerView alloc]initWithArray:mobileOperators index:_cardTypeCombine];
    chooseMobileOperatorView.block = ^(NSInteger selectedIndex){
        _cardTypeCombine = selectedIndex;
        self.cardTypeTextField.text = [NSString stringWithFormat:@"%@",mobileOperators[selectedIndex]];
    };
    [chooseMobileOperatorView show];
}
- (void)rechargeBtnClick
{
    if (self.snTextField.text.length < 1)
    {
        [MBProgressHUD showError:@"请输入充值卡序号"];
        return;
    }else if (self.passwordTextField.text.length < 1)
    {
        [MBProgressHUD showError:@"请输入充值卡密码"];
        return;
    }else if(self.chargeMoneyTextField.text.length == 0)
    {
        [MBProgressHUD showError:@"请输入充值金额"];
        return;
    }
    //充值金额是否可用
    BOOL moneyValid = NO;
    if (supportPenny) {//支持1分充值
        moneyValid = [self.chargeMoneyTextField.text floatValue] * 100 >= 1;
    }else
    {
        moneyValid = [self.chargeMoneyTextField.text intValue] >= 1;
    }
    if(!moneyValid)
    {
        [MBProgressHUD showError:@"您输入的金额不正确"];
        return;
    }
    
    NSNumber *chargeMoney = [NSNumber numberWithFloat:[self.chargeMoneyTextField.text floatValue] * 100];
    NSDictionary *dict = @{
                           @"cmd":@(8030),
                           @"userId":UserId,
                           @"cardTypeCombine":@(_cardTypeCombine),
                           @"chargeMoney":chargeMoney,
                           @"sn":self.snTextField.text,
                           @"password":self.passwordTextField.text,
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"rechargeBtnClick - json = %@",json);
        if(SUCCESS)
        {
            YZRechargeSuccessViewController *successVc = [[YZRechargeSuccessViewController alloc] init];
            successVc.rechargeSuccessType = PhoneCardRechargeSuccess;
            successVc.isOrderPay = self.isOrderPay;
            [self.navigationController pushViewController:successVc animated:YES];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"rechargeBtnClick - error = %@",error);
    }];
}

@end
