//
//  YZQxcViewController.m
//  ez
//
//  Created by apple on 14-10-21.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZNewQxcViewController.h"
#import "YZBallBtn.h"
#import "YZBetStatus.h"

@interface YZNewQxcViewController ()<UITableViewDelegate, UITableViewDataSource, YZSelectBallCellDelegate, YZBallBtnDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *statusArray;//数据
@property (nonatomic, strong) NSMutableArray *selBallArrays;//已选
@property (nonatomic, strong) NSMutableArray *autoSelBallNumbers;//机选号码数组

@end

@implementation YZNewQxcViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutTableView];
    [self.backView removeFromSuperview];
    [self.scrollView removeFromSuperview];
}

#pragma mark - 布局tableView
- (void)layoutTableView
{
    CGFloat tableViewH = self.autoSelectedLabel.y - CGRectGetMaxY(self.endTimeLabel.frame);
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.endTimeLabel.frame), screenWidth, tableViewH)];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:tableView];
    [self.view bringSubviewToFront:self.autoSelectedLabel];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSelectBallCell *cell = [YZSelectBallCell cellWithTableView:tableView andIndexpath:indexPath];
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.status = self.statusArray[indexPath.row];
    cell.tag = indexPath.row;
    cell.owner = self.tableView;
    return cell;
}

//返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSelectBallCellStatus * status = self.statusArray[indexPath.row];
    return status.cellH;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.autoSelBallNumbers.count < 7) return;//没有机选return
    YZSelectBallCell *cell1 = (YZSelectBallCell *)cell;
    int selBallNum = [self.autoSelBallNumbers[cell1.tag] intValue];
    YZBallBtn *ball = cell1.ballsArray[selBallNum];
    if(ball.isSelected) return;
    [ball ballClick:ball];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self computeAmountMoney];
}

#pragma  mark - 删除按钮点击
- (void)deleteBtnClick
{
    for (NSMutableArray *selBalls in self.selBallArrays) {
        for (YZBallBtn *ballBtn in selBalls) {
            if(ballBtn.isSelected)
            {
                [ballBtn ballChangeToWhite];
            }
        }
        [selBalls removeAllObjects];
    }
    [self computeAmountMoney];
}

#pragma mark - 机选
- (void)autoSelectedBetWithNumber:(NSInteger)number
{
    for (int i = 0; i < number; i++) {
        [YZBetTool autoChooseNewQxc];
    }
    [self gotoBetVc];
}

#pragma mark - 确认按钮点击
- (void)confirmBtnClick:(UIButton *)btn
{
    [self commitNormalBet];
    [self gotoBetVc];
}

- (void)gotoBetVc
{
    //页面跳转
    YZBetViewController *bet = [[YZBetViewController alloc] init];//投注控制器
    bet.gameId = self.gameId;
    [self.navigationController pushViewController: bet animated:YES];
}

- (void)commitNormalBet//提交普通的数据
{
    if (self.betCount == 0)//没有一注
    {
        [MBProgressHUD showError:@"请每位至少选择1个号码"];
    }else if(self.betCount * 2 > 20000)
    {
        [MBProgressHUD showError:@"单注金额不能超过2万元"];
    }else//其他正确情况就传数据
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *betStr = [NSMutableString string];
        NSMutableString *lastBetStr = [NSMutableString string];
        for (NSMutableArray *selBalls in self.selBallArrays) {
            NSInteger index = [self.selBallArrays indexOfObject:selBalls];
            NSMutableString *subBetStr = [NSMutableString string];
            NSArray * selBalls_ = [self sortBallsArray:selBalls];
            for(YZBallBtn *btn in selBalls_)
            {
                [subBetStr appendFormat:@"%ld,", (long)btn.tag];
            }
            if (subBetStr.length > 0) {
                [subBetStr deleteCharactersInRange:NSMakeRange(subBetStr.length-1, 1)];//去掉最后一个逗号
            }
            [betStr appendString:subBetStr];
            if (index == 6) {
                lastBetStr = subBetStr;
            }
            if (index == 5) {
                [betStr appendString:@"#"];
            }else
            {
                [betStr appendString:@"|"];
            }
        }
        if (betStr.length > 0) {
            [betStr deleteCharactersInRange:NSMakeRange(betStr.length-1, 1)];//去掉最后一个|
        }
        if (self.betCount == 1)
        {
            [betStr appendString:@"[单式1注]"];
        }else
        {
            BOOL frontMultiple = NO;
            BOOL laterMultiple = NO;
            for (NSMutableArray *selBalls in self.selBallArrays) {
                NSInteger index = [self.selBallArrays indexOfObject:selBalls];
                if (index == 6) {
                    laterMultiple = selBalls.count > 1;
                }else
                {
                    frontMultiple = selBalls.count > 1;
                }
            }
            if (frontMultiple && laterMultiple) {
                [betStr appendString:[NSString stringWithFormat:@"[全复%d注]", self.betCount]];
            }else if (frontMultiple && !laterMultiple)
            {
                [betStr appendString:[NSString stringWithFormat:@"[前六位复式%d注]", self.betCount]];
            }else if (!frontMultiple && laterMultiple)
            {
                [betStr appendString:[NSString stringWithFormat:@"[最后一位复式%d注]", self.betCount]];
            }
        }
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:betStr];
        NSRange range1 = [betStr rangeOfString:@"["];
        NSRange range2 = [betStr rangeOfString:@"]"];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(range1.location - lastBetStr.length - 1, lastBetStr.length + 1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, range2.location - range1.location + 1)];
        status.labelText = attStr;
        status.betCount = self.betCount;
        CGSize labelSize = [attStr.string sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(275, MAXFLOAT)];
         status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        [YZStatusCacheTool saveStatus:status];
        
        //删除所有的
        [self deleteBtnClick];
    }
}

