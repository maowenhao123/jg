//
//  YZKy481ViewController.m
//  ez
//
//  Created by dahe on 2019/11/5.
//  Copyright © 2019 9ge. All rights reserved.
//
#import "YZKy481ViewController.h"
#import "YZKy481ChartViewController.h"
#import "YZKy481PlayTypeView.h"
#import "YZKy481WanNengView.h"
#import "YZKy481ChongView.h"
#import "YZKy481DanView.h"
#import "YZKy481BaView.h"
#import "YZChongDanView.h"
#import "YZTitleButton.h"
#import "YZKy481RecentLotteryCell.h"
#import "YZKy481Math.h"
#import "YZBallBtn.h"
#import "YZCommitTool.h"

@interface YZKy481ViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, YZKy481PlayTypeViewDelegate, YZSelectBallCellDelegate, YZBallBtnDelegate, YZKy481ViewDelegate>
{
    BOOL _panEnable;//pan手势是否激活
    CGFloat _lastTranslationY;
    CGFloat _historyCellH;
    NSString *_currentPlayTypeCode;//当前玩法
}
@property (nonatomic, weak) YZTitleButton *titleBtn;//title按钮
@property (nonatomic, weak) YZKy481PlayTypeView * playTypeView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) YZKy481WanNengView *wanNengView;
@property (nonatomic, weak) YZKy481ChongView *chongView;
@property (nonatomic, weak) YZKy481DanView *danView;
@property (nonatomic, weak) YZKy481BaView *baView;
@property (nonatomic, weak) YZChongDanView *chongDanView;
@property (nonatomic, strong) NSMutableArray *allStatusArray;//所有的数据
@property (nonatomic, strong) NSMutableArray *currentStatusArray;//当前tableview的数据
@property (nonatomic, strong) NSMutableArray *allSelBallsArray;//所有选中的球对象数组
@property (nonatomic, strong) NSMutableArray *historyTableViews;//含有分类的tableview数组
@property (nonatomic, weak) UIView *alphaChangeView;//透明度变化的view
@property (nonatomic, weak) UITableView *historyTableView;//不含分类的
@property (nonatomic, weak) UIView *currentHistoryView;//当前的历史开奖view
@property (nonatomic, weak) UIView *historyBackView;//有万千百位的历史开奖的背景view
@property (nonatomic, weak) UIView *historyTopBackView;//
@property (nonatomic, weak) UIButton *historySelBtn;
@property (nonatomic, weak) UIScrollView *historyScrollView;//有万千百位的历史开奖的scrollView
@property (nonatomic, strong) NSArray * playTypeCodes;
@property (nonatomic, weak) UIView *guideView;

@end

@implementation YZKy481ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedPlayTypeBtnTag = 0;
    _historyCellH = screenWidth / 12;
    self.selectedPlayTypeBtnTag = [YZUserDefaultTool getIntForKey:@"selectedky481PlayTypeBtnTag"];
    [self setupSonChilds];
    [self loadHistoryData];
    [self addGuideView];
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
        NSLog(@"%@", json);
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
    self.historyTableView.height = (self.recentStatus.count + 1) * _historyCellH;
    self.historyBackView.height = (self.recentStatus.count + 2) * _historyCellH;
    for (UITableView * tableView in self.historyTableViews) {
        tableView.height = (self.recentStatus.count + 1) * _historyCellH;
        [tableView reloadData];
    }
}

