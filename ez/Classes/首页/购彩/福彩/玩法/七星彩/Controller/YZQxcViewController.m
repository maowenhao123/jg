//
//  YZQxcViewController.m
//  ez
//
//  Created by apple on 14-10-21.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZQxcViewController.h"
#import "YZBallBtn.h"
#import "YZBetStatus.h"

@interface YZQxcViewController ()<UITableViewDelegate,UITableViewDataSource,YZSelectBallCellDelegate,YZBallBtnDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *statusArray1;//左边tableview的数据

@property (nonatomic, strong) NSMutableArray *selYiBalls;//已选一位
@property (nonatomic, strong) NSMutableArray *selErBalls;//已选二位
@property (nonatomic, strong) NSMutableArray *selSanBalls;//已选三位
@property (nonatomic, strong) NSMutableArray *selSiBalls;//已选四位
@property (nonatomic, strong) NSMutableArray *selWuBalls;//已选五位
@property (nonatomic, strong) NSMutableArray *selLiuBalls;//已选六位
@property (nonatomic, strong) NSMutableArray *selQiBalls;//已选七位

@property (nonatomic, strong) NSMutableArray *autoSelBallNumbers;//机选号码数组

@property (nonatomic, strong) NSMutableArray *selNumberArray;//已选号码的数组

@property (nonatomic, weak) UIView *playTypeBackView;//选择玩法的背景View

@end

typedef enum{
    KHasNullAutoSel = 11,
}KHasNull;

