//
//  YZUnionBuyViewController.m
//  ez
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import "YZUnionBuyViewController.h"
#import "YZInitiateUnionBuyViewController.h"
#import "YZTitleButton.h"
#import "YZUnionBuyPlayTypeView.h"
#import "YZUnionBuyCell.h"
#import "YZAttatchedCell.h"
#import "UIBarButtonItem+YZ.h"
#import "YZUnionBuyStatus.h"
#import "YZLoadHtmlFileController.h"
#import "YZLoginViewController.h"
#import "YZNavigationController.h"
#import "YZBetSuccessViewController.h"
#import "YZUnionBuyDetailViewController.h"
#import "YZUnionBuyComfirmPayTool.h"
#import "UIButton+YZ.h"
#import "YZUnionChangeNickNameView.h"
#import "YZValidateTool.h"

@interface YZUnionBuyViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UISearchBarDelegate,YZUnionBuyCellDelegate,YZAttatchedCellDelegate,YZUnionChangeNickNameViewDelegate, YZUnionBuyPlayTypeViewDelegate>

@property (nonatomic, weak) YZUnionBuyPlayTypeView *playTypeView;
@property (nonatomic,strong) UIBarButtonItem *searchNavigationItem;
@property (nonatomic,strong) UIBarButtonItem *guideNavigationItem;
@property (nonatomic, strong) UIBarButtonItem *initiateNavigationItem;
@property (nonatomic, strong) YZTitleButton *titleBtn;//头部按钮
@property (nonatomic, weak) UIButton *selectedTabbarButton;//已选中的上面的tabbar按钮
@property (nonatomic, weak) UIView *lineView;//三个按钮下面移动的lineView
@property (nonatomic, strong) NSMutableArray *topBtns;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) MJRefreshGifHeader *header;
@property (nonatomic, weak) MJRefreshBackGifFooter *footer;
@property (nonatomic,assign) NSInteger pageIndex;
@property (nonatomic, strong) NSArray *unionBuys;//合买数据
@property (nonatomic, strong) NSMutableArray *dataArray;//tableview的数据源
@property (nonatomic, strong) NSArray *menuBtnToGameIds;
@property (nonatomic, copy) NSString *selectedGameId;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, copy) NSString *keyWord;

@end

