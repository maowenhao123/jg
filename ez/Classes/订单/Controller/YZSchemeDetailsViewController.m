//
//  YZSchemeListDetailViewController.m
//  ez
//
//  Created by apple on 16/9/30.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define orderInfoLabelH 22
#define orderInfoLabelCount 5

#import "YZSchemeDetailsViewController.h"
#import "YZRechargeListViewController.h"
#import "YZBetSuccessViewController.h"
#import "YZFCOrderDetailViewController.h"
#import "YZSchemeDetailTableViewCell.h"
#import "YZFastBetView.h"
#import "YZScheme.h"
#import "JSON.h"

@interface YZSchemeDetailsViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,YZFastBetViewDelegate>
{
    int _termCount;
    int _multiple;
    BOOL _winStop;
    int _pageIndex;
    
}
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIView * headerView;
@property (nonatomic, weak) MJRefreshGifHeader *header;
@property (nonatomic, weak) MJRefreshBackGifFooter *footer;
@property (nonatomic, weak) UIView * winView;//中奖视图
@property (nonatomic, weak) UIImageView * logoImageView;//logo
@property (nonatomic, weak) UILabel * playTypeNameLabel;//玩法名称
@property (nonatomic, weak) UILabel * bonusLabel;//奖金
@property (nonatomic, weak) UIView * orderInfoView;
@property (nonatomic, weak) UILabel *unhitReturnMoneyDescLabel;
@property (nonatomic, strong) NSMutableArray *orderInfoLabels;//订单信息的label数组
@property (nonatomic, weak) UIImageView * ticketImageView;//状态图标
@property (nonatomic, weak)  UIButton * betButton;
@property (nonatomic, strong) YZScheme *scheme;

@property (nonatomic, copy) NSString *currentTermId;
@property (nonatomic, strong) NSMutableArray *ticketList;//请求参数的号码数组
@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) YZFastBetView * fastBetView;

@end

