//
//  YZUnionBuyDetaiBottomView.m
//  ez
//
//  Created by 毛文豪 on 2019/5/13.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZUnionBuyDetaiBottomView.h"
#import "YZValidateTool.h"

@interface YZUnionBuyDetaiBottomView ()<UITextFieldDelegate>

@property (nonatomic, weak) UILabel *surplusMoneyLabel;//剩余money的label
@property (nonatomic, weak) UILabel *ratioLabel;//占用比例

@end

@implementation YZUnionBuyDetaiBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        //阴影
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shadowOpacity = 1;
        
        [self setupChilds];
    }
    return self;
}

- (void)setupChilds
{
    UIFont *unionFont = [UIFont systemFontOfSize:YZGetFontSize(28)];
    //剩余moneylabel
    UILabel *surplusMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 35)];
    self.surplusMoneyLabel = surplusMoneyLabel;
    surplusMoneyLabel.text = @"剩余0元";
    surplusMoneyLabel.textColor = YZBlackTextColor;
    surplusMoneyLabel.font = unionFont;
    surplusMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:surplusMoneyLabel];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 35, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [self addSubview:line];
    
    //确认按钮
    YZBottomButton *confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    CGFloat confirmBtnH = 30;
    CGFloat confirmBtnW = 75;
    confirmBtn.frame = CGRectMake(screenWidth - confirmBtnW - 15, 35 + (45 - confirmBtnH) / 2, confirmBtnW, confirmBtnH);
    [confirmBtn setTitle:@"付款" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    
    //调节大小view
    UILabel *lastLabel;
    for(NSUInteger i = 0;i < 2;i ++)
    {
        //购、元
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = unionFont;
        label.textColor = YZBlackTextColor;
        label.font = unionFont;
        [self addSubview:label];
        
        CGFloat multipleTextFieldW = 90;
        CGFloat multipleTextFieldH = 25;
        if(i == 0)
        {
            label.text = @"购";
            CGSize labelSize = [label.text sizeWithLabelFont:label.font];
            label.frame = CGRectMake(YZMargin, 35, labelSize.width, 45);
            lastLabel = label;
            //倍数输入框，期数输入框
            UITextField *moneyTd = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 7, 35 + (45 - multipleTextFieldH) / 2, multipleTextFieldW, multipleTextFieldH)];
            self.moneyTd = moneyTd;
            moneyTd.delegate = self;
            moneyTd.placeholder = @"1";
            moneyTd.text = @"1";
            moneyTd.textColor = YZBlackTextColor;
            moneyTd.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
            moneyTd.textAlignment = NSTextAlignmentCenter;
            moneyTd.keyboardType = UIKeyboardTypeNumberPad;
            moneyTd.layer.masksToBounds = YES;
            moneyTd.layer.cornerRadius = 2;
            moneyTd.layer.borderColor = YZColor(213, 213, 213, 1).CGColor;
            moneyTd.layer.borderWidth = 1;
            [self addSubview:moneyTd];
            
            for(NSUInteger j = 0;j < 2;j ++)
            {
                //减小和增大按钮
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.tag = j;
                CGFloat btnWH = multipleTextFieldH;
                CGFloat btnX = 0;
                if(j == 1)
                {
                    btnX = multipleTextFieldW - btnWH - 1;
                }
                btn.frame = CGRectMake(btnX, 0, btnWH, btnWH);
                NSString *imageName = @"bet_subtract_icon";
                if(j == 1)
                {
                    imageName = @"bet_add_icon";
                }
                [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage ImageFromColor:YZColor(238, 238, 238, 1) WithRect:btn.bounds] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage ImageFromColor:YZGrayTextColor WithRect:btn.bounds] forState:UIControlStateSelected];
                [btn addTarget:self action:@selector(plusMoneyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [moneyTd addSubview:btn];
            }
        }else
        {
            label.text = @"元";
            label.frame = lastLabel.frame;
            label.x = CGRectGetMaxX(lastLabel.frame) + multipleTextFieldW + 2 * 7;
            //占用比例
            UILabel *ratioLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 35, confirmBtn.x - CGRectGetMaxX(label.frame), 45)];
            self.ratioLabel = ratioLabel;
            ratioLabel.font = unionFont;
            ratioLabel.textColor = YZBlackTextColor;
            [self addSubview:ratioLabel];
        }
    }
    // 监听textField文字改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moneyTdTextDidChange) name:UITextFieldTextDidChangeNotification object:self.moneyTd];
}

- (void)setUnionBuyStatus:(YZUnionBuyStatus *)unionBuyStatus
{
    _unionBuyStatus = unionBuyStatus;
    
    self.surplusMoneyLabel.text = [NSString stringWithFormat:@"剩余%ld元",(long)[_unionBuyStatus.surplusMoney integerValue] / 100];
    
    float amount = [_unionBuyStatus.totalAmount floatValue] / 100;
    float ratio = ((float)[self.moneyTd.text integerValue] / amount) * 100;
    NSString *ratioStr = [NSString stringWithFormat:@"（占%0.1f%%）",ratio];
    NSMutableAttributedString * ratioAttStr = [[NSMutableAttributedString alloc] initWithString:ratioStr];
    NSRange range1 = [ratioStr rangeOfString:@"占"];
    [ratioAttStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(range1.location + 1, ratioStr.length - range1.location - 2)];
    self.ratioLabel.attributedText = ratioAttStr;
}

- (void)confirmBtnClick
{
    [self endEditing:YES];
    
    if(_delegate && [_delegate respondsToSelector:@selector(bottomViewConfirmBtnClick)])
    {
        [_delegate bottomViewConfirmBtnClick];
    }
}

//点击了减小和增加钱的按钮
- (void)plusMoneyBtnClick:(UIButton *)btn
{
    NSInteger multiple = [self.moneyTd.text integerValue];
    if(btn.tag == 0 && multiple != 1)//是减小按钮
    {
        multiple--;
    }else if(btn.tag == 1 && multiple != [self.unionBuyStatus.surplusMoney integerValue] / 100)//增大按钮
    {
        multiple++;
    }
    self.moneyTd.text = [NSString stringWithFormat:@"%ld",(long)multiple];
    [self moneyTdTextDidChange];
}

- (void)moneyTdTextDidChange
{
    [self setRatioLabelWithMoney:[self.moneyTd.text integerValue]];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField.text intValue] == 0 && [string isEqualToString:@"0"]) return NO;
    if([YZValidateTool validateNumber:string])
    {
        NSString *allStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
        NSInteger maxMoney =  [self.unionBuyStatus.surplusMoney integerValue] / 100;
        if([allStr integerValue] > maxMoney)
        {
            textField.text = [NSString stringWithFormat:@"%ld",(long)maxMoney];
            [self setRatioLabelWithMoney:maxMoney];
            return NO;
        }
        return YES;
    }
    return NO;
}

- (void)setRatioLabelWithMoney:(NSInteger)money
{
    float amount = [self.unionBuyStatus.totalAmount floatValue] / 100;
    float ratio = ((float)money / amount) * 100;
    NSString *ratioStr = [NSString stringWithFormat:@"（占%0.1f%%）",ratio];
    NSMutableAttributedString * ratioAttStr = [[NSMutableAttributedString alloc] initWithString:ratioStr];
    NSRange range1 = [ratioStr rangeOfString:@"占"];
    [ratioAttStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(range1.location + 1, ratioStr.length - range1.location - 2)];
    self.ratioLabel.attributedText = ratioAttStr;
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.moneyTd];
}

@end
