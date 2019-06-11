
//
//  YZBankCardViewController.m
//  ez
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZBankCardViewController.h"
#import "YZBankCardTableViewCell.h"
#import "YZAddBankCardViewController.h"
#import "YZNoDataTableViewCell.h"
#import "YZBankCardStatus.h"

@interface YZBankCardViewController ()<UITableViewDelegate,UITableViewDataSource,YZAddBankCardDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIButton * addBankCardBtn;
@property (nonatomic, weak) UIButton * deleteBtn;
@property (nonatomic, strong) NSMutableArray *bankCards;

@end

@implementation YZBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的银行卡";
    [self setupChilds];
    waitingView_loadingData;
    [self getBankData];
}
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self getBankData];
}
- (void)getBankData
{
    NSDictionary *dict = @{
                           @"cmd":@(10700),
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"%@",json);
        if (SUCCESS) {
            NSArray * bankCards = [YZBankCardStatus objectArrayWithKeyValuesArray:json[@"cards"]];
            self.bankCards = [NSMutableArray arrayWithArray:bankCards];
            [self.tableView reloadData];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"账户error");
    }];
}
- (void)setupChilds
{
    //添加银行卡
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"addBank_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(addBankCardBtnClick)] ;
    //tableview
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.allowsMultipleSelectionDuringEditing = YES;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:tableView];
}
- (void)addBankCardBtnClick
{
    YZAddBankCardViewController * addBankCardVC = [[YZAddBankCardViewController alloc]init];
    addBankCardVC.delegate = self;
    [self.navigationController pushViewController:addBankCardVC animated:YES];
}
//添加银行卡成功
- (void)addBankSuccess
{
    waitingView_loadingData;
    [self getBankData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.bankCards.count > 0 ? self.bankCards.count : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bankCards.count == 0) {//没有数据时
        YZNoDataTableViewCell *cell = [YZNoDataTableViewCell cellWithTableView:tableView cellId:@"noBankcardCell"];
        cell.imageName = @"no_bankcard";
        cell.noDataStr = @"暂时没有银行卡";
        return cell;
    }else
    {
        YZBankCardTableViewCell * cell = [YZBankCardTableViewCell cellWithTableView:tableView];
        YZBankCardStatus * bankCard = self.bankCards[indexPath.section];
        cell.status = bankCard;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bankCards.count == 0 ? tableView.height * 0.7 : 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.bankCards.count - 1 == section) {
        return 10;
    }
    return 0.01;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bankCards.count == 0) {
        return NO;
    }
    return YES;
}
//自定义删除
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.bankCards.count == 0) {//没有数据时
        return;
    }
    //删除银行卡
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认删除银行卡?删除后不可复原。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        YZBankCardStatus * ststus = self.bankCards[indexPath.section];
        [self deleteDataWithBankCardId:ststus.cardId indexPath:indexPath];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)deleteDataWithBankCardId:(NSString *)cardId indexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dict = @{
                           @"cmd":@(10722),
                           @"userId":UserId,
                           @"cardId":cardId
                           };
     [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"银行卡删除成功"];
            [self.bankCards removeObjectAtIndex:indexPath.section];
            [self.tableView reloadData];
        }else
        {
            ShowErrorView;
        }
    }failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
    }];
}
#pragma mark - 初始化
- (NSMutableArray *)bankCards
{
    if (_bankCards == nil) {
        _bankCards = [NSMutableArray array];
    }
    return _bankCards;
}
@end
