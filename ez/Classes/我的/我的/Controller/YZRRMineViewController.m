//
//  YZRRMineViewController.m
//  ez
//
//  Created by dahe on 2019/9/10.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZRRMineViewController.h"
#import "YZMineSettingViewController.h"
#import "YZIntegralConversionViewController.h"
#import "YZAccountInfoViewController.h"
#import "YZMoneyDetailViewController.h"
#import "YZRechargeRecordViewController.h"
#import "YZWithdrawalRecordViewController.h"
#import "YZWithdrawalViewController.h"
#import "YZRechargeListViewController.h"
#import "YZVoucherViewController.h"
#import "YZMessageViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZShareProfitsViewController.h"
#import "YZWeChatPublicViewController.h"
#import "YZChatViewController.h"
#import "YZThirdPartyStatus.h"
#import "UIImageView+WebCache.h"
#import "UIButton+YZ.h"

@interface YZRRMineViewController ()

@property (nonatomic, weak) UIScrollView * scrollView;
@property (nonatomic,weak)  UIImageView *avatarImageView;
@property (nonatomic,weak) UILabel * nickNameLabel;
@property (nonatomic, weak) UILabel * nameCertificationLabel;
@property (nonatomic, weak) UIView *line1;
@property (nonatomic, weak) UILabel * phoneBindingLabel;
@property (nonatomic, strong) NSMutableArray *moneyDetailbtns;
@property (nonatomic, weak) UIButton * rechargeButton;
@property (nonatomic, weak) UIButton * withdrawalButton;
@property (nonatomic, weak) UIButton * voucheButton;
@property (nonatomic,strong) YZUser *user;

@end

@implementation YZRRMineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadUserInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    [self setupChilds];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    waitingView_loadingData;
    //接收登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInfo) name:loginSuccessNote object:nil];
    //接收html充值成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInfo) name:HtmlRechargeSuccessNote object:nil];
}
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self loadUserInfo];
}