@implementation YZQxcViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //布局tableView
    [self layoutTableView];
    //移除父类不必要的控件
    [self.backView removeFromSuperview];
    [self.scrollView removeFromSuperview];
}
#pragma mark - 布局tableView
- (void)layoutTableView
{
    CGRect frame = self.tableView1.frame;
    CGFloat tableViewX = frame.origin.x;
    CGFloat tableViewY = CGRectGetMaxY(self.endTimeLabel.frame);
    CGFloat tableViewW = frame.size.width;
    CGFloat tableViewH = screenHeight - statusBarH - navBarH - self.bottomView.height - tableViewY - [YZTool getSafeAreaBottom];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH)];
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
    return self.statusArray1.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSelectBallCell *cell = [YZSelectBallCell cellWithTableView:tableView andIndexpath:indexPath];
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.status = self.statusArray1[indexPath.row];
    cell.tag = indexPath.row;
    cell.owner = self.tableView;
    return  cell;
}
//返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSelectBallCellStatus * status = self.statusArray1[indexPath.row];
    return status.cellH;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.autoSelBallNumbers.count < 7) return;//没有机选return
    YZSelectBallCell *cell1 = (YZSelectBallCell *)cell;
    int selBallNum = [self.autoSelBallNumbers[cell1.tag] intValue];
    if(selBallNum == KHasNullAutoSel) return;//如果是没有需要选中的，return
    YZBallBtn *ball = cell1.ballsArray[selBallNum];
    if(ball.isSelected) return;
    
    [ball ballClick:ball];
    [self setBetCount:1];
    self.autoSelBallNumbers[cell1.tag] = @(KHasNullAutoSel);
}
#pragma  mark - 删除按钮点击
- (void)deleteBtnClick
{
    YZLog(@"deleteBtnClick");
    [self clearSelBalls:self.selYiBalls];
    [self clearSelBalls:self.selErBalls];
    [self clearSelBalls:self.selSanBalls];//移除选中的球对象数组
    [self clearSelBalls:self.selSiBalls];
    [self clearSelBalls:self.selWuBalls];
    [self clearSelBalls:self.selLiuBalls];
    [self clearSelBalls:self.selQiBalls];
    [self.selNumberArray removeAllObjects];//移除选中的球号码数组
    [self computeAmountMoney];
}
#pragma mark - 机选
- (void)autoSelectedBetWithNumber:(NSInteger)number
{
    for (int i = 0; i < number; i++) {
        [YZBetTool autoChooseQxc];
    }
    [self gotoBetVc];
}
#pragma mark - 确认按钮点击
- (void)confirmBtnClick:(UIButton *)btn
{
    YZLog(@"confirmBtnClick");
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
    if (self.selYiBalls.count < 1 || self.selErBalls.count < 1 || self.selSanBalls.count < 1 || self.selSiBalls.count < 1 || self.selWuBalls.count < 1 || self.selLiuBalls.count < 1 || self.selQiBalls.count < 1)
    {//没有一注
        [MBProgressHUD showError:@"请每位至少选择1个号码"];
    }else if(self.betCount * 2 > 20000)
    {
        [MBProgressHUD showError:@"单注金额不能超过2万元"];
    }else//其他正确情况就传数据
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对一位球数组排序
        self.selYiBalls = [self sortBallsArray:self.selYiBalls];
        for(YZBallBtn *btn in self.selYiBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"|"];
        //对二位球数组排序
        self.selErBalls = [self sortBallsArray:self.selErBalls];
        for(YZBallBtn *btn in self.selErBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"|"];
        //对三位球数组排序
        self.selSanBalls = [self sortBallsArray:self.selSanBalls];
        for(YZBallBtn *btn in self.selSanBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"|"];
        //对四位球数组排序
        self.selSiBalls = [self sortBallsArray:self.selSiBalls];
        for(YZBallBtn *btn in self.selSiBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"|"];
        //对五位球数组排序
        self.selWuBalls = [self sortBallsArray:self.selWuBalls];
        for(YZBallBtn *btn in self.selWuBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"|"];
        //对六位球数组排序
        self.selLiuBalls = [self sortBallsArray:self.selLiuBalls];
        for(YZBallBtn *btn in self.selLiuBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"|"];
        //对七位球数组排序
        self.selQiBalls = [self sortBallsArray:self.selQiBalls];
        for(YZBallBtn *btn in self.selQiBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        if(self.betCount == 1)
        {
            [str appendString:@"[单式1注]"];
        }else
        {
            [str appendString:[NSString stringWithFormat:@"[复式%d注]",self.betCount]];
        }
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"["];
        NSRange range2 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, range2.location - range1.location + 1)];
        status.labelText = attStr;
        status.betCount = self.betCount;
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(275, MAXFLOAT)];
         status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
        //删除所有的
        [self deleteBtnClick];
    }
}
#pragma mark - YZBallBtnDelegate的代理方法,点击了ball 按钮
- (void)ballDidClick:(YZBallBtn *)btn
{
    YZSelectBallCell *cell = btn.owner;
    switch (cell.tag)
    {
        case 0:
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selYiBalls removeObject:btn];
            }else
            {
                [self.selYiBalls addObject:btn];
            }
            break;
        case 1:
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selErBalls removeObject:btn];
            }else
            {
                [self.selErBalls addObject:btn];
            }
            break;
        case 2:
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selSanBalls removeObject:btn];
            }else
            {
                [self.selSanBalls addObject:btn];
            }
            break;
        case 3:
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selSiBalls removeObject:btn];
            }else
            {
                [self.selSiBalls addObject:btn];
            }
            break;
        case 4:
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selWuBalls removeObject:btn];
            }else
            {
                [self.selWuBalls addObject:btn];
            }
            break;
        case 5:
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selLiuBalls removeObject:btn];
            }else
            {
                [self.selLiuBalls addObject:btn];
            }
            break;
        case 6:
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selQiBalls removeObject:btn];
            }else
            {
                [self.selQiBalls addObject:btn];
            }
            break;
            
        default:
            break;
    }
    //计算注数和金额
    [self computeAmountMoney];
}
- (NSMutableArray *)statusArray1
{
    if(_statusArray1 == nil)
    {
        _statusArray1 = [NSMutableArray array];
    }
    NSMutableArray *array = [NSMutableArray array];
    //一位cell的数据
    YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"每位都要至少选择1个号码"];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, attStr.length)];
    status.title = attStr;
    NSMutableString *muStr = [NSMutableString string];
    for(YZBallBtn *ball in self.selYiBalls)//已选球
    {
        [muStr appendFormat:@"%ld",(long)ball.tag];
    }
    status.startNumber = @"0";
    status.ballsCount = 10;
    status.isRed = YES;
    status.selballStr = muStr;
    status.icon = @"one_flat";
    [array addObject:status];
    
    //二位cell的数据
    YZSelectBallCellStatus *status1 = [[YZSelectBallCellStatus alloc] init];
    NSMutableString *muStr1 = [NSMutableString string];
    for(YZBallBtn *ball in self.selErBalls)
    {
        [muStr1 appendFormat:@"%ld",(long)ball.tag];
    }
    status1.selballStr = muStr1;
    status1.icon = @"two_flat";
    status1.startNumber = @"0";
    status1.ballsCount = 10;
    status1.isRed = YES;
    [array addObject:status1];
    
    //三位cell的数据
    YZSelectBallCellStatus *status2 = [[YZSelectBallCellStatus alloc] init];
    NSMutableString *muStr2 = [NSMutableString string];
    for(YZBallBtn *ball in self.selSanBalls)
    {
        [muStr2 appendFormat:@"%ld",(long)ball.tag];
    }
    status2.selballStr = muStr2;
    status2.icon = @"three_flat";
    status2.startNumber = @"0";
    status2.ballsCount = 10;
    status2.isRed = YES;
    [array addObject:status2];
    
    //四位cell的数据
    YZSelectBallCellStatus *status3 = [[YZSelectBallCellStatus alloc] init];
    NSMutableString *muStr3 = [NSMutableString string];
    for(YZBallBtn *ball in self.selSiBalls)
    {
        [muStr3 appendFormat:@"%ld",(long)ball.tag];
    }
    status3.selballStr = muStr3;
    status3.icon = @"four_flat";
    status3.startNumber = @"0";
    status3.ballsCount = 10;
    status3.isRed = YES;
    [array addObject:status3];
    
    //五位cell的数据
    YZSelectBallCellStatus *status4 = [[YZSelectBallCellStatus alloc] init];
    NSMutableString *muStr4 = [NSMutableString string];
    for(YZBallBtn *ball in self.selWuBalls)
    {
        [muStr4 appendFormat:@"%ld",(long)ball.tag];
    }
    status4.selballStr = muStr4;
    status4.icon = @"five_flat";
    status4.startNumber = @"0";
    status4.ballsCount = 10;
    status4.isRed = YES;
    [array addObject:status4];
    
    //六位cell的数据
    YZSelectBallCellStatus *status5 = [[YZSelectBallCellStatus alloc] init];
    NSMutableString *muStr5 = [NSMutableString string];
    for(YZBallBtn *ball in self.selLiuBalls)
    {
        [muStr5 appendFormat:@"%ld",(long)ball.tag];
    }
    status5.selballStr = muStr5;
    status5.icon = @"six_flat";
    status5.startNumber = @"0";
    status5.ballsCount = 10;
    status5.isRed = YES;
    [array addObject:status5];
    
    //七位cell的数据
    YZSelectBallCellStatus *status6 = [[YZSelectBallCellStatus alloc] init];
    NSMutableString *muStr6 = [NSMutableString string];
    for(YZBallBtn *ball in self.selQiBalls)
    {
        [muStr6 appendFormat:@"%ld",(long)ball.tag];
    }
    status6.selballStr = muStr6;
    status6.icon = @"seven_flat";
    status6.startNumber = @"0";
    status6.ballsCount = 10;
    status6.isRed = YES;
    [array addObject:status6];
    
    return _statusArray1 = array;
}
- (NSMutableArray *)selYiBalls
{
    if(_selYiBalls == nil)
    {
        _selYiBalls = [NSMutableArray array];
    }
    return _selYiBalls;
}
- (NSMutableArray *)selErBalls
{
    if(_selErBalls == nil)
    {
        _selErBalls = [NSMutableArray array];
    }
    return _selErBalls;
}
- (NSMutableArray *)selSanBalls
{
    if(_selSanBalls == nil)
    {
        _selSanBalls = [NSMutableArray array];
    }
    return _selSanBalls;
}
- (NSMutableArray *)selSiBalls
{
    if(_selSiBalls == nil)
    {
        _selSiBalls = [NSMutableArray array];
    }
    return _selSiBalls;
}
- (NSMutableArray *)selWuBalls
{
    if(_selWuBalls == nil)
    {
        _selWuBalls = [NSMutableArray array];
    }
    return _selWuBalls;
}
- (NSMutableArray *)selLiuBalls
{
    if(_selLiuBalls == nil)
    {
        _selLiuBalls = [NSMutableArray array];
    }
    return _selLiuBalls;
}
- (NSMutableArray *)selQiBalls
{
    if(_selQiBalls == nil)
    {
        _selQiBalls = [NSMutableArray array];
    }
    return _selQiBalls;
}
- (NSMutableArray *)autoSelBallNumbers
{
    if(_autoSelBallNumbers == nil)
    {
        _autoSelBallNumbers = [[NSMutableArray alloc] initWithCapacity:7];
    }
    return _autoSelBallNumbers;
}

