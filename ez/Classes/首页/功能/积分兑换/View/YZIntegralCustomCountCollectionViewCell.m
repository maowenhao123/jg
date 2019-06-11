//
//  YZIntegralCustomCountCollectionViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/2/5.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZIntegralCustomCountCollectionViewCell.h"

@interface YZIntegralCustomCountCollectionViewCell ()<UITextFieldDelegate>

@end

@implementation YZIntegralCustomCountCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChilds];
    }
    return self;
}

- (void)setupChilds
{
    //输入兑换张数
    UITextField *countTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, screenWidth - 2 * 15, 36)];
    self.countTextField = countTextField;
    countTextField.backgroundColor = YZWhiteLineColor;
    countTextField.placeholder = @"输入兑换张数";
    countTextField.textColor = YZBlackTextColor;
    countTextField.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    countTextField.textAlignment = NSTextAlignmentCenter;
    countTextField.keyboardType = UIKeyboardTypeNumberPad;
    countTextField.borderStyle = UITextBorderStyleNone;
    countTextField.delegate = self;
    countTextField.layer.masksToBounds = YES;
    countTextField.layer.cornerRadius = 3;
    [self addSubview:countTextField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(integralCustomCount:)]) {
        [_delegate integralCustomCount:[textField.text integerValue]];
    }
}

@end
