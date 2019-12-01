//
//  YZFastBetView.m
//  ez
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height
#import "YZFastBetView.h"
#import "UIButton+YZ.h"

@interface YZFastBetView()<UITextFieldDelegate>

@property (nonatomic, assign) int amount;
@property (nonatomic, assign) int termNumber;
@property (nonatomic, assign) int multipleNumber;
@property (nonatomic, assign) BOOL winStop;
@property (nonatomic, weak) UIImageView *backImageView1;
@property (nonatomic, weak) UIImageView *backImageView2;
@property (nonatomic, weak) UITextField *multipleTF;
@property (nonatomic, weak) UITextField *termTF;
@property (nonatomic, weak) UIButton *winStopBtn;
@property (nonatomic, weak) UILabel *promptLabel;
@property (nonatomic, weak) UIButton *confirmBtn;
@end

@implementation YZFastBetView

- (instancetype)initWithFrame:(CGRect)frame amount:(int)amount termNumber:(int)termNumber multipleNumber:(int)multipleNumber winStop:(BOOL)winStop
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        _amount = amount;
        _termNumber = termNumber;
        _multipleNumber = multipleNumber;
        _winStop = winStop;
        [self setupChilds];
    }
    return self;
}
#pragma mark - 布局子控件
- (void)setupChilds
{
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, KWidth, 30)];
    titleLabel.text = @"快速投注";
    titleLabel.textColor = YZBlackTextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [self addSubview:titleLabel];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, KWidth, 1)];
    line1.backgroundColor = YZWhiteLineColor;
    [self addSubview:line1];
    
    for (int i = 0; i < 2; i++) {
        CGFloat labelH = 50;
        CGFloat labelW = 40;
        CGFloat textFeildW = 100;
        CGFloat labelX = (KWidth - textFeildW - labelW) / 2;
        CGFloat labelY = CGRectGetMaxY(line1.frame) + 10 + 50 * i;
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(labelX - 10, labelY,labelW, labelH)];
        if (i == 0) {
            label.text = @"倍数:";
        }else
        {
            label.text = @"期数:";
        }
        label.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        label.textColor = YZBlackTextColor;
        [self addSubview:label];
        
        UITextField * textFeild = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), labelY + 10, textFeildW, labelH - 2 *10)];
        textFeild.delegate = self;
        textFeild.text  = @"1";
        textFeild.placeholder = @"1";
        textFeild.textAlignment = NSTextAlignmentCenter;
        textFeild.borderStyle = UITextBorderStyleRoundedRect;
        textFeild.keyboardType = UIKeyboardTypeNumberPad;
        textFeild.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        textFeild.textColor = YZBlackTextColor;
        [self addSubview:textFeild];
        if (i == 0) {
            self.multipleTF = textFeild;
            textFeild.text = [NSString stringWithFormat:@"%d",_multipleNumber];
        }else
        {
            self.termTF = textFeild;
            textFeild.text = [NSString stringWithFormat:@"%d",_termNumber];
        }
    }
    
    //中奖后停追
    UIButton *winStopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [winStopBtn setImage:[UIImage imageNamed:@"rightcase"] forState:UIControlStateNormal];
    [winStopBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateSelected];
    winStopBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [winStopBtn.titleLabel setFont:[UIFont systemFontOfSize:YZGetFontSize(26)]];
    self.winStopBtn = winStopBtn;
    winStopBtn.selected = _winStop;
    [winStopBtn setTitle:@"中奖后停追" forState:UIControlStateNormal];
   
    [winStopBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    
    CGFloat winStopBtnX = (KWidth - 100) / 2;
    CGFloat winStopBtnY = CGRectGetMaxY(self.termTF.frame) + 15;
    CGFloat winStopBtnW = 100;
    winStopBtn.frame = CGRectMake(winStopBtnX, winStopBtnY, winStopBtnW, 20);
    [winStopBtn setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:5];
    [winStopBtn addTarget:self action:@selector(clickWinStopBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:winStopBtn];
    
    //提示
    UILabel * promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(winStopBtn.frame), KWidth - 20, 35)];
    self.promptLabel = promptLabel;
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    promptLabel.numberOfLines = 0;
    promptLabel.textColor = YZGrayTextColor;
    [self addSubview:promptLabel];
    
    //底部按钮
    //横线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, KHeight - 45, KWidth, 1)];
    lineView1.backgroundColor = YZWhiteLineColor;
    [self addSubview:lineView1];
    //竖线
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(KWidth/2 - 0.5, CGRectGetMaxY(lineView1.frame), 1, KHeight - CGRectGetMaxY(lineView1.frame))];
    lineView2.backgroundColor = YZWhiteLineColor;
    [self addSubview:lineView2];
    //取消按钮
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, CGRectGetMinY(lineView2.frame), KWidth - CGRectGetMinX(lineView2.frame), lineView2.height);
    [cancelBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    //确认按钮
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn = confirmBtn;
    confirmBtn.frame = CGRectMake(CGRectGetMaxX(lineView2.frame), CGRectGetMinY(lineView2.frame), KWidth - CGRectGetMinX(lineView2.frame), lineView2.height);
    [confirmBtn setTitleColor:YZBaseColor forState:UIControlStateNormal];
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    
    [self computeAmountMoney];
}
- (void)clickWinStopBtn:(UIButton *)button
{
    button.selected = !button.selected;
}
- (void)cancelBtnClick
{
    if (_delegate &&[_delegate respondsToSelector:@selector(FastBetViewCancelBtnClick)]) {
        [_delegate FastBetViewCancelBtnClick];
    }
}
- (void)confirmBtnClick:(UIButton *)button
{
    if ([button.titleLabel.text isEqualToString:@"确认"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(FastBetViewCancelBtnClickWithTermNumber:multipleNumber:winStop:)]) {
            [_delegate FastBetViewCancelBtnClickWithTermNumber:[self.termTF.text intValue] multipleNumber:[self.multipleTF.text intValue] winStop:self.winStopBtn.selected];
        }
    }else
    {
        if (_delegate && [_delegate respondsToSelector:@selector(FastBetViewgotoRecharge)]) {
            [_delegate FastBetViewgotoRecharge];
        }
    }
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = [textField.superview convertRect:textField.frame toView:self.superview];
    int offset = CGRectGetMaxY(frame) - (screenHeight - 216.0 - 42) + 10;//键盘高度216
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animateDuration];
    if(offset > 0)
    {
        self.center = CGPointMake(KEY_WINDOW.center.x, KEY_WINDOW.center.y - offset);
    }
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animateDuration];
    self.center = KEY_WINDOW.center;
    [UIView commitAnimations];
    
    if (textField == self.multipleTF && [self.multipleTF.text intValue] == 0)
    {
        self.multipleTF.text = @"1";
    }
    if(textField == self.multipleTF && [self.multipleTF.text intValue] > 9999)
    {
        self.multipleTF.text = @"9999";
    }
    if (textField == self.termTF && [self.termTF.text intValue] == 0)
    {
        self.termTF.text = @"1";
    }
    if(textField == self.termTF && [self.termTF.text intValue] > 999)
    {
        self.termTF.text = @"999";
    }
    [self computeAmountMoney];
}
#pragma mark - 计算注数和金额
- (void)computeAmountMoney
{
    int money = [self.termTF.text intValue] * [self.multipleTF.text intValue] * _amount;
    NSString *alertText = [YZTool getAlertViewTextWithAmountMoney:money];
    BOOL enoughMoney = [YZTool hasEnoughMoneyWithAmountMoney:money];
    self.promptLabel.text = alertText;
    if (enoughMoney) {
        [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    }else{
        [_confirmBtn setTitle:@"去充值" forState:UIControlStateNormal];
    }
}
@end
