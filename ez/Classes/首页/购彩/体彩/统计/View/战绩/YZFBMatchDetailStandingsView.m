//
//  YZFBMatchDetailStandingsView.m
//  ez
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define padding 10

#import "YZFBMatchDetailStandingsView.h"
#import "YZFBMatchDetailTextTableViewCell.h"
#import "YZFBMatchDetailStandingsTitleTableViewCell.h"
#import "YZFBMatchDetailStandingsContentTableViewCell.h"
#import "YZFBMatchDetailNoDataTableViewCell.h"

@interface YZFBMatchDetailStandingsView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation YZFBMatchDetailStandingsView

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
    tableView.contentInset = UIEdgeInsetsMake(0, 0 , padding, 0);
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.bounces = NO;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self addSubview:tableView];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (!self.standingsStatus.historyClose) {
            if (self.standingsStatus.history.matches.count == 0) {//没有数据时
                return 2;
            }else
            {
                return self.standingsStatus.history.matches.count + 2;
            }
        }else//折叠
        {
            return 0;
        }
    }else if (section == 1)
    {
        if (!self.standingsStatus.recentClose) {
            if (self.standingsStatus.homeRecent.matches.count == 0 && self.standingsStatus.awayRecent.matches.count == 0) {//没有数据时
                return 2;
            }else
            {
                return self.standingsStatus.homeRecent.matches.count + 2 + self.standingsStatus.awayRecent.matches.count + 2;
            }
        }else
        {
            return 0;
        }
    }else if (section == 2)
    {
        if (!self.standingsStatus.futureClose) {
            if (self.standingsStatus.homeFuture.count == 0 && self.standingsStatus.awayFuture.count == 0) {//没有数据时
                return 2;
            }else
            {
                return self.standingsStatus.homeFuture.count + 2 + self.standingsStatus.awayFuture.count + 2;
            }
        }else
        {
            return 0;
        }
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//历史交锋
        if (self.standingsStatus.history.matches.count == 0) {//没有数据时
            if (indexPath.row == 0)
            {
                YZFBMatchDetailStandingsTitleTableViewCell * cell = [YZFBMatchDetailStandingsTitleTableViewCell cellWithTableView:tableView];
                cell.isFuture = NO;
                return cell;
            }else
            {
                YZFBMatchDetailNoDataTableViewCell * cell = [YZFBMatchDetailNoDataTableViewCell cellWithTableView:tableView];
                return cell;
            }
        }else
        {
            if (indexPath.row == 0) {
                YZFBMatchDetailTextTableViewCell * cell = [YZFBMatchDetailTextTableViewCell cellWithTableView:tableView];
                YZMatchStatus *matchStatus = self.standingsStatus.history;
                NSString * teamName = matchStatus.name;
                int gameCount = matchStatus.num;
                int homeTeamSuccess = matchStatus.win;
                int homeTeamEqual = matchStatus.draw;
                int homeTeamLost = matchStatus.lost;
                NSString * str = [NSString stringWithFormat:@"  • 近%d次交锋，%@%d胜%d平%d负",gameCount,teamName,homeTeamSuccess,homeTeamEqual,homeTeamLost];
                NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str];
                [attStr addAttribute:NSForegroundColorAttributeName value:YZMDRedColor range:NSMakeRange(str.length - 6, 2)];
                [attStr addAttribute:NSForegroundColorAttributeName value:YZMDBlueColor range:NSMakeRange(str.length - 4, 2)];
                [attStr addAttribute:NSForegroundColorAttributeName value:YZMDGreenColor range:NSMakeRange(str.length - 2, 2)];
                if (!YZStringIsEmpty(teamName)) {//有值时才显示
                    cell.contentLabel.attributedText = attStr;
                }
                return cell;
            }else if (indexPath.row == 1)
            {
                YZFBMatchDetailStandingsTitleTableViewCell * cell = [YZFBMatchDetailStandingsTitleTableViewCell cellWithTableView:tableView];
                cell.isFuture = NO;
                return cell;
            }else
            {
                YZFBMatchDetailStandingsContentTableViewCell * cell = [YZFBMatchDetailStandingsContentTableViewCell cellWithTableView:tableView];
                YZMatchCellStatus *matchCellStatus = self.standingsStatus.history.matches[indexPath.row - 2];
                cell.homeTeam = self.standingsStatus.history.name;
                cell.matchCellStatus = matchCellStatus;
                return cell;
            }
        }
    }else if (indexPath.section == 1)//近期战绩
    {
        if (self.standingsStatus.homeRecent.matches.count == 0 && self.standingsStatus.awayRecent.matches.count == 0) {//没有数据时
            if (indexPath.row == 0)
            {
                YZFBMatchDetailStandingsTitleTableViewCell * cell = [YZFBMatchDetailStandingsTitleTableViewCell cellWithTableView:tableView];
                cell.isFuture = NO;
                return cell;
            }else
            {
                YZFBMatchDetailNoDataTableViewCell * cell = [YZFBMatchDetailNoDataTableViewCell cellWithTableView:tableView];
                return cell;
            }
        }else
        {
            if (indexPath.row == 0 || indexPath.row == self.standingsStatus.homeRecent.matches.count + 2) {
                YZFBMatchDetailTextTableViewCell * cell = [YZFBMatchDetailTextTableViewCell cellWithTableView:tableView];
                YZMatchStatus *matchStatus;
                if (indexPath.row == 0)//主队近期战绩
                {
                    matchStatus = self.standingsStatus.homeRecent;
                }else if (indexPath.row == self.standingsStatus.homeRecent.matches.count + 2)//客队近期战绩
                {
                    matchStatus = self.standingsStatus.awayRecent;
                }
                NSString * teamName = matchStatus.name;
                int gameCount = matchStatus.num;
                int homeTeamSuccess = matchStatus.win;
                int homeTeamEqual = matchStatus.draw;
                int homeTeamLost = matchStatus.lost;
                NSString * str = [NSString stringWithFormat:@"  • 近%d次交锋，%@%d胜%d平%d负",gameCount,teamName,homeTeamSuccess,homeTeamEqual,homeTeamLost];
                NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str];
                [attStr addAttribute:NSForegroundColorAttributeName value:YZMDRedColor range:NSMakeRange(str.length - 6, 2)];
                [attStr addAttribute:NSForegroundColorAttributeName value:YZMDBlueColor range:NSMakeRange(str.length - 4, 2)];
                [attStr addAttribute:NSForegroundColorAttributeName value:YZMDGreenColor range:NSMakeRange(str.length - 2, 2)];
                if (!YZStringIsEmpty(teamName)) {//有值时才显示
                    cell.contentLabel.attributedText = attStr;
                }
                return cell;
            }else if (indexPath.row == 1 || indexPath.row == self.standingsStatus.homeRecent.matches.count + 2 + 1)
            {
                YZFBMatchDetailStandingsTitleTableViewCell * cell = [YZFBMatchDetailStandingsTitleTableViewCell cellWithTableView:tableView];
                cell.isFuture = NO;
                return cell;
            }else
            {
                YZFBMatchDetailStandingsContentTableViewCell * cell = [YZFBMatchDetailStandingsContentTableViewCell cellWithTableView:tableView];
                if (indexPath.row - 2 < self.standingsStatus.homeRecent.matches.count)
                {//主队近期战绩
                    YZMatchCellStatus *matchCellStatus = self.standingsStatus.homeRecent.matches[indexPath.row - 2];
                    cell.homeTeam = self.standingsStatus.homeRecent.name;
                    cell.matchCellStatus = matchCellStatus;
                }
                else if (indexPath.row >= self.standingsStatus.homeRecent.matches.count + 4 && indexPath.row < self.standingsStatus.homeRecent.matches.count + self.standingsStatus.awayRecent.matches.count + 4)
                {//客队近期战绩
                    YZMatchCellStatus *matchCellStatus = self.standingsStatus.awayRecent.matches[indexPath.row - 4 - self.standingsStatus.homeRecent.matches.count];
                    cell.homeTeam = self.standingsStatus.awayRecent.name;
                    cell.matchCellStatus = matchCellStatus;
                }
                return cell;
            }
        }
    }else if (indexPath.section == 2)
    {
        if (self.standingsStatus.homeFuture.count == 0 && self.standingsStatus.awayFuture.count == 0) {//没有数据时
            if (indexPath.row == 0)
            {
                YZFBMatchDetailStandingsTitleTableViewCell * cell = [YZFBMatchDetailStandingsTitleTableViewCell cellWithTableView:tableView];
                cell.isFuture = YES;
                return cell;
            }else
            {
                YZFBMatchDetailNoDataTableViewCell * cell = [YZFBMatchDetailNoDataTableViewCell cellWithTableView:tableView];
                return cell;
            }
        }else
        {
            if (indexPath.row == 0 || indexPath.row == 2 + self.standingsStatus.homeFuture.count) {
                YZFBMatchDetailTextTableViewCell * cell = [YZFBMatchDetailTextTableViewCell cellWithTableView:tableView];
                NSString *teamName;
                if (indexPath.row == 0) {
                    teamName = self.standingsStatus.round.home.name;
                }else if (indexPath.row == 2 + self.standingsStatus.homeFuture.count)
                {
                    teamName = self.standingsStatus.round.away.name;
                }
                NSString * str = [NSString stringWithFormat:@"  • %@",teamName];
                NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:str];
                cell.contentLabel.attributedText = attStr;
                return cell;
            }else if (indexPath.row == 1 || indexPath.row == 2 + self.standingsStatus.homeFuture.count + 1)
            {
                YZFBMatchDetailStandingsTitleTableViewCell * cell = [YZFBMatchDetailStandingsTitleTableViewCell cellWithTableView:tableView];
                cell.isFuture = YES;
                return cell;
            }else
            {
                YZFBMatchDetailStandingsContentTableViewCell * cell = [YZFBMatchDetailStandingsContentTableViewCell cellWithTableView:tableView];
                if (indexPath.row - 2 < self.standingsStatus.homeFuture.count)
                {//主队未来赛事
                    YZMatchFutureStatus *matchFutureStatus = self.standingsStatus.homeFuture[indexPath.row - 2];
                    cell.matchFutureStatus = matchFutureStatus;
                }
                else if (indexPath.row >= self.standingsStatus.homeFuture.count + 4 && indexPath.row < self.standingsStatus.homeFuture.count + self.standingsStatus.awayFuture.count + 4) {//客队未来赛事
                    YZMatchFutureStatus *matchFutureStatus = self.standingsStatus.awayFuture[indexPath.row - 4 - self.standingsStatus.homeFuture.count];
                    cell.matchFutureStatus = matchFutureStatus;
                }
                return cell;
            }
        }
    }
    return nil;
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
    headerButton.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    headerButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    headerButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [headerButton setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    NSArray * headerTexts = @[@"历史交锋",@"近期战绩",@"未来赛事"];
    [headerButton setTitle:headerTexts[section] forState:UIControlStateNormal];
    [headerButton setImageEdgeInsets:UIEdgeInsetsMake(0, headerView.width - 20 - 8, 0, 0)];
    [headerButton setImage:[UIImage imageNamed:@"ft_header_arrow_up"] forState:UIControlStateNormal];
    [headerButton addTarget:self action:@selector(closeButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:headerButton];

    //三角旋转
    if (section == 0) {
        if(self.standingsStatus.historyClose)
        {
            [headerButton setImage:[UIImage imageNamed:@"ft_header_arrow_down"] forState:UIControlStateNormal];
        }else
        {
            [headerButton setImage:[UIImage imageNamed:@"ft_header_arrow_up"] forState:UIControlStateNormal];
        }
    }else if (section == 1)
    {
        if(self.standingsStatus.recentClose)
        {
            [headerButton setImage:[UIImage imageNamed:@"ft_header_arrow_down"] forState:UIControlStateNormal];
        }else
        {
            [headerButton setImage:[UIImage imageNamed:@"ft_header_arrow_up"] forState:UIControlStateNormal];
        }
    }else if (section == 2)
    {
        if(self.standingsStatus.futureClose)
        {
            [headerButton setImage:[UIImage imageNamed:@"ft_header_arrow_down"] forState:UIControlStateNormal];
        }else
        {
            [headerButton setImage:[UIImage imageNamed:@"ft_header_arrow_up"] forState:UIControlStateNormal];
        }
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
    if (button.tag == 0) {
        self.standingsStatus.historyClose = !self.standingsStatus.historyClose;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:button.tag];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }else if (button.tag == 1)
    {
        self.standingsStatus.recentClose = !self.standingsStatus.recentClose;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:button.tag];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }else if (button.tag == 2)
    {
        self.standingsStatus.futureClose = !self.standingsStatus.futureClose;
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:button.tag];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark - 初始化
- (YZFBMatchDetailStandingsStatus *)standingsStatus
{
    if (!_standingsStatus) {
        _standingsStatus = [[YZFBMatchDetailStandingsStatus alloc] init];
    }
    return _standingsStatus;
}
@end
