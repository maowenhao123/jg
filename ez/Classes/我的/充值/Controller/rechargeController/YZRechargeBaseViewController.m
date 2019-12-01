//
//  YZRechargeBaseViewController.m
//  ez
//
//  Created by apple on 14-10-28.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZRechargeBaseViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZValidateTool.h"

@implementation YZRechargeBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    [self setupChilds];
}

- (void)setupChilds
{
    //输入框的背景view
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [UIColor whiteColor];
    backView.frame = CGRectMake(0, 10, screenWidth, YZCellH);
    [self.view addSubview:backView];
    
    //label
    UILabel *label = [[UILabel alloc] init];
    label.text = @"充值金额(元)";
    label.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    label.textColor = YZBlackTextColor;
    CGSize labelSize = [label.text sizeWithLabelFont:label.font];
    label.frame = CGRectMake(YZMargin, 0, labelSize.width, YZCellH);
    [backView addSubview:label];
    
    //textfield
    YZDecimalTextField *textfield = [[YZDecimalTextField alloc] init];
    self.amountTextTield = textfield;
    if (!supportPenny) {
        textfield.keyboardType = UIKeyboardTypeNumberPad;
    }
    textfield.textColor = YZBlackTextColor;
    textfield.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    textfield.placeholder = @"请输入充值金额";
    textfield.textAlignment = NSTextAlignmentRight;
    CGFloat textfieldX = CGRectGetMaxX(label.frame)+5;
    CGFloat textfieldW = screenWidth - textfieldX - YZMargin;
    textfield.frame = CGRectMake(textfieldX, 0, textfieldW, YZCellH);
    [backView addSubview:textfield];
    
    //立即充值按钮
    YZBottomButton * rechargeBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    rechargeBtn.y = CGRectGetMaxY(backView.frame) + 30;
    [rechargeBtn setTitle:@"立即充值" forState:UIControlStateNormal];
    [rechargeBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rechargeBtn];
    
    //温馨提示
    UILabel *tishiLabel = [[UILabel alloc] init];
    self.tishiLabel = tishiLabel;
    tishiLabel.numberOfLines = 0;
    if (!YZStringIsEmpty(self.intro))
    {
        NSDictionary *optoins = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
        NSData *data = [self.intro dataUsingEncoding:NSUnicodeStringEncoding];
        NSError * error;
        NSAttributedString *attributeString = [[NSAttributedString alloc] initWithData:data options:optoins documentAttributes:nil error:&error];
        if (!error) {
            tishiLabel.attributedText = attributeString;
        }
    }else
    {
        tishiLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        tishiLabel.textColor = YZGrayTextColor;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n1、免手续费，快捷安全\n2、日充值限额不超过1万元\n3、支持信用卡借记卡充值\n4、充值金额不可提现，奖金可以提现\n5、客服热线：400-700-1898"];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(70, 12)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
        tishiLabel.attributedText = attStr;
    }
    CGSize tishiSize = [tishiLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - 2 * rechargeBtn.x, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat tishiY = CGRectGetMaxY(rechargeBtn.frame) + 10;
    CGFloat tishiW = screenWidth - 2 * rechargeBtn.x;
    tishiLabel.frame = CGRectMake(rechargeBtn.x, tishiY, tishiW, tishiSize.height);
    [self.view addSubview:tishiLabel];
    
    //充值说明
    if (!YZStringIsEmpty(self.detailUrl)) {
        UIButton * rechargeExplainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rechargeExplainBtn = rechargeExplainBtn;
        [rechargeExplainBtn setTitle:@"充值说明（点击查看）" forState:UIControlStateNormal];
        [rechargeExplainBtn setTitleColor:YZBaseColor forState:UIControlStateNormal];
        rechargeExplainBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [rechargeExplainBtn addTarget:self action:@selector(rechargeExplainBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        CGSize rechargeExplainBtnSize = [rechargeExplainBtn.currentTitle sizeWithLabelFont:rechargeExplainBtn.titleLabel.font];
        rechargeExplainBtn.frame = CGRectMake(tishiLabel.x, CGRectGetMaxY(tishiLabel.frame) + 10, rechargeExplainBtnSize.width, rechargeExplainBtnSize.height);
        [self.view addSubview:rechargeExplainBtn];
    }
}

- (void)btnClick
{
    [self.view endEditing:YES];
    
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
    //子类重写
    [self rechargeBtnClick];
}
//子类重写
- (void)rechargeBtnClick
{
    
    
}

- (void)rechargeExplainBtnDidClick
{
    YZLoadHtmlFileController * updataActivityVC = [[YZLoadHtmlFileController alloc] initWithWeb:self.detailUrl];
    [self.navigationController pushViewController:updataActivityVC animated:YES];
}

@end