#pragma mark - 布局子视图
- (void)setupSonChilds
{
    //移除父控制器不必要的控件
    [self.backView removeFromSuperview];//移除俩个按钮
    [self.scrollView removeFromSuperview];//移除scrollview
    
    //titleBtn
    YZTitleButton *titleBtn = [[YZTitleButton alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    self.titleBtn = titleBtn;
    NSArray * playTypes = @[@"任选一", @"任选二", @"任选三", @"任选二全包", @"任选二万能两码", @"任选三全包", @"直选", @"组选4", @"组选6", @"组选12", @"组选24", @"三不重", @"二带一单式", @"二带一包单", @"二带一包对", @"二带一包号", @"包2", @"包3", @"豹子", @"形态", @"拖拉机"];
    [titleBtn setTitle:playTypes[self.selectedPlayTypeBtnTag] forState:UIControlStateNormal];
#if JG
    [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
#elif ZC
    [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
#elif CS
    [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
#endif
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
    //选择玩法类型
    YZKy481PlayTypeView * playTypeView = [[YZKy481PlayTypeView alloc] initWithFrame:KEY_WINDOW.bounds selectedPlayTypeBtnTag:self.selectedPlayTypeBtnTag];
    self.playTypeView = playTypeView;
    playTypeView.titleBtn = titleBtn;
    playTypeView.delegate = self;
    [KEY_WINDOW addSubview:playTypeView];
    
    //玩法
    CGFloat tableViewY = CGRectGetMaxY(self.endTimeLabel.frame);
    CGFloat tableViewH = self.tableView1.height;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, screenWidth, tableViewH)];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view insertSubview:tableView belowSubview:self.bottomView];
    [self addPanGestureToView:tableView];
    
    //任选二万能两码
    YZKy481WanNengView *wanNengView = [[YZKy481WanNengView alloc] initWithFrame:CGRectMake(0, tableViewY, screenWidth, tableViewH)];
    self.wanNengView = wanNengView;
    wanNengView.delegate = self;
    wanNengView.hidden = YES;
    [self.view insertSubview:wanNengView belowSubview:self.bottomView];
    [self addPanGestureToView:wanNengView];
    
    //组选4 组选12
    YZKy481ChongView *chongView = [[YZKy481ChongView alloc] initWithFrame:CGRectMake(0, tableViewY, screenWidth, tableViewH)];
    self.chongView = chongView;
    chongView.delegate = self;
    chongView.hidden = YES;
    [self.view insertSubview:chongView belowSubview:self.bottomView];
    [self addPanGestureToView:chongView];
    
    //组选6 组选24
    YZKy481DanView *danView = [[YZKy481DanView alloc] initWithFrame:CGRectMake(0, tableViewY, screenWidth, tableViewH)];
    self.danView = danView;
    danView.delegate = self;
    danView.hidden = YES;
    [self.view insertSubview:danView belowSubview:self.bottomView];
    [self addPanGestureToView:danView];
    
    //八个号码
    YZKy481BaView *baView = [[YZKy481BaView alloc] initWithFrame:CGRectMake(0, tableViewY, screenWidth, tableViewH)];
    self.baView = baView;
    baView.hidden = YES;
    baView.delegate = self;
    [self.view insertSubview:baView belowSubview:self.bottomView];
    [self addPanGestureToView:baView];
    
    //重号单号
    YZChongDanView *chongDanView = [[YZChongDanView alloc] initWithFrame:CGRectMake(0, tableViewY, screenWidth, tableViewH)];
    self.chongDanView = chongDanView;
    chongDanView.hidden = YES;
    chongDanView.delegate = self;
    [self.view insertSubview:chongDanView belowSubview:self.bottomView];
    [self addPanGestureToView:chongDanView];
    
    self.currentStatusArray = self.allStatusArray[self.selectedPlayTypeBtnTag];//记录的数据源
    _currentPlayTypeCode = self.playTypeCodes[self.selectedPlayTypeBtnTag];//记录的当前玩法
    
    //历史开奖
    UIView *alphaChangeView = [[UIView alloc] init];
    self.alphaChangeView = alphaChangeView;
    alphaChangeView.userInteractionEnabled = NO;
    alphaChangeView.frame = tableView.frame;
    [self.view insertSubview:alphaChangeView belowSubview:tableView];
    
    //看近期开奖的tableview
    UITableView *historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, screenWidth, 11 * _historyCellH)];
    self.historyTableView = historyTableView;
    historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    historyTableView.scrollEnabled = NO;
    historyTableView.delegate = self;
    historyTableView.dataSource = self;
    [historyTableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view insertSubview:historyTableView belowSubview:alphaChangeView];
    [self addPanGestureToView:historyTableView];
    
    UIView * historyBackView = [[UIView alloc] initWithFrame:CGRectMake(0, tableViewY, screenWidth, 12 * _historyCellH)];
    self.historyBackView = historyBackView;
    [self.view insertSubview:historyBackView belowSubview:self.historyTableView];
    
    //顶部按钮
    UIView * historyTopBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, _historyCellH)];
    self.historyTopBackView = historyTopBackView;
    [historyBackView addSubview:historyTopBackView];
    
    NSArray * btnTitles = @[@"综合", @"自由泳", @"仰泳", @"蛙泳", @"蝶泳"];
    CGFloat topBtnW = screenWidth / btnTitles.count;
    for(int i = 0; i < btnTitles.count; i++)
    {
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topBtn.tag = i;
        topBtn.frame = CGRectMake(topBtnW * i, 0, topBtnW, _historyCellH);
        topBtn.backgroundColor = [UIColor whiteColor];
        [topBtn setTitle:btnTitles[i] forState:UIControlStateNormal];
        topBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
        [topBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [topBtn setTitleColor:YZColor(233, 116, 61, 1.0) forState:UIControlStateSelected];
        [topBtn setBackgroundImage:[UIImage imageNamed:@"button_underline"] forState:UIControlStateSelected];
        if(i == 0)
        {
            topBtn.selected = YES;
            self.historySelBtn = topBtn;
        }
        [topBtn addTarget:self action:@selector(historyTopBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [historyTopBackView addSubview:topBtn];
    }
    
    //有万千百的历史开奖
    UIScrollView *historyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _historyCellH , screenWidth, 11 * _historyCellH)];
    self.historyScrollView = historyScrollView;
    historyScrollView.backgroundColor = [UIColor whiteColor];
    historyScrollView.delegate = self;
    historyScrollView.contentSize = CGSizeMake(screenWidth * btnTitles.count, historyScrollView.height);
    historyScrollView.showsHorizontalScrollIndicator = NO;
    historyScrollView.pagingEnabled = YES;
    [historyBackView addSubview:historyScrollView];
    [self addPanGestureToView:historyScrollView];
    
    //添加tableview
    for(int i = 0; i < btnTitles.count;i++)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, historyScrollView.height)];
        if (i == 0) {
            tableView.tag = KhistoryCellTagZongHe;
        }else if (i == 1)
        {
            tableView.tag = KhistoryCellTagZiyou;
        }else if (i == 2)
        {
            tableView.tag = KhistoryCellTagYang;
        }else if (i == 3)
        {
            tableView.tag = KhistoryCellTagWa;
        }else if (i == 4)
        {
            tableView.tag = KhistoryCellTagDie;
        }
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
        [self.historyTableViews addObject:tableView];
        [historyScrollView addSubview:tableView];
    }
    
    [self setViewHiddenOrShow];
    [self switchCurrentHistoryView];
}

#pragma mark -  标题按钮点击
- (void)titleBtnClick:(YZTitleButton *)btn
{
    [self.playTypeView show];
}

- (void)playTypeDidClickBtn:(UIButton *)btn
{
    NSArray *savedStatusArr = [YZStatusCacheTool getStatues];
    //不是相同玩法,不支持混合投注,有数据则提示删除
    if(self.selectedPlayTypeBtnTag != btn.tag && savedStatusArr.count > 0)
    {
        [self.playTypeView hidden];
        [self showOtherPlayTypeAlertViewWithBtn:btn];//切换不同玩法，有数据冲突时弹出
    }else
    {
        [self switchOtherPlayTypeWithBtn:btn];
    }
}

