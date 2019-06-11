//
//  YZChoosePhoneTableViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/7/16.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZChoosePhoneTableViewCell.h"
#import "YZTextField.h"

@interface YZChoosePhoneTableViewCell ()<UITextFieldDelegate>

@property (nonatomic, weak) YZTextField *phoneTF;

@end

@implementation YZChoosePhoneTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ChoosePhoneTableViewCellId";
    YZChoosePhoneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZChoosePhoneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = RGBACOLOR(254, 253, 250, 1);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    CGFloat phoneTFW = 180;
    YZTextField * phoneTF = [[YZTextField alloc] initWithFrame:CGRectMake((screenWidth - 40 - phoneTFW) / 2, 20, phoneTFW, 30)];
    self.phoneTF = phoneTF;
    phoneTF.textColor = YZMDBlueColor;
    phoneTF.tintColor = YZMDBlueColor;
    phoneTF.font = [UIFont boldSystemFontOfSize:YZGetFontSize(34)];
    phoneTF.textAlignment = NSTextAlignmentCenter;
    phoneTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneTF.maxLength = 11;
    phoneTF.delegate = self;
    [self addSubview:phoneTF];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(phoneTF.x, CGRectGetMaxY(phoneTF.frame), phoneTF.width, 1)];
    line.backgroundColor = YZMDBlueColor;
    [self addSubview:line];
    
    //添加
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton = addButton;
    addButton.frame = CGRectMake(0, CGRectGetMaxY(line.frame) + 10, screenWidth - 40, 30);
    [addButton setTitle:@"TA的手机号码" forState:UIControlStateNormal];
    [addButton setTitleColor:RGBACOLOR(196, 165, 134, 1) forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    addButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(34)];
    [addButton addTarget:self action:@selector(addButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addButton];
}

- (void)addButtonDidClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(choosePhoneTableViewCellAddPhone:)]) {
        [_delegate choosePhoneTableViewCellAddPhone:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector:@selector(choosePhoneTableViewCell:phoneDidChange:)]) {
        [_delegate choosePhoneTableViewCell:self phoneDidChange:textField.text];
    }
}

- (void)setPhone:(NSString *)phone
{
    _phone = phone;
    
    self.phoneTF.text = _phone;
}


@end