#pragma mark - 计算注数和金额
- (void)computeAmountMoney
{
    int redComposeCount = 1;
    for (NSMutableArray *selBalls in self.selBallArrays) {
        redComposeCount *= selBalls.count;
    }
    self.betCount = redComposeCount;
}

#pragma mark - YZBallBtnDelegate的代理方法,点击了ball 按钮
- (void)ballDidClick:(YZBallBtn *)btn
{
    YZSelectBallCell *cell = btn.owner;
    NSMutableArray *selBalls = self.selBallArrays[cell.tag];
    if (btn.isSelected)//之前是选中的就移除
    {
        [selBalls removeObject:btn];
    }else
    {
        [selBalls addObject:btn];
    }
    //计算注数和金额
    [self computeAmountMoney];
}

#pragma mark - 初始化
- (NSMutableArray *)selBallArrays
{
    if (_selBallArrays == nil)
    {
        _selBallArrays = [NSMutableArray array];
        for (int i = 0; i < 7; i++) {
            [_selBallArrays addObject:[NSMutableArray array]];
        }
    }
    return _selBallArrays;
}

- (NSMutableArray *)statusArray
{
    if (_statusArray == nil)
    {
        _statusArray = [NSMutableArray array];
    }
    [_statusArray removeAllObjects];
    for (int i = 0; i < 7; i++) {
        YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
        if (i == 0) {
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"每位都要至少选择1个号码"];
            [attStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, attStr.length)];
            status.title = attStr;
        }
        NSMutableString *muStr = [NSMutableString string];
        NSMutableArray *selBalls = self.selBallArrays[i];
        for(YZBallBtn *ball in selBalls)//已选球
        {
            [muStr appendFormat:@"%ld", (long)ball.tag];
        }
        if (i == 6) {
            status.ballsCount = 15;
            status.isRed = NO;
        }else
        {
            status.ballsCount = 10;
            status.isRed = YES;
        }
        status.startNumber = @"0";
        status.selballStr = muStr;
        if (i == 0) {
            status.icon = @"one_flat";
        }else if (i == 1)
        {
            status.icon = @"two_flat";
        }else if (i == 2)
        {
            status.icon = @"three_flat";
        }else if (i == 3)
        {
            status.icon = @"four_flat";
        }else if (i == 4)
        {
            status.icon = @"five_flat";
        }else if (i == 5)
        {
            status.icon = @"six_flat";
        }else if (i == 6)
        {
            status.icon = @"seven_flat";
        }
        [_statusArray addObject:status];
    }
    return _statusArray;
}

- (NSMutableArray *)autoSelBallNumbers
{
    if(_autoSelBallNumbers == nil)
    {
        _autoSelBallNumbers = [[NSMutableArray alloc] initWithCapacity:7];
    }
    return _autoSelBallNumbers;
}

#pragma mark - 摇动机选
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSString * allowShake = [YZUserDefaultTool getObjectForKey:@"allowShake"];
    if ([allowShake isEqualToString:@"0"]) return;
    
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self deleteBtnClick];
    [self.autoSelBallNumbers removeAllObjects];
    while (self.autoSelBallNumbers.count < 7) {
        YZSelectBallCellStatus *status = self.statusArray[self.autoSelBallNumbers.count];
        int random = arc4random() % status.ballsCount;
        [self.autoSelBallNumbers addObject:@(random)];
    }
    for(int i = 0;i < self.autoSelBallNumbers.count;i++)
    {
        YZSelectBallCell *cell = (YZSelectBallCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if (!YZObjectIsEmpty(cell))//如果cell在屏幕上
        {
            int number = [self.autoSelBallNumbers[i] intValue];
            YZSelectBallCellStatus *status = self.statusArray[i];
            if(number < status.ballsCount)
            {
                YZBallBtn *ballBtn = cell.ballsArray[number];
                [ballBtn ballClick:ballBtn];
            }
        }
    }
    [self setBetCount:1];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


@end