- (void)loadUserInfo
{
    if (!UserId)
    {
        [MBProgressHUD hideHUDForView:self.view];
        return;
    }
    NSDictionary *dict = @{
                           @"cmd":@(8006),
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        YZLog(@"%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            //存储用户信息
            YZUser *user = [YZUser objectWithKeyValues:json];
            self.user = user;
            [YZUserDefaultTool saveUser:user];
            [self getMessageCount];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"账户error");
    }];
}
- (void)getMessageCount
{
    NSDictionary *dict = @{
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlJiguang(@"/countUnRead") params:dict success:^(id json) {
        if (SUCCESS) {
            int countUnReadMessage = [json[@"count"] intValue];
            NSLog(@"%d", countUnReadMessage);
        }
    } failure:^(NSError *error)
     {
         YZLog(@"error = %@",error);
     }];
}
#pragma mark - 布局视图
- (void)setupChilds
{
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - tabBarH)];
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    //背景
    UIImageView * backView = [[UIImageView alloc] init];
    backView.frame = CGRectMake(0, 0, screenWidth, 155);
    backView.image = [UIImage imageNamed:@"mine_top_bg_rr"];
    backView.userInteractionEnabled = YES;
    [scrollView addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mineBackViewClick)];
    [backView addGestureRecognizer:tap];
    
    //设置
    UIButton * settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat settingButtonWH = 55;
    settingButton.frame = CGRectMake(screenWidth - settingButtonWH - 5, statusBarH, settingButtonWH, settingButtonWH);
    [settingButton setImage:[UIImage imageNamed:@"11x5_setting"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:settingButton];
    
    //头像
    UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(YZMargin, 49, 50, 50)];
    self.avatarImageView = avatarImageView;
    avatarImageView.image = [UIImage imageNamed:@"avatar_zc"];
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = avatarImageView.width / 2;
    [backView addSubview:avatarImageView];
    
    //昵称
    UILabel * nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + 10, 50, screenWidth - (CGRectGetMaxX(avatarImageView.frame) + 10), 30)];
    self.nickNameLabel = nickNameLabel;
    nickNameLabel.text = @"昵称";
    nickNameLabel.textColor = [UIColor whiteColor];
    nickNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [backView addSubview:nickNameLabel];
    
    //实名认证
    UILabel * nameCertificationLabel = [[UILabel alloc]init];
    self.nameCertificationLabel = nameCertificationLabel;
    nameCertificationLabel.textColor = UIColorFromRGB(0xffd9d8);
    nameCertificationLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [backView addSubview:nameCertificationLabel];
    
    //分割线1
    UIView * line1 = [[UIView alloc]init];
    self.line1 = line1;
    line1.backgroundColor = YZColor(253, 165, 162, 1);
    [backView addSubview:line1];
    
    //手机绑定信息
    UILabel * phoneBindingLabel = [[UILabel alloc]init];
    self.phoneBindingLabel = phoneBindingLabel;
    phoneBindingLabel.textColor = UIColorFromRGB(0xffd9d8);
    phoneBindingLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [backView addSubview:phoneBindingLabel];
   
    //账户金额
    UIView * moneyDetailView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(backView.frame) - 40, screenWidth - 2 * 15, 80)];
    moneyDetailView.backgroundColor = [UIColor whiteColor];
    moneyDetailView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    moneyDetailView.layer.shadowOffset = CGSizeMake(2, 2);
    moneyDetailView.layer.shadowRadius = 2;
    moneyDetailView.layer.shadowOpacity = 0.8;
    moneyDetailView.layer.cornerRadius = 5;
    [scrollView addSubview:moneyDetailView];
    
    CGFloat moneyDetailBtnY = 0;
    CGFloat moneyDetailBtnH = moneyDetailView.height;
    CGFloat lineH = 21;
    for (int i = 0; i < 3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(moneyDetailView.width * i / 3, moneyDetailBtnY, moneyDetailView.width / 3, moneyDetailBtnH);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.numberOfLines = 2;
        [moneyDetailView addSubview:button];
        [self.moneyDetailbtns addObject:button];
        if (i != 2) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(moneyDetailView.width / 3 - 1, (moneyDetailBtnH - lineH) / 2, 1.5, lineH)];
            line.backgroundColor = YZWhiteLineColor;
            [button addSubview:line];
        }
    }
    [self setMoneyButtonTitleByBalance:@"0元" bonus:@"0元" grade:@"0"];
    
    //我的钱包
    UIView * walletView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame), screenWidth, 178)];
    walletView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:walletView];
    [scrollView bringSubviewToFront:moneyDetailView];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(15, 62, 3, 15)];
    lineView1.backgroundColor = UIColorFromRGB(0xf47a3a);
    [walletView addSubview:lineView1];
    
    UILabel * walletLabel = [[UILabel alloc] init];
    walletLabel.textColor = UIColorFromRGB(0x2b2b2b);
    walletLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    walletLabel.text = @"我的钱包";
    CGSize walletLabelSize = [walletLabel.text sizeWithLabelFont:walletLabel.font];
    walletLabel.frame = CGRectMake(CGRectGetMaxX(lineView1.frame) + 5, 62, walletLabelSize.width, walletLabelSize.height);
    [walletView addSubview:walletLabel];
    lineView1.centerY = walletLabel.centerY;
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(walletLabel.frame) + 12, screenWidth, 1)];
    line2.backgroundColor = YZWhiteLineColor;
    [walletView addSubview:line2];
    
    //充值提款彩券
    CGFloat rechargeBtnY = CGRectGetMaxY(line2.frame) + 3;
    CGFloat rechargeBtnH = 85;
    for (int i = 0; i < 4; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(walletView.width / 4 * i, rechargeBtnY, walletView.width / 4, rechargeBtnH);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            self.rechargeButton = button;
            [button setImage:[UIImage imageNamed:@"mine_recharge_icon_rr"] forState:UIControlStateNormal];
            [button setTitle:@"充值" forState:UIControlStateNormal];
        }else if (i == 1)
        {
            self.withdrawalButton = button;
            [button setImage:[UIImage imageNamed:@"mine_withdrawal_icon_rr"] forState:UIControlStateNormal];
            [button setTitle:@"提款" forState:UIControlStateNormal];
        }else if (i == 2)
        {
            self.voucheButton = button;
            [button setImage:[UIImage imageNamed:@"vouche_bar_rr"] forState:UIControlStateNormal];
            [button setTitle:@"彩券" forState:UIControlStateNormal];
        }else if (i == 3)
        {
            self.voucheButton = button;
            [button setImage:[UIImage imageNamed:@"integral_conversion_icon_rr"] forState:UIControlStateNormal];
            [button setTitle:@"积分兑换" forState:UIControlStateNormal];
        }
        [button setTitleColor:UIColorFromRGB(0x2b2b2b) forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [button setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentUp imgTextDistance:7];//图片和文字的间距
        [button addTarget:self action:@selector(walletButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [walletView addSubview:button];
        if (i != 0) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, (rechargeBtnH - lineH) / 2, 1, lineH)];
            line.backgroundColor = YZWhiteLineColor;
            [button addSubview:line];
        }
    }
    
    UIView * lastView = walletView;
    for (int i = 0; i < 2; i++) {
        CGFloat functionViewH;
        if (i == 0) {
            functionViewH = 120;
        }else
        {
            functionViewH = 120;
        }
        UIView * functionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame) + 10, screenWidth, functionViewH)];
        functionView.backgroundColor = [UIColor whiteColor];
        [scrollView addSubview:functionView];
        lastView = functionView;
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 15, 3, 15)];
        lineView.backgroundColor = UIColorFromRGB(0xf47a3a);
        [functionView addSubview:lineView];
        
        UILabel * functionLabel = [[UILabel alloc] init];
        functionLabel.textColor = UIColorFromRGB(0x2b2b2b);
        functionLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        if (i == 0) {
            functionLabel.text = @"我的交易";
        }else
        {
            functionLabel.text = @"我的服务";
        }
        CGSize functionLabelSize = [functionLabel.text sizeWithLabelFont:functionLabel.font];
        functionLabel.frame = CGRectMake(CGRectGetMaxX(lineView.frame) + 5, 15, functionLabelSize.width, functionLabelSize.height);
        [functionView addSubview:functionLabel];
        lineView.centerY = functionLabel.centerY;
        
        //功能按钮
        CGFloat functionBtnY = 40;
        CGFloat functionBtnH = 70;
        NSArray * buttonTitles;
        NSArray * buttonImageNames;
        if (i == 0) {
            buttonTitles = @[@"投注详情", @"资金明细", @"充值记录", @"提款记录"];
            buttonImageNames = @[@"mine_order_rr_icon", @"mine_money_rr_icon", @"mine_recharge_record_rr_icon", @"mine_withdrawal_record_rr_icon"];
        }else
        {
            buttonTitles = @[@"我的消息", @"购彩帮助", @"联系客服"];
            buttonImageNames = @[@"mine_message_rr_icon", @"mine_help_rr_icon", @"mine_contact_service_rr_icon"];
        }
        for (int j = 0; j < buttonTitles.count; j++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = i * 100 + j;
            button.frame = CGRectMake(screenWidth / 4 * (j % 4), functionBtnY, screenWidth / 4, functionBtnH);
            [button setTitleColor:UIColorFromRGB(0x2b2b2b) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
            [button setImage:[UIImage imageNamed:buttonImageNames[j]] forState:UIControlStateNormal];
            [button setTitle:buttonTitles[j] forState:UIControlStateNormal];
            [button setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentUp imgTextDistance:10];//图片和文字的间距
            [button addTarget:self action:@selector(functionButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
            [functionView addSubview:button];
        }
        
        scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(functionView.frame) + 10);
    }
}

