//
//  YZScjqViewController.m
//  ez
//
//  Created by apple on 14-12-15.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZScjqViewController.h"
#import "YZScjqCell.h"
#import "YZMatchInfosStatus.h"
#import "YZGameIndosStatus.h"
#import "YZScjqBetViewController.h"

@interface YZScjqViewController ()<YZScjqCellDelegate>

@end

@implementation YZScjqViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = nil;
    self.title = @"四场进球";
    //设置底下文字
    self.bottomMidLabel.text = @"  还需选择4场比赛";
    _minMatchCounts = [NSArray arrayWithObjects:@(4),@(9), nil];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZScjqCell *cell = [YZScjqCell cellWithTableView:tableView];
    cell.delegate = self;
    NSMutableArray *termIdStatusArray = self.statusArray[_selectedTermIdBtnTag];
    cell.status = termIdStatusArray[indexPath.row];
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return scjqCellH;
}
#pragma mark - cell的赔率按钮点击
- (void)scjqCellOddsInfoBtnDidClick:(UIButton *)btn withCell:(YZScjqCell *)cell
{
    NSMutableArray *termIdStatusArray = self.statusArray[_selectedTermIdBtnTag];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YZScjqCellStatus *status = termIdStatusArray[indexPath.row];
    
    int btnColum = (int)btn.tag / 4;//按钮所在行
    status.btnStateArray[btnColum][btn.tag % 4] = btn.isSelected ? @(1) : @(0);//所在行额第几个按钮，按钮状态改相反
    NSNumber *btnStateCount = status.btnSelectedCountArr[btnColum];
    int btnCount = [btnStateCount intValue];
    if(btn.selected)
    {
        btnCount ++;
    }else
    {
        btnCount --;
    }
    status.btnSelectedCountArr[btnColum] = [NSNumber numberWithInt:btnCount];
    
    //设置底部的文字
    [self setBottomMidLabelText];
}
- (void)setBottomMidLabelText
{
    int count = 0;
    
    for(YZScjqCellStatus *status in self.statusArray[_selectedTermIdBtnTag])
    {
        NSNumber *btnSelectedCount1 = [status.btnSelectedCountArr firstObject];
        NSNumber *btnSelectedCount2 = [status.btnSelectedCountArr lastObject];
        if([btnSelectedCount1 intValue]> 0 && [btnSelectedCount2 intValue]> 0)//俩排按钮都选了
        count ++;//选中一个场次，计数加1
    }
    _selectedMatchCount = count;
    
    NSString *title = nil;
    int minMatchCount = [_minMatchCounts[0] intValue];
    if(count < minMatchCount)
    {
        title = [NSString stringWithFormat:@"  还需选择%d场比赛",minMatchCount-count];
        _betCount = 0;
    }else
    {
        title = [NSString stringWithFormat:@"  您已选择%d注",[self computeBetCount]];
    }
    self.bottomMidLabel.text = title;
}

- (void)deleteBtnClick
{
    if(!self.statusArray.count) return;
        
    for(YZScjqCellStatus *status in self.statusArray[_selectedTermIdBtnTag])
    {
        [status deleteAllSelBtn];//删除所有选中按钮
    }
    _selectedMatchCount = 0;
    [self.tableView reloadData];
    NSString *title = [NSString stringWithFormat:@"  还需选择%d场比赛",[[_minMatchCounts firstObject] intValue]];
    self.bottomMidLabel.text = title;
}
#pragma mark - 计算注数的
- (int)computeBetCount
{
    int count = 1;
    
    for(YZScjqCellStatus *status in self.statusArray[_selectedTermIdBtnTag])
    {
        for(NSNumber *btnSelectedCount in status.btnSelectedCountArr)
        {
            count = count * [btnSelectedCount intValue];
        }
    }
    _betCount = count;
    return count;
}
#pragma mark -  确认按钮点击
- (void)confirmBtnClick
{
    if(_betCount == 0)
    {
        [MBProgressHUD showError:@"至少选择一注"];
        return;
    }
    YZScjqBetViewController *betVc = [[YZScjqBetViewController alloc] initWithStatusArray:[self getBetStatus] playType:@"01"];
    betVc.gameId = self.gameId;
    betVc.termId = _termIds[_selectedTermIdBtnTag];
    betVc.title = [NSString stringWithFormat:@"%@投注",self.title];
    [self.navigationController pushViewController:betVc animated:YES];
}
- (NSMutableArray *)getBetStatus
{
    return [self.statusArray firstObject];
}
- (void)setStatusArray
{
    //数据源数组
    NSMutableArray *statusArray = [NSMutableArray array];
    
    //设置期数数组
    NSMutableArray *termIds = [NSMutableArray array];
    for(YZGameIndosStatus *matchInfos in self.matchInfosStatusArray)
    {
        [termIds addObject:matchInfos.termId];//期数数组
        
        NSMutableArray *termIdstatusArray = [NSMutableArray array];
        NSArray *detailInfos = [matchInfos.matchGames componentsSeparatedByString:@";"];//元素是nsstring,是一场比赛
        for(int i = 0; i < detailInfos.count;i++)
        {
            NSString *cellStatusStr = detailInfos[i];
            NSArray *cellStatusArray = [cellStatusStr componentsSeparatedByString:@"|"];
            YZScjqCellStatus *status = [[YZScjqCellStatus alloc] init];
            status.number = i+1;
            status.matchName = cellStatusArray[1];
            NSString *endTimeTemp = [[cellStatusArray firstObject] substringWithRange:NSMakeRange(8, 4)];
            NSMutableString *muEndTimeTemp = [endTimeTemp mutableCopy];
            [muEndTimeTemp insertString:@":" atIndex:2];
            status.endTime = [muEndTimeTemp copy];
            
            status.vsText = [NSString stringWithFormat:@"%@\nvs\n%@",cellStatusArray[2],cellStatusArray[3]];
            status.code = [cellStatusArray firstObject];
            [termIdstatusArray addObject:status];
        }
        [statusArray  addObject:termIdstatusArray];
    }
    _termIds = termIds;//期数数组
    self.statusArray = statusArray;//数据源
}

@end
