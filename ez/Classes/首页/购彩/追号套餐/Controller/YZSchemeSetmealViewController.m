//
//  YZSchemeSetmealViewController.m
//  ez
//
//  Created by 毛文豪 on 2018/7/11.
//  Copyright © 2018年 9ge. All rights reserved.
//
#define topBtnH 42

#import "YZSchemeSetmealViewController.h"
#import "YZLoadHtmlFileController.h"
#import "YZLoginViewController.h"
#import "YZSetmealRecordViewController.h"
#import "YZSetmealBetViewController.h"
#import "YZSchemeSetmealTableViewCell.h"

@interface YZSchemeSetmealViewController ()<UITableViewDelegate, UITableViewDataSource, YZSchemeSetmealTableViewCellDelegate>

@property (nonatomic, weak) UIImageView *bannerView;
@property (nonatomic, weak) UIButton *selectedBtn;//被选中的顶部按钮
@property (nonatomic, weak) UIView *topBtnLine;//顶部按钮的下划线
@property (nonatomic, strong) NSMutableArray *topBtns;//顶部按钮数组
@property (nonatomic, weak) UIScrollView *scrollView;//滑动的scrollview
@property (nonatomic, strong) NSMutableArray *tableViews;//要显示的view数组
@property (nonatomic, strong) NSMutableArray *headerViews;
@property (nonatomic, assign) int currentIndex;//显示第几个view
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) NSString *bannerUrl;

@end

@implementation YZSchemeSetmealViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"追号套餐";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"套餐记录" style:UIBarButtonItemStylePlain target:self action:@selector(schemeSetmealRecordBarDidClick)];
    [self setupBannerView];
    waitingView_loadingData
    [self getChasePlanPromotionData];
}

- (void)schemeSetmealRecordBarDidClick
{
    if(!UserId)//没登录
    {
        YZLoginViewController *loginVc = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }
    YZSetmealRecordViewController * recordVC = [[YZSetmealRecordViewController alloc] init];
    [self.navigationController pushViewController:recordVC animated:YES];
}

#pragma mark - 请求数据
- (void)getChasePlanPromotionData
{
    NSDictionary *dict = @{
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlShare(@"/getChasePlanPromotion") params:dict success:^(id json) {
        YZLog(@"getChasePlanPromotion:%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            NSString *picUrl = json[@"picUrl"];
            self.bannerUrl = json[@"url"];
            if (YZStringIsEmpty(picUrl)) {
                self.bannerView.height = 0;
            }else
            {
                self.bannerView.height = 80;
                [self.bannerView sd_setImageWithURL:[NSURL URLWithString:json[@"picUrl"]] placeholderImage:[UIImage imageNamed:@"unhit_return_money_desc"]];
            }
            waitingView_loadingData;
            [self getChasePlanData];
        }
    } failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
         [MBProgressHUD hideHUDForView:self.view];
        self.bannerView.height = 0;
        waitingView_loadingData;
        [self getChasePlanData];
    }];
}

- (void)getChasePlanData
{
    NSDictionary *dict = @{
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlSalesManager(@"/getChasePlanList") params:dict success:^(id json) {
        YZLog(@"getChasePlanList:%@",json);
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            NSArray * dataArray = [YZSchemeSetmealModel objectArrayWithKeyValuesArray:json[@"chasePlanList"]];
            for (YZSchemeSetmealModel * schemeSetmealModel in dataArray) {
                NSInteger index = [dataArray indexOfObject:schemeSetmealModel];
                NSArray * infos = [YZSchemeSetmealInfoModel objectArrayWithKeyValuesArray:json[@"chasePlanList"][index][@"infos"]];
                schemeSetmealModel.infos = infos;
            }
            self.dataArray = dataArray;
            [self setupTableViews];
        }
    } failure:^(NSError *error)
     {
         YZLog(@"error = %@",error);
         [MBProgressHUD hideHUDForView:self.view];
     }];
}

#pragma mark - 初始化视图
- (void)setupBannerView
{
    UIImageView *bannerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 80)];
    self.bannerView = bannerView;
    bannerView.image = [UIImage imageNamed:@"unhit_return_money_desc"];
    [self.view addSubview:bannerView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bannerViewDidClick)];
    bannerView.userInteractionEnabled = YES;
    [bannerView addGestureRecognizer:tap];
}

- (void)bannerViewDidClick
{
    if (YZStringIsEmpty(self.bannerUrl)) {
        return;
    }
    YZLoadHtmlFileController * htmlVC = [[YZLoadHtmlFileController alloc] initWithWeb:self.bannerUrl];
    [self.navigationController pushViewController:htmlVC animated:YES];
}

