//
//  YZBasketBallViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/5/22.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZBasketBallViewController.h"
#import "YZBasketBallBetViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZTitleButton.h"
#import "YZBasketBallHeaderView.h"
#import "YZBasketBallTableViewCell.h"
#import "YZBasketBallTableViewCell1.h"
#import "YZBasketBallTableViewCell2.h"
#import "YZDateTool.h"

@interface YZBasketBallViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate, YZBasketBallHeaderViewDelegate, YZBasketBallTableViewCellDelegate, YZBasketBallTableViewCell1Delegate, YZBasketBallTableViewCell2Delegate>
{
    BOOL _openTitleMenu;//是否打开title菜单
    NSArray *_playTypeBtnTitles;//玩法按钮的title数组
    NSInteger _selectedPlayTypeBtnTag;//选中的玩法的tag
    NSInteger _selectedMatchCount;//已选比赛场次
    int _minMatchCount;//当前玩法最少选择的比赛场数
    BOOL _openMenu;
}
@property (nonatomic, weak) UIView *loadFailBgView;
@property (nonatomic, weak) YZTitleButton *titleBtn;
@property (nonatomic, weak) UIView *menuBackView;
@property (nonatomic, weak) UIView *menuView;
@property (nonatomic, weak) UIView *playTypeBackView;//title菜单的背景view
@property (nonatomic, weak) UIView *playTypeView;//选择玩法视图
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) MJRefreshGifHeader *header;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) UILabel *bottomMidLabel;
@property (nonatomic, strong) NSArray *matchInfosStatusArray;//比赛信息模型数组
@property (nonatomic, strong) NSArray *statusArray;//数据数组，里面放YZFtCellStatus

@end

@implementation YZBasketBallViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setBottomMidLabelText];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _playTypeBtnTitles = @[@"胜负", @"大小分", @"让分胜负", @"胜分差", @"混合过关", @"胜负", @"大小分", @"让分胜负", @"胜分差", @"混合过关"];
    _selectedPlayTypeBtnTag = 4;
    _minMatchCount = 2;
    [self setupSonChilds];
    [self getCurrentMatchInfo];
}

#pragma mark - 请求数据
- (void)getCurrentMatchInfo
{
    NSArray *playTypeCode = @[@"01", @"02", @"03", @"04", @"05"];
    NSDictionary *dict = @{
                             @"cmd":@(8028),
                             @"gameId":@"T52",
                             @"oddsCode":@[@"CN"],
                             @"playTypeCode":playTypeCode,
                             };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        YZLog(@"getCurrentMatchInfo - json = %@",json);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (SUCCESS) {
            NSArray *matchInfosStatusArray = json[@"matchInfos"];
            if (matchInfosStatusArray.count > 0) {
                self.matchInfosStatusArray = [YZMatchInfosStatus objectArrayWithKeyValuesArray:json[@"matchInfos"]];//转模型数组
                self.titleBtn.userInteractionEnabled = YES;
                [self setData];
                [self.tableView reloadData];
            }else
            {
                self.matchInfosStatusArray = [NSArray array];
            }
            if(self.matchInfosStatusArray.count > 0)
            {
                [self removeLoadFailView];
            }else
            {
                [self addLoadFailView:@"暂时没有销售期次信息"];
            }
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        YZLog(@"getCurrentMatchInfo - error = %@",error);
        if(!self.loadFailBgView && !self.matchInfosStatusArray.count)
        {
            [self addLoadFailView:@"亲~~~网络不给力..."];
        }
    }];
}

- (void)setData
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
    self.statusArray = cellStatusArray;
}

#pragma mark - 错误视图
- (void)addLoadFailView:(NSString *)title
{
    UIView *loadFailBgView = [[UIView alloc] init];
    self.loadFailBgView = loadFailBgView;
    loadFailBgView.bounds = CGRectMake(0, 0, self.tableView.width, self.tableView.height / 2);
    loadFailBgView.center = self.tableView.center;
    [self.tableView addSubview:loadFailBgView];
    //图片
    UIImage *loadFailImage = [UIImage imageNamed:@"loadFailImage"];
    UIImageView *loadFailImageView = [[UIImageView alloc] initWithImage:loadFailImage];
    CGFloat loadFailImageViewW = loadFailImage.size.width;
    CGFloat loadFailImageViewH = loadFailImage.size.height;
    loadFailImageView.bounds = CGRectMake(0, 0, loadFailImageViewW, loadFailImageViewH);
    loadFailImageView.centerX = loadFailBgView.centerX;
    [loadFailBgView addSubview:loadFailImageView];
    
    //加载失败文字
    UILabel *loadFailLabel = [[UILabel alloc] init];
    loadFailLabel.textColor = [UIColor darkGrayColor];
    loadFailLabel.font = [UIFont systemFontOfSize:YZGetFontSize(38)];
    loadFailLabel.text = title;//@"亲~~~网络不给力...";
    loadFailLabel.textAlignment = NSTextAlignmentCenter;
    CGSize loadFailLabelSize = [loadFailLabel.text sizeWithLabelFont:loadFailLabel.font];
    loadFailLabel.frame = CGRectMake(0, CGRectGetMaxY(loadFailImageView.frame) + 30, loadFailBgView.width, loadFailLabelSize.height);
    [loadFailBgView addSubview:loadFailLabel];
}