//切换不同玩法，有数据冲突时弹出
- (void)showOtherPlayTypeAlertViewWithBtn:(UIButton *)btn
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"  message:@"该玩法目前不支持混合投注，是否清空您之前的投注号码？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.playTypeView.selectedPlayTypeBtnTag = self.selectedPlayTypeBtnTag;
    }];
    UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"清空号码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [YZStatusCacheTool deleteAllStatus];//清空数据库中所有的号码数据
        [self switchOtherPlayTypeWithBtn:btn];
    }];
    [alertController addAction:alertAction1];
    [alertController addAction:alertAction2];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)switchOtherPlayTypeWithBtn:(UIButton *)btn
{
    //存储选中的玩法
    [YZUserDefaultTool saveInt:(int)btn.tag forKey:@"selectedky481PlayTypeBtnTag"];
    
    [self closeTableViewWithAnimation];//关闭tableView
    
    self.selectedPlayTypeBtnTag = btn.tag;
    _currentPlayTypeCode = self.playTypeCodes[btn.tag];
    [self.titleBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
    
    [self setViewHiddenOrShow];
}

- (void)setViewHiddenOrShow
{
    self.wanNengView.hidden = YES;
    self.danView.hidden = YES;
    self.chongView.hidden = YES;
    self.baView.hidden = YES;
    self.chongDanView.hidden = YES;
    self.tableView.hidden = YES;
    self.currentStatusArray = self.allStatusArray[self.selectedPlayTypeBtnTag];
    NSMutableArray *selStatusArray = self.allSelBallsArray[self.selectedPlayTypeBtnTag];
    if (self.selectedPlayTypeBtnTag == 0 || self.selectedPlayTypeBtnTag == 1 || self.selectedPlayTypeBtnTag == 2 || self.selectedPlayTypeBtnTag == 3 || self.selectedPlayTypeBtnTag == 5 || self.selectedPlayTypeBtnTag == 6) {
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }else if (self.selectedPlayTypeBtnTag == 4)//万能
    {
        self.wanNengView.hidden = NO;
        self.wanNengView.status = self.currentStatusArray.firstObject;
    }else if (self.selectedPlayTypeBtnTag == 7 || self.selectedPlayTypeBtnTag == 9)//组选4 组选12
    {
        self.chongView.hidden = NO;
        self.chongView.selectedPlayTypeBtnTag = self.selectedPlayTypeBtnTag;
        self.chongView.status = self.currentStatusArray.firstObject;
        self.chongView.selStatusArray = selStatusArray;
    }else if (self.selectedPlayTypeBtnTag == 8 || self.selectedPlayTypeBtnTag == 10)//组选6 组选24
    {
        self.danView.hidden = NO;
        self.danView.selectedPlayTypeBtnTag = self.selectedPlayTypeBtnTag;
        self.danView.status = self.currentStatusArray.firstObject;
        self.danView.selStatusArray = selStatusArray;
    }else if (self.selectedPlayTypeBtnTag == 11 || self.selectedPlayTypeBtnTag == 13 || self.selectedPlayTypeBtnTag == 14 || self.selectedPlayTypeBtnTag == 15 || self.selectedPlayTypeBtnTag == 16 || self.selectedPlayTypeBtnTag == 17 || self.selectedPlayTypeBtnTag == 18 || self.selectedPlayTypeBtnTag == 19 || self.selectedPlayTypeBtnTag == 20)
    {
        self.baView.hidden = NO;
        self.baView.selectedPlayTypeBtnTag = self.selectedPlayTypeBtnTag;
        self.baView.status = self.currentStatusArray.firstObject;
        self.baView.selStatusArray = selStatusArray;
    }else if (self.selectedPlayTypeBtnTag == 12)
    {
        self.chongDanView.hidden = NO;
        self.chongDanView.status = self.currentStatusArray.firstObject;
    }
    [self computeAmountMoney];
    [self switchCurrentHistoryView];
}

#pragma mark - 走势图引导
- (void)addGuideView
{
    BOOL haveShow = [YZUserDefaultTool getIntForKey:@"ky481_trend_guideHaveShow"];
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
    
    [YZUserDefaultTool saveInt:1 forKey:@"ky481_trend_guideHaveShow"];
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

#pragma mark - 历史开奖
- (void)historyTopBtnClick:(UIButton *)btn
{
    [self.historyScrollView setContentOffset:CGPointMake(btn.tag * screenWidth, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(![scrollView isKindOfClass:[UITableView class]])
    {
        if (scrollView == self.historyScrollView) {
            CGFloat offsetX = scrollView.contentOffset.x;
            double pageDouble = offsetX / (screenWidth);
            int historyPageInt = (int)(pageDouble + 0.5);
            [self changeHistoryBtnState:self.historyTopBackView.subviews[historyPageInt]];
        }
    }
}

- (void)changeHistoryBtnState:(UIButton *)btn
{
    self.historySelBtn.selected = NO;
    btn.selected = YES;
    self.historySelBtn = btn;
}

- (void)switchCurrentHistoryView
{
    if(self.selectedPlayTypeBtnTag == 4 || self.selectedPlayTypeBtnTag == 7 || self.selectedPlayTypeBtnTag == 8 || self.selectedPlayTypeBtnTag == 9 || self.selectedPlayTypeBtnTag == 10)//没有分类的
    {
        if (self.selectedPlayTypeBtnTag == 4) {
            self.historyTableView.tag = KhistoryCellTagWanNeng;
            _historyCellH = screenWidth / 14;
        }else
        {
            self.historyTableView.tag = KhistoryCellTagZu;
            _historyCellH = screenWidth / 12;
        }
        self.historyTableView.height = _historyCellH * (self.recentStatus.count + 1);
        [self.view sendSubviewToBack:self.historyBackView];
        [self.historyTableView reloadData];
        self.currentHistoryView = self.historyTableView;
    }else//有分类的
    {
        [self.view sendSubviewToBack:self.historyTableView];
        self.currentHistoryView = self.historyBackView;
        _historyCellH = screenWidth / 12;
    }
}

- (void)addPanGestureToView:(UIView *)view
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tableViewPan:)];
    pan.delegate = self;
    [view addGestureRecognizer:pan];
}

- (void)tableViewPan:(UIPanGestureRecognizer *)pan
{
    if(!_panEnable) return;
    UIView * panView;
    if (self.selectedPlayTypeBtnTag == 0 || self.selectedPlayTypeBtnTag == 1 || self.selectedPlayTypeBtnTag == 2 || self.selectedPlayTypeBtnTag == 3 || self.selectedPlayTypeBtnTag == 5 || self.selectedPlayTypeBtnTag == 6) {
        panView = self.tableView;
    }else if (self.selectedPlayTypeBtnTag == 4)//万能
    {
        panView = self.wanNengView;
    }else if (self.selectedPlayTypeBtnTag == 7 || self.selectedPlayTypeBtnTag == 9)//组选4 组选12
    {
        panView = self.chongView;
    }else if (self.selectedPlayTypeBtnTag == 8 || self.selectedPlayTypeBtnTag == 10)//组选6 组选24
    {
        panView = self.danView;
    }else if (self.selectedPlayTypeBtnTag == 11 || self.selectedPlayTypeBtnTag == 13 || self.selectedPlayTypeBtnTag == 14 || self.selectedPlayTypeBtnTag == 15 || self.selectedPlayTypeBtnTag == 16 || self.selectedPlayTypeBtnTag == 17 || self.selectedPlayTypeBtnTag == 18 || self.selectedPlayTypeBtnTag == 19 || self.selectedPlayTypeBtnTag == 20)
    {
        panView = self.baView;
    }else if (self.selectedPlayTypeBtnTag == 12)
    {
        panView = self.chongDanView;
    }
    CGFloat endTimeBgMaxY = CGRectGetMaxY(self.endTimeLabel.frame);
    CGPoint translation = [pan translationInView:panView];
    CGFloat endY = CGRectGetMaxY(self.currentHistoryView.frame);
    if(pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged)
    {
        if(((panView.y + translation.y) > endTimeBgMaxY)|| (translation.y < 0 && panView.y > endTimeBgMaxY) || (translation.y > 0 && panView.y < endY))//向上且y值大于endTimeBg的最大Y值，或者，向下且y值小于下面固定的某一值
        {
            panView.centerY = panView.centerY + translation.y;
            [pan setTranslation:CGPointZero inView:panView];
        }
        if(translation.y < 0 && panView.y < endTimeBgMaxY)//向上且y值小于endTimeBg的最大Y值
        {
            panView.y = endTimeBgMaxY;
        }else if(translation.y > 0 && panView.y > endY)//向下且y值大于下面固定的某一值
        {
            panView.y = endY;
        }
        _lastTranslationY = translation.y;
    }else if(pan.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:animateDuration
                         animations:^{
            if(_lastTranslationY > 2)//有向下滑的趋势
            {
                panView.y = endY;
            }else if (_lastTranslationY < -2)//有向上滑的趋势
            {
                panView.y = endTimeBgMaxY;
            }else//无趋势
            {
                if(panView.y < endTimeBgMaxY + self.currentHistoryView.height / 2)//tableview在endTimeBg上面了就归位
                {
                    panView.y = endTimeBgMaxY;
                }else if(panView.y >= endTimeBgMaxY + self.currentHistoryView.height / 2)//y值中间的一半以外，下去
                {
                    panView.y = endY;
                }else if(panView.y > self.bottomView.y)//y值大于下面一栏的y值就归位下去
                {
                    panView.y = endY;
                }
            }
        }];
    }else if (pan.state == UIGestureRecognizerStateCancelled)
    {
        [UIView animateWithDuration:animateDuration animations:^{
            panView.y = endTimeBgMaxY;
        }];
    }
    //设置透明度
    CGFloat layerScale = (panView.y - endTimeBgMaxY) / (endY - endTimeBgMaxY);
    self.alphaChangeView.layer.backgroundColor = YZColor(0, 0, 0, 0.7 * (1 - layerScale)).CGColor;
}

