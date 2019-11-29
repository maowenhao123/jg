//
//  YZMineViewController.m
//  ez
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZMineViewController.h"
#import "YZMineHeaderView.h"
#import "YZMineFunctionTableViewCell.h"
#import "YZFunctionStatus.h"
#import "YZChooseAvatarView.h"
#import "YZMineSettingViewController.h"
#import "YZAccountInfoViewController.h"
#import "YZIntegralConversionViewController.h"
#import "YZMoneyDetailViewController.h"
#import "YZRechargeRecordViewController.h"
#import "YZWithdrawalRecordViewController.h"
#import "YZWithdrawalViewController.h"
#import "YZRechargeListViewController.h"
#import "YZVoucherViewController.h"
#import "YZMessageViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZShareProfitsViewController.h"
#import "YZCustomerServiceViewController.h"
#import "YZChatViewController.h"
#import "YZWeChatPublicViewController.h"
#import "YZShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"

@interface YZMineViewController ()<UITableViewDelegate,UITableViewDataSource,YZMineHeaderViewDelegate>
{
    YZUser *_user;
}

@property (nonatomic, weak) UITableView *mainTableView;
@property (nonatomic, weak) YZMineHeaderView * headerView;
@property (nonatomic, strong) NSArray *functions;
@property (nonatomic, weak) MJRefreshGifHeader *header;

@end

