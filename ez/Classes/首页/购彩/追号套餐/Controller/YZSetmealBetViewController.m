//
//  YZSetmealBetViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/7/11.
//  Copyright © 2018年 9ge. All rights reserved.
//
#define cellH 45

#import "YZSetmealBetViewController.h"
#import "YZLoginViewController.h"
#import "YZRechargeListViewController.h"
#import "YZSetmealChooseNumberViewController.h"
#import "YZBetSuccessViewController.h"
#import "YZSetmealShowNumberViewController.h"
#import "YZMultipleKeyboardView.h"
#import "YZSetmealNumberTableViewCell.h"
#import "YZWinNumberBallStatus.h"
#import "JSON.h"
#import "UIButton+YZ.h"

@interface YZSetmealBetViewController ()<UITableViewDelegate, UITableViewDataSource, YZMultipleKeyboardViewCellDelegate, YZSetmealChooseNumberViewControllerDelegate, YZSetmealShowNumberViewControllerDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UILabel *termLabel;
@property (nonatomic, strong) UIButton * addTermButton;
@property (nonatomic, weak) UIView * bottomView;
@property (nonatomic, weak) UIButton *multipleButton;
@property (nonatomic, weak) UIButton * buyButton;
@property (nonatomic, weak) UILabel *unhitReturnMoneyDescLabel;
@property (nonatomic, copy) NSString *currentTermId;
@property (nonatomic, copy) NSString *multiple;
@property (nonatomic, strong) YZSchemeSetmealInfoModel *schemeSetmealInfoModel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) float amountMoney;//金额

@end

@implementation YZSetmealBetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.multiple = @"1";
    self.amountMoney = 2.0;
    self.title = @"投注号码";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑号码" style:UIBarButtonItemStylePlain target:self action:@selector(editNumberBarDidClick)];
    [self setupChilds];
    [self getCurrentTermDataWithIsPay:NO];
}

- (void)editNumberBarDidClick
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑号码"]) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
        [self.tableView setEditing:YES animated:YES];
    }else
    {
        self.navigationItem.rightBarButtonItem.title = @"编辑号码";
        [self.tableView setEditing:NO animated:YES];
    }
}

