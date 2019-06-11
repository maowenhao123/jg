//
//  YZFucaiViewController.m
//  ez
//
//  Created by apple on 14-9-10.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZFucaiViewController.h"
#import "YZBallBtn.h"
#import "YZBetStatus.h"

@interface YZFucaiViewController ()<UITableViewDelegate,UITableViewDataSource,YZSelectBallCellDelegate,YZBallBtnDelegate>
@property (nonatomic, weak) UIView *countBackView;//选择多少个号码的背部view
@property (nonatomic, weak) UIScrollView *scrollView3;//组三view

@property (nonatomic, strong) NSMutableArray *zusanTableViews;//组三tableViews

@property (nonatomic, strong) NSArray *tableView1RedBallsArray;//第一个tableView的红球数组
@property (nonatomic, strong) NSMutableArray *statusArray1;//左边tableview的数据
@property (nonatomic, strong) NSMutableArray *statusArray2;//右边tableview的数据
@property (nonatomic, strong) NSMutableArray *statusArray31;//组选单式三tableview的数据
@property (nonatomic, strong) NSMutableArray *statusArray32;//组三复式tableview的数据
@property (nonatomic, strong) NSMutableArray *statusArray6;//直选六tableview的数据

@property (nonatomic, strong) NSMutableArray *selBaiBalls;//已选百位
@property (nonatomic, strong) NSMutableArray *selShiBalls;//已选十位
@property (nonatomic, strong) NSMutableArray *selGeBalls;//已选个位
@property (nonatomic, strong) NSMutableArray *selNumberArray;//已选号码的数组

@property (nonatomic, strong) NSMutableArray *selHezhiBalls;//已选和值球号码
@property (nonatomic, strong) NSMutableArray *selSanBalls;//已选组选三复式的球
@property (nonatomic, strong) NSMutableArray *selLiuBalls;//已选组选六的球

@property (nonatomic, weak) UIView *playTypeBackView;//选择玩法的背景View

@property (nonatomic, strong) NSArray *hezhiBallComposeCount;//和值注数
@property (nonatomic, strong) NSArray *zusanBallComposeCount;//组三复式注数
@property (nonatomic, strong) NSArray *zuliuBallComposeCount;//组六注数

@property (nonatomic, copy) NSString *playTypeCode;//游戏玩法BetTypeCode
@property (nonatomic, weak) UIButton *titleBtn;//头部按钮
@property (nonatomic, weak) UITableView *tableView31;//直选三单式的
@property (nonatomic, weak) UITableView *tableView32;//直选三复式的
@property (nonatomic, weak) UITableView *currentZusanTableView;//当前选中组三的tableview
@property (nonatomic, weak) UITableView *tableView6;//直选六的

@property (nonatomic, weak) UIView *backView2;//复式按钮的底部view
@property (nonatomic, weak) UIView *backView3;//组三按钮的底部view
@property (nonatomic, weak) UIButton *fushiBtn;//复式投注按钮

@property (nonatomic, weak) UIButton *leftZusanBtn;//组三单式
@property (nonatomic, weak) UIButton *rightZusanBtn;//组三复式
@property (nonatomic, weak) UIButton *selectedZusanBtn;//组三被选中的btn
@property (nonatomic, weak) UIView *topBtnLine3;//顶部按钮的下划线

@property (nonatomic, weak) YZBallBtn *selectedChongball;
@property (nonatomic, weak) YZBallBtn *selectedDanball;
@end

typedef enum{
    KTableViewZuxuansanDanTag = 31,
    KTableViewZuxuansanFuTag = 32,
}tableviewTag;

@implementation YZFucaiViewController

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
    
    //navigationbar
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleBtn = titleBtn;
    titleBtn.frame = CGRectMake(0, 0, 100, 30);
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
    [titleBtn setTitle:@"直选" forState:UIControlStateNormal];
    [titleBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0, 0)];
