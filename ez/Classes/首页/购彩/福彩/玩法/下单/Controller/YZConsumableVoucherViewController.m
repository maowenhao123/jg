//
//  YZConsumableVoucherViewController.m
//  ez
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZConsumableVoucherViewController.h"
#import "YZVoucherTableViewCell.h"

@interface YZConsumableVoucherViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, weak) MJRefreshGifHeader *header;

@end

@implementation YZConsumableVoucherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"可用彩券";
    [self setupChilds];
    [self getConsumableListDetailData];
}

#pragma  mark - 获取可用彩券的数据
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self getConsumableListDetailData];
}
- (void)getConsumableListDetailData
{
    NSNumber * money = [NSNumber numberWithInt:(int)self.amountMoney * 100];
    NSDictionary * orderDic = @{
                                @"money":money,
                                @"game":self.gameId
                                };
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"order":orderDic,
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithURL:BaseUrlCoupon(@"/getConsumableList") params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        YZLog(@"%@",json);
        //清空数据
        if ([self.header isRefreshing]) {
            self.dataArray = [NSArray array];
            [self.header endRefreshing];
        }
        if (SUCCESS) {;
            self.dataArray = [YZVoucherStatus objectArrayWithKeyValuesArray:json[@"respCouponList"]];
            [self.tableView reloadData];
        }else
        {
            ShowErrorView;
        }
    }failure:^(NSError *error)
    {
         [self.header endRefreshing];
         [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma  mark - 布局视图
- (void)setupChilds
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消使用" style:UIBarButtonItemStylePlain target:self action:@selector(cancelUseVoucher)];
    
    CGFloat scrollViewH = screenHeight-statusBarH-navBarH;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, scrollViewH) style:UITableViewStyleGrouped];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:tableView];
    
    //下拉刷新
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderData:header];
    tableView.mj_header = header;
    self.header = header;
}

#pragma  mark - MJRefreshBaseViewDelegate的代理方法
- (void)refreshViewBeginRefreshing
{
    [self getConsumableListDetailData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZVoucherTableViewCell * cell = [YZVoucherTableViewCell cellWithTableView:tableView];
    YZVoucherStatus * status = self.dataArray[indexPath.section];
    cell.index = 1;
    cell.status = status;
    cell.goButton.hidden = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.dataArray.count - 1) {
        return 10;
    }
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(chooseVoucherStstus:)]) {
        YZVoucherStatus * status = self.dataArray[indexPath.section];
        [_delegate chooseVoucherStstus:status];
    }
}

//取消使用代金券
- (void)cancelUseVoucher
{
    [self.navigationController popViewControllerAnimated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(cancelUseVoucher)]) {
        [_delegate cancelUseVoucher];
    }
}

#pragma mark - 初始化
- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

@end