#pragma mark - 请求数据
- (void)getCurrentTermDataWithIsPay:(BOOL)isPay
{
    [MBProgressHUD showMessage:text_gettingCurrentTerm toView:self.view];
    NSDictionary *dict = @{
                           @"cmd":@(8026),
                           @"gameId":self.gameId
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"getCurrentTerm:%@",json);
        if(SUCCESS)
        {
            NSArray *termList = json[@"game"][@"termList"];
            if(!termList.count)
            {
                [MBProgressHUD showError:text_sailStop];
            }else
            {
                self.currentTermId = [termList lastObject][@"termId"];
            }
            if (isPay) {
                [self comfirmPay];//支付
            }else
            {
                [self getChasePlanData];
            }
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

- (void)getChasePlanData
{
    NSDictionary *dict = @{
                           @"id":self.schemeSetmealId,
                           };
    waitingView
    [[YZHttpTool shareInstance] postWithURL:BaseUrlSalesManager(@"/getChasePlan") params:dict success:^(id json) {
        YZLog(@"getChasePlan:%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            self.schemeSetmealInfoModel = [YZSchemeSetmealInfoModel objectWithKeyValues:json[@"info"]];
            [self setData];
        }
    } failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
         [MBProgressHUD hideHUDForView:self.view];
    }];
}

#pragma mark - 初始化视图
- (void)setupChilds
{
    //类型选号
    NSArray * typeButtonTitles = @[@"自选号码", @"生日选号", @"手机选号", @"幸运数字"];
    CGFloat typeButtonPadding = 10;
    CGFloat typeButtonW = (screenWidth - (typeButtonTitles.count + 1) * typeButtonPadding) / typeButtonTitles.count;
    CGFloat typeButtonH = 38;
    UIView *lastView;
    for (int i = 0; i < typeButtonTitles.count; i++) {
        UIButton * typeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        typeButton.tag = i;
        typeButton.backgroundColor = [UIColor whiteColor];
        typeButton.frame = CGRectMake(typeButtonPadding + (typeButtonPadding + typeButtonW) * i, 15, typeButtonW, typeButtonH);
        [typeButton setTitle:typeButtonTitles[i] forState:UIControlStateNormal];
        [typeButton setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        typeButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        typeButton.layer.masksToBounds = YES;
        typeButton.layer.cornerRadius = 2;
        typeButton.layer.borderWidth = 1;
        typeButton.layer.borderColor = YZWhiteLineColor.CGColor;
        [typeButton addTarget:self action:@selector(typeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:typeButton];
        
        lastView = typeButton;
    }
    
    //tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame) + 15, screenWidth, 30 + cellH + 40)];
    self.tableView = tableView;
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tableView];
    [self addTermData];
    
    //headerView
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
    
    UILabel *termLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, screenWidth - 20, headerView.height - 7)];
    self.termLabel = termLabel;
    termLabel.textColor = YZBlackTextColor;
    termLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [headerView addSubview:termLabel];
    
    tableView.tableHeaderView = headerView;
    
    //footerView
    self.addTermButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addTermButton.frame = CGRectMake(0, 0, screenWidth, 40);
    self.addTermButton.backgroundColor = [UIColor whiteColor];
    [self.addTermButton setTitle:@"添加一注" forState:UIControlStateNormal];
    [self.addTermButton setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    self.addTermButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [self.addTermButton setImage:[UIImage imageNamed:@"11x5_history_btn"] forState:UIControlStateNormal];
    [self.addTermButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentRight imgTextDistance:3];
    [self.addTermButton addTarget:self action:@selector(addTermData) forControlEvents:UIControlEventTouchUpInside];
    tableView.tableFooterView = self.addTermButton;
    
    //底部视图
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tableView.frame) + 40, screenWidth, 70)];
    self.bottomView = bottomView;
    [self.view addSubview:bottomView];
    
    //倍数
    UIButton * multipleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.multipleButton = multipleButton;
    multipleButton.backgroundColor = [UIColor whiteColor];
    multipleButton.frame = CGRectMake(15, 0, 100, 35);
    [multipleButton setTitle:@"1倍" forState:UIControlStateNormal];
    [multipleButton setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    multipleButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [multipleButton setImage:[UIImage imageNamed:@"11x5_history_btn"] forState:UIControlStateNormal];
    [multipleButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentRight imgTextDistance:4];
    multipleButton.layer.masksToBounds = YES;
    multipleButton.layer.cornerRadius = 2;
    multipleButton.layer.borderWidth = 1;
    multipleButton.layer.borderColor = YZWhiteLineColor.CGColor;
    [multipleButton addTarget:self action:@selector(multipleButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:multipleButton];
    
    //投注按钮
    YZBottomButton * buyButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.buyButton = buyButton;
    buyButton.frame = CGRectMake(CGRectGetMaxX(multipleButton.frame) + 10, 0, screenWidth - CGRectGetMaxX(multipleButton.frame) - 10 - 15, 35);
    [buyButton setTitle:@"立即付款2.00元" forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buyButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:buyButton];
    
    //金额描述
    UILabel * unhitReturnMoneyDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(buyButton.frame) + 15, screenWidth - 40, 20)];
    self.unhitReturnMoneyDescLabel = unhitReturnMoneyDescLabel;
    unhitReturnMoneyDescLabel.textColor = YZRedTextColor;
    unhitReturnMoneyDescLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    unhitReturnMoneyDescLabel.textAlignment = NSTextAlignmentRight;
    [bottomView addSubview:unhitReturnMoneyDescLabel];
}

#pragma mark - 按钮点击
- (void)typeButtonDidClick:(UIButton *)button
{
    if (button.tag == 0) {
        YZSetmealShowNumberViewController * showNumberVC = [[YZSetmealShowNumberViewController alloc] init];
        showNumberVC.gameId = self.gameId;
        showNumberVC.delegate = self;
        [self.navigationController pushViewController:showNumberVC animated:YES];
    }else
    {
        if (self.dataArray.count >= 5) {
            [MBProgressHUD showError:@"追号套餐，最多选择5注"];
            return;
        }
        YZSetmealChooseNumberViewController * chooseNumberVC = [[YZSetmealChooseNumberViewController alloc] init];
        chooseNumberVC.chooseNumberType = button.tag;
        chooseNumberVC.gameId = self.gameId;
        chooseNumberVC.delegate = self;
        [self.navigationController pushViewController:chooseNumberVC animated:YES];
    }
}

