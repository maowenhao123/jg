//
//  YZZCMineViewController.m
//  ez
//
//  Created by 毛文豪 on 2017/9/27.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZZCMineViewController.h"
#import "YZMineSettingViewController.h"
#import "YZAccountInfoViewController.h"
#import "YZMoneyDetailViewController.h"
#import "YZRechargeRecordViewController.h"
#import "YZWithdrawalRecordViewController.h"
#import "YZWithdrawalViewController.h"
#import "YZRechargeListViewController.h"
#import "YZVoucherViewController.h"
#import "YZMessageViewController.h"
#import "YZOrderViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZContactCustomerServiceViewController.h"
#import "YZThirdPartyStatus.h"
#import "UIImageView+WebCache.h"
#import "UIButton+YZ.h"

@interface YZZCMineViewController ()

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

@implementation YZZCMineViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //接收需要刷新账户中心的纪录的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshRecord:) name:RefreshRecordNote object:nil];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadUserInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //设置状态栏
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
- (void)refreshRecord:(NSNotification *)note
{
    YZOrderViewController *orderVC = [[YZOrderViewController alloc]init];
    [self.navigationController pushViewController:orderVC animated:YES];
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
    //20190510101341972
    //1612201120220100000026446
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
    UIImageView * backView = [[UIImageView alloc]init];
    backView.frame = CGRectMake(0, 0, screenWidth, statusBarH + navBarH + 78);
    if (iPhone5 || iPhone4)
    {
        backView.image = [UIImage imageNamed:@"mine_top_bg_zc_4"];
    }else if (iPhone6)
    {
        backView.image = [UIImage imageNamed:@"mine_top_bg_zc_6"];
    }else if (iPhone6P)
    {
        backView.image = [UIImage imageNamed:@"mine_top_bg_zc_6P"];
    }else
    {
        backView.image = [UIImage imageNamed:@"mine_top_bg_zc_6P"];
    }
    backView.userInteractionEnabled = YES;
    [scrollView addSubview:backView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mineBackViewClick)];
    [backView addGestureRecognizer:tap];
    
    //头像
    UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(YZMargin, statusBarH + 25, 50, 50)];
    self.avatarImageView = avatarImageView;
    avatarImageView.image = [UIImage imageNamed:@"avatar_zc"];
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = avatarImageView.width / 2;
    [backView addSubview:avatarImageView];
    
    //昵称
    UILabel * nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + 10, statusBarH + 25, screenWidth - (CGRectGetMaxX(avatarImageView.frame) + 10), 30)];
    self.nickNameLabel = nickNameLabel;
    nickNameLabel.text = @"昵称";
    nickNameLabel.textColor = [UIColor whiteColor];
    nickNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [backView addSubview:nickNameLabel];
    
    //实名认证
    UILabel * nameCertificationLabel = [[UILabel alloc]init];
    self.nameCertificationLabel = nameCertificationLabel;
    nameCertificationLabel.textColor = YZColor(253, 165, 162, 1);
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
    phoneBindingLabel.textColor = YZColor(253, 165, 162, 1);
    phoneBindingLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [backView addSubview:phoneBindingLabel];
  
    //accessory
    CGFloat accessoryW = 8;
    CGFloat accessoryH = 11;
    UIImageView * accessory = [[UIImageView alloc]init];
    accessory.frame = CGRectMake(screenWidth - YZMargin - accessoryW, 0, accessoryW, accessoryH);
    accessory.centerY = avatarImageView.centerY;
    accessory.image = [UIImage imageNamed:@"mine_accessory_zc"];
    [backView addSubview:accessory];
    
    //账户金额
    UIView * moneyDetailView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(backView.frame), screenWidth, 77)];
    moneyDetailView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:moneyDetailView];
    
    CGFloat moneyDetailBtnY = 0;
    CGFloat moneyDetailBtnH = moneyDetailView.height;
    CGFloat lineH = 20;
    for (int i = 0; i < 3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(screenWidth * i / 3, moneyDetailBtnY, screenWidth / 3, moneyDetailBtnH);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.numberOfLines = 2;
        [moneyDetailView addSubview:button];
        [self.moneyDetailbtns addObject:button];
        if (i != 2) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(screenWidth / 3 - 1,(moneyDetailBtnH - lineH) / 2, 1.5, lineH)];
            line.backgroundColor = YZWhiteLineColor;
            [button addSubview:line];
        }
    }
    [self setMoneyButtonTitleByBalance:@"0元" bonus:@"0元" grade:@"0"];
    
    //我的钱包
    UIView * walletView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(moneyDetailView.frame) + 9, screenWidth, 110)];
    walletView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:walletView];
    
    UILabel * walletLabel = [[UILabel alloc] init];
    walletLabel.textColor = YZBlackTextColor;
    walletLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    walletLabel.text = @"我的钱包";
    CGSize walletLabelSize = [walletLabel.text sizeWithLabelFont:walletLabel.font];
    walletLabel.frame = CGRectMake(YZMargin, 11, walletLabelSize.width, walletLabelSize.height);
    [walletView addSubview:walletLabel];
    
    //充值提款彩券
    CGFloat rechargeBtnY = 40;
    CGFloat rechargeBtnH = 58;
    for (int i = 0; i < 3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(screenWidth / 3 * i, rechargeBtnY, screenWidth / 3, rechargeBtnH);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            self.rechargeButton = button;
            [button setImage:[UIImage imageNamed:@"mine_recharge_icon"] forState:UIControlStateNormal];
            [button setTitle:@"充值" forState:UIControlStateNormal];
        }else if (i == 1)
        {
            self.withdrawalButton = button;
            [button setImage:[UIImage imageNamed:@"mine_withdrawal_icon"] forState:UIControlStateNormal];
            [button setTitle:@"提款" forState:UIControlStateNormal];
        }else if (i == 2)
        {
            self.voucheButton = button;
            [button setImage:[UIImage imageNamed:@"vouche_bar"] forState:UIControlStateNormal];
            [button setTitle:@"彩券" forState:UIControlStateNormal];
        }
        [button setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
        [button setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentUp imgTextDistance:10];//图片和文字的间距
        [button addTarget:self action:@selector(walletButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [walletView addSubview:button];
        if (i != 0) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, (rechargeBtnH - lineH) / 2, 1, lineH)];
            line.backgroundColor = YZWhiteLineColor;
            [button addSubview:line];
        }
    }
    
    //我的服务
    UIView * functionView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(walletView.frame) + 9, screenWidth, 190)];
    functionView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:functionView];
    
    UILabel * functionLabel = [[UILabel alloc] init];
    functionLabel.textColor = YZBlackTextColor;
    functionLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    functionLabel.text = @"我的服务";
    CGSize functionLabelSize = [functionLabel.text sizeWithLabelFont:functionLabel.font];
    functionLabel.frame = CGRectMake(YZMargin, 11, functionLabelSize.width, functionLabelSize.height);
    [functionView addSubview:functionLabel];
    
    //功能按钮
    CGFloat functionBtnY1 = 40;
    CGFloat functionBtnY2 = 114;
    CGFloat functionBtnH = 70;
    NSArray * buttonTitles = @[@"投注详情", @"资金明细", @"充值记录", @"提款记录", @"消息中心", @"购彩帮助", @"联系客服", @"设置"];
    NSArray * buttonImageNames = @[@"mine_order_zc_icon", @"mine_money_zc_icon", @"mine_recharge_record_zc_icon", @"mine_withdrawal_record_zc_icon", @"mine_message_zc_icon", @"mine_help_zc_icon", @"mine_contact_service_zc_icon", @"mine_setting_zc_icon"];
    for (int i = 0; i < 8; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(screenWidth / 4 * (i % 4), (i < 4 ? functionBtnY1 : functionBtnY2), screenWidth / 4, functionBtnH);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        [button setImage:[UIImage imageNamed:buttonImageNames[i]] forState:UIControlStateNormal];
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        [button setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentUp imgTextDistance:10];//图片和文字的间距
        [button addTarget:self action:@selector(functionButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [functionView addSubview:button];
    }
    
    scrollView.contentSize = CGSizeMake(screenWidth, CGRectGetMaxY(functionView.frame) + 10);
//    [self test];
}
- (void)test
{
    NSDictionary *testDict = @{
                               @"cmd":@(8026),
                               @"gameId":@"T05"
                               };
    [[YZHttpTool shareInstance] postWithParams:testDict success:^(id json) {
        YZLog(@"%@",json);
        if (Jump) {//隐藏充值按钮
            self.rechargeButton.hidden = YES;
            self.withdrawalButton.x = 0;
            self.withdrawalButton.width = screenWidth / 2;
            self.voucheButton.x = screenWidth / 2;
            self.voucheButton.width = screenWidth / 2;
        }else
        {
            self.rechargeButton.hidden = NO;
            self.rechargeButton.x = 0;
            self.rechargeButton.width = screenWidth / 3;
            self.withdrawalButton.x = screenWidth / 3;
            self.withdrawalButton.width = screenWidth / 3;
            self.voucheButton.x = screenWidth / 3 * 2;
            self.voucheButton.width = screenWidth / 3;
        }
        [self.withdrawalButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:10];//图片和文字的间距
        [self.rechargeButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:10];//图片和文字的间距
        [self.voucheButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:10];//图片和文字的间距
    } failure:^(NSError *error) {
        YZLog(@"getCurrentTermData - error = %@",error);
    }];
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
    NSArray * moneyDetailbtnTitles = @[@"彩金",@"奖金",@"积分"];
    for (UIButton * button in self.moneyDetailbtns) {
        NSInteger index = [self.moneyDetailbtns indexOfObject:button];
        NSString * btnStr = [NSString stringWithFormat:@"%@\n%@", moneys[index], moneyDetailbtnTitles[index]];
        NSMutableAttributedString * btnAttStr = [[NSMutableAttributedString alloc]initWithString:btnStr];
        [btnAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(34)] range:NSMakeRange(0, btnAttStr.length - 2)];
        [btnAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(238, 37, 37, 1) range:NSMakeRange(0, btnAttStr.length - 2)];
        [btnAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(btnAttStr.length - 2, 2)];
        [btnAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(btnAttStr.length - 2, 2)];
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
    }else
    {
        YZVoucherViewController * voucherVC = [[YZVoucherViewController alloc]init];
        [self.navigationController pushViewController:voucherVC animated:YES];
    }
}

- (void)functionButtonDidClick:(UIButton *)button
{
    if (button.tag == 0)
    {
        YZOrderViewController *orderVC = [[YZOrderViewController alloc]init];
        [self.navigationController pushViewController:orderVC animated:YES];
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
    }else if (button.tag == 4)
    {
        YZMessageViewController * messageVC = [[YZMessageViewController alloc]init];
        [self.navigationController pushViewController:messageVC animated:YES];
    }else if (button.tag == 5)
    {
        YZLoadHtmlFileController *htmlVc = [[YZLoadHtmlFileController alloc] initWithFileName:@"help.htm"];
        htmlVc.title = @"购彩帮助";
        [self.navigationController pushViewController:htmlVc animated:YES];
    }else if (button.tag == 6)
    {
        YZContactCustomerServiceViewController * contactServiceVC = [[YZContactCustomerServiceViewController alloc]init];
        [self.navigationController pushViewController:contactServiceVC animated:YES];
    }else if (button.tag == 7)
    {
        YZMineSettingViewController * settingVC = [[YZMineSettingViewController alloc]init];
        [self.navigationController pushViewController:settingVC animated:YES];
    }
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
