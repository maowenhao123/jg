//
//  YZFBMatchDetailOddsViewController.m
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define padding 10

#import "YZFBMatchDetailOddsViewController.h"
#import "YZFBMatchDetailOddsLeftTableViewCell.h"
#import "YZFBMatchDetailOddsRightTitleTableViewCell.h"
#import "YZFBMatchDetailOddsRightContentTableViewCell.h"
#import "YZFBMatchDetailNoDataTableViewCell.h"

@interface YZFBMatchDetailOddsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UITableView *leftTableView;//左边tableView
@property (nonatomic, weak) UITableView *rightTableView;//右边tableView
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) NSString *currentCompanyId;
@property (nonatomic, weak) MJRefreshGifHeader *header;

@end

@implementation YZFBMatchDetailOddsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    //设置被选中
    for (int i = 0; i < self.oddsCells.count; i++) {
        YZOddsCellStatus * oddsCellStatus = self.oddsCells[i];
        if ([oddsCellStatus.companyId isEqualToString:self.companyId]) {
            oddsCellStatus.selected = YES;
        }else
        {
            oddsCellStatus.selected = NO;
        }
    }
    self.currentCompanyId = self.companyId;
    [self setupChildViews];
    [self getDataWithCompanyId:self.companyId];
}
#pragma mark - 布局视图
- (void)setupChildViews
{
    //右边tableView
    UITableView * rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.25 * screenWidth + padding, 0, (1 - 0.25) * screenWidth - 2 * padding, screenHeight - statusBarH - navBarH)];
    self.rightTableView = rightTableView;
    rightTableView.backgroundColor = YZBackgroundColor;
    rightTableView.contentInset = UIEdgeInsetsMake(padding, 0 , padding, 0);
    [rightTableView setContentOffset:CGPointMake(0, -padding)];
    rightTableView.tag = 102;
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    rightTableView.showsVerticalScrollIndicator = NO;
    rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [rightTableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:rightTableView];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshViewBeginRefreshing)];
    header.ignoredScrollViewContentInsetTop = padding;
    [YZTool setRefreshHeaderData:header];
    self.header = header;
    rightTableView.mj_header = header;
    
    //左边tableView
    UITableView * leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0.25 * screenWidth, screenHeight - statusBarH - navBarH)];
    self.leftTableView = leftTableView;
    leftTableView.tag = 101;
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    leftTableView.showsVerticalScrollIndicator = NO;
    [leftTableView setEstimatedSectionHeaderHeightAndFooterHeight];
    leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //阴影
    leftTableView.layer.masksToBounds = NO;
    leftTableView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    leftTableView.layer.shadowOffset = CGSizeMake(2, 0);
    leftTableView.layer.shadowOpacity = 1;
    [self.view addSubview:leftTableView];
    [leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    //headerView
    UILabel * companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth * 0.25, 30)];
    companyLabel.backgroundColor = [UIColor whiteColor];
    companyLabel.text = @"--公司--";
    companyLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    companyLabel.textColor = YZColor(116, 116, 116, 1);
    companyLabel.textAlignment = NSTextAlignmentCenter;
    leftTableView.tableHeaderView = companyLabel;
}
- (void)refreshViewBeginRefreshing
{
    [self getDataWithCompanyId:self.currentCompanyId];
}
#pragma mark - 请求数据
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self getDataWithCompanyId:self.currentCompanyId];
}
- (void)getDataWithCompanyId:(NSString *)companyId
{
    waitingView_loadingData;
    NSDictionary *dict = @{
                           @"roundNum":self.roundNum,
                           @"companyId":companyId
                           };
    NSString * param;
    if (self.oddsType == 0) {
        param = @"/getEuropeOddsDetail";
    }else if (self.oddsType == 1)
    {
        param = @"/getAsiaOddsDetail";
    }else if (self.oddsType == 2)
    {
        param = @"/getOverUnderDetail";
    }
    [[YZHttpTool shareInstance] requestTarget:self PostWithURL:BaseUrlFootball(param) params:dict success:^(id json) {
        YZLog(@"%@ - json = %@",param,json);
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            if (self.oddsType == 0) {
                self.dataArray = [YZEuropeOddsStatus objectArrayWithKeyValuesArray:json[@"europeOdds"]];
            }else if (self.oddsType == 1)
            {
                self.dataArray = [YZAsiaOddsStatus objectArrayWithKeyValuesArray:json[@"asiaOdds"]];
            }else if (self.oddsType == 2)
            {
                self.dataArray = [YZOverUnderStatus objectArrayWithKeyValuesArray:json[@"overUnder"]];
            }
            [self.rightTableView reloadData];
            [self.header endRefreshing];
        }else
        {
            ShowErrorView
            [self.header endRefreshing];
        }
    } failure:^(NSError *error) {
        [self.header endRefreshing];
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"getMatchStat - error = %@",error);
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 101) {
        return self.oddsCells.count;
    }else
    {
        if (self.dataArray.count == 0) {//没有数据时
            return 2;
        }
        return self.dataArray.count + 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 101) {
        YZFBMatchDetailOddsLeftTableViewCell * cell = [YZFBMatchDetailOddsLeftTableViewCell cellWithTableView:tableView];
        YZOddsCellStatus * status = self.oddsCells[indexPath.row];
        cell.status = status;
        return cell;
    }else
    {
        if (indexPath.row == 0) {//标题
            YZFBMatchDetailOddsRightTitleTableViewCell * cell = [YZFBMatchDetailOddsRightTitleTableViewCell cellWithTableView:tableView];
            cell.oddsType = self.oddsType;
            return cell;
        }else
        {
            if (self.dataArray.count == 0) {//没有数据时
                YZFBMatchDetailNoDataTableViewCell * cell = [YZFBMatchDetailNoDataTableViewCell cellWithTableView:tableView];
                cell.oddsCell = YES;
                return cell;
            }else
            {
                YZFBMatchDetailOddsRightContentTableViewCell * cell = [YZFBMatchDetailOddsRightContentTableViewCell cellWithTableView:tableView];
                cell.status = self.dataArray[indexPath.row - 1];
                return cell;
                
            }
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 101) {
        YZOddsCellStatus * oddsCellStatus = self.oddsCells[indexPath.row];
        if ([self.currentCompanyId isEqualToString:oddsCellStatus.companyId])
        {
            return;
        }
        //清空被选中的
        NSMutableArray * indexPaths = [NSMutableArray array];
        for (int i = 0; i < self.oddsCells.count; i++) {
            YZOddsCellStatus * status = self.oddsCells[i];
            if (status.isSelected) {
                status.selected = NO;
                NSIndexPath * openIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:openIndexPath];
            }
        }
        //点击的indexPath
        YZOddsCellStatus * status = self.oddsCells[indexPath.row];
        status.selected = YES;//选中
        [indexPaths addObject:indexPath];
        [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        
        //选中的居中
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
        //请求数据
        self.currentCompanyId = oddsCellStatus.companyId;
        [self getDataWithCompanyId:oddsCellStatus.companyId];
    }
}
#pragma mark - 初始化
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
@end
