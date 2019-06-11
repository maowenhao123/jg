//
//  YZFBMatchDetailOddsView.m
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define padding 10

#import "YZFBMatchDetailOddsView.h"
#import "YZFBMatchDetailOddsViewController.h"
#import "YZFBMatchDetailTypeBtnView.h"
#import "YZFBMatchDetailOddsContentTableViewCell.h"
#import "YZFBMatchDetailOddsTitleTableViewCell.h"
#import "YZFBMatchDetailNoDataTableViewCell.h"

@interface YZFBMatchDetailOddsView ()<UITableViewDelegate,UITableViewDataSource,YZFBMatchDetailTypeBtnViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *typeButtonTitles;//类型按钮标题
@property (nonatomic, assign) NSInteger oddsType;//赔率类型

@end

@implementation YZFBMatchDetailOddsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZBackgroundColor;
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(padding, 0, self.width - 2 * padding, self.height)];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self addSubview:tableView];
    
    UILabel * footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth - 2 * padding, 35)];
    footerLabel.text = @"*点击赔率数字可查看赔率变动情况";
    footerLabel.textColor = YZColor(116, 116, 116, 1);
    footerLabel.textAlignment = NSTextAlignmentRight;
    footerLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    tableView.tableFooterView = footerLabel;
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.oddsType == 0) {
        if (self.oddsStatus.europeOddsCells.count == 0) {//没有数据
            return 2;
        }
        return self.oddsStatus.europeOddsCells.count + 1;
    }else if (self.oddsType == 1)
    {
        if (self.oddsStatus.asiaOddsCells.count == 0) {//没有数据
            return 2;
        }
        return self.oddsStatus.asiaOddsCells.count + 1;
    }else if (self.oddsType == 2)
    {
        if (self.oddsStatus.overUnderCells.count == 0) {//没有数据
            return 2;
        }
        return self.oddsStatus.overUnderCells.count + 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        YZFBMatchDetailOddsTitleTableViewCell * cell = [YZFBMatchDetailOddsTitleTableViewCell cellWithTableView:tableView];
        cell.oddsType = self.oddsType;
        return cell;
    }else
    {
        if (self.oddsType == 0) {//欧赔
            if (self.oddsStatus.europeOddsCells.count == 0) {//没有数据 
                YZFBMatchDetailNoDataTableViewCell * cell = [YZFBMatchDetailNoDataTableViewCell cellWithTableView:tableView];
                return cell;
            }else
            {
                YZFBMatchDetailOddsContentTableViewCell * cell = [YZFBMatchDetailOddsContentTableViewCell cellWithTableView:tableView];
                cell.oddsCellStatus = self.oddsStatus.europeOddsCells[indexPath.row - 1];
                return cell;
            }
        }else if (self.oddsType == 1)//亚盘
        {
            if (self.oddsStatus.asiaOddsCells.count == 0) {//没有数据
                YZFBMatchDetailNoDataTableViewCell * cell = [YZFBMatchDetailNoDataTableViewCell cellWithTableView:tableView];
                return cell;
            }else
            {
                YZFBMatchDetailOddsContentTableViewCell * cell = [YZFBMatchDetailOddsContentTableViewCell cellWithTableView:tableView];
                cell.oddsCellStatus = self.oddsStatus.asiaOddsCells[indexPath.row - 1];
                return cell;
            }
        }else if (self.oddsType == 2)//大小盘
        {
            if (self.oddsStatus.overUnderCells.count == 0) {//没有数据
                YZFBMatchDetailNoDataTableViewCell * cell = [YZFBMatchDetailNoDataTableViewCell cellWithTableView:tableView];
                return cell;
            }else
            {
                YZFBMatchDetailOddsContentTableViewCell * cell = [YZFBMatchDetailOddsContentTableViewCell cellWithTableView:tableView];
                cell.oddsCellStatus = self.oddsStatus.overUnderCells[indexPath.row - 1];
                return cell;
            }
        }else
        {
            return nil;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 50)];
    headerView.backgroundColor = YZBackgroundColor;
    
    CGFloat typeBtnViewW = 80 * self.typeButtonTitles.count;
    CGFloat typeBtnViewX = (screenWidth - typeBtnViewW) / 2;
    YZFBMatchDetailTypeBtnView * typeBtnView = [[YZFBMatchDetailTypeBtnView alloc] initWithFrame:CGRectMake(typeBtnViewX, 10, typeBtnViewW, 30) titleArray:self.typeButtonTitles];
    typeBtnView.delegate = self;
    [headerView addSubview:typeBtnView];
    typeBtnView.segmentedControl.selectedSegmentIndex = self.oddsType;//设置默认选择项索引
    return headerView;
}
//类型按钮点击
- (void)typeSegmentControlSelectedIndex:(NSInteger)index
{
    self.oddsType = index;
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //没有数据
    if (self.oddsType == 0 && self.oddsStatus.europeOddsCells.count == 0) {//欧赔
        return;
    }else if (self.oddsType == 1 && self.oddsStatus.asiaOddsCells.count == 0)//亚盘
    {
        return;
    }else if (self.oddsType == 2 && self.oddsStatus.overUnderCells.count == 0)//大小盘
    {
        return;
    }
    
    YZFBMatchDetailOddsViewController * oddsVC = [[YZFBMatchDetailOddsViewController alloc] init];
    oddsVC.title = self.typeButtonTitles[self.oddsType];
    YZOddsCellStatus * oddsCellStatus;
    if (self.oddsType == 0) {//欧赔
        oddsCellStatus = self.oddsStatus.europeOddsCells[indexPath.row - 1];
        oddsVC.oddsCells = self.oddsStatus.europeOddsCells;
    }else if (self.oddsType == 1)//亚盘
    {
        oddsCellStatus = self.oddsStatus.asiaOddsCells[indexPath.row - 1];
        oddsVC.oddsCells = self.oddsStatus.asiaOddsCells;
    }else if (self.oddsType == 2)//大小盘
    {
        oddsCellStatus = self.oddsStatus.overUnderCells[indexPath.row - 1];
        oddsVC.oddsCells = self.oddsStatus.overUnderCells;
    }
    oddsVC.companyId = oddsCellStatus.companyId;
    oddsVC.selectedIndex = indexPath.row - 1;
    oddsVC.roundNum = self.roundNum;
    oddsVC.oddsType = self.oddsType;
    [self.viewController.navigationController pushViewController:oddsVC animated:YES];
}
#pragma mark - 初始化
- (YZFBMatchDetailOddsStatus *)oddsStatus
{
    if (!_oddsStatus) {
        _oddsStatus = [[YZFBMatchDetailOddsStatus alloc] init];
    }
    return _oddsStatus;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            NSMutableArray * array = [NSMutableArray array];
            [_dataArray addObject:array];
        }
    }
    return _dataArray;
}
- (NSArray *)typeButtonTitles
{
    if (!_typeButtonTitles) {
        _typeButtonTitles = @[@"欧赔",@"亚盘",@"大小盘"];
    }
    return _typeButtonTitles;
}
@end
