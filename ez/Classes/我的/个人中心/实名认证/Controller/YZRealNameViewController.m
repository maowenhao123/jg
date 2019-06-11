//
//  YZRealNameViewController.m
//  ez
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZRealNameViewController.h"
#import "YZValidateTool.h"
#import "YZCardNoTextField.h"

@interface YZRealNameViewController ()

@property (nonatomic, weak) UITextField *nameTF;
@property (nonatomic, weak) UITextField *cardNoTF;
@property (nonatomic, weak) UIButton *confirmBtn;

@end

@implementation YZRealNameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"实名认证";
    [self setupChilds];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.nameTF];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.cardNoTF];
}
- (void)setupChilds
{
    UIView * lastView;
    NSArray * titles = @[@"真实姓名",@"身份证号"];
    for (int i = 0; i < 2; i++) {
        CGFloat viewY = 10 + i * YZCellH;
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, viewY, screenWidth, YZCellH)];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        lastView = view;
       
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        titleLabel.textColor = YZBlackTextColor;
        titleLabel.text = titles[i];
        CGSize size = [titleLabel.text sizeWithLabelFont:titleLabel.font];
        titleLabel.frame = CGRectMake(15, 0, size.width, YZCellH);
        [view addSubview:titleLabel];
        
        //textField
        UITextField * textField;
        if (i == 0) {
          textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame),0, screenWidth - CGRectGetMaxX(titleLabel.frame) - YZMargin, YZCellH)];
        }else
        {
           textField = [[YZCardNoTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame),0, screenWidth - CGRectGetMaxX(titleLabel.frame) - YZMargin, YZCellH)];
        }
        textField.borderStyle = UITextBorderStyleNone;
        textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        textField.textAlignment = NSTextAlignmentRight;
        textField.textColor = YZBlackTextColor;
        [self.view addSubview:textField];
        if (i == 0) {
            textField.placeholder = @"请输入真实姓名";
            self.nameTF = textField;
        }else if (i == 1)
        {
            textField.placeholder = @"请输入身份证号码";
            self.cardNoTF = textField;
        }
        [view addSubview:textField];
        //分割线
        if (i != 1) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, YZCellH - 1, screenWidth, 1)];
            line.backgroundColor = YZWhiteLineColor;
            [view addSubview:line];
        }
    }
    
    //温馨提示
    UILabel * footerLabel = [[UILabel alloc]init];
    footerLabel.numberOfLines = 0;
    NSString * footerStr =  @"温馨提示：\n1. 姓名和身份证信息提交后不可修改。\n2. 姓名必须与您的银行卡开户姓名保持一致。\n3.身份证号是大奖提款的唯一凭证，请认真填写。";
    NSMutableAttributedString * footerAttStr = [[NSMutableAttributedString alloc]initWithString:footerStr];
    [footerAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(0, footerAttStr.length)];
    [footerAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, footerAttStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [footerAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, footerAttStr.length)];
    footerLabel.attributedText = footerAttStr;
    CGSize size = [footerLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - YZMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    footerLabel.frame = CGRectMake(20, CGRectGetMaxY(lastView.frame) + 10, screenWidth - 20 * 2, size.height);
    [self.view addSubview:footerLabel];
    
    //判断是否已实名认证
    //如果没有实名认证才添加确认按钮
    YZUser *user = [YZUserDefaultTool user];
    if(!user.userInfo.realname || !user.userInfo.cardno)
    {
        YZBottomButton * confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
        self.confirmBtn = confirmBtn;
        confirmBtn.y = CGRectGetMaxY(footerLabel.frame) + 30;
        [confirmBtn setTitle:@"提交认证" forState:UIControlStateNormal];
        confirmBtn.enabled = NO;//默认不可选
        [confirmBtn addTarget:self action:@selector(confirmButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:confirmBtn];
        self.nameTF.textColor = YZBlackTextColor;
        self.cardNoTF.textColor = YZBlackTextColor;
    }else //已经实名认证了，就显示出来
    {
        NSMutableString *replaceString =  replaceString = [NSMutableString string];
        for(int i = 0;i < user.userInfo.realname.length-1;i++)
        {
            [replaceString appendString:@"*"];
        }
        self.nameTF.text = [user.userInfo.realname stringByReplacingCharactersInRange:NSMakeRange(1, user.userInfo.realname.length-1) withString:replaceString];
        NSString * cardNo = user.userInfo.cardno;
        if (cardNo.length == 18) {//是身份证号
            cardNo = [cardNo stringByReplacingCharactersInRange:NSMakeRange(3, 12) withString:@"************"];
        }
        self.cardNoTF.text = cardNo;
        self.nameTF.userInteractionEnabled = NO;
        self.cardNoTF.userInteractionEnabled = NO;
        self.nameTF.textColor = YZGrayTextColor;
        self.cardNoTF.textColor = YZGrayTextColor;
    }
}
#pragma mark - UITextFieldNotification
-(void)textFieldEditChanged:(NSNotification *)notification
{
    if(self.nameTF.text.length == 0)//姓名验证
    {
        self.confirmBtn.enabled = NO;
        return;
    }
    if(self.cardNoTF.text.length == 0)//身份证号验证
    {
        self.confirmBtn.enabled = NO;
        return;
    }else
    {
        self.confirmBtn.enabled = YES;
    }
}
#pragma mark - 保存
- (void)confirmButtonClick
{
    [self.view endEditing:YES];
    
    if(![YZValidateTool validateNickname:self.nameTF.text])
    {
        [MBProgressHUD showError:@"您输入的姓名不正确"];
        return;
    }
    if(![YZValidateTool validateIdentityCard:self.cardNoTF.text])//身份证号验证
    {
        [MBProgressHUD showError:@"您输入的身份证号码不正确"];
        return;
    }
    //弹框
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"确认信息" message:[NSString stringWithFormat:@"真实姓名：%@\n身份证号：%@",self.nameTF.text,self.cardNoTF.text] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self confirmMessage];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)confirmMessage
{
    NSDictionary *dict = @{
                           @"cmd":@(8007),
                           @"userId":UserId,
                           @"realname":self.nameTF.text,
                           @"cardNo":self.cardNoTF.text//身份证号码
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            YZUser *user = [YZUserDefaultTool user];
            YZUserInfo *userInfo = [YZUserInfo objectWithKeyValues:json[@"userInfo"]];
            user.userInfo.cardno = userInfo.cardno;
            user.userInfo.realname = userInfo.realname;
            [YZUserDefaultTool saveUser:user];
            [MBProgressHUD showSuccess:@"实名绑定成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"实名绑定失败"];
    }];
}
#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.nameTF];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:@"UITextFieldTextDidChangeNotification"
                                                 object:self.cardNoTF];
}

@end
