//
//  YZSsqViewController.m
//  ez
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZSsqViewController.h"
#import "YZSsqChartViewController.h"
#import "YZBallBtn.h"
#import "YZBetStatus.h"

@interface YZSsqViewController ()<UITableViewDelegate,UITableViewDataSource,YZSelectBallCellDelegate,YZBallBtnDelegate>

@property (nonatomic, weak) UIView *countBackView;//选择多少个号码的背部view
@property (nonatomic, assign) int redBallRandomCount;//红球随机数
@property (nonatomic, assign) int blueBallRandomCount;//蓝球随机数
@property (nonatomic, weak) YZLotteryButton *currentcClickedRandomCountBtn;//当前点击的随机数按钮
@property (nonatomic, strong) NSMutableArray *statusArray1;//左边tableview的数据
@property (nonatomic, strong) NSMutableArray *statusArray2;//右边tableview的数据
@property (nonatomic, strong) NSMutableArray *selRedBalls;//已选红球
@property (nonatomic, strong) NSMutableArray *selBlueBalls;//已选蓝球
@property (nonatomic, strong) NSMutableArray *selNumberArray;//已选号码的数组
@property (nonatomic, strong) NSMutableArray *selBileRedBalls;//已选胆码红球
@property (nonatomic, strong) NSMutableArray *selDragRedBalls;//已选拖码红球
@property (nonatomic, strong) NSMutableArray *selDragBlueBalls;//已选胆拖蓝球
@property (nonatomic, strong) NSMutableArray *selDragNumberArray;//已选胆拖号码的数组
@property (nonatomic, weak) UIView *guideView;

@end

@implementation YZSsqViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addGuideView];
    //初始化值
    _redBallRandomCount = 6;
    _blueBallRandomCount = 1;
    
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
#pragma mark - UITableViewDelegate
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
        YZSelectBallCellStatus *status = self.statusArray1[indexPath.row];
        return status.cellH;
    }else
    {
        YZSelectBallCellStatus *status = self.statusArray2[indexPath.row];
        return status.cellH;
    }
}
#pragma mark - 点击了随机按钮的代理方法,删除控制器的已选按钮
- (void)randomBtnDidClick:(YZLotteryButton *)btn
{
    if ([btn.titleLabel.text isEqualToString:@"机选红球"])//机选红球按钮
    {
        //先清空已选按钮
        [self clearSelBalls:self.selRedBalls];
    }else//机选蓝球按钮
    {
        //先清空已选按钮
        [self clearSelBalls:self.selBlueBalls];
    }
}

