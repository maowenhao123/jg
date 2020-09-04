//
//  YZPlsViewController.m
//  ez
//
//  Created by apple on 14-10-19.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZPlsViewController.h"
#import "YZBallBtn.h"
#import "YZBetStatus.h"
#import "YZTitleButton.h"
#import "YZCommitTool.h"

@interface YZPlsViewController ()<UITableViewDelegate,UITableViewDataSource,YZSelectBallCellDelegate,YZBallBtnDelegate>
{
    BOOL _openTitleMenu;//是否打开菜单
}
@property (nonatomic, strong) NSMutableArray *zusanTableViews;//组三tableViews
@property (nonatomic, strong) NSArray *tableView1RedBallsArray;//第一个tableView的红球数组
@property (nonatomic, strong) NSMutableArray *statusArray1;//第一个tableview的数据
@property (nonatomic, strong) NSMutableArray *statusArray2;//第二个tableview的数据
@property (nonatomic, strong) NSMutableArray *statusArray3;//第三个tableview的数据
@property (nonatomic, strong) NSMutableArray *statusArrayZuxuan;//组选tableview的数据
@property (nonatomic, strong) NSMutableArray *statusArrayZusan1;//组三单式tableview的数据
@property (nonatomic, strong) NSMutableArray *statusArrayZusan2;//组三复式tableview的数据
@property (nonatomic, strong) NSMutableArray *statusArrayZuliu;//组六tableview的数据

@property (nonatomic, strong) NSMutableArray *selBaiBalls;//已选百位
@property (nonatomic, strong) NSMutableArray *selShiBalls;//已选十位
@property (nonatomic, strong) NSMutableArray *selGeBalls;//已选个位
@property (nonatomic, strong) NSMutableArray *selNumberArray;//已选号码的数组
@property (nonatomic, strong) NSMutableArray *selHezhiBalls;//已选和值球号码数组
@property (nonatomic, strong) NSMutableArray *selZuheBalls;//已选组合球号码数组

@property (nonatomic, strong) NSMutableArray *selZuxuanBalls;//已选直选三的球
@property (nonatomic, strong) NSMutableArray *selSanBalls;//已选直选三的球
@property (nonatomic, strong) NSMutableArray *selLiuBalls;//已选直选六的球

@property (nonatomic, weak) UIView *playTypeBackView;//选择玩法的背景View

@property (nonatomic, strong) NSArray *hezhiBallComposeCount;//和值注数
@property (nonatomic, strong) NSArray *zuheBallComposeCount;//组合注数
@property (nonatomic, strong) NSArray *zuxuanBallComposeCount;//组选注数
@property (nonatomic, strong) NSArray *zusanBallComposeCount;//组三注数
@property (nonatomic, strong) NSArray *zuliuBallComposeCount;//组六注数

@property (nonatomic, copy) NSString *playTypeCode;//游戏玩法BetTypeCode
@property (nonatomic, weak) UIButton *titleBtn;//头部按钮
@property (nonatomic, weak) UIScrollView *scrollView3;//组三view
@property (nonatomic, weak) UITableView *tableViewZuhe;//组合的tableview
@property (nonatomic, weak) UITableView *tableViewZuxuan;//组选的tableview
@property (nonatomic, weak) UITableView *tableView31;//组选三的单式
@property (nonatomic, weak) UITableView *tableView32;//组选三的复式
@property (nonatomic, weak) UITableView *currentZusanTableView;//当前选中组三的tableview
@property (nonatomic, weak) UITableView *tableView6;//组选六的

@property (nonatomic, weak) UIView *backView2;//复式按钮的底部view
@property (nonatomic, weak) UIView *backView3;//组三按钮的底部view
@property (nonatomic, weak) UIView *topBtnLine3;

@property (nonatomic, weak) UIButton *fushiBtn;//复式投注按钮
@property (nonatomic, weak) UIButton *zuheBtn;//组合按钮
@property (nonatomic, weak) UIButton *leftZusanBtn;//组三单式
@property (nonatomic, weak) UIButton *rightZusanBtn;//组三复式
@property (nonatomic, weak) UIButton *selectedZusanBtn;//组三被选中的btn

@property (nonatomic, weak) YZBallBtn *selectedChongball;
@property (nonatomic, weak) YZBallBtn *selectedDanball;
@end

typedef enum{
    KTableViewZuxuansanDanTag = 31,
    KTableViewZuxuansanFuTag = 32,
    KTableViewZuxuanTag = 4,
}tableviewTag;