#pragma mark - 设置数据
- (void)setUser:(YZUser *)user
{
    _user = user;
    //头像
    NSString * loginWay = [YZUserDefaultTool getObjectForKey:@"loginWay"];
    YZThirdPartyStatus *thirdPartyStatus = [YZUserDefaultTool thirdPartyStatus];
    if ([loginWay isEqualToString:@"thirdPartyLogin"] && thirdPartyStatus) {//第三方登录
        NSURL *imageUrl = [NSURL URLWithString:thirdPartyStatus.iconurl];
        //取出偏好设置中得已选图片
        NSString *imageTag = [YZUserDefaultTool getObjectForKey:@"selectedIconTag"];
        imageTag = imageTag ? imageTag : @"0";
        UIImage *placeholderImage = [UIImage imageNamed:[NSString stringWithFormat:@"icon%@",imageTag]];
        [self.avatarImageView sd_setImageWithURL:imageUrl placeholderImage:placeholderImage];
    }else
    {
        self.avatarImageView.image = [UIImage imageNamed:@"avatar_zc"];
    }
    
    //赋值个人基本信息
    if ([loginWay isEqualToString:@"thirdPartyLogin"] && thirdPartyStatus) {//第三方登录
        self.nickNameLabel.text = thirdPartyStatus.name;
    }else
    {
        self.nickNameLabel.text = _user.nickName;
    }
    
    if (_user.userInfo.realname) {
        self.nameCertificationLabel.text = @"已认证";
    }else
    {
        self.nameCertificationLabel.text = @"未认证";
    }
    if (_user.mobilePhone) {
        self.phoneBindingLabel.text = @"已绑定手机";
    }else
    {
        self.phoneBindingLabel.text = @"未绑定手机";
    }
    
    //赋值彩金、奖金、积分
    NSString *balance = [NSString stringWithFormat:@"%.2f元",[_user.balance intValue] / 100.0];
    if ([_user.balance intValue] == 0)
    {
        balance = @"0元";
    }
    NSString *bonus = [NSString stringWithFormat:@"%.2f元",[_user.bonus intValue] / 100.0];
    if ([_user.bonus intValue] == 0)
    {
        bonus = @"0元";
    }
    NSString *grade = [NSString stringWithFormat:@"%d",[_user.grade intValue]];
    [self setMoneyButtonTitleByBalance:balance bonus:bonus grade:grade];
    
    //frame
    CGSize nickSize = [self.nickNameLabel.text sizeWithLabelFont:self.nickNameLabel.font];
    CGSize nameSize = [self.nameCertificationLabel.text sizeWithLabelFont:self.nameCertificationLabel.font];
    CGFloat padding = 5;
    CGFloat nickNameY = (81 - nickSize.height - nameSize.height - padding) / 2;
    CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 10, nickNameY, nickSize.width, nickSize.height);
    self.nameCertificationLabel.frame = CGRectMake(self.nickNameLabel.x, CGRectGetMaxY(self.nickNameLabel.frame) + padding, nameSize.width, nameSize.height);
    
    self.line1.frame = CGRectMake(CGRectGetMaxX(self.nameCertificationLabel.frame) + 3, self.nameCertificationLabel.y, 1, self.nameCertificationLabel.height);
    
    CGSize mobilePhoneSize = [self.phoneBindingLabel.text sizeWithLabelFont:self.phoneBindingLabel.font];
    self.phoneBindingLabel.frame = CGRectMake(CGRectGetMaxX(self.line1.frame) + 3, self.nameCertificationLabel.y, mobilePhoneSize.width, self.nameCertificationLabel.height);
}
- (void)setMoneyButtonTitleByBalance:(NSString *)balance bonus:(NSString *)bonus grade:(NSString *)grade
{
    NSArray *moneys = [NSArray arrayWithObjects:balance,bonus,grade,nil];
    NSArray * moneyDetailbtnTitles = @[@"彩金", @"奖金", @"积分"];
    for (UIButton * button in self.moneyDetailbtns) {
        NSInteger index = [self.moneyDetailbtns indexOfObject:button];
        NSString * btnStr = [NSString stringWithFormat:@"%@\n%@", moneys[index], moneyDetailbtnTitles[index]];
        NSMutableAttributedString * btnAttStr = [[NSMutableAttributedString alloc]initWithString:btnStr];
        [btnAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(34)] range:NSMakeRange(0, btnAttStr.length - 2)];
        [btnAttStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xee2525) range:NSMakeRange(0, btnAttStr.length - 2)];
        [btnAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(btnAttStr.length - 2, 2)];
        [btnAttStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xababab) range:NSMakeRange(btnAttStr.length - 2, 2)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;//居中
        [paragraphStyle setLineSpacing:7];//行间距
        [btnAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, btnAttStr.length)];
        [button setAttributedTitle:btnAttStr forState:UIControlStateNormal];
    }
}
#pragma mark - 按钮点击
- (void)mineBackViewClick
{
    YZAccountInfoViewController * accountInfoVC = [[YZAccountInfoViewController alloc]init];
    [self.navigationController pushViewController:accountInfoVC animated:YES];
}

