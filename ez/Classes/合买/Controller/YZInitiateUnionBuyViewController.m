//
//  YIinitiateUnionBuyViewController.m
//  ez
//
//  Created by 毛文豪 on 2019/6/5.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZInitiateUnionBuyViewController.h"
#import "YZGameIdViewController.h"
#import "YZZCBuyLotteryCollectionViewCell.h"

@interface YZInitiateUnionBuyViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UICollectionView *collectionView;

@end

NSString * const InitiateUnionBuyCellId = @"InitiateUnionBuyCellId";

@implementation YZInitiateUnionBuyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择玩法";
    [self setupChilds];
    [self initData];
}

#pragma mark - 加载数据
- (void)initData
{
    NSArray * gameNameIds = @[@"F01", @"T01", @"F02", @"T03", @"T02", @"T53", @"T04", @"F03", @"T54"];
    for (NSString * gameId in gameNameIds) {
        YZBuyLotteryCellStatus * status = [[YZBuyLotteryCellStatus alloc] init];
        status.gameId = gameId;
        status.gameName = [YZTool gameIdNameDict][gameId];
        
        [self.dataArray addObject:status];
    }
    [self.collectionView reloadData];
}

#pragma mark - 布局视图
- (void)setupChilds
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0.0;//列间距
    layout.minimumLineSpacing = 0.0;//行间距
    layout.itemSize = CGSizeMake(screenWidth / 3, 109);
    
    CGFloat collectionViewY = 0;
    CGFloat collectionViewH = screenHeight - statusBarH - navBarH;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, collectionViewY, screenWidth, collectionViewH) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:collectionView];
    
    //注册
    [collectionView registerClass:[YZZCBuyLotteryCollectionViewCell class] forCellWithReuseIdentifier:InitiateUnionBuyCellId];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    YZZCBuyLotteryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:InitiateUnionBuyCellId forIndexPath:indexPath];
    cell.status = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    YZBuyLotteryCellStatus * status = self.dataArray[indexPath.row];
    YZGameIdViewController *destVc = (YZGameIdViewController *)[[[YZTool gameDestClassDict][status.gameId] alloc] initWithGameId:status.gameId];
    [self.navigationController pushViewController:destVc animated:YES];
}

#pragma mark - 初始化
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
