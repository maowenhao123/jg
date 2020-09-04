//
//  YZBuyLotteryCollectionView.m
//  ez
//
//  Created by apple on 16/10/9.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define bannerCellId @"BuyLotteryCollectionViewBannerCellId"
#define functionCellId @"HomePageFunctionCollectionViewCellId"
#define recommendLotteryCellId @"RecommendLotteryCollectionViewCellId"
#define cycleScrollCellId @"BuyLotteryCollectionViewCycleScrollCellId"
#define gameInfoCellId @"BuyLotteryCollectionViewGameInfoCellId"
#define gameInfoCellId_zc @"ZCBuyLotteryCollectionViewGameInfoCellId"
#define InformationHeaderId @"InformationHeaderId"
#define InformationCellId @"InformationCellId"

#define bannerH 180
#define cycleScrollViewH 29
#define cellH 90
#define cellH_zc 109
#define informationCell 110
#import "YZBuyLotteryCollectionView.h"
#import "YZLoginViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZGameIdViewController.h"
#import "YZInformationDetailViewController.h"
#import "YZInitiateUnionBuyViewController.h"
#import "YZBannerCollectionViewCell.h"
#import "YZBuyLotteryCollectionReusableView.h"
#import "YZHomePageFunctionCollectionViewCell.h"
#import "YZRecommendLotteryCollectionViewCell.h"
#import "YZCycleScrollViewCollectionViewCell.h"
#import "YZBuyLotteryCollectionViewCell.h"
#import "YZZCBuyLotteryCollectionViewCell.h"
#import "YZInformationCollectionViewCell.h"

@interface YZBuyLotteryCollectionView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, assign) int pageIndex;
@property (nonatomic,strong) NSArray *functions;
@property (nonatomic, strong) YZQuickStakeGameModel *quickStakeGameModel;
@property (nonatomic, strong) YZUnionBuyStatus *unionBuyStatus;
@property (nonatomic, strong) NSArray *cycleDatas;
@property (nonatomic, strong) NSArray *gameInfos;
@property (nonatomic, strong) NSMutableArray *informations;
@property (nonatomic, weak) MJRefreshBackGifFooter *footer;

@end

@implementation YZBuyLotteryCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        [self registerClass];
        [MBProgressHUD showMessage:@"获取数据，客官请稍后..." toView:self];
        [self getFunctionData];
        [self getNoticeData];
        [self getGameInfoDataWith:nil];
        [self getInformationDataWith:nil];
        [self getQuickStakeData];
        [self getAllUnionBuyStatus];
        
        //初始化底部刷新控件
        MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshViewBeginRefreshing)];
        [YZTool setRefreshFooterData:footer];
        self.footer = footer;
        self.mj_footer = footer;
    }
    return self;
}

