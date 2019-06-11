//
//  YZS1x5ViewController.m
//  ez
//
//  Created by apple on 14-11-5.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define playTypeBtnCount 21
#import "YZS1x5ViewController.h"
#import "YZTitleButton.h"
#import "YZRecentLotteryCell.h"
#import "YZCommitTool.h"

@interface YZS1x5ViewController ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,YZSelectBallCellDelegate,YZBallBtnDelegate>
{
    BOOL _openTitleMenu;//是否打开菜单
    NSString *_currentPlayTypeCode;//当前玩法
    NSArray *_playTypeBtnTitles;//玩法按钮的title数组
    NSArray *_playTypeCodes;//玩法按钮的title数组
    NSArray *_minSelCountArray;//至少选几个球的数组
    NSArray *_maxSelCountArray;//至多选几个球的数组
    int _currentMinSelCount;//当前至少选几个球
    NSArray *_btnTitles;//按钮标题
    BOOL _panEnable;//pan手势是否激活
    int _selectedPlayTypeBtnTag;//选中的玩法的tag
    CGFloat lastTranslationY;
}
@property (nonatomic, weak) YZTitleButton *titleBtn;//title按钮
@property (nonatomic, weak) UIView *playTypeBackView;//玩法背景view
@property (nonatomic, weak) UIImageView * historyImageView;
@property (nonatomic, strong) UIButton *selectedPlayTypeBtn;//已选中的玩法按钮
@property (nonatomic, strong) NSMutableArray *allSelBallsArray;//所有选中的球对象数组
@property (nonatomic, strong) NSMutableArray *currentStatusArray;//当前tableview的数据
@property (nonatomic, strong) NSMutableArray *allStatusArray;//所有的数据
@property (nonatomic, strong) NSMutableArray *historyTableViews;//含有万千百的tableview数组
@property (nonatomic, weak) UIView *alphaChangeView;//透明度变化的view
@property (nonatomic, weak) UITableView *historyTableView;//不含百千万的
@property (nonatomic, weak) UIView *currentHistoryView;//当前的历史开奖view
@property (nonatomic, weak) UIView *historyBackView;//有万千百位的历史开奖的背景view
@property (nonatomic, weak) UIView *historyTopBackView;//
@property (nonatomic, weak) YZLotteryButton *historySelBtn;
@property (nonatomic, weak) UIScrollView *historyScrollView;//有万千百位的历史开奖的scrollView
@property (nonatomic, strong) NSMutableArray * titleBtns;//标题按钮的数组;
@property (nonatomic, weak) UIView *playTypeView;//玩法视图

@end

