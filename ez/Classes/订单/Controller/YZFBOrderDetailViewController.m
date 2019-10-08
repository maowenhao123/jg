//
//  YZFBOrderDetailViewController.m
//  ez
//
//  Created by apple on 16/10/8.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define orderInfoLabelH 27
#define orderInfoLabelCount 6

#import "YZFBOrderDetailViewController.h"
#import "YZFBTicketDetailViewController.h"
#import "YZFbOrderDetailTableViewCell.h"
#import "YZBbOrderDetailTableViewCell.h"
#import "YZFBOrderStatus.h"
#import "YZOrder.h"
#import "YZShareView.h"
#import <UMSocialCore/UMSocialCore.h>
#import "WXApi.h"

@interface YZFBOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) YZOrder *order;//订单
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UIView * headerView;
@property (nonatomic, weak) UIImageView * logoImageView;
@property (nonatomic, weak) UILabel * playTypeNameLabel;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView * orderInfoView;
@property (nonatomic, strong) NSMutableArray *orderInfoLabels;//订单信息的label数组
@property (nonatomic, weak) UIImageView *ticketImageView;
@property (nonatomic, weak) UILabel * orderStatusLabel;

@end

@implementation YZFBOrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"投注详情";
    [self getOrderDetailData];
    [self setupChilds];
    waitingView_loadingData;
}

#pragma mark - 获取订单明细
- (void)getOrderDetailData
{
    NSDictionary *dict = @{
                           @"cmd":@(8035),
                           @"orderId":self.orderId
                           };
    
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"json = %@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            [self setDataArrayByJson:json];
        }else
        {
            [MBProgressHUD showError:json[@"retDesc"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"getOrderDetailData - error = %@",error);
    }];
}
- (void)setDataArrayByJson:(id)json
{
    self.order = [YZOrder objectWithKeyValues:json[@"order"]];
    NSDictionary * terms = json[@"terms"];
    NSMutableArray * orderCodes = [NSMutableArray arrayWithArray:terms.allKeys];
    NSMutableArray * orderCodes_sort = [self sortArray:orderCodes];
    for (int i = 0; i < orderCodes_sort.count; i++) {
        YZFBOrderStatus * status = [[YZFBOrderStatus alloc]init];
        NSString * code = orderCodes_sort[i];
        NSDictionary * term = terms[code];
        status.gameId = self.order.gameId;
        status.codes = self.order.codes;
        status.termValue = term;
        [self.dataArray addObject:status];
    }
    [self.tableView reloadData];
}
#pragma mark - 布局视图
- (void)setupChilds
{
    //分享
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"order_share"] style:UIBarButtonItemStylePlain target:self action:@selector(share)];
#if RR
    self.navigationItem.rightBarButtonItem = nil;
