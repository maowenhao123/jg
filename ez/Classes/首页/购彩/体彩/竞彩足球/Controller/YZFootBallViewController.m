//
//  YZFootBallViewController.m
//  ez
//
//  Created by apple on 14-11-19.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZFootBallViewController.h"
#import "YZFBMatchDetailViewController.h"
#import "YZFTHeaderView.h"
#import "YZFootBallCell.h"
#import "YZFbBetViewController.h"
#import "YZFbBetCellStatus.h"
#import "YZFootBallMatchRate.h"
#import "YZFBPlayTypeView.h"
#import "YZFBSiftView.h"
#import "YZDateTool.h"

@interface YZFootBallViewController ()<UITableViewDataSource,UITableViewDelegate, YZFTHeaderViewDelegate, YZFBPlayTypeViewDelegate, YZFBSiftViewDelegate, YZFootBallCellDelegate>
{
    NSInteger _selectedPlayTypeBtnTag;//选中的玩法的tag
    NSInteger _selectedMatchCount;//已选比赛场次
    int _minMatchCount;//当前玩法最少选择的比赛场数
}
@property (nonatomic, weak) YZFBPlayTypeView *playTypeView;//选择玩法视图
@property (nonatomic, weak) YZFBSiftView *siftView;//筛选视图
@property (nonatomic, strong) NSArray *statusArray;//数据数组，里面放YZFtCellStatus
@property (nonatomic, strong) NSArray *currentStatusArray;//当前的数据数组，里面放YZFtCellStatus
@property (nonatomic, strong) NSArray *matchNameArray;//比赛名称数组
@property (nonatomic, weak) MJRefreshGifHeader *header;
@property (nonatomic, weak) YZTitleButton *titleBtn;
@property (nonatomic, strong)  NSMutableArray *currentMatchNames;//当前比赛名称的数组
@property (nonatomic, weak) UIBarButtonItem *siftBtn;//筛选按钮
@property (nonatomic, assign) NSInteger selectedMatchCount;//已选比赛场次
@property (nonatomic, strong) NSMutableDictionary *matchDetailDic;//比赛详情
@property (nonatomic, weak) UIView *guideView;

@end


@implementation YZFootBallViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setBottomMidLabelText];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _minMatchCount = 2;
    
    UIBarButtonItem *siftBtn = [UIBarButtonItem itemWithIcon:@"ft_top_sift" highIcon:nil target:self action:@selector(siftBtnClick)];
    siftBtn.enabled = NO;
    self.siftBtn = siftBtn;
    UIBarButtonItem *navMoreBtn = [UIBarButtonItem itemWithIcon:@"more_flat" highIcon:@"more_pressed_flat" target:self action:@selector(openMenuView)];
    self.navigationItem.rightBarButtonItems = @[navMoreBtn, siftBtn];//筛选按钮
    
    [self setupSonChilds];
}

- (void)openMenuView
{
    [super openMenuView];
}

#pragma mark - 添加子视图
- (void)setupSonChilds
{
    //玩法
    YZFBPlayTypeView *playTypeView = [[YZFBPlayTypeView alloc] initWithFrame:KEY_WINDOW.bounds selectedPlayTypeBtnTag:_selectedPlayTypeBtnTag];
    self.playTypeView = playTypeView;
    playTypeView.delegate = self;
    [KEY_WINDOW addSubview:playTypeView];
    
    //设置底下文字
    self.bottomMidLabel.text = @"  至少选2场比赛";
    
    //titlebutton
    YZTitleButton *titleBtn = [[YZTitleButton alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    titleBtn.userInteractionEnabled = NO;
    self.titleBtn = titleBtn;
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
    [titleBtn setTitle:@"混合过关" forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    playTypeView.titleBtn = self.titleBtn;
    
    //tableView
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    CGFloat tableViewH = self.bottomView.y;
    tableView.frame = CGRectMake(0, 0, screenWidth, tableViewH);
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view insertSubview:tableView belowSubview:self.bottomView];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderData:header];
    self.header = header;
    tableView.mj_header = header;
}

- (void)addGuideView
{
    BOOL haveShow = [YZUserDefaultTool getIntForKey:@"fb_match_detail_guideHaveShow"];
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
    CGPoint center = CGPointMake(35, statusBarH + navBarH + 44 + 99);
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath moveToPoint:center];
    [circlePath addArcWithCenter:center radius:15 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    [circlePath closePath];
    
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];

    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = YZColor(0, 0, 0, 0.6).CGColor;
    
    [guideView.layer addSublayer:fillLayer];
    
    CGFloat guideImageViewWH = 253;
    UIImageView * guideImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, statusBarH + navBarH + 44 + 93, guideImageViewWH, guideImageViewWH)];
    guideImageView.image = [UIImage imageNamed:@"fb_match_detail_guide"];
    [guideView addSubview:guideImageView];
    
    [YZUserDefaultTool saveInt:1 forKey:@"fb_match_detail_guideHaveShow"];
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