#pragma mark - 点击了随机数按钮的代理方法
- (void)randomCountBtnDidClick:(YZLotteryButton *)btn
{
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
    UIColor *btnColor = YZRedBallColor;
    YZSelectBallCell *cell = (YZSelectBallCell *)btn.owner;
    if(cell.tag == 1)
    {
        btnColor = YZBlueBallColor;
    }
    int btnCount = (int)(btn.range.length - btn.range.location + 1);
    for(int i = (int)btn.range.location - (int)btn.range.location;i < btnCount;i++)
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
    YZLog(@"btn.tag = %d",(int)btn.tag);
    if(self.currentcClickedRandomCountBtn.currentImage == [UIImage imageNamed:@"rightRedBtn"])//是红球的随机数按钮
    {
        self.redBallRandomCount = (int)btn.tag;
    }else
    {
        self.blueBallRandomCount = (int)btn.tag;
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
        [self clearSelBalls:self.selBlueBalls];
        [self.selNumberArray removeAllObjects];//移除选中的球号码数组
    }else
    {
        [self clearSelBalls:self.selBileRedBalls];//移除选中的球对象数组
        [self clearSelBalls:self.selDragRedBalls];
        [self clearSelBalls:self.selDragBlueBalls];
        [self.selDragNumberArray removeAllObjects];//移除选中的球号码数组
    }
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
#pragma mark - 机选
- (void)autoSelectedBetWithNumber:(NSInteger)number
{
    for (int i = 0; i < number; i++) {
        [YZBetTool autoChooseSsq];
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
    if (self.selBileRedBalls.count >= 1 && self.selDragRedBalls.count >= 2 && (self.selBileRedBalls.count + self.selDragRedBalls.count) > 6 && self.selDragBlueBalls.count >=1)
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
        //对球数组排序
        self.selDragBlueBalls = [self sortBallsArray:self.selDragBlueBalls];
        [str appendString:@"|"];//添加美元符号
        for(YZBallBtn *btn in self.selDragBlueBalls)
        {
            [str appendFormat:@"%02ld,",(long)btn.tag];//蓝球
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:[NSString stringWithFormat:@"[胆拖%d注]",self.betCount]];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"|"];//17
        NSRange range2 = [str rangeOfString:@"["];//20
        NSRange range3 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, 1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(range1.location + 1, self.selDragBlueBalls.count * 3 - 1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range2.location, range3.location - range2.location + 1)];
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
    if(self.selRedBalls.count < 6 || self.selBlueBalls.count < 1)
    {//没有一注
        [MBProgressHUD showError:@"红球至少选6个，蓝球至少选1个"];
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
        [str appendString:@"|"];
        //对球数组排序
        self.selBlueBalls = [self sortBallsArray:self.selBlueBalls];
        for(YZBallBtn *btn in self.selBlueBalls)
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
        NSRange range1 = [str rangeOfString:@"|"];//17
        NSRange range2 = [str rangeOfString:@"["];//20
        NSRange range3 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, 1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(range1.location + 1, self.selBlueBalls.count * 3 - 1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range2.location, range3.location - range2.location + 1)];
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
        NSMutableArray *muArr = [btn.selImageName isEqualToString:@"redBall_flat"] ? self.selRedBalls : self.selBlueBalls;
        if(btn.isSelected)//之前是选中的就移除
        {
            [muArr removeObject:btn];
        }else
        {
            [muArr addObject:btn];
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
                    //不能超过5个胆码
                    if(self.selBileRedBalls.count < 5)
                    {
                        [self.selBileRedBalls addObject:btn];
                    }else
                    {
                        [btn ballChangeToWhite];
                        [MBProgressHUD showError:@"红球最多只能选择5个胆码"];
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
                    if(self.selDragRedBalls.count < 16)//不能超过16个拖码
                    {
                        [self.selDragRedBalls addObject:btn];
                    }else
                    {
                        [btn ballChangeToWhite];
                        [MBProgressHUD showError:@"红球最多只能选择16个拖码"];
                    }
                }
                break;
            case 2://蓝球
                if(btn.isSelected)//之前是选中的就移除
                {
                    [self.selDragBlueBalls removeObject:btn];
                }else
                {
                    [self.selDragBlueBalls addObject:btn];
                }
                break;
            default:
                break;
        }
    }
    
    //计算注数和金额
    [self computeAmountMoney];
}
#pragma mark - 初始化
- (NSMutableArray *)statusArray1
{
    if(_statusArray1 == nil)
    {
        _statusArray1 = [NSMutableArray array];
    }
    NSMutableArray *array = [NSMutableArray array];
    //左边view的第一个cell
    YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"红球 至少选6个，超过6个为复式投注"];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedBallColor range:NSMakeRange(0, 2)];
    status.title = attStr;
    status.isRed = YES;
    status.RandomCount = self.redBallRandomCount;
    status.randomCountRange = NSMakeRange(6, 20);
    status.ballsCount = 33;
    status.selBalls = self.selRedBalls;
    [array addObject:status];
    
    //左边view的第二个cell
    YZSelectBallCellStatus *status1 = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"蓝球 至少选1个，超过1个为复式投注"];
    [attStr1 addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(0, 2)];
    status1.title = attStr1;
    status1.isRed = NO;
    status1.RandomCount = self.blueBallRandomCount;
    status1.randomCountRange = NSMakeRange(1, 16);
    status1.ballsCount = 16;
    status.selBalls = self.selBlueBalls;
    [array addObject:status1];
    
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
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"红球胆码 选择1-5个，胆码加托码“至少选择7个"];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedBallColor range:NSMakeRange(0, 4)];
    status.title = attStr;
    status.isRed = YES;
    status.ballsCount = 33;
    status.selBalls = self.selBileRedBalls;
    [array addObject:status];
    
    //右边view的第二个cell
    YZSelectBallCellStatus *status1 = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"红球拖码 选择2-16个"];
    [attStr1 addAttribute:NSForegroundColorAttributeName value:YZRedBallColor range:NSMakeRange(0, 4)];
    status1.title = attStr1;
    status1.isRed = YES;
    status1.ballsCount = 33;
    status.selBalls = self.selDragRedBalls;
    [array addObject:status1];
    
    //右边view的第三个cell
    YZSelectBallCellStatus *status2 = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:@"蓝球 至少选择1个"];
    [attStr2 addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(0, 2)];
    status2.title = attStr2;
    status2.isRed = NO;
    status.selBalls = self.selDragBlueBalls;
    status2.ballsCount = 16;
    [array addObject:status2];
    
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
- (NSMutableArray *)selBlueBalls
{
    if(_selBlueBalls == nil)
    {
        _selBlueBalls = [NSMutableArray array];
    }
    return _selBlueBalls;
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
    for(NSArray *arr in self.selBlueBalls)
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
- (NSMutableArray *)selDragBlueBalls
{
    if(_selDragBlueBalls == nil)
    {
        _selDragBlueBalls = [NSMutableArray array];
    }
    return _selDragBlueBalls;
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
    for(NSArray *arr in self.selDragBlueBalls)
    {
        [_selDragNumberArray addObject:arr];
    }
    return _selDragNumberArray;
}
#pragma mark -  计算注数和金额
- (void)computeAmountMoney
{
    if(self.currentTableView == self.tableView1)
    {
        int redComposeCount = [YZMathTool getCountWithN:(int)self.selRedBalls.count andM:6];
        int blueComposeCount = (int)self.selBlueBalls.count;
        self.betCount = redComposeCount * blueComposeCount;
    }else
    {
        if(self.selBileRedBalls.count + self.selDragRedBalls.count > 6)
        {
            int redComposeCount = [YZMathTool getCountWithN:(int)self.selDragRedBalls.count andM:6 - (int)self.selBileRedBalls.count];
            int blueComposeCount = (int)self.selDragBlueBalls.count;
            self.betCount = redComposeCount * blueComposeCount;
        }else
        {
            self.betCount = 0;
        }
    }
}
#pragma mark - 重写父类的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    YZLog(@"scrollViewDidEndDragging");
    [self computeAmountMoney];
}
- (void)trendBtnDidClick
{
    [self gotoTrendWithIsRecentOpenLottery:NO];
}
- (void)recentOpenLotteryBtnClick
{
    [self gotoTrendWithIsRecentOpenLottery:YES];
}
- (void)gotoTrendWithIsRecentOpenLottery:(BOOL)isRecentOpenLottery
{
    YZSsqChartViewController * chartVC = [[YZSsqChartViewController alloc] init];
    chartVC.gameId = self.gameId;
    if(self.currentTableView == self.tableView1)
    {
        chartVC.dantuo = NO;
    }else//胆拖
    {
        chartVC.dantuo = YES;
    }
    NSMutableArray * selectedRedBalls = [NSMutableArray array];
    for(YZBallBtn *btn in self.selRedBalls)
    {
        [selectedRedBalls addObject:[NSString stringWithFormat:@"%02ld",(long)btn.tag]];
    }
    NSMutableArray * selectedBlueBalls = [NSMutableArray array];
    for(YZBallBtn *btn in self.selBlueBalls)
    {
        [selectedBlueBalls addObject:[NSString stringWithFormat:@"%02ld",(long)btn.tag]];
    }
    NSMutableArray * selectedBalls = [NSMutableArray arrayWithObjects:selectedRedBalls, selectedBlueBalls, nil];
    chartVC.selectedBalls = selectedBalls;
    chartVC.isDlt = NO;
    chartVC.isRecentOpenLottery = isRecentOpenLottery;
    [self.navigationController pushViewController:chartVC animated:YES];
    
    //清空选中号码
    [self deleteBtnClick];
}