@implementation YZUnionBuyViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBarItem];
    [self setupChilds];
}
#pragma mark - 设置导航栏按钮
- (void)setupNavBarItem
{
    //搜索按钮
    self.searchNavigationItem = [UIBarButtonItem itemWithIcon:@"unionBuy_search" highIcon:@"unionBuy_search" target:self action:@selector(searchButtonClick)];
    //说明按钮
    self.guideNavigationItem = [UIBarButtonItem itemWithIcon:@"unionBuy_guide" highIcon:@"unionBuy_guide" target:self action:@selector(unionBuyGuideButtonClick)];
    self.navigationItem.leftBarButtonItems = @[self.guideNavigationItem, self.searchNavigationItem];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = YES;
    self.searchBar.tintColor = YZBlueBallColor;
    self.searchBar.placeholder = @"请输入昵称查找";
    
    //标题按钮
    self.titleBtn = [[YZTitleButton alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    [self.titleBtn setTitle:@"全部彩种" forState:UIControlStateNormal];
#if JG
    [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
#elif ZC
    [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
#elif CS
    [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
#elif RR
    [self.titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
#endif
    [self.titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = self.titleBtn;
    
    //发起合买
    self.initiateNavigationItem = [[UIBarButtonItem alloc] initWithTitle:@"发起合买" style:UIBarButtonItemStyleDone target:self action:@selector(initiateUnionBuy)];
    self.navigationItem.rightBarButtonItem = self.initiateNavigationItem;
}

- (void)searchButtonClick
{
    [self.searchBar becomeFirstResponder];
    self.navigationItem.leftBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.titleView = self.searchBar;
}
//说明按钮点击
- (void)unionBuyGuideButtonClick
{
    YZLoadHtmlFileController *htmlVc = [[YZLoadHtmlFileController alloc] initWithFileName:@"unionBuy.html"];
    htmlVc.title = @"合买大厅说明";
    [self.navigationController pushViewController:htmlVc animated:YES];
}
- (void)initiateUnionBuy
{
    YZInitiateUnionBuyViewController *detailVc = [[YZInitiateUnionBuyViewController alloc] init];
    [self.navigationController pushViewController:detailVc animated:YES];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.keyWord = @"";
    self.navigationItem.leftBarButtonItems = @[self.guideNavigationItem, self.searchNavigationItem];
    self.navigationItem.rightBarButtonItem = self.initiateNavigationItem;
    self.navigationItem.titleView = self.titleBtn;
    [self.header beginRefreshing];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.pageIndex = 0;
    SortType aSortType = sortTypeDescending;//默认降序
    if(self.selectedTabbarButton.imageView.transform.d != 1)//图片已经反转
    {
        aSortType = sortTypeAscending;
    }
    //清空数据
    [self.dataArray removeAllObjects];
    NSInteger indexOfTabbarButton = self.selectedTabbarButton.tag;
    self.keyWord = searchBar.text;
    [self getAllUnionBuyStatusWithGameId:self.selectedGameId sortType:aSortType fieldType:indexOfTabbarButton + 1 index:self.pageIndex];
}
#pragma  mark - 初始化子控件
- (void)setupChilds
{
    //玩法
    YZUnionBuyPlayTypeView *playTypeView = [[YZUnionBuyPlayTypeView alloc] initWithFrame:KEY_WINDOW.bounds];
    self.playTypeView = playTypeView;
    playTypeView.delegate = self;
    [KEY_WINDOW addSubview:playTypeView];
    
    //三个标签按钮
    CGFloat topBtnH = 42;
    UIView *tabbarBgView = [[UIView alloc] init];
    tabbarBgView.backgroundColor = [UIColor whiteColor];
    tabbarBgView.frame = CGRectMake(0, 0, screenWidth, topBtnH);
    [self.view addSubview:tabbarBgView];
    
    //三个按钮,1：金额排序、2：进度排序、3：战绩排序
    NSArray *topTitles = @[@"金额排序", @"进度排序", @"战绩排序"];
    CGFloat topBtnW = (screenWidth - 10) / topTitles.count;
    for(NSUInteger i = 0; i < topTitles.count; i++)
    {
        UIButton *topBtn = [[UIButton alloc] init];
        topBtn.tag = i;
        topBtn.frame = CGRectMake(i * (topBtnW + 1), 0, topBtnW, topBtnH - 2);
        [self.topBtns addObject:topBtn];
        [topBtn setTitle:topTitles[i] forState:UIControlStateNormal];
        topBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [topBtn setTitleColor:YZColor(134, 134, 134, 1) forState:UIControlStateNormal];
        [topBtn setTitleColor:YZColor(246, 53, 80, 1) forState:UIControlStateSelected];
        [topBtn setTitleColor:YZColor(246, 53, 80, 1) forState:UIControlStateHighlighted];
        [topBtn setImage:[UIImage imageNamed:@"unionBuy_gray_down"] forState:UIControlStateNormal];
        [topBtn setImage:[UIImage imageNamed:@"unionBuy_red_down"] forState:UIControlStateHighlighted];
        [topBtn setImage:[UIImage imageNamed:@"unionBuy_red_down"] forState:UIControlStateSelected];
        [topBtn setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentRight imgTextDistance:2];
        [topBtn addTarget:self action:@selector(tabbarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [tabbarBgView addSubview:topBtn];
    }
    
    //lineView
    UIView *lineView = [[UIView alloc] init];
    self.lineView = lineView;
    lineView.backgroundColor = YZColor(246, 53, 80, 1);
    lineView.frame = CGRectMake(5, topBtnH - 2, topBtnW - 2 * 5, 2);
    [tabbarBgView addSubview:lineView];
    
    CGFloat tableViewH = screenHeight - statusBarH - navBarH - tabBarH - topBtnH;
    if (self.navigationController.viewControllers.count > 1) {
        tableViewH = screenHeight - statusBarH - navBarH - topBtnH;
    }
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBtnH, screenWidth, tableViewH) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:tableView];
    
    //初始化头部刷新控件
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshViewBeginRefreshing)];
    self.header = header;
    [YZTool setRefreshHeaderData:header];
    tableView.mj_header = header;
    
    //初始化底部刷新控件
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshViewBeginRefreshing)];
    self.footer = footer;
    [YZTool setRefreshFooterData:footer];
    tableView.mj_footer = footer;
    
    //默认选中第一个按钮，和刷新数据
    [self selectedButtonClick:[self.topBtns firstObject]];
}
//头部刷新控件刷新代理
-(void)headerRefreshViewBeginRefreshing
{
    self.pageIndex = 0;
    SortType aSortType = sortTypeDescending;//默认降序
    if(self.selectedTabbarButton.imageView.transform.d != 1)//图片已经反转
    {
        aSortType = sortTypeAscending;
    }

    NSInteger indexOfTabbarButton = self.selectedTabbarButton.tag;
    [self getAllUnionBuyStatusWithGameId:self.selectedGameId sortType:aSortType fieldType:indexOfTabbarButton + 1 index:self.pageIndex];
}

- (void)footerRefreshViewBeginRefreshing
{
    self.pageIndex += 1;
    SortType aSortType = sortTypeDescending;//默认降序
    if(self.selectedTabbarButton.imageView.transform.d != 1)//图片已经反转
    {
        aSortType = sortTypeAscending;
    }
    NSInteger indexOfTabbarButton = self.selectedTabbarButton.tag;
    [self getAllUnionBuyStatusWithGameId:self.selectedGameId sortType:aSortType fieldType:indexOfTabbarButton + 1 index:self.pageIndex];
}
//上面3个按钮点击
- (void)selectedButtonClick:(UIButton *)btn
{
    if(!btn.selected)//未选中
    {
        [self.view endEditing:YES];
        self.selectedTabbarButton.selected = NO;
        btn.selected = YES;
        self.selectedTabbarButton = btn;
        //移动lineView
        [UIView animateWithDuration:animateDuration animations:^{
            self.lineView.centerX = btn.centerX;
        }];
    }else//已经是选中
    {
        if(btn.imageView.transform.d == 1)
        {
            [UIView animateWithDuration:animateDuration animations:^{
                btn.imageView.transform = CGAffineTransformMakeRotation(-M_PI);
            }];
        }else
        {
            [UIView animateWithDuration:animateDuration animations:^{
                btn.imageView.transform = CGAffineTransformIdentity;
            }];
        }
    }
}
- (void)tabbarButtonClick:(UIButton *)btn
{
    [self selectedButtonClick:btn];
    [self.header beginRefreshing];
}

#pragma mark - 头部按钮点击
- (void)titleBtnClick:(UIButton *)sender
{    
    [self.playTypeView show];
}
//标题按钮弹出菜单的玩法按钮
- (void)playTypeDidClick:(UIButton *)btn
{
    [UIView animateWithDuration:animateDuration animations:^{
        self.titleBtn.imageView.transform = CGAffineTransformIdentity;
    }];
    
    if ([btn.currentTitle isEqualToString:@"全部彩种"]) {
        self.selectedGameId = @"";
    }else
    {
        self.selectedGameId = self.menuBtnToGameIds[btn.tag];
    }
    [self.titleBtn setTitle:btn.currentTitle forState:UIControlStateNormal];
    [self.header beginRefreshing];//开始刷新当前tableview
}

#pragma mark - tableView数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZUnionBuyStatusFrame *statusFrame = self.dataArray[indexPath.row];
    if(statusFrame.cellType == KCellTypeAttatchedCell)
    {
        YZAttatchedCell *cell = [YZAttatchedCell cellWithTableView:tableView];
        cell.statusFrame = statusFrame;
        cell.delegate = self;
        return cell;
    }else
    {
        YZUnionBuyCell *cell = [YZUnionBuyCell cellWithTableView:tableView];
        cell.tag = indexPath.row;
        cell.delegate = self;
        cell.statusFrame = statusFrame;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZUnionBuyStatusFrame *statusFrame = self.dataArray[indexPath.row];
    if(statusFrame.cellType == KCellTypeAttatchedCell)
    {
        return attatchedCellH;
    }else
    {
        return statusFrame.cellH;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[YZUnionBuyCell class]])
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        YZUnionBuyStatus *status = [[(YZUnionBuyCell *)cell statusFrame] status];
        YZUnionBuyDetailViewController *detailVc = [[YZUnionBuyDetailViewController alloc] initWithUnionBuyPlanId:status.unionBuyPlanId gameId:status.gameId];
        [self.navigationController pushViewController:detailVc animated:YES];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar endEditing:YES];
}
#pragma  mark - YZUnionBuyCell的代理方法，点击了AccessoryBtn按钮
- (void)unionBuyCellAccessoryBtnDidClick:(UIButton *)btn cell:(YZUnionBuyCell *)cell
{
    if(btn.isSelected)
    {
        //先看看是否已有attatchedCell
        NSInteger indexOfAttatchedCell =  [self indexOfAttatchedCellDataSource];
        if(indexOfAttatchedCell > 0)//说明有了
        {
            //删除已经有的attatchedCell
            [self.dataArray removeObjectAtIndex:indexOfAttatchedCell];
            NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:indexOfAttatchedCell inSection:0];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[oldIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            //将按钮选择状态改为normal
            YZUnionBuyCell *lastAttatchedOfCell = (YZUnionBuyCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexOfAttatchedCell - 1 inSection:0]];
            lastAttatchedOfCell.accessoryBtn.selected = NO;
            YZUnionBuyStatusFrame *statusFrame = self.dataArray[indexOfAttatchedCell - 1];
            statusFrame.status.accessoryBtnSelected = NO;
        }
        
        //数据源添加一条数据
        YZUnionBuyStatusFrame *newStatusFrame = [[YZUnionBuyStatusFrame alloc] init];
        YZUnionBuyStatusFrame *lastStatusFrame = cell.statusFrame;
        newStatusFrame.status = lastStatusFrame.status;
        newStatusFrame.cellType = KCellTypeAttatchedCell;
        NSInteger indexOfStatus = [self.dataArray indexOfObject:cell.statusFrame];
        [self.dataArray insertObject:newStatusFrame atIndex:indexOfStatus + 1];
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        indexPath = [NSIndexPath indexPathForRow:(indexOfStatus + 1) inSection:0];
        //添加一个attatchedCell
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }else
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        indexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:0];
        //删除一个attatchedCell
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}
//查找AttatchedCell的index，如果没有返回0，有返回index
- (NSInteger)indexOfAttatchedCellDataSource
{
    NSMutableArray *currentTableViewDataSource = self.dataArray;
    for(NSInteger i = 0; i < currentTableViewDataSource.count; i++)
    {
        YZUnionBuyStatusFrame *statusFrame = currentTableViewDataSource[i];
        if(statusFrame.cellType == KCellTypeAttatchedCell)
        {
            return i;
        }
    }
    return 0;
}
#pragma mark - YZAttatchedCellDelegate的代理方法，点击了马上付款按钮
- (void)attatchedCellDidClickQuickPayBtnWithCell:(YZAttatchedCell *)cell
{
    [self.view endEditing:YES];
    if([cell.moneyTd.text integerValue] == 0)
    {
        [MBProgressHUD showError:@"投注金额不能小于1"];
        return;
    }
    
    if(!UserId)//没登录
    {
        YZLoginViewController *loginVc = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    
    if ([YZTool needChangeNickName]) {
        YZUnionChangeNickNameView * changeNickNameView = [[YZUnionChangeNickNameView alloc] initWithFrame:KEY_WINDOW.bounds];
        changeNickNameView.delegate = self;
        [KEY_WINDOW addSubview:changeNickNameView];
        return;
    }

    YZStartUnionbuyModel *param = [[YZStartUnionbuyModel alloc] init];
    param.userName = cell.statusFrame.status.userName;
    param.unionBuyPlanId = cell.statusFrame.status.unionBuyPlanId;
    param.planId = cell.statusFrame.status.planId;
    param.money = @([cell.moneyTd.text integerValue] * 100);
    param.singleMoney = cell.statusFrame.status.singleMoney;
    param.gameId = cell.statusFrame.status.gameId;
    param.termId = cell.statusFrame.status.issue;
    param.title = cell.statusFrame.status.title;
    param.desc = cell.statusFrame.status.desc;
    param.commission = cell.statusFrame.status.commission;
    param.deposit = cell.statusFrame.status.deposit;
    param.settings = cell.statusFrame.status.settings;
    
    [[YZUnionBuyComfirmPayTool shareInstance] participateUnionBuyOfAllWithParam:param sourceController:self];
}
- (void)confirmBtnDidClick:(NSString *)nickName
{
    if (YZStringIsEmpty(nickName)) return;
    YZUser *user = [YZUserDefaultTool user];
    NSDictionary *dict = @{
                           @"cmd":@(8126),
                           @"userId":UserId,
                           @"userName":user.userName,
                           @"nickName":nickName
                           };
    waitingView
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            [self loadUserInfo];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"修改昵称失败"];
    }];
}
- (void)loadUserInfo
{
    if (!UserId) return;
    NSDictionary *dict = @{
                           @"cmd":@(8006),
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        YZLog(@"%@",json);
        if (SUCCESS) {
            //存储用户信息
            YZUser *user = [YZUser objectWithKeyValues:json];
            [YZUserDefaultTool saveUser:user];
            [MBProgressHUD showSuccess:@"修改成功"];
        }
    } failure:^(NSError *error) {
        YZLog(@"账户error");
    }];
}