#if JG
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"down_arrow"] forState:UIControlStateNormal];
#elif ZC
    [titleBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
#elif CS
    [titleBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    [titleBtn setImage:[UIImage imageNamed:@"down_arrow_black"] forState:UIControlStateNormal];
#endif
    self.navigationItem.titleView = titleBtn;
    
    [titleBtn addTarget:self action:@selector(titleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupBtn];//复式投注的按钮
    [self setupZusanBtn];//组三投注按钮
    //组六
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backView.frame), screenWidth,self.scrollView.frame.size.height) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView6 = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.tag = 6;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view insertSubview:tableView belowSubview:self.scrollView];
    
    //组三
    //scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delaysContentTouches = NO;
    self.scrollView3 = scrollView;
    scrollView.delegate = self;
    CGFloat scrollViewH = screenHeight-statusBarH-navBarH-49-36-endTimeLabelH;
    scrollView.frame = CGRectMake(0, CGRectGetMaxY(self.backView.frame), screenWidth,self.scrollView.frame.size.height);
    [self.view addSubview:scrollView];
    //设置属性
    scrollView.contentSize = CGSizeMake(screenWidth * 2, scrollViewH);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    
    //添加2个tableview
    for(int i = 0;i < 2;i++)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(screenWidth * i, 0, screenWidth, scrollViewH) style:UITableViewStylePlain];
        tableView.delaysContentTouches = NO;
        tableView.backgroundColor = YZBackgroundColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.delegate = self;
        tableView.dataSource = self;
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
        [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
        [scrollView addSubview:tableView];
    }
    [self.view insertSubview:self.scrollView3 belowSubview:self.scrollView];
}
- (void)titleBtnClick
{
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
    CGFloat playTypeViewH = 100;
    playTypeView.bounds = CGRectMake(0, 0, playTypeViewW, playTypeViewH);
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
    
    CGFloat btnY = playTypeViewH/2 + 5;
    for(int i = 0;i < 3;i++)
    {
        int padding = 10;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.backgroundColor = YZColor(234, 62, 36, 1);
        if(i == 0)
        {
            [btn setTitle:@"直选" forState:UIControlStateNormal];
        }else if(i == 1)
        {
            [btn setTitle:@"组三" forState:UIControlStateNormal];
        }else
        {
            [btn setTitle:@"组六" forState:UIControlStateNormal];
        }
        CGFloat btnW = (playTypeViewW - padding * 4) / 3;
        CGFloat btnH = 30;
        CGFloat btnX = padding + i * (btnW + padding);
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [playTypeView addSubview:btn];
        [btn addTarget:self action:@selector(playTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    //虚线
    UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accountDetail_separator"]];
    separator.frame = CGRectMake(0, playTypeViewH/2, playTypeViewW, 1);
    [playTypeView addSubview:separator];
}
//三个玩法按钮点击
- (void)playTypeBtn:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
            self.playTypeCode = @"01";
            [self zhixuanBtnClick];
            break;
        case 1:
            self.playTypeCode = @"02";
            [self zuxuansanBtnClick];
            break;
        case 2:
            self.playTypeCode = @"03";
            [self zuxuanliuBtnClick];
            break;
            
        default:
            break;
    }
    [self.playTypeBackView removeFromSuperview];
    YZLog(@"playTypeCode = %@",self.playTypeCode);
    [self computeAmountMoney];
    if([self.playTypeCode isEqualToString:@"01"] && self.currentTableView == self.tableView1)
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
    [self.view bringSubviewToFront:self.backView];
    [self.view insertSubview:self.scrollView3 aboveSubview:self.tableView6];
    [self.view insertSubview:self.scrollView aboveSubview:self.scrollView3];
}
- (void)zuxuansanBtnClick
{
    [self.titleBtn setTitle:@"组三" forState:UIControlStateNormal];
    [self.view bringSubviewToFront:self.backView3];
    [self.view insertSubview:self.tableView6 aboveSubview:self.scrollView];
    [self.view insertSubview:self.scrollView3 aboveSubview:self.tableView6];
}
- (void)zuxuanliuBtnClick
{
    [self.titleBtn setTitle:@"组六" forState:UIControlStateNormal];
    [self.fushiBtn setTitle:@"组六" forState:UIControlStateSelected];
    [self.view bringSubviewToFront:self.backView2];
    [self.view insertSubview:self.scrollView aboveSubview:self.scrollView3];
    [self.view insertSubview:self.tableView6 aboveSubview:self.scrollView];
}
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
    [topBtn setTitleColor:YZColor(246, 53, 80, 1) forState:UIControlStateSelected];
    [backView2 addSubview:topBtn];
    
    //底部红线
    UIView * topBtnLine = [[UIView alloc]init];
    topBtnLine.frame = CGRectMake(5, 36 - 2, screenWidth - 10, 2);
    topBtnLine.backgroundColor = YZColor(246, 53, 80, 1);
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
    CGFloat backViewH3 = 36;
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
        topBtn.frame = CGRectMake(5 + (((screenWidth - 3 * 5) / 2) + 5) * i, 0, topBtnW, backViewH3);
        topBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        topBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [topBtn setTitleColor:YZColor(134, 134, 134, 1) forState:UIControlStateNormal];
        [topBtn setTitleColor:YZColor(246, 53, 80, 1) forState:UIControlStateSelected];        [backView3 addSubview:topBtn];
        [topBtn addTarget:self action:@selector(topZusanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    //底部红线
    UIView * topBtnLine3 = [[UIView alloc]init];
    self.topBtnLine3 = topBtnLine3;
    topBtnLine3.frame = CGRectMake(5, backViewH3 - 2, topBtnW, 2);
    topBtnLine3.backgroundColor = YZColor(246, 53, 80, 1);
    [backView3 addSubview:topBtnLine3];
}
- (void)topZusanBtnClick:(YZLotteryButton *)btn{
    [self.scrollView3 setContentOffset:CGPointMake(btn.tag * screenWidth, 0) animated:YES];
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
            [self changeBtnState:self.backView.subviews[self.pageInt]];
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
                         self.topBtnLine3.center = CGPointMake(btn.center.x, self.topBtnLine.center.y);
                     }];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 0)
    {
        return self.statusArray1.count;
    }else if(tableView.tag == 1)
    {
        return self.statusArray2.count;
    }else if(tableView.tag == KTableViewZuxuansanDanTag)//直选单式三
    {
        return self.statusArray31.count;
    }else if(tableView.tag == KTableViewZuxuansanFuTag)//直选复式三
    {
        return self.statusArray32.count;
    }else if(tableView.tag == 6)//直选六
    {
        return  self.statusArray6.count;
    }else
    {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSelectBallCell *cell = [YZSelectBallCell cellWithTableView:tableView andIndexpath:(NSIndexPath *)indexPath];
    cell.index = indexPath.row;
    cell.delegate = self;
    if(tableView.tag == 0)
    {
        cell.status = self.statusArray1[indexPath.row];
        cell.tag = indexPath.row;
        cell.owner = self.tableView1;
        return  cell;
    }else if(tableView.tag == 1)
    {
        cell.status = self.statusArray2[indexPath.row];
        cell.tag = indexPath.row;
        cell.owner = self.tableView2;
        return  cell;
    }else if(tableView.tag == KTableViewZuxuansanDanTag)//直选单式三
    {
        cell.status = self.statusArray31[indexPath.row];
        cell.tag = indexPath.row;
        cell.owner = self.tableView2;
        return  cell;
    }else if(tableView.tag == KTableViewZuxuansanFuTag)//直选复式三
    {
        cell.status = self.statusArray32[indexPath.row];
        cell.tag = indexPath.row;
        cell.owner = self.tableView2;
        return  cell;
    }else//直选六
    {
        cell.status = self.statusArray6[indexPath.row];
        cell.tag = indexPath.row;
        cell.owner = self.tableView2;
        return  cell;
    }
}
//返回cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 0)
    {
        YZSelectBallCellStatus * status = self.statusArray1[indexPath.row];
        return status.cellH;
    }else if(tableView.tag == 1)
    {
        YZSelectBallCellStatus * status = self.statusArray2[indexPath.row];
        return status.cellH;
        
    }else if(tableView.tag == KTableViewZuxuansanDanTag)//直选单式三
    {
        YZSelectBallCellStatus * status = self.statusArray31[indexPath.row];
        return status.cellH;
        
    }else if(tableView.tag == KTableViewZuxuansanFuTag)//直选复式三
    {
        YZSelectBallCellStatus * status = self.statusArray32[indexPath.row];
        return status.cellH;
        
    }else//直选六
    {
        YZSelectBallCellStatus * status = self.statusArray6[indexPath.row];
        return status.cellH;
    }
}
- (void)removeCountView
{
    [self.countBackView removeFromSuperview];
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
        }else
        {
            [self clearSelBalls:self.selHezhiBalls];//移除选中的球对象数组
        }
    }else if([self.playTypeCode isEqualToString:@"02"])
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
    }else
    {
        [self clearSelBalls:self.selLiuBalls];//移除选中按钮，和选中按钮数组
    }
    
    [self computeAmountMoney];
}
#pragma mark - 机选
- (void)autoSelectedBetWithNumber:(NSInteger)number
{
    for (int i = 0; i < number; i++) {
        [YZBetTool autoChoosefc];
    }
    [self gotoBetVc];
}
#pragma mark - 确认按钮点击
- (void)confirmBtnClick:(UIButton *)btn
{
    YZLog(@"confirmBtnClick");
    //直选和值0和27不能单独投注
    if([self.playTypeCode isEqualToString:@"01"])
    {
        if(self.currentTableView == self.tableView2)
        {
            if (self.selHezhiBalls.count == 1) {
                for (YZBallBtn *btn in self.selHezhiBalls) {
                    if (btn.tag == 0) {
                        [MBProgressHUD showError:@"直选和值0不能单独投注"];
                        return;
                    }else if (btn.tag == 27){
                        [MBProgressHUD showError:@"直选和值27不能单独投注"];
                        return;
                    }
                }
            }
        }
    }
    if([self.playTypeCode isEqualToString:@"01"])
    {
        if(self.currentTableView == self.tableView1)
        {
            [self commitNormalBet];//提交普通的数据
        }else if(self.currentTableView == self.tableView2)
        {
            [self commitHezhiBet];//提交和值的数据
        }
    }else if([self.playTypeCode isEqualToString:@"02"])
    {
        if (self.currentZusanTableView == self.tableView31) {
            [self commitSanDanBet];
        }else
        {
            [self commitSanFuBet];//提交组三复式的数据
        }
    }else if([self.playTypeCode isEqualToString:@"03"])//组六
    {
        [self commitLiuBet];//提交组六的数据
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
- (void)commitSanDanBet//提交直选三单式的数据
{
    if (!self.selectedDanball || !self.selectedChongball) {
        [MBProgressHUD showError:@"请每位至少选择1个号码"];
    }else
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        [str appendString:[NSString stringWithFormat:@"%ld|",(long)self.selectedDanball.tag]];
        [str appendString:[NSString stringWithFormat:@"%ld|",(long)self.selectedChongball.tag]];
        [str appendString:[NSString stringWithFormat:@"%ld",(long)self.selectedChongball.tag]];
        [str appendString:@"[组三单式1注]"];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"["];//20
        NSRange range2 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, range2.location - range1.location + 1)];
        status.labelText = attStr;
        status.betCount = self.betCount;
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(275, MAXFLOAT)];
        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        status.playType = _playTypeCode;
        status.betType = @"00";
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
- (void)commitSanFuBet//提交直选三的数据
{
    if(self.selSanBalls.count < 2)
    {
        [MBProgressHUD showError:@"请至少选择2个号码"];
    }else if(self.betCount * 2 > 20000)
    {
        [MBProgressHUD showError:@"单注金额不能超过2万元"];
    }else
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对球数组排序
        self.selSanBalls = [self sortBallsArray:self.selSanBalls];
        for(YZBallBtn *btn in self.selSanBalls)
        {
            [str appendFormat:@"%d,",(int)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:[NSString stringWithFormat:@"[组三复式%d注]",self.betCount]];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"["];//20
        NSRange range2 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, range2.location - range1.location + 1)];
        status.labelText = attStr;
        status.betCount = self.betCount;
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(275, MAXFLOAT)];
         status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
