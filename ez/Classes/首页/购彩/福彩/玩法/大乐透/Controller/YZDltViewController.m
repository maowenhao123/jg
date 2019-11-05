//
//  YZDltViewController.m
//  ez
//
//  Created by apple on 14-10-19.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZDltViewController.h"
#import "YZSsqChartViewController.h"
#import "YZBallBtn.h"
#import "YZBetStatus.h"
#import "YZCommitTool.h"

@interface YZDltViewController ()<UITableViewDelegate,UITableViewDataSource,YZSelectBallCellDelegate,YZBallBtnDelegate>
@property (nonatomic, weak) UIView *countBackView;//选择多少个号码的灰黑色背景view
@property (nonatomic, assign) int redBallRandomCount;//红球随机数
@property (nonatomic, assign) int blueBallRandomCount;//蓝球随机数
@property (nonatomic, weak) YZLotteryButton *currentcClickedRandomCountBtn;//当前点击的随机数按钮
@property (nonatomic, strong) NSMutableArray *statusArray1;//左边tableview的数据
@property (nonatomic, strong) NSMutableArray *statusArray2;//左边tableview的数据
@property (nonatomic, strong) NSMutableArray *selRedBalls;//已选红球
@property (nonatomic, strong) NSMutableArray *selBlueBalls;//已选蓝球
@property (nonatomic, strong) NSMutableArray *selRedBalls1;//已选红球
@property (nonatomic, strong) NSMutableArray *selBlueBalls1;//已选蓝球
@property (nonatomic, strong) NSMutableArray *selRedBalls2;//已选红球
@property (nonatomic, strong) NSMutableArray *selBlueBalls2;//已选蓝球
@property (nonatomic, strong) NSMutableArray *selNumberArray;//已选号码的数组
@property (nonatomic, weak) YZLotteryButton *betBtn;//投注投注按钮
@property (nonatomic, weak) UIView *guideView;

@end

