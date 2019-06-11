//
//  YZFBTicketDetailViewController.m
//  ez
//
//  Created by apple on 16/10/11.
//  Copyright © 2016年 9ge. All rights reserved.
//
#import "YZFBTicketDetailViewController.h"
#import "YZFBTicketDetailTableViewCell.h"
#import "YZOrder.h"

@interface YZFBTicketDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) YZOrder *order;
@property (nonatomic, strong) NSArray *ticketListArray;

@end

@implementation YZFBTicketDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"出票明细";
    [self setupChilds];
    [self loadTicketDetailData];
    waitingView_loadingData
}
#pragma mark - 获取数据
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self loadTicketDetailData];
}
- (void)loadTicketDetailData
{
    NSDictionary *dict = @{
                           @"cmd":@(8036),
                           @"orderId":self.orderId
                           };
    
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            self.ticketListArray = [YZTicketList objectArrayWithKeyValuesArray:json[@"order"][@"ticketList"]];
            self.order = [YZOrder objectWithKeyValues:json[@"order"]];
            [self.tableView reloadData];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"getOrderDetailData - error = %@",error);
    }];
}
- (void)setupChilds
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH)];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.ticketListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZFBTicketDetailTableViewCell * cell = [YZFBTicketDetailTableViewCell cellWithTableView:tableView];
    cell.ticketList = self.ticketListArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZTicketList *ticketList = self.ticketListArray[indexPath.row];
    NSArray *orderCodes = [ticketList.orderCode componentsSeparatedByString:@";"];
    NSArray *numbers = [ticketList.numbers componentsSeparatedByString:@";"];
    NSString * text = [YZTicketList getTicketInfos:orderCodes numbers:numbers gameId:self.order.gameId];
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(24)] maxSize:CGSizeMake(screenWidth * 0.4, MAXFLOAT)];
    return  (size.height + 20) > 60 ? (size.height + 20) : 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 35)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    NSArray * labelWs = @[@0.2,@0.4,@0.15,@0.25];
    UILabel * lastLabel;
    NSArray *titles = @[@"时间",@"出票内容",@"倍数",@"状态"];
    for (int i = 0; i < titles.count; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, [labelWs[i] floatValue] * screenWidth, 35)];
        label.text = titles[i];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        label.textColor = YZBlackTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:label];
        lastLabel = label;
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, lineWidth, 35)];
        line.backgroundColor = YZGrayTextColor;
        [headerView addSubview:line];
    }
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, lineWidth)];
    line1.backgroundColor = YZGrayTextColor;
    [headerView addSubview:line1];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 35 - lineWidth, screenWidth, lineWidth)];
    line2.backgroundColor = YZGrayTextColor;
    [headerView addSubview:line2];
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, lineWidth, 35)];
    line3.backgroundColor = YZGrayTextColor;
    [headerView addSubview:line3];
    
    return headerView;
}
#pragma mark - 初始化
- (NSArray *)ticketListArray
{
    if (_ticketListArray == nil) {
        _ticketListArray = [NSArray array];
    }
    return _ticketListArray;
}
@end