#pragma mark - 走势图页面
- (void)trendBtnDidClick
{
    YZKy481ChartViewController *chartVC = [[YZKy481ChartViewController alloc] init];
    chartVC.gameId = self.gameId;
    chartVC.selectedPlayTypeBtnTag = self.selectedPlayTypeBtnTag;
    [self.navigationController pushViewController:chartVC animated:YES];
}

#pragma mark - 近期开奖按钮点击，重写父类方法
- (void)recentOpenLotteryBtnClick
{
    UIView * view;
    if (self.selectedPlayTypeBtnTag == 4) {
        view = self.wanNengView;
    }else if (self.selectedPlayTypeBtnTag == 7 || self.selectedPlayTypeBtnTag == 9)//组选4 组选12
    {
        view = self.chongView;
    }else if (self.selectedPlayTypeBtnTag == 8 || self.selectedPlayTypeBtnTag == 10)//组选6 组选24
    {
        view = self.danView;
    }else
    {
        view = self.tableView;
    }
    
    if(view.y == CGRectGetMaxY(self.endTimeLabel.frame))
    {
        [self openTableViewWithAnimation];
    }else
    {
        [self closeTableViewWithAnimation];
    }
}

- (void)openTableViewWithAnimation
{
    if(!_panEnable) return;
    UIView * view;
    if (self.selectedPlayTypeBtnTag == 4) {
        view = self.wanNengView;
    }else if (self.selectedPlayTypeBtnTag == 7 || self.selectedPlayTypeBtnTag == 9)//组选4 组选12
    {
        view = self.chongView;
    }else if (self.selectedPlayTypeBtnTag == 8 || self.selectedPlayTypeBtnTag == 10)//组选6 组选24
    {
        view = self.danView;
    }else
    {
        view = self.tableView;
    }
    
    if(view.y == CGRectGetMaxY(self.endTimeLabel.frame))
    {
        [UIView animateWithDuration:animateDuration
                         animations:^{
            self.alphaChangeView.layer.backgroundColor = YZColor(0, 0, 0, 0).CGColor;
            view.y = CGRectGetMaxY(self.currentHistoryView.frame);
        }];
    }
}