- (void)commitLiuBet//提交直选六的数据
{
    if(self.selLiuBalls.count < 3)
    {
        [MBProgressHUD showError:@"请至少选择3个号码"];
    }else if(self.betCount * 2 > 20000)
    {
        [MBProgressHUD showError:@"单注金额不能超过2万元"];
    }else
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对球数组排序
        self.selLiuBalls = [self sortBallsArray:self.selLiuBalls];
        if(self.selLiuBalls.count == 3)//组六单式
        {
            for(YZBallBtn *btn in self.selLiuBalls)
            {
                [str appendFormat:@"%ld|",(long)btn.tag];
            }
        }else if(self.selLiuBalls.count >= 4)//组六复式
        {
            for(YZBallBtn *btn in self.selLiuBalls)
            {
                [str appendFormat:@"%ld,",(long)btn.tag];
            }
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        if(self.selLiuBalls.count == 3)//组六单式
        {
            [str appendString:[NSString stringWithFormat:@"[组六单式%d注]",self.betCount]];
        }else if(self.selLiuBalls.count >= 4)//组六复式
        {
            [str appendString:[NSString stringWithFormat:@"[组六复式%d注]",self.betCount]];
        }
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"["];//20
        NSRange range2 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, range2.location - range1.location + 1)];
        status.labelText = attStr;
        status.betCount = self.betCount;
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(275, MAXFLOAT)];
         status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