- (void)settingButtonDidClick
{
    YZMineSettingViewController * settingVC = [[YZMineSettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)walletButtonDidClick:(UIButton *)button
{
    if (button.tag == 1) {//提款
        if (!_user.userInfo.realname || !_user.mobilePhone) {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"完善实名信息后才能提款哦" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"去完善" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //没有实名认证需要先进行实名认证才能提现
                if (!_user.userInfo.realname && !_user.mobilePhone) {
                    YZNamePhoneBindingViewController * namePhoneBindingVC = [[YZNamePhoneBindingViewController alloc]init];
                    [self.navigationController pushViewController:namePhoneBindingVC animated:YES];
                }else if (!_user.userInfo.realname  && _user.mobilePhone) {//没有实名认证
                    YZRealNameViewController * realNameVC = [[YZRealNameViewController alloc]init];
                    [self.navigationController pushViewController:realNameVC animated:YES];
                }else if (!_user.mobilePhone && _user.userInfo.realname) {
                    YZPhoneBindingViewController * PhoneBindingVC = [[YZPhoneBindingViewController alloc]init];
                    [self.navigationController pushViewController:PhoneBindingVC animated:YES];
                }
            }];
            [alertController addAction:alertAction1];
            [alertController addAction:alertAction2];
            [self presentViewController:alertController animated:YES completion:nil];
        }else
        {
            //提现
            YZWithdrawalViewController * withdrawalVC = [[YZWithdrawalViewController alloc]init];
            [self.navigationController pushViewController:withdrawalVC animated:YES];
        }
    }else if (button.tag == 0)//充值
    {
        YZRechargeListViewController *rechargeVc = [[YZRechargeListViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:rechargeVc animated:YES];
    }else if (button.tag == 2)//彩券
    {
        YZVoucherViewController * voucherVC = [[YZVoucherViewController alloc]init];
        [self.navigationController pushViewController:voucherVC animated:YES];
    }else if (button.tag == 3)//积分兑换
    {
        YZIntegralConversionViewController * integralConversionVC = [[YZIntegralConversionViewController alloc] init];
        [self.navigationController pushViewController:integralConversionVC animated:YES];
    }
}

- (void)functionButtonDidClick:(UIButton *)button
{
    if (button.tag == 0)
    {
        NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:NO];
            });
        }];
        NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
            dispatch_sync(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:RefreshRecordNote object:@(0)];
            });
        }];
        [op2 addDependency:op1];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue waitUntilAllOperationsAreFinished];
        [queue addOperation:op1];
        [queue addOperation:op2];
    }else if (button.tag == 1)
    {
        YZMoneyDetailViewController *moneyDetailVC = [[YZMoneyDetailViewController alloc]init];
        [self.navigationController pushViewController:moneyDetailVC animated:YES];
    }else if (button.tag == 2)
    {
        YZRechargeRecordViewController * rechargeRecordVC = [[YZRechargeRecordViewController alloc]init];
        [self.navigationController pushViewController:rechargeRecordVC animated:YES];
    }else if (button.tag == 3)
    {
        YZWithdrawalRecordViewController * withdrawalRecordVC = [[YZWithdrawalRecordViewController alloc]init];
        [self.navigationController pushViewController:withdrawalRecordVC animated:YES];
    }else if (button.tag == 100)
    {
        YZMessageViewController * messageVC = [[YZMessageViewController alloc]init];
        [self.navigationController pushViewController:messageVC animated:YES];
    }else if (button.tag == 101)
    {
        YZLoadHtmlFileController *htmlVc = [[YZLoadHtmlFileController alloc] initWithFileName:@"help.htm"];
        [self.navigationController pushViewController:htmlVc animated:YES];
    }else if (button.tag == 102)
    {
        [self chatDidBarClick];
    }
}

