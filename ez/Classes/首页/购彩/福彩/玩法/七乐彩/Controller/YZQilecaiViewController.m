//
//  YZQilecaiViewController.m
//  ez
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZQilecaiViewController.h"
#import "YZBallBtn.h"
#import "YZBetStatus.h"

@interface YZQilecaiViewController ()<UITableViewDelegate,UITableViewDataSource,YZSelectBallCellDelegate,YZBallBtnDelegate>

@property (nonatomic, weak) UIView *countBackView;//选择多少个号码的背部view
@property (nonatomic, strong) NSArray *tableView1RedBallsArray;//第一个tableView的红球数组
@property (nonatomic, weak) YZLotteryButton *currentcClickedRandomCountBtn;//当前点击的随机数按钮
@property (nonatomic, strong) NSMutableArray *statusArray1;//左边tableview的数据
@property (nonatomic, strong) NSMutableArray *statusArray2;//右边tableview的数据

@property (nonatomic, strong) NSMutableArray *selRedBalls;//已选红球
@property (nonatomic, strong) NSMutableArray *selNumberArray;//已选号码的数组
@property (nonatomic, assign) int redBallRandomCount;//红球随机数

@property (nonatomic, strong) NSMutableArray *selBileRedBalls;//已选胆码红球
@property (nonatomic, strong) NSMutableArray *selDragRedBalls;//已选拖码红球
@property (nonatomic, strong) NSMutableArray *selDragNumberArray;//已选胆拖号码的数组
@end

@implementation YZQilecaiViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化值
    _redBallRandomCount = 7;
    
    for(int i = 0;i < self.tableViews.count;i++)
    {
        UITableView *tableView = self.tableViews[i];
        tableView.delegate = self;
        tableView.dataSource = self;
    }
    
    //设置左右按钮的文字
    [self.leftBtn setTitle:@"普通投注" forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"胆拖投注" forState:UIControlStateNormal];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 0)
    {
        return self.statusArray1.count;
    }else
    {
        return self.statusArray2.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSelectBallCell *cell = [YZSelectBallCell cellWithTableView:tableView andIndexpath:indexPath];
    cell.index = indexPath.row;
    cell.delegate = self;
    if(tableView.tag == 0)
    {
        cell.status = self.statusArray1[indexPath.row];
        cell.tag = indexPath.row;
        cell.owner = self.tableView1;
        return  cell;
    }else
    {
        cell.status = self.statusArray2[indexPath.row];
        cell.tag = indexPath.row;
        cell.owner = self.tableView2;
        return  cell;
    }
}
//返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 0)
    {
        YZSelectBallCellStatus * status = self.statusArray1[indexPath.row];
        return status.cellH;
    }else
    {
        YZSelectBallCellStatus * status = self.statusArray2[indexPath.row];
        return status.cellH;
    }
}
#pragma mark - 点击了随机按钮的代理方法,删除控制器的已选按钮
- (void)randomBtnDidClick:(YZLotteryButton *)btn
{
    YZLog(@"randomBtnClick -- btn.title = %@",btn.titleLabel.text);
    //先清空已选按钮
    [self clearSelBalls:self.selRedBalls];
}