- (void)closeTableViewWithAnimation
{
    UIView * view;
    if (self.selectedPlayTypeBtnTag == 4) {
        view = self.wanNengView;
    }else if (self.selectedPlayTypeBtnTag == 7 || self.selectedPlayTypeBtnTag == 9)//组选4 组选12
    {
        view = self.chongView;
    }else if (self.selectedPlayTypeBtnTag == 8 || self.selectedPlayTypeBtnTag == 10)//组选6 组选24
    {
        view = self.danView;
    }else
    {
        view = self.tableView;
    }
    
    if(view.y != CGRectGetMaxY(self.endTimeLabel.frame))
    {
        [UIView animateWithDuration:animateDuration
                         animations:^{
            self.alphaChangeView.layer.backgroundColor = YZColor(0, 0, 0, 0.7).CGColor;
            view.y = CGRectGetMaxY(self.endTimeLabel.frame);
        }];
    }
}

#pragma  mark - 清空数据
- (void)deleteBtnClick
{
    NSMutableArray *selStatusArray = self.allSelBallsArray[self.selectedPlayTypeBtnTag];
    for (NSMutableArray * selStatusArray_ in selStatusArray) {
        [selStatusArray_ removeAllObjects];
    }
    if (self.selectedPlayTypeBtnTag == 0 || self.selectedPlayTypeBtnTag == 1 || self.selectedPlayTypeBtnTag == 2 || self.selectedPlayTypeBtnTag == 3 || self.selectedPlayTypeBtnTag == 5 || self.selectedPlayTypeBtnTag == 6) {
        self.tableView.hidden = NO;
        [self.tableView reloadData];
    }else if (self.selectedPlayTypeBtnTag == 4)
    {
        [self.wanNengView reloadData];
    }else if (self.selectedPlayTypeBtnTag == 7 || self.selectedPlayTypeBtnTag == 9)//组选4 组选12
    {
        self.chongView.selStatusArray = selStatusArray;
    }else if (self.selectedPlayTypeBtnTag == 8 || self.selectedPlayTypeBtnTag == 10)//组选6 组选24
    {
        self.danView.selStatusArray = selStatusArray;
    }else if (self.selectedPlayTypeBtnTag == 11 || self.selectedPlayTypeBtnTag == 13 || self.selectedPlayTypeBtnTag == 14 || self.selectedPlayTypeBtnTag == 15 || self.selectedPlayTypeBtnTag == 16 || self.selectedPlayTypeBtnTag == 17 || self.selectedPlayTypeBtnTag == 18 || self.selectedPlayTypeBtnTag == 19 || self.selectedPlayTypeBtnTag == 20)
    {
        self.baView.selStatusArray = selStatusArray;
    }else if (self.selectedPlayTypeBtnTag == 12)
    {
        [self.chongDanView reloadData];
    }
    [self computeAmountMoney];
}

#pragma mark - 确认按钮点击
- (void)confirmBtnClick:(UIButton *)btn
{
    [YZCommitTool commitKy481BetWithBalls:self.allSelBallsArray betCount:self.betCount playType:_currentPlayTypeCode currentTitle:self.titleBtn.currentTitle selectedPlayTypeBtnTag:self.selectedPlayTypeBtnTag];
    [self deleteBtnClick];
    [self gotoBetVc];
}

- (void)gotoBetVc
{
    YZBetViewController *bet = [[YZBetViewController alloc] initWithPlayType:_currentPlayTypeCode];
    bet.gameId = self.gameId;
    bet.selectedPlayTypeBtnTag = (int)self.selectedPlayTypeBtnTag;
    [self.navigationController pushViewController: bet animated:YES];
}

#pragma mark - 机选
- (void)autoSelectedBetWithNumber:(NSInteger)number
{
    for (int i = 0; i < number; i++) {
        [YZBetTool autoChooseKy481WithPlayType:_currentPlayTypeCode andSelectedPlayTypeBtnTag:(int)self.selectedPlayTypeBtnTag];
    }
    [self gotoBetVc];
}