- (void)chatDidBarClick
{
    //注册
    NSDictionary *dict = @{
                           @"userId":UserId,
                           };
    waitingView
    [[YZHttpTool shareInstance] postWithURL:BaseUrlEasemob(@"/register") params:dict success:^(id json) {
        if (SUCCESS) {
            YZLog(@"%@", json);
            //异步登录
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                HChatClient *client = [HChatClient sharedClient];
                HError *error = [client loginWithUsername:json[@"userInfo"][@"username"] password:json[@"userInfo"][@"password"]];
                if (!error)
                {
                    YZLog(@"登录成功");
                    YZUser *user = [YZUserDefaultTool user];
                    [[EMClient sharedClient] setApnsNickname:user.nickName];
                    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
                    options.displayStyle = EMPushDisplayStyleMessageSummary;// 显示消息内容
                    EMError *pushError = [[EMClient sharedClient] updatePushOptionsToServer]; // 更新配置到服务器，该方法为同步方法，如果需要，请放到单独线程
                    if(!pushError) {
                        YZLog(@"更新成功");
                    }else {
                        YZLog(@"更新失败");
                    }
                    
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view];
                        // 进入会话页面
                        YZChatViewController *chatVC = [[YZChatViewController alloc] initWithConversationChatter:CECIM];
                        chatVC.title = @"在线客服";
                        [self.navigationController pushViewController:chatVC animated:YES];
                    });
                } else
                {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view];
                        [MBProgressHUD showError:@"发起聊天失败"];
                    });
                }
            });
        }else
        {
            [MBProgressHUD hideHUDForView:self.view];
            ShowErrorView
        }
    } failure:^(NSError *error)
     {
         YZLog(@"error = %@",error);
         [MBProgressHUD hideHUDForView:self.view];
     }];
}

#pragma mark - 初始化
- (NSMutableArray *)moneyDetailbtns
{
    if (_moneyDetailbtns == nil) {
        _moneyDetailbtns = [NSMutableArray array];
    }
    return _moneyDetailbtns;
}


@end