- (void)getNumberBallStatus:(NSArray *)numberBallStatus numberArray:(NSArray *)numberArray
{
    if (YZArrayIsEmpty(numberArray)) {
        [self getNumberBallStatus:numberBallStatus];
    }else
    {
        NSInteger index = [self.dataArray indexOfObject:numberArray];
        [self.dataArray replaceObjectAtIndex:index withObject:numberBallStatus];
        if (self.dataArray.count == 1) {
            [self.tableView reloadData];
        }else
        {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
        [self setViewFrame];
        [self setTermCount];
    }
}

- (void)getNumberBallStatus:(NSArray *)numberBallStatus
{
    [self.dataArray insertObject:numberBallStatus atIndex:0];
    if (self.dataArray.count == 1) {
        [self.tableView reloadData];
    }else
    {
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    [self setViewFrame];
    [self setTermCount];
}

- (void)multipleButtonDidClick
{
    YZMultipleKeyboardView * multipleKeyboardView = [[YZMultipleKeyboardView alloc] initWithMultiple:self.multiple];
    multipleKeyboardView.delegate = self;
    [multipleKeyboardView show];
}

- (void)multipleKeyboardViewDidChangeMultiple:(NSString *)multiple
{
    self.multiple = multiple;
    [self.multipleButton setTitle:[NSString stringWithFormat:@"%@倍", self.multiple] forState:UIControlStateNormal];
    [self.multipleButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentRight imgTextDistance:4];
    [self setTermCount];
}

#pragma mark - 设置数据
- (void)setData
{
    self.termLabel.text = [NSString stringWithFormat:@"追%@期  第%@起", self.schemeSetmealInfoModel.termCount, self.currentTermId];
    self.unhitReturnMoneyDescLabel.text = [NSString stringWithFormat:@"不中奖返%.2f元", [self.schemeSetmealInfoModel.unhitReturnMoney floatValue] / 100];
    [self setTermCount];
}

- (void)addTermData
{
    int redCount = 0;
    int blueCount = 0;
    if ([self.gameId isEqualToString:@"F01"]) {
        redCount = 6;
        blueCount = 1;
    }else if ([self.gameId isEqualToString:@"T01"]) {
        redCount = 5;
        blueCount = 2;
    }
    
    //红球
    NSMutableSet *redSet = [NSMutableSet set];
    while (redSet.count < redCount) {
        [redSet addObject:@([self getRandomRedBallNumber])];
    }
    NSMutableArray * array1 = [NSMutableArray array];
    for (NSNumber * number in redSet) {
        YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
        ballStatus.number = [NSString stringWithFormat:@"%02d",[number intValue]];
        ballStatus.type = 1;
        [array1 addObject:ballStatus];
    }
    //对红球数组排序
    NSMutableArray *sortArray1 = [self sortBallsArray:array1];
    //蓝球
    NSMutableSet *blueSet = [NSMutableSet set];
    while (blueSet.count < blueCount) {
        [blueSet addObject:@([self getRandomBlueBallNumber])];
    }
    NSMutableArray * array2 = [NSMutableArray array];
    for (NSNumber * number in blueSet) {
        YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
        ballStatus.number = [NSString stringWithFormat:@"%02d",[number intValue]];
        ballStatus.type = 2;
        [array2 addObject:ballStatus];
    }
    //对蓝球数组排序
    NSMutableArray *sortArray2 = [self sortBallsArray:array2];
    //合并数组
    NSMutableArray * array = [NSMutableArray arrayWithArray:sortArray1];
    [array addObjectsFromArray:sortArray2];
    
    [self.dataArray insertObject:array atIndex:0];
    if (self.dataArray.count == 1) {
        [self.tableView reloadData];
    }else
    {
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    [self setViewFrame];
    [self setTermCount];
}

- (void)setViewFrame
{
    if (self.dataArray.count < 5) {
        self.tableView.height = 30 + self.dataArray.count * cellH + 40;
        self.tableView.tableFooterView = self.addTermButton;
    }else
    {
        self.tableView.height = 30 + self.dataArray.count * cellH + 10;
        self.tableView.tableFooterView = nil;
    }
    self.bottomView.y = CGRectGetMaxY(self.tableView.frame) + 40;
}

- (void)setTermCount
{
    self.amountMoney = [self.multiple intValue] * self.dataArray.count * [self.schemeSetmealInfoModel.termCount intValue] * 2.0;
    NSString * money = [NSString stringWithFormat:@"立即付款%.2f元", self.amountMoney];
    [self.buyButton setTitle:money forState:UIControlStateNormal];
    [self setUnhitReturnMoneyDescText];
}

- (void)setUnhitReturnMoneyDescText
{
    NSString *unhitReturnMoneyDesc = [NSString stringWithFormat:@"不中奖返%.2f元", [self.schemeSetmealInfoModel.unhitReturnMoney floatValue] / 100 * [self.multiple intValue] * self.dataArray.count];
    self.unhitReturnMoneyDescLabel.text = unhitReturnMoneyDesc;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSetmealNumberTableViewCell * cell = [YZSetmealNumberTableViewCell cellWithTableView:tableView];
    cell.numberArray = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellH;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self setViewFrame];
    [self setTermCount];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSetmealShowNumberViewController * showNumberVC = [[YZSetmealShowNumberViewController alloc] init];
    showNumberVC.gameId = self.gameId;
    showNumberVC.numberArray = self.dataArray[indexPath.row];
    showNumberVC.delegate = self;
    [self.navigationController pushViewController:showNumberVC animated:YES];
}

#pragma mark - 付款
- (void)buyButtonDidClick
{
    if (self.amountMoney > 20000)
    {
        [MBProgressHUD showError:@"单次投注方案不能超过2万元!"];
        return;
    }
    if(!UserId)//没登录
    {
        YZLoginViewController *loginVc = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
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
    BOOL hasEnoughMoney = [YZTool hasEnoughMoneyWithAmountMoney:self.amountMoney];
    if (hasEnoughMoney) {
        NSString * message = [YZTool getAlertViewTextWithAmountMoney:self.amountMoney];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"支付确认" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getCurrentTermDataWithIsPay:YES];//当前期次的信息
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
    YZRechargeListViewController *rechargeVc = [[YZRechargeListViewController alloc] initWithStyle:UITableViewStyleGrouped];
    rechargeVc.isOrderPay = YES;
    [self.navigationController pushViewController:rechargeVc animated:YES];
}

- (void)isJump:(BOOL)jump
{
    if(!jump)//不跳
    {
        [self comfirmPay];//支付
    }else //跳转网页
    {
        [MBProgressHUD hideHUDForView:self.view];
        NSNumber *multiple = @([self.multiple integerValue]);//投多少倍
        NSNumber *amount = @((int)self.amountMoney * 100);
        NSNumber *termCount = self.schemeSetmealInfoModel.termCount;//追期数
        NSMutableArray *ticketList = [self getTicketList];
        NSString *ticketListJsonStr = [ticketList JSONRepresentation];
        YZLog(@"ticketListJsonStr = %@",ticketListJsonStr);
#if JG
        NSString * mcpStr = @"EZmcp";
#elif ZC
        NSString * mcpStr = @"ZCmcp";
#endif
        NSString *param = [NSString stringWithFormat:@"userId=%@&gameId=%@&termId=%@&multiple=%@&amount=%@&ticketList=%@&payType=%@&termCount=%@&startTermId=%@&winStop=%@&id=%@&channel=%@&childChannel=%@&version=%@&remark=%@",UserId,self.gameId,self.currentTermId,multiple,amount,[ticketListJsonStr URLEncodedString],@"ACCOUNT",termCount,self.currentTermId,@false,@"1407305392008",mainChannel,childChannel,[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],mcpStr];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",jumpURLStr,param]];
        YZLog(@"url:%@",url);
        [[UIApplication sharedApplication] openURL:url];
    }
}
#pragma  mark - 确认支付
- (void)comfirmPay//支付接口
{
    NSNumber *multiple = @([self.multiple integerValue]);//投多少倍
    NSNumber *amount = @((int)self.amountMoney * 100);
    NSNumber *termCount = self.schemeSetmealInfoModel.termCount;//追期数
    NSNumber *zs = @(self.dataArray.count);
    NSNumber *unitReturnMoney = self.schemeSetmealInfoModel.unhitReturnMoney;
    NSNumber * totalReturnMoney = @(self.dataArray.count * [unitReturnMoney longLongValue] * [self.multiple intValue]);
    NSMutableArray *ticketList = [self getTicketList];
    NSDictionary * dict = @{
                              @"cmd":@(8053),
                              @"userId":UserId,
                              @"gameId":self.gameId,
                              @"termId":self.currentTermId,
                              @"multiple":multiple,
                              @"amount":amount,
                              @"ticketList":ticketList,
                              @"payType":@"ACCOUNT",
                              @"termCount":termCount,
                              @"startTermId":self.currentTermId,
                              @"winStop":@false,
                              @"chasePlanId":self.schemeSetmealId,
                              @"chasePlanName":self.schemeSetmealInfoModel.name,
                              @"zs":zs,
                              @"unitReturnMoney":unitReturnMoney,
                              @"totalReturnMoney":totalReturnMoney,
                              };
    
    [MBProgressHUD showMessage:text_paying toView:self.view];
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            [MBProgressHUD hideHUDForView:self.view];
            YZBetSuccessViewController *betSuccessVc = [[YZBetSuccessViewController alloc] init];
            betSuccessVc.payVcType = BetTypeNormal;
            betSuccessVc.termCount = [termCount intValue];
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

- (NSMutableArray *)getTicketList
{
    NSMutableArray * ticketList = [NSMutableArray array];
    NSMutableString *numbers = [NSMutableString string];
    for (NSArray *numberArray in self.dataArray) {
        NSMutableString *numbers_ = [NSMutableString string];
        for (YZWinNumberBallStatus * ballStatus in numberArray) {
            if (ballStatus.type == 1) {
                [numbers_ appendString:[NSString stringWithFormat:@"%@,", ballStatus.number]];
            }
        }
        [numbers_ deleteCharactersInRange:NSMakeRange(numbers_.length - 1, 1)];//去掉最后一个逗号
        [numbers_ appendFormat:@"|"];//加一竖
        for (YZWinNumberBallStatus * ballStatus in numberArray) {
            if (ballStatus.type == 2)
            {
                [numbers_ appendString:[NSString stringWithFormat:@"%@,",ballStatus.number]];
            }
        }
        [numbers_ deleteCharactersInRange:NSMakeRange(numbers_.length - 1, 1)];//去掉最后一个逗号
        [numbers appendFormat:@";%@", numbers_];
    }
    [numbers deleteCharactersInRange:NSMakeRange(0, 1)];//删除第一个分号
    NSDictionary *dict = @{@"numbers":numbers,
                           @"betType":@"00",
                           @"playType":@"00"};
    [ticketList addObject:dict];
    return ticketList;
}

#pragma mark - 初始化
- (NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark - 工具
- (int)getRandomRedBallNumber
{
    if ([self.gameId isEqualToString:@"F01"]) {
        return arc4random() % 33 + 1;
    }else
    {
        return arc4random() % 35 + 1;
    }
}
- (int)getRandomBlueBallNumber
{
    if ([self.gameId isEqualToString:@"F01"]) {
        return arc4random() % 16 + 1;
    }else
    {
        return arc4random() % 12 + 1;
    }
}
//冒泡排序球数组
- (NSMutableArray *)sortBallsArray:(NSMutableArray *)mutableArray
{
    if(mutableArray.count == 1) return mutableArray;
    for(int i = 0;i < mutableArray.count;i++)
    {
        for(int j = i + 1;j <mutableArray.count;j++)
        {
            YZWinNumberBallStatus * ballStatus1 = mutableArray[i];
            YZWinNumberBallStatus * ballStatus2 = mutableArray[j];
            int number1 = [ballStatus1.number intValue];
            int number2 = [ballStatus2.number intValue];
            if(number1 > number2)
            {
                [mutableArray replaceObjectAtIndex:i withObject:ballStatus2];
                [mutableArray replaceObjectAtIndex:j withObject:ballStatus1];
            }
        }
    }
    return mutableArray;
}


@end
