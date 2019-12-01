//
//  YZServiceListViewController.m
//  ez
//
//  Created by dahe on 2019/7/15.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZServiceListViewController.h"
#import "YZChatViewController.h"
#import "YZServiceTableViewCell.h"

@interface YZServiceListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation YZServiceListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"联系客服";
    [self setupChilds];
    [self getData];
}

- (void)getData
{
    waitingView
    NSDictionary *dict = @{
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlSalesManager(@"/getCustomerServiceEntryList") params:dict success:^(id json) {
        YZLog(@"%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            self.dataArray = [YZServiceModel objectArrayWithKeyValuesArray:json[@"customerServiceEntryList"]];
            for (YZServiceModel * serviceModel in self.dataArray) {
                NSInteger index = [self.dataArray indexOfObject:serviceModel];
                NSDictionary * customerServiceEntry = json[@"customerServiceEntryList"][index];
                serviceModel.description_ = customerServiceEntry[@"description"];
            }
            [self.tableView reloadData];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error)
    {
        YZLog(@"error = %@",error);
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma  mark - 布局视图
- (void)setupChilds
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH)];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    tableView.tableFooterView = [UIView new];
    [self.view addSubview:tableView];
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 9)];
    tableView.tableHeaderView = headerView;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZServiceTableViewCell * cell = [YZServiceTableViewCell cellWithTableView:tableView];
    cell.serviceModel = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZServiceModel *serviceModel = self.dataArray[indexPath.row];
    
    if ([serviceModel.redirectType isEqualToString:@"EASEMOB"]) {
        [self goChat];
    }else if ([serviceModel.redirectType isEqualToString:@"WEIXIN"])
    {
        NSDictionary *extendDic = [YZTool dictionaryWithJsonString:serviceModel.extendParams];
        if (YZDictIsEmpty(extendDic)) {
            return;
        }
        
        //复制账号
        UIPasteboard *pab = [UIPasteboard generalPasteboard];
        NSString *string = extendDic[@"weixin"];
        [pab setString:string];
        [MBProgressHUD showSuccess:@"复制成功"];
        [self performSelector:@selector(skipWeixin) withObject:self afterDelay:1.0f];
    }else if ([serviceModel.redirectType isEqualToString:@"QQ"])
    {
        NSDictionary *extendDic = [YZTool dictionaryWithJsonString:serviceModel.extendParams];
        if (YZDictIsEmpty(extendDic)) {
            return;
        }
        
        NSString *urlStr = [NSString stringWithFormat:@"%@", extendDic[@"url"]];
        NSURL * url = [NSURL URLWithString:urlStr];
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
        //先判断是否能打开该url
        if (canOpen)
        {   //打开QQ
            [[UIApplication sharedApplication] openURL:url];
        }else {
            [MBProgressHUD showError:@"您的设备未安装QQ"];
        }
    }else if ([serviceModel.redirectType isEqualToString:@"TELL"])
    {
        NSDictionary *extendDic = [YZTool dictionaryWithJsonString:serviceModel.extendParams];
        if (YZDictIsEmpty(extendDic)) {
            return;
        }
        
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@", extendDic[@"tellphone"]];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }
}

- (void)goChat
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
                        chatVC.title = @"在线聊天";
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

- (void)skipWeixin
{
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    //先判断是否能打开该url
    if (canOpen)
    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
    }else {
        [MBProgressHUD showError:@"您的设备未安装微信APP"];
    }
}

#pragma mark - 初始化
- (NSArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}


@end
