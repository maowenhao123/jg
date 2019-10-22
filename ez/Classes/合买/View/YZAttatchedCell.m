//
//  YZAttatchedCell.m
//  ez
//
//  Created by apple on 15/3/11.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import "YZAttatchedCell.h"
#import "YZValidateTool.h"

@interface YZAttatchedCell ()<UITextFieldDelegate>

@property (nonatomic, weak) UIView *bgView;
@property (nonatomic, weak) UIView *separator;
@property (nonatomic, weak) UIButton *allBuyBtn;
@property (nonatomic, weak) UILabel *moneyLabel;
@property (nonatomic, weak) UIButton *quickPayBtn;

@end

@implementation YZAttatchedCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"attatchedCell";
    YZAttatchedCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell)
    {
        cell = [[YZAttatchedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = YZColor(243, 243, 243, 1);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    //gbview
    UIView *bgView = [[UIView alloc] init];
    self.bgView = bgView;
    bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    bgView.layer.borderWidth = 0.5f;
    [self.contentView addSubview:bgView];
    
    UITextField *moneyTd = [[UITextField alloc] init];
    moneyTd.delegate = self;
    self.moneyTd = moneyTd;
    moneyTd.textColor = YZBlackTextColor;
    moneyTd.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    moneyTd.placeholder = @" 输入购买";
    moneyTd.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    moneyTd.returnKeyType = UIReturnKeyDone;
    [bgView addSubview:moneyTd];
    
    UIView *separator = [[UIView alloc] init];
    self.separator = separator;
    separator.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:separator];
    
    UIButton *allBuyBtn = [[UIButton alloc] init];
    self.allBuyBtn = allBuyBtn;
    [allBuyBtn setTitle:@"全包" forState:UIControlStateNormal];
    [allBuyBtn setTitleColor:YZBaseColor forState:UIControlStateNormal];
    allBuyBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [allBuyBtn addTarget:self action:@selector(allBuyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:allBuyBtn];
    
    UILabel *moneyLabel = [[UILabel alloc] init];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    self.moneyLabel = moneyLabel;
    moneyLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [self setmoneyLabelTextWithMoney:0];
    [self.contentView addSubview:moneyLabel];
    
    YZBottomButton *quickPayBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.quickPayBtn = quickPayBtn;
    [quickPayBtn setTitle:@"马上付款" forState:UIControlStateNormal];
    quickPayBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [quickPayBtn addTarget:self action:@selector(quickPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:quickPayBtn];
    
    //监听输入框
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moneyTextFieldTextDidChange) name:UITextFieldTextDidChangeNotification object:self.moneyTd];
}
- (void)moneyTextFieldTextDidChange
{
    [self setmoneyLabelTextWithMoney:[self.moneyTd.text integerValue]];
}
- (void)layoutSubviews
{
    CGFloat padding = 5;
    CGFloat bgViewX = padding;
    CGFloat bgViewY = padding;
    CGFloat bgViewH = attatchedCellH - 2 * bgViewX;
    
    //moneyTd、separator、allBuyBtn
    CGFloat moneyTdW = 70 - 2;
    CGFloat moneyTdY = 0;
    self.moneyTd.frame = CGRectMake(2, moneyTdY, moneyTdW, bgViewH - moneyTdY);
    CGFloat separatorY = 3.0f;
    self.separator.frame = CGRectMake(CGRectGetMaxX(self.moneyTd.frame), separatorY, 0.5f, bgViewH - 2 * separatorY);
    self.allBuyBtn.frame = CGRectMake(CGRectGetMaxX(self.separator.frame), 0, 50, bgViewH);
    
    CGFloat bgViewW = CGRectGetMaxX(self.allBuyBtn.frame);
    self.bgView.frame = CGRectMake(bgViewX, bgViewY, bgViewW, bgViewH);
    
    CGFloat quickPayBtnW = 65;
    CGFloat quickPayBtnH = 30;
    CGFloat quickPayBtnX = self.width - quickPayBtnW - padding * 2;
    CGFloat quickPayBtnY = (self.height - quickPayBtnH) / 2;
    self.quickPayBtn.frame = CGRectMake(quickPayBtnX, quickPayBtnY, quickPayBtnW, quickPayBtnH);
    
    CGFloat moneyLabelW = CGRectGetMinX(self.quickPayBtn.frame) - CGRectGetMaxX(self.bgView.frame);
    self.moneyLabel.frame = CGRectMake(CGRectGetMaxX(self.bgView.frame), padding, moneyLabelW, bgViewH);
}
#pragma  mark - 全包按钮点击
- (void)allBuyBtnClick
{
    NSInteger money = [_statusFrame.status.surplusMoney integerValue] / 100;
    self.moneyTd.text = [NSString stringWithFormat:@"%ld",(long)money];
    [self setmoneyLabelTextWithMoney:money];
}
- (void)setStatusFrame:(YZUnionBuyStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    self.moneyTd.text = @"";
    [self setmoneyLabelTextWithMoney:0];
}
- (void)setmoneyLabelTextWithMoney:(NSInteger)money
{
    NSString *moneyLabelText = [NSString stringWithFormat:@"共 %ld 元",(long)money];
    NSDictionary *attDict = @{NSForegroundColorAttributeName : YZRedTextColor};
    self.moneyLabel.attributedText = [moneyLabelText attributedStringWithAttributs:attDict firstString:@"共" secondString:@"元"];
}
#pragma  mark - 快速付款按钮点击
- (void)quickPayBtnClick
{
    if([self.delegate respondsToSelector:@selector(attatchedCellDidClickQuickPayBtnWithCell:)])
    {
        [self.delegate attatchedCellDidClickQuickPayBtnWithCell:self];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSInteger maxMoney =  [_statusFrame.status.surplusMoney integerValue] / 100;
    if(maxMoney == 0)
    {
        [MBProgressHUD showError:@"该订单已认购满员"];
        return NO;
    }
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([textField.text intValue] == 0 && [string isEqualToString:@"0"])
        return NO;
    if([YZValidateTool validateNumber:string])
    {
        NSString *allStr = [NSString stringWithFormat:@"%@%@",textField.text,string];
        NSInteger maxMoney =  [_statusFrame.status.surplusMoney integerValue] / 100;
        if([allStr integerValue] > maxMoney)
        {
            textField.text = [NSString stringWithFormat:@"%@",@(maxMoney) > 0 ? @(maxMoney) : @""];
            [self setmoneyLabelTextWithMoney:maxMoney];
            return NO;
        }else
        {
            return YES;
        }
    }else
    {
        return NO;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.moneyTd];
}
@end
