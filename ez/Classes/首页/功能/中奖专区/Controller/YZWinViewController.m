//
//  YZWinViewController.m
//  ezTests
//
//  Created by dahe on 2020/5/18.
//  Copyright © 2020 9ge. All rights reserved.
//

#import "YZWinViewController.h"
#import "YZWinListViewController.h"
#import "SGPagingView.h"

@interface YZWinViewController ()<SGPageTitleViewDelegate, SGPageContentCollectionViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;

@end

@implementation YZWinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"中奖专区";
    [self setupPageView];
}

#pragma mark - 布局子视图
- (void)setupPageView
{
    SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
    configure.showBottomSeparator = NO;
    configure.titleColor = YZBlackTextColor;
    configure.titleFont = [UIFont systemFontOfSize:15];
    configure.titleSelectedFont = [UIFont systemFontOfSize:16];
    configure.titleSelectedColor = YZBaseColor;
    configure.indicatorColor = YZBaseColor;
    configure.titleGradientEffect = YES;
    configure.showIndicator = YES;
    NSArray *titleArr = @[@"中奖实况", @"中奖排名", @"关注度", @"大奖播报"];
    
    self.pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, screenWidth, 44) delegate:self titleNames:titleArr configure:configure];
    self.pageTitleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pageTitleView];
    
    NSMutableArray *childArr = [NSMutableArray array];
    for (int i = 0; i < titleArr.count; i++) {
        YZWinListViewController *winListVC = [[YZWinListViewController alloc] init];
        winListVC.index = i;
        [childArr addObject:winListVC];
    }
    self.pageContentCollectionView = [[SGPageContentCollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageTitleView.frame), screenWidth, screenHeight - statusBarH - navBarH - CGRectGetMaxY(self.pageTitleView.frame)) parentVC:self childVCs:childArr];
    self.pageContentCollectionView.delegatePageContentCollectionView = self;
    [self.view addSubview:self.pageContentCollectionView];
}

#pragma mark - SGPageTitleViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex
{
    [self.pageContentCollectionView setPageContentCollectionViewCurrentIndex:selectedIndex];
}

#pragma mark - SGPageContentCollectionViewDelegate
- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

@end
