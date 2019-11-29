//
//  YZRechargeListViewController.m
//  ez
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZRechargeListViewController.h"
#import "YZVoucherViewController.h"
#import "YZBankRemitController.h"
#import "YZLoadHtmlFileController.h"
#import "YZPhoneCardRechargeViewController.h"
#import "YZZhifubaoNewRechargeViewController.h"
#import "YZZhifubaoRechargeViewController.h"
#import "YZWeixinRechargeViewController.h"
#import "YZHtmlRechargeViewController.h"
#import "YZBankCardRechargeViewController.h"
#import "YZUPPayPluginRechargeViewController.h"
#import "YZBonusCardRechargeViewController.h"
#import "YZErCodeRechargeViewController.h"
#import "YZRechargeTableViewCell.h"
#import "YZRechargeStatus.h"

@interface YZRechargeListViewController ()

@property (nonatomic, strong) NSMutableArray *statusArray;//数据模型数组
@property (nonatomic, weak) MJRefreshGifHeader *header;

@end

@implementation YZRechargeListViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if ([super initWithStyle:style])
    {
        self.tableView.backgroundColor = YZBackgroundColor;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        //初始化头部刷新控件
        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
        [YZTool setRefreshHeaderData:header];
        self.header = header;
        self.tableView.mj_header = header;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"充值";
    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithIcon:@"back_btn_flat" highIcon:@"back_btn_flat" target:self action:@selector(back)];
    waitingView_loadingData;
    [self getData];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)headerRefreshViewBeginRefreshing
{
    [self.statusArray removeAllObjects];
    [self getData];
}
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self headerRefreshViewBeginRefreshing];
}
- (void)getData
{
    NSDictionary *dict = @{
                           @"version":@"0.0.2"
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlSalesManager(@"/getPaymentList") params:dict success:^(id json) {
        YZLog(@"getPromotionList:%@",json);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (SUCCESS){
            NSArray * paymentArray = [YZRechargeStatus objectArrayWithKeyValuesArray:json[@"payment"]];
            [self setStatusArrayByArray:paymentArray];
            [self.tableView reloadData];
            [self.header endRefreshing];
        }else
        {
            ShowErrorView;
            [self.tableView reloadData];
            [self.header endRefreshing];
        }
    }failure:^(NSError *error)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
        [self.header endRefreshing];
         YZLog(@"error = %@",error);
    }];
}
- (void)setStatusArrayByArray:(NSArray *)paymentArray
{
    NSMutableArray * statusArray = [NSMutableArray array];
    for (YZRechargeStatus * status in paymentArray) {
        if (status.status == 2) {//启用的才添加
            if ([status.clientId isEqualToString:@"jiuge_alipytransfer"] || [status.clientId isEqualToString:@"zhongcai_alipytransfer"] || [status.clientId isEqualToString:@"zhongcai_alipay_app"] || [status.clientId isEqualToString:@"jiuge_alipay_qr"] || [status.clientId isEqualToString:@"jiuge_lftpay_alipay_qr"] || [status.clientId isEqualToString:@"plbpay_alipay_h5"] || [status.clientId isEqualToString:@"alipytransfer"] || [status.clientId isEqualToString:@"alipay_img_qr"])//支付宝
            {
                status.imageName = @"rechagre_zhifubao_icon";
                status.title = status.name;
                [statusArray addObject:status];
            }
            else if ([status.clientId isEqualToString:@"jiuge_ziweixing_wx"] || [status.clientId isEqualToString:@"zhongcai_ziweixing_wx"] || [status.clientId isEqualToString:@"plbpay_weixin_h5"] || [status.clientId isEqualToString:@"jiuge_lftpay_weixin_qr"] || [status.clientId isEqualToString:@"weixin_qr"])//微信
            {
                status.imageName = @"recharge_weixin_icon";
                status.title = status.name;
                [statusArray addObject:status];
            }
            else if ([status.clientId isEqualToString:@"zhongcai_lianlian_app"] || [status.clientId isEqualToString:@"jiuge_banktransfer"] || [status.clientId isEqualToString:@"zhongcai_banktransfer"] || [status.clientId isEqualToString:@"web"])//银行
            {
                status.imageName = @"recharge_bankcard_icon";
                status.title = status.name;
                [statusArray addObject:status];
            }
            else if ([status.clientId isEqualToString:@"jiuge_couponscard"])//彩金卡充值
            {
                status.imageName = @"recharge_bonuscard_icon";
                status.title = status.name;
                [statusArray addObject:status];
            }
            else if ([status.clientId isEqualToString:@"jiuge_telecard"])//手机充值卡充值
            {
                status.imageName = @"recharge_phonecard_icon";
                status.title = status.name;
                [statusArray addObject:status];
            }
            else if ([status.clientId isEqualToString:@"jiuge_unionpay"] || [status.clientId isEqualToString:@"unionpay_qr"] || [status.clientId isEqualToString:@"common_wap"])//银联支付
            {
                status.imageName = @"recharge_upay_icon";
                status.title = status.name;
                [statusArray addObject:status];
            }else if ([status.clientId isEqualToString:@"qq_qr"])//qq支付
            {
                status.imageName = @"recharge_qq_icon";
                status.title = status.name;
                [statusArray addObject:status];
            }
            else if ([status.clientId isEqualToString:@"jd_qr"])//京东支付
            {
                status.imageName = @"recharge_jd_icon";
                status.title = status.name;
                [statusArray addObject:status];
            }
        }
    }
    self.statusArray = statusArray;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZRechargeTableViewCell * cell = [YZRechargeTableViewCell cellWithTableView:tableView];
    YZRechargeStatus *status = self.statusArray[indexPath.row];
    cell.status = status;
    if (status == [self.statusArray lastObject]) {
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
    
    YZRechargeStatus *status = self.statusArray[indexPath.row];
    if([status.clientId isEqualToString:@"jiuge_ziweixing_wx"] || [status.clientId isEqualToString:@"zhongcai_ziweixing_wx"] || [status.clientId isEqualToString:@"plbpay_weixin_h5"])//微信支付
    {
        YZWeixinRechargeViewController *weixinRechargeVc = [[YZWeixinRechargeViewController alloc] init];
        weixinRechargeVc.paymentId = status.paymentId;
        weixinRechargeVc.isOrderPay = self.isOrderPay;
        weixinRechargeVc.clientId = status.clientId;
        weixinRechargeVc.detailUrl = status.detailUrl;
        weixinRechargeVc.intro = status.intro;
        if ([status.clientId isEqualToString:@"plbpay_weixin_h5"]) {
            weixinRechargeVc.url = status.url;
        }
        [self.navigationController pushViewController:weixinRechargeVc animated:YES];
    }else if ([status.clientId isEqualToString:@"jiuge_alipytransfer"] || [status.clientId isEqualToString:@"zhongcai_alipytransfer"])//支付宝转账
    {
        YZZhifubaoNewRechargeViewController *zhifubaoNewRechargeVc = [[YZZhifubaoNewRechargeViewController alloc] init];
        zhifubaoNewRechargeVc.detailUrl = status.detailUrl;
        zhifubaoNewRechargeVc.intro = status.intro;
        [self.navigationController pushViewController:zhifubaoNewRechargeVc animated:YES];
    }else if([status.clientId isEqualToString:@"zhongcai_alipay_app"] || [status.clientId isEqualToString:@"jiuge_alipay_qr"] || [status.clientId isEqualToString:@"jiuge_lftpay_alipay_qr"] || [status.clientId isEqualToString:@"plbpay_alipay_h5"])//支付宝充值
    {
        YZZhifubaoRechargeViewController *zhifubaoRechargeVc = [[YZZhifubaoRechargeViewController alloc]init];
        zhifubaoRechargeVc.paymentId = status.paymentId;
        zhifubaoRechargeVc.clientId = status.clientId;
        zhifubaoRechargeVc.isOrderPay = self.isOrderPay;
        zhifubaoRechargeVc.detailUrl = status.detailUrl;
        zhifubaoRechargeVc.intro = status.intro;
        if ([status.clientId isEqualToString:@"plbpay_alipay_h5"]) {
            zhifubaoRechargeVc.url = status.url;
        }
        [self.navigationController pushViewController:zhifubaoRechargeVc animated:YES];
    }else if ([status.clientId isEqualToString:@"jiuge_lftpay_weixin_qr"] || [status.clientId isEqualToString:@"alipay_img_qr"])//二维码充值
    {
        YZErCodeRechargeViewController *erCodeRechargeVc = [[YZErCodeRechargeViewController alloc] init];
        erCodeRechargeVc.paymentId = status.paymentId;
        erCodeRechargeVc.clientId = status.clientId;
        erCodeRechargeVc.detailUrl = status.detailUrl;
        erCodeRechargeVc.intro = status.intro;
        [self.navigationController pushViewController:erCodeRechargeVc animated:YES];
    }else if([status.clientId isEqualToString:@"weixin_qr"] || [status.clientId isEqualToString:@"qq_qr"] || [status.clientId isEqualToString:@"jd_qr"] || [status.clientId isEqualToString:@"unionpay_qr"] || [status.clientId isEqualToString:@"common_wap"])//html充值
    {
        YZHtmlRechargeViewController *htmlRechargeVc = [[YZHtmlRechargeViewController alloc] init];
        htmlRechargeVc.title = status.name;
        htmlRechargeVc.paymentId = status.paymentId;
        htmlRechargeVc.goBrowser = [status.clientId isEqualToString:@"common_wap"];
        htmlRechargeVc.detailUrl = status.detailUrl;
        htmlRechargeVc.intro = status.intro;
        [self.navigationController pushViewController:htmlRechargeVc animated:YES];
    }else if([status.clientId isEqualToString:@"zhongcai_lianlian_app"])//银行卡支付(连连支付)
    {
        YZBankCardRechargeViewController *phoneCardRechargeVc = [[YZBankCardRechargeViewController alloc] init];
        phoneCardRechargeVc.paymentId = status.paymentId;
        phoneCardRechargeVc.isOrderPay = self.isOrderPay;
        phoneCardRechargeVc.detailUrl = status.detailUrl;
        phoneCardRechargeVc.intro = status.intro;
        [self.navigationController pushViewController:phoneCardRechargeVc animated:YES];
    }else if([status.clientId isEqualToString:@"jiuge_banktransfer"] || [status.clientId isEqualToString:@"zhongcai_banktransfer"])//银行汇款
    {
        YZBankRemitController *bankRemitRechargeVc = [[YZBankRemitController alloc]init];
        bankRemitRechargeVc.detailUrl = status.detailUrl;
        bankRemitRechargeVc.intro = status.intro;
        [self.navigationController pushViewController:bankRemitRechargeVc animated:YES];
    }else if([status.clientId isEqualToString:@"jiuge_couponscard"])//彩金卡充值 
    {
        YZBonusCardRechargeViewController *bonusCardRechargeVc = [[YZBonusCardRechargeViewController alloc]init];
        bonusCardRechargeVc.isOrderPay = self.isOrderPay;
        bonusCardRechargeVc.detailUrl = status.detailUrl;
        bonusCardRechargeVc.intro = status.intro;
        [self.navigationController pushViewController:bonusCardRechargeVc animated:YES];
    }else if([status.clientId isEqualToString:@"jiuge_telecard"])//手机充值卡充值
    {
        YZPhoneCardRechargeViewController *phoneCardRechargeVc = [[YZPhoneCardRechargeViewController alloc]init];
        phoneCardRechargeVc.isOrderPay = self.isOrderPay;
        phoneCardRechargeVc.detailUrl = status.detailUrl;
        phoneCardRechargeVc.intro = status.intro;
        [self.navigationController pushViewController:phoneCardRechargeVc animated:YES];
    }else if([status.clientId isEqualToString:@"jiuge_unionpay"])//银联支付
    {
        YZUPPayPluginRechargeViewController *uPPayPluginRechargeVc = [[YZUPPayPluginRechargeViewController alloc] init];
        uPPayPluginRechargeVc.paymentId = status.paymentId;
        uPPayPluginRechargeVc.isOrderPay = self.isOrderPay;
        uPPayPluginRechargeVc.detailUrl = status.detailUrl;
        uPPayPluginRechargeVc.intro = status.intro;
        [self.navigationController pushViewController:uPPayPluginRechargeVc animated:YES];
    }else if([status.clientId isEqualToString:@"alipytransfer"] || [status.clientId isEqualToString:@"web"])//H5页面
    {
        YZLoadHtmlFileController * updataActivityVC = [[YZLoadHtmlFileController alloc] initWithWeb:status.url];
        [self.navigationController pushViewController:updataActivityVC animated:YES];
    }
}
#pragma mark - 初始化
- (NSMutableArray *)statusArray
{
    if(_statusArray == nil)
    {
        _statusArray = [NSMutableArray array];
    }
    return _statusArray;
}

@end
