//
//  YZAddBankCardViewController.m
//  ez
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZAddBankCardViewController.h"
#import "YZBottomPickerView.h"
#import "YZValidateTool.h"

@interface YZAddBankCardViewController ()
{
    NSInteger _index;
}
@property (nonatomic, weak) UITextField *bankNameTF;
@property (nonatomic, weak) UITextField *bankNumberCardTF;
@property (nonatomic, weak) UITextField *bankNumberCardValidationTF;
@property (nonatomic, weak) UITextField *nameTF;
@property (nonatomic, weak) UIButton *confirmBtn;

@end

@implementation YZAddBankCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加银行卡";
    self.view.backgroundColor = YZBackgroundColor;
    [self setupChilds];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.bankNameTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.bankNumberCardTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.bankNumberCardValidationTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.nameTF];
}
- (void)setupChilds
{
    NSArray * titles = @[@"开户银行",@"银行卡号",@"确认卡号",@"持卡人姓名"];
    NSArray * placeholders = @[@"请选择开户银行",@"不支持信用卡",@"请再次输入银行卡号",@"持请输入持卡人姓名"];
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, screenWidth, YZCellH * placeholders.count)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    for (int i = 0; i < 4; i++) {
        CGFloat viewY = i * YZCellH;
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        titleLabel.textColor = YZBlackTextColor;
        titleLabel.text = titles[i];
        CGSize size = [titleLabel.text sizeWithLabelFont:titleLabel.font];
        titleLabel.frame = CGRectMake(YZMargin, viewY, size.width, YZCellH);
        [backView addSubview:titleLabel];
        
        //textField
        UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame),viewY, screenWidth - CGRectGetMaxX(titleLabel.frame) - YZMargin, YZCellH)];
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        textField.textColor = YZBlackTextColor;
        textField.textAlignment = NSTextAlignmentRight;
        textField.placeholder = placeholders[i];
        if (i == 0) {
            self.bankNameTF = textField;
            textField.width = textField.width - 8 - 5;
            textField.userInteractionEnabled = NO;
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = textField.frame;
            [btn addTarget:self action:@selector(selectPickerView:) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:btn];
            //accessory
            CGFloat accessoryW = 8;
            CGFloat accessoryH = 11;
            UIImageView * accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - YZMargin - accessoryW, (YZCellH - accessoryH) / 2, accessoryW, accessoryH)];
            accessoryImageView.image = [UIImage imageNamed:@"accessory_dray"];
            [backView addSubview:accessoryImageView];
        }else if (i == 1)
        {
            self.bankNumberCardTF = textField;
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }else if (i == 2)
        {
            self.bankNumberCardValidationTF = textField;
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }else if (i == 3)
        {
            self.nameTF = textField;
            YZUser *user = [YZUserDefaultTool user];
            NSString * realname = user.userInfo.realname;
            if (realname.length > 1) {//实名认证后就自动读取实名认证的姓名
                textField.userInteractionEnabled = NO;
                for (int j = 0; j < user.userInfo.realname.length - 1; j++) {
                    realname = [realname stringByReplacingCharactersInRange:NSMakeRange(1 + j, 1) withString:@"*"];
                }
                textField.text = realname;
            }
        }
        [backView addSubview:textField];
        
        //分割线
        if (i != 0) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, YZCellH * i, screenWidth, 1)];
            line.backgroundColor = YZWhiteLineColor;
            [backView addSubview:line];
        }
    }
    
    //确认按钮
    YZBottomButton * confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn = confirmBtn;
    confirmBtn.y = CGRectGetMaxY(backView.frame) + 30;
    [confirmBtn setTitle:@"确认添加" forState:UIControlStateNormal];
    confirmBtn.enabled = NO;//默认不可选
    [confirmBtn addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
}
- (void)selectPickerView:(UIButton *)button
{
    [self.view endEditing:YES];//取消其他键盘
    NSArray * bankNames = @[@"中国建设银行",@"中国工商银行",@"中国农业银行",@"中国邮政储蓄银行",@"中国银行",@"交通银行",@"招商银行",@"中国光大银行",@"兴业银行",@"平安银行",@"中国民生银行",@"上海浦东发展银行",@"广东发展银行",@"华夏银行",@"中信银行"];
    //选择银行
    YZBottomPickerView * bankChooseView = [[YZBottomPickerView alloc]initWithArray:bankNames index:_index];
    bankChooseView.block = ^(NSInteger selectedIndex){
        _index = selectedIndex;
        self.bankNameTF.text = [NSString stringWithFormat:@"%@",bankNames[selectedIndex]];
    };
    [bankChooseView show];
}
#pragma mark - UITextFieldNotification
-(void)textFieldEditChanged:(NSNotification *)notification
{
    if (self.bankNameTF.text.length == 0) {//银行
        self.confirmBtn.enabled = NO;
        return;
    }
    if(self.bankNumberCardTF.text.length == 0)//银行卡号
    {
        self.confirmBtn.enabled = NO;
        return;
    }
    if(self.nameTF.text.length == 0)//银行卡号
    {
        self.confirmBtn.enabled = NO;
        return;
    }
    self.confirmBtn.enabled = YES;
}
- (void)confirmButtonClick
{
    if(![YZValidateTool validateCardNumber:self.bankNumberCardTF.text])//银行卡号
    {
        [MBProgressHUD showError:@"银行卡号格式错误"];
        return;
    }
    if (![self.bankNumberCardTF.text isEqualToString:self.bankNumberCardValidationTF.text]) {
        [MBProgressHUD showError:@"两次输入的银行卡号不一样"];
        return;
    }
    if(self.nameTF.userInteractionEnabled &&![YZValidateTool validateUserName:self.nameTF.text])//持卡人姓名
    {
        [MBProgressHUD showError:@"持卡人姓名格式错误"];
        return;
    }
    NSString * accountName = self.nameTF.text;
    if (!self.nameTF.userInteractionEnabled) {
        YZUser *user = [YZUserDefaultTool user];
        accountName = user.userInfo.realname;
    }
    NSDictionary *dict = @{
                           @"cmd":@(10721),
                           @"userId":UserId,
                           @"bank":self.bankNameTF.text,
                           @"accountNumber":self.bankNumberCardTF.text,
                           @"accountName":accountName,
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"%@",json);
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"银行卡添加成功"];
            if (_delegate && [_delegate respondsToSelector:@selector(addBankSuccess)]) {
                [_delegate addBankSuccess];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"账户error");
    }];
}
#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.bankNameTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.bankNumberCardTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.bankNumberCardValidationTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.nameTF];
}
@end