- (void)commitHezhiBet//提交和值的数据
{
    if (self.selHezhiBalls.count < 1)
    {
        [MBProgressHUD showError:@"请至少选择1个号码"];
    }else if(self.betCount * 2 > 20000)
    {
        [MBProgressHUD showError:@"单注金额不能超过2万元"];
    }else
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对球数组排序
        self.selHezhiBalls = [self sortBallsArray:self.selHezhiBalls];
        for(YZBallBtn *btn in self.selHezhiBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];//添加胆码
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:[NSString stringWithFormat:@"[直选和值%d注]",self.betCount]];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"["];//20
        NSRange range2 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, range2.location - range1.location + 1)];
        status.labelText = attStr;
        status.betCount = self.betCount;
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(275, MAXFLOAT)];
         status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
- (void)commitNormalBet//提交普通的数据
{
    if(self.selBaiBalls.count < 1 || self.selShiBalls.count < 1 || self.selGeBalls.count < 1)
    {//没有一注
        [MBProgressHUD showError:@"请每位至少选择1个号码"];
    }else if(self.betCount * 2 > 20000)
    {
        [MBProgressHUD showError:@"单注金额不能超过2万元"];
    }else//其他正确情况就传数据
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对百位球数组排序
        self.selBaiBalls = [self sortBallsArray:self.selBaiBalls];
        for(YZBallBtn *btn in self.selBaiBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"|"];
        //对十位球数组排序
        self.selShiBalls = [self sortBallsArray:self.selShiBalls];
        for(YZBallBtn *btn in self.selShiBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"|"];
        //对个位球数组排序
        self.selGeBalls = [self sortBallsArray:self.selGeBalls];
        for(YZBallBtn *btn in self.selGeBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        if(self.betCount == 1)
        {
            [str appendString:@"[直选单式1注]"];
        }else
        {
            [str appendString:[NSString stringWithFormat:@"[直选复式%d注]",self.betCount]];
        }
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"["];//20
        NSRange range2 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, range2.location - range1.location + 1)];
        status.labelText = attStr;
        status.betCount = self.betCount;
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(275, MAXFLOAT)];
         status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