//开始刷新
- (void)refreshViewBeginRefreshing
{
    self.titleBtn.userInteractionEnabled = NO;
    self.siftBtn.enabled = NO;
    [self getCurrentMatchInfo];
    [self.header endRefreshing];
    [self setBottomMidLabelText];
    //情况缓存
    self.matchDetailDic = nil;
}

#pragma mark - tableView的数据源和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.currentStatusArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YZSectionStatus *sectionStatus = self.currentStatusArray[section];
    return (sectionStatus.opened ? sectionStatus.matchInfosArray.count : 0);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YZFTHeaderView *header = [YZFTHeaderView headerViewWithTableView:tableView];
    header.sectionStatus = self.currentStatusArray[section];
    header.delegate = self;
    header.tag = section;
    //三角旋转
    if(!header.sectionStatus.opened)
    {
        header.btn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else
    {
        header.btn.imageView.transform = CGAffineTransformIdentity;
    }
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZFootBallCell *cell = [YZFootBallCell cellWithTableView:tableView];
    cell.delegate = self;
    YZSectionStatus *sectionStatus = self.currentStatusArray[indexPath.section];
    YZMatchInfosStatus *matchInfos = sectionStatus.matchInfosArray[indexPath.row];
    matchInfos.playTypeTag = (int)_selectedPlayTypeBtnTag;
    cell.matchInfos = matchInfos;
    YZFBMatchDetailStatus *matchDetailStatus = self.matchDetailDic[matchInfos.code];
    if (matchDetailStatus && matchInfos.open) {
        cell.matchDetailStatus = matchDetailStatus;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headerViewH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat openHeight = 0;
    YZSectionStatus *sectionStatus = self.currentStatusArray[indexPath.section];
    YZMatchInfosStatus *matchInfos = sectionStatus.matchInfosArray[indexPath.row];
    if (matchInfos.isOpen) {
        openHeight = FbMatchDetailH;
    }
    if(_selectedPlayTypeBtnTag == 0 || _selectedPlayTypeBtnTag == 7)//混合过关cell的高
    {
        return FbCellH0 + openHeight;
    }else
    {
        return FbCellH1 + openHeight;
    }
}
#pragma  mark - YZFootBallCellDelegate的代理方法
- (void)footBallCellOpenBtnDidClick:(UIButton *)btn withCell:(YZFootBallCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YZSectionStatus *sectionStatus = self.currentStatusArray[indexPath.section];
    YZMatchInfosStatus *matchInfos = sectionStatus.matchInfosArray[indexPath.row];
    if (matchInfos.open) {//当前是打开状态
       matchInfos.open = NO;
       [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else
    {
        matchInfos.open = YES;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSString * roundNum = matchInfos.code;//赛事ID
        YZFBMatchDetailStatus *matchDetailStatus = self.matchDetailDic[roundNum];
        if (!matchDetailStatus) {//没有数据时请求数据
            waitingView_loadingData;
            NSDictionary *dict = @{
                                   @"roundNum":roundNum
                                   };
            [[YZHttpTool shareInstance] requestTarget:self PostWithURL:BaseUrlFootball(@"/getMatchStat") params:dict success:^(id json) {
                YZLog(@"getMatchStat - json = %@",json);
                [MBProgressHUD hideHUDForView:self.view];
                if(SUCCESS)
                {
                    YZFBMatchDetailStatus * matchDetailStatus_ = [YZFBMatchDetailStatus objectWithKeyValues:json];
                    [self.matchDetailDic setValue:matchDetailStatus_ forKey:roundNum];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view];
                YZLog(@"getMatchStat - error = %@",error);
            }];
        }
    }
}
- (void)showDetailBtnDidClickWithCell:(YZFootBallCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YZSectionStatus *sectionStatus = self.currentStatusArray[indexPath.section];
    YZMatchInfosStatus *matchInfos = sectionStatus.matchInfosArray[indexPath.row];
    NSString * roundNum = matchInfos.code;//赛事ID
    
    YZFBMatchDetailViewController * matchDetailVC = [[YZFBMatchDetailViewController alloc]init];
    matchDetailVC.roundNum = roundNum;
    [self.navigationController pushViewController:matchDetailVC animated:YES];
}
- (void)reloadBottomMidLabelText
{
    [self setBottomMidLabelText];
}

#pragma  mark - 清空数据
- (void)deleteBtnClick
{
    for(YZSectionStatus *sectionStatus in self.statusArray)
    {
        for(YZMatchInfosStatus *matchInfos in sectionStatus.matchInfosArray)
        {
            if([matchInfos isHaveSelected])
            {
                [matchInfos deleteAllSelBtn];//删除所有选中按钮
            }
        }
    }
    [self.tableView reloadData];
    _selectedMatchCount = 0;
    self.bottomMidLabel.text = [NSString stringWithFormat:@"  至少选%d场比赛", _minMatchCount];
}
#pragma mark - 确认按钮点击
- (void)confirmBtnClick
{
    if(_selectedMatchCount < _minMatchCount)
    {
        [MBProgressHUD showError:[NSString stringWithFormat:@"请至少选择%d场比赛", _minMatchCount]];
    }else if (_selectedMatchCount > 15)
    {
        [MBProgressHUD showError:@"最多只能选择15场比赛"];
    }else//正常提交数据
    {
        YZFbBetViewController *betVc = [[YZFbBetViewController alloc] initWithGameId:self.gameId statusArray:[self getBetStatusArray] selectedPlayType:(int)_selectedPlayTypeBtnTag];
        betVc.title = [NSString stringWithFormat:@"竞彩足球-%@",self.titleBtn.currentTitle];
        [self.navigationController pushViewController:betVc animated:YES];
    }
}
- (NSMutableArray *)getBetStatusArray
{
    NSMutableArray *muArr = [NSMutableArray array];

    for(YZSectionStatus *sectionStatus in self.currentStatusArray)
    {
        for(YZMatchInfosStatus *matchInfos in sectionStatus.matchInfosArray)
        {
            if([matchInfos isHaveSelected])//该cell有被选中的按钮
            {
                YZFbBetCellStatus *status = [[YZFbBetCellStatus alloc] init];
                status.playType = (int)_selectedPlayTypeBtnTag;
                status.code = matchInfos.code;
                //设置VS双方
                NSMutableAttributedString *Vs1LabelMuAttStr = [[NSMutableAttributedString alloc] init];
                NSString *macthNum = [NSString stringWithFormat:@"%@ ",[matchInfos.code substringFromIndex:9]];
                NSArray *detailInfoArray = [matchInfos.detailInfo componentsSeparatedByString:@"|"];
                signed int concedePoints = [matchInfos.concedePoints intValue];
                NSString *name = [self getSubStringOfString:detailInfoArray[0] limitedLength:4];
                NSString *foreStr = [NSString stringWithFormat:@"%@%@",macthNum,name];
                NSString *allStr = foreStr;
                if(matchInfos.playTypeTag != 1)//不是胜平负，就显示绿色的加减数
                {
                    NSString *points;
                    if(concedePoints > 0)
                    {
                        points =[NSString stringWithFormat:@"(+%d)",concedePoints];
                    }else
                    {
                        points =[NSString stringWithFormat:@"(%d)",concedePoints];
                    }
                    allStr = [NSString stringWithFormat:@"%@%@",foreStr,points];
                }
                [Vs1LabelMuAttStr appendAttributedString:[[NSAttributedString alloc] initWithString:allStr]];
                [Vs1LabelMuAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, 3)];
                NSDictionary *Attdict = @{NSForegroundColorAttributeName : [UIColor grayColor],NSFontAttributeName : [UIFont systemFontOfSize:12]};
                [Vs1LabelMuAttStr addAttributes:Attdict range:NSMakeRange(0, 3)];//前面的数字变小变灰
                [Vs1LabelMuAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(97, 180, 59, 1) range:NSMakeRange(foreStr.length, allStr.length-foreStr.length)];
                status.vs1MuAttText = Vs1LabelMuAttStr;//vslabel1的文字
                status.vs2Text = [self getSubStringOfString:detailInfoArray[1] limitedLength:4];//vslabel2的文字
                
                status.matchInfosStatus = matchInfos;//比赛信息
                status.btnSelectedCount = [matchInfos numberSelMatch];
                [muArr addObject:status];
            }
        }
    }
    return muArr;
}
- (NSMutableArray *)getRateWithType:(NSString *)CNType andMatchInfos:(YZMatchInfosStatus *)matchInfos
{
    NSMutableArray * selMatchArray = [NSMutableArray array];
    NSMutableArray * selMatchArr = matchInfos.selMatchArr[0];
    NSArray * array = [NSArray array];
    if ([CNType isEqualToString:@"CN02"]) {
        array = [selMatchArr subarrayWithRange:NSMakeRange(0, 3)];
    }else
    {
        array = [selMatchArr subarrayWithRange:NSMakeRange(3, 3)];
    }
    for (YZFootBallMatchRate * rate in array) {
        if (rate.value != nil && rate.value.length != 0) {
            [selMatchArray addObject:rate];
        }
    }
    return selMatchArray;
}
- (NSMutableArray *)getSelectedOddsInfoArrayWtihOddsInfosArray:(NSMutableArray *)oddsInfosArray
{
    NSMutableArray *muArr = [NSMutableArray array];
    for(YZFootBallMatchRate *rate in oddsInfosArray)
    {
        if(![rate.value isEqualToString:@""])
        {
            [muArr addObject:rate];
        }
    }
    return  muArr;
}
- (NSString *)getSubStringOfString:(NSString *)string limitedLength:(NSInteger)limitedLength
{
    if(string.length <= limitedLength) return string;
    
    return [string substringToIndex:limitedLength];
}
#pragma mark - 设置底部label显示几场比赛
- (void)setBottomMidLabelText
{
    int count = 0;
    for(YZSectionStatus *sectionStatus in self.currentStatusArray)
    {
        for(YZMatchInfosStatus *matchInfos in sectionStatus.matchInfosArray)
        {
            if([matchInfos isHaveSelected]){
                count ++;//cell有被选中的按钮，计数加1
            }
        }
    } 
    _selectedMatchCount = count;
    if(_selectedMatchCount < _minMatchCount)
    {
        self.bottomMidLabel.text = [NSString stringWithFormat:@"  至少选%d场比赛", _minMatchCount];
    }else
    {
        self.bottomMidLabel.text = [NSString stringWithFormat:@"  您选择了%ld场比赛",(long)_selectedMatchCount];
        if(_selectedMatchCount > 15) [MBProgressHUD showError:@"最多只能选择15场比赛"];
    }
}
#pragma mark - 标题按钮点击
- (void)titleBtnClick:(YZTitleButton *)btn
{
    [self.playTypeView show];
}
#pragma mark -  玩法按钮点击
- (void)playTypeDidClickBtn:(UIButton *)btn
{
    _selectedPlayTypeBtnTag = btn.tag;

    if (_selectedPlayTypeBtnTag >= 7) {
        _minMatchCount = 1;
        //设置titlebtn的title
        [self.titleBtn setTitle:[NSString stringWithFormat:@"%@",btn.currentTitle] forState:UIControlStateNormal];
    }else
    {
        _minMatchCount = 2;
        //设置titlebtn的title
        [self.titleBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
    }

    [self.tableView reloadData];

    //清空数据
    [self deleteBtnClick];
}
#pragma  mark - 筛选按钮点击
- (void)siftBtnClick
{
    //筛选view
    if (!self.siftView) {
        YZFBSiftView *siftView = [[YZFBSiftView alloc]initWithFrame:KEY_WINDOW.bounds matchNameArray:self.matchNameArray];
        self.siftView = siftView;
        siftView.delegate = self;
        [KEY_WINDOW addSubview:siftView];
        
    }
    
    [self.siftView show];
}

//筛选
- (void)siftDidClickWithSelectedMatchNames:(NSArray *)selectedMatchNames
{
    int count = 0;
    if(self.currentMatchNames.count > 0 && selectedMatchNames.count == self.currentMatchNames.count)
    {
        for(int i = 0;i < selectedMatchNames.count;i++)
        {
            if([selectedMatchNames[i] isEqualToString:self.currentMatchNames[i]])
            {
                count ++;//判断相同一次，就加1
            }
        }
    }
    if(self.currentMatchNames.count > 0 && count == self.currentMatchNames.count)//计数和当前比赛名称个数一样，说明筛选要求没变,啥都不用做
    {
        self.currentMatchNames = [self.matchNameArray mutableCopy];
    }else
    {
        if(self.matchNameArray.count == selectedMatchNames.count)//全选了，就不筛选，直接赋值statusArray
        {
            self.currentStatusArray = self.statusArray;
            if(selectedMatchNames.count != self.currentMatchNames.count)//全选但当前不是全选，刷新下
            {
                [self.tableView reloadData];//刷新
            }
            return;
        }else//改变筛选要求了
        {
            //对比赛名称进行筛选
            NSMutableArray *muArrTemp = self.currentMatchNames;//暂存
            self.currentMatchNames = [NSMutableArray arrayWithArray:selectedMatchNames];//改变当前比赛名称
            NSArray *tempArr = [self siftMatchName];
            
            int matchCount = 0;
            for(YZSectionStatus *sectionStatus in tempArr)
            {
                matchCount += sectionStatus.matchInfosArray.count;//统计筛选后剩余几场比赛
            }
            if(matchCount < 2)
            {
                [MBProgressHUD showError:@"筛选后可投注比赛不足2场"];
                self.currentMatchNames = muArrTemp;//赋值回去
                return;
            }else
            {
                self.currentStatusArray = tempArr;//大于2场，就赋值当前数据，刷新
            }
            
            [self.tableView reloadData];
        }
    }
}

#pragma  mark - 对比赛名称进行筛选，刷新当前数据数组
- (NSArray *)siftMatchName
{
    NSMutableArray *currentStatusArray = [NSMutableArray array];
    for(YZSectionStatus *sectionStatus in self.statusArray)
    {
        //对cell的数据进行名称筛选
        YZSectionStatus *newSectionStatus = [[YZSectionStatus alloc] init];
        NSMutableArray *matchInfosArray = [NSMutableArray array];
        for(YZMatchInfosStatus *matchInfos in sectionStatus.matchInfosArray)
        {
            if([self.currentMatchNames containsObject:matchInfos.matchName])//如果是当前已选的比赛名称
            {
                [matchInfosArray addObject:matchInfos];
            }
        }
        if(matchInfosArray.count > 0)//section里有cell的数据才放进去
        {
            newSectionStatus.matchInfosArray = [matchInfosArray copy];
            YZMatchInfosStatus *matchInfos = [newSectionStatus.matchInfosArray firstObject];
            NSString *headerTime = [YZDateTool getChineseDateStringFromDateString:[matchInfos.code substringWithRange:NSMakeRange(0, 8)] format:@"yyyyMMdd"];
             newSectionStatus.title = [NSString stringWithFormat:@"%@ %lu场比赛",headerTime,(unsigned long)newSectionStatus.matchInfosArray.count];//section标题
            [currentStatusArray addObject:newSectionStatus];
        }
    }
    return  [currentStatusArray copy];
}

#pragma  mark - 获取到了比赛信息后调用
- (void)getCurrentMatchInfoEnded
{    
    [self setStatusArray:nil];//设置statusArray数据
    self.currentStatusArray = self.statusArray;//设置当前数据源
    self.currentMatchNames = [self.matchNameArray mutableCopy];//设置当前比赛名称
    //有数据按钮才能点击
    if (self.currentStatusArray.count > 0) {
        self.titleBtn.userInteractionEnabled = YES;
        self.siftBtn.enabled = YES;
    }
    [self.tableView reloadData];
    [self.header endRefreshing];
    if(self.currentStatusArray.count > 0)
    {
        [self addGuideView];
    }
}
- (void)setStatusArray:(NSArray *)statusArray
{
    //对数据进行时间分组后的数组，元素是数组，元素数组的元素的时间是同一天
    NSMutableArray *timeSortedStatusArray = [NSMutableArray array];
    //遍历比赛信息，对时间进行分组
    NSMutableSet *matchNameSet = [NSMutableSet set];
    for(int i = 0;i < self.matchInfosStatusArray.count;i++)
    {
        YZMatchInfosStatus *matchInfosStatus = self.matchInfosStatusArray[i];
        NSArray *detailInfoArray = [matchInfosStatus.detailInfo componentsSeparatedByString:@"|"];
        matchInfosStatus.matchName = detailInfoArray[2];
        [matchNameSet addObject:detailInfoArray[2]];//所有的比赛名称
        if(i == 0)//先把第一个放进去
        {
            NSMutableArray *muArr = [NSMutableArray array];
            [muArr addObject:matchInfosStatus];
            [timeSortedStatusArray addObject:muArr];
        }else
        {
            NSMutableArray *muArr = [timeSortedStatusArray lastObject];
            YZMatchInfosStatus *status = [muArr lastObject];
            //对code进行比较，是否同一天
            BOOL isequalDay = [[matchInfosStatus.code substringWithRange:NSMakeRange(0, 8)] isEqualToString:[status.code substringWithRange:NSMakeRange(0, 8)]];
            if(isequalDay)//同一天
            {
                [muArr addObject:matchInfosStatus];
            }else//不是同一天
            {
                //新建一个数组放不同时间的数据，数组放入timeSortedStatusArray
                NSMutableArray *muArr = [NSMutableArray array];
                [muArr addObject:matchInfosStatus];
                [timeSortedStatusArray addObject:muArr];
            }
        }
    }
    self.matchNameArray = [matchNameSet allObjects];//赋值给比赛名称数组
    NSMutableArray *cellStatusArray = [NSMutableArray array];
    for(int i = 0;i < timeSortedStatusArray.count;i++)
    {
        YZSectionStatus *sectionStatus = [[YZSectionStatus alloc] init];
        sectionStatus.matchInfosArray = timeSortedStatusArray[i];//比赛信息
        YZMatchInfosStatus *matchInfos = [sectionStatus.matchInfosArray firstObject];
        NSString *headerTime = [YZDateTool getChineseDateStringFromDateString:[matchInfos.code substringWithRange:NSMakeRange(0, 8)] format:@"yyyyMMdd"];
        sectionStatus.title = [NSString stringWithFormat:@"%@ %lu场比赛",headerTime,(unsigned long)sectionStatus.matchInfosArray.count];//section标题
        [cellStatusArray addObject:sectionStatus];
    }
    _statusArray = cellStatusArray;
}

//headerView的代理方法
- (void)headerViewDidClickWithHeader:(YZFTHeaderView *)header
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:header.tag];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSArray *)currentStatusArray
{
    if(_currentStatusArray == nil)
    {
        _currentStatusArray = [NSMutableArray array];
        _currentStatusArray = self.statusArray;//赋值给当前的数据数组
    }
    return _currentStatusArray;
}

- (NSArray *)matchNameArray
{
    if(_matchNameArray == nil)
    {
        _matchNameArray = [NSArray array];
    }
    return  _matchNameArray;
}

- (NSMutableDictionary *)matchDetailDic
{
    if (!_matchDetailDic) {
        _matchDetailDic = [NSMutableDictionary dictionary];
    }
    return _matchDetailDic;
}

@end