- (void)setupTableViews
{
    CGFloat bannerViewH = self.bannerView.height;
    //底部的view
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, bannerViewH, screenWidth, topBtnH)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    //顶部按钮
    NSMutableArray *btnTitles = [NSMutableArray array];
    for (YZSchemeSetmealModel * schemeSetmealModel in self.dataArray) {
        NSString * btnTitle = [NSString stringWithFormat:@"%@套餐", [YZTool gameIdNameDict][schemeSetmealModel.type.gameId]];
        [btnTitles addObject:btnTitle];
    }
    CGFloat topBtnW = (screenWidth - 10) / self.dataArray.count;
    for(int i = 0;i < self.self.dataArray.count;i++)
    {
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topBtn.tag = i;
        [topBtn setTitle:btnTitles[i] forState:UIControlStateNormal];
        topBtn.frame = CGRectMake(5 + i*topBtnW, 0, topBtnW, topBtnH - 2);
        topBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        topBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [topBtn setTitleColor:YZColor(134, 134, 134, 1) forState:UIControlStateNormal];
        [topBtn setTitleColor:YZBaseColor forState:UIControlStateSelected];
        [topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [backView addSubview:topBtn];
        [self.topBtns addObject:topBtn];
    }
    //底部红线
    UIView * topBtnLine = [[UIView alloc]init];
    self.topBtnLine = topBtnLine;
    topBtnLine.frame = CGRectMake(5, topBtnH - 2, topBtnW, 2);
    topBtnLine.backgroundColor = YZBaseColor;
    [backView addSubview:topBtnLine];
    
    CGFloat scrollViewH = screenHeight - statusBarH - navBarH - topBtnH - bannerViewH;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.frame = CGRectMake(0, bannerViewH + topBtnH, screenWidth, scrollViewH);
    [self.view addSubview:scrollView];
    
    //设置属性
    scrollView.contentSize = CGSizeMake(screenWidth * self.dataArray.count, scrollViewH);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    
    //添加view
    for(int i = 0; i < btnTitles.count; i++)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i * screenWidth, 0, screenWidth, scrollViewH)];
        tableView.backgroundColor = YZBackgroundColor;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
        tableView.showsVerticalScrollIndicator = NO;
        [scrollView addSubview:tableView];
        [self.tableViews addObject:tableView];
    }
}

#pragma mark - 视图滑动
- (void)topBtnClick:(UIButton *)btn
{
    //滚动到指定页码
    [self.scrollView setContentOffset:CGPointMake(btn.tag * screenWidth, 0) animated:YES];
    [self changeSelectedBtn:btn];
}
- (void)changeSelectedBtn:(UIButton *)btn
{
    self.selectedBtn.selected = NO;
    self.selectedBtn.userInteractionEnabled = YES;
    btn.userInteractionEnabled = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    //红线动画
    [UIView animateWithDuration:animateDuration
                     animations:^{
                         self.topBtnLine.center = CGPointMake(btn.center.x, self.topBtnLine.center.y);
                     }];
    //赋值
    self.currentIndex = (int)btn.tag;
    //当前页面切换，子类实现
    [self changeCurrentIndex:self.currentIndex];
}
#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(![scrollView isKindOfClass:[UITableView class]])
    {
        // 1.取出水平方向上滚动的距离
        CGFloat offsetX = scrollView.contentOffset.x;
        // 2.求出页码
        double pageDouble = offsetX / scrollView.frame.size.width;
        int pageInt = (int)(pageDouble + 0.5);
        //3.切换按钮
        [self changeSelectedBtn:self.topBtns[pageInt]];
    }
}
- (void)changeCurrentIndex:(int)currentIndex
{
    UITableView *tableView = self.tableViews[currentIndex];
    [tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    YZSchemeSetmealModel * schemeSetmealModel = self.dataArray[self.currentIndex];
    NSArray * infos = schemeSetmealModel.infos;
    return infos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSchemeSetmealTableViewCell * cell = [YZSchemeSetmealTableViewCell cellWithTableView:tableView];
    YZSchemeSetmealModel * schemeSetmealModel = self.dataArray[self.currentIndex];
    NSArray * infos = schemeSetmealModel.infos;
    cell.schemeSetmealInfoModel = infos[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 9 + 100;
}

- (void)schemeSetmealTableViewCellBuyDidClickCell:(YZSchemeSetmealTableViewCell *)cell
{
    UITableView *tableView = self.tableViews[self.currentIndex];
    NSIndexPath * indexPath = [tableView indexPathForCell:cell];
    
    YZSetmealBetViewController * betVC = [[YZSetmealBetViewController alloc] init];
    YZSchemeSetmealModel * schemeSetmealModel = self.dataArray[self.currentIndex];
    NSArray * infos = schemeSetmealModel.infos;
    YZSchemeSetmealInfoModel * schemeSetmealInfoModel = infos[indexPath.row];
    betVC.schemeSetmealId = schemeSetmealInfoModel.id;
    betVC.gameId = schemeSetmealInfoModel.gameId;
    [self.navigationController pushViewController:betVC animated:YES];
}

#pragma mark - 初始化
- (NSArray *)dataArray
{
    if(_dataArray == nil)
    {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)topBtns
{
    if (_topBtns == nil) {
        _topBtns = [NSMutableArray array];
    }
    return _topBtns;
}

- (NSMutableArray *)tableViews
{
    if(_tableViews == nil)
    {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (NSMutableArray *)headerViews
{
    if(_headerViews == nil)
    {
        _headerViews = [NSMutableArray array];
    }
    return _headerViews;
}

@end