#endif
    CGFloat tableViewH = screenHeight - statusBarH - navBarH - 40 - [YZTool getSafeAreaBottom];
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, tableViewH)];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    
    //顶部视图
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50 + 5 + orderInfoLabelH * orderInfoLabelCount + 7 * 2 + 10)];
    self.headerView = headerView;
    headerView.backgroundColor = YZBackgroundColor;
    
    //玩法信息
    UIView * playTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    playTypeView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:playTypeView];
    
    UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7.5, 35, 35)];
    self.logoImageView = logoImageView;
    [playTypeView addSubview:logoImageView];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 49, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [headerView addSubview:line];
    
    UILabel * playTypeNameLabel = [[UILabel alloc]init];
    self.playTypeNameLabel = playTypeNameLabel;
    playTypeNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    playTypeNameLabel.textColor = YZBlackTextColor;
    [playTypeView addSubview:playTypeNameLabel];

    UILabel * orderStatusLabel = [[UILabel alloc]init];
    self.orderStatusLabel = orderStatusLabel;
    orderStatusLabel.textColor = YZGrayTextColor;
    orderStatusLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [playTypeView addSubview:orderStatusLabel];
    
    //竞彩足球信息
    CGFloat orderInfoViewY = CGRectGetMaxY(playTypeView.frame);
    UIView * orderInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, orderInfoViewY, screenWidth, orderInfoLabelH * orderInfoLabelCount + 7 * 2)];
    self.orderInfoView = orderInfoView;
    orderInfoView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:orderInfoView];
    
    for (int i = 0; i < orderInfoLabelCount; i++) {
        UILabel * orderInfoLabel = [[UILabel alloc]init];
        orderInfoLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        orderInfoLabel.textColor = YZBlackTextColor;
        orderInfoLabel.numberOfLines = 0;
        [orderInfoView addSubview:orderInfoLabel];
        
        [self.orderInfoLabels addObject:orderInfoLabel];
    }

    CGFloat ticketImageViewWH = 50;
    UIImageView * ticketImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - ticketImageViewWH - 15, 7, ticketImageViewWH, ticketImageViewWH)];
    self.ticketImageView = ticketImageView;
    [orderInfoView addSubview:ticketImageView];
    
    tableView.tableHeaderView = headerView;
    
    //出票明细
    UIButton * tickDetailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    tickDetailButton.frame = CGRectMake(0, screenHeight - statusBarH - navBarH - 40 - [YZTool getSafeAreaBottom], screenWidth, 40);
    tickDetailButton.backgroundColor = [UIColor whiteColor];
    [tickDetailButton setTitle:@"出票明细" forState:UIControlStateNormal];
    [tickDetailButton setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    tickDetailButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [tickDetailButton addTarget:self action:@selector(tickDetailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tickDetailButton];
    
    UIView * btnLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    btnLine.backgroundColor = YZWhiteLineColor;
    [tickDetailButton addSubview:btnLine];
}
- (void)tickDetailButtonClick
{
    YZFBTicketDetailViewController * ticketDetailVC = [[YZFBTicketDetailViewController alloc]init];
    ticketDetailVC.orderId = self.orderId;
    [self.navigationController pushViewController:ticketDetailVC animated:YES];
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_order.gameId isEqualToString:@"T51"]) {
        YZFbOrderDetailTableViewCell * cell = [YZFbOrderDetailTableViewCell cellWithTableView:tableView];
        cell.status = self.dataArray[indexPath.row];
        return cell;
    }else if ([_order.gameId isEqualToString:@"T52"])
    {
        YZBbOrderDetailTableViewCell * cell = [YZBbOrderDetailTableViewCell cellWithTableView:tableView];
        cell.status = self.dataArray[indexPath.row];
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZFBOrderStatus * status = self.dataArray[indexPath.row];
    if ([_order.gameId isEqualToString:@"T51"]) {
        return status.cellH;
    }else if ([_order.gameId isEqualToString:@"T52"])
    {
        return status.bBCellH;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 27)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    NSArray * labelWs = @[@0.5,@0.2,@0.3];
    UILabel * lastLabel;
    NSArray *titles;
    if ([_order.gameId isEqualToString:@"T51"]) {
        titles = @[@"主队VS客队",@"赛果",@"您的投注"];
    }else if ([_order.gameId isEqualToString:@"T52"])
    {
        titles = @[@"主队VS客队",@"比分",@"您的投注"];
    }
    for (int i = 0; i < titles.count; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, [labelWs[i] floatValue] * screenWidth, 27)];
        label.text = titles[i];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        label.textColor = YZBlackTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
        lastLabel = label;
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastLabel.frame) - lineWidth, 0, lineWidth, 27)];
        line.backgroundColor = YZGrayTextColor;
        [headerView addSubview:line];
    }
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, lineWidth)];
    line1.backgroundColor = YZGrayTextColor;
    [headerView addSubview:line1];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 27 - lineWidth, screenWidth, lineWidth)];
    line2.backgroundColor = YZGrayTextColor;
    [headerView addSubview:line2];
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, lineWidth, 27)];
    line3.backgroundColor = YZGrayTextColor;
    [headerView addSubview:line3];
    
    return headerView;
}
#pragma mark - 设置数据
- (void)setOrder:(YZOrder *)order
{
    _order = order;
    self.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",_order.gameId]];
    self.playTypeNameLabel.text = [YZTool gameIdNameDict][_order.gameId];
    CGSize playTypeNameSize = [self.playTypeNameLabel.text sizeWithLabelFont:self.playTypeNameLabel.font];
    self.playTypeNameLabel.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + YZMargin, 10, playTypeNameSize.width, 30);
    
    //是否中奖
    float bonus = [_order.bonus intValue] / 100.0;
    if(bonus > 0)
    {
        self.orderStatusLabel.text = [NSString stringWithFormat:@"中奖：%.2f元",bonus];
        self.orderStatusLabel.textColor = YZRedTextColor;
    }else
    {
        self.orderStatusLabel.text = self.order.ishitDesc;
        self.orderStatusLabel.textColor = YZGrayTextColor;
    }
    CGSize orderStatusSize = [self.orderStatusLabel.text sizeWithLabelFont:self.orderStatusLabel.font];
    self.orderStatusLabel.frame = CGRectMake(screenWidth - orderStatusSize.width - 10, 10, orderStatusSize.width, 30);
    //追号信息
    UILabel * lastOrderInfoLabel;
    for (UILabel * orderInfoLabel in self.orderInfoLabels) {
        NSInteger index = [self.orderInfoLabels indexOfObject:orderInfoLabel];
        if (index == 0) {
            orderInfoLabel.text = [NSString stringWithFormat:@"投注金额：%.2f元",[order.amount intValue] / 100.0];
        }else if (index == 1)
        {
            if ([_order.gameId isEqualToString:@"T51"]) {
                orderInfoLabel.text = [NSString stringWithFormat:@"投注玩法：%@",[YZTool footBallPlayTypeDic][order.playType]];
            }else if ([_order.gameId isEqualToString:@"T52"])
            {
                orderInfoLabel.text = [NSString stringWithFormat:@"投注玩法：%@",[YZTool basketBallPlayTypeDic][order.playType]];
            }
        }else if (index == 2)
        {
            NSArray *passWayCodes = [_order.betType componentsSeparatedByString:@","];
            NSString *passWaysString = [self getPassWaysString:passWayCodes];
            orderInfoLabel.text = [NSString stringWithFormat:@"过关方式：%@",passWaysString];
        }else if (index == 3)
        {
            orderInfoLabel.text = [NSString stringWithFormat:@"投注信息：%@注 %@倍",order.count,order.multiple];
        }else if (index == 4)
        {
            orderInfoLabel.text = [NSString stringWithFormat:@"投注时间：%@",order.createTime];
        }else if (index == 5)
        {
            orderInfoLabel.text = [NSString stringWithFormat:@"订单编号：%@",order.orderId];
        }
        CGSize orderInfoLabelSize = [orderInfoLabel.text sizeWithFont:orderInfoLabel.font maxSize:CGSizeMake(screenWidth - YZMargin - 70, MAXFLOAT)];
        CGFloat orderInfoLabelY = CGRectGetMaxY(lastOrderInfoLabel.frame);
        orderInfoLabelY = (orderInfoLabelY == 0 ? 7 : orderInfoLabelY);
        CGFloat _orderInfoLabelH = orderInfoLabelSize.height < orderInfoLabelH ? orderInfoLabelH : orderInfoLabelSize.height;
        orderInfoLabel.frame = CGRectMake(YZMargin, orderInfoLabelY, orderInfoLabelSize.width, _orderInfoLabelH);
        lastOrderInfoLabel = orderInfoLabel;
    }
    CGFloat orderInfoViewH = CGRectGetMaxY(lastOrderInfoLabel.frame) + 7;
    self.headerView.frame = CGRectMake(0, 0, screenWidth, 50 + orderInfoViewH + 10);
    self.orderInfoView.frame = CGRectMake(0, 50, screenWidth, orderInfoViewH);
    self.tableView.tableHeaderView = self.headerView;
    
    if ([_order.status intValue] == 2)//出票中
    {
        self.ticketImageView.image = [UIImage imageNamed:@"ticket_chupiaozhong"];
    }else if ([_order.status intValue] == 3)//出票成功
    {
        self.ticketImageView.image = [UIImage imageNamed:@"ticket_chengong"];
    }else if ([_order.status intValue] == 4)//出票失败
    {
        self.ticketImageView.image = [UIImage imageNamed:@"ticket_shibai"];
    }else if ([_order.status intValue] == 5)//部分出票
    {
        self.ticketImageView.image = [UIImage imageNamed:@"ticket_bufen"];
    }
}
#pragma mark - 初始化
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)orderInfoLabels
{
    if (_orderInfoLabels == nil) {
        _orderInfoLabels = [NSMutableArray array];
    }
    return _orderInfoLabels;
}
#pragma mark - 工具
- (NSMutableArray *)sortArray:(NSMutableArray *)mutableArray
{
    if(mutableArray.count == 1) return mutableArray;
    for(int i = 0;i < mutableArray.count;i++)
    {
        for(int j = i + 1;j <mutableArray.count;j++)
        {
            NSString * code1 = mutableArray[i];
            NSString * code2 = mutableArray[j];
            long long number1 = [code1 longLongValue];
            long long number2 = [code2 longLongValue];
            if(number1 > number2)
            {
                [mutableArray exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }
    }
    return mutableArray;
}
- (NSString *)getPassWaysString:(NSArray *)passWayCodes
{
    NSMutableString *passWaysString = [NSMutableString string];
    for(NSString *passWay in passWayCodes)
    {
        [passWaysString appendString:[NSString stringWithFormat:@"%@ ",[YZTool passWayDict][passWay]]];
    }
    return [passWaysString copy];
}
#pragma mark - 分享
- (void)share
{
    YZUser *user = [YZUserDefaultTool user];
    NSDictionary *dict = @{
                           @"gameId":self.order.gameId,
                           @"userName":user.userName
                           };
    waitingView;
    [[YZHttpTool shareInstance] postWithURL:BaseUrlShare(@"/getShareOrder") params:dict success:^(id json) {
        YZLog(@"getShareOrder:%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            YZShareView * shareView = [[YZShareView alloc]init];
            [shareView show];
            shareView.block = ^(UMSocialPlatformType platformType){//选择平台
                [self shareImageToPlatformType:platformType json:json];
            };
        }
    } failure:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view];
         YZLog(@"error = %@",error);
     }];
}
- (void)shareImageToPlatformType:(UMSocialPlatformType)platformType json:(id)json
{
    NSString * title;
    NSString * descr;
    //是否中奖
    float bonus = [self.order.bonus intValue] / 100.0;
    float amount = [self.order.amount intValue] / 100.0;
    if(bonus > 0)
    {
        title = [NSString stringWithFormat:@"%@", json[@"hitTitle"]];
        descr = [[NSString stringWithFormat:@"%@", json[@"hitDesc"]] stringByReplacingOccurrencesOfString:@"hitmoney" withString:[NSString stringWithFormat:@"%.2f",bonus]];
    }else
    {
        title = [NSString stringWithFormat:@"%@", json[@"unHitTitle"]];
        descr = [[NSString stringWithFormat:@"%@", json[@"unHitDesc"]] stringByReplacingOccurrencesOfString:@"stakemoney" withString:[NSString stringWithFormat:@"%.2f",amount]];
    }
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
#if JG
    UIImage * image = [UIImage imageNamed:@"logo"];
#elif ZC
    UIImage * image = [UIImage imageNamed:@"logo1"];
#elif CS
    UIImage * image = [UIImage imageNamed:@"logo1"];
#elif RR
    UIImage * image = [UIImage imageNamed:@"logo1"];
#endif
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:image];
    shareObject.webpageUrl = json[@"url"];
    messageObject.shareObject = shareObject;//调用分享接口
#if JG
    [WXApi registerApp:WXAppIdOld withDescription:@"九歌彩票"];
#elif ZC
    [WXApi registerApp:WXAppIdOld withDescription:@"中彩啦"];
#elif CS
    [WXApi registerApp:WXAppIdOld withDescription:@"财多多"];
#elif RR
    [WXApi registerApp:WXAppIdOld withDescription:@"人人彩"];
#endif
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
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