- (NSMutableArray *)selNumberArray
{
    if(_selNumberArray == nil)
    {
        _selNumberArray = [NSMutableArray array];
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for(NSArray *arr in self.selYiBalls)
    {
        [tempArr addObject:arr];
    }
    for(NSArray *arr in self.selErBalls)
    {
        [tempArr addObject:arr];
    }
    for(NSArray *arr in self.selSanBalls)
    {
        [tempArr addObject:arr];
    }
    for(NSArray *arr in self.selSiBalls)
    {
        [tempArr addObject:arr];
    }
    for(NSArray *arr in self.selWuBalls)
    {
        [tempArr addObject:arr];
    }
    for(NSArray *arr in self.selLiuBalls)
    {
        [tempArr addObject:arr];
    }
    for(NSArray *arr in self.selQiBalls)
    {
        [tempArr addObject:arr];
    }
    return _selNumberArray = tempArr;
}
//计算注数和金额
- (void)computeAmountMoney
{
    int redComposeCount = (int)(self.selYiBalls.count * self.selErBalls.count * self.selSanBalls.count * self.selSiBalls.count * self.selWuBalls.count * self.selLiuBalls.count * self.selQiBalls.count);
    self.betCount = redComposeCount;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    YZLog(@"scrollViewDidEndDragging");
    [self computeAmountMoney];
}
//摇动机选
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSString * allowShake = [YZUserDefaultTool getObjectForKey:@"allowShake"];
    if ([allowShake isEqualToString:@"0"]) return;
    
    [self deleteBtnClick];
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
    
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath1 atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    NSMutableArray *muArr = [NSMutableArray array];
    while (muArr.count < 7) {
        int random1 = arc4random() % 10;
        YZLog(@"random1 = %d",random1);
        [muArr addObject:@(random1)];
    }
    self.autoSelBallNumbers = muArr;
    for(int i = 0;i < muArr.count;i++)
    {
        YZSelectBallCell *cell = (YZSelectBallCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if(cell.frame.size.width != 0)//如果cell不在屏幕上
        {
            int index = [muArr[i] intValue];
            if(index < 10)
            {
                YZBallBtn *ballBtn = cell.ballsArray[index];
                [ballBtn ballClick:ballBtn];
            }
        }
    }
    [self setBetCount:1];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:6 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath2 atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
//清空号码球数组，让所有已选号码球变回原来颜色
- (void)clearSelBalls:(NSMutableArray *)array
{
    for(int i = 0;i < array.count;i++)
    {
        YZBallBtn *ballBtn = array[i];
        if(ballBtn.isSelected)
        {
            [ballBtn ballChangeToWhite];
        }
    }
    [array removeAllObjects];
}


@end