#pragma mark - 注册
- (void)registerClass
{
    [self registerClass:[YZBuyLotteryCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:InformationHeaderId];
    [self registerClass:[YZBannerCollectionViewCell class] forCellWithReuseIdentifier:bannerCellId];
    [self registerClass:[YZHomePageFunctionCollectionViewCell class] forCellWithReuseIdentifier:functionCellId];
    [self registerClass:[YZRecommendLotteryCollectionViewCell class] forCellWithReuseIdentifier:recommendLotteryCellId];
    [self registerClass:[YZCycleScrollViewCollectionViewCell class] forCellWithReuseIdentifier:cycleScrollCellId];
    [self registerClass:[YZBuyLotteryCollectionViewCell class] forCellWithReuseIdentifier:gameInfoCellId];
    [self registerClass:[YZZCBuyLotteryCollectionViewCell class] forCellWithReuseIdentifier:gameInfoCellId_zc];
    [self registerClass:[YZInformationCollectionViewCell class] forCellWithReuseIdentifier:InformationCellId];
}
#pragma mark - 获取数据
- (void)headerRefreshViewBeginRefreshingWith:(MJRefreshGifHeader *)header
{
    self.pageIndex = 0;
    //轮播图
    YZBannerCollectionViewCell * bannerCollectionViewCell = (YZBannerCollectionViewCell * )[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [bannerCollectionViewCell getDataWith:header];
    [self getFunctionData];
    [self getQuickStakeData];
    [self getNoticeData];
    [self getGameInfoDataWith:header];
    [self getInformationDataWith:header];
}

- (void)footerRefreshViewBeginRefreshing
{
    self.pageIndex ++;
    [self getInformationDataWith:nil];
}

- (void)getFunctionData
{
    NSDictionary *dict = @{
                           @"version": @"0.0.5"
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlSalesManager(@"/getShortcutModules") params:dict success:^(id json) {
        YZLog(@"getShortcutModules:%@",json);
        if (SUCCESS) {
            NSArray *functions = [YZHomePageFunctionModel objectArrayWithKeyValuesArray:json[@"shortcutModules"]];
            NSMutableArray *functions_mu = [NSMutableArray array];
            for (YZHomePageFunctionModel * functionModel in functions) {
                if (![functionModel.type isEqualToString:@"COMMUNITY"] && ![functionModel.type isEqualToString:@"UNIONPLAN"]) {
                    [functions_mu addObject:functionModel];
                }
            }
            self.functions = [NSArray arrayWithArray:functions];
            [UIView performWithoutAnimation:^{
                [self reloadSections:[NSIndexSet indexSetWithIndex:1]];
            }];
        }
    } failure:^(NSError *error)
    {
        YZLog(@"error = %@",error);
    }];
}

//获取推荐彩票
- (void)getQuickStakeData
{
    NSDictionary *dict = @{
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlSalesManager(@"/getQuickStakeGames") params:dict success:^(id json) {
        YZLog(@"getQuickStakeGames:%@",json);
        if (SUCCESS) {
            NSArray * dataArray = [YZQuickStakeGameModel objectArrayWithKeyValuesArray:json[@"games"]];
            self.quickStakeGameModel = dataArray.firstObject;
            [UIView performWithoutAnimation:^{
                [self reloadSections:[NSIndexSet indexSetWithIndex:2]];
            }];
        }
    } failure:^(NSError *error)
    {
        YZLog(@"error = %@",error);
    }];
}

//获取合买数据
- (void)getAllUnionBuyStatus
{
    [[YZHttpTool shareInstance] getUnionBuyStatusWithUserName:@"" gameId:@"" sortType:sortTypeDescending fieldType:fieldTypeOrderByProgress index:0 getSuccess:^(NSArray *unionBuys) {
        NSArray * unionBuyStatuss = [YZUnionBuyStatus objectArrayWithKeyValuesArray:unionBuys];
        self.unionBuyStatus = unionBuyStatuss.firstObject;
        [UIView performWithoutAnimation:^{
            [self reloadSections:[NSIndexSet indexSetWithIndex:2]];
        }];
    } getFailure:^{
        YZLog(@"error");
    }];
}

//获取滚动新闻
- (void)getNoticeData
{
    NSDictionary *dict = @{
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlNotice(@"/getNoticeList") params:dict success:^(id json) {
        YZLog(@"getNoticeList:%@",json);
        if (SUCCESS){
            self.cycleDatas = [YZNoticeStatus objectArrayWithKeyValuesArray:json[@"notices"]];
            [UIView performWithoutAnimation:^{
                [self reloadSections:[NSIndexSet indexSetWithIndex:3]];
            }];
        }
    }failure:^(NSError *error)
    {
        YZLog(@"error = %@",error);
    }];
}

//获取彩种信息数据
- (void)getGameInfoDataWith:(MJRefreshGifHeader *)header
{
    NSDictionary *dict = @{
                           @"version":@"0.0.8",
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlSalesManager(@"/getGameInfoList") params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self];
        [header endRefreshing];
        YZLog(@"gameInfo:%@",json);
        if (SUCCESS){
            self.gameInfos = [YZBuyLotteryCellStatus objectArrayWithKeyValuesArray:json[@"gameInfoList"]];
            [UIView performWithoutAnimation:^{
                [self reloadSections:[NSIndexSet indexSetWithIndex:4]];
            }];
        }else
        {
            self.gameInfos = [self getDefaultGameInfos];
            [UIView performWithoutAnimation:^{
                [self reloadSections:[NSIndexSet indexSetWithIndex:4]];
            }];
        }
    }failure:^(NSError *error)
    {
         [MBProgressHUD hideHUDForView:self];
         [header endRefreshing];
         self.gameInfos = [self getDefaultGameInfos];
         [UIView performWithoutAnimation:^{
            [self reloadSections:[NSIndexSet indexSetWithIndex:4]];
         }];
         YZLog(@"error = %@",error);
    }];
}