@implementation YZDltViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGuideView];
    //初始化值
    _redBallRandomCount = 5;
    _blueBallRandomCount = 2;
    [self setupBtn];//复式投注的按钮
    for(int i = 0;i < self.tableViews.count;i++)
    {
        UITableView *tableView = self.tableViews[i];
        tableView.delegate = self;
        tableView.dataSource = self;
    }
}
- (void)setupBtn
{
    [self.leftBtn setTitle:@"普通投注" forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"胆拖投注" forState:UIControlStateNormal];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0)
    {
        return self.statusArray1.count;
    }else
    {
        return self.statusArray2.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0)
    {
        YZSelectBallCell *cell = [YZSelectBallCell cellWithTableView:tableView andIndexpath:indexPath];
        cell.index = indexPath.row;
        cell.delegate = self;
        cell.status = self.statusArray1[indexPath.row];
        cell.tag = indexPath.row;
        cell.owner = self.tableView1;
        return  cell;
    }else{
        YZSelectBallCell *cell = [YZSelectBallCell cellWithTableView:tableView andIndexpath:indexPath];
        cell.index = indexPath.row;
        cell.delegate = self;
        YZSelectBallCellStatus * status = self.statusArray2[indexPath.row];
        cell.status = status;
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
    YZLog(@"randomBtnClick -- btn.title = %@",btn.titleLabel.text);
    if ([btn.titleLabel.text isEqualToString:@"机选前区"])//机选红球按钮
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
    YZLog(@"randomCountBtnClick");
    self.currentcClickedRandomCountBtn = btn;//绑定是哪个机选数字按钮点击的
    UIView *countBackView = [[UIView alloc] init];//灰黑色背景
    self.countBackView = countBackView;
    countBackView.backgroundColor = YZColor(0, 0, 0, 0.4);
    countBackView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCountView)];
    [countBackView addGestureRecognizer:tap];
    [self.tabBarController.view addSubview:countBackView];
    
    UIView *countView = [[UIView alloc] init];//数字按钮框
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
        [countBtn setTitle:[NSString stringWithFormat:@"%d",(int)countBtn.tag] forState:UIControlStateNormal];
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
    }else
    {
        self.blueBallRandomCount = (int)btn.tag;
    }
    
    [self.currentcClickedRandomCountBtn setTitle:[NSString stringWithFormat:@"%d个",(int)btn.tag] forState:UIControlStateNormal];
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
    if (self.currentTableView == self.tableView1) {//普通投注
        [self clearSelBalls:self.selRedBalls];//移除选中的球对象数组
        [self clearSelBalls:self.selBlueBalls];
    }else
    {
        [self clearSelBalls:self.selRedBalls1];//移除选中的球对象数组
        [self clearSelBalls:self.selBlueBalls1];
        [self clearSelBalls:self.selRedBalls2];//移除选中的球对象数组
        [self clearSelBalls:self.selBlueBalls2];
    }
    [self computeAmountMoney];
}
#pragma mark - 机选
- (void)autoSelectedBetWithNumber:(NSInteger)number
{
    for (int i = 0; i < number; i++) {
        [YZBetTool autoChooseDlt];
    }
    [self gotoBetVc];
}
#pragma mark - 确认按钮点击
- (void)confirmBtnClick:(UIButton *)btn
{
    if (self.currentTableView == self.tableView1) {
        [YZCommitTool commitDltNormalBetWithRedBalls:self.selRedBalls blueBalls:self.selBlueBalls betCount:self.betCount];//提交普通投注的数据
    }else
    {
        [YZCommitTool commitDltBileBetWithRedBalls1:self.selRedBalls1 blueBalls1:self.selBlueBalls1 redBalls2:self.selRedBalls2 blueBalls2:self.selBlueBalls2 betCount:self.betCount];//提交胆拖投注的数据
    }
    //删除所有的
    [self deleteBtnClick];
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
#pragma mark - YZBallBtnDelegate的代理方法,点击了ball 按钮
- (void)ballDidClick:(YZBallBtn *)btn
{
    if (self.currentTableView == self.tableView1) {
        NSMutableArray *muArr = [btn.selImageName isEqualToString:@"redBall_flat"] ? self.selRedBalls : self.selBlueBalls;
        if(btn.isSelected)//之前是选中的就移除
        {
            [muArr removeObject:btn];
        }else
        {
            [muArr addObject:btn];
        }
    }else
    {
        YZSelectBallCell * cell = btn.owner;
        NSInteger tag = btn.tag;
        NSLog(@"%ld %ld",(long)cell.tag,(long)tag);
        if (cell.tag == 0) {
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selRedBalls1 removeObject:btn];
            }else
            {
                for(int i = 0;i < self.selRedBalls2.count;i++)
                {
                    YZBallBtn *ballBtn = self.selRedBalls2[i];
                    if(ballBtn.tag == btn.tag)//如果胆码和拖码一样，就取消拖码的
                    {
                        [ballBtn ballChangeToWhite];
                        [self.selRedBalls2 removeObjectAtIndex:i];
                    }
                }
                //不能超过4个胆码
                if(self.selRedBalls1.count < 4)
                {
                    [self.selRedBalls1 addObject:btn];
                }else
                {
                    [btn ballChangeToWhite];
                    [MBProgressHUD showError:@"最多只能选择4个胆码"];
                }
            }
        } else if (cell.tag == 1)
        {
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selRedBalls2 removeObject:btn];
            }else
            {
                for(int i = 0;i < self.selRedBalls1.count;i++)
                {
                    YZBallBtn *ballBtn = self.selRedBalls1[i];
                    if(ballBtn.tag == btn.tag)//如果拖码和胆码一样，就取消胆码的
                    {
                        [ballBtn ballChangeToWhite];
                        [self.selRedBalls1 removeObjectAtIndex:i];
                    }
                }
                [self.selRedBalls2 addObject:btn];
            }
        }else if (cell.tag == 2)
        {
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selBlueBalls1 removeObject:btn];
            }else
            {
                for(int i = 0;i < self.selBlueBalls2.count;i++)
                {
                    YZBallBtn *ballBtn = self.selBlueBalls2[i];
                    if(ballBtn.tag == btn.tag)//如果胆码和拖码一样，就取消拖码的
                    {
                        [ballBtn ballChangeToWhite];
                        [self.selBlueBalls2 removeObjectAtIndex:i];
                    }
                }
                //不能超过4个胆码
                if(self.selBlueBalls1.count < 1)
                {
                    [self.selBlueBalls1 addObject:btn];
                }else
                {
                    [btn ballChangeToWhite];
                    [MBProgressHUD showError:@"最多只能选择1个胆码"];
                }
            }
        }else if (cell.tag == 3)
        {
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selBlueBalls2 removeObject:btn];
            }else
            {
                for(int i = 0;i < self.selBlueBalls1.count;i++)
                {
                    YZBallBtn *ballBtn = self.selBlueBalls1[i];
                    if(ballBtn.tag == btn.tag)//如果胆码和拖码一样，就取消胆码的
                    {
                        [ballBtn ballChangeToWhite];
                        [self.selBlueBalls1 removeObjectAtIndex:i];
                    }
                }
                [self.selBlueBalls2 addObject:btn];
            }
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
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"前区 至少选5个，超过5个为复式投注"];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedBallColor range:NSMakeRange(0, 2)];
    status.title = attStr;
    status.isRed = YES;
    status.RandomCount = self.redBallRandomCount;
    status.randomCountRange = NSMakeRange(5, 22);
    status.ballsCount = 35;
    status.selBalls = self.selRedBalls;
    [array addObject:status];
    
    //左边view的第二个cell
    YZSelectBallCellStatus *status1 = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"后区 至少选2个，超过2个为复式投注"];
    [attStr1 addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(0, 2)];
    status1.title = attStr1;
    status1.isRed = NO;
    status1.RandomCount = self.blueBallRandomCount;
    status1.randomCountRange = NSMakeRange(2, 12);
    status1.ballsCount = 12;
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
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"前区胆码 至少选择1个，至多选4个，胆码加托码至少选择6个"];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedBallColor range:NSMakeRange(0, 4)];
    status.title = attStr;
    status.isRed = YES;
    status.ballsCount = 35;
    status.selBalls = self.selRedBalls1;
    [array addObject:status];
    
    //右边view的第二个cell
    YZSelectBallCellStatus *status1 = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr1 = [[NSMutableAttributedString alloc] initWithString:@"前区脱码 至少选择2个"];
    [attStr1 addAttribute:NSForegroundColorAttributeName value:YZRedBallColor range:NSMakeRange(0, 4)];
    status1.title = attStr1;
    status1.isRed = YES;
    status1.ballsCount = 35;
    status1.selBalls = self.selRedBalls2;
    [array addObject:status1];
    
    //左边view的第三个cell
    YZSelectBallCellStatus *status2 = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr2 = [[NSMutableAttributedString alloc] initWithString:@"后区胆码 至多选择1个"];
    [attStr2 addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(0, 4)];
    status2.title = attStr2;
    status2.isRed = NO;
    status2.ballsCount = 12;
    status2.selBalls = self.selBlueBalls1;
    [array addObject:status2];
    
    //左边view的第四个cell
    YZSelectBallCellStatus *status3 = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr3 = [[NSMutableAttributedString alloc] initWithString:@"后区拖码 至少选择2个"];
    [attStr3 addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(0, 4)];
    status3.title = attStr3;
    status3.isRed = NO;
    status3.ballsCount = 12;
    status3.selBalls = self.selBlueBalls2;
    [array addObject:status3];
    
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
- (NSMutableArray *)selRedBalls1
{
    if(_selRedBalls1 == nil)
    {
        _selRedBalls1 = [NSMutableArray array];
    }
    return _selRedBalls1;
}
- (NSMutableArray *)selBlueBalls1
{
    if(_selBlueBalls1 == nil)
    {
        _selBlueBalls1 = [NSMutableArray array];
    }
    return _selBlueBalls1;
}
- (NSMutableArray *)selRedBalls2
{
    if(_selRedBalls2 == nil)
    {
        _selRedBalls2 = [NSMutableArray array];
    }
    return _selRedBalls2;
}
- (NSMutableArray *)selBlueBalls2
{
    if(_selBlueBalls2 == nil)
    {
        _selBlueBalls2 = [NSMutableArray array];
    }
    return _selBlueBalls2;
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
#pragma mark - 计算注数和金额
- (void)computeAmountMoney
{
    if(self.currentTableView == self.tableView1)
    {
        int redComposeCount = [YZMathTool getCountWithN:(int)self.selRedBalls.count andM:5];
        int blueComposeCount = [YZMathTool getCountWithN:(int)self.selBlueBalls.count andM:2];
        self.betCount = redComposeCount * blueComposeCount;
    }else
    {
        NSInteger selBallCount = self.selRedBalls1.count + self.selRedBalls2.count + self.selBlueBalls1.count + self.selBlueBalls2.count;
        if (self.selRedBalls1.count >= 1 && self.selRedBalls2.count >= 2 && self.selBlueBalls2.count >= 2 && selBallCount > 7) {
            int redComposeCount = [YZMathTool getCountWithN:(int)self.selRedBalls2.count andM:5 - (int)self.selRedBalls1.count];
            int blueComposeCount = [YZMathTool getCountWithN:(int)self.selBlueBalls2.count andM:2 - (int)self.selBlueBalls1.count];
            self.betCount = redComposeCount * blueComposeCount;
        }else
        {
            self.betCount = 0;
        }
    }
}
#pragma mark - 清空号码球数组，让所有已选号码球变回原来颜色
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
#pragma mark - 重写父类的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    YZLog(@"scrollViewDidEndDragging");
    [self computeAmountMoney];
}
//走势图页面
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
    chartVC.isDlt = YES;
    chartVC.isRecentOpenLottery = isRecentOpenLottery;
    [self.navigationController pushViewController:chartVC animated:YES];
    
    //清空选中号码
    [self deleteBtnClick];
}
- (void)addGuideView
{
    BOOL haveShow = [YZUserDefaultTool getIntForKey:@"dlt_trend_guideHaveShow"];
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
    UIImageView * guideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(guideImageViewX, 20 + 44, 246, 406)];
    guideImageView.image = [UIImage imageNamed:@"trend_guide"];
    [guideView addSubview:guideImageView];
    
    [YZUserDefaultTool saveInt:1 forKey:@"dlt_trend_guideHaveShow"];
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
    
    if (self.currentTableView.tag == 0) {
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
