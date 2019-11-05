//
//  YZScjqBetViewController.m
//  ez
//
//  Created by apple on 14-12-15.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZScjqBetViewController.h"
#import "YZScjqCell.h"

@interface YZScjqBetViewController ()<YZScjqCellDelegate>

@end

@implementation YZScjqBetViewController

- (instancetype)initWithStatusArray:(NSMutableArray *)statusArray playType:(NSString *)playType
{
    if(self = [super init])
    {
        self.statusArray = statusArray;
        _playType = playType;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZScjqCell *cell = [YZScjqCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.betStatus = self.statusArray[indexPath.row];
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return scjqCellH;
}
- (void)scjqCellOddsInfoBtnDidClick:(UIButton *)btn withCell:(YZScjqCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YZScjqCellStatus *status = self.statusArray[indexPath.row];
    
    int btnColum = (int)btn.tag / 4;//按钮所在行
    status.btnStateArray[btnColum][btn.tag % 4] = btn.isSelected ? @(1) : @(0);//所在行额第几个按钮，按钮状态改相反
    NSNumber *btnStateCount = status.btnSelectedCountArr[btnColum];
    int btnCount = [btnStateCount intValue];
    if(btn.selected)
    {
        btnCount ++;
    }else//取消选中
    {
        btnCount --;
        if([status.btnSelectedCountArr[btnColum] intValue] == 1)
        {
            [MBProgressHUD showError:@"至少选择一注"];
            btn.selected = YES;
            status.btnStateArray[btnColum][btn.tag % 4] = btn.isSelected ? @(1) : @(0);
            btnCount ++;
        }
    }
    status.btnSelectedCountArr[btnColum] = [NSNumber numberWithInt:btnCount];
    
    //设置底部的文字
    [self setAmountLabelText];
}
#pragma mark - 计算注数的
- (int)computeBetCount
{
    int count = 1;
    
    for(YZScjqCellStatus *status in self.statusArray)
    {
        for(NSNumber *btnSelectedCount in status.btnSelectedCountArr)
        {
            count = count * [btnSelectedCount intValue];
        }
    }
    self.betCount = count;
    self.amountMoney = 2 * self.betCount * [self.multipleTextField.text intValue];
    return count;
}

- (void)deleteAllSelBtn
{
    for(YZScjqCellStatus *status in self.statusArray)
    {
        [status deleteAllSelBtn];
    }
    [self.tableView reloadData];
    [self setAmountLabelText];
}
- (NSMutableArray *)getTicketList
{
    NSMutableArray *ticketList = [NSMutableArray array];
    NSMutableString *muStr = [NSMutableString string];
    NSArray *spfCodeArr = [NSArray arrayWithObjects:@"0",@"1",@"2",@"3", nil];
    for(YZScjqCellStatus *status in self.statusArray)
    {
        //一次循环是一场次
        for(NSMutableArray *btnStateArray in status.btnStateArray)
        {
            //一次循环是一排按钮的
            for(int i  = 0;i < btnStateArray.count;i++)
            {
                NSNumber *btnState = btnStateArray[i];
                NSString *spfCode = nil;
                if([btnState intValue])//按钮选中
                {
                    spfCode = spfCodeArr[i];
                }
                if(spfCode)
                {
                    [muStr appendString:[NSString stringWithFormat:@"%@,",spfCode]];//赔率间加,
                }
            }
            [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//删除最后一个“,”
            [muStr appendString:@"|"];

        }
    }
    [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//删除最后一个“|”
    NSString *betType = nil;
    if(self.betCount > 1)
    {
        betType = @"01";//复式
    }else
    {
        betType = @"00";//单式
    }
    NSDictionary *dict = @{@"numbers":muStr,
                           @"betType":betType,
                           @"playType":_playType};
    [ticketList addObject:dict];
    return ticketList;
}


@end
