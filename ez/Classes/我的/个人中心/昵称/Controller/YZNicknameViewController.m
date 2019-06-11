//
//  YZNicknameViewController.m
//  ez
//
//  Created by 毛文豪 on 2017/8/21.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZNicknameViewController.h"

@interface YZNicknameViewController ()

@property (nonatomic,weak) UITextField * textField;

@end

@implementation YZNicknameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    if (self.isChange) {
        self.title = @"修改昵称";
    }else
    {
        self.title = @"用户昵称";
    }
    [self setupChilds];
}

- (void)setupChilds
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 9, screenWidth, YZCellH)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(YZMargin, 0, screenWidth - 2 * YZMargin, YZCellH)];
    self.textField = textField;
    textField.textColor = YZBlackTextColor;
    textField.borderStyle = UITextBorderStyleNone;
    textField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [self.view addSubview:textField];
    if (self.isChange) {
        YZUser *user = [YZUserDefaultTool user];
        textField.placeholder = user.nickName;
    }else
    {
        textField.placeholder = @"请输入昵称，2-10个汉字、字母组合";
    }
    [view addSubview:textField];
    
    //温馨提示
    UILabel * footerLabel = [[UILabel alloc]init];
    footerLabel.numberOfLines = 0;
    NSString * footerStr =  @"*发起或参与合买时会显示用户昵称";
    NSMutableAttributedString * footerAttStr = [[NSMutableAttributedString alloc]initWithString:footerStr];
    [footerAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(0, footerAttStr.length)];
    [footerAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, footerAttStr.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];
    [footerAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, footerAttStr.length)];
    footerLabel.attributedText = footerAttStr;
    CGSize footerLabelSize = [footerLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - YZMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    footerLabel.frame = CGRectMake(YZMargin, CGRectGetMaxY(view.frame) + 10, screenWidth - YZMargin * 2, footerLabelSize.height);
    [self.view addSubview:footerLabel];
    
    //确认按钮
    YZBottomButton * confirmButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    confirmButton.y = CGRectGetMaxY(footerLabel.frame) + 30;
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmButton];
}

- (void)confirmBtnDidClick
{
    if (YZStringIsEmpty(self.textField.text))
    {
        [MBProgressHUD showError:@"请输入昵称"];
        return;
    }
    YZUser *user = [YZUserDefaultTool user];
    NSDictionary *dict = @{
                           @"cmd":@(8126),
                           @"userId":UserId,
                           @"userName":user.userName,
                           @"nickName":self.textField.text
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            [self loadUserInfo];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"修改昵称失败"];
    }];
}
- (void)loadUserInfo
{
    if (!UserId) return;
    NSDictionary *dict = @{
                           @"cmd":@(8006),
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        YZLog(@"%@",json);
        if (SUCCESS) {
            //存储用户信息
            YZUser *user = [YZUser objectWithKeyValues:json];
            [YZUserDefaultTool saveUser:user];
            [MBProgressHUD showSuccess:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        YZLog(@"账户error");
    }];
}

@end