#pragma mark - 点击了随机数按钮的代理方法
- (void)randomCountBtnDidClick:(YZLotteryButton *)btn
{
    YZLog(@"randomCountBtnClick");
    self.currentcClickedRandomCountBtn = btn;//绑定是哪个机选数字按钮点击的
    UIView *countBackView = [[UIView alloc] init];
    self.countBackView = countBackView;
    countBackView.backgroundColor = YZColor(0, 0, 0, 0.4);
    countBackView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCountView)];
    [countBackView addGestureRecognizer:tap];
    [self.tabBarController.view addSubview:countBackView];
    
    UIView *countView = [[UIView alloc] init];
    countView.backgroundColor = [UIColor whiteColor];
    countView.layer.cornerRadius = 5;
    countView.clipsToBounds = YES;
    CGFloat countViewW = 260;
    countView.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.5);
    [countBackView addSubview:countView];
    
    //添加数字按钮
    CGFloat countBtnW = 30;
    CGFloat countBtnH = 30;
    int maxColums = 7;
    CGFloat margin = (countViewW - maxColums * countBtnW) / (maxColums + 1);
    UIColor *btnColor = YZRedTextColor;
    if( (btn.currentImage == [UIImage imageNamed:@"rightBlueBtn"]) || (btn.currentImage == [UIImage imageNamed:@"rightBlueBtn_pressed"]))//是红球的随机数按钮
    {
        btnColor = YZBlueBallColor;
    }
    int btnCount = (int)(btn.range.length - btn.range.location + 1);
    for(int i = (int)(btn.range.location - btn.range.location);i < btnCount;i++)
    {
        UIButton *countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        countBtn.backgroundColor = btnColor;
        countBtn.tag = btn.range.location + i;
        [countBtn setTitle:[NSString stringWithFormat:@"%ld",(long)countBtn.tag] forState:UIControlStateNormal];
        CGFloat countBtnX = margin + (i % maxColums) * (countBtnW + margin);
        CGFloat countBtnY = 10 + margin + (i / maxColums) * (countBtnH + margin);
        countBtn.frame = CGRectMake(countBtnX, countBtnY, countBtnW, countBtnH);
        [countView addSubview:countBtn];
        [countBtn addTarget:self action:@selector(countBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    int columsCount = (btnCount / maxColums) + 1;
    CGFloat countViewH = 20 + margin + columsCount * (countBtnH + margin);
    countView.bounds = CGRectMake(0, 0, countViewW, countViewH);
}
- (void)countBtnClick:(UIButton *)btn
{
    if(self.currentcClickedRandomCountBtn.currentImage == [UIImage imageNamed:@"rightRedBtn"])//是红球的随机数按钮
    {
        self.redBallRandomCount = (int)btn.tag;
    }
    
    [self.currentcClickedRandomCountBtn setTitle:[NSString stringWithFormat:@"%ld个",(long)btn.tag] forState:UIControlStateNormal];
    [self removeCountView];
    
    //自动机选,取出随机数按钮的父控件的另一按钮，就是随机按钮
    YZLotteryButton *randomBtn = [self.currentcClickedRandomCountBtn.superview.subviews firstObject];
    
    YZSelectBallCell *cell = self.currentcClickedRandomCountBtn.owner;
    //刷新自动选选球数量的数据
    cell.status.RandomCount = (int)btn.tag;
    [cell randomBtnClick:randomBtn];
}
- (void)removeCountView
{
    [self.countBackView removeFromSuperview];
}
#pragma  mark - 删除按钮点击
- (void)deleteBtnClick
{
    YZLog(@"deleteBtnClick");
    if(self.currentTableView == self.tableView1)
    {
        [self clearSelBalls:self.selRedBalls];//移除选中的球对象数组
        [self.selNumberArray removeAllObjects];//移除选中的球号码数组
    }else
    {
        [self clearSelBalls:self.selBileRedBalls];//移除选中的球对象数组
        [self clearSelBalls:self.selDragRedBalls];
        [self.selDragNumberArray removeAllObjects];//移除选中的球号码数组
    }
    
    [self computeAmountMoney];
}
#pragma mark - 机选
- (void)autoSelectedBetWithNumber:(NSInteger)number
{
    for (int i = 0; i < number; i++) {
        [YZBetTool autoChooseQlc];
    }
    [self gotoBetVc];
}
#pragma mark - 确认按钮点击
- (void)confirmBtnClick:(UIButton *)btn
{
    YZLog(@"confirmBtnClick");
    if(self.currentTableView == self.tableView1)
    {
        [self commitNormalBet];//提交普通投注的数据
    }else
    {
        [self commitBileBet];//提交胆拖投注的数据
    }
    [self gotoBetVc];
}
- (void)gotoBetVc
{
    //页面跳转
    YZBetViewController *bet = [[YZBetViewController alloc] init];//投注控制器
    bet.gameId = self.gameId;
    [self.navigationController pushViewController: bet animated:YES];
}
- (void)currentTableViewDidChange
{
    if(self.currentTableView == self.tableView1)
    {
        self.autoSelectedLabel.hidden = NO;
    }else
    {
        self.autoSelectedLabel.hidden = YES;
    }
    [super setDeleteAutoSelectedBtnTitle];
    [self computeAmountMoney];
}
#pragma mark - 提交胆拖投注的数据
- (void)commitBileBet//提交胆拖投注的数据
{
    if (self.selBileRedBalls.count >= 1 && self.selDragRedBalls.count >= 2 && (self.selBileRedBalls.count + self.selDragRedBalls.count) >= 8)
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对球数组排序
        self.selBileRedBalls = [self sortBallsArray:self.selBileRedBalls];
        for(YZBallBtn *btn in self.selBileRedBalls)
        {
            [str appendFormat:@"%02ld,",(long)btn.tag];//添加胆码
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"$"];//添加美元符号
        //对球数组排序
        self.selDragRedBalls = [self sortBallsArray:self.selDragRedBalls];
        for(YZBallBtn *btn in self.selDragRedBalls)
        {
            [str appendFormat:@"%02ld,",(long)btn.tag];//拖码
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:[NSString stringWithFormat:@"[胆拖%d注]",self.betCount]];
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
        //删除所有已选的按钮
        [self deleteBtnClick];
    }else
    {
        [MBProgressHUD showError:@"请按规则选择号码"];
    }
}
#pragma mark - 提交普通投注的数据
- (void)commitNormalBet//提交普通投注的数据
{
    if(self.selRedBalls.count < 7)
    {//没有一注
        [MBProgressHUD showError:@"请至少选择7个号码"];
    }else if(self.betCount * 2 > 20000)
    {
        [MBProgressHUD showError:@"单注金额不能超过2万元"];
    }else//其他正确情况就传数据
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对球数组排序
        self.selRedBalls = [self sortBallsArray:self.selRedBalls];
        for(YZBallBtn *btn in self.selRedBalls)
        {
            [str appendFormat:@"%02ld,",(long)btn.tag];
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

#pragma mark - YZBallBtnDelegate的代理方法,点击了ball 按钮
- (void)ballDidClick:(YZBallBtn *)btn
{
    if(self.currentTableView == self.tableView1)//是左边的tableView
    {
        if(btn.isSelected)//之前是选中的就移除
        {
            [self.selRedBalls removeObject:btn];
        }else
        {
            //如果超过15个就不添加了
            if(self.selRedBalls.count >= 15)
            {
                [btn ballChangeToWhite];
                [MBProgressHUD showError:@"最多选择15个号码"];
            }else
            {
                [self.selRedBalls addObject:btn];
            }
        }
    }else//右边的tableView
    {
        YZSelectBallCell *cell = btn.owner;
        switch (cell.tag) {
            case 0://红球胆码
                if(btn.isSelected)//之前是选中的就移除
                {
                    [self.selBileRedBalls removeObject:btn];
                }else
                {
                    for(int i = 0;i < self.selDragRedBalls.count;i++)
                    {
                        YZBallBtn *ballBtn = self.selDragRedBalls[i];
                        if(ballBtn.tag == btn.tag)//如果胆码和拖码一样，就取消拖码的
                        {
                            [ballBtn ballChangeToWhite];
                            [self.selDragRedBalls removeObjectAtIndex:i];
                        }
                    }
                    //不能超过6个胆码
                    if(self.selBileRedBalls.count < 6)
                    {
                        [self.selBileRedBalls addObject:btn];
                    }else
                    {
                        [btn ballChangeToWhite];
                        [MBProgressHUD showError:@"最多只能选择6个胆码"];
                    }
                }
                break;
            case 1://红球拖码
                if(btn.isSelected)//之前是选中的就移除
                {
                    [self.selDragRedBalls removeObject:btn];
                }else
                {
                    for(int i = 0;i < self.selBileRedBalls.count;i++)
                    {
                        YZBallBtn *ballBtn = self.selBileRedBalls[i];
                        if(ballBtn.tag == btn.tag)//如果拖码和胆码一样，就取消胆码的
                        {
                            [ballBtn ballChangeToWhite];
                            [self.selBileRedBalls removeObjectAtIndex:i];
                        }
                    }
                    if(self.selDragRedBalls.count < 14)//不能超过14个拖码
                    {
                        [self.selDragRedBalls addObject:btn];
                    }else
                    {
                        [btn ballChangeToWhite];
                        [MBProgressHUD showError:@"最多只能选择14个拖码"];
                    }
                }
                break;
                
            default:
                break;
        }
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
    //左边view的第一个cell
    YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"至少选7个号码"];
    status.title = attStr;
    status.isRed = YES;
    status.RandomCount = self.redBallRandomCount;
    status.randomCountRange = NSMakeRange(7, 15);
    status.ballsCount = 30;
    status.selBalls = self.selRedBalls;
    [array addObject:status];
    
    _statusArray1 = array;
    return _statusArray1;
}
- (NSMutableArray *)statusArray2
{
    if(_statusArray2 == nil)
    {
        _statusArray2 = [NSMutableArray array];
    }
    NSMutableArray *array = [NSMutableArray array];
    
    //右边view的第一个cell
    YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"胆码区 至少选择1个，至多选择6个"];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedBallColor range:NSMakeRange(0, 3)];
    status.title = attStr;
    status.isRed = YES;
    status.ballsCount = 30;
    status.selBalls = self.selBileRedBalls;
    [array addObject:status];
    
    //右边view的第二个cell
    YZSelectBallCellStatus *status1 = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"拖码区 至少选择2个"];
    [attStr1 addAttribute:NSForegroundColorAttributeName value:YZRedBallColor range:NSMakeRange(0, 3)];
    status1.title = attStr1;
    status1.isRed = YES;
    status1.ballsCount = 30;
    status.selBalls = self.selDragRedBalls;
    [array addObject:status1];
    
    _statusArray2 = array;
    
    return _statusArray2;
}
- (NSMutableArray *)selRedBalls
{
    if(_selRedBalls == nil)
    {
        _selRedBalls = [NSMutableArray array];
    }
    return _selRedBalls;
}

