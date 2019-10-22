//
//  YZBonusCardRechargeViewController.m
//  ez
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZBonusCardRechargeViewController.h"
#import "YZRechargeSuccessViewController.h"
#import "YZLoadHtmlFileController.h"

@interface YZBonusCardRechargeViewController ()

@property (nonatomic, weak) UIButton *rechargeBtn;//充值按钮
@property (nonatomic, weak) UITextField *cardIdTextField;//卡号输入框
@property (nonatomic, weak) UITextField *pwdTextField;//密码输入框

@end

@implementation YZBonusCardRechargeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"彩金卡充值";
    [self setupChilds];
}
- (void)setupChilds
{
    UIView * lastView;
    NSArray * titles = @[@"卡号",@"密码"];
    NSArray * placeholders = @[@"请输入卡号",@"请输入密码"];
    for (int i = 0; i < 2; i++) {
        CGFloat viewY = 10 + i * YZCellH;
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, viewY, screenWidth, YZCellH)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        lastView = view;
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        titleLabel.textColor = YZBlackTextColor;
        titleLabel.text = titles[i];
        CGSize size = [titleLabel.text sizeWithLabelFont:titleLabel.font];
        titleLabel.frame = CGRectMake(15, 0, size.width, YZCellH);
        [view addSubview:titleLabel];
        
        //textField
        UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame),0, screenWidth - CGRectGetMaxX(titleLabel.frame) - YZMargin, YZCellH)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        textField.textAlignment = NSTextAlignmentRight;
        textField.placeholder = placeholders[i];
        [self.view addSubview:textField];
        if (i == 0) {
            self.cardIdTextField = textField;
        }else if (i == 1)
        {
            self.pwdTextField = textField;
        }
        [view addSubview:textField];
        //分割线
        if (i != 1) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, YZCellH - 1, screenWidth, 1)];
            line.backgroundColor = YZWhiteLineColor;
            [view addSubview:line];
        }
    }
    //充值按钮
    UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rechargeBtn = rechargeBtn;
    rechargeBtn.frame = CGRectMake(0, CGRectGetMaxY(lastView.frame)+20, screenWidth, 40);
    [rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:YZGetFontSize(30)];
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
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString: @"温馨提示：\n1、使用彩金卡充值免手续费；\n2、使用彩金卡充值的金额不能提现"];
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
    if(self.cardIdTextField.text.length < 1)
    {
        [MBProgressHUD showError:@"请输入彩金卡卡号"];
        return;
    }else if (self.pwdTextField.text.length < 1)
    {
        [MBProgressHUD showError:@"请输入彩金卡密码"];
        return;
    }
    [MBProgressHUD showMessage:@"正在充值，客官请稍后" toView:self.view];
    NSDictionary *dict = @{
                           @"cmd":@(8031),
                           @"userId":UserId,
                           @"cardId":self.cardIdTextField.text,
                           @"password":self.pwdTextField.text
                           };

    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"rechargeBtnClick - json = %@",json);
        if(SUCCESS)
        {
            YZRechargeSuccessViewController *successVc = [[YZRechargeSuccessViewController alloc] init];
            successVc.rechargeSuccessType = BonusCardRechargeSuccess;
            successVc.isOrderPay = self.isOrderPay;
            [self.navigationController pushViewController:successVc animated:YES];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"rechargeBtnClick - error = %@",error);
    }];
}

@end