- (void)removeLoadFailView
{
    if(self.loadFailBgView)
    {
        [self.loadFailBgView removeFromSuperview];
        self.loadFailBgView = nil;
    }
}

#pragma mark - 添加子视图
- (void)setupSonChilds
{
    //titlebutton
    YZTitleButton *titleBtn = [[YZTitleButton alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    titleBtn.userInteractionEnabled = NO;
    self.titleBtn = titleBtn;
#if JG
    [titleBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
#elif ZC
    [titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
#elif CS
    [titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
#elif RR
    [titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
#endif
    [titleBtn setTitle:@"混合过关" forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
    
    CGFloat bottomViewH = 49;
    //tableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - bottomViewH - statusBarH - navBarH - [YZTool getSafeAreaBottom])];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:tableView];
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshViewBeginRefreshing)];
    [YZTool setRefreshHeaderData:header];
    self.header = header;
    tableView.mj_header = header;
    
    //底栏
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tableView.frame), screenWidth, bottomViewH)];
    self.bottomView = bottomView;
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    //删除按钮
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat deleteBtnWH = 20;
    CGFloat deleteBtnY = (bottomViewH - deleteBtnWH) / 2;
    deleteBtn.frame = CGRectMake(YZMargin, deleteBtnY, deleteBtnWH, deleteBtnWH);
    [deleteBtn setImage:[UIImage imageNamed:@"buyLottery_deleteBtn_flat"] forState:UIControlStateNormal];
    [deleteBtn setImage:[UIImage imageNamed:@"buyLottery_deleteBtn_pressed_flat"] forState:UIControlStateHighlighted];
    [bottomView addSubview:deleteBtn];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];

    //分割线
    UIView * deleteBtnLineView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxY(deleteBtn.frame) + YZMargin, 12, 1, bottomViewH - 2 * 12)];
    deleteBtnLineView.backgroundColor = YZWhiteLineColor;
    [bottomView addSubview:deleteBtnLineView];
    
    CGFloat buttonH = 30;
    CGFloat buttonW = 75;
    CGFloat buttonY = (bottomViewH - buttonH) / 2;
    //确认按钮
    YZBottomButton *confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(screenWidth - buttonW - 15, buttonY, buttonW, buttonH);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [bottomView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //底部中间的label，显示选择多少场比赛
    UILabel *bottomMidLabel = [[UILabel alloc] init];
    self.bottomMidLabel = bottomMidLabel;
    bottomMidLabel.textColor = YZBlackTextColor;
    bottomMidLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    CGFloat bottomMidLabelX = CGRectGetMaxX(deleteBtn.frame) + 22;
    CGFloat bottomMidLabelW = confirmBtn.x - bottomMidLabelX - 10;
    bottomMidLabel.frame = CGRectMake(bottomMidLabelX, 0, bottomMidLabelW, 25);
    bottomMidLabel.center = CGPointMake(bottomMidLabel.center.x, bottomViewH/2);
    [bottomView addSubview:bottomMidLabel];
}

//开始刷新
- (void)refreshViewBeginRefreshing
{
    self.titleBtn.userInteractionEnabled = NO;
    [self getCurrentMatchInfo];
    [self.header endRefreshing];
    [self setBottomMidLabelText];
}