#pragma mark - 走势图引导
- (void)addGuideView
{
    BOOL haveShow = [YZUserDefaultTool getIntForKey:@"ssq_trend_guideHaveShow"];
    if (haveShow) {
        return;
    }
    //guide
    UIView * guideView = [[UIView alloc] initWithFrame:KEY_WINDOW.bounds];
    self.guideView = guideView;
    [KEY_WINDOW addSubview:guideView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeGuideView)];
    [guideView addGestureRecognizer:tap];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, guideView.width, guideView.height)];
    //小圆
    CGPoint center = CGPointMake(screenWidth - 32, statusBarH + 21);
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath moveToPoint:center];
    [circlePath addArcWithCenter:center radius:18 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [circlePath closePath];
    
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = YZColor(0, 0, 0, 0.6).CGColor;
    
    [guideView.layer addSublayer:fillLayer];
    
    CGFloat guideImageViewX = screenWidth - 246 - 26;
    UIImageView * guideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(guideImageViewX, statusBarH + 44, 246, 406)];
    guideImageView.image = [UIImage imageNamed:@"trend_guide"];
    [guideView addSubview:guideImageView];
    
    [YZUserDefaultTool saveInt:1 forKey:@"ssq_trend_guideHaveShow"];
}
- (void)removeGuideView
{
    [UIView animateWithDuration:animateDuration
                     animations:^{
                         self.guideView.alpha = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.guideView removeFromSuperview];
                     }];
}

#pragma mark - 摇动震动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSString * allowShake = [YZUserDefaultTool getObjectForKey:@"allowShake"];
    if ([allowShake isEqualToString:@"0"]) return;
    
    if(self.currentTableView == self.tableView1)
    {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
        //机选红球
        YZSelectBallCell *cell = (YZSelectBallCell *)[self.tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell randomBtnClick:cell.randomBtn];
        
        //机选蓝球
        YZSelectBallCell *cell1 = (YZSelectBallCell *)[self.tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        [cell1 randomBtnClick:cell1.randomBtn];
    }
}
@end