@implementation YZSchemeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"追期详情";
    self.pageIndex = 0;
    [self setupChilds];
    waitingView_loadingData;
    [self getSchemeDetailData];
}
#pragma mark - 获取数据
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self headerRefreshViewBeginRefreshing];
}
- (void)getSchemeDetailData
{
    NSDictionary *dict = @{
                           @"cmd":@(8024),
                           @"schemeId":self.schemeId,
                           @"pageIndex":@(self.pageIndex),
                           @"pageSize" : @(10)
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        YZLog(@"json = %@",json);
        if(SUCCESS)
        {
            NSMutableArray * oldOrderList = self.scheme.orderList;//获取之前的orderList
            if (!oldOrderList || oldOrderList.count == 0) {
                oldOrderList = [NSMutableArray array];
            }
            self.scheme = [YZScheme objectWithKeyValues:json[@"scheme"]];
            NSArray * newOrderList = self.scheme.orderList;
            [oldOrderList addObjectsFromArray:newOrderList];//在之前的基础上添加新的orderList
            YZLog(@"orderListCount:%ld",oldOrderList.count);
            _scheme.orderList = oldOrderList;//重新给scheme的orderList赋值
            _termCount = [self.scheme.termCount intValue];
            _winStop = [self.scheme.winStop boolValue];
            for(int i = 0;i < _scheme.orderList.count;i ++)
            {
                YZOrder *order = _scheme.orderList[i];
                _multiple = [order.multiple intValue];
            }
            if (_termCount == 0) {
                _termCount = 1;
            }
            if (_multiple == 0) {
                _multiple = 1;
            }
            //结束刷新
            [self.tableView reloadData];
            [self.header endRefreshing];
            if (newOrderList.count == 0) {//没有新的数据
                [self.footer endRefreshingWithNoMoreData];
            }else
            {
                [self.footer endRefreshing];
            }
        }else
        {
            ShowErrorView
            [self.tableView reloadData];
            [self.header endRefreshing];
            [self.footer endRefreshing];
        }
        [self refreshUI];
        [MBProgressHUD hideHUDForView:self.view];
    } failure:^(NSError *error) {
        [self.tableView reloadData];
        [self.header endRefreshing];
        [self.footer endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"getSchemeDetailData - error = %@",error);
    }];
}
#pragma mark - 布局视图
- (void)setupChilds
{
    CGFloat tableViewH = screenHeight - statusBarH - navBarH - 40;
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, tableViewH)];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:tableView];
    
    //初始化头部刷新控件
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderData:header];
    self.header = header;
    tableView.mj_header = header;
    
    //初始化底部刷新控件
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshViewBeginRefreshing)];
    [YZTool setRefreshFooterData:footer];
    self.footer = footer;
    tableView.mj_footer = footer;
    //顶部视图
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50 + 5 + orderInfoLabelH * orderInfoLabelCount + 7 * 2 + 10)];
    self.headerView = headerView;
    headerView.backgroundColor = YZBackgroundColor;
    
    //玩法信息
    UIView * playTypeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    playTypeView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:playTypeView];
    
    UILabel * bonusLabel = [[UILabel alloc]init];
    self.bonusLabel = bonusLabel;
    bonusLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [playTypeView addSubview:bonusLabel];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 49, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [headerView addSubview:line];
    
    UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 7.5, 35, 35)];
    self.logoImageView = logoImageView;
    [playTypeView addSubview:logoImageView];
    
    UILabel * playTypeNameLabel = [[UILabel alloc]init];
    self.playTypeNameLabel = playTypeNameLabel;
    playTypeNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    playTypeNameLabel.textColor = YZBlackTextColor;
    [playTypeView addSubview:playTypeNameLabel];
    
    //追号信息
    CGFloat orderInfoViewY = CGRectGetMaxY(playTypeView.frame);
    UIView * orderInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, orderInfoViewY, screenWidth, orderInfoLabelH * orderInfoLabelCount + 7 * 2)];
    self.orderInfoView = orderInfoView;
    orderInfoView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:orderInfoView];
    
    //金额描述
    UILabel * unhitReturnMoneyDescLabel = [[UILabel alloc] init];
    self.unhitReturnMoneyDescLabel = unhitReturnMoneyDescLabel;
    unhitReturnMoneyDescLabel.textColor = YZRedTextColor;
    unhitReturnMoneyDescLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [orderInfoView addSubview:unhitReturnMoneyDescLabel];
    
    for (int i = 0; i < orderInfoLabelCount; i++) {
        UILabel * orderInfoLabel = [[UILabel alloc]init];
        orderInfoLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        orderInfoLabel.textColor = YZBlackTextColor;
        [orderInfoView addSubview:orderInfoLabel];
        
        [self.orderInfoLabels addObject:orderInfoLabel];
    }
    //状态图标
    CGFloat ticketImageViewWH = 50;
    UIImageView * ticketImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - ticketImageViewWH - 15, 7, ticketImageViewWH, ticketImageViewWH)];
    self.ticketImageView = ticketImageView;
    [orderInfoView addSubview:ticketImageView];
    
    tableView.tableHeaderView = headerView;
    
    //快速投注
    YZBottomButton * betButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.betButton = betButton;
    betButton.frame = CGRectMake(0, screenHeight - statusBarH - navBarH - 40, screenWidth, 40); 
    [betButton addTarget:self action:@selector(betButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:betButton];
    
    UIView * btnLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 0.5)];
    btnLine.backgroundColor = [UIColor lightGrayColor];
    [betButton addSubview:btnLine];
}
#pragma mark - 底部按钮点击
- (void)betButtonClick:(UIButton *)button
{
    if ([button.currentTitle isEqualToString:@"停止追号"]) {
        [self stopSchemeBtnDidClick];
    }else
    {
        [self ticketList];
        if ([_scheme.gameId isEqualToString:@"T05"] || [_scheme.gameId isEqualToString:@"T61"]  || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"] || [_scheme.gameId isEqualToString:@"F04"]) {//高频彩直接投注
            [self fastBetBtnClick];
        }else
        {
            UIView * backView = [[UIView alloc]initWithFrame:KEY_WINDOW.bounds];
            self.backView = backView;
            backView.backgroundColor =  YZColor(0, 0, 0, 0.4);
            [KEY_WINDOW addSubview:backView];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBackView) ];
            tap.delegate = self;
            [backView addGestureRecognizer:tap];
            
            YZFastBetView * fastBetView = [[YZFastBetView alloc]initWithFrame:CGRectMake(20, 100, screenWidth - 40, 260) amount:[self getSingleAmount] termNumber:_termCount multipleNumber:_multiple winStop:_winStop];
            self.fastBetView = fastBetView;
            fastBetView.center = KEY_WINDOW.center;
            fastBetView.delegate = self;
            [backView addSubview:fastBetView];
            
            fastBetView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            [UIView animateWithDuration:animateDuration animations:^{
                fastBetView.transform = CGAffineTransformMakeScale(1, 1);
            }];
        }
    }
}
- (void)removeBackView
{
    [self.backView removeFromSuperview];
}
//YZFastBetViewDelegate
- (void)FastBetViewCancelBtnClick
{
    [self removeBackView];
}
- (void)FastBetViewCancelBtnClickWithTermNumber:(int)termNumber multipleNumber:(int)multipleNumber winStop:(BOOL)winStop
{
    [self removeBackView];
    _termCount = termNumber;
    _multiple = multipleNumber;
    _winStop = winStop;
    [self getCurrentTermData];
}
- (void)FastBetViewgotoRecharge
{
    [self removeBackView];
    [self gotoRecharge];
}
//停止追号按钮点击
- (void)stopSchemeBtnDidClick
{
    [MBProgressHUD showMessage:@"客官请稍候" toView:self.view];
    NSDictionary *dict = @{
                           @"cmd":@(8025),
                           @"userId":UserId,
                           @"schemeId":self.schemeId,
                           };
    
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        
        YZLog(@"json = %@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            [MBProgressHUD showSuccess:@"已停追"];
            //重新刷新数据
            self.pageIndex = 0;
            [self.scheme.orderList removeAllObjects];
            [self getSchemeDetailData];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"stopScheme - error = %@",error);
    }];
}
#pragma  mark - MJRefreshBaseViewDelegate的代理方法
- (void)headerRefreshViewBeginRefreshing
{
    //清空数据
    self.pageIndex = 0;
    [self.scheme.orderList removeAllObjects];
    [self getSchemeDetailData];
}
- (void)footerRefreshViewBeginRefreshing
{
    self.pageIndex++;
    [self getSchemeDetailData];
}
#pragma mark - 设置数据
- (void)refreshUI
{
    //玩法信息
    self.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",self.scheme.gameId]];
    self.playTypeNameLabel.text = [YZTool gameIdNameDict][self.scheme.gameId];
  
    CGSize playTypeNameSize = [self.playTypeNameLabel.text sizeWithLabelFont:self.playTypeNameLabel.font];
    self.playTypeNameLabel.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 10, 15, playTypeNameSize.width, 30);
    float bonus = [self.scheme.bonus intValue] / 100.0;
    if(bonus > 0)
    {
        self.bonusLabel.text = [NSString stringWithFormat:@"%@：%.2f元",self.scheme.ishitDesc,bonus];
        self.bonusLabel.textColor = YZRedTextColor;
    }
    CGSize bonusSize = [self.bonusLabel.text sizeWithLabelFont:self.bonusLabel.font];
    self.bonusLabel.frame = CGRectMake(screenWidth - bonusSize.width - YZMargin, 10, bonusSize.width, 30);
    
    if (!YZStringIsEmpty(self.scheme.noHitDesc)) {
        self.unhitReturnMoneyDescLabel.text = self.scheme.noHitDesc;
        self.unhitReturnMoneyDescLabel.frame = CGRectMake(12, 7, screenWidth - 2 * 12, orderInfoLabelH);
    }else
    {
        self.unhitReturnMoneyDescLabel.frame = CGRectZero;
    }
    
    //追号信息
    UIView * lastLabel;
    for (UILabel * orderInfoLabel in self.orderInfoLabels) {
        NSInteger index = [self.orderInfoLabels indexOfObject:orderInfoLabel];
        if (index == 0) {
            orderInfoLabel.text = [NSString stringWithFormat:@"投注时间：%@",self.scheme.createTime];
        }else if (index == 1)
        {
            orderInfoLabel.text = [NSString stringWithFormat:@"追号金额：%.2f元",[self.scheme.amount floatValue] / 100];
        }else if (index == 2)
        {
            orderInfoLabel.text = [NSString stringWithFormat:@"中奖停追：%@",[self.scheme.winStop boolValue] ? @"是" : @"否"];
        }else if (index == 3)
        {
            orderInfoLabel.text = [NSString stringWithFormat:@"追号进度：已追%@期/共%@期",self.scheme.finishedTermCount,self.scheme.termCount];
        }else if (index == 4)
        {
            orderInfoLabel.text = [NSString stringWithFormat:@"订单编号：%@",self.schemeId];
        }
        CGSize orderInfoLabelSize = [orderInfoLabel.text sizeWithLabelFont:orderInfoLabel.font];
        CGFloat orderInfoLabelY = 7 + index * orderInfoLabelH;
        if (!YZStringIsEmpty(self.scheme.noHitDesc)) {
            orderInfoLabelY = CGRectGetMaxY(self.unhitReturnMoneyDescLabel.frame) + index * orderInfoLabelH;
        }
        orderInfoLabel.frame = CGRectMake(12, orderInfoLabelY, orderInfoLabelSize.width, orderInfoLabelH);
        lastLabel = orderInfoLabel;
    }
    self.orderInfoView.height = CGRectGetMaxY(lastLabel.frame) + 7;
    self.headerView.height = CGRectGetMaxY(self.orderInfoView.frame) + 10;
    self.tableView.tableHeaderView = self.headerView;
    
    [self.betButton setTitle:@"快速投注" forState:UIControlStateNormal];
    if ([_scheme.status intValue] == 1)//进行中
    {
        [self.betButton setTitle:@"停止追号" forState:UIControlStateNormal];
        self.ticketImageView.image = [UIImage imageNamed:@"ticket_zhuihaozhong"];
    }else if ([_scheme.status intValue] == 2)//已完成
    {
        self.ticketImageView.image = [UIImage imageNamed:@"ticket_wancheng"];
    }else if ([_scheme.status intValue] == 3)//已停追
    {
        self.ticketImageView.image = [UIImage imageNamed:@"ticket_tingzhui"];
    }else if ([_scheme.status intValue] == 4)//中奖已停追
    {
        self.ticketImageView.image = [UIImage imageNamed:@"ticket_zhongjiangtingzhui"];
    }else if ([_scheme.status intValue] == 6)//手动停追
    {
        self.ticketImageView.image = [UIImage imageNamed:@"ticket_shoudongtingzhui"];
    }
}
#pragma mark - tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.scheme.orderList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSchemeDetailTableViewCell *cell=[YZSchemeDetailTableViewCell cellWithTableView:tableView];
    cell.noLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row + 1];
    cell.status = self.scheme.orderList[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 27;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 27)];
    headerView.backgroundColor = [UIColor whiteColor];
    NSArray * titles = @[@"序号",@"期次",@"状态",@"中奖信息"];
    NSArray * labelWs = @[@0.15,@0.3,@0.25,@0.3];
    UILabel * lastLabel;
    for (int i = 0; i < titles.count; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, [labelWs[i] floatValue] * screenWidth, 27 - 1)];
        label.text = titles[i];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        label.textColor = YZBlackTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
        lastLabel = label;
    }
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 27 - 1, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [headerView addSubview:line];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YZOrder * order = self.scheme.orderList[indexPath.row];
    YZFCOrderDetailViewController * FCOrderDetailVC = [[YZFCOrderDetailViewController alloc]init];
    FCOrderDetailVC.gameId = self.gameId;
    FCOrderDetailVC.order = order;
    [self.navigationController pushViewController:FCOrderDetailVC animated:YES];
}
#pragma mark - 快速投注
- (void)fastBetBtnClick
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
    waitingView;
    NSDictionary *dict = @{
                           @"cmd":@(8006),
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            //存储用户信息
            YZUser *user = [YZUser objectWithKeyValues:json];
            [YZUserDefaultTool saveUser:user];
            [self showComfirmPayAlertView];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"账户error");
    }];
}