//获取资讯
- (void)getInformationDataWith:(MJRefreshGifHeader *)header
{
    NSDictionary *dict = @{
                           @"pageIndex":@(self.pageIndex),
                           @"pageSize":@(10)
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getAppHomePageInformationList") params:dict success:^(id json) {
        YZLog(@"getAppHomePageInformationList:%@",json);
        if (SUCCESS){
            if (self.pageIndex == 0) {
                [self.informations removeAllObjects];
            }
            NSArray * newInformations = [YZInformationModel objectArrayWithKeyValuesArray:json[@"appInformations"]];
            [self.informations addObjectsFromArray:newInformations];
            if (newInformations.count == 0) {
                [self.footer endRefreshingWithNoMoreData];
            }else
            {
                [self.footer endRefreshing];
            }
            [UIView performWithoutAnimation:^{
                [self reloadSections:[NSIndexSet indexSetWithIndex:5]];
            }];
        }else
        {
            [self.footer endRefreshing];
        }
    }failure:^(NSError *error)
    {
         [self.footer endRefreshing];
         YZLog(@"error = %@",error);
    }];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 5 && !YZArrayIsEmpty(self.informations)) {
        return CGSizeMake(screenWidth, 10 + 40);
    }
    return CGSizeZero;
}
//配置item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return CGSizeMake(self.width, bannerH);
    }else if (indexPath.section == 1)
    {
        if (self.functions.count > 5) {
            return CGSizeMake(self.width, 95);
        }else if (self.functions.count <= 5 && self.functions.count > 0)
        {
            return CGSizeMake(self.width, 84);
        }else
        {
            return CGSizeMake(self.width, 1);
        }
    }else if (indexPath.section == 2)
    {
        if (!YZObjectIsEmpty(self.quickStakeGameModel) || !YZObjectIsEmpty(self.unionBuyStatus)) {
            return CGSizeMake(self.width, 115);
        }else
        {
            return CGSizeMake(self.width, 1);
        }
    }else if (indexPath.section == 3)
    {
        if (self.cycleDatas.count == 0) {//没有数据时
            return CGSizeMake(self.width, 10);
        }else
        {
            return CGSizeMake(self.width, cycleScrollViewH);
        }
    }else if (indexPath.section == 4)
    {
#if JG
        return CGSizeMake(self.width / 2, cellH);
#elif ZC
        return CGSizeMake(self.width / 3, cellH_zc);
#endif
    }else if (indexPath.section == 5){
        return CGSizeMake(self.width, informationCell);
    }
    return CGSizeMake(self.width, 0);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    view.layer.zPosition = 0.0;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 6;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 4) {
        return self.gameInfos.count;
    }else if (section == 5){
        return self.informations.count;
    }
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        YZBannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bannerCellId forIndexPath:indexPath];
        return cell;
    }else if (indexPath.section == 1)
    {
        YZHomePageFunctionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:functionCellId forIndexPath:indexPath];
        cell.functions = self.functions;
        return cell;
    }else if (indexPath.section == 2)
    {
        YZRecommendLotteryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:recommendLotteryCellId forIndexPath:indexPath];
        if (!YZObjectIsEmpty(self.quickStakeGameModel)) {
            cell.gameModel = self.quickStakeGameModel;
        }
        if (!YZObjectIsEmpty(self.unionBuyStatus)) {
            cell.unionBuyStatus = self.unionBuyStatus;
        }
        return cell;
    }else if (indexPath.section == 3)
    {
        YZCycleScrollViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cycleScrollCellId forIndexPath:indexPath];
        cell.cycleDatas = self.cycleDatas;
        return cell;
    }else if (indexPath.section == 4)
    {
#if JG
        YZBuyLotteryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gameInfoCellId forIndexPath:indexPath];
        cell.status = self.gameInfos[indexPath.row];
        if (indexPath.row % 2 == 0) {
            cell.line2.hidden = NO;
        }else
        {
            cell.line2.hidden = YES;
        }
        return cell;