@implementation YZS1x5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _playTypeBtnTitles = [[NSArray alloc] initWithObjects:@"任选一", @"任选二", @"任选三", @"任选四", @"任选五", @"任选六", @"任选七", @"任选八", @"前二直选", @"前二组选", @"前三直选", @"前三组选", @"任选二", @"任选三", @"任选四", @"任选五", @"任选六", @"任选七", @"前二组选", @"前三组选", @"",nil];
    _playTypeCodes = [[NSArray alloc] initWithObjects:@"21",@"22", @"23", @"24", @"25", @"26", @"27", @"28", @"30", @"29", @"32", @"31", @"22", @"23", @"24", @"25", @"26", @"27", @"29", @"31", @"",nil];
    _minSelCountArray = [[NSArray alloc] initWithObjects:@"1",@"2", @"3", @"4", @"5", @"6", @"7", @"8", @"1", @"2", @"1", @"3", @"1",@"2", @"3", @"4", @"5", @"6", @"1", @"2", @"",nil];
    _maxSelCountArray = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"1", @"2",nil];

    _btnTitles = [[NSArray alloc] initWithObjects:@"万位",@"千位",@"百位", nil];
    [self setupSonChilds];
    [self setupPlayTypeView];
    [self loadHistoryData];//获取历史开奖数据
}
- (void)setupSonChilds
{
    //移除父控制器不必要的控件
    [self.backView removeFromSuperview];//移除俩个按钮
    [self.scrollView removeFromSuperview];//移除scrollview

    //titleBtn
    YZTitleButton *titleBtn = [[YZTitleButton alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    self.titleBtn = titleBtn;
    self.navigationItem.titleView = titleBtn;
    //默认玩法为任选五
    BOOL havesSelectedPlayType = [YZUserDefaultTool getIntForKey:@"havesSelectedPlayType"];
    if (!havesSelectedPlayType) {
        [YZUserDefaultTool saveInt:4 forKey:@"selectedPlayTypeBtnTag"];
        [YZUserDefaultTool saveInt:1 forKey:@"havesSelectedPlayType"];
    }
    //设置数据源和标题
    _selectedPlayTypeBtnTag = [YZUserDefaultTool getIntForKey:@"selectedPlayTypeBtnTag"];
    
    self.currentStatusArray = self.allStatusArray[_selectedPlayTypeBtnTag];//记录的数据源
    _currentPlayTypeCode = _playTypeCodes[_selectedPlayTypeBtnTag];//记录的当前玩法
    _currentMinSelCount = [_minSelCountArray[_selectedPlayTypeBtnTag] intValue];//记录的当前至少选几个球
    //设置记录的标题
    NSString *title = _playTypeBtnTitles[_selectedPlayTypeBtnTag];
    if(_selectedPlayTypeBtnTag >= 12)
    {
        title = [NSString stringWithFormat:@"%@胆拖",title];
    }
    [titleBtn setTitle:title forState:UIControlStateNormal];
    
#if JG
    [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
#elif ZC
    [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
#elif CS
    [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
#endif
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //可以上下滑动的tableview
    UITableView *tableView = [[UITableView alloc] init];
    tableView.clipsToBounds = NO;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsZero;
    tableView.scrollEnabled = NO;
    tableView.delaysContentTouches = NO;
    self.tableView1 = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    CGFloat tableViewY = CGRectGetMaxY(self.endTimeLabel.frame);
    CGFloat tableViewH = self.bottomView.y - CGRectGetMaxY(self.endTimeLabel.frame);
    tableView.frame = CGRectMake(0, tableViewY, screenWidth, tableViewH);
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view insertSubview:tableView belowSubview:self.bottomView];
    //添加拖动手势
    [self addPanGestureToView:tableView];

    //透明度变化的view
    UIView *alphaChangeView = [[UIView alloc] init];
    self.alphaChangeView = alphaChangeView;
    alphaChangeView.userInteractionEnabled = NO;
    alphaChangeView.frame = tableView.frame;
    [self.view insertSubview:alphaChangeView belowSubview:tableView];
    
    //看近期开奖的tableview
    UITableView *historyTableView = [[UITableView alloc] init];
    historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    historyTableView.scrollEnabled = NO;
    historyTableView.delegate = self;
    historyTableView.dataSource = self;
    historyTableView.tag = KHistoryTag11;
    self.historyTableView = historyTableView;
    historyTableView.frame = tableView.frame;
    [historyTableView setEstimatedSectionHeaderHeightAndFooterHeight];
    historyTableView.height = 11 * btnWH;//22是cell的高度
    [self.view insertSubview:historyTableView belowSubview:alphaChangeView];
    //添加手势
    [self addPanGestureToView:historyTableView];
    
    UIView * historyBackView = [[UIView alloc]initWithFrame:historyTableView.frame];
    historyBackView.height = 12 * btnWH;//22是cell的高度
    self.historyBackView = historyBackView;
    [self.view insertSubview:historyBackView belowSubview:self.historyTableView];
    
    //3个按钮
    UIView * historyTopBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, btnWH)];
    self.historyTopBackView = historyTopBackView;
    [historyBackView addSubview:historyTopBackView];
    
    int btnCount = 3;
    CGFloat topBtnH = btnWH;
    for(int i = 0;i < btnCount;i++)
    {
        YZLotteryButton *topBtn = [YZLotteryButton buttonWithType:UIButtonTypeCustom];
        topBtn.backgroundColor = [UIColor whiteColor];
        topBtn.tag = i;
        [topBtn setTitle:_btnTitles[i] forState:UIControlStateNormal];
        if(i==0)
        {
            topBtn.selected = YES;
            self.historySelBtn = topBtn;
            topBtn.userInteractionEnabled = NO;
        }
        CGFloat topBtnW = screenWidth / btnCount;
        topBtn.frame = CGRectMake(topBtnW * i, 0, topBtnW, topBtnH);
        topBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        topBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [topBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [topBtn setTitleColor:YZColor(233, 116, 61, 1.0) forState:UIControlStateSelected];
        [topBtn setImage:[UIImage imageNamed:@"button_underline"] forState:UIControlStateSelected];
        [historyTopBackView addSubview:topBtn];
        [topBtn addTarget:self action:@selector(historyTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //有万千百的历史开奖
    CGFloat historyScrollViewH = 11 * btnWH;
    UIScrollView *historyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, btnWH , screenWidth, historyScrollViewH)];
    self.historyScrollView = historyScrollView;
    //设置属性
    historyScrollView.backgroundColor = [UIColor whiteColor];
    historyScrollView.delaysContentTouches = NO;
    historyScrollView.delegate = self;
    historyScrollView.contentSize = CGSizeMake(screenWidth * btnCount, historyScrollViewH);
    historyScrollView.showsHorizontalScrollIndicator = NO;
    historyScrollView.bounces = NO;
    historyScrollView.pagingEnabled = YES;
    [historyBackView addSubview:historyScrollView];
    //添加手势
    [self addPanGestureToView:historyBackView];
    
    //添加3个tableview
    for(int i = 0;i < btnCount;i++)
    {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.frame = CGRectMake(screenWidth * i, 0, screenWidth, historyScrollViewH);
        tableView.scrollEnabled = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        if(i == 0)
        {
            tableView.tag = KHistory2Tag21;
        }else if (i == 1)
        {
            tableView.tag = KHistory2Tag22;
        }else
        {
            tableView.tag = KHistory2Tag23;
        }
        [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
        [self.historyTableViews addObject:tableView];
        [historyScrollView addSubview:tableView];
    }
    //设置要显示历史开奖的view
    [self switchCurrentHistoryView];
    
    //打开最近中奖号的按钮
    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    historyBtn.frame = self.endTimeLabel.frame;
    historyBtn.backgroundColor = [UIColor clearColor];
    [historyBtn addTarget:self action:@selector(historyBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:historyBtn];
    
    UIImageView * historyImageView = [[UIImageView alloc]init];
    self.historyImageView = historyImageView;
    historyImageView.image = [UIImage imageNamed:@"11x5_history_btn"];
    CGFloat historyImageViewW = 12;
    CGFloat historyImageViewH = 7;
    historyImageView.frame = CGRectMake(screenWidth - historyImageViewW - 12, (endTimeLabelH - historyImageViewH) / 2, historyImageViewW, historyImageViewH);
    [historyBtn addSubview:historyImageView];
    
    //设置摇一摇机选是否显示
    if(_selectedPlayTypeBtnTag < 12 )
    {
        self.autoSelectedLabel.hidden = NO;
    }else
    {
        self.autoSelectedLabel.hidden = YES;
    }
    
    [super setDeleteAutoSelectedBtnTitle];
}
- (void)historyBtnDidClick
{
    if(self.tableView1.y == CGRectGetMaxY(self.endTimeLabel.frame))
    {
        [self openTableViewWithAnimation];
    }else
    {
        [self closeTableViewWithAnimation];
    }
}
- (void)historyTopBtnClick:(YZLotteryButton *)btn
{
    [self.historyScrollView setContentOffset:CGPointMake(btn.tag * screenWidth, 0) animated:YES];
}
- (void)addPanGestureToView:(UIView *)view
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewPan:)];
    pan.delegate = self;
    [view addGestureRecognizer:pan];
}
#pragma mark - 请求历史开奖数据
- (void)loadHistoryData
{
    NSDictionary *dict = @{
                           @"cmd":@(8018),
                           @"gameId":self.gameId,
                           @"pageIndex":@(0),
                           @"pageSize":@(10)
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            NSArray * termList = json[@"termList"];
            NSArray * recentStatus = [NSArray array];
            if (termList.count >= 10) {
                recentStatus = [YZRecentLotteryStatus objectArrayWithKeyValuesArray:[termList subarrayWithRange:NSMakeRange(0, 10)]];
            }else{
                recentStatus = [YZRecentLotteryStatus objectArrayWithKeyValuesArray:termList];
            }
            //倒序
            self.recentStatus =  [[recentStatus reverseObjectEnumerator] allObjects];
            [self setHistoryTableView];
        }
    } failure:^(NSError *error) {
        YZLog(@"开奖error = %@",error);
    }];
}
//根据获取到的历史开奖的数据的个数来决定历史开奖view的高度 父类
- (void)setHistoryTableView
{
    [self.historyTableView reloadData];
    self.historyTableView.height = (self.recentStatus.count + 1)* btnWH;
    self.historyBackView.height = (self.recentStatus.count + 2) * btnWH;
    for (UITableView * tableView in self.historyTableViews) {
        [tableView reloadData];
        tableView.height = (self.recentStatus.count + 1)* btnWH;
    }
}
#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(![scrollView isKindOfClass:[UITableView class]])
    {
        if (scrollView == self.historyScrollView) {
            // 1.取出水平方向上滚动的距离
            CGFloat offsetX = scrollView.contentOffset.x;
            
            // 2.求出页码
            double pageDouble = offsetX / (screenWidth);
            int historyPageInt = (int)(pageDouble + 0.5);
            [self changeHistoryBtnState:self.historyTopBackView.subviews[historyPageInt]];
        }
    }
}
- (void)changeHistoryBtnState:(YZLotteryButton *)btn
{
    self.historySelBtn.selected = NO;
    self.historySelBtn.userInteractionEnabled = YES;
    btn.userInteractionEnabled = NO;
    btn.selected = YES;
    self.historySelBtn = btn;
}
#pragma mark - 手势滑动tableview
- (void)tableViewPan:(UIPanGestureRecognizer *)pan
{
    if(!_panEnable) return;
    UITableView *tableView = self.tableView1;
    CGFloat endTimeBgMaxY = CGRectGetMaxY(self.endTimeLabel.frame);
    CGPoint translation = [pan translationInView:tableView];
    CGFloat endY = CGRectGetMaxY(self.currentHistoryView.frame);
    if(pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged)
    {
        if(((tableView.y + translation.y) > endTimeBgMaxY)|| (translation.y < 0 && tableView.y > endTimeBgMaxY) || (translation.y > 0 && tableView.y < endY))//向上且y值大于endTimeBg的最大Y值，或者，向下且y值小于下面固定的某一值
        {
            [tableView setCenter:CGPointMake(tableView.center.x, tableView.center.y + translation.y)];
            [pan setTranslation:CGPointZero inView:tableView];
        }
        if(translation.y < 0 && tableView.y < endTimeBgMaxY)//向上且y值小于endTimeBg的最大Y值
        {
            tableView.y = endTimeBgMaxY;
        }else if(translation.y > 0 && tableView.y > endY)//向下且y值大于下面固定的某一值
        {
            tableView.y = endY;
        }
        lastTranslationY = translation.y;
    }
    
    if(pan.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:animateDuration
                         animations:^{
             if(lastTranslationY > 2)//有向下滑的趋势
             {
                 tableView.y = endY;
             }else if (lastTranslationY < -2)//有向上滑的趋势
             {
                 tableView.y = endTimeBgMaxY;
             }else//无趋势
             {
                 if(tableView.y < endTimeBgMaxY + self.currentHistoryView .height / 2)//tableview在endTimeBg上面了就归位
                 {
                     tableView.y = endTimeBgMaxY;
                 }else if(tableView.y >= endTimeBgMaxY + self.currentHistoryView .height / 2)//y值中间的一半以外，下去
                 {
                     tableView.y = endY;
                 }else if(tableView.y > self.bottomView.y)//y值大于下面一栏的y值就归位下去
                 {
                     tableView.y = endY;
                 }
             }
         }];
    }else if (pan.state == UIGestureRecognizerStateCancelled)
    {
        [UIView animateWithDuration:animateDuration animations:^{
            tableView.y = endTimeBgMaxY;
        }];
    }
    //设置透明度
    CGFloat layerScale = (tableView.y - endTimeBgMaxY) / (endY - endTimeBgMaxY);
    self.alphaChangeView.layer.backgroundColor = YZColor(0, 0, 0, 0.7*(1 - layerScale)).CGColor;
}
#pragma mark - 近期开奖按钮点击，重写父类方法
- (void)recentOpenLotteryBtnClick
{

    if(self.tableView1.y == CGRectGetMaxY(self.endTimeLabel.frame))
    {
        [self openTableViewWithAnimation];
    }else
    {
        [self closeTableViewWithAnimation];
    }
}
#pragma mark - 打开tableView
- (void)openTableViewWithAnimation
{
    if(!_panEnable) return;
    //动画
    if(self.tableView1.y == CGRectGetMaxY(self.endTimeLabel.frame))
    {
        [UIView animateWithDuration:animateDuration
                         animations:^{
                             self.alphaChangeView.layer.backgroundColor = YZColor(0, 0, 0, 0).CGColor;
                             self.tableView1.y = CGRectGetMaxY(self.currentHistoryView.frame);
                         }];
    }
}
#pragma mark - 关闭tableView
- (void)closeTableViewWithAnimation
{
    if(self.tableView1.y != CGRectGetMaxY(self.endTimeLabel.frame))
    {
        [UIView animateWithDuration:animateDuration
                         animations:^{
                             self.alphaChangeView.layer.backgroundColor = YZColor(0, 0, 0, 0.7).CGColor;
                             self.tableView1.y = CGRectGetMaxY(self.endTimeLabel.frame);
                         }];
    }
}
#pragma mark - tableview的代理数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == KHistoryTag11 || tableView.tag == KHistory2Tag21 || tableView.tag == KHistory2Tag22 || tableView.tag == KHistory2Tag23)
    {
        int count = (int)self.recentStatus.count;
        if(count > 0) _panEnable = YES;
        return count;
    }else
    {
        return self.currentStatusArray.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == KHistoryTag11 || tableView.tag == KHistory2Tag21 || tableView.tag == KHistory2Tag22 || tableView.tag == KHistory2Tag23)
    {
        YZRecentLotteryCell *cell = [YZRecentLotteryCell cellWithTableView:tableView];
        if(indexPath.row % 2 != 0)
        {
            cell.backgroundColor = UIColorFromRGB(0xFFE7E7E7);
        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        NSArray *statusArr = nil;
        if(tableView.tag == KHistoryTag11)
        {
            statusArr = [self recentStatusWithCellTag:KhistoryCellTagZero];
        }else if (tableView.tag == KHistory2Tag21)
        {
            statusArr = [self recentStatusWithCellTag:KhistoryCellTagWan];
        }else if (tableView.tag == KHistory2Tag22)
        {
            statusArr = [self recentStatusWithCellTag:KhistoryCellTagQian];
        }else if (tableView.tag == KHistory2Tag23)
        {
            statusArr = [self recentStatusWithCellTag:KhistoryCellTagBai];
        }
        cell.status = statusArr[indexPath.row];
        return cell;
    }else
    {
        YZSelectBallCell *cell = [YZSelectBallCell cellWithTableView:tableView andIndexpath:indexPath];
        cell.index = indexPath.row;
        cell.delegate = self;
        cell.tag = indexPath.row;
        cell.status = self.currentStatusArray[indexPath.row];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == KHistoryTag11 ||tableView.tag == KHistory2Tag21 ||tableView.tag == KHistory2Tag22 ||tableView.tag == KHistory2Tag23)
    {
        return btnWH;
    }else
    {
        YZSelectBallCellStatus * status = self.currentStatusArray[indexPath.row];
        return status.cellH;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == KHistoryTag11 ||tableView.tag == KHistory2Tag21 ||tableView.tag == KHistory2Tag22 ||tableView.tag == KHistory2Tag23)
    {
        return btnWH;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView.tag == KHistoryTag11 ||tableView.tag == KHistory2Tag21 ||tableView.tag == KHistory2Tag22 ||tableView.tag == KHistory2Tag23)
    {
        UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, btnWH)];
        headerView.backgroundColor = UIColorFromRGB(0xFFE7E7E7);
        CGFloat btn1W = screenWidth - 11 * btnWH;
        for(int i = 0;i < 12;i++)
        {
            UIButton *btn = [[UIButton alloc] init];
            btn.userInteractionEnabled = NO;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.layer.borderWidth = 0.25;
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            CGFloat btnX = 0;
            if(i == 0){
                btnX = 0;
                btn.frame = CGRectMake(btnX, 0, btn1W, btnWH);
                [btn setTitle:@"期" forState:UIControlStateNormal];
                [btn setTitleColor:UIColorFromRGB(0xFF825A5A) forState:UIControlStateNormal];
            }else{
                btnX = btn1W + (i-1) * btnWH;
                btn.frame = CGRectMake(btnX, 0, btnWH, btnWH);
                [btn setTitle:[NSString stringWithFormat:@"%02d",i] forState:UIControlStateNormal];
            }
            [headerView addSubview:btn];
        }
        return headerView;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView != self.tableView1) return;
    YZSelectBallCell *cell1 = (YZSelectBallCell *)cell;
    if(_selectedPlayTypeBtnTag <= 7 || _selectedPlayTypeBtnTag == 9 || _selectedPlayTypeBtnTag == 11)//普通投注，除去前二直选、前三直选
    {
        NSMutableArray *statusArray = self.allSelBallsArray[_selectedPlayTypeBtnTag];
        if(statusArray.count == 0) return;
        for(YZBallBtn *ball in statusArray)
        {
            YZBallBtn *cellBall = cell1.ballsArray[ball.tag-1];
            [cellBall ballChangeToRed];
        }
    }else
    {
        NSMutableArray *cellStatusArray = self.allSelBallsArray[_selectedPlayTypeBtnTag][cell1.tag];
        if(cellStatusArray.count == 0) return;
        for(YZBallBtn *ball in cellStatusArray)
        {
            YZBallBtn *cellBall = cell1.ballsArray[ball.tag-1];
            [cellBall ballChangeToRed];
        }
    }
}
#pragma mark - YZHistoryWinViewDelegate
- (void)chooseBall:(NSArray *)selectedBalls withPlayTypeNum:(int)playTypeNum
{
    UIButton * button = _titleBtns[playTypeNum];
    [self switchOtherPlayTypeWithBtn:button];
    //关闭历史获奖视图
    [self closeTableViewWithAnimation];
    //点击号码球
    [self deleteBtnClick];
    for (int i = 0; i < selectedBalls.count; i++) {
        NSArray * balls = selectedBalls[i];
        YZSelectBallCell *cell = (YZSelectBallCell *)[self.tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        for(NSString *number in balls)
        {
            YZBallBtn *ball = cell.ballsArray[[number intValue]-1];
            [ball ballClick:ball];
        }
    }
    [self computeAmountMoney];
}
#pragma mark - 点击标题
- (void)setupPlayTypeView
{
    //底部背景遮盖
    UIView *playTypeBackView = [[UIView alloc] init];
    playTypeBackView.hidden = YES;
    self.playTypeBackView = playTypeBackView;
    playTypeBackView.backgroundColor = YZColor(0, 0, 0, 0.4);
    playTypeBackView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePlayTypeBackView)];
    [playTypeBackView addGestureRecognizer:tap];
    tap.delegate = self;
    [self.tabBarController.view addSubview:playTypeBackView];
    //玩法view
    UIView *playTypeView = [[UIView alloc] init];
    self.playTypeView = playTypeView;
    playTypeView.backgroundColor = [UIColor whiteColor];
    playTypeView.layer.cornerRadius = 5;
    playTypeView.clipsToBounds = YES;
    CGFloat playTypeViewW = screenWidth - 20;
    playTypeView.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.5);
    [playTypeBackView addSubview:playTypeView];
    
    int maxColums = 3;
    CGFloat btnH = 35;
    int padding = 20;
    UIButton *lastBtn;
    UILabel *lastLabel;
    for(int i = 0;i < playTypeBtnCount;i++)
    {
        if(i == 0)
        {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:YZGetFontSize(32)];
            label.backgroundColor = YZColor(240, 240, 240, 1);
            label.textColor = YZBlackTextColor;
            label.text = @"普通投注";
            CGFloat labelW = playTypeViewW - 10;
            CGFloat labelH = 30;
            label.frame =CGRectMake(5, padding, labelW, labelH);
            lastLabel = label;
            [playTypeView addSubview:label];
        }
        //玩法按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = YZColor(0, 0, 0, 0.2).CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
        [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [btn setTitle:_playTypeBtnTitles[i] forState:UIControlStateNormal];
        if(i == playTypeBtnCount-1)
        {
            btn.userInteractionEnabled = NO;
        }
        CGFloat btnW = (playTypeViewW - 10) / maxColums;
        CGFloat btnX = 5 + (i % maxColums) * btnW;
        
        [self.titleBtns addObject:btn];
        if(i == 12)
        {
            UILabel *label = [[UILabel alloc] init];
            label.font = [UIFont systemFontOfSize:YZGetFontSize(32)];
            label.backgroundColor = YZColor(240, 240, 240, 1);
            label.textColor = YZBlackTextColor;
            label.text = @"胆拖投注";
            CGFloat labelW = playTypeViewW - 10;
            CGFloat labelH = 30;
            CGFloat labelY = CGRectGetMaxY(lastBtn.frame) + padding;
            label.frame =CGRectMake(5, labelY, labelW, labelH);
            lastLabel = label;
            [playTypeView addSubview:label];
        }
        
        CGFloat btnY =  CGRectGetMaxY(lastLabel.frame) + padding + (i / maxColums) * btnH;
        if(i >= 12)
        {
            btnY = CGRectGetMaxY(lastLabel.frame) + padding + ((i - 12) / maxColums) * btnH;
        }
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        lastBtn = btn;
        [playTypeView addSubview:btn];
        [btn addTarget:self action:@selector(playTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        //选中图片
        int selectedPlayTypeBtnTag = [YZUserDefaultTool getIntForKey:@"selectedPlayTypeBtnTag"];//没有存储，取出来默认是0
        if(selectedPlayTypeBtnTag == i)//有就选择相应地按钮
        {
            btn.selected = YES;
        }
    }
    CGFloat playTypeViewH = CGRectGetMaxY(lastBtn.frame) + 5;
    playTypeView.bounds = CGRectMake(0, 0, playTypeViewW, playTypeViewH);
}
- (void)titleBtnClick:(YZTitleButton *)btn
{
    [self closeTableViewWithAnimation];//打开或者关闭tableView
    
    [UIView animateWithDuration:animateDuration animations:^{
        if(!_openTitleMenu)
        {
            btn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
            self.playTypeBackView.hidden = NO;
        }else
        {
            btn.imageView.transform = CGAffineTransformIdentity;
            self.playTypeBackView.hidden = YES;
        }
    }];
    _openTitleMenu = !_openTitleMenu;
    
    self.playTypeView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        self.playTypeView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

#pragma mark -  玩法按钮点击
- (void)playTypeBtn:(UIButton *)btn
{
    if(btn.tag == _selectedPlayTypeBtnTag)
    {
        return;//一样就不动
    }
    self.selectedPlayTypeBtn = btn;
    NSArray *savedStatusArr = [YZStatusCacheTool getStatues];
    //不是相同玩法,不支持混合投注,有数据则提示删除
    if(![_currentPlayTypeCode isEqualToString: _playTypeCodes[btn.tag]] && savedStatusArr.count > 0)
    {
        [self removePlayTypeBackView];
        [self showOtherPlayTypeAlertView];//切换不同玩法，有数据冲突时弹出
    }else
    {
        [self switchOtherPlayTypeWithBtn:btn];
    }
}
- (void)switchOtherPlayTypeWithBtn:(UIButton *)btn
{
    //存储选中的玩法
    [YZUserDefaultTool saveInt:(int)btn.tag forKey:@"selectedPlayTypeBtnTag"];
    
    //设置玩法
    _currentPlayTypeCode = _playTypeCodes[btn.tag];
    _selectedPlayTypeBtnTag = (int)btn.tag;
    _currentMinSelCount = [_minSelCountArray[btn.tag] intValue];

    //设置被选中
    for (int i = 0; i < self.titleBtns.count; i++) {
        YZLotteryButton * button = self.titleBtns[i];
        if (i == _selectedPlayTypeBtnTag) {
            button.selected = YES;
        }else
        {
            button.selected = NO;
        }
    }
    
    //设置要显示历史开奖的view
    [self switchCurrentHistoryView];
    
    //设置标题
    NSString *title = _playTypeBtnTitles[btn.tag];
    if(btn.tag >= 12)
    {
        title = [NSString stringWithFormat:@"%@胆拖",title];
    }
    [self.titleBtn setTitle:title forState:UIControlStateNormal];

    //设置当前数据源
    self.currentStatusArray = self.allStatusArray[btn.tag];
    //刷新数据
    [self.tableView1 reloadData];
    
    [self removePlayTypeBackView];
    
    [self computeAmountMoney];
    
    //设置摇一摇机选是否显示
    if(_selectedPlayTypeBtnTag < 12 )
    {
        self.autoSelectedLabel.hidden = NO;
    }else
    {
        self.autoSelectedLabel.hidden = YES;
    }

    [super setDeleteAutoSelectedBtnTitle];
}
//切换不同玩法，有数据冲突时弹出
- (void)showOtherPlayTypeAlertView
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"  message:@"该玩法目前不支持混合投注，是否清空您之前的投注号码？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"清空号码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [YZStatusCacheTool deleteAllStatus];//清空数据库中所有的号码数据
        [self switchOtherPlayTypeWithBtn:self.selectedPlayTypeBtn];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - YZBallBtnDelegate的代理方法,点击了ball 按钮
- (void)ballDidClick:(YZBallBtn *)btn
{
    if(_selectedPlayTypeBtnTag <= 7 || _selectedPlayTypeBtnTag == 9 || _selectedPlayTypeBtnTag == 11)//普通投注，除去前二直选、前三直选,只有一个cell的
    {
        NSMutableArray *statusArray = self.allSelBallsArray[_selectedPlayTypeBtnTag];
        if(btn.isSelected)//之前是选中的就移除
        {
            //由于不重用cell，号码球的地址值不一样，遍历数组球的tag，删除球
            YZBallBtn *selBall = nil;
            for(YZBallBtn *ball in statusArray)
            {
                if(btn.tag == ball.tag)
                {
                    selBall = ball;
                }
            }
            [statusArray removeObject:selBall];
        }else
        {
            if(_selectedPlayTypeBtnTag == 6 && statusArray.count >= 8)//任选八不超过8个
            {
                [btn ballChangeToWhite];
                [MBProgressHUD showError:@"至多能选择8个号码"];
                return;
            }
            [statusArray addObject:btn];
        }
    }else//2个cell以上的
    {
        YZSelectBallCell *cell = btn.owner;
        NSMutableArray *cellStatusArray = self.allSelBallsArray[_selectedPlayTypeBtnTag];
        if(btn.isSelected)
        {
            //由于不重用cell，号码球的地址值不一样，只能遍历数组球的tag，删除球
            YZBallBtn *selBall = nil;
            for(YZBallBtn *ball in cellStatusArray[cell.tag])
            {
                if(btn.tag == ball.tag)
                {
                    selBall = ball;
                }
            }
            [cellStatusArray[cell.tag] removeObject:selBall];//之前是选中的就移除
        }else
        {
            if(_selectedPlayTypeBtnTag >= 12)//如果不是前二直选、前三直选,2个cell的
            {
                if(cell.tag == 0)//第一个cell限制选球个数
                {
                    NSMutableArray *cellStatus0 = cellStatusArray[0];
                    int maxSelCount = [_maxSelCountArray[_selectedPlayTypeBtnTag - 12] intValue];
                    if(cellStatus0.count == maxSelCount)
                    {
                        [MBProgressHUD showError:[NSString stringWithFormat:@"至多选择%d个胆码",maxSelCount]];
                        [btn ballChangeToWhite];
                        return;
                    }
                }
                NSMutableArray *anotherCellStatus = cell.tag ? cellStatusArray[0] : cellStatusArray[1];
                YZBallBtn *selBall = nil;
                for(YZBallBtn *ball in anotherCellStatus)
                {
                    if(btn.tag == ball.tag)
                    {
                        selBall = ball;
                    }
                }
                if(selBall){//有相同的球,删除对方的
                    [anotherCellStatus removeObject:selBall];
                    int anotherRow = cell.tag ? 0 : 1;
                    YZSelectBallCell *anotherCell = (YZSelectBallCell *)[self.tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:anotherRow inSection:0]];
                    YZBallBtn *anotherBall = anotherCell.ballsArray[selBall.tag-1];
                    [anotherBall ballChangeToWhite];
                }
            }else if ((_selectedPlayTypeBtnTag == 8 || _selectedPlayTypeBtnTag == 10) && ([self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T64"]))
            {
                for (NSMutableArray *anotherCellStatus in cellStatusArray) {
                    NSInteger index = [cellStatusArray indexOfObject:anotherCellStatus];
                    if (cell.tag != index) {
                        YZBallBtn *selBall = nil;
                        for(YZBallBtn *ball in anotherCellStatus)
                        {
                            if(btn.tag == ball.tag)
                            {
                                selBall = ball;
                            }
                        }
                        if(selBall){//有相同的球,删除对方的
                            [anotherCellStatus removeObject:selBall];
                            int anotherRow = (int)index;
                            YZSelectBallCell *anotherCell = (YZSelectBallCell *)[self.tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:anotherRow inSection:0]];
                            YZBallBtn *anotherBall = anotherCell.ballsArray[selBall.tag-1];
                            [anotherBall ballChangeToWhite];
                        }
                    }
                }
            }
            [cellStatusArray[cell.tag] addObject:btn];
        }
    }
    [self computeAmountMoney];
}
#pragma mark - 计算注数和金额
- (void)computeAmountMoney
{
    int composeCount = 0;
    int i = _selectedPlayTypeBtnTag;
    NSMutableArray *statusArr = self.allSelBallsArray[i];
    if (i == 0) {//任选一
        composeCount = (int)statusArr.count;
    }else if(i == 8 || (i >= 12 && i <= 19))//前二直选,胆拖,两排红球
    {
        NSArray *arr0 = [self getNumbersArray:statusArr[0]];
        NSArray *arr1 = [self getNumbersArray:statusArr[1]];
        if(i == 8)
        {
            composeCount = [self computeCount_2:arr0 :arr1];
        }else
        {
            int allMinSelCount = [_maxSelCountArray[_selectedPlayTypeBtnTag - 12] intValue] + 1;//胆拖码共至少选几个
            if(arr0.count >= 1 && (arr0.count + arr1.count) > allMinSelCount)
            {
                composeCount = [YZMathTool getCountWithN:(int)arr1.count andM: (int)allMinSelCount - (int)arr0.count];
            }
        }
    }else if(i == 10)//前三直选，三排红球
    {
        NSArray *arr0 = [self getNumbersArray:statusArr[0]];
        NSArray *arr1 = [self getNumbersArray:statusArr[1]];
        NSArray *arr2 = [self getNumbersArray:statusArr[2]];
        composeCount = [self computeCount_3:arr0 :arr1 :arr2];
    }else//一排红球
    {
        composeCount = [YZMathTool getCountWithN:(int)statusArr.count andM:_currentMinSelCount];
    }
    self.betCount = composeCount;
}
#pragma mark - 确认按钮点击
- (void)confirmBtnClick:(UIButton *)btn
{
    //把信息存入数据库
    [YZCommitTool commit1x5BetWithBalls:self.allSelBallsArray betCount:self.betCount playType:_currentPlayTypeCode currentTitle:self.titleBtn.currentTitle selectedPlayTypeBtnTag:_selectedPlayTypeBtnTag];
        //删除所有的
    [self deleteBtnClick];
    [self gotoBetVc];
}
- (void)gotoBetVc
{
    YZBetViewController *bet = [[YZBetViewController alloc] initWithPlayType:_currentPlayTypeCode];//投注控制器
    bet.gameId = self.gameId;
    bet.selectedPlayTypeBtnTag = _selectedPlayTypeBtnTag;
    [self.navigationController pushViewController: bet animated:YES];
}
#pragma  mark - 删除按钮点击,删除当前tableview的数据
- (void)deleteBtnClick
{
    if(_selectedPlayTypeBtnTag <= 7 || _selectedPlayTypeBtnTag == 9 || _selectedPlayTypeBtnTag == 11)//只有一个cell的
    {
        [self.allSelBallsArray[_selectedPlayTypeBtnTag] removeAllObjects];
    }else
    {
        for(NSMutableArray *muArr in self.allSelBallsArray[_selectedPlayTypeBtnTag])
        {
            [muArr removeAllObjects];
        }
    }
    [self.tableView1 reloadData];
        
    [self computeAmountMoney];
}
//把球数组的号码转为字符串数组
- (NSArray *)getNumbersArray:(NSArray *)muArray
{
    NSMutableArray *arr = [NSMutableArray array];
    for(int i = 0;i < muArray.count;i++)
    {
        YZBallBtn *ball = muArray[i];
        [arr addObject:[NSString stringWithFormat:@"%ld",(long)ball.tag]];
    }
    return arr;
}
#pragma mark - 机选
- (void)autoSelectedBetWithNumber:(NSInteger)number
{
    for (int i = 0; i < number; i++) {
        [YZBetTool autoChooseS1x5WithPlayType:_currentPlayTypeCode andSelectedPlayTypeBtnTag:_selectedPlayTypeBtnTag];
    }
    [self gotoBetVc];
}
#pragma mark - 设置要显示历史开奖的view
- (void)switchCurrentHistoryView
{
    //有百千万的
    if( _selectedPlayTypeBtnTag == 8 || _selectedPlayTypeBtnTag == 10)
    {
        [self.view sendSubviewToBack:self.historyTableView];
        self.currentHistoryView = self.historyBackView;
    }else//没有千百万的
    {
        [self.view sendSubviewToBack:self.historyBackView];
        self.currentHistoryView = self.historyTableView;
    }
}
- (void)removePlayTypeBackView
{
    [UIView animateWithDuration:animateDuration
                     animations:^{
        self.titleBtn.imageView.transform = CGAffineTransformIdentity;
    }
                     completion:^(BOOL finished) {
        self.playTypeBackView.hidden = YES;
         _openTitleMenu = NO;
    }];
}
#pragma mark - UIGestureRecognizerDelegate
//支持多手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return  YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint pos = [touch locationInView:self.playTypeView.superview];
        if (CGRectContainsPoint(self.playTypeView.frame, pos)) {
            return NO;
        }
    }
    return YES;
}
- (NSMutableArray *)allSelBallsArray
{
    if(_allSelBallsArray == nil)
    {
        _allSelBallsArray = [NSMutableArray array];
        for(int i = 0;i < playTypeBtnCount-1;i++)
        {
            [_allSelBallsArray addObject:[NSMutableArray array]];
            if(i == 8 || i == 10 || (i >= 12 && i <= 19))//前二直选、前三直选和胆拖，添加一个数组
            {
                [_allSelBallsArray[i] addObject:[NSMutableArray array]];
                [_allSelBallsArray[i] addObject:[NSMutableArray array]];
            }
            if(i == 10)//前三直选，再添加一个数组
            {
                [_allSelBallsArray[i] addObject:[NSMutableArray array]];
            }
        }
    }
    return _allSelBallsArray;
}
#pragma  mark -  数据源
- (NSMutableArray *)allStatusArray
{
    if(_allStatusArray != nil)
    {
        return  _allStatusArray;
    }
    NSMutableArray *allArray = [NSMutableArray array];
    //任选一
    [allArray addObject:[self setupStatusWithTitle:@"至少选择1个号码，猜中第一位即中13元" isRed:YES ballsCount:11 icon:nil startNumber:@"1"]];
    //任选二
    [allArray addObject:[self setupStatusWithTitle:@"至少选择2个号码，猜中任意2个号码即中6元" isRed:YES ballsCount:11 icon:nil startNumber:@"1"]];
    //任选三
    [allArray addObject:[self setupStatusWithTitle:@"至少选择3个号码，猜中任意3个号码即中19元" isRed:YES ballsCount:11 icon:nil startNumber:@"1"]];
    //任选四
    [allArray addObject:[self setupStatusWithTitle:@"至少选择4个号码，猜中任意4个号码即中78元" isRed:YES ballsCount:11 icon:nil startNumber:@"1"]];
    //任选五
    [allArray addObject:[self setupStatusWithTitle:@"至少选择5个号码，猜中全部5个号即中540元" isRed:YES ballsCount:11 icon:nil startNumber:@"1"]];
    //任选六
    [allArray addObject:[self setupStatusWithTitle:@"至少选择6个号码，猜中全部5个号即中90元" isRed:YES ballsCount:11 icon:nil startNumber:@"1"]];
    //任选七
    [allArray addObject:[self setupStatusWithTitle:@"至少选择7个号码，猜中全部5个号即中26元" isRed:YES ballsCount:11 icon:nil startNumber:@"1"]];
    //任选八
    [allArray addObject:[self setupStatusWithTitle:@"请选择8个号码，猜中全部5个号即中9元" isRed:YES ballsCount:11 icon:nil startNumber:@"1"]];
    
    //前二直选
    NSArray *qianerArr1 = [self setupStatusWithTitle:@"每位至少选1个号，与前2位对应即中130元" isRed:YES ballsCount:11 icon:@"wan_flat" startNumber:@"1"];
    NSArray *qianerArr2 = [self setupStatusWithTitle:nil isRed:YES ballsCount:11 icon:@"qian_flat" startNumber:@"1"];
    [allArray addObject:@[qianerArr1.lastObject, qianerArr2.lastObject]];
    //前二组选
    [allArray addObject:[self setupStatusWithTitle:@"至少选择2个号码，猜中前2位顺序不限即中65元" isRed:YES ballsCount:11 icon:nil startNumber:@"1"]];
    //前三直选
    NSArray *qiansanArr1 = [self setupStatusWithTitle:@"每位至少选1个号，与前3位对应即中1170元" isRed:YES ballsCount:11 icon:@"wan_flat" startNumber:@"1"];
    NSArray *qiansanArr2 = [self setupStatusWithTitle:nil isRed:YES ballsCount:11 icon:@"qian_flat" startNumber:@"1"];
    NSArray *qiansanArr3 = [self setupStatusWithTitle:nil isRed:YES ballsCount:11 icon:@"bai_btn_flat" startNumber:@"1"];
    [allArray addObject:@[qiansanArr1.lastObject, qiansanArr2.lastObject, qiansanArr3.lastObject]];
    //前三组选
    [allArray addObject:[self setupStatusWithTitle:@"至少选择3个号码，猜中前3位顺序不限即中195元" isRed:YES ballsCount:11 icon:nil startNumber:@"1"]];
    //任选二胆拖
    [allArray addObject:[self setupBileDragStatusWithTitle1:@"胆码区 请选择1个号码" title2:@"拖码区 胆码和拖码个数之和至少3个"]];
    //任选三胆拖
    [allArray addObject:[self setupBileDragStatusWithTitle1:@"胆码区 至少选择1个，至多选择2个" title2:@"拖码区 胆码和拖码个数之和至少4个"]];
    //任选四胆拖
    [allArray addObject:[self setupBileDragStatusWithTitle1:@"胆码区 至少选择1个，至多选择3个" title2:@"拖码区 胆码和拖码个数之和至少5个"]];
    //任选五胆拖
    [allArray addObject:[self setupBileDragStatusWithTitle1:@"胆码区 至少选择1个，至多选择4个" title2:@"拖码区 胆码和拖码个数之和至少6个"]];
    //任选六胆拖
    [allArray addObject:[self setupBileDragStatusWithTitle1:@"胆码区 至少选择1个，至多选择5个" title2:@"拖码区 胆码和拖码个数之和至少7个"]];
    //任选七胆拖
    [allArray addObject:[self setupBileDragStatusWithTitle1:@"胆码区 至少选择1个，至多选择6个" title2:@"拖码区 胆码和拖码个数之和至少8个"]];
    //前二组选胆拖
    [allArray addObject:[self setupBileDragStatusWithTitle1:@"胆码区 请选择1个号码" title2:@"拖码区 胆码和拖码个数之和至少3个"]];
    //前三组选胆拖
    [allArray addObject:[self setupBileDragStatusWithTitle1:@"胆码区 至少选择1个，至多选择2个" title2:@"拖码区 胆码和拖码个数之和至少4个"]];

    return _allStatusArray = allArray;
}
#pragma  mark -  摇动机选
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSString * allowShake = [YZUserDefaultTool getObjectForKey:@"allowShake"];
    if ([allowShake isEqualToString:@"0"]) return;

    if(_selectedPlayTypeBtnTag >= 12 ) return;
    //删除已选的
    [self deleteBtnClick];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
    
    if(_selectedPlayTypeBtnTag <= 7 || _selectedPlayTypeBtnTag == 9 || _selectedPlayTypeBtnTag == 11)//一个cell的
    {
        //随机号码
        int minSelCount = [_minSelCountArray[_selectedPlayTypeBtnTag] intValue];
        NSMutableSet *randomSet = [[NSMutableSet alloc] init];
        while (randomSet.count < minSelCount)
        {
            int random = arc4random() % 11 + 1;
            [randomSet addObject:@(random)];
        }
        //点击号码球
        YZSelectBallCell *cell = (YZSelectBallCell *)[self.tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        for(NSNumber *number in randomSet)
        {
            YZBallBtn *ball = cell.ballsArray[[number intValue]-1];
            [ball ballClick:ball];
        }
    }else if(_selectedPlayTypeBtnTag == 8 || _selectedPlayTypeBtnTag == 10)//前三直选、前二直选
    {
        //随机号码
        NSMutableArray *selStatus = self.allSelBallsArray[_selectedPlayTypeBtnTag];
        NSMutableSet *randomSet = [[NSMutableSet alloc] init];
        while (randomSet.count < selStatus.count)
        {
            int random = arc4random() % 11 + 1;
            [randomSet addObject:@(random)];
        }
        //点击号码球
        for(int i = 0;i < randomSet.count;i++)
        {
            YZSelectBallCell *cell = (YZSelectBallCell *)[self.tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            
            YZBallBtn *ball = cell.ballsArray[[[randomSet allObjects][i] intValue]-1];
            [ball ballClick:ball];
        }
    }
}
#pragma mark - 带“中元”的数据生成方法
- (NSArray *)setupStatusWithTitle:(NSString *)title isRed:(BOOL)isRed ballsCount:(int)ballsCount icon:(NSString *)icon startNumber:(NSString *)startNumber
{
    NSMutableArray *array = [NSMutableArray array];
    YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
    if(title)
    {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:title];
        NSRange zhongRange = [[attStr string] rangeOfString:@"即中"];
        NSRange yuanRange = [[attStr string] rangeOfString:@"元"];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(zhongRange.location+2, yuanRange.location-zhongRange.location-2)];
        status.title = attStr;
    }
    status.isRed = isRed;
    status.ballsCount = ballsCount;
    status.icon = icon;
    status.startNumber = startNumber;
    status.ballReuse = NO;
    [array addObject:status];
    return array;
}
#pragma  mark - 生成胆拖数据
- (NSArray *)setupBileDragStatusWithTitle1:(NSString *)title1 title2:(NSString *)title2
{
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 0;i < 2;i++)
    {
        YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
        //第一组数据才有文字标题
        NSString *title = nil;
        if(i == 0){
            title = title1;
        }else{
            title = title2;
        }
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:title];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0,3)];
        status.title = attStr;
        status.isRed = YES;
        status.ballsCount = 11;
        status.startNumber = @"1";
        status.ballReuse = NO;
        [array addObject:status];
    }
    return array;
}
#pragma mark - 将胆拖码tag转换为普通tag
- (int)dantuoTagToNormalTagWithTag:(int)tag
{
    if(tag >=12 && tag <= 17){
        tag -= 12;
    }else if(tag == 18){
        tag = 9;
    }else if(tag == 19){
        tag = 11;
    }
    return tag;
}
- (NSArray *)recentStatusWithCellTag:(KhistoryCellTag)cellTag
{
    NSMutableArray *muArr = [[NSMutableArray alloc] init];
    for(int i = 0;i < self.recentStatus.count;i++)
    {
        YZRecentLotteryStatus *status = self.recentStatus[i];
        status.cellTag = cellTag;
        [muArr addObject:status];
    }
    return muArr;
}
- (NSMutableArray *)historyTableViews
{
    if(_historyTableViews == nil)
    {
        _historyTableViews = [NSMutableArray array];
    }
    return _historyTableViews;
}
- (NSMutableArray *)titleBtns
{
    if(_titleBtns == nil)
    {
        _titleBtns = [NSMutableArray array];
    }
    return _titleBtns;
}
#pragma mark - 工具
//11选5的两个cell的红球，求注数方法
- (int)computeCount_2:(NSArray *)nums1 :(NSArray *)nums2
{
    int stakeCount = 0;
    if (nums1.count == 0 || nums2.count == 0) {
        return 0;
    }
    for (int i = 0; i < nums1.count; i++) {
        for (int j = 0; j < nums2.count; j++) {
            NSString *str1 = nums1[i];
            NSString *str2 = nums2[j];
            if (![str1 isEqualToString:str2]) {
                stakeCount++;
            }
        }
    }
    return stakeCount;
}
//11选5的三个cell的红球，求注数方法
- (int)computeCount_3:(NSArray *)nums1 :(NSArray *)nums2 :(NSArray *) nums3
{
    int stakeCount = 0;
    if (nums1.count == 0 || nums2.count == 0 || nums3.count == 0) {
        return 0;
    }
    
    for (int i = 0; i < nums1.count; i++) {
        for (int j = 0; j < nums2.count; j++) {
            for (int k = 0; k < nums3.count; k++) {
                NSString *str1 = nums1[i];
                NSString *str2 = nums2[j];
                NSString *str3 = nums3[k];
                if ((![str1 isEqualToString:str2])
                    && (![str2 isEqualToString:str3])
                    && (![str1 isEqualToString:str3])) {
                    stakeCount++;
                }
            }
        }
    }
    return stakeCount;
}

@end