#pragma mark - YZBallBtnDelegate的代理方法,点击了ball 按钮
- (void)ballDidClick:(YZBallBtn *)btn
{
    if([self.playTypeCode isEqualToString:@"01"])//直选
    {
        if(self.currentTableView == self.tableView1)//是左边的tableView
        {
            YZSelectBallCell *cell = btn.owner;
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
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"至少选择一个和值号码"];
    status.title = attStr;
    status.isRed = YES;
    status.ballsCount = 28;
    status.startNumber = @"0";
    [array addObject:status];
    
    return _statusArray2 = array;
}
- (NSMutableArray *)statusArray31
{
    if(_statusArray31 == nil)
    {
        _statusArray31 = [NSMutableArray array];
    }
    NSMutableArray *array = [NSMutableArray array];
    
    //左边view的第一个cell
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
    
    return _statusArray31 = array;
}
- (NSMutableArray *)statusArray32
{
    if(_statusArray32 == nil)
    {
        _statusArray32 = [NSMutableArray array];
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
    
    return _statusArray32 = array;
}
- (NSMutableArray *)statusArray6
{
    if(_statusArray6 == nil)
    {
        _statusArray6 = [NSMutableArray array];
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
    
    return _statusArray6 = array;
}
- (NSMutableArray *)zusanTableViews
{
    if(_zusanTableViews == nil)
    {
        _zusanTableViews = [NSMutableArray array];
    }
    return _zusanTableViews;
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
//计算注数和金额
- (void)computeAmountMoney
{
    if([self.playTypeCode isEqualToString:@"01"])
    {
        if(self.currentTableView == self.tableView1)//左边的tableView
        {
            int redComposeCount = (int)(self.selGeBalls.count * self.selShiBalls.count * self.selBaiBalls.count);
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
        }
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
    if([self.playTypeCode isEqualToString:@"01"] && self.currentTableView == self.tableView1)
    {
        self.autoSelectedLabel.hidden = NO;
    }else
    {
        self.autoSelectedLabel.hidden = YES;
    }
    [super setDeleteAutoSelectedBtnTitle];
}
#pragma mark - 摇一摇机选
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSString * allowShake = [YZUserDefaultTool getObjectForKey:@"allowShake"];
    if ([allowShake isEqualToString:@"0"]) return;
    
    if([self.playTypeCode isEqualToString:@"01"] && self.currentTableView == self.tableView1)
    {
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
        
        [self clearSelBalls:self.selBaiBalls];
        [self clearSelBalls:self.selShiBalls];
        [self clearSelBalls:self.selGeBalls];
        
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
//清空号码球数组，让所有已选号码球变回原来颜色
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

- (NSArray *)hezhiBallComposeCount
{
    if(_hezhiBallComposeCount == nil)
    {
        _hezhiBallComposeCount = [NSArray arrayWithObjects:@(1),@(3),@(6),@(10),@(15),@(21),@(28),@(36),@(45),@(55),@(63),@(69),@(73),@(75),@(75),@(73),@(69),@(63),@(55),@(45),@(36),@(28),@(21),@(15),@(10),@(6),@(3),@(1), nil];
    }
    return _hezhiBallComposeCount;
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
    [self.playTypeBackView removeFromSuperview];
}
@end