#pragma  mark -  摇动机选
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSString * allowShake = [YZUserDefaultTool getObjectForKey:@"allowShake"];
    if ([allowShake isEqualToString:@"0"]) return;
    
    //删除已选的
    [self deleteBtnClick];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
    
    if (self.selectedPlayTypeBtnTag == 0 || self.selectedPlayTypeBtnTag == 1 || self.selectedPlayTypeBtnTag == 2 || self.selectedPlayTypeBtnTag == 3 || self.selectedPlayTypeBtnTag == 5 || self.selectedPlayTypeBtnTag == 6) {
        NSInteger number = self.selectedPlayTypeBtnTag + 1;
        if (self.selectedPlayTypeBtnTag == 6) {
            number = 4;
        }else if (self.selectedPlayTypeBtnTag == 3)
        {
            number = 2;
        }else if (self.selectedPlayTypeBtnTag == 5)
        {
            number = 3;
        }
        for (int i = 0; i < number; i++) {
            int random = arc4random() % 8 + 1;
            //点击号码球
            YZSelectBallCell *cell = (YZSelectBallCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            YZBallBtn *ball = cell.ballsArray[random - 1];
            [ball ballClick:ball];
        }
        
    }else if (self.selectedPlayTypeBtnTag == 4)
    {
        NSArray * ballTitles =  @[@"28", @"37", @"46", @"55", @"38", @"47", @"56", @"11", @"48", @"57", @"66", @"12", @"58", @"67", @"13", @"22", @"68", @"77", @"14", @"23", @"78", @"15", @"24", @"33", @"88", @"16", @"25", @"34", @"17", @"26", @"35", @"44", @"18", @"27", @"36", @"45"];
        int random = arc4random() % ballTitles.count;
        self.wanNengView.randomTitle = ballTitles[random];
    }else if (self.selectedPlayTypeBtnTag == 7 || self.selectedPlayTypeBtnTag == 8 || self.selectedPlayTypeBtnTag == 9 || self.selectedPlayTypeBtnTag == 10)
    {
        NSInteger number = 2;
        if (self.selectedPlayTypeBtnTag == 9) {
            number = 3;
        }else if (self.selectedPlayTypeBtnTag == 10)
        {
            number = 4;
        }
        NSMutableSet *randomSet = [[NSMutableSet alloc] init];
        while (randomSet.count < number)
        {
            int random = arc4random() % 8 + 1;
            [randomSet addObject:@(random)];
        }
        if (self.selectedPlayTypeBtnTag == 7 || self.selectedPlayTypeBtnTag == 9) {
            self.chongView.randomSet = randomSet;
        }else if (self.selectedPlayTypeBtnTag == 8 || self.selectedPlayTypeBtnTag == 10)
        {
            self.danView.randomSet = randomSet;
        }
    }
}

