//
//  YZShareIncomeViewController.m
//  ez
//
//  Created by 毛文豪 on 2017/5/16.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define lineWidth 0.8

#import "YZShareIncomeViewController.h"
#import "YZShareIncomeTableViewCell.h"
#import "YZNoDataTableViewCell.h"

@interface YZShareIncomeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    int _pageIndex;
}
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UILabel * quantityLabel;
@property (nonatomic, strong) id json;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) MJRefreshGifHeader *header;
@property (nonatomic, weak) MJRefreshBackGifFooter *footer;

@end

@implementation YZShareIncomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的收益";
    [self getData];
    [self setupChilds];
}

#pragma mark - 请求数据
- (void)getData {
    waitingView;
    NSDictionary *dict = @{
                           @"cmd":@(10636),
                           @"userId":UserId,
                           @"pageIndex":@(_pageIndex),
                           @"pageSize":@10
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"%@",json);
        if(SUCCESS)
        {
            self.json = json;
            NSArray * dataArray = [YZShareIncomeStatus objectArrayWithKeyValuesArray:json[@"earningsList"]];
            [self.dataArray addObjectsFromArray:dataArray];
            [self.tableView reloadData];
            if (dataArray.count == 0) {
                [self.footer endRefreshingWithNoMoreData];
            }else
            {
                [self.footer endRefreshing];
            }
            [self setQuantityData];
        }else
        {
            ShowErrorView
            [self.footer endRefreshing];
        }
        [self.header endRefreshing];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}

#pragma mark - 布局视图
- (void)setupChilds
{
    //tableview
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH)];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = YZBackgroundColor;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:tableView];
    
    //headerView
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.frame = CGRectMake(0, 0, screenWidth, 40);
    
    UILabel * quantityLabel = [[UILabel alloc] initWithFrame:CGRectMake(YZMargin, 0, screenWidth - 2 * YZMargin, headerView.height)];
    self.quantityLabel = quantityLabel;
    quantityLabel.textColor = YZBlackTextColor;
    quantityLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [headerView addSubview:quantityLabel];
    
    tableView.tableHeaderView = headerView;
    
    [self setupRefreshView];
}

#pragma mark - 集成上拉下拉刷新控件
- (void)setupRefreshView
{
    //初始化头部刷新控件
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderData:header];
    self.header = header;
    self.tableView.mj_header = header;
    
    //初始化底部刷新控件
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshViewBeginRefreshing)];
    [YZTool setRefreshFooterData:footer];
    self.footer = footer;
    self.tableView.mj_footer = footer;
}

- (void)headerRefreshViewBeginRefreshing
{
    _pageIndex = 0;
    [self.dataArray removeAllObjects];
    [self getData];
}

- (void)footerRefreshViewBeginRefreshing
{
    _pageIndex ++;
    [self getData];
}

- (void)setQuantityData
{
    NSString * number = [NSString stringWithFormat:@"%@",self.json[@"quantity"]];
    NSString * totalMoney = [NSString stringWithFormat:@"%.2f",[self.json[@"totalMoney"] floatValue] / 100];
    NSString *quantityStr = [NSString stringWithFormat:@"您累计邀请了%@位好友，收益总额%@元",number,totalMoney];
    NSMutableAttributedString *quantityAttStr = [[NSMutableAttributedString alloc] initWithString:quantityStr];
    [quantityAttStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:[quantityStr rangeOfString:number]];
    [quantityAttStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:[quantityStr rangeOfString:totalMoney]];
    self.quantityLabel.attributedText = quantityAttStr;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count == 0 ? 1 : self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count == 0) {
        YZNoDataTableViewCell *cell = [YZNoDataTableViewCell cellWithTableView:tableView cellId:@"noShareIncomeCell"];
        cell.imageName = @"no_recharge";
        cell.noDataStr = @"您还没有收益记录";
        return cell;
    }else
    {
        YZShareIncomeTableViewCell * cell = [YZShareIncomeTableViewCell cellWithTableView:tableView];
        YZShareIncomeStatus * status = self.dataArray[indexPath.row];
        if (status == self.dataArray.lastObject) {
            cell.line.hidden = NO;
        }else
        {
            cell.line.hidden = YES;
        }
        cell.status = status;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 35)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    NSArray * labelWs = @[@0.3,@0.45,@0.25];
    UILabel * lastLabel;
    NSArray *titles = @[@"手机号码",@"注册时间",@"购买收益"];
    for (int i = 0; i < titles.count; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, [labelWs[i] floatValue] * screenWidth, headerView.height)];
        label.text = titles[i];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        label.textColor = YZBlackTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
        lastLabel = label;
    }
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, lineWidth)];
    line1.backgroundColor = YZGrayTextColor;
    [headerView addSubview:line1];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.height - lineWidth, screenWidth, lineWidth)];
    line2.backgroundColor = YZGrayTextColor;
    [headerView addSubview:line2];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.dataArray.count == 0 ? tableView.height * 0.7 : 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

#pragma mark - 初始化
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