- (void)showComfirmPayAlertView
{
    float amount = [self getAmount];
    BOOL hasEnoughMoney = [YZTool hasEnoughMoneyWithAmountMoney:amount];
    if (hasEnoughMoney) {
        NSString * message = [YZTool getAlertViewTextWithAmountMoney:amount];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"支付确认" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getCurrentTermData];//当前期次的信息
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }else
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"余额不足" message:@"对不起，余额不足，请充值。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gotoRecharge];
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)gotoRecharge
{
    YZRechargeListViewController *rechargeVc = [[YZRechargeListViewController alloc] init];
    rechargeVc.isOrderPay = YES;
    [self.navigationController pushViewController:rechargeVc animated:YES];
}
//获取当前期次信息
- (void)getCurrentTermData
{
    [MBProgressHUD showMessage:text_gettingCurrentTerm toView:self.view];
    NSDictionary *dict = @{
                           @"cmd":@(8026),
                           @"gameId":_scheme.gameId
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            NSArray *termList = json[@"game"][@"termList"];
            if(!termList.count)
            {
                [MBProgressHUD showError:text_sailStop];
                return;
            }
            self.currentTermId = [termList lastObject][@"termId"];
            [self comfirmPay];//支付
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"获取当前期信息失败"];
        YZLog(@"getCurrentTermData - error = %@",error);
    }];
}
- (void)comfirmPay//支付接口
{
    [MBProgressHUD showMessage:text_paying toView:self.view];
    NSDictionary *dict = @{
                           @"cmd":@(8050),
                           @"userId":UserId,
                           @"gameId":_scheme.gameId,
                           @"termId":self.currentTermId,
                           @"multiple":@(_multiple),
                           @"ticketList":self.ticketList,
                           @"amount":@([self getAmount] * 100),
                           @"payType":@"ACCOUNT",
                           @"termCount":@(_termCount),
                           @"startTermId":self.currentTermId,
                           @"winStop":[NSNumber numberWithBool:_winStop]
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            [MBProgressHUD hideHUDForView:self.view];//隐藏正在支付的弹框
            YZBetSuccessViewController *betSuccessVc = [[YZBetSuccessViewController alloc] init];
            betSuccessVc.termCount = _termCount;
            //跳转
            [self.navigationController pushViewController:betSuccessVc animated:YES];
        }else
        {
            [MBProgressHUD hideHUDForView:self.view];//隐藏正在支付的弹框
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"error = %@",error);
    }];
}
- (NSMutableArray *)ticketList
{
    if (_ticketList == nil) {
        _ticketList = [NSMutableArray array];
        for(YZTicketList *ticket in _scheme.ticketList)
        {
            NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
            [muDict setValue:ticket.numbers forKey:@"numbers"];
            [muDict setValue:ticket.betType forKey:@"betType"];
            [muDict setValue:ticket.playType forKey:@"playType"];
            [_ticketList addObject:muDict];
        }
    }
    return _ticketList;
}
- (int)getAmount
{
    int amount = _multiple * _termCount * [self getSingleAmount];
    return amount;
}
- (int)getSingleAmount
{
    int amount = 0;
    for(YZTicketList *ticket in _scheme.ticketList)
    {
        amount += [ticket.amount intValue] / 100;
    }
    return amount;
}
- (int)getBetCount
{
    int betCount = 0;
    for(YZTicketList *ticket in _scheme.ticketList)
    {
        betCount += [ticket.count intValue];
    }
    return betCount;
}
#pragma mark - 初始化
- (NSMutableArray *)orderInfoLabels
{
    if (_orderInfoLabels == nil) {
        _orderInfoLabels = [NSMutableArray array];
    }
    return _orderInfoLabels;
}
@end
