//
//  YZChatViewController.m
//  ez
//
//  Created by 毛文豪 on 2017/11/2.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZChatViewController.h"
#import "IQKeyboardManager.h"
#import "YZThirdPartyStatus.h"

@interface YZChatViewController ()<HChatClientDelegate, HDMessageViewControllerDelegate, HDMessageViewControllerDataSource>

@end

@implementation YZChatViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = NO;
    keyboardManager.enableAutoToolbar = NO;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.enableAutoToolbar = YES;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setupUnreadMessageCount" object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.showRefreshHeader = YES;
    
    self.visitorInfo = [self visitorInfo];
    
    [self _setupBarButtonItem];
}

- (void)_setupBarButtonItem
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(deleteAllMessages:)];
}

//清空所有消息
- (void)deleteAllMessages:(id)sender
{
    if (self.dataArray.count == 0) {
        [MBProgressHUD showError:@"消息已经清空"];
        return;
    }
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认清空所有消息吗?"  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self.messageTimeIntervalTag = -1;
        [self.conversation deleteAllMessages:nil];
        [self.dataArray removeAllObjects];
        [self.messsagesSource removeAllObjects];
        [self.tableView reloadData];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (HVisitorInfo *)visitorInfo
{
    YZUser *user = [YZUserDefaultTool user];
    HVisitorInfo *visitor = [[HVisitorInfo alloc] init];
    visitor.name = user.userName;
    visitor.nickName = user.nickName;
    visitor.phone = user.mobilePhone;
    return visitor;
}

- (id<HDIMessageModel>)messageViewController:(HDMessageViewController *)viewController modelForMessage:(HMessage *)message
{
    id<HDIMessageModel> model = nil;
    model = [[HDMessageModel alloc] initWithMessage:message];
    if (model.isSender) {
        //头像
        NSString * loginWay = [YZUserDefaultTool getObjectForKey:@"loginWay"];
        YZThirdPartyStatus *thirdPartyStatus = [YZUserDefaultTool thirdPartyStatus];
        if ([loginWay isEqualToString:@"thirdPartyLogin"] && thirdPartyStatus) {//第三方登录
            model.avatarURLPath = thirdPartyStatus.iconurl;
        }else
        {
            //取出偏好设置中得已选图片
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *imageTag = [defaults stringForKey:@"selectedIconTag"];
            if(imageTag == nil)
            {//如果没有就默认第一张图片
                imageTag = @"0";
            }
            model.avatarImage = [UIImage imageNamed:[NSString stringWithFormat:@"icon%@", imageTag]];
        }
    }else
    {
        model.avatarImage = [UIImage imageNamed:@"logo"];
    }
    model.nickname = nil;
    return model;
}

@end
