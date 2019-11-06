//
//  YZPlwViewController.m
//  ez
//
//  Created by apple on 14-10-21.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZPlwViewController.h"
#import "YZBallBtn.h"
#import "YZBetStatus.h"

@interface YZPlwViewController ()<UITableViewDelegate,UITableViewDataSource,YZSelectBallCellDelegate,YZBallBtnDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *statusArray1;//左边tableview的数据
@property (nonatomic, strong) NSMutableArray *selWanBalls;//已选万位
@property (nonatomic, strong) NSMutableArray *selQianBalls;//已选千位
@property (nonatomic, strong) NSMutableArray *selBaiBalls;//已选百位
@property (nonatomic, strong) NSMutableArray *selShiBalls;//已选十位
@property (nonatomic, strong) NSMutableArray *selGeBalls;//已选个位
@property (nonatomic, strong) NSMutableArray *autoSelBallNumbers;//机选号码数组
@property (nonatomic, strong) NSMutableArray *selNumberArray;//已选号码的数组
@property (nonatomic, weak) UIView *playTypeBackView;//选择玩法的背景View

@end

typedef enum{
    KHasNullAutoSel = 11,
}KHasNull;


@implementation YZPlwViewController

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
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH)];
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
    if(self.autoSelBallNumbers.count < 5) return;//没有机选return
    YZSelectBallCell *cell1 = (YZSelectBallCell *)cell;
    int selBallNum = [self.autoSelBallNumbers[cell1.tag] intValue];
    if(selBallNum == KHasNullAutoSel) return;//如果是没有需要选中的，return
    YZBallBtn *ball = cell1.ballsArray[selBallNum];
    if(ball.isSelected) return;
    
    [ball ballClick:ball];
    self.autoSelBallNumbers[cell1.tag] = @(KHasNullAutoSel);
}
#pragma  mark - 删除按钮点击
- (void)deleteBtnClick
{
    YZLog(@"deleteBtnClick");
    [self clearSelBalls:self.selWanBalls];
    [self clearSelBalls:self.selQianBalls];
    [self clearSelBalls:self.selBaiBalls];//移除选中的球对象数组
    [self clearSelBalls:self.selShiBalls];
    [self clearSelBalls:self.selGeBalls];
    [self.selNumberArray removeAllObjects];//移除选中的球号码数组
    [self computeAmountMoney];
}
#pragma mark - 机选
- (void)autoSelectedBetWithNumber:(NSInteger)number
{
    for (int i = 0; i < number; i++) {
        [YZBetTool autoChoosePlw];
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
- (void)commitNormalBet//提交普通的数据
{
    if (self.selWanBalls.count < 1 || self.selQianBalls.count < 1 || self.selBaiBalls.count < 1 || self.selShiBalls.count < 1 || self.selGeBalls.count < 1)
    {//没有一注
        [MBProgressHUD showError:@"请每位至少选择1个号码"];
    }else if(self.betCount * 2 > 20000)
    {
        [MBProgressHUD showError:@"单注金额不能超过2万元"];
    }else//其他正确情况就传数据
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对万位球数组排序
        self.selWanBalls = [self sortBallsArray:self.selWanBalls];
        for(YZBallBtn *btn in self.selWanBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"|"];
        //对千位球数组排序
        self.selQianBalls = [self sortBallsArray:self.selQianBalls];
        for(YZBallBtn *btn in self.selQianBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"|"];
        //对百位球数组排序
        self.selBaiBalls = [self sortBallsArray:self.selBaiBalls];
        for(YZBallBtn *btn in self.selBaiBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"|"];
        //对十位球数组排序
        self.selShiBalls = [self sortBallsArray:self.selShiBalls];
        for(YZBallBtn *btn in self.selShiBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"|"];
        //对个位球数组排序
        self.selGeBalls = [self sortBallsArray:self.selGeBalls];
        for(YZBallBtn *btn in self.selGeBalls)
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
        NSRange range1 = [str rangeOfString:@"["];//20
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
- (void)gotoBetVc
{
    //页面跳转
    YZBetViewController *bet = [[YZBetViewController alloc] init];//投注控制器
    bet.gameId = self.gameId;
    [self.navigationController pushViewController: bet animated:YES];
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
                [self.selWanBalls removeObject:btn];
            }else
            {
                [self.selWanBalls addObject:btn];
            }
            break;
        case 1:
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selQianBalls removeObject:btn];
            }else
            {
                [self.selQianBalls addObject:btn];
            }
            break;
        case 2:
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selBaiBalls removeObject:btn];
            }else
            {
                [self.selBaiBalls addObject:btn];
            }
            break;
        case 3:
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selShiBalls removeObject:btn];
            }else
            {
                [self.selShiBalls addObject:btn];
            }
            break;
        case 4:
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selGeBalls removeObject:btn];
            }else
            {
                [self.selGeBalls addObject:btn];
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
    //万位cell的数据
    YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"每位都要至少选择1个号码"];
    status.title = attStr;
    NSMutableString *muStr = [NSMutableString string];
    for(YZBallBtn *ball in self.selWanBalls)
    {
        [muStr appendFormat:@"%ld",(long)ball.tag];
    }
    status.selballStr = muStr;
    status.icon = @"wan_flat";
    status.startNumber = @"0";
    status.ballsCount = 10;
    status.isRed = YES;
    [array addObject:status];
    
    //千位cell的数据
    YZSelectBallCellStatus *status1 = [[YZSelectBallCellStatus alloc] init];
    NSMutableString *muStr1 = [NSMutableString string];
    for(YZBallBtn *ball in self.selQianBalls)
    {
        [muStr1 appendFormat:@"%ld",(long)ball.tag];
    }
    status1.selballStr = muStr1;
    status1.icon = @"qian_flat";
    status1.startNumber = @"0";
    status1.ballsCount = 10;
    status1.isRed = YES;
    [array addObject:status1];
    
    //百位cell的数据
    YZSelectBallCellStatus *status2 = [[YZSelectBallCellStatus alloc] init];
    NSMutableString *muStr2 = [NSMutableString string];
    for(YZBallBtn *ball in self.selBaiBalls)
    {
        [muStr2 appendFormat:@"%ld",(long)ball.tag];
    }
    status2.selballStr = muStr2;
    status2.icon = @"bai_btn_flat";
    status2.startNumber = @"0";
    status2.ballsCount = 10;
    status2.isRed = YES;
    [array addObject:status2];
    
    //十位cell的数据
    YZSelectBallCellStatus *status3 = [[YZSelectBallCellStatus alloc] init];
    NSMutableString *muStr3 = [NSMutableString string];
    for(YZBallBtn *ball in self.selShiBalls)
    {
        [muStr3 appendFormat:@"%ld",(long)ball.tag];
    }
    status3.selballStr = muStr3;
    status3.icon = @"shi_flat";
    status3.startNumber = @"0";
    status3.ballsCount = 10;
    status3.isRed = YES;
    [array addObject:status3];
    
    //个位cell的数据
    YZSelectBallCellStatus *status4 = [[YZSelectBallCellStatus alloc] init];
    NSMutableString *muStr4 = [NSMutableString string];
    for(YZBallBtn *ball in self.selGeBalls)
    {
        [muStr4 appendFormat:@"%ld",(long)ball.tag];
    }
    status4.selballStr = muStr4;
    status4.icon = @"ge_flat";
    status4.startNumber = @"0";
    status4.ballsCount = 10;
    status4.isRed = YES;
    [array addObject:status4];
    
    return _statusArray1 = array;
}
- (NSMutableArray *)selGeBalls
{
    if(_selGeBalls == nil)
    {
        _selGeBalls = [NSMutableArray array];
    }
    return _selGeBalls;
}
- (NSMutableArray *)selShiBalls
{
    if(_selShiBalls == nil)
    {
        _selShiBalls = [NSMutableArray array];
    }
    return _selShiBalls;
}
- (NSMutableArray *)selBaiBalls
{
    if(_selBaiBalls == nil)
    {
        _selBaiBalls = [NSMutableArray array];
    }
    return _selBaiBalls;
}
- (NSMutableArray *)selQianBalls
{
    if(_selQianBalls == nil)
    {
        _selQianBalls = [NSMutableArray array];
    }
    return _selQianBalls;
}
- (NSMutableArray *)selWanBalls
{
    if(_selWanBalls == nil)
    {
        _selWanBalls = [NSMutableArray array];
    }
    return _selWanBalls;
}
- (NSMutableArray *)selNumberArray
{
    if(_selNumberArray == nil)
    {
        _selNumberArray = [NSMutableArray array];
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for(NSArray *arr in self.selWanBalls)
    {
        [tempArr addObject:arr];
    }
    for(NSArray *arr in self.selQianBalls)
    {
        [tempArr addObject:arr];
    }
    for(NSArray *arr in self.selBaiBalls)
    {
        [tempArr addObject:arr];
    }
    for(NSArray *arr in self.selShiBalls)
    {
        [tempArr addObject:arr];
    }
    for(NSArray *arr in self.selGeBalls)
    {
        [tempArr addObject:arr];
    }
    return _selNumberArray = tempArr;
}
//计算注数和金额
- (void)computeAmountMoney
{
    int redComposeCount = (int)(self.selWanBalls.count * self.selQianBalls.count * self.selGeBalls.count * self.selShiBalls.count * self.selBaiBalls.count);
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
    while (muArr.count < 5) {
        int random1 = arc4random() % 10;
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
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:4 inSection:0];
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
- (void)removePlayTypeBackView
{
    [self.playTypeBackView removeFromSuperview];
}

@end
