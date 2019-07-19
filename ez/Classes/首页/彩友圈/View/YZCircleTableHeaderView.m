//
//  YZCircleTableHeaderView.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleTableHeaderView.h"
#import "YZCommunityCircleViewController.h"
#import "YZCircleCommunityCollectionViewCell.h"

NSString * const circleCommunityCollectionViewCellId = @"circleCommunityCollectionViewCellId";

@interface YZCircleTableHeaderView ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic,weak) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation YZCircleTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupChildViews];
        [self getData];
    }
    return self;
}

#pragma mark - 请求数据
- (void)getData
{
    NSDictionary *dict = @{
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getCommunityList") params:dict success:^(id json) {
        YZLog(@"getCommunityList:%@",json);
        if (SUCCESS){
            self.dataArray = json[@"community"];
            [self.collectionView reloadData];
        }
    }failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
    }];
}

#pragma mark - 布局子视图
- (void)setupChildViews
{
    //collectionView
    CGFloat collectionViewH = 100;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(screenWidth / 3, collectionViewH);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0.0;//列间距
    layout.minimumLineSpacing = 0.0;//行间距
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, collectionViewH) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:collectionView];
    
    //注册
    [collectionView registerClass:[YZCircleCommunityCollectionViewCell class] forCellWithReuseIdentifier:circleCommunityCollectionViewCellId];
    
    //公告
    UILabel * noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"最新帖子";
    noticeLabel.frame = CGRectMake(YZMargin, collectionViewH, self.width - 2 *YZMargin, 40);
    noticeLabel.textColor = YZBlackTextColor;
    noticeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [self addSubview:noticeLabel];
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
    
    YZCircleCommunityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:circleCommunityCollectionViewCellId forIndexPath:indexPath];
    cell.dic = self.dataArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    NSDictionary * dic = self.dataArray[indexPath.row];
    YZCommunityCircleViewController * communityCircleVC = [[YZCommunityCircleViewController alloc] init];
    communityCircleVC.communityId = dic[@"id"];
    communityCircleVC.title = dic[@"name"];
    [self.viewController.navigationController pushViewController:communityCircleVC animated:YES];
}

#pragma mark - 初始化
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

@end
