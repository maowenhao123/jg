//
//  YZChooseBirthdayTableViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/7/16.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZChooseBirthdayTableViewCell.h"
#import "YZTextField.h"

@interface YZChooseBirthdayTableViewCell ()<UITextFieldDelegate>

@property (nonatomic, weak) UIView *dateView;
@property (nonatomic, weak) YZTextField *yearTF;
@property (nonatomic, weak) YZTextField *monthTF;
@property (nonatomic, weak) YZTextField *dayTF;

@end

@implementation YZChooseBirthdayTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ChooseBirthdayTableViewCellId";
    YZChooseBirthdayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZChooseBirthdayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    UIView * dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 0, 30)];
    self.dateView = dateView;
    [self addSubview:dateView];
    
    //年月日
    NSArray * titles = @[@"年", @"月", @"日"];
    UIView * lastView;
    for (int i = 0; i < titles.count; i++) {
        YZTextField * textField = [[YZTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lastView.frame), 0, 40, 30)];
        if (i == 0) {
            self.yearTF = textField;
            textField.width = 65;
            textField.maxLength = 4;
        }else if (i == 1)
        {
            self.monthTF = textField;
            textField.maxLength = 2;
        }else if (i == 2)
        {
            self.dayTF = textField;
            textField.maxLength = 2;
        }
        textField.textColor = YZMDBlueColor;
        textField.tintColor = YZMDBlueColor;
        textField.font = [UIFont boldSystemFontOfSize:YZGetFontSize(34)];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.delegate = self;
        [dateView addSubview:textField];
        lastView = textField;
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(textField.x, CGRectGetMaxY(textField.frame), textField.width, 1)];
        line.backgroundColor = YZMDBlueColor;
        [dateView addSubview:line];
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lastView.frame), 0, 30, 30)];
        label.text = titles[i];
        label.textColor = RGBACOLOR(196, 165, 134, 1);
        label.font = [UIFont systemFontOfSize:YZGetFontSize(34)];
        label.textAlignment = NSTextAlignmentCenter;
        [dateView addSubview:label];
        lastView = label;
    }
    dateView.width = CGRectGetMaxX(lastView.frame);
    dateView.centerX = (screenWidth - 40) / 2;
    
    //添加
    UIButton * addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addButton = addButton;
    addButton.frame = CGRectMake(0, CGRectGetMaxY(dateView.frame) + 10, screenWidth - 40, 30);
    [addButton setTitle:@"TA的生日" forState:UIControlStateNormal];
    [addButton setTitleColor:RGBACOLOR(196, 165, 134, 1) forState:UIControlStateNormal];
    [addButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    addButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(34)];
    [addButton addTarget:self action:@selector(addButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addButton];
}

- (void)addButtonDidClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(chooseBirthdayTableViewCellAddBirthday:)]) {
        [_delegate chooseBirthdayTableViewCellAddBirthday:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.yearTF) {
        self.dateComponents.year = [textField.text integerValue];
    }else if (textField == self.monthTF)
    {
        self.dateComponents.month = [textField.text integerValue];
    }else if (textField == self.dayTF)
    {
        self.dateComponents.day = [textField.text integerValue];
    }
}

- (void)setDateComponents:(NSDateComponents *)dateComponents
{
    _dateComponents = dateComponents;
    
    if (_dateComponents.year != 0) {
        self.yearTF.text = [NSString stringWithFormat:@"%ld", _dateComponents.year];
    }
    if (_dateComponents.month != 0) {
        self.monthTF.text = [NSString stringWithFormat:@"%ld", _dateComponents.month];
    }
    if (_dateComponents.day != 0) {
        self.dayTF.text = [NSString stringWithFormat:@"%ld", _dateComponents.day];
    }
}

@end