- (NSMutableArray *)selNumberArray
{
    if(_selNumberArray == nil)
    {
        _selNumberArray = [NSMutableArray array];
    }
    
    for(NSArray *arr in self.selRedBalls)
    {
        [_selNumberArray addObject:arr];
    }
    
    return _selNumberArray;
}
//胆码的
- (NSMutableArray *)selBileRedBalls
{
    if(_selBileRedBalls == nil)
    {
        _selBileRedBalls = [NSMutableArray array];
    }
    return _selBileRedBalls;
}
- (NSMutableArray *)selDragRedBalls
{
    if(_selDragRedBalls == nil)
    {
        _selDragRedBalls = [NSMutableArray array];
    }
    return _selDragRedBalls;
}

- (NSMutableArray *)selDragNumberArray//已选胆拖号码数组
{
    if(_selDragNumberArray == nil)
    {
        _selDragNumberArray = [NSMutableArray array];
    }
    for(NSArray *arr in self.selBileRedBalls)
    {
        [_selDragNumberArray addObject:arr];
    }
    for(NSArray *arr in self.selDragRedBalls)
    {
        [_selDragNumberArray addObject:arr];
    }
    
    return _selDragNumberArray;
}
//计算注数和金额
- (void)computeAmountMoney
{
    if(self.currentTableView == self.tableView1)
    {
        int redComposeCount = [YZMathTool getCountWithN:(int)self.selRedBalls.count andM:7];
        self.betCount = redComposeCount;
    }else
    {
        if(self.selBileRedBalls.count + self.selDragRedBalls.count > 7)
        {
            int redComposeCount = [YZMathTool getCountWithN:(int)self.selDragRedBalls.count andM:7 - (int)self.selBileRedBalls.count];
            self.betCount = redComposeCount;
        }else
        {
            self.betCount = 0;
        }
    }
    
}
//重写父类的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    YZLog(@"scrollViewDidEndDragging");
    [self computeAmountMoney];
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

//摇动震动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSString * allowShake = [YZUserDefaultTool getObjectForKey:@"allowShake"];
    if ([allowShake isEqualToString:@"0"]) return;
    
    if(self.currentTableView == self.tableView1)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
        YZSelectBallCell *cell = (YZSelectBallCell *)[self.tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell randomBtnClick:cell.randomBtn];
    }
}
@end