@implementation YZMineViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadUserInfo];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    [self setupChilds];
    waitingView_loadingData;
    //接收登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInfo) name:loginSuccessNote object:nil];
    //接收html充值成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInfo) name:HtmlRechargeSuccessNote object:nil];
    //接收积分兑换成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInfo) name:IntegralConversionSuccessNote object:nil];
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
        [self.header endRefreshing];
        if (SUCCESS) {
            //存储用户信息
            YZUser *user = [YZUser objectWithKeyValues:json];
            _user = user;
            [YZUserDefaultTool saveUser:user];
            self.headerView.user = _user;
            [self.mainTableView reloadData];
            [self getMessageCount];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [self.header endRefreshing];
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
            YZMineFunctionTableViewCell * cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
            //消息红点的显示与隐藏
            if (countUnReadMessage > 0) {
                cell.redDot.hidden = NO;
            }else
            {
                cell.redDot.hidden = YES;
            }
        }
    } failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
    }];
}
#pragma mark - 布局视图
- (void)setupChilds
{
    //设置按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mine_setting_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(settingBarClick)];
    
    UITableView * mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH - tabBarH) style:UITableViewStyleGrouped];
    self.mainTableView = mainTableView;
    mainTableView.backgroundColor = YZBackgroundColor;
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.showsVerticalScrollIndicator = NO;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [mainTableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:mainTableView];
    
    //初始化头部刷新控件
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderGif:header];
    self.header= header;
    mainTableView.mj_header = header;
    
    YZMineHeaderView * headerView = [[YZMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 146 + 58)];
    self.headerView = headerView;
    headerView.delegate = self;
    mainTableView.tableHeaderView = headerView;
}
- (void)settingBarClick
{
    YZMineSettingViewController * settingVC = [[YZMineSettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
//刷新
- (void)headerRefreshViewBeginRefreshing
{
    [self loadUserInfo];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.functions.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * array = self.functions[section];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZMineFunctionTableViewCell * cell = [YZMineFunctionTableViewCell cellWithTableView:tableView];
    NSArray * array = self.functions[indexPath.section];
    YZFunctionStatus * status = array[indexPath.row];
    cell.status = status;
    if (status == [array lastObject]) {//最后一个不显示分割线
        cell.line.hidden = YES;
    }else
    {
        cell.line.hidden = NO;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YZCellH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
//        if (indexPath.row == 0) {//积分兑换
//            YZIntegralConversionViewController * integralConversionVC = [[YZIntegralConversionViewController alloc]init];
//            [self.navigationController pushViewController:integralConversionVC animated:YES];
        if (indexPath.row == 0) {//资金明细
            YZMoneyDetailViewController *moneyDetailVC = [[YZMoneyDetailViewController alloc]init];
            [self.navigationController pushViewController:moneyDetailVC animated:YES];
        }else if (indexPath.row == 1) {//充值记录
            YZRechargeRecordViewController * rechargeRecordVC = [[YZRechargeRecordViewController alloc]init];
            [self.navigationController pushViewController:rechargeRecordVC animated:YES];
        }else if (indexPath.row == 2)//提现记录
        {
            YZWithdrawalRecordViewController * withdrawalRecordVC = [[YZWithdrawalRecordViewController alloc]init];
            [self.navigationController pushViewController:withdrawalRecordVC animated:YES];
        }
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {//分享
            BOOL share_open = [YZUserDefaultTool getIntForKey:@"share_open"];
            if (share_open) {
                YZShareProfitsViewController * shareVC = [[YZShareProfitsViewController alloc] init];
                [self.navigationController pushViewController:shareVC animated:YES];
            }else{
                [self share];
            }
        }else if (indexPath.row == 1) {//消息中心
            YZMessageViewController * messageVC = [[YZMessageViewController alloc]init];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
    }else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {//购彩帮助
            YZLoadHtmlFileController *htmlVc1 = [[YZLoadHtmlFileController alloc] initWithFileName:@"help.htm"];
            htmlVc1.title = @"购彩帮助";
            [self.navigationController pushViewController:htmlVc1 animated:YES];
        }else if (indexPath.row == 1)//关于我们
        {
            YZLoadHtmlFileController *htmlVc1 = [[YZLoadHtmlFileController alloc] initWithFileName:@"about.htm"];
            htmlVc1.title = @"关于我们";
            [self.navigationController pushViewController:htmlVc1 animated:YES];
        }else if (indexPath.row == 2)//在线客服
        {
            [self goChatVC];
        }else if (indexPath.row == 3)//客服电话
        {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-700-1898"];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            [self.view addSubview:callWebview];
        }else if (indexPath.row == 4)//微信公众号
        {
            YZWeChatPublicViewController * weChatPublicVC = [[YZWeChatPublicViewController alloc]init];
            [self.navigationController pushViewController:weChatPublicVC animated:YES];
        }
    }
}

- (void)goChatVC
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

#pragma mark - cell delegate
- (void)mineHeaderViewDidClick
{
    YZAccountInfoViewController * accountInfoVC = [[YZAccountInfoViewController alloc]init];
    [self.navigationController pushViewController:accountInfoVC animated:YES];
}
- (void)mineDetailTableViewCellDidClickAvatar
{
    YZChooseAvatarView * chooseAvatarView = [[YZChooseAvatarView alloc]init];
    [chooseAvatarView show];
    chooseAvatarView.block = ^(NSInteger index){
        self.headerView.avatar.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%ld",(long)index]];
    };
}
- (void)mineRechargeTableViewCellDidClickBtn:(UIButton *)button
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
#pragma mark - 初始化
- (NSArray *)functions
{
    if (_functions == nil) {
//        YZFunctionStatus * status11 = [[YZFunctionStatus alloc]init];
//        status11.title = @"积分兑换";
//        status11.icon = @"mine_money_detail_icon";
        
        YZFunctionStatus * status12 = [[YZFunctionStatus alloc]init];
        status12.title = @"资金明细";
        status12.icon = @"mine_money_detail_icon";
        
        YZFunctionStatus * status13 = [[YZFunctionStatus alloc]init];
        status13.title = @"充值记录";
        status13.icon = @"mine_recharge_record_icon";
        
        YZFunctionStatus * status14 = [[YZFunctionStatus alloc]init];
        status14.title = @"提款记录";
        status14.icon = @"mine_withdrawal_record_icon";
        
        NSArray * array1 = @[status12, status13, status14];
        
        BOOL share_open = [YZUserDefaultTool getIntForKey:@"share_open"];
        YZFunctionStatus * status21 = [[YZFunctionStatus alloc]init];
        if (share_open) {
            status21.title = @"分享好友赚钱";
        }else
        {
            status21.title = @"好友分享";
        }
        status21.icon = @"mine_share_icon";
        
        YZFunctionStatus * status22 = [[YZFunctionStatus alloc]init];
        status22.title = @"消息中心";
        status22.icon = @"mine_message_icon";
        
        NSArray * array2 = @[status21,status22];
        YZFunctionStatus * status31 = [[YZFunctionStatus alloc]init];
        status31.title = @"购彩帮助";
        status31.icon = @"mine_help_icon";
        
        YZFunctionStatus * status32 = [[YZFunctionStatus alloc]init];
        status32.title = @"关于我们";
        status32.icon = @"mine_about_icon";
        
        YZFunctionStatus * status33 = [[YZFunctionStatus alloc]init];
        status33.title = @"在线客服";
        status33.icon = @"mine_contact_service_icon";
        
        YZFunctionStatus * status34 = [[YZFunctionStatus alloc]init];
        status34.title = @"客服电话";
        status34.icon = @"mine_contact_service_phone_icon";
        
        YZFunctionStatus * status35 = [[YZFunctionStatus alloc]init];
        status35.title = @"微信公众号";
        status35.icon = @"weixin_code_icon";
        
        NSArray * array3 = @[status31, status32, status33, status34, status35];
        
        _functions = @[array1,array2,array3];
    }
    return _functions;
}
#pragma mark - 分享
- (void)share
{
    YZShareView * shareView = [[YZShareView alloc]init];
    [shareView show];
    shareView.block = ^(UMSocialPlatformType platformType){//选择平台
        [self shareImageToPlatformType:platformType];
    };
}
//分享图片
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType
{
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    if (platformType == UMSocialPlatformType_Sms) {//短信
        messageObject.text = @"屌丝咋变高富帅？快用九歌买彩票:http://t.cn/RfRPgBu";
    }else
    {
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"屌丝咋变高富帅？快用九歌买彩票" descr:@"手机买彩票，随时随地享受中奖乐趣！福彩、体彩、足球彩… …" thumImage:[UIImage imageNamed:@"logo"]];
        shareObject.webpageUrl = [NSString stringWithFormat:@"%@%@", baseH5Url, @"/zhongcai/html/adele.html"];
        messageObject.shareObject = shareObject;
    }
    
#if JG
    [WXApi registerApp:WXAppIdOld withDescription:@"九歌彩票"];
#elif ZC
    [WXApi registerApp:WXAppIdOld withDescription:@"中彩啦"];
#elif CS
    [WXApi registerApp:WXAppIdOld withDescription:@"财多多"];
#endif
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSInteger errorCode = error.code;
            if (errorCode == 2003) {
                [MBProgressHUD showError:@"分享失败"];
            }else if (errorCode == 2008)
            {
                [MBProgressHUD showError:@"应用未安装"];
            }else if (errorCode == 2010)
            {
                [MBProgressHUD showError:@"网络异常"];
            }
        }
    }];
}

@end
