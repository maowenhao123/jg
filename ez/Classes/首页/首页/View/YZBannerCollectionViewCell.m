//
//  YZBannerCollectionViewCell.m
//  ez
//
//  Created by apple on 16/12/29.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZBannerCollectionViewCell.h"
#import "YZLoadHtmlFileController.h"
#import "SDCycleScrollView.h"

@interface YZBannerCollectionViewCell ()<SDCycleScrollViewDelegate>

@property (nonatomic, weak) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *respPromotionList;

@end

@implementation YZBannerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupChilds];
        [self getDataWith:nil];
    }
    return self;
}
#pragma mark - 布局视图
- (void)setupChilds
{
    // 设置图片
    NSString *imageName = @"banner_default_6P.jpg";
    if (iPhone6)
    {
        imageName = @"banner_default_6.jpg";
    }else if (iPhone6P)
    {
        imageName = @"banner_default_6P.jpg";
    }
    UIImage * placeholderImage = [UIImage imageNamed:imageName];
    //轮播图
    SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.width, 180) delegate:self placeholderImage:placeholderImage];
    self.cycleScrollView = cycleScrollView;
    cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView.pageDotColor = [UIColor colorWithWhite:1 alpha:0.44];
    // 设置图片
    NSString *defaultImageName = @"banner_ks_6P.jpg";
    if (iPhone6)
    {
        defaultImageName = @"banner_ks_6.jpg";
    }else if (iPhone6P)
    {
        defaultImageName = @"banner_ks_6P.jpg";
    }
    UIImage * defaultImage = [UIImage imageNamed:defaultImageName];
    self.cycleScrollView.localizationImageNamesGroup = @[defaultImage];
    [self addSubview:cycleScrollView];
}
#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSMutableArray * imagesURLStrings = [NSMutableArray array];
    for (YZRespPromotionStatus *status in self.respPromotionList) {
        [imagesURLStrings addObject:status.picAddr];
    }
    if (imagesURLStrings.count > 0) {//有数据时才可以选择
        YZRespPromotionStatus *status = self.respPromotionList[index];
        NSString * showAddr = status.showAddr;
//        showAddr = @"http://i.ez1898.com/zc_down/guidepage.html";
        if (YZStringIsEmpty(showAddr)) return;//没有链接时，不跳转
        YZLoadHtmlFileController * webVC = [[YZLoadHtmlFileController alloc]initWithWeb:showAddr];
        webVC.title = status.title;
        [self.viewController.navigationController pushViewController:webVC animated:YES];
    }
}
#pragma mark - 获取数据
- (void)getDataWith:(MJRefreshGifHeader *)header
{
    //获得当前版本号
    NSDictionary *dict = @{
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlAdvert(@"") params:dict success:^(id json) {
        [header endRefreshing];
        YZLog(@"getPromotionList:%@",json);
        if (SUCCESS){
            self.respPromotionList = [YZRespPromotionStatus objectArrayWithKeyValuesArray:json[@"respAdvertList"]];
            [self setData];
        }else
        {
            self.respPromotionList = nil;
            [self setData];
        }
    }failure:^(NSError *error)
    {
         [header endRefreshing];
         self.respPromotionList = nil;
         [self setData];
         YZLog(@"error = %@",error);
    }];
}
- (void)setData
{
    // 设置图片
    NSString *imageName = @"banner_ks_6P.jpg";
    if (iPhone6)
    {
        imageName = @"banner_ks_6.jpg";
    }else if (iPhone6P)
    {
        imageName = @"banner_ks_6P.jpg";
    }
    UIImage * defaultImage = [UIImage imageNamed:imageName];
    
    NSMutableArray * imagesURLStrings = [NSMutableArray array];//图片
    for (YZRespPromotionStatus *status in self.respPromotionList) {
        [imagesURLStrings addObject:status.picAddr];
    }
    if (YZArrayIsEmpty(imagesURLStrings)) {
        self.cycleScrollView.localizationImageNamesGroup = @[defaultImage];
    }else
    {
        self.cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    }
}
#pragma mark - 初始化
- (NSArray *)respPromotionList
{
    if (_respPromotionList == nil) {
        _respPromotionList = [NSArray array];
    }
    return _respPromotionList;
}
@end