#pragma mark - 获取合买数据
- (void)getAllUnionBuyStatusWithGameId:(NSString *)gameId sortType:(SortType)sortType fieldType:(FieldType)fieldType index:(NSInteger)index
{
    [[YZHttpTool shareInstance] getUnionBuyStatusWithUserName:self.keyWord gameId:gameId sortType:sortType fieldType:fieldType index:index getSuccess:^(NSArray *unionBuys) {
        if ([self.header isRefreshing]) {
            [self.dataArray removeAllObjects];
        }
        if(unionBuys.count > 0)//有数据
        {
            self.unionBuys = [YZUnionBuyStatus objectArrayWithKeyValuesArray:unionBuys];
            [self refreshStatusFrames];
            [self.tableView reloadData];
            [self.footer endRefreshing];
        }else
        {
            [self.tableView reloadData];
            [self.footer endRefreshingWithNoMoreData];
        }
        [self.header endRefreshing];
    } getFailure:^{
        if ([self.header isRefreshing]) {
            [self.dataArray removeAllObjects];
        }
        [self.header endRefreshing];
        [self.footer endRefreshing];
    }];
}
- (void)refreshStatusFrames
{
    for(NSUInteger i = 0; i < _unionBuys.count; i++)
    {
        YZUnionBuyStatusFrame *statusFrame = [[YZUnionBuyStatusFrame alloc] init];
        statusFrame.status = self.unionBuys[i];
        [self.dataArray addObject:statusFrame];
    }
}

#pragma mark - 初始化
- (NSMutableArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSMutableArray array];
    }
    return  _dataArray;
}

- (NSMutableArray *)topBtns
{
    if(_topBtns == nil)
    {
        _topBtns = [NSMutableArray array];
    }
    return  _topBtns;
}

-(NSArray *)menuBtnToGameIds
{
    if(_menuBtnToGameIds == nil)
    {
        _menuBtnToGameIds = @[@"F01", @"T01", @"F02", @"T03", @"T02", @"T53", @"T04", @"F03", @"T54"];
    }
    return  _menuBtnToGameIds;
}

@end