#pragma mark - 标题按钮点击
- (void)titleBtnClick:(YZTitleButton *)btn
{
    [UIView animateWithDuration:animateDuration animations:^{
        if(!_openTitleMenu)
        {
            btn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
        }else
        {
            btn.imageView.transform = CGAffineTransformIdentity;
        }
    }];
    
    _openTitleMenu = !_openTitleMenu;
    
    //底部背景遮盖
    UIView *playTypeBackView = [[UIView alloc] init];
    self.playTypeBackView = playTypeBackView;
    playTypeBackView.backgroundColor = YZColor(0, 0, 0, 0.4);
    playTypeBackView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePlayTypeBackView)];
    tap.delegate = self;
    [playTypeBackView addGestureRecognizer:tap];
    [self.tabBarController.view addSubview:playTypeBackView];
    
    //玩法view
    UIView *playTypeView = [[UIView alloc] init];
    self.playTypeView = playTypeView;
    playTypeView.backgroundColor = [UIColor whiteColor];
    playTypeView.layer.masksToBounds = YES;
    playTypeView.layer.cornerRadius = 8;
    [playTypeBackView addSubview:playTypeView];
    CGFloat playTypeViewW = screenWidth - 20;
    
    int maxColums = 3;//每行几个
    CGFloat btnH = 40;
    int padding = 8;
    int btnCount = (int)_playTypeBtnTitles.count;
    int guoguanBtnCount = 5;
    UIButton *lastBtn;
    UILabel *lastLabel;
    for(int i = 0;i < btnCount;i++)
    {
        if (i == 0 || i == guoguanBtnCount) {
            UILabel * titleLabel = [[UILabel alloc]init];
            titleLabel.frame = CGRectMake(0, CGRectGetMaxY(lastBtn.frame) + 2 * padding, playTypeViewW, btnH);
            titleLabel.backgroundColor = YZColor(240, 240, 240, 1);
            if (i == 0) {
                titleLabel.text = @"过关";
            }else
            {
                titleLabel.text = @"单关";
            }
            titleLabel.textColor = YZBlackTextColor;
            titleLabel.font = [UIFont systemFontOfSize:16.0f];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [playTypeView addSubview:titleLabel];
            lastLabel = titleLabel;
        }
        
        //玩法按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setTitle:_playTypeBtnTitles[i] forState:UIControlStateNormal];
        
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
        CGFloat btnW = (playTypeViewW - 10) / maxColums;
        CGFloat btnX;
        CGFloat btnY;
        if (i < guoguanBtnCount) {
            btnX = 5 + (i % maxColums) * btnW;
            btnY = CGRectGetMaxY(lastLabel.frame) + 2 * padding + (i / maxColums) * (btnH + padding);
        }else
        {
            btnX = 5 + ((i - guoguanBtnCount) % maxColums) * btnW;
            btnY = CGRectGetMaxY(lastLabel.frame) + 2 * padding + ((i - guoguanBtnCount)/ maxColums) * (btnH + padding);
        }
        
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        lastBtn = btn;
        [playTypeView addSubview:btn];
        [btn addTarget:self action:@selector(playTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        if(_selectedPlayTypeBtnTag == i)//有就选择相应地按钮
        {
            btn.selected = YES;
        }
    }
    
    CGFloat playTypeViewH = CGRectGetMaxY(lastBtn.frame) + 2 * padding;
    playTypeView.bounds = CGRectMake(0, 0, playTypeViewW, playTypeViewH);
    playTypeView.center = playTypeBackView.center;
    
    playTypeView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        playTypeView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)removePlayTypeBackView
{
    [UIView animateWithDuration:animateDuration animations:^{
        self.titleBtn.imageView.transform = CGAffineTransformIdentity;
    }];
    _openTitleMenu = !_openTitleMenu;
    [self.playTypeBackView removeFromSuperview];
}

- (void)playTypeBtn:(UIButton *)btn
{
    if(btn.tag == _selectedPlayTypeBtnTag)
    {
        [self removePlayTypeBackView];
        return;//一样就不动
    }
    _selectedPlayTypeBtnTag = btn.tag;
    
    if (_selectedPlayTypeBtnTag >= 5) {
        _minMatchCount = 1;
    }else
    {
        _minMatchCount = 2;
    }
    //设置titlebtn的title
    if (_selectedPlayTypeBtnTag > 4) {
        [self.titleBtn setTitle:[NSString stringWithFormat:@"%@(单关)", btn.currentTitle] forState:UIControlStateNormal];
    }else
    {
        [self.titleBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
    }
    [self removePlayTypeBackView];
    
    [self.tableView reloadData];

    //清空数据
    [self deleteBtnClick];
}

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
    self.bottomMidLabel.text = [NSString stringWithFormat:@"至少选%d场比赛", _minMatchCount];
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
        YZBasketBallBetViewController *betVc = [[YZBasketBallBetViewController alloc] initWithStatusArray:[self getBetStatusArray] selectedPlayType:(int)_selectedPlayTypeBtnTag];
        [self.navigationController pushViewController:betVc animated:YES];
    }
}

- (NSMutableArray *)getBetStatusArray
{
    NSMutableArray *muArr = [NSMutableArray array];
    for(YZSectionStatus *sectionStatus in self.statusArray)
    {
        for(YZMatchInfosStatus *matchInfosModel in sectionStatus.matchInfosArray)
        {
            if([matchInfosModel isHaveSelected])//该cell有被选中的按钮
            {
                [muArr addObject:matchInfosModel];
            }
        }
    }
    return muArr;
}

