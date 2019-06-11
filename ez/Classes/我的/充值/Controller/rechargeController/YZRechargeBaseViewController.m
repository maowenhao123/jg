//
//  YZRechargeBaseViewController.m
//  ez
//
//  Created by apple on 14-10-28.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZRechargeBaseViewController.h"
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
    UILabel *tishi = [[UILabel alloc] init];
    self.tishiLabel = tishi;
    tishi.numberOfLines = 0;
    tishi.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    tishi.textColor = YZGrayTextColor;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"温馨提示：\n1、免手续费，快捷安全\n2、日充值限额不超过1万元\n3、支持信用卡借记卡充值\n4、充值金额不可提现，奖金可以提现\n5、客服热线：400-700-1898"];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(70, 12)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
    tishi.attributedText = attStr;
    CGSize tishiSize = [tishi.attributedText boundingRectWithSize:CGSizeMake(screenWidth - 2 * rechargeBtn.x, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat tishiY = CGRectGetMaxY(rechargeBtn.frame) + 10;
    CGFloat tishiW = screenWidth - 2 * rechargeBtn.x;
    tishi.frame = CGRectMake(rechargeBtn.x, tishiY, tishiW, tishiSize.height);
    [self.view addSubview:tishi];
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


@end