@implementation YZPlsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //初始化值
    _playTypeCode = @"01";
    for(int i = 0;i < self.tableViews.count;i++)
    {
        UITableView *tableView = self.tableViews[i];
        tableView.delegate = self;
        tableView.dataSource = self;
    }
    
    //设置左右按钮的文字
    [self.leftBtn setTitle:@"普通" forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"和值" forState:UIControlStateNormal];
    
    //添加一个组合的按钮和tableview
    int topBtnCount = 3;
    CGFloat topBtnW = ((screenWidth - (topBtnCount + 1) * 5) / topBtnCount);
    self.topBtnLine.width = topBtnW;
    for(int i = 0;i < topBtnCount;i++)
    {
        CGFloat topBtnX = 5 + (topBtnW + 5) * i;
        if(i == 0)
        {
            self.leftBtn.frame = CGRectMake(topBtnX, 0, topBtnW, 30);
        }else if (i == 1)
        {
            self.rightBtn.frame = CGRectMake(topBtnX, 0, topBtnW, 30);
        }else if(i == 2)
        {
            UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [topBtn setTitle:@"组合" forState:UIControlStateNormal];
            self.zuheBtn = topBtn;
            topBtn.tag = i;
            topBtn.frame = CGRectMake(5 + (topBtnW + 5) * i, 0, topBtnW, 30);
            topBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            topBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
            [topBtn setTitleColor:YZColor(134, 134, 134, 1) forState:UIControlStateNormal];
            [topBtn setTitleColor:YZColor(246, 53, 80, 1) forState:UIControlStateSelected];
            [self.backView addSubview:topBtn];
            [self.topBtns addObject:topBtn];
            [topBtn addTarget:self action:@selector(zuheBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat tableViewH = self.scrollView.frame.size.height;
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, tableViewH) style:UITableViewStylePlain];
            tableView.delaysContentTouches = NO;
            tableView.backgroundColor = YZBackgroundColor;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.tag = i;
            tableView.delegate = self;
            tableView.dataSource = self;
            self.tableViewZuhe = tableView;
            [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
            [self.tableViews addObject:tableView];
            self.scrollView.contentSize = CGSizeMake(screenWidth * 3, tableViewH);
            [self.scrollView addSubview:tableView];
        }
    }

    YZTitleButton *titleBtn = [[YZTitleButton alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    self.titleBtn = titleBtn;
    self.navigationItem.titleView = titleBtn;
    [titleBtn setTitle:@"直选" forState:UIControlStateNormal];
#if JG
    [titleBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
#elif ZC
    [titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
#endif
    [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupBtn];//复式投注的按钮
    [self setupZusanBtn];//组三投注按钮
    
    //组选和值和组六的tableview
    for(int i = 1;i < 3;i++)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backView.frame), screenWidth,self.scrollView.frame.size.height) style:UITableViewStylePlain];
        tableView.backgroundColor = YZBackgroundColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
        if(i == 1)
        {
            self.tableView6 = tableView;
            tableView.tag = 6;
        }else if (i == 2)
        {
            tableView.tag = KTableViewZuxuanTag;
            self.tableViewZuxuan = tableView;
        }
        [self.view insertSubview:tableView belowSubview:self.scrollView];
    }
    //组三
    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delaysContentTouches = NO;
    self.scrollView3 = scrollView;
    scrollView.delegate = self;
    CGFloat scrollViewH = screenHeight - statusBarH - navBarH - self.bottomView.height - 36 - endTimeLabelH - [YZTool getSafeAreaBottom];
    scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), screenWidth,self.scrollView.frame.size.height);
    [self.view addSubview:scrollView];
    //设置属性
    scrollView.contentSize = CGSizeMake(screenWidth * 2, scrollViewH);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    delegate:
    //添加2个tableview
    for(int i = 0;i < 2;i++)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, scrollViewH) style:UITableViewStylePlain];
        tableView.backgroundColor = YZBackgroundColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
        if(i == 0)
        {
            self.tableView31 =tableView;
            self.currentZusanTableView = tableView;
            tableView.tag = KTableViewZuxuansanDanTag;
        }else
        {
            self.tableView32 = tableView;
            tableView.tag = KTableViewZuxuansanFuTag;
        }
        [self.zusanTableViews addObject:tableView];
        [scrollView addSubview:tableView];
    }
    [self.view insertSubview:self.scrollView3 belowSubview:self.scrollView];
    
}
#pragma mark - 顶部按钮
- (void)setupBtn
{
    //复式投注按钮
    //底部的view
    UIView *backView2 = [[UIView alloc] initWithFrame:self.backView.frame];
    self.backView2 = backView2;
    backView2.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:backView2 belowSubview:self.backView];
    
    UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fushiBtn = topBtn;
    topBtn.selected = YES;
    topBtn.userInteractionEnabled = NO;
    topBtn.frame = CGRectMake(5, 0, screenWidth - 10, 36);
    topBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    topBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [topBtn setTitleColor:YZColor(134, 134, 134, 1) forState:UIControlStateNormal];
    [topBtn setTitleColor:YZBaseColor forState:UIControlStateSelected];
    [backView2 addSubview:topBtn];
    
    //底部红线
    UIView * topBtnLine = [[UIView alloc]init];
    topBtnLine.frame = CGRectMake(5, 36 - 2, screenWidth - 10, 2);
    topBtnLine.backgroundColor = YZBaseColor;
    [backView2 addSubview:topBtnLine];
}
- (void)setupZusanBtn{
    //复式投注按钮
    //底部的view
    UIView *backView3 = [[UIView alloc] initWithFrame:self.backView.frame];
    self.backView3 = backView3;
    backView3.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:backView3 belowSubview:self.backView];
    
    //两个按钮
    CGFloat topBtnW = ((screenWidth - 3 * 5) / 2);
    for(int i = 0;i < 2;i++)
    {
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topBtn.tag = i;
        if(i==0)
        {
            topBtn.selected = YES;
            self.selectedZusanBtn = topBtn;
            topBtn.userInteractionEnabled = NO;
            [topBtn setTitle:@"组三单式" forState:UIControlStateNormal];
            self.leftZusanBtn = topBtn;
        }else
        {
            self.rightZusanBtn = topBtn;
            [topBtn setTitle:@"组三复式" forState:UIControlStateNormal];
        }
        topBtn.frame = CGRectMake(5 + topBtnW * i, 0, topBtnW, 36);
        topBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        topBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [topBtn setTitleColor:YZColor(134, 134, 134, 1) forState:UIControlStateNormal];
        [topBtn setTitleColor:YZColor(246, 53, 80, 1) forState:UIControlStateSelected];
        [backView3 addSubview:topBtn];
        [topBtn addTarget:self action:@selector(topZusanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    //底部红线
    UIView * topBtnLine3 = [[UIView alloc]init];
    self.topBtnLine3 = topBtnLine3;
    topBtnLine3.frame = CGRectMake(5, 36 - 2, topBtnW, 2);
    topBtnLine3.backgroundColor = YZColor(246, 53, 80, 1);
    [backView3 addSubview:topBtnLine3];
}

#pragma  mark - 按钮点击
- (void)topZusanBtnClick:(YZLotteryButton *)btn{
    [self.scrollView3 setContentOffset:CGPointMake(btn.tag * screenWidth, 0) animated:YES];
}
- (void)zuheBtnClick:(YZLotteryButton *)btn
{
    [self.scrollView setContentOffset:CGPointMake(btn.tag * screenWidth, 0) animated:YES];
}
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
    
    //底部view
    UIView *playTypeBackView = [[UIView alloc] init];
    playTypeBackView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    self.playTypeBackView = playTypeBackView;
    playTypeBackView.backgroundColor = YZColor(0, 0, 0, 0.4);
    playTypeBackView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removePlayTypeBackView)];
    [playTypeBackView addGestureRecognizer:tap];
    [self.tabBarController.view addSubview:playTypeBackView];
    //玩法view
    UIView *playTypeView = [[UIView alloc] init];
    playTypeView.backgroundColor = [UIColor whiteColor];
    playTypeView.layer.cornerRadius = 5;
    playTypeView.clipsToBounds = YES;
    CGFloat playTypeViewW = 260;
    playTypeView.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.5);
    [playTypeBackView addSubview:playTypeView];
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = YZBlackTextColor;
    label.text = @"请选择玩法";
    CGSize labelSize = [label.text sizeWithFont:label.font maxSize:CGSizeMake(screenWidth, MAXFLOAT)];
    CGFloat labelW = labelSize.width;
    CGFloat labelH = labelSize.height;
    label.frame =CGRectMake(0, 15, labelW, labelH);
    label.center = CGPointMake(playTypeViewW/2, label.center.y);
    [playTypeView addSubview:label];
    
    //虚线
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accountDetail_separator"]];
    CGFloat separatorY = CGRectGetMaxY(label.frame) + 15;
    separator.frame = CGRectMake(0, separatorY, playTypeViewW, 1);
    [playTypeView addSubview:separator];
    
    CGFloat playTypeBtnCount = 4;
    int maxColums = 2;
    int padding = 10;
    CGFloat btnH = 30;
    for(int i = 0;i < playTypeBtnCount;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        btn.tag = i;
        btn.backgroundColor = YZColor(234, 62, 36, 1);
        if(i == 0)
        {
            [btn setTitle:@"直选" forState:UIControlStateNormal];
        }else if(i == 1)
        {
            [btn setTitle:@"组选和值" forState:UIControlStateNormal];
        }else if(i == 2)
        {
            [btn setTitle:@"组三" forState:UIControlStateNormal];
        }else if(i == 3)
        {
            [btn setTitle:@"组六" forState:UIControlStateNormal];
        }
        CGFloat btnW = (playTypeViewW - padding * (maxColums + 1)) / maxColums;
        CGFloat btnX = padding + (i % maxColums) * (btnW + padding);
        CGFloat btnY = CGRectGetMaxY(separator.frame) + 5 + (i / maxColums) * (btnH + padding);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [playTypeView addSubview:btn];
        [btn addTarget:self action:@selector(playTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    CGFloat playTypeViewH = CGRectGetMaxY(separator.frame) + 5 + 2 * (btnH + padding);
    playTypeView.bounds = CGRectMake(0, 0, playTypeViewW, playTypeViewH);
    
    playTypeView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        playTypeView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
//三个玩法按钮点击
- (void)playTypeBtn:(UIButton *)btn
{
    [UIView animateWithDuration:animateDuration animations:^{
        self.titleBtn.imageView.transform = CGAffineTransformIdentity;
    }];
    _openTitleMenu = !_openTitleMenu;
    
    switch (btn.tag) {
        case 0://直选
            self.playTypeCode = @"01";
            [self zhixuanBtnClick];
            break;
        case 1://组选
            self.playTypeCode = @"04";
            [self zuxuanBtnClick];
            break;
        case 2://组三
            self.playTypeCode = @"02";
            [self zuxuansanBtnClick];
            break;
        case 3://组六
            self.playTypeCode = @"03";
            [self zuxuanliuBtnClick];
            break;
            
        default:
            break;
    }
    [self.playTypeBackView removeFromSuperview];
    YZLog(@"playTypeCode = %@",self.playTypeCode);
    [self computeAmountMoney];
    if(self.currentTableView == self.tableView1 && [self.playTypeCode isEqualToString:@"01"])
    {
        self.autoSelectedLabel.hidden = NO;
    }else
    {
        self.autoSelectedLabel.hidden = YES;
    }
    [super setDeleteAutoSelectedBtnTitle];
}
- (void)zhixuanBtnClick
{
    [self.titleBtn setTitle:@"直选" forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.backView];//让直选的三个按钮出来
    [self.view insertSubview:self.scrollView3 aboveSubview:self.tableView6];
    [self.view insertSubview:self.tableViewZuxuan aboveSubview:self.scrollView3];
    [self.view insertSubview:self.scrollView aboveSubview:self.tableViewZuxuan];
}
- (void)zuxuanBtnClick
{
    [self.titleBtn setTitle:@"组选和值" forState:UIControlStateNormal];
    [self.fushiBtn setTitle:@"组选和值" forState:UIControlStateSelected];
    [self.view bringSubviewToFront:self.backView2];
    [self.view insertSubview:self.tableView6 aboveSubview:self.scrollView];
    [self.view insertSubview:self.scrollView3 aboveSubview:self.tableView6];
    [self.view insertSubview:self.tableViewZuxuan aboveSubview:self.scrollView3];
}
- (void)zuxuansanBtnClick
{
    [self.titleBtn setTitle:@"组三" forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.backView3];
    [self.view insertSubview:self.scrollView aboveSubview:self.tableViewZuxuan];
    [self.view insertSubview:self.tableView6 aboveSubview:self.scrollView];
    [self.view insertSubview:self.scrollView3 aboveSubview:self.tableView6];
}
- (void)zuxuanliuBtnClick
{
    [self.titleBtn setTitle:@"组六" forState:UIControlStateNormal];
    [self.fushiBtn setTitle:@"组六" forState:UIControlStateSelected];
    [self.view bringSubviewToFront:self.backView2];
    [self.view insertSubview:self.tableViewZuxuan aboveSubview:self.scrollView3];
    [self.view insertSubview:self.scrollView aboveSubview:self.tableViewZuxuan];
    [self.view insertSubview:self.tableView6 aboveSubview:self.scrollView];
}
#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(![scrollView isKindOfClass:[UITableView class]])
    {
        if ([_playTypeCode isEqualToString:@"01"])
        {
            // 1.取出水平方向上滚动的距离
            CGFloat offsetX = scrollView.contentOffset.x;
            // 2.求出页码
            double pageDouble = offsetX / scrollView.frame.size.width;
            self.pageInt = (int)(pageDouble + 0.5);
            [self changeBtnState:self.topBtns[self.pageInt]];
        }else if ([_playTypeCode isEqualToString:@"02"])
        {
            // 1.取出水平方向上滚动的距离
            CGFloat offsetX = scrollView.contentOffset.x;
            // 2.求出页码
            double pageDouble = offsetX / scrollView.frame.size.width;
            int pageZusanInt = (int)(pageDouble + 0.5);
            [self changeZusanBtnState:self.backView3.subviews[pageZusanInt]];
        }
    }
}
- (void)changeZusanBtnState:(YZLotteryButton *)btn
{
    self.selectedZusanBtn.selected = NO;
    self.selectedZusanBtn.userInteractionEnabled = YES;
    btn.userInteractionEnabled = NO;
    btn.selected = YES;
    self.selectedZusanBtn = btn;
    self.currentZusanTableView = self.zusanTableViews[btn.tag];//当前的tableview
    [self currentTableViewDidChange];
    //红线动画
    [UIView animateWithDuration:animateDuration
                     animations:^{
                         self.topBtnLine3.center = CGPointMake(btn.center.x, self.topBtnLine3.center.y);
                     }];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 0)//普通
    {
        return self.statusArray1.count;
    }else if(tableView.tag == 1)//和值
    {
        return self.statusArray2.count;
    }else if(tableView.tag == 2)//组合
    {
        return self.statusArray3.count;
    }else if(tableView.tag == KTableViewZuxuanTag)//组选
    {
        return self.statusArrayZuxuan.count;
    }else if(tableView.tag == KTableViewZuxuansanDanTag)//组三单式
    {
        return self.statusArrayZusan1.count;
    }else if(tableView.tag == KTableViewZuxuansanFuTag)//组三单式
    {
        return self.statusArrayZusan2.count;
    }else if(tableView.tag == 6)//组六
    {
        return  self.statusArrayZuliu.count;
    }else
    {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSelectBallCell *cell = [YZSelectBallCell cellWithTableView:tableView andIndexpath:indexPath];
    cell.index = indexPath.row;
    cell.tag = indexPath.row;
    cell.delegate = self;
    if(tableView.tag == 0)//普通
    {
        cell.status = self.statusArray1[indexPath.row];
        cell.owner = self.tableView1;
    }else if(tableView.tag == 1)//和值
    {
        cell.status = self.statusArray2[indexPath.row];
        cell.owner = self.tableView2;
    }else if(tableView.tag == 2)//组合
    {
        cell.status = self.statusArray3[indexPath.row];
        cell.owner = self.tableViewZuhe;
    }else if(tableView.tag == KTableViewZuxuanTag)//组选
    {
        cell.status = self.statusArrayZuxuan[indexPath.row];
        cell.owner = self.tableViewZuxuan;
    }else if(tableView.tag == KTableViewZuxuansanDanTag)//组三单式
    {
        cell.status = self.statusArrayZusan1[indexPath.row];
        cell.owner = self.tableView31;
    }else if(tableView.tag == KTableViewZuxuansanFuTag)//组三单式
    {
        cell.status = self.statusArrayZusan2[indexPath.row];
        cell.owner = self.tableView32;
    }else if(tableView.tag == 6)//组六
    {
        cell.status = self.statusArrayZuliu[indexPath.row];
        cell.owner = self.tableView6;
    }
    return cell;
}

//返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 0)//普通
    {
        YZSelectBallCellStatus *status = self.statusArray1[indexPath.row];
        return status.cellH;
    }else if(tableView.tag == 1)//和值
    {
        YZSelectBallCellStatus *status = self.statusArray2[indexPath.row];
        return status.cellH;
    }else if(tableView.tag == 2)//组合
    {
        YZSelectBallCellStatus *status = self.statusArray3[indexPath.row];
        return status.cellH;
    }else if(tableView.tag == KTableViewZuxuanTag)//组选
    {
        YZSelectBallCellStatus *status = self.statusArrayZuxuan[indexPath.row];
        return status.cellH;
    }else if(tableView.tag == KTableViewZuxuansanDanTag)//组三单式
    {
        YZSelectBallCellStatus *status = self.statusArrayZusan1[indexPath.row];
        return status.cellH;
    }else if(tableView.tag == KTableViewZuxuansanFuTag)//组三单式
    {
        YZSelectBallCellStatus *status = self.statusArrayZusan2[indexPath.row];
        return status.cellH;
    }else if(tableView.tag == 6)//组六
    {
        YZSelectBallCellStatus *status = self.statusArrayZuliu[indexPath.row];
        return status.cellH;
    }
    return 0;
}

#pragma  mark - 删除按钮点击
- (void)deleteBtnClick
{
    YZLog(@"deleteBtnClick");
    if([self.playTypeCode isEqualToString:@"01"])
    {
        if(self.currentTableView == self.tableView1)
        {
            [self clearSelBalls:self.selBaiBalls];//移除选中的球对象数组
            [self clearSelBalls:self.selShiBalls];
            [self clearSelBalls:self.selGeBalls];
            [self.selNumberArray removeAllObjects];//移除选中的球号码数组
        }else if(self.currentTableView == self.tableView2)
        {
            [self clearSelBalls:self.selHezhiBalls];//移除选中的球对象数组
        }else if(self.currentTableView == self.tableViewZuhe)
        {
            [self clearSelBalls:self.selZuheBalls];//移除选中的球对象数组
        }
    }else if([self.playTypeCode isEqualToString:@"04"])//组选
    {
        [self clearSelBalls:self.selZuxuanBalls];//移除选中按钮，和选中按钮数组
    }else if([self.playTypeCode isEqualToString:@"02"])//组三
    {
        if (self.currentZusanTableView == self.tableView31) {
            [self.selectedChongball ballChangeToWhite];
            [self.selectedDanball ballChangeToWhite];
            self.selectedChongball = nil;
            self.selectedDanball = nil;
        }else
        {
            [self clearSelBalls:self.selSanBalls];//移除选中按钮，和选中按钮数组
        }
    }else if([self.playTypeCode isEqualToString:@"03"])//组六
    {
        [self clearSelBalls:self.selLiuBalls];//移除选中按钮，和选中按钮数组
    }
    
    [self computeAmountMoney];
}
#pragma mark - 机选
- (void)autoSelectedBetWithNumber:(NSInteger)number
{
    for (int i = 0; i < number; i++) {
        [YZBetTool autoChoosePls];
    }
    [self gotoBetVc];
}
#pragma mark - 确认按钮点击
- (void)confirmBtnClick:(UIButton *)btn
{
    YZLog(@"confirmBtnClick");
    //直选和值不能单选27
    if([self.playTypeCode isEqualToString:@"01"])
    {
        if(self.currentTableView == self.tableView2)
        {
            if(self.selHezhiBalls.count == 1)//和值只有一个球
            {
                for(YZBallBtn *btn in self.selHezhiBalls)
                {
                    if (btn.tag == 27) {
                        [MBProgressHUD showError:@"直选和值27不能单独投注"];
                        return;
                    }
                }
            }
        }
    }
    if(self.betCount * 2 > 20000)
    {
        [MBProgressHUD showError:@"单注金额不能超过2万元"];
    }
    
    if([self.playTypeCode isEqualToString:@"01"])
    {
        if(self.currentTableView == self.tableView1)
        {
            [YZCommitTool commitPisNormalBetWithBaiBalls:self.selBaiBalls shiBalls:self.selShiBalls geBalls:self.selGeBalls betCount:self.betCount playType:self.playTypeCode];//提交普通的数据
        }else if(self.currentTableView == self.tableView2)
        {
            [YZCommitTool commitPisHezhiBetWithBalls:self.selHezhiBalls betCount:self.betCount playType:self.playTypeCode];//提交和值的数据
        }else if(self.currentTableView == self.tableViewZuhe)
        {
            [YZCommitTool commitPisZuheBetWithBalls:self.selZuheBalls betCount:self.betCount playType:self.playTypeCode];//提交组合的数据
        }
    }else if([self.playTypeCode isEqualToString:@"04"])
    {
        [YZCommitTool commitPisZuxuanBetWithBalls:self.selZuxuanBalls andBetCount:self.betCount andPlayType:_playTypeCode];//提交组选的数据
    }else if([self.playTypeCode isEqualToString:@"02"])
    {
        if (self.currentZusanTableView == self.tableView31) {
            [YZCommitTool commitPisSanDanBetWithDanBall:self.selectedDanball chongBall:self.selectedChongball betCount:self.betCount playType:self.playTypeCode];//提交组三单式的数据
        }else
        {
            [YZCommitTool commitPisSanFuBetWithBalls:self.selSanBalls andBetCount:self.betCount andPlayType:self.playTypeCode];//提交组三复式的数据
        }
    }else if([self.playTypeCode isEqualToString:@"03"])//组六
    {
        [YZCommitTool commitPisLiuBetWithBalls:self.selLiuBalls BetCount:self.betCount PlayType:self.playTypeCode];//提交组六的数据
    }
    //删除所有的
    [self deleteBtnClick];
    [self gotoBetVc];
}
- (void)gotoBetVc
{
    //页面跳转
    YZBetViewController *bet = [[YZBetViewController alloc] init];//投注控制器
    bet.gameId = self.gameId;
    [self.navigationController pushViewController: bet animated:YES];
}
#pragma mark - YZBallBtnDelegate的代理方法,点击了ball 按钮
- (void)ballDidClick:(YZBallBtn *)btn
{
    if([self.playTypeCode isEqualToString:@"01"])//直选
    {
        if(self.currentTableView == self.tableView1)//是左边的tableView
        {
            YZSelectBallCell *cell = btn.owner;
            //先检测有几个0号码被选中
            int zeroCount = 0;
            for(YZBallBtn *ball in self.selBaiBalls)
            {
                if(ball.tag == 0)
                {
                    zeroCount ++;
                }
            }
            for(YZBallBtn *ball in self.selShiBalls)
            {
                if(ball.tag == 0)
                {
                    zeroCount ++;
                }
            }
            for(YZBallBtn *ball in self.selGeBalls)
            {
                if(ball.tag == 0)
                {
                    zeroCount ++;
                }
            }
            if(zeroCount == 2 && !btn.isSelected && btn.tag == 0)
            {
                [btn ballChangeToWhite];
                [MBProgressHUD showError:@"目前暂不支持三个0同号"];
                return;
            }
            switch (cell.tag)
            {
                case 0:
                    if(btn.isSelected)//之前是选中的就移除
                    {
                        [self.selBaiBalls removeObject:btn];
                    }else
                    {
                        [self.selBaiBalls addObject:btn];
                    }
                    break;
                case 1:
                    if(btn.isSelected)//之前是选中的就移除
                    {
                        [self.selShiBalls removeObject:btn];
                    }else
                    {
                        [self.selShiBalls addObject:btn];
                    }
                    break;
                case 2:
                    if(btn.isSelected)//之前是选中的就移除
                    {
                        [self.selGeBalls removeObject:btn];
                    }else
                    {
                        [self.selGeBalls addObject:btn];
                    }
                    break;
                    
                default:
                    break;
            }
        }else if(self.currentTableView == self.tableView2)//右边的tableView
        {
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selHezhiBalls removeObject:btn];
            }else
            {
                [self.selHezhiBalls addObject:btn];
            }
        }else if(self.currentTableView == self.tableViewZuhe)//组合tableView
        {
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selZuheBalls removeObject:btn];
            }else
            {
                [self.selZuheBalls addObject:btn];
            }
        }
    }else if([self.playTypeCode isEqualToString:@"04"])//组选
    {
        if(btn.isSelected)//之前是选中的就移除
        {
            [self.selZuxuanBalls removeObject:btn];
        }else
        {
            [self.selZuxuanBalls addObject:btn];
        }
    }
    else if([self.playTypeCode isEqualToString:@"02"])//组三
    {
        if (self.currentZusanTableView == self.tableView32){//组三复式
            if(btn.isSelected)//之前是选中的就移除
            {
                [self.selSanBalls removeObject:btn];
            }else
            {
                [self.selSanBalls addObject:btn];
            }
        }else{
            YZSelectBallCell *cell = btn.owner;
            if (cell.tag == 0) {
                if (self.selectedDanball.tag == btn.tag) {//如果有被选中的单号球,就把被选中的单号求取消被选择
                    [self.selectedDanball ballChangeToWhite];
                    self.selectedDanball = nil;
                }
                if (self.selectedChongball) {//如果有被选中的球
                    if (self.selectedChongball.tag == btn.tag) {//如果当前球被选中,取消被选择状态
                        self.selectedChongball = nil;
                    }else//如果当前球不是被选中,取消之前被选中的球
                    {
                        [self.selectedChongball ballChangeToWhite];
                        self.selectedChongball = btn;
                    }
                }else//如果没有被选中的球,直接选中
                {
                   self.selectedChongball = btn;
                }
            }else{
                if (self.selectedChongball.tag == btn.tag) {
                    [self.selectedChongball ballChangeToWhite];
                    self.selectedChongball = nil;
                }
                if (self.selectedDanball) {
                    if (self.selectedDanball.tag == btn.tag) {
                        self.selectedDanball = nil;
                    }else
                    {
                        [self.selectedDanball ballChangeToWhite];
                        self.selectedDanball = btn;
                    }
                }else
                {
                    self.selectedDanball = btn;
                }
            }
        }
    }else if([self.playTypeCode isEqualToString:@"03"])//组六
    {
        if(btn.isSelected)//之前是选中的就移除
        {
            [self.selLiuBalls removeObject:btn];
        }else
        {
            [self.selLiuBalls addObject:btn];
        }
    }
    
    //计算注数和金额
    [self computeAmountMoney];
}
#pragma mark - 计算注数和金额
- (void)computeAmountMoney
{
    if([self.playTypeCode isEqualToString:@"01"])
    {
        if(self.currentTableView == self.tableView1)//左边的tableView
        {
            int redComposeCount = (int)self.selGeBalls.count * (int)self.selShiBalls.count * (int)self.selBaiBalls.count;
            self.betCount = redComposeCount;
        }else if(self.currentTableView == self.tableView2)//右边的tableView
        {
            if(self.selHezhiBalls.count)//有值
            {
                int hezhiComposeCount = 0;
                for(YZBallBtn *btn in self.selHezhiBalls)
                {
                    NSNumber *number = self.hezhiBallComposeCount[btn.tag];
                    hezhiComposeCount += [number intValue];
                }
                self.betCount = hezhiComposeCount;
            }else
            {
                self.betCount = 0;
            }
        }else if(self.currentTableView == self.tableViewZuhe)//组选和值的tableView
        {
            if(self.selZuheBalls.count)//有值
            {
                int zuheComposeCount = 0;
                NSNumber *number = self.zuheBallComposeCount[self.selZuheBalls.count];
                zuheComposeCount += [number intValue];
                self.betCount = zuheComposeCount;
            }else
            {
                self.betCount = 0;
            }
        }
    }else if ([self.playTypeCode isEqualToString:@"04"])//组选
    {
        int zuxuanComposeCount = 0;
        for(YZBallBtn *btn in self.selZuxuanBalls)
        {
            NSNumber *number = self.zuxuanBallComposeCount[btn.tag];
            zuxuanComposeCount += [number intValue];
        }
        self.betCount = zuxuanComposeCount;
    }else if ([self.playTypeCode isEqualToString:@"02"])//组三的
    {
        if (self.currentZusanTableView == self.tableView32) {//组三复式
            NSNumber *number = self.zusanBallComposeCount[self.selSanBalls.count];
            self.betCount = [number intValue];
        }else{//组三单式
            if (self.selectedChongball && self.selectedDanball) {
                self.betCount = 1;
            }else
            {
                self.betCount = 0;
            }
        }
    }else if([self.playTypeCode isEqualToString:@"03"])//组六的
    {
        NSNumber *number = self.zuliuBallComposeCount[self.selLiuBalls.count];
        self.betCount = [number intValue];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    YZLog(@"scrollViewDidEndDragging");
    [self computeAmountMoney];
}
- (void)currentTableViewDidChange
{
    [self computeAmountMoney];
    if(self.currentTableView == self.tableView1 && [self.playTypeCode isEqualToString:@"01"])
    {
        self.autoSelectedLabel.hidden = NO;
    }else
    {
        self.autoSelectedLabel.hidden = YES;
    }
    [super setDeleteAutoSelectedBtnTitle];
}
#pragma mark - 摇动机选
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSString * allowShake = [YZUserDefaultTool getObjectForKey:@"allowShake"];
    if ([allowShake isEqualToString:@"0"]) return;
    
    if(self.currentTableView == self.tableView1 && [self.playTypeCode isEqualToString:@"01"])
    {
        [self clearSelBalls:self.selBaiBalls];
        [self clearSelBalls:self.selShiBalls];
        [self clearSelBalls:self.selGeBalls];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
        NSMutableSet *baiSet = [NSMutableSet set];
        NSMutableSet *shiSet = [NSMutableSet set];
        NSMutableSet *geSet = [NSMutableSet set];
        
        int random1 = arc4random() % 10;
        [baiSet addObject:[NSString stringWithFormat:@"%d",random1]];
        
        int random2 = arc4random() % 10;
        [shiSet addObject:[NSString stringWithFormat:@"%d",random2]];
        
        int random3 = arc4random() % 10;
        [geSet addObject:[NSString stringWithFormat:@"%d",random3]];
        
        NSArray *randomArr = [NSArray arrayWithObjects:@(random1),@(random2),@(random3), nil];
        for(int i = 0;i < 3;i++)
        {
            YZSelectBallCell *cell = (YZSelectBallCell *)[self.tableView1 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            YZBallBtn *ballBtn = cell.ballsArray[[randomArr[i] intValue]] ;
            [ballBtn ballClick:ballBtn];
        }
    }
}
#pragma mark - 清空号码球数组，让所有已选号码球变回原来颜色
- (void)clearSelBalls:(NSMutableArray *)array
{
    for(int i = 0;i < array.count;i++)
    {
        YZBallBtn *ballBtn = array[i];
        if(ballBtn.isSelected)
        {
            [ballBtn ballChangeToWhite];
        }
    }
    [array removeAllObjects];
}
#pragma mark - 初始化
- (NSMutableArray *)statusArray1
{
    if(_statusArray1 == nil)
    {
        _statusArray1 = [NSMutableArray array];
    }
    NSMutableArray *array = [NSMutableArray array];
    //左边view的第一个cell
    YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"每位至少都要选择1个号码"];
    status.title = attStr;
    status.isRed = YES;
    status.ballsCount = 10;
    status.icon = @"bai_btn_flat";
    status.startNumber = @"0";
    [array addObject:status];
    
    //左边view的第二个cell
    YZSelectBallCellStatus *status1 = [[YZSelectBallCellStatus alloc] init];
    status1.isRed = YES;
    status1.ballsCount = 10;
    status1.icon = @"shi_flat";
    status1.startNumber = @"0";
    [array addObject:status1];
    
    //左边view的第三个cell
    YZSelectBallCellStatus *status2 = [[YZSelectBallCellStatus alloc] init];
    status2.isRed = YES;
    status2.ballsCount = 10;
    status2.icon = @"ge_flat";
    status2.startNumber = @"0";
    [array addObject:status2];
    
    return _statusArray1 = array;
}
- (NSMutableArray *)statusArray2
{
    if(_statusArray2 == nil)
    {
        _statusArray2 = [NSMutableArray array];
    }
    NSMutableArray *array = [NSMutableArray array];
    
    //右边view的第一个cell
    YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"至少选择1个和值号码"];
    status.title = attStr;
    status.isRed = YES;
    status.ballsCount = 27;
    status.startNumber = @"1";
    [array addObject:status];
    
    return _statusArray2 = array;
}
- (NSMutableArray *)statusArray3
{
    if(_statusArray3 == nil)
    {
        _statusArray3 = [NSMutableArray array];
    }
    NSMutableArray *array = [NSMutableArray array];
    
    //右边view的第一个cell
    YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"请至少选择3个号码"];
    status.title = attStr;
    status.isRed = YES;
    status.ballsCount = 10;
    status.startNumber = @"0";
    [array addObject:status];
    
    return _statusArray3 = array;
}
- (NSMutableArray *)statusArrayZuxuan
{
    if(_statusArrayZuxuan == nil)
    {
        _statusArrayZuxuan = [NSMutableArray array];
    }
    NSMutableArray *array = [NSMutableArray array];
    
    //右边view的第一个cell
    YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"至少选择1个和值号码"];
    status.title = attStr;
    status.isRed = YES;
    status.ballsCount = 24;
    status.startNumber = @"2";
    [array addObject:status];
    
    return _statusArrayZuxuan = array;
}
- (NSMutableArray *)statusArrayZusan1
{
    if(_statusArrayZusan1 == nil)
    {
        _statusArrayZusan1 = [NSMutableArray array];
    }
    NSMutableArray *array = [NSMutableArray array];
    
    //右边view的第一个cell
    YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"每位至少选择1个号码"];
    status.title = attStr;
    status.isRed = YES;
    status.icon = @"chong_flat";
    status.ballsCount = 10;
    status.startNumber = @"0";
    [array addObject:status];
    
    //左边view的第二个cell
    YZSelectBallCellStatus *status1 = [[YZSelectBallCellStatus alloc] init];
    status1.isRed = YES;
    status1.icon = @"dan_flat";
    status1.ballsCount = 10;
    status1.startNumber = @"0";
    [array addObject:status1];
    
    return _statusArrayZusan1 = array;
}
- (NSMutableArray *)statusArrayZusan2
{
    if(_statusArrayZusan2 == nil)
    {
        _statusArrayZusan2 = [NSMutableArray array];
    }
    NSMutableArray *array = [NSMutableArray array];
    
    //右边view的第一个cell
    YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"至少选择2个号码"];
    status.title = attStr;
    status.isRed = YES;
    status.ballsCount = 10;
    status.startNumber = @"0";
    [array addObject:status];
    
    return _statusArrayZusan2 = array;
}
- (NSMutableArray *)statusArrayZuliu
{
    if(_statusArrayZuliu == nil)
    {
        _statusArrayZuliu = [NSMutableArray array];
    }
    NSMutableArray *array = [NSMutableArray array];
    
    //右边view的第一个cell
    YZSelectBallCellStatus *status = [[YZSelectBallCellStatus alloc] init];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"至少选择3个号码"];
    status.title = attStr;
    status.isRed = YES;
    status.ballsCount = 10;
    status.startNumber = @"0";
    [array addObject:status];
    
    return _statusArrayZuliu = array;
}
- (NSMutableArray *)selGeBalls
{
    if(_selGeBalls == nil)
    {
        _selGeBalls = [NSMutableArray array];
    }
    return _selGeBalls;
}
- (NSMutableArray *)selBaiBalls
{
    if(_selBaiBalls == nil)
    {
        _selBaiBalls = [NSMutableArray array];
    }
    return _selBaiBalls;
}
- (NSMutableArray *)selShiBalls
{
    if(_selShiBalls == nil)
    {
        _selShiBalls = [NSMutableArray array];
    }
    return _selShiBalls;
}
- (NSMutableArray *)selHezhiBalls
{
    if(_selHezhiBalls == nil)
    {
        _selHezhiBalls = [NSMutableArray array];
    }
    return _selHezhiBalls;
}
- (NSMutableArray *)selZuxuanBalls
{
    if(_selZuxuanBalls == nil)
    {
        _selZuxuanBalls = [NSMutableArray array];
    }
    return _selZuxuanBalls;
}
- (NSMutableArray *)selZuheBalls
{
    if(_selZuheBalls == nil)
    {
        _selZuheBalls = [NSMutableArray array];
    }
    return _selZuheBalls;
}
- (NSMutableArray *)selSanBalls
{
    if(_selSanBalls == nil)
    {
        _selSanBalls = [NSMutableArray array];
    }
    return _selSanBalls;
}
- (NSMutableArray *)selLiuBalls
{
    if(_selLiuBalls == nil)
    {
        _selLiuBalls = [NSMutableArray array];
    }
    return _selLiuBalls;
}
- (NSMutableArray *)selNumberArray
{
    if(_selNumberArray == nil)
    {
        _selNumberArray = [NSMutableArray array];
    }
    NSMutableArray *tempArr = [NSMutableArray array];
    for(NSArray *arr in self.selBaiBalls)
    {
        [tempArr addObject:arr];
    }
    for(NSArray *arr in self.selShiBalls)
    {
        [tempArr addObject:arr];
    }
    for(NSArray *arr in self.selGeBalls)
    {
        [tempArr addObject:arr];
    }
    
    return _selNumberArray = tempArr;
}
- (NSMutableArray *)zusanTableViews
{
    if(_zusanTableViews == nil)
    {
        _zusanTableViews = [NSMutableArray array];
    }
    return _zusanTableViews;
}
- (NSArray *)zuheBallComposeCount
{
    if(_zuheBallComposeCount == nil)
    {
        _zuheBallComposeCount = [NSArray arrayWithObjects:@(0),@(0),@(0),@(6),@(24),@(60),@(120),@(210),@(336),@(504),@(720), nil];
    }
    return _zuheBallComposeCount;
}
- (NSArray *)hezhiBallComposeCount
{
    if(_hezhiBallComposeCount == nil)
    {
        _hezhiBallComposeCount = [NSArray arrayWithObjects:@(1),@(3),@(6),@(10),@(15),@(21),@(28),@(36),@(45),@(55),@(63),@(69),@(73),@(75),@(75),@(73),@(69),@(63),@(55),@(45),@(36),@(28),@(21),@(15),@(10),@(6),@(3),@(1), nil];
    }
    return _hezhiBallComposeCount;
}
- (NSArray *)zuxuanBallComposeCount
{
    if(_zuxuanBallComposeCount == nil)
    {
        _zuxuanBallComposeCount = [NSArray arrayWithObjects:@(0),@(1),@(2),@(2),@(4),@(5),@(6),@(8),@(10),@(11),@(13),@(14),@(14),@(15),@(15),@(14),@(14),@(13),@(11),@(10),@(8),@(6),@(5),@(4),@(2),@(2),@(1), nil];
    }
    return _zuxuanBallComposeCount;
}
- (NSArray *)zusanBallComposeCount
{
    if(_zusanBallComposeCount == nil)
    {
        _zusanBallComposeCount = [NSArray arrayWithObjects:@(0),@(0),@(2),@(6),@(12),@(20),@(30),@(42),@(56),@(72),@(90), nil];
    }
    return _zusanBallComposeCount;
}
- (NSArray *)zuliuBallComposeCount
{
    if(_zuliuBallComposeCount == nil)
    {
        _zuliuBallComposeCount = [NSArray arrayWithObjects:@(0),@(0),@(0),@(1),@(4),@(10),@(20),@(35),@(56),@(84),@(120), nil];
    }
    return _zuliuBallComposeCount;
}
- (void)removePlayTypeBackView
{
    [UIView animateWithDuration:animateDuration animations:^{
        self.titleBtn.imageView.transform = CGAffineTransformIdentity;
    }];
    _openTitleMenu = !_openTitleMenu;
    [self.playTypeBackView removeFromSuperview];
}

@end