#pragma mark - tableView的数据源和代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.statusArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YZSectionStatus *sectionStatus = self.statusArray[section];
    return (sectionStatus.opened ? sectionStatus.matchInfosArray.count : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedPlayTypeBtnTag == 4 || _selectedPlayTypeBtnTag == 9) {
        YZBasketBallTableViewCell *cell = [YZBasketBallTableViewCell cellWithTableView:tableView];
        YZSectionStatus *sectionStatus = self.statusArray[indexPath.section];
        YZMatchInfosStatus *matchInfosModel = sectionStatus.matchInfosArray[indexPath.row];
        matchInfosModel.playTypeTag = (int)_selectedPlayTypeBtnTag;
        cell.matchInfosModel = matchInfosModel;
        cell.delegate = self;
        return cell;
    }else if (_selectedPlayTypeBtnTag == 3 || _selectedPlayTypeBtnTag == 8)
    {
        YZBasketBallTableViewCell2 *cell = [YZBasketBallTableViewCell2 cellWithTableView:tableView];
        YZSectionStatus *sectionStatus = self.statusArray[indexPath.section];
        YZMatchInfosStatus *matchInfosModel = sectionStatus.matchInfosArray[indexPath.row];
        matchInfosModel.playTypeTag = (int)_selectedPlayTypeBtnTag;
        cell.matchInfosModel = matchInfosModel;
        cell.delegate = self;
        return cell;
    }else
    {
        YZBasketBallTableViewCell1 *cell = [YZBasketBallTableViewCell1 cellWithTableView:tableView];
        YZSectionStatus *sectionStatus = self.statusArray[indexPath.section];
        YZMatchInfosStatus *matchInfosModel = sectionStatus.matchInfosArray[indexPath.row];
        matchInfosModel.playTypeTag = (int)_selectedPlayTypeBtnTag;
        cell.matchInfosModel = matchInfosModel;
        cell.delegate = self;
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    YZBasketBallHeaderView *header = [YZBasketBallHeaderView headerViewWithTableView:tableView];
    header.delegate = self;
    header.tag = section;
    header.sectionModel = self.statusArray[section];
    //三角旋转
    if(!header.sectionModel.opened)
    {
        header.btn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else
    {
        header.btn.imageView.transform = CGAffineTransformIdentity;
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_selectedPlayTypeBtnTag == 4 || _selectedPlayTypeBtnTag == 9) {
        return 119;
    }else if (_selectedPlayTypeBtnTag == 3 || _selectedPlayTypeBtnTag == 8)
    {
        return 99;
    }
    return 89;
}

//headerView的代理方法
- (void)headerViewDidClickWithHeader:(YZBasketBallHeaderView *)header
{
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:header.tag];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadBottomMidLabelText
{
    [self setBottomMidLabelText];
}

#pragma mark - 设置底部label显示几场比赛
- (void)setBottomMidLabelText
{
    int count = 0;
    for(YZSectionStatus *sectionStatus in self.statusArray)
    {
        for(YZMatchInfosStatus *matchInfos in sectionStatus.matchInfosArray)
        {
            if([matchInfos isHaveSelected]){
                count ++;//cell有被选中的按钮，计数加1
            }
        }
    }
    _selectedMatchCount = count;
    if (_selectedMatchCount == 0) {
        self.bottomMidLabel.text = [NSString stringWithFormat:@"至少选%d场比赛", _minMatchCount];
    }
    else if(_selectedMatchCount < _minMatchCount)
    {
        self.bottomMidLabel.text = [NSString stringWithFormat:@"已选%ld场，还差%ld场", _selectedMatchCount, _minMatchCount - _selectedMatchCount];
    }else
    {
        self.bottomMidLabel.text = [NSString stringWithFormat:@"已选%ld场",(long)_selectedMatchCount];
        if(_selectedMatchCount > 15) [MBProgressHUD showError:@"最多只能选择15场比赛"];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.playTypeView) {
            CGPoint pos = [touch locationInView:self.playTypeView.superview];
            if (CGRectContainsPoint(self.playTypeView.frame, pos)) {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - 初始化
- (NSArray *)matchInfosStatusArray
{
    if(_matchInfosStatusArray == nil)
    {
        _matchInfosStatusArray = [NSArray array];
    }
    return  _matchInfosStatusArray;
}

- (NSArray *)statusArray
{
    if (!_statusArray) {
        _statusArray = [NSArray array];
    }
    return _statusArray;
}

@end
