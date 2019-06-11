//
//  YZFBMatchDetailIntegralView.m
//  ez
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define padding 10

#import "YZFBMatchDetailIntegralView.h"
#import "YZFBMatchDetailTypeBtnView.h"
#import "YZFBMatchDetailIntegralTitleTableViewCell.h"
#import "YZFBMatchDetailIntegralContentTableViewCell.h"
#import "YZFBMatchDetailNoDataTableViewCell.h"

@interface YZFBMatchDetailIntegralView ()<UITableViewDelegate,UITableViewDataSource,YZFBMatchDetailTypeBtnViewDelegate>

@property (nonatomic, assign) NSInteger integralType;//积分类型

@end

@implementation YZFBMatchDetailIntegralView

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
    //tableview
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(padding, 0, self.width - 2 * padding, self.height)];
    self.tableView = tableView;
    tableView.contentInset = UIEdgeInsetsMake(0, 0 , padding, 0);
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self addSubview:tableView];
    
    UIView * headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, screenWidth, 40);
    headerView.backgroundColor = YZBackgroundColor;
    
    NSArray * typeButtonTitles = @[@"总积分",@"主场积分",@"客场积分"];
    CGFloat typeBtnViewW = 80 * typeButtonTitles.count;
    CGFloat typeBtnViewX = (screenWidth - typeBtnViewW) / 2;
    YZFBMatchDetailTypeBtnView * typeBtnView = [[YZFBMatchDetailTypeBtnView alloc] initWithFrame:CGRectMake(typeBtnViewX, 10, typeBtnViewW, 30) titleArray:typeButtonTitles];
    typeBtnView.delegate = self;
    [headerView addSubview:typeBtnView];
    tableView.tableHeaderView = headerView;
    
    //暂无数据
    UILabel * noDataLabel = [[UILabel alloc] init];
    self.noDataLabel = noDataLabel;
    noDataLabel.text = @"暂无数据";
    noDataLabel.textColor = YZGrayTextColor;
    noDataLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    CGSize noDataLabelSzie = [noDataLabel.text sizeWithLabelFont:noDataLabel.font];
    CGFloat noDataLabelW = noDataLabelSzie.width;
    CGFloat noDataLabelH = noDataLabelSzie.height;
    CGFloat noDataLabelX = (self.width - noDataLabelW) / 2;
    CGFloat noDataLabelY = 55;
    noDataLabel.frame = CGRectMake(noDataLabelX, noDataLabelY, noDataLabelW, noDataLabelH);
    [self addSubview:noDataLabel];
}
//类型按钮点击
- (void)typeSegmentControlSelectedIndex:(NSInteger)index
{
    self.integralType = index;
    [self.tableView reloadData];
    self.noDataLabel.hidden = YES;
    if (self.integralType == 0) {//总积分
        if (self.integralStatus.totalScores.count == 0) {//没有数据时
            self.noDataLabel.hidden = NO;
        }
    }else if (self.integralType == 1)//主场积分
    {
        if (self.integralStatus.homeScores.count == 0) {//没有数据时
            self.noDataLabel.hidden = NO;
        }
    }else if (self.integralType == 2)//客场积分
    {
        if (self.integralStatus.awayScores.count == 0) {//没有数据时
            self.noDataLabel.hidden = NO;
        }
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.integralType == 0) {//总积分
        return self.integralStatus.totalScores.count;
    }else if (self.integralType == 1)//主场积分
    {
        return self.integralStatus.homeScores.count;
    }else if (self.integralType == 2)//客场积分
    {
        return self.integralStatus.awayScores.count;
    }
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.integralType == 0) {//总积分
        YZScoreRowStatus * scoreRowStatus = self.integralStatus.totalScores[section];
        if (scoreRowStatus.close) {//关闭
            return 0;
        }
        if (scoreRowStatus.scores.count == 0) {//没有数据时
            return 2;
        }
        return scoreRowStatus.scores.count + 1;
    }else if (self.integralType == 1)//主场积分
    {
        YZScoreRowStatus * scoreRowStatus = self.integralStatus.homeScores[section];
        if (scoreRowStatus.close) {//关闭
            return 0;
        }
        if (scoreRowStatus.scores.count == 0) {//没有数据时
            return 2;
        }
        return scoreRowStatus.scores.count + 1;
    }else if (self.integralType == 2)//客场积分
    {
        YZScoreRowStatus * scoreRowStatus = self.integralStatus.awayScores[section];
        if (scoreRowStatus.close) {//关闭
            return 0;
        }
        if (scoreRowStatus.scores.count == 0) {//没有数据时
            return 2;
        }
        return scoreRowStatus.scores.count + 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        YZFBMatchDetailIntegralTitleTableViewCell * cell = [YZFBMatchDetailIntegralTitleTableViewCell cellWithTableView:tableView];
        return cell;
    }else
    {
        NSArray * teamNames = @[self.integralStatus.round.home.name,self.integralStatus.round.away.name];
        if (self.integralType == 0) {//总积分
            YZScoreRowStatus * scoreRowStatus = self.integralStatus.totalScores[indexPath.section];
            if (scoreRowStatus.scores.count == 0) {//没有数据时
                YZFBMatchDetailNoDataTableViewCell * cell = [YZFBMatchDetailNoDataTableViewCell cellWithTableView:tableView];
                return cell;
            }else
            {
                YZFBMatchDetailIntegralContentTableViewCell * cell = [YZFBMatchDetailIntegralContentTableViewCell cellWithTableView:tableView];
                cell.integralStatus = scoreRowStatus.scores[indexPath.row - 1];
                cell.teamNames = teamNames;
                return cell;
            }
        }else if (self.integralType == 1)//主场积分
        {
            YZScoreRowStatus * scoreRowStatus = self.integralStatus.homeScores[indexPath.section];
            if (scoreRowStatus.scores.count == 0) {//没有数据时
                YZFBMatchDetailNoDataTableViewCell * cell = [YZFBMatchDetailNoDataTableViewCell cellWithTableView:tableView];
                return cell;
            }else
            {
                YZFBMatchDetailIntegralContentTableViewCell * cell = [YZFBMatchDetailIntegralContentTableViewCell cellWithTableView:tableView];
                cell.integralStatus = scoreRowStatus.scores[indexPath.row - 1];
                cell.teamNames = teamNames;
                return cell;
            }
        }else if (self.integralType == 2)//客场积分
        {
            YZScoreRowStatus * scoreRowStatus = self.integralStatus.awayScores[indexPath.section];
            if (scoreRowStatus.scores.count == 0) {//没有数据时
                YZFBMatchDetailNoDataTableViewCell * cell = [YZFBMatchDetailNoDataTableViewCell cellWithTableView:tableView];
                return cell;
            }else
            {
                YZFBMatchDetailIntegralContentTableViewCell * cell = [YZFBMatchDetailIntegralContentTableViewCell cellWithTableView:tableView];
                cell.integralStatus = scoreRowStatus.scores[indexPath.row - 1];
                cell.teamNames = teamNames;
                return cell;
            }
        }
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35 + padding;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 35 + padding)];
    headerView.backgroundColor = YZBackgroundColor;
    
    UIButton * headerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headerButton.tag = section;
    headerButton.frame = CGRectMake(0, padding, tableView.width, 35);
    headerButton.backgroundColor = [UIColor whiteColor];
    headerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    headerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [headerButton setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    
    YZScoreRowStatus * scoreRowStatus;
    if (self.integralType == 0) {//总积分
        scoreRowStatus = self.integralStatus.totalScores[section];
    }else if (self.integralType == 1)//主场积分
    {
        scoreRowStatus = self.integralStatus.homeScores[section];
    }else if (self.integralType == 2)//客场积分
    {
        scoreRowStatus = self.integralStatus.awayScores[section];
    }
    NSString * headerButtonTitle = scoreRowStatus.title;
    BOOL close = scoreRowStatus.close;
    
    if (YZStringIsEmpty(headerButtonTitle) || [headerButtonTitle rangeOfString:@"null"].location != NSNotFound) {
        headerButtonTitle = @"联赛积分榜";
    }
    [headerButton setTitle:headerButtonTitle forState:UIControlStateNormal];
    [headerButton setImageEdgeInsets:UIEdgeInsetsMake(0, headerView.width - 20 - 8, 0, 0)];
    [headerButton setImage:[UIImage imageNamed:@"ft_header_arrow_up"] forState:UIControlStateNormal];
    [headerButton addTarget:self action:@selector(closeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:headerButton];
    
    if (close) {//联赛
        [headerButton setImage:[UIImage imageNamed:@"ft_header_arrow_down"] forState:UIControlStateNormal];
    }else
    {
        [headerButton setImage:[UIImage imageNamed:@"ft_header_arrow_up"] forState:UIControlStateNormal];
    }

    //分割线
    UIView * line_left = [[UIView alloc] initWithFrame:CGRectMake(0, padding, 1, 35)];
    line_left.backgroundColor = YZWhiteLineColor;
    [headerView addSubview:line_left];
    
    UIView * line_right = [[UIView alloc] initWithFrame:CGRectMake(tableView.width - 1, padding, 1, 35)];
    line_right.backgroundColor = YZWhiteLineColor;
    [headerView addSubview:line_right];
    
    UIView * line_up = [[UIView alloc] initWithFrame:CGRectMake(0, padding, tableView.width, 1)];
    line_up.backgroundColor = YZWhiteLineColor;
    [headerView addSubview:line_up];
    
    UIView * line_down = [[UIView alloc] initWithFrame:CGRectMake(0, padding + 35 - 1, tableView.width, 1)];
    line_down.backgroundColor = YZWhiteLineColor;
    [headerView addSubview:line_down];
    
    return headerView;
}
- (void)closeButtonDidClick:(UIButton *)button
{
    YZScoreRowStatus * scoreRowStatus;
    if (self.integralType == 0) {//总积分
        scoreRowStatus = self.integralStatus.totalScores[button.tag];
    }else if (self.integralType == 1)//主场积分
    {
        scoreRowStatus = self.integralStatus.homeScores[button.tag];
    }else if (self.integralType == 2)//客场积分
    {
        scoreRowStatus = self.integralStatus.awayScores[button.tag];
    }
    scoreRowStatus.close = !scoreRowStatus.close;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:button.tag];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
@end