#elif ZC
        YZZCBuyLotteryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:gameInfoCellId_zc forIndexPath:indexPath];
        cell.status = self.gameInfos[indexPath.row];
        cell.index = indexPath.row;
        return cell;
#endif
    }else if (indexPath.section == 5)
    {
        YZInformationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:InformationCellId forIndexPath:indexPath];
        cell.informationModel = self.informations[indexPath.row];
        return cell;
    }
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 5 && !YZArrayIsEmpty(self.informations)) {
        YZBuyLotteryCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:InformationHeaderId forIndexPath:indexPath];
        return headerView;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 4)
    {
        YZBuyLotteryCellStatus * status = self.gameInfos[indexPath.row];
        if ([status.gameId isEqualToString:@"UNIONPLAN"]) {
            YZInitiateUnionBuyViewController *initiateUnionBuyVC = [[YZInitiateUnionBuyViewController alloc] init];
            [self.viewController.navigationController pushViewController:initiateUnionBuyVC animated:YES];
        }else
        {
            YZGameIdViewController *destVc = (YZGameIdViewController *)[[[YZTool gameDestClassDict][status.gameId] alloc] initWithGameId:status.gameId];
            [self.viewController.navigationController pushViewController:destVc animated:YES];
        }
    }else if (indexPath.section == 5)
    {
        //阅读量+1
        YZInformationModel *informationModel = self.informations[indexPath.row];
        NSInteger browseTimes = [informationModel.browseTimes integerValue] + 1;
        informationModel.browseTimes = @(browseTimes);
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        
        YZInformationDetailViewController *informationDetailVC = [[YZInformationDetailViewController alloc] init];
        informationDetailVC.informationModel = informationModel;
        [self.viewController.navigationController pushViewController:informationDetailVC animated:YES];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4 || indexPath.section == 5)
    {
        return YES;
    }
    return NO;
}

#if JG
#elif ZC
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{    
    if (_buyLotteryDelegate && [_buyLotteryDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_buyLotteryDelegate scrollViewDidScroll:self];
    }
}
#endif

#pragma mark - 初始化
- (NSArray *)functions
{
    if (_functions == nil) {
        _functions = [NSArray array];
    }
    return _functions;
}

- (NSArray *)cycleDatas
{
    if (_cycleDatas == nil) {
        _cycleDatas = [NSArray array];
    }
    return _cycleDatas;
}

- (NSArray *)gameInfos
{
    if (_gameInfos == nil) {
        _gameInfos = [NSArray array];
    }
    return _gameInfos;
}

- (NSMutableArray *)informations
{
    if (_informations == nil) {
        _informations = [NSMutableArray array];
    }
    return _informations;
}

#pragma mark - 默认数据
- (NSArray *)getDefaultGameInfos
{
    NSArray * gameInfos = [NSArray array];
    NSError*error;
    //获取文件路径
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"default_lottery"ofType:nil];
    //根据文件路径读取数据
    NSData *jdata = [[NSData alloc]initWithContentsOfFile:filePath];
    //格式化成json数据
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jdata options:kNilOptions error:&error];
    gameInfos = [YZBuyLotteryCellStatus objectArrayWithKeyValuesArray:jsonObject[@"pages"]];
    return gameInfos;
}

@end
