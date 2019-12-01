//
//  YZMineSettingViewController.m
//  ez
//
//  Created by apple on 16/9/5.
//  Copyright © 2016年 9ge. All rights reserved.
//
#import "YZMineSettingViewController.h"
#import "YZStatusCacheTool.h"
#import <UMSocialCore/UMSocialCore.h>

@interface YZMineSettingViewController ()

@property (nonatomic, weak) UILabel *desLabel;

@end

@implementation YZMineSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"设置";
    [self setupChilds];
    //接收刷新通知状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNotificationStatus) name:RefreshNotificationStatusNote object:nil];
}
- (void)refreshNotificationStatus
{
    UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
    if (UIUserNotificationTypeNone == setting.types) {
        self.desLabel.text = @"已关闭，去开启";
    }else
    {
        self.desLabel.text = @"已开启，去关闭";
    }
}
- (void)setupChilds
{
    for (int i = 0; i < 3; i++) {
        CGFloat viewY = 10 + i * YZCellH;
    
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, viewY, screenWidth, YZCellH)];
        view.tag = i;
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.textColor = YZBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        if (i == 0) {
            titleLabel.text = @"版本号";
        }else if (i == 1) {
            titleLabel.text = @"推送消息开启";
        }else if (i == 2)
        {
            titleLabel.text = @"摇一摇选号";
        }
        CGSize size = [titleLabel.text sizeWithLabelFont:titleLabel.font];
        titleLabel.frame = CGRectMake(YZMargin, 0, size.width, YZCellH);
        [view addSubview:titleLabel];
        
        if (i == 0) {
            UILabel * desLabel = [[UILabel alloc]init];
            desLabel.textColor = YZGrayTextColor;
            desLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
            //获得当前版本号
            NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
            desLabel.text = [NSString stringWithFormat:@"v%@",currentVersion];
            desLabel.textAlignment = NSTextAlignmentRight;
            CGSize size = [desLabel.text sizeWithLabelFont:desLabel.font];
            desLabel.frame = CGRectMake(screenWidth - YZMargin - size.width, 0, size.width, YZCellH);
            [view addSubview:desLabel];
        }else if (i == 1)
        {//用户名
            //添加点击事件
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap:)];
            [view addGestureRecognizer:tap];
            
            //accessory
            CGFloat accessoryW = 8;
            CGFloat accessoryH = 11;
            UIImageView * accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 15 - accessoryW, (YZCellH - accessoryH) / 2, accessoryW, accessoryH)];
            accessoryImageView.image = [UIImage imageNamed:@"accessory_dray"];
            [view addSubview:accessoryImageView];
            
            UILabel * desLabel = [[UILabel alloc]init];
            self.desLabel = desLabel;
            desLabel.textColor = YZGrayTextColor;
            desLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
            UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
            if (UIUserNotificationTypeNone == setting.types) {
                desLabel.text = @"已关闭，去开启";
            }else
            {
                desLabel.text = @"已开启，去关闭";
            }
            desLabel.textAlignment = NSTextAlignmentRight;
            CGSize size = [desLabel.text sizeWithLabelFont:desLabel.font];
            desLabel.frame = CGRectMake(accessoryImageView.x - 5 - size.width, 0, size.width, YZCellH);
            [view addSubview:desLabel];
        }else if (i == 2)
        {
            //开关
            UISwitch *switchView = [[UISwitch alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            // 控件大小，不能设置frame，只能用缩放比例
            CGFloat scale = 0.8;
            switchView.transform = CGAffineTransformMakeScale(scale, scale);
            switchView.x = screenWidth - switchView.width - YZMargin;
            switchView.y = (YZCellH - switchView.height * scale) / 2;
            switchView.tag = i;
            switchView.onTintColor = YZBaseColor;
            NSString * allowShake = [YZUserDefaultTool getObjectForKey:@"allowShake"];
            if ([allowShake isEqualToString:@"0"]) {
                switchView.on = NO;
            }else
            {
                switchView.on = YES;
            }
            [switchView addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
            [view addSubview:switchView];
        }
        //分割线
        if (i != 2) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, YZCellH - 1, screenWidth, 1)];
            line.backgroundColor = YZWhiteLineColor;
            [view addSubview:line];
        }
    }
    
    //底部退出登录按钮
    UIButton * logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(20, 10 + 3 * YZCellH + 40, screenWidth - 2 * 20, 40);
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:YZBaseColor forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    logoutBtn.layer.masksToBounds = YES;
    logoutBtn.layer.cornerRadius = logoutBtn.height / 2;
    logoutBtn.layer.borderColor = YZBaseColor.CGColor;
    logoutBtn.layer.borderWidth = 1;
    [logoutBtn addTarget:self action:@selector(logoutButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
}

- (void)viewTap:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 1) {
        //跳入当前App设置界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

- (void)switchValueChange:(UISwitch *)switchView
{
    [YZUserDefaultTool saveObject:[NSString stringWithFormat:@"%d",switchView.on] forKey:@"allowShake"];
}

- (void)logoutButtonClick
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确定退出登录？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self logout];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)logout
{
    [MBProgressHUD showMessage:@"正在注销，客官请稍后" toView:self.view];
    //删除用户的个人数据
    [YZUserDefaultTool removeObjectForKey:@"userId"];
    [YZUserDefaultTool removeObjectForKey:@"userPwd"];
    [YZStatusCacheTool deleteUserStatus];//删除用户信息数据表
    [YZTool logoutAlias];
    //取消自动登录
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:1 forKey:@"autoLogin"];
    [defaults synchronize];
    
    dispatch_time_t poptime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
    dispatch_after(poptime, dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        [self.navigationController popToRootViewControllerAnimated:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ToBuyLottery" object:nil];
    });
}

@end
