//
//  YZSmartBetSettingView.m
//  ez
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height
#import "YZSmartBetSettingView.h"
#import "YZValidateTool.h"

@interface YZSmartBetSettingView()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *typeBtns;
@property (nonatomic, weak) UITextField *multipleTextField;
@property (nonatomic, weak) UITextField *termTextField;
@property (nonatomic, weak) UIImageView *backImageView1;
@property (nonatomic, weak) UIImageView *backImageView2;
@property (nonatomic, weak) UIButton *selTypeBtn;
@property (nonatomic, weak) UIButton *winStopBtn;
@property (nonatomic, weak) UITextField *textField1;
@property (nonatomic, weak) UITextField *textField2;
@property (nonatomic, weak) UITextField *textField3;
@property (nonatomic, weak) UITextField *textField4;
@property (nonatomic, weak) UITextField *textField5;

@end

@implementation YZSmartBetSettingView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupChilds];
    }
    return self;
}
- (void)setTermCount:(int)termCount
{
    self.termTextField.text = [NSString stringWithFormat:@"%d",termCount];
}
- (void)setMultipleNumber:(int)multipleNumber
{
    self.multipleTextField.text = [NSString stringWithFormat:@"%d",multipleNumber];
}
- (void)setWinStop:(BOOL)winStop
{
    self.winStopBtn.selected = winStop;
}
- (void)setType:(int)type
{
    for (UIButton *button in self.typeBtns) {
        if (button.tag == type) {
            button.selected = YES;
            self.selTypeBtn = button;
        }else
        {
            button.selected = NO;
        }
    }
}
- (void)setProfitArray:(NSArray *)profitArray
{
    for (int i = 0; i < profitArray.count; i++) {
        NSString * string = profitArray[i];
        if (i == 0) {
            self.textField1.text = string;
        }else if (i == 1)
        {
            self.textField2.text = string;
        }else if (i == 2)
        {
            self.textField3.text = string;
        }else if (i == 3)
        {
            self.textField4.text = string;
        }else if (i == 4)
        {
            self.textField5.text = string;
        }
    }
}
- (void)setupChilds{
    //设置追号方案
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, KWidth, 30)];
    titleLabel.text = @"设置追号方案";
    titleLabel.textColor = [UIColor redColor];
    titleLabel.font = [UIFont systemFontOfSize:13.0];
    titleLabel.textAlignment= NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    //第一个红色分割线
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(titleLabel.frame), KWidth - 10, 1)];
    line1.backgroundColor = [UIColor redColor];
    [self addSubview:line1];
    
    //基本设置
    UILabel *baseTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(line1.frame), 100, 30)];
    baseTitleLabel.text = @"基本设置";
    baseTitleLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:baseTitleLabel];
    
    //倍数按钮的背景view
    UIView *multipleBackView = [[UIView alloc] init];
    CGFloat multipleBackViewX = CGRectGetMinX(baseTitleLabel.frame);
    CGFloat multipleBackViewY = CGRectGetMaxY(baseTitleLabel.frame);
    CGFloat multipleBackViewW = KWidth - multipleBackViewX;
    CGFloat multipleBackViewH = 70;
    multipleBackView.frame =  CGRectMake(multipleBackViewX, multipleBackViewY, multipleBackViewW, multipleBackViewH);
    [self addSubview:multipleBackView];
    
    for(int i = 0;i < 2;i++)
    {
        //倍数输入框，期数输入框
        UITextField *multipleTextField = [[UITextField alloc] init];
        multipleTextField.delegate = self;
        if(i == 0)
        {
            self.termTextField = multipleTextField;
        }else
        {
            self.multipleTextField = multipleTextField;
        }
        multipleTextField.keyboardType = UIKeyboardTypeNumberPad;
        multipleTextField.placeholder = @"1";
        multipleTextField.text = @"1";
        multipleTextField.textAlignment = NSTextAlignmentCenter;
        multipleTextField.font = [UIFont systemFontOfSize:13.0];
        CGFloat multipleTextFieldW = 100;
        CGFloat multipleTextFieldH = 30;
        CGFloat multipleTextFieldX = 20;
        CGFloat multipleTextFieldY = 5 + i * (multipleTextFieldH + 5);
        //输入框下面插入一张背景图片
        UIImage *image = [UIImage resizedImageWithName:@"bet_minus_plus" left:0.5 top:0];
        UIImageView *backImageView = [[UIImageView alloc] initWithImage:image];
        if(i == 0){
            self.backImageView1 = backImageView;
        }else{
            self.backImageView2 = backImageView;
        }
        backImageView.userInteractionEnabled  = YES;
        backImageView.frame = CGRectMake(multipleTextFieldX, multipleTextFieldY, multipleTextFieldW, multipleTextFieldH);
        multipleTextField.frame = CGRectMake(0, 0, multipleTextFieldW, multipleTextFieldH);
        [multipleBackView addSubview:backImageView];
        [backImageView addSubview:multipleTextField];
        
        for(int j = 0;j < 2;j++)
        {
            //减小和增大按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = j;
            NSString *hiImageName = @"bet_minusBtn_pressed";
            if(j == 1)
            {
                hiImageName = @"bet_plusBtn_pressed";
            }
            [btn setBackgroundImage:[UIImage imageNamed:hiImageName] forState:UIControlStateHighlighted];
            CGFloat btnW = multipleTextFieldH;
            CGFloat btnH = multipleTextFieldH;
            CGFloat btnX = 0;
            if(j == 1)
            {
                btnX = multipleTextFieldW - btnW - 1;
            }
            btn.frame = CGRectMake(btnX, 0, btnW, btnH);
            [multipleTextField addSubview:btn];
            if(i == 0)//倍数的按钮
            {
                [btn addTarget:self action:@selector(termBtn:) forControlEvents:UIControlEventTouchUpInside];
            }else
            {//期数的按钮
                [btn addTarget:self action:@selector(multipleBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            //投注俩字
            UILabel *betLabel = [[UILabel alloc] init];
            betLabel.textColor = [UIColor grayColor];
            betLabel.font = [UIFont systemFontOfSize:13];
            NSString *text = @"";
            if(i == 0 && j == 0)
            {
                text = @"连续追号:";
            }else if(i == 0 && j == 1)
            {
                text = @"期 (2-999期)";
            }else if(i == 1 && j == 0)
            {
                text = @"起始倍数:";
            }else if(i == 1 && j == 1)
            {
                text = @"倍 (1-9999倍)";
            }
            betLabel.text = text;
            CGSize betLabelSize = [betLabel.text sizeWithFont:betLabel.font maxSize:CGSizeMake(multipleBackViewW, multipleBackViewH)];
            CGFloat betLabelW = betLabelSize.width;
            CGFloat betLabelH = betLabelSize.height;
            CGFloat betLabelX = 0;
            if(j == 1)
            {
                betLabelX = CGRectGetMaxX(backImageView.frame) + 2;
            }
            betLabel.frame = CGRectMake(betLabelX, 0, betLabelW, betLabelH);
            betLabel.center = CGPointMake(betLabel.center.x, backImageView.center.y);
            [multipleBackView addSubview:betLabel];
            if (j == 0) {
                backImageView.x = CGRectGetMaxX(betLabel.frame) + 2;
            }
        }
    }
    //盈利设置
    UILabel *profitTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(multipleBackView.frame), 100, 30)];
    profitTitleLabel.text = @"盈利设置";
    profitTitleLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:profitTitleLabel];
    
    //选择方式
    UIButton * lastBtn;
    for (int i = 0; i < 3; i++) {
        UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseBtn.frame = CGRectMake(8 * 2, CGRectGetMaxY(profitTitleLabel.frame) + 10 + 40 * i, 25, 25);
        chooseBtn.tag = i;
        if (i == self.type) {
            chooseBtn.selected = YES;
            self.selTypeBtn = chooseBtn;
        }else{
            chooseBtn.selected = NO;
        }
        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"xuanzhong_ball_green"] forState:UIControlStateSelected];
        [chooseBtn setBackgroundImage:[UIImage imageNamed:@"weixuanzhong_ball_green"] forState:UIControlStateNormal];
        [chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:chooseBtn];
        [self.typeBtns addObject:chooseBtn];
        lastBtn = chooseBtn;
    }
    
    //uilabel和uitextfeild混编
    //第一行
    UILabel * label11 = [[UILabel alloc]init];
    label11.text = @"全程盈利不低于";
    label11.textColor = [UIColor grayColor];
    label11.font = [UIFont systemFontOfSize:14.0];
    CGSize size11 = [label11.text sizeWithLabelFont:label11.font];
    label11.frame = CGRectMake(CGRectGetMaxX(lastBtn.frame) + 5, CGRectGetMaxY(profitTitleLabel.frame) + 10, size11.width, 25);
    [self addSubview:label11];
    
    UITextField * textField1 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label11.frame) + 2, label11.y, 35, 25)];
    self.textField1 = textField1;
    textField1.font = [UIFont systemFontOfSize:13.0];
    textField1.keyboardType = UIKeyboardTypeNumberPad;
    textField1.borderStyle = UITextBorderStyleRoundedRect;
    textField1.delegate = self;
    [self addSubview:textField1];
    
    UILabel * label12 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textField1.frame)+ 2, textField1.y, 30, 25)];
    label12.text = @"%";
    label12.textColor = [UIColor grayColor];
    label12.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:label12];
    
    //第二行
    UILabel * label21 = [[UILabel alloc]init];
    label21.text = @"前";
    label21.textColor = [UIColor grayColor];
    label21.font = [UIFont systemFontOfSize:13.0];
    CGSize size21 = [label21.text sizeWithLabelFont:label21.font];
    label21.frame = CGRectMake(CGRectGetMaxX(lastBtn.frame) + 5, CGRectGetMaxY(profitTitleLabel.frame) + 10 + 40, size21.width, 25);
    [self addSubview:label21];
    
    UITextField * textField2 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label21.frame) + 2, label21.y, 35, 25)];
    self.textField2 = textField2;
    textField2.font = [UIFont systemFontOfSize:13.0];
    textField2.keyboardType = UIKeyboardTypeNumberPad;
    textField2.borderStyle = UITextBorderStyleRoundedRect;
    textField2.delegate = self;
    [self addSubview:textField2];
    
    UILabel * label22 = [[UILabel alloc]init];
    label22.text = @"期盈利";
    label22.textColor = [UIColor grayColor];
    label22.font = [UIFont systemFontOfSize:14.0];
    CGSize size22 = [label22.text sizeWithLabelFont:label22.font];
    label22.frame = CGRectMake(CGRectGetMaxX(textField2.frame) + 2, label21.y, size22.width, 25);
    [self addSubview:label22];
    
    UITextField * textField3 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label22.frame) + 2, label21.y, 35, 25)];
    self.textField3 = textField3;
    textField3.font = [UIFont systemFontOfSize:13.0];
    textField3.keyboardType = UIKeyboardTypeNumberPad;
    textField3.borderStyle = UITextBorderStyleRoundedRect;
    textField3.delegate = self;
    [self addSubview:textField3];
    
    UILabel * label23 = [[UILabel alloc]init];
    label23.text = @"%之后盈利率";
    label23.textColor = [UIColor grayColor];
    label23.font = [UIFont systemFontOfSize:13.0];
    CGSize size23 = [label23.text sizeWithLabelFont:label23.font];
    label23.frame = CGRectMake(CGRectGetMaxX(textField3.frame) + 2, label21.y, size23.width, 25);
    [self addSubview:label23];
    
    UITextField * textField4 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label23.frame) + 2, label21.y, 35, 25)];
    self.textField4 = textField4;
    textField4.font = [UIFont systemFontOfSize:13.0];
    textField4.keyboardType = UIKeyboardTypeNumberPad;
    textField4.borderStyle = UITextBorderStyleRoundedRect;
    textField4.delegate = self;
    [self addSubview:textField4];
    
    UILabel * label24 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textField4.frame)+ 2, label21.y, 30, 25)];
    label24.text = @"%";
    label24.textColor = [UIColor grayColor];
    label24.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:label24];
    
    //第三行
    UILabel * label31 = [[UILabel alloc]init];
    label31.text = @"全程盈利不低于";
    label31.textColor = [UIColor grayColor];
    label31.font = [UIFont systemFontOfSize:13.0];
    CGSize size31 = [label31.text sizeWithLabelFont:label31.font];
    label31.frame = CGRectMake(CGRectGetMaxX(lastBtn.frame) + 5, CGRectGetMaxY(profitTitleLabel.frame) + 10 + 40 * 2, size31.width, 25);
    [self addSubview:label31];
    
    UITextField * textField5 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label31.frame) + 2, label31.y, 50, 25)];
    self.textField5 = textField5;
    textField5.font = [UIFont systemFontOfSize:13.0];
    textField5.keyboardType = UIKeyboardTypeNumberPad;
    textField5.borderStyle = UITextBorderStyleRoundedRect;
    textField5.delegate = self;
    [self addSubview:textField5];

    UILabel * label32 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textField5.frame)+ 2, label31.y, 30, 25)];
    label32.text = @"元";
    label32.textColor = [UIColor grayColor];
    label32.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:label32];
    
    //中奖后停追
    UIButton * winStopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.winStopBtn = winStopBtn;
    winStopBtn.frame = CGRectMake(8 * 2, CGRectGetMaxY(lastBtn.frame) + 15, 25, 25);
    winStopBtn.selected = YES;
    [winStopBtn setBackgroundImage:[UIImage imageNamed:@"xuanzhong_green"] forState:UIControlStateSelected];
    [winStopBtn setBackgroundImage:[UIImage imageNamed:@"weixuanzhong_green"] forState:UIControlStateNormal];
    [winStopBtn addTarget:self action:@selector(winStopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:winStopBtn];
    
    UILabel *winStopLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(winStopBtn.frame) + 5, winStopBtn.y, 100, winStopBtn.height)];
    winStopLabel.center = CGPointMake(winStopLabel.center.x, winStopBtn.center.y);
    winStopLabel.text = @"中奖后停追";
    winStopLabel.textColor = [UIColor grayColor];
    winStopLabel.font = [UIFont systemFontOfSize:13.0];
    [self addSubview:winStopLabel];
    //底部按钮
    //横线
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, KHeight - 43, KWidth, 1)];
    line2.backgroundColor = [UIColor redColor];
    [self addSubview:line2];
    //竖线
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(KWidth/2 - 0.5, CGRectGetMaxY(line2.frame), 1, KHeight - CGRectGetMaxY(line2.frame))];
    line3.backgroundColor = [UIColor redColor];
    [self addSubview:line3];
    //取消按钮
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, CGRectGetMinY(line3.frame), KWidth - CGRectGetMinX(line3.frame), line3.height);
    [cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    //确认按钮
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(CGRectGetMaxX(line3.frame), CGRectGetMinY(line3.frame), KWidth - CGRectGetMinX(line3.frame), line3.height);
    [confirmBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"生成方案" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
}
#pragma mark - 按钮点击
- (void)cancelBtnClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(SmartBetSettingViewCancelBtnClick)]) {
        [_delegate SmartBetSettingViewCancelBtnClick];
    }
}
- (void)confirmBtnClick
{
    int termNumber = [self.termTextField.text intValue];
    if (termNumber < 2) {
        [MBProgressHUD showError:@"智能追号至少要追两期哦"];
        return;
    }
    int multipleNumber = [self.multipleTextField.text intValue];
    int type = (int)self.selTypeBtn.tag;
    BOOL winStop = self.winStopBtn.selected;
    NSArray * profitArray = [NSArray arrayWithObjects:self.textField1.text,self.textField2.text,self.textField3.text,self.textField4.text,self.textField5.text,nil];
    if (_delegate && [_delegate respondsToSelector:@selector(SmartBetSettingViewConfirmBtnClickWithTermNumber:multipleNumber:type:profitArray:isWinStop:)]) {
        [_delegate SmartBetSettingViewConfirmBtnClickWithTermNumber:termNumber multipleNumber:multipleNumber type:type profitArray:profitArray isWinStop:winStop];
    }
}
- (void)multipleBtn:(UIButton *)btn
{
    int multiple = [self.multipleTextField.text intValue];
    if(btn.tag == 0 && multiple != 1)//是减小按钮
    {
        multiple--;
    }else if(btn.tag == 1 && multiple != 9999)//增大按钮
    {
        multiple++;
    }
    self.multipleTextField.text = [NSString stringWithFormat:@"%d",multiple];
}
- (void)termBtn:(UIButton *)btn
{
    int termCount = [self.termTextField.text intValue];
    if(btn.tag == 0 && termCount != 2)//是减小按钮
    {
        termCount--;
    }else if(btn.tag == 1 && termCount != 999)//增大按钮
    {
        termCount++;
    }
    self.termTextField.text = [NSString stringWithFormat:@"%d",termCount];
}
- (void)chooseBtnClick:(UIButton *)button
{
    if (button == self.selTypeBtn) {
        return;
    }
    button.selected = YES;
    self.selTypeBtn.selected = NO;
    self.selTypeBtn = button;
}
- (void)winStopBtnClick:(UIButton *)button
{
    button.selected = !button.selected;
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
    
    if (textField == self.multipleTextField && [self.multipleTextField.text intValue] == 0)
    {
        self.multipleTextField.text = @"1";
    }
    if(textField == self.multipleTextField && [self.multipleTextField.text intValue] > 9999)
    {
        self.multipleTextField.text = @"9999";
    }
    if (textField == self.termTextField && [self.termTextField.text intValue] == 0)
    {
        self.termTextField.text = @"1";
    }
    if(textField == self.termTextField && [self.termTextField.text intValue] > 999)
    {
        self.termTextField.text = @"999";
    }

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [YZValidateTool validateNumber:string];
}
- (NSMutableArray *)typeBtns
{
    if (_typeBtns == nil) {
        _typeBtns = [NSMutableArray array];
    }
    return _typeBtns;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