#pragma mark - tableview的代理数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.tableView)
    {
        return self.currentStatusArray.count;
    }else
    {
        int count = (int)self.recentStatus.count;
        if(count > 0) _panEnable = YES;
        return count + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView)
    {
        YZSelectBallCell *cell = [YZSelectBallCell cellWithTableView:tableView andIndexpath:indexPath];
        cell.index = indexPath.row;
        cell.delegate = self;
        cell.tag = indexPath.row;
        cell.status = self.currentStatusArray[indexPath.row];
        return cell;
    }else
    {
        YZKy481RecentLotteryCell *cell = [YZKy481RecentLotteryCell cellWithTableView:tableView];
        if(indexPath.row % 2 == 0)
        {
            cell.backgroundColor = UIColorFromRGB(0xFFE7E7E7);
        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.cellTag = (int)tableView.tag;
        cell.index = indexPath.row;
        if (indexPath.row > 0) {
            cell.status = self.recentStatus[indexPath.row - 1];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.tableView)
    {
        YZSelectBallCellStatus * status = self.currentStatusArray[indexPath.row];
        return status.cellH;
    }else
    {
        return _historyCellH;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView != self.tableView) return;
    NSMutableArray *selStatusArray = self.allSelBallsArray[self.selectedPlayTypeBtnTag][cell.tag];
    if(selStatusArray.count == 0) return;
    YZSelectBallCell * cell_ = (YZSelectBallCell *)cell;
    for(YZBallBtn *ball in selStatusArray)
    {
        YZBallBtn *cellBall = cell_.ballsArray[ball.tag - 1];
        [cellBall ballChangeToRed];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView != self.tableView)
    {
        [self trendBtnDidClick];
    }
}

#pragma mark - 自定义协议
- (void)ballDidClick:(YZBallBtn *)btn
{
    NSMutableArray *statusArray = self.allSelBallsArray[self.selectedPlayTypeBtnTag];
    if (self.selectedPlayTypeBtnTag == 0 || self.selectedPlayTypeBtnTag == 1 || self.selectedPlayTypeBtnTag == 2 || self.selectedPlayTypeBtnTag == 3 || self.selectedPlayTypeBtnTag == 5 || self.selectedPlayTypeBtnTag == 6)
    {
        YZSelectBallCell *cell = btn.owner;
        if(btn.isSelected)
        {
            YZBallBtn *selBall = nil;
            for(YZBallBtn *ball in statusArray[cell.tag])
            {
                if(btn.tag == ball.tag)
                {
                    selBall = ball;
                }
            }
            [statusArray[cell.tag] removeObject:selBall];
        }else
        {
            [statusArray[cell.tag] addObject:btn];
        }
    }else if (self.selectedPlayTypeBtnTag == 8 || self.selectedPlayTypeBtnTag == 10)
    {
        NSMutableArray * statusArray_ = [NSMutableArray array];
        if (btn.tag > 10) {
            statusArray_ = statusArray[0];
        }else
        {
            statusArray_ = statusArray[1];
        }
        if(btn.isSelected)
        {
            [statusArray_ removeObject:btn];
        }else
        {
            [statusArray_ addObject:btn];
        }
    }else if (self.selectedPlayTypeBtnTag == 7 || self.selectedPlayTypeBtnTag == 9)
    {
        NSMutableArray * statusArray_ = [NSMutableArray array];
        if (btn.tag >= 10) {
            statusArray_ = statusArray[1];
        }else
        {
            statusArray_ = statusArray[0];
        }
        if(btn.isSelected)
        {
            [statusArray_ removeObject:btn];
        }else
        {
            [statusArray_ addObject:btn];
        }
    }else if (self.selectedPlayTypeBtnTag == 4)//任选二万能
    {
        NSMutableArray * statusArray_ = statusArray[0];
        if(!btn.isSelected)
        {
            [statusArray_ removeObject:btn];
        }else
        {
            [statusArray_ addObject:btn];
        }
    }else if (self.selectedPlayTypeBtnTag == 12)
    {
        NSMutableArray * statusArray_ = [NSMutableArray array];
        if (btn.tag >= 110) {
            statusArray_ = statusArray[1];
        }else
        {
            statusArray_ = statusArray[0];
        }
        if(btn.isSelected)
        {
            [statusArray_ addObject:btn];
        }else
        {
            [statusArray_ removeObject:btn];
        }
    }else if (self.selectedPlayTypeBtnTag == 11 || self.selectedPlayTypeBtnTag == 13 || self.selectedPlayTypeBtnTag == 14 || self.selectedPlayTypeBtnTag == 15 || self.selectedPlayTypeBtnTag == 16 || self.selectedPlayTypeBtnTag == 17 || self.selectedPlayTypeBtnTag == 18 || self.selectedPlayTypeBtnTag == 19 || self.selectedPlayTypeBtnTag == 20)
    {
        NSMutableArray * statusArray_ = statusArray[0];
        if(btn.isSelected)
        {
            [statusArray_ addObject:btn];
        }else
        {
            [statusArray_ removeObject:btn];
        }
    }
    [self computeAmountMoney];
}

#pragma mark - 计算注数和金额
- (void)computeAmountMoney
{
    NSMutableArray *selStatusArray = self.allSelBallsArray[self.selectedPlayTypeBtnTag];
    if (self.selectedPlayTypeBtnTag == 1 || self.selectedPlayTypeBtnTag == 2) {
        for (NSArray * cellStatusArray in selStatusArray) {
            if (cellStatusArray.count > 0) {
                self.selectcount ++;
            }
        }
    }
    self.betCount = [YZKy481Math getBetCountWithSelStatusArray:selStatusArray selectedPlayTypeBtnTag:self.selectedPlayTypeBtnTag];
}

#pragma  mark -  数据源
- (NSMutableArray *)allStatusArray
{
    if(_allStatusArray == nil)
    {
        _allStatusArray = [NSMutableArray array];
        //任选一 任选一 任选一 直选
        NSMutableArray * playTypeBalls6 = [NSMutableArray array];
        NSArray * yongTitles = @[@"自由泳", @"仰泳", @"蛙泳", @"蝶泳"];
        NSArray * hitTitles = @[@"任选一项，猜中一项即中9元", @"任选二项，猜中任意2项且顺序一致即中74元", @"任选三项，猜中任意3项且顺序一致即中593元", @"开奖号码与所选号码相同即中4751元"];
        for (int i = 0; i < hitTitles.count; i++) {
            NSMutableArray * playTypeBalls = [NSMutableArray array];
            for (int j = 0; j < yongTitles.count; j++) {
                NSString * hitTitle = @"";
                NSString * yongTitle = yongTitles[j];
                if (j == 0) {
                    hitTitle = hitTitles[i];
                }
                YZSelectBallCellStatus *status = [self setupStatusWithTitle:hitTitle ballsCount:8 leftTitle:yongTitle icon:@"" startNumber:@"1"];
                if (i == 3) {
                    [playTypeBalls6 addObject:status];
                }else
                {
                    [playTypeBalls addObject:status];
                }
            }
            if (i != 3) {
                [_allStatusArray addObject:playTypeBalls];
            }
        }
        
        //任选二全包
        NSMutableArray * playTypeBalls3 = [NSMutableArray array];
        YZSelectBallCellStatus *status31 = [self setupStatusWithTitle:@"开奖号码中包含所选的两位即中74元" ballsCount:8 leftTitle:@"" icon:@"one_flat" startNumber:@"1"];
        [playTypeBalls3 addObject:status31];
        YZSelectBallCellStatus *status32 = [self setupStatusWithTitle:@"" ballsCount:8 leftTitle:@"" icon:@"two_flat" startNumber:@"1"];
        [playTypeBalls3 addObject:status32];
        [_allStatusArray addObject:playTypeBalls3];
        
        //任选二万能两码
        NSMutableArray * playTypeBalls4 = [NSMutableArray array];
        YZSelectBallCellStatus *status4 = [self setupStatusWithTitle:@"开奖号码中包含所选的两位即中74元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls4 addObject:status4];
        [_allStatusArray addObject:playTypeBalls4];
        
        //任选三全包
        NSMutableArray * playTypeBalls5 = [NSMutableArray array];
        NSArray * weiTitles = @[@"第一位", @"第二位", @"第三位"];
        for (int i = 0; i < weiTitles.count; i++) {
            NSString * hitTitle = @"";
            if (i == 0) {
                hitTitle = @"开奖号码中包含所选的三位即中593元";
            }
            YZSelectBallCellStatus *status = [self setupStatusWithTitle:hitTitle ballsCount:8 leftTitle:weiTitles[i] icon:@"" startNumber:@"1"];
            [playTypeBalls5 addObject:status];
        }
        [_allStatusArray addObject:playTypeBalls5];
        
        //直选
        [_allStatusArray addObject:playTypeBalls6];
        
        //组选4
        NSMutableArray * playTypeBalls7 = [NSMutableArray array];
        YZSelectBallCellStatus *status7 = [self setupStatusWithTitle:@"开奖号码与所选号码相同即中1187元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls7 addObject:status7];
        [_allStatusArray addObject:playTypeBalls7];
        
        //组选6
        NSMutableArray * playTypeBalls8 = [NSMutableArray array];
        YZSelectBallCellStatus *status8 = [self setupStatusWithTitle:@"开奖号码与所选号码相同即中791元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls8 addObject:status8];
        [_allStatusArray addObject:playTypeBalls8];
        
        //组选12
        NSMutableArray * playTypeBalls9 = [NSMutableArray array];
        YZSelectBallCellStatus *status9 = [self setupStatusWithTitle:@"开奖号码与所选号码相同即中395元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls9 addObject:status9];
        [_allStatusArray addObject:playTypeBalls9];
        
        //组选24
        NSMutableArray * playTypeBalls10 = [NSMutableArray array];
        YZSelectBallCellStatus *status10 = [self setupStatusWithTitle:@"开奖号码与所选号码相同即中197元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls10 addObject:status10];
        [_allStatusArray addObject:playTypeBalls10];
        
        //三不重
        NSMutableArray * playTypeBalls11 = [NSMutableArray array];
        YZSelectBallCellStatus *status11 = [self setupStatusWithTitle:@"任选三项，猜中前三位或后三位即中49元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls11 addObject:status11];
        [_allStatusArray addObject:playTypeBalls11];
        
        //二带一单式
        NSMutableArray * playTypeBalls12 = [NSMutableArray array];
        YZSelectBallCellStatus *status12 = [self setupStatusWithTitle:@"任选两项，猜中前三位或后三位即中98元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls12 addObject:status12];
        [_allStatusArray addObject:playTypeBalls12];
        
        //二带一包单
        NSMutableArray * playTypeBalls13 = [NSMutableArray array];
        YZSelectBallCellStatus *status13 = [self setupStatusWithTitle:@"任选一对，全包投注，猜中即中98元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls13 addObject:status13];
        [_allStatusArray addObject:playTypeBalls13];
        
        //二带一包对
        NSMutableArray * playTypeBalls14 = [NSMutableArray array];
        YZSelectBallCellStatus *status14 = [self setupStatusWithTitle:@"任选一对，包对投注，猜中即中98元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls14 addObject:status14];
        [_allStatusArray addObject:playTypeBalls14];
        
        //二带一包号
        NSMutableArray * playTypeBalls15 = [NSMutableArray array];
        YZSelectBallCellStatus *status15 = [self setupStatusWithTitle:@"任选两项，猜中前三位或后三位即中98元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls15 addObject:status15];
        [_allStatusArray addObject:playTypeBalls15];
        
        //包2
        NSMutableArray * playTypeBalls16 = [NSMutableArray array];
        YZSelectBallCellStatus *status16 = [self setupStatusWithTitle:@"任选两项，猜中前三位或后三位即中49元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls16 addObject:status16];
        [_allStatusArray addObject:playTypeBalls16];
        
        //包3
        NSMutableArray * playTypeBalls17 = [NSMutableArray array];
        YZSelectBallCellStatus *status17 = [self setupStatusWithTitle:@"任选三项，猜中前三位或后三位即中49元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls17 addObject:status17];
        [_allStatusArray addObject:playTypeBalls17];
        
        //豹子
        NSMutableArray * playTypeBalls18 = [NSMutableArray array];
        YZSelectBallCellStatus *status18 = [self setupStatusWithTitle:@"至少任选一项，猜中即中163元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls18 addObject:status18];
        [_allStatusArray addObject:playTypeBalls18];
        
        //形态
        NSMutableArray * playTypeBalls19 = [NSMutableArray array];
        YZSelectBallCellStatus *status19 = [self setupStatusWithTitle:@"组4形态单注奖金固定为21元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls19 addObject:status19];
        [_allStatusArray addObject:playTypeBalls19];
        
        //拖拉机
        NSMutableArray * playTypeBalls20 = [NSMutableArray array];
        YZSelectBallCellStatus *status20 = [self setupStatusWithTitle:@"猜中前三位或后三位按照大小且相连的顺序排列即中26元" ballsCount:8 leftTitle:@"" icon:@"" startNumber:@"1"];
        [playTypeBalls20 addObject:status20];
        [_allStatusArray addObject:playTypeBalls20];
    }
    return  _allStatusArray;
}

- (NSMutableArray *)allSelBallsArray
{
    if(_allSelBallsArray == nil)
    {
        _allSelBallsArray = [NSMutableArray array];
        for(int i = 0; i < 21; i++)
        {
            [_allSelBallsArray addObject:[NSMutableArray array]];
            for (int j = 0; j < 4; j++) {
                [_allSelBallsArray[i] addObject:[NSMutableArray array]];
            }
        }
    }
    return _allSelBallsArray;
}

- (NSMutableArray *)historyTableViews
{
    if(_historyTableViews == nil)
    {
        _historyTableViews = [NSMutableArray array];
    }
    return _historyTableViews;
}

- (NSArray *)playTypeCodes
{
    if (!_playTypeCodes) {
        _playTypeCodes = @[@"05", @"06", @"07", @"06", @"06", @"07", @"08", @"04", @"03", @"02", @"01", @"12", @"09", @"09", @"09", @"09", @"10", @"11", @"15", @"16", @"13"];
    }
    return _playTypeCodes;
}

#pragma mark - 带“中元”的数据生成方法
- (YZSelectBallCellStatus *)setupStatusWithTitle:(NSString *)title ballsCount:(int)ballsCount leftTitle:(NSString *)leftTitle icon:(NSString *)icon startNumber:(NSString *)startNumber
{
    YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
    if(!YZStringIsEmpty(title))
    {
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:title];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:NSMakeRange(0, attStr.length)];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\D*"  options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
        NSArray *result = [regex matchesInString:attStr.string options:0 range:NSMakeRange(0, attStr.length)];
        for (NSTextCheckingResult *resultCheck in result) {
            if (resultCheck.range.length > 0) {
                [attStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:resultCheck.range];
            }
        }
        status.title = attStr;
    }
    status.ballsCount = ballsCount;
    status.leftTitle = leftTitle;
    status.startNumber = startNumber;
    status.isRed = YES;
    status.icon = icon;
    status.ballReuse = NO;
    return status;
}

@end
