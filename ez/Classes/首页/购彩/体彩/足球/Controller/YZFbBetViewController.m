//
//  YZFbBetViewController.m
//  ez
//
//  Created by apple on 14-12-2.
//  Copyright (c) 2014年 9ge. All rights reserved.
//  竞彩足球的投注界面
#define padding 10.0f

#import "YZFbBetViewController.h"
#import "YZChooseVoucherViewController.h"
#import "YZStartUnionBuyViewController.h"
#import "YZFbBetCell.h"
#import "YZValidateTool.h"
#import "YZLoginViewController.h"
#import "YZRechargeListViewController.h"
#import "YZFootBallTool.h"
#import "YZFbBetSuccessViewController.h"
#import "YZNavigationController.h"
#import "YZPlayPassWay.h"
#import "UIButton+YZ.h"
#import "YZFootBallMatchRate.h"

@interface YZFbBetViewController ()<UITableViewDataSource,UITableViewDelegate,YZFbBetCellDelegate>
{
    CGFloat _maxTableViewH;
    CGFloat _maxWhiteSawToothImageViewH;//白色锯齿图片
    NSArray *_freeWayTitles;//自由过关标题数组
    NSArray *_moreWayTitles;//多串过关标题数组
    NSArray *_currentFreeWayBtns;//自由过关的按钮
    NSArray *_currentMoreWayBtns;//多串过关的按钮
    float _minPrize;//最小奖金
    float _maxPrize;//最大奖金
    int _selDanBtnCount;
    NSString *_playType;
    int maxWayCount;//可选择的玩法
}

@property (nonatomic, strong) NSMutableArray *statusArray;//里面的是YZFbBetCellStatus模型
@property (nonatomic, copy) NSString *gameId;//游戏id

@property (nonatomic, weak) UILabel *amountLabel;
@property (nonatomic, assign) int betCount;//注数
@property (nonatomic, assign) float amountMoney;//金额
@property (nonatomic, weak) UITextField *multipleTextField;//倍数输入框
@property (nonatomic, weak) UILabel *bonusLabel;//奖金范围的label
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIImageView *whiteSawToothImageView;
@property (nonatomic, weak) UIView *passWayBackView;//过关方式按钮点击后出现的背景view
@property (nonatomic, strong) NSMutableArray *selectedFreeWayTags;//已选自由过关的按钮tag
@property (nonatomic, strong) NSMutableArray *selectedMoreWayTags;//已选多串过关的按钮tag
@property (nonatomic, strong) NSMutableArray *currentFreeWayTitles;//当前的自由过关标题数组
@property (nonatomic, strong) NSMutableArray *currentMoreWayTitles;//当前的多串过关标题数组
@property (nonatomic, weak) UIView *passWayView;//过关方式视图
@property (nonatomic, weak) UIButton *passWayBtn;//过关方式按钮
@property (nonatomic, strong) NSDictionary *playTypeDict;
@property (nonatomic, assign) int selectedPlayType;//选中的玩法
@end

@implementation YZFbBetViewController

- (instancetype)initWithGameId:(NSString *)gameId
                   statusArray:(NSMutableArray *)statusArray
              selectedPlayType:(int)selectedPlayType
{
    if(self = [super init])
    {
        _gameId = gameId;
        _statusArray = statusArray;
        _selectedPlayType = selectedPlayType;
        maxWayCount = [YZFootBallTool getMaxWayCountByStatusArray:statusArray];
    }
    return  self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setDanBtnState];
    
    NSInteger index = self.statusArray.count - 2;
    NSString *title;
    if(index >= self.currentFreeWayTitles.count)
    {
        title = [_currentFreeWayTitles lastObject];
    }else
    {
        title = _currentFreeWayTitles[index];
    }
    [self.passWayBtn setTitle:title forState:UIControlStateNormal];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = [UIColor whiteColor];
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:textAttrs];
    // 设置navBar背景
    [navBar setBackgroundImage:[YZTool getFBNavImage] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 取出appearance对象
    UINavigationBar *navBar = self.navigationController.navigationBar;
#if JG
    //设置颜色
    navBar.tintColor = [UIColor whiteColor];
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:textAttrs];
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:YZBaseColor WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
#elif ZC
    //设置颜色
    navBar.tintColor = YZBlackTextColor;
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = YZBlackTextColor;
    [navBar setTitleTextAttributes:textAttrs];
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
#elif CS
    //设置颜色
    navBar.tintColor = YZBlackTextColor;
    // 设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = YZBlackTextColor;
    [navBar setTitleTextAttributes:textAttrs];
    // 设置背景
    [navBar setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:CGRectMake(0, 0, screenWidth, statusBarH + navBarH)] forBarMetrics:UIBarMetricsDefault];
    //设置状态栏
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupChilds];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(multipleTextFieldChanged) name:UITextFieldTextDidChangeNotification object:self.multipleTextField];
    
     _freeWayTitles = [[NSArray alloc] initWithObjects:@"2串1", @"3串1", @"4串1", @"5串1", @"6串1", @"7串1", @"8串1",nil];
    
    _moreWayTitles = [[NSArray alloc] initWithObjects:@"3串3", @"3串4", @"4串4", @"4串5", @"4串6", @"4串11", @"5串5",@"5串6", @"5串10", @"5串16", @"5串20", @"5串26", @"6串6", @"6串7",@"6串15", @"6串20", @"6串22", @"6串35", @"6串42", @"6串50", @"6串57",@"7串7", @"7串8", @"7串21", @"7串35", @"7串120", @"8串8", @"8串9",@"8串28", @"8串56", @"8串70", @"8串247",nil];
    
    waitingView
    [self computeBetCountAndPrizeRange];
}
- (void)multipleTextFieldChanged
{
    if([self.multipleTextField.text intValue] > 999)
    {
        self.multipleTextField.text = @"999";
    }
    //设置注数和钱
    [self setAmountLabelText:_betCount];
    //设置奖金
    [self setBonusLabelTextWithMinPrize:_minPrize maxPrize:_maxPrize];
}

#pragma mark - 布局子视图
- (void)setupChilds
{
    //底栏
    CGFloat bottomViewW = screenWidth;
    CGFloat bottomViewH = 49;
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = screenHeight - bottomViewH - statusBarH - navBarH - [YZTool getSafeAreaBottom];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH)];
    [self.view addSubview:bottomView];
    
    //绿线
    UIImageView *greenLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ft_bottomline"]];
    CGFloat greenLineW = bottomViewW;
    CGFloat greenLineH = 2;
    greenLine.frame = CGRectMake(0, 0, greenLineW, greenLineH);
    [bottomView addSubview:greenLine];
    
    //投注按钮
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat confirmBtnH = 30;
    CGFloat confirmBtnW = 75;
    confirmBtn.frame = CGRectMake(screenWidth - confirmBtnW - 15, (bottomViewH - confirmBtnH) / 2, confirmBtnW, confirmBtnH);
    [confirmBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(80, 148, 35, 1) WithRect:confirmBtn.bounds] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"投注" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [bottomView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(betBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.layer.cornerRadius = 2;
    
    //注数和倍数和金额总数
    UILabel *amountLabel = [[UILabel alloc] init];
    self.amountLabel = amountLabel;
    amountLabel.textAlignment = NSTextAlignmentCenter;
    amountLabel.numberOfLines = 0;
    amountLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    amountLabel.textColor = YZBlackTextColor;
    CGFloat amountLabelX = 20;
    CGFloat amountLabelW = bottomViewW - amountLabelX - confirmBtnW - 10;
    CGFloat amountLabelH = 25;
    amountLabel.frame = CGRectMake(amountLabelX, 0, amountLabelW, amountLabelH);
    amountLabel.center = CGPointMake(amountLabel.center.x, bottomViewH/2);
    [self setAmountLabelText:0];//设置文字
    [bottomView addSubview:amountLabel];
    
    //奖金范围
    UILabel *bonusLabel = [[UILabel alloc] init];
    self.bonusLabel = bonusLabel;
    bonusLabel.textAlignment = NSTextAlignmentCenter;
    bonusLabel.backgroundColor = [UIColor whiteColor];
    bonusLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    bonusLabel.textColor = YZBlackTextColor;
    CGFloat bonusLabelH = 30;
    CGFloat bonusLabelY = bottomView.y - bonusLabelH;
    bonusLabel.frame = CGRectMake(0, bonusLabelY, screenWidth, bonusLabelH);
    [self.view addSubview:bonusLabel];
    [self setBonusLabelTextWithMinPrize:0 maxPrize:0];
    
    //过关方式按钮
    CGFloat passWayViewH = 35;
    CGFloat passWayViewW = 80;
    CGFloat passWayViewY = bonusLabel.y - padding - passWayViewH;
    UIView * passWayView = [[UIView alloc]initWithFrame:CGRectMake(padding, passWayViewY, passWayViewW, passWayViewH)];
    self.passWayView = passWayView;
    passWayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:passWayView];
    passWayView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    passWayView.layer.borderWidth = 0.5;
    
    CGFloat btnImageW = 30;
    if (_selectedPlayType >= 7) {
        UILabel * singleLabel = [[UILabel alloc]initWithFrame:passWayView.bounds];
        singleLabel.text = @"单关";
        singleLabel.font = [UIFont systemFontOfSize:15];
        singleLabel.textAlignment = NSTextAlignmentCenter;
        [passWayView addSubview:singleLabel];
    }else
    {
        UIButton *passWayBtn = [[UIButton alloc] init];
        self.passWayBtn = passWayBtn;
        passWayBtn.backgroundColor = [UIColor whiteColor];
    
        passWayBtn.frame = passWayView.bounds;
        [passWayBtn setTitle:@"过关方式" forState:UIControlStateNormal];
        passWayBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        passWayBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        UIImage *passWayImage = [UIImage imageNamed:@"fb_passwayBtn"];
        passWayBtn.imageView.contentMode = UIViewContentModeCenter;
        [passWayBtn setImage:passWayImage forState:UIControlStateNormal];
        [passWayBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, passWayViewW - btnImageW)];
        [passWayBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
        [passWayBtn setTitleColor:YZColor(97, 180, 59, 1) forState:UIControlStateNormal];//草绿
        [passWayBtn addTarget:self action:@selector(passWayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [passWayView addSubview:passWayBtn];
        //灰色虚线
        UIImageView *dashLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fb_gray_dashLine"]];
        dashLine.frame = CGRectMake(btnImageW, 0, 1, passWayViewH);
        [passWayBtn addSubview:dashLine];
    }
    //倍数输入框
    UITextField *multipleTextField = [[UITextField alloc] init];
    self.multipleTextField = multipleTextField;
    multipleTextField.backgroundColor = [UIColor whiteColor];
    multipleTextField.text = @"1";
    multipleTextField.textAlignment = NSTextAlignmentCenter;
    multipleTextField.keyboardType = UIKeyboardTypeNumberPad;
    multipleTextField.layer.borderWidth = 0.5;
    multipleTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    multipleTextField.textColor = YZBlackTextColor;
    multipleTextField.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    CGFloat multipleTextFieldX = CGRectGetMaxX(passWayView.frame) +padding;
    CGFloat multipleTextFieldY = passWayViewY;
    CGFloat multipleTextFieldH = passWayViewH;
    CGFloat multipleTextFieldW = screenWidth - multipleTextFieldX - padding;
    multipleTextField.frame = CGRectMake(multipleTextFieldX, multipleTextFieldY, multipleTextFieldW, multipleTextFieldH);
    [self.view addSubview:multipleTextField];
    
    //加减号按钮
    for(int i = 0;i < 2;i ++)
    {
        //灰色虚线
        UIImageView *dashLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fb_gray_dashLine"]];
        dashLine.frame = CGRectMake(0, 0, 1, multipleTextFieldH);
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = i;
        CGFloat btnW = btnImageW + 20;
        CGFloat btnH = multipleTextFieldH;
        btn.frame = CGRectMake(0, 0, btnW, btnH);
        [btn setTitleColor:YZColor(97, 180, 59, 1) forState:UIControlStateNormal];//草绿色
        btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        btn.titleLabel.backgroundColor = [UIColor whiteColor];
        UIImage *image = nil;
        if(i == 0)
        {
            image = [UIImage imageNamed:@"fb_minus"];
            [btn setTitle:@"投" forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, btnImageW-8, 0, 0)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 0, btnW - btnImageW)];
            dashLine.x = btnImageW;
        }else
        {
            image = [UIImage imageNamed:@"fb_plus"];
            [btn setTitle:@"倍" forState:UIControlStateNormal];
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -8, 0, btnImageW)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0, btnW - btnImageW+10, 0, 0)];
            btn.x = multipleTextFieldW - btnW;
            dashLine.x = btnW - btnImageW;
        }
        [btn addSubview:dashLine];
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(multipleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [multipleTextField addSubview:btn];
    }
    
    //继续选择添加赛事
    UIButton *goSelectBtn = [[UIButton alloc] init];
    CGFloat goSelectBtnW = screenWidth - 2 * padding;
    CGFloat goSelectBtnH = 40;
    CGFloat goSelectBtnY = passWayView.y - padding - goSelectBtnH;
    goSelectBtn.frame = CGRectMake(padding, goSelectBtnY, goSelectBtnW, goSelectBtnH);
    goSelectBtn.backgroundColor = YZColor(97, 180, 59, 1);//草绿
    [goSelectBtn setImage:[UIImage imageNamed:@"fb_round_plus"] forState:UIControlStateNormal];
    goSelectBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [goSelectBtn setTitle:@"继续选择添加赛事" forState:UIControlStateNormal];
    [goSelectBtn setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:12];
    [goSelectBtn addTarget:self action:@selector(goSelectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goSelectBtn];
    goSelectBtn.layer.masksToBounds = YES;
    goSelectBtn.layer.cornerRadius = 2;
    
    //顶部图片
    UIImage *cylinderImage = [UIImage imageNamed:@"fb_cylinderImage"];
    UIImageView *topImageView = [[UIImageView alloc] initWithImage:cylinderImage];
    CGFloat topImageViewX = padding / 2;
    CGFloat topImageViewY = padding / 2;
    CGFloat topImageViewW = screenWidth - 2 * topImageViewX;
    CGFloat topImageViewH = cylinderImage.size.height;
    topImageView.frame = CGRectMake(topImageViewX, topImageViewY, topImageViewW, topImageViewH);
    [self.view addSubview:topImageView];
    
    //带锯齿，随cell个数变化高度的imageview
    UIImage *whiteSawTooth = [UIImage resizedImageWithName:@"whtieSawToothImage" left:0 top:0.1];
    UIImageView *whiteSawToothImageView = [[UIImageView alloc] initWithImage:whiteSawTooth];
    self.whiteSawToothImageView = whiteSawToothImageView;
    whiteSawToothImageView.userInteractionEnabled = YES;
    CGFloat whiteSawToothImageViewX = padding;
    CGFloat whiteSawToothImageViewY = CGRectGetMaxY(topImageView.frame) - topImageViewH / 2;
    CGFloat whiteSawToothImageViewW = screenWidth - 2 * padding;
    CGFloat whiteSawToothImageViewH = 0;
    whiteSawToothImageView.frame = CGRectMake(whiteSawToothImageViewX, whiteSawToothImageViewY, whiteSawToothImageViewW, whiteSawToothImageViewH);
    [self.view addSubview:whiteSawToothImageView];
    
    //tableView
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delaysContentTouches = NO;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    CGFloat tableViewX = 2;
    CGFloat tableViewY = 0;
    CGFloat tableViewW = whiteSawToothImageViewW - tableViewX * 2;
    CGFloat tableViewH = 0;
    _maxTableViewH = goSelectBtn.y - padding - whiteSawToothImageViewY - tableViewY - padding;//tableView的最大高度
    tableView.frame = CGRectMake(tableViewX, tableViewY, tableViewW, tableViewH);
    [whiteSawToothImageView addSubview:tableView];
}
#pragma mark - tableView的数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self changeTableViewHeight];
    
    return  self.statusArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZFbBetCell *cell = [YZFbBetCell cellWithTableView:tableView andIndexpath:indexPath];
    cell.delegate = self;
    cell.status = self.statusArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZFbBetCellStatus *status = self.statusArray[indexPath.row];
    return status.cellH;
}
#pragma mark - YZFbBetCellDelegate  cell的代理方法
//cell胆按钮的代理方法
- (void)fbBetCellDidClickDanBtn:(UIButton *)btn inCell:(YZFbBetCell *)cell
{
    btn.isSelected ? _selDanBtnCount ++ : _selDanBtnCount --;
    int index = [[self.selectedFreeWayTags firstObject] intValue];
    int m = [[self.currentFreeWayTitles[index] substringToIndex:1] intValue];//根据第一个判断
    if(_selDanBtnCount == m - 1)//胆按钮选择的个数最多是m串1的m-1
    {
        //让其他胆按钮失效 不可选
        for(YZFbBetCellStatus *status in self.statusArray)
        {
            if(status.danBtnState != danBtnStateSelected)
            {
                status.danBtnState = danBtnStateDisabled;
            }
        }
    }else//可选
    {
        //让其他失效胆按钮，enabel
        for(YZFbBetCellStatus *status in self.statusArray)
        {
            if(status.danBtnState == danBtnStateDisabled)
            {
                status.danBtnState = danBtnStateNormal;
            }
        }
    }
    [self.tableView reloadData];
    waitingView
    [self computeBetCountAndPrizeRange];
}
//cell左上角删除按钮的代理方法
- (void)fbBetCellDidClickDeleteBtn:(UIButton *)btn inCell:(YZFbBetCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YZFbBetCellStatus *status = self.statusArray[indexPath.row];//取出cell的数据
    [status.matchInfosStatus deleteAllSelBtn];
    //先删除数据源
    [self.statusArray removeObjectAtIndex:indexPath.row];
    //删除cell
    NSArray *arr = [NSArray arrayWithObject:indexPath];
    [self.tableView deleteRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
    [self changeTableViewHeight];
    [self refreshPassWayTags];
    [self setPassWayBtnTitle];
    
    waitingView
    
    [self computeBetCountAndPrizeRange];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self setDanBtnState];
}
//cell赔率信息按钮的代理方法
- (void)fbBetCellDidClickOddsInfoBtn:(UIButton *)btn inBtnsView:(UIView *)btnsView inCell:(YZFbBetCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YZFbBetCellStatus *status = self.statusArray[indexPath.row];//取出cell的数据
    status.btnSelectedCount --;
    YZMatchInfosStatus *matchInfosStatus = status.matchInfosStatus;
    NSMutableArray * selMatchArr = matchInfosStatus.selMatchArr[btnsView.tag/100];
    NSInteger deleteIndex = -1;
    for (YZFootBallMatchRate * rate in selMatchArr) {
        if (rate.info != nil && rate.info.length != 0) {
            if ([btn.titleLabel.text rangeOfString:rate.info].location != NSNotFound) {
                deleteIndex = [selMatchArr indexOfObject:rate];
            }
        }
    }
    if (deleteIndex != -1) {
        [selMatchArr removeObjectAtIndex:deleteIndex];
    }
    matchInfosStatus.selMatchArr[btnsView.tag/100] = selMatchArr;
    //重新赋值，计算cell的高度
    status.matchInfosStatus = matchInfosStatus;
    
    //查看是否已被全部删除
    NSArray *indexArray = [NSArray arrayWithObject:indexPath];
    if(![status.matchInfosStatus isHaveSelected])
    {
        //都没有按钮的标题
        [self.statusArray removeObjectAtIndex:indexPath.row];//先删除数据源
        [self.tableView deleteRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];//删除cell
        [self refreshPassWayTags];
    }else
    {
        self.statusArray[indexPath.row] = status;
        //刷新对应cell
        [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];//刷新所在cell
    }
    [self changeTableViewHeight];
    [self setPassWayBtnTitle];
    
    [self setDanBtnState];
    
    waitingView
    [self computeBetCountAndPrizeRange];
}
- (void)setDanBtnState
{
    _selDanBtnCount = 0;
    if(self.statusArray.count > 2 && [self hasFreeWayIndexLittleThenStatusArrayCount])//
    {
        //可以选择胆了
        for(YZFbBetCellStatus *status in self.statusArray)
        {
            status.danBtnState = danBtnStateNormal;
        }
    }else
    {
        for(YZFbBetCellStatus *status in self.statusArray)
        {
            status.danBtnState = danBtnStateDisabled;
        }
    }
    [self.tableView reloadData];
}
- (BOOL)hasFreeWayIndexLittleThenStatusArrayCount
{
    BOOL b = NO;
    YZPlayPassWay *playPassWay = [[self getFreeWayIndexArray] firstObject];//元素是m串1的m，类型NSNumber
    if(playPassWay.number < self.statusArray.count)//比如选的最左边的是2串1，场数是3，2<3,则说明可以选择胆
    {
        if (_selectedMoreWayTags.count == 0) {//胆拖不支持多串投注
            b = YES;
        }
    }
    return b;
}
- (void)refreshPassWayTags
{
    [self.selectedFreeWayTags removeAllObjects];
    [self.selectedMoreWayTags removeAllObjects];
    if(self.currentFreeWayTitles.count > 0)
    {
        [self.selectedFreeWayTags addObject:@(self.currentFreeWayTitles.count-1)];
    }
}
- (BOOL)hasBtnTitleWithTitleArray:(NSMutableArray *)titleArray
{
    //返回yes，有按钮标题
    if(!titleArray) return NO;//为空
    BOOL b = NO;
    for(YZFootBallMatchRate *rate in titleArray)
    {
        if(![rate.value isEqualToString:@""])
        {
            b = YES;
            break;
        }
    }
    return b;
}
#pragma mark - 计算注数和奖金
- (void)computeBetCountAndPrizeRange
{
    __block NSMutableArray *muArr = [NSMutableArray array];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSMutableArray *danArray;
        if(_selDanBtnCount > 0)
        {
            danArray = [NSMutableArray array];
            for(YZFbBetCellStatus *status in self.statusArray)
            {
                if(status.danBtnState == danBtnStateSelected)
                {
                    [danArray addObject:status];
                }
            }
        }
        muArr = [YZFootBallTool computeBetCountAndPrizeRangeWithBetArray:self.statusArray playWays:[self getPlayWayIndexArray] danArray:danArray selectedPlayType:_selectedPlayType];
        YZLog(@"op1 currentThread = %@",[NSThread currentThread]);
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        
        //回到主线程更新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self setAmountLabelText:[[muArr firstObject] intValue]];
            
            _minPrize = [[muArr objectAtIndex:1] floatValue];
            _maxPrize = [[muArr objectAtIndex:2] floatValue];
            [self setBonusLabelTextWithMinPrize:_minPrize maxPrize:_maxPrize];
            YZLog(@"op2 currentThread = %@",[NSThread currentThread]);
        });
    }];
    [op2 addDependency:op1];//先算，后更新UI
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSArray *opArr = [NSArray arrayWithObjects:op1,op2, nil];
    [queue addOperations:opArr waitUntilFinished:NO];
}
- (NSArray *)getPlayWayIndexArray
{
    NSMutableArray * playArray = [NSMutableArray array];
    NSArray * moreWayIndexArray = [self getMoreWayIndexArray];
    NSArray * freeWayIndexArray = [self getFreeWayIndexArray];
    [playArray addObjectsFromArray:freeWayIndexArray];
    [playArray addObjectsFromArray:moreWayIndexArray];
    return playArray;
}
- (NSArray *)getMoreWayIndexArray
{
    NSMutableArray *moreWayIndexArray = [NSMutableArray array];
    if (self.selectedMoreWayTags.count > 0) {//有选择多串过关方式
        NSDictionary * morePassWayDic = [YZFootBallTool getMorePassWayDict];
        for (NSNumber * num in self.selectedMoreWayTags) {
            NSString * morePassWayKey = _moreWayTitles[[num intValue]];
            NSArray * morePassWayArr = [morePassWayKey componentsSeparatedByString:@"串"];
            NSString * morePassWayValue = morePassWayDic[morePassWayKey];//3,1,0,0,0,0,0
            NSArray * freePassWayNums = [morePassWayValue componentsSeparatedByString:@","];
            //把多串过关拆分成自由过关
            for (int i = 0; i < freePassWayNums.count; i++) {
                int freePassWayNum = [freePassWayNums[i] intValue];
                if (freePassWayNum > 0) {
                    YZPlayPassWay * playPassWay = [[YZPlayPassWay alloc]init];
                    playPassWay.index = [[morePassWayArr firstObject] intValue];
                    playPassWay.number = i + 2;
                    playPassWay.name = morePassWayKey;
                    [moreWayIndexArray addObject:playPassWay];
                }
            }
        }
    }
    return [moreWayIndexArray copy];
}
- (NSArray *)getFreeWayIndexArray//有多少个自由过关方式，元素是m串1的m值
{
    NSMutableArray *freeWayIndexArray = [NSMutableArray arrayWithCapacity:self.selectedFreeWayTags.count];
    for(NSNumber *num in self.selectedFreeWayTags)
    {
        YZPlayPassWay * playPassWay = [[YZPlayPassWay alloc]init];
        playPassWay.index = [num intValue] + 2;
        playPassWay.number = [num intValue] + 2;
        playPassWay.name = _freeWayTitles[[num intValue]];
        [freeWayIndexArray addObject:playPassWay];
    }
    return [freeWayIndexArray copy];
}

#pragma mark - 设置奖金范围label的文字 bonusLabel
- (void)setBonusLabelTextWithMinPrize:(float)minPrize maxPrize:(float)maxPrize
{
    float multiple = [self.multipleTextField.text floatValue];
    multiple = multiple > 0 ? multiple : 1;
    NSString *title = [NSString stringWithFormat:@"奖金范围：%0.2f 元 - %0.2f 元",minPrize * 2 * multiple,maxPrize * 2 * multiple];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:title];
    NSRange maoRange = [title rangeOfString:@"："];
    NSRange yuanRange = [title rangeOfString:@"元"];
    NSRange ganRange = [title rangeOfString:@"-"];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(maoRange.location + 1, yuanRange.location - maoRange.location-1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(ganRange.location + 2, title.length - ganRange.location - 4)];
    self.bonusLabel.attributedText = attStr;
}
#pragma mark - 设置总金额注数label的文字 bonusLabel
- (void)setAmountLabelText:(int)betCount
{
    _betCount = betCount;
    float multiple = [self.multipleTextField.text floatValue];
    multiple = multiple > 0 ? multiple : 1;
    self.amountMoney = _betCount * 2 * multiple;
    NSString *temp = [NSString stringWithFormat:@"共%d注%0.2f元",betCount,self.amountMoney];
    
    NSRange range1 = [temp rangeOfString:@"共"];
    NSRange range2 = [temp rangeOfString:@"注"];
    NSRange range3 = [temp rangeOfString:@"元"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temp];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(range2.location + 1, range3.location - range2.location - 1)];
    self.amountLabel.attributedText = attStr;
}
#pragma mark - 过关方式按钮点击
- (void)passWayBtnClick:(UIButton *)btn
{
    if(self.statusArray.count < 2)
    {
        [MBProgressHUD showError:@"请至少选择2场比赛"];
        return;
    }
    //底部背景遮盖
    UIView *passWayBackView = [[UIView alloc] init];
    self.passWayBackView = passWayBackView;
    passWayBackView.backgroundColor = YZColor(0, 0, 0, 0.4);
    passWayBackView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.tabBarController.view addSubview:passWayBackView];
    //过关view
    UIView *passWayView = [[UIView alloc] init];
    passWayView.backgroundColor = [UIColor whiteColor];
    passWayView.layer.cornerRadius = 5;
    passWayView.clipsToBounds = YES;
    CGFloat passWayViewW = screenWidth - 40;
    [passWayBackView addSubview:passWayView];
    
    int maxColums = 4;
    UIButton *lastBtn;
    CGFloat btnH = 30;
    CGFloat btnW = (passWayViewW - (maxColums + 1) * padding) / maxColums;
    UILabel *lastLabel;
    CGFloat labelH = 25;
    UIScrollView *scrollView;
    for(int i = 0;i < 2;i++)//2个label
    {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        label.backgroundColor = YZColor(240, 240, 240, 1);
        label.textColor = YZBlackTextColor;
        label.frame =CGRectMake(0, 0, passWayViewW, labelH);
        lastLabel = label;
        [passWayView addSubview:label];
        if(i == 0)
        {
            label.text = @"  自由过关";
            NSMutableArray *muArr = [NSMutableArray array];
            NSArray *titles = self.currentFreeWayTitles;
            for(int i = 0;i < titles.count;i++)//自由过关下面的按钮
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [muArr addObject:btn];
                lastBtn = btn;
                btn.tag = i;
                btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
                btn.layer.borderWidth = 0.5;
                btn.layer.borderColor = YZColor(0, 0, 0, 0.2).CGColor;
                [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
                [btn setTitleColor:YZGrayTextColor forState:UIControlStateDisabled];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
                [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
                [btn setTitle:titles[i] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(freePassWayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                CGFloat btnX = padding + (i % maxColums) * (btnW + padding);
                CGFloat btnY = CGRectGetMaxY(lastLabel.frame) + padding + (i / maxColums) * (btnH + padding);
                btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
                [passWayView addSubview:btn];
                //让按钮不可点
                if(_selDanBtnCount > 2 && i <= _selDanBtnCount - 2)
                {
                    btn.enabled = NO;
                }
            }
            _currentFreeWayBtns = [muArr copy];
            //选中已选的
            if(_currentFreeWayBtns.count)
            {
                for(int i = 0;i < self.selectedFreeWayTags.count;i ++)
                {
                    NSNumber *index = self.selectedFreeWayTags[i];
                    UIButton *btn = _currentFreeWayBtns[[index intValue]];
                    btn.selected = YES;
                }
            }
        }else if (i == 1)
        {
            if(self.statusArray.count < 3) break;
            label.text = @"  多串过关";
            label.y = CGRectGetMaxY(lastBtn.frame) + padding;
            scrollView = [[UIScrollView alloc] init];
            CGFloat scrollViewY = CGRectGetMaxY(label.frame);
            CGFloat scrollViewH = 160;
            scrollView.frame = CGRectMake(0, scrollViewY, passWayViewW, scrollViewH);
            [passWayView addSubview:scrollView];
            
            if ([self haveSelDan]) {//有被选中的胆,提示多串过关不支持胆拖投注
                UILabel * promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, passWayViewW, 30)];
                promptLabel.text = @"胆拖不支持多串过关投注";
                promptLabel.textAlignment = NSTextAlignmentCenter;
                promptLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
                promptLabel.textColor = YZGrayTextColor;
                [scrollView addSubview:promptLabel];
                scrollView.height = CGRectGetMaxY(promptLabel.frame) + 20;
                break;
            }
            
            //取出相应地多串过关标题
            NSArray *titles = self.currentMoreWayTitles;
            NSMutableArray *muArr = [NSMutableArray array];
            for(int i = 0;i < titles.count;i++)//多串过关下面的按钮
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [muArr addObject:btn];
                lastBtn = btn;
                btn.tag = i;
                btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
                btn.layer.borderWidth = 0.5;
                btn.layer.borderColor = YZColor(0, 0, 0, 0.2).CGColor;
                [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
                [btn setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
                [btn setTitle:titles[i] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(morePassWayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                CGFloat btnX = padding / 2 + (i % maxColums) * (btnW + padding);
                CGFloat btnY = padding + (i / maxColums) * (btnH + padding);
                btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
                [scrollView addSubview:btn];
            }
            _currentMoreWayBtns = [muArr copy];
            //选中已选的
            if(_currentMoreWayBtns.count)
            {
                for(int i = 0;i < self.selectedMoreWayTags.count;i ++)
                {
                    NSNumber *index = self.selectedMoreWayTags[i];
                    UIButton *btn = _currentMoreWayBtns[[index intValue]];
                    btn.selected = YES;
                }
            }
            scrollView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetMaxY(lastBtn.frame), 0);
            //重新设置scrollview的高度
            if((CGRectGetMaxY(lastBtn.frame) + padding + btnH) < scrollViewH)
            {
                scrollView.height = CGRectGetMaxY(lastBtn.frame) + btnH;
            }
        }
    }
    
    //确认和取消按钮
    NSArray *confirmTitles = [NSArray arrayWithObjects:@"取消",@"确认", nil];
    UIButton *confirmBtn;
    CGFloat btnY = 0;
    if(scrollView)
    {
        btnY = CGRectGetMaxY(scrollView.frame) + padding;
    }else//没有scrollview
    {
        btnY = CGRectGetMaxY(lastBtn.frame) + padding;
    }
    for(int i = 0;i < 2;i++)
    {
        UIButton *btn = [[UIButton alloc] init];
        confirmBtn = btn;
        btn.tag = i;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = YZColor(0, 0, 0, 0.4).CGColor;
        CGFloat btnW = (passWayViewW - 3 * padding) / 2;
        CGFloat btnX = padding + i * (btnW + padding);

        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        [btn setTitle:confirmTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"ft_btn_pressed"] forState:UIControlStateHighlighted];
        [btn setBackgroundImage:[UIImage resizedImageWithName:@"ft_btn_pressed"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(confirmClick:) forControlEvents:UIControlEventTouchUpInside];
        [passWayView addSubview:btn];
    }
    
    CGFloat passWayViewH = CGRectGetMaxY(confirmBtn.frame) + padding;
    passWayView.bounds = CGRectMake(0, 0, passWayViewW, passWayViewH);
    passWayView.center = self.view.center;
    
    passWayView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        passWayView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
//有被选中的胆
- (BOOL)haveSelDan
{
    BOOL haveDan = NO;
    for(YZFbBetCellStatus *status in self.statusArray)
    {
        if (status.danBtnState == danBtnStateSelected) {
            haveDan = YES;
        }
    }
    return haveDan;
}
- (void)freePassWayBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}
- (void)morePassWayBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}
- (void)confirmClick:(UIButton *)btn
{
    [self removepassWayBackView];
    if(btn.tag == 1)//确认按钮
    {
        self.selectedFreeWayTags = [self getSelectedPassWayTagsFromBtns:_currentFreeWayBtns];
        self.selectedMoreWayTags = [self getSelectedPassWayTagsFromBtns:_currentMoreWayBtns];
        [self setPassWayBtnTitle];//设置过关方式按钮的标题
        //如果选有多串过关 则不能选择胆拖投注
        [self setDanBtnState];
        waitingView
        [self computeBetCountAndPrizeRange];
    }
}
//获取被选中的按钮tag数组
- (NSMutableArray *)getSelectedPassWayTagsFromBtns:(NSArray *)btns
{
    //扫描自由过关按钮数组
    NSMutableArray *selectedFreeWayTags = [NSMutableArray array];
    for(UIButton *btn in btns)
    {
        if(btn.isSelected)
        {
            [selectedFreeWayTags addObject:@(btn.tag)];
        }
    }
    return selectedFreeWayTags;
}
//设置过关方式的显示
- (void)setPassWayBtnTitle
{
    NSString *title = nil;
    //有被选中的过关方式
    if(self.selectedFreeWayTags.count > 1 || self.selectedMoreWayTags.count > 1 || (self.selectedFreeWayTags.count + self.selectedMoreWayTags.count > 1))
    {
        if(self.selectedFreeWayTags.count > 0)
        {
            NSNumber *index = [self.selectedFreeWayTags firstObject];
            title = _freeWayTitles[[index intValue]];
        }else
        {
            NSNumber *index = [self.selectedMoreWayTags firstObject];
            title = _moreWayTitles[[index intValue]];
        }
        [self.passWayBtn setTitle:[NSString stringWithFormat:@"%@...",title] forState:UIControlStateNormal];
    }else if(self.selectedFreeWayTags.count == 0 && self.selectedMoreWayTags.count == 0)
    {
        [self.passWayBtn setTitle:@"过关方式" forState:UIControlStateNormal];
    }else
    {
        if(self.selectedFreeWayTags.count)
        {
            NSNumber *index = [self.selectedFreeWayTags firstObject];
            title = _freeWayTitles[[index intValue]];
        }else
        {
            NSNumber *index = [self.selectedMoreWayTags firstObject];
            title = _moreWayTitles[[index intValue]];
        }
        [self.passWayBtn setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
    }
}
#pragma mark - 投注按钮点击
- (void)betBtnClick
{
    int minMatchCount = 2;
    if (_selectedPlayType >= 7) {
        minMatchCount = 1;
    }
    if(self.statusArray.count < minMatchCount)
    {
        [MBProgressHUD showError:[NSString stringWithFormat:@"请至少选择%d场比赛",minMatchCount]];
        return;
    }
    if(self.amountMoney > 20000)
    {
        [MBProgressHUD showError:@"单注金额不能超过2万元"];
        return;
    }
    if(!UserId)//没登录
    {
        YZLoginViewController *loginVc = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }else
    {
        [self loadUserInfo];//刷新个人信息
    }
}
- (void)loadUserInfo
{
    if (!UserId)
    {
        [MBProgressHUD hideHUDForView:self.view];
        return;
    }
    waitingView;
    NSDictionary *dict = @{
                           @"cmd":@(8006),
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if (SUCCESS) {
            //存储用户信息
            YZUser *user = [YZUser objectWithKeyValues:json];
            [YZUserDefaultTool saveUser:user];
            [self getConsumableList];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"账户error");
    }];
}
- (void)getConsumableList
{
    NSDictionary * orderDic = @{@"money":@(self.amountMoney * 100),
                                @"game":self.gameId
                                };
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"order":orderDic,
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithURL:BaseUrlCoupon(@"/getConsumableList") params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (SUCCESS) {;
            NSArray * respCouponList = json[@"respCouponList"];
            if (respCouponList.count == 0) {
                [self showComfirmPayAlertView];
            }else
            {
                [self gotoChooseVoucherVC];
            }
        }else
        {
            [self showComfirmPayAlertView];
        }
    }failure:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
     }];
}
- (void)gotoChooseVoucherVC
{
    //选择彩券
    YZChooseVoucherViewController * chooseVoucherVC = [[YZChooseVoucherViewController alloc]init];
    chooseVoucherVC.gameId = self.gameId;
    chooseVoucherVC.amountMoney = self.amountMoney;
    chooseVoucherVC.betCount = self.betCount;
    chooseVoucherVC.multiple = [self.multipleTextField.text intValue];
    NSString * betType;
    if (_selectedPlayType >= 7) {//单关1串1
        betType = @"11";
    }else
    {
        betType = [self getBetType];
    }
    chooseVoucherVC.betType = betType;
    chooseVoucherVC.numbers = [self getNumbers];
    chooseVoucherVC.playType = _playType;
    chooseVoucherVC.isJC = YES;
    [self.navigationController pushViewController:chooseVoucherVC animated:YES];
}
- (void)showComfirmPayAlertView
{
    BOOL hasEnoughMoney = [YZTool hasEnoughMoneyWithAmountMoney:self.amountMoney];
    if (hasEnoughMoney) {
        NSString * message = [YZTool getAlertViewTextWithAmountMoney:self.amountMoney];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"支付确认" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getCurrentTermData];//当前期次的信息
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }else
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"余额不足" message:@"对不起，余额不足，请充值。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gotoRecharge];
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)gotoRecharge
{
    YZRechargeListViewController *rechargeVc = [[YZRechargeListViewController alloc] init];
    rechargeVc.isOrderPay = YES;
    [self.navigationController pushViewController:rechargeVc animated:YES];
}
//获取当前期信息
- (void)getCurrentTermData
{
    [MBProgressHUD showMessage:text_gettingCurrentTerm toView:self.view];
    NSDictionary *dict = @{
                           @"cmd":@(8028),
                           @"gameId":self.gameId
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"getCurrentTermData - json = %@",json);
        if(SUCCESS)
        {
            if(!Jump)//不跳
            {
                [self comfirmPay];//支付
            }else //跳转网页
            {
                [MBProgressHUD hideHUDForView:self.view];
                NSNumber *multiple = [NSNumber numberWithInt:[self.multipleTextField.text intValue]];//投多少倍
                NSNumber *amount = [NSNumber numberWithInt:(int)self.amountMoney * 100];
                NSString *number = [self getNumbers];
#if JG
                NSString * mcpStr = @"EZmcp";
#elif ZC
                NSString * mcpStr = @"ZCmcp";
#elif CS
                NSString * mcpStr = @"CSmcp";
#endif
                NSString *param = [NSString stringWithFormat:@"userId=%@&gameId=%@&multiple=%@&amount=%@&number=%@&payType=%@&id=%@&channel=%@&childChannel=%@&version=%@&playType=%@&betType=%@&remark=%@",UserId,self.gameId,multiple,amount,[number URLEncodedString],@"ACCOUNT",@"1407305392008",mainChannel,childChannel,[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],_playType,[self getBetType],mcpStr];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",jumpURLStr,param]];
                YZLog(@"url = %@",url);
                
                [[UIApplication sharedApplication] openURL:url];
            }
        }else
        {
            ShowErrorView
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"获取当前期信息失败"];
        YZLog(@"getCurrentTermData - error = %@",error);
    }];
}
#pragma  mark - 确认支付
- (void)comfirmPay//支付接口
{
    [MBProgressHUD showMessage:text_paying toView:self.view];
    NSNumber *multiple = [NSNumber numberWithInt:[self.multipleTextField.text intValue]];
    NSNumber *amount = [NSNumber numberWithInt:(int)self.amountMoney * 100];
    NSString * betType;
    if (_selectedPlayType >= 7) {//单关1串1
        betType = @"11";
    }else
    {
        betType = [self getBetType];
    }
    NSDictionary *dict = @{
                           @"cmd":@(8034),
                           @"userId":UserId,
                           @"gameId":self.gameId,
                           @"multiple":multiple,
                           @"amount":amount,
                           @"payType":@"ACCOUNT",
                           @"number":[self getNumbers],
                           @"playType":_playType,
                           @"betType":betType,
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];//隐藏正在支付的弹框
        if(SUCCESS)
        {
            //清空所有数据
            [self deleteAllStatus];
            //支付成功控制器
            YZFbBetSuccessViewController *betSuccessVc = [[YZFbBetSuccessViewController alloc] initWithAmount:[amount floatValue] bonus:[json[@"balance"] floatValue] isJC:YES];
            //跳转
            [self.navigationController pushViewController:betSuccessVc animated:YES];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];//隐藏正在支付的弹框
        YZLog(@"error = %@",error);
    }];
}
- (void)deleteAllStatus
{
    for(YZFbBetCellStatus *status in self.statusArray)
    {
        [status.matchInfosStatus deleteAllSelBtn];
    }
    [self.statusArray removeAllObjects];
    [self computeBetCountAndPrizeRange];
}
- (NSMutableString *)getBetType
{
    NSMutableString *betTypes = [NSMutableString string];
    for(NSNumber *freeWayTag in self.selectedFreeWayTags)
    {
        NSString *freeWay = _freeWayTitles[[freeWayTag intValue]];
        NSString * betType = [freeWay stringByReplacingOccurrencesOfString:@"串" withString:@""];
        [betTypes appendString:betType];
        [betTypes appendString:@","];
    }
    for(NSNumber *moreWayTag in self.selectedMoreWayTags)
    {
        NSString *moreWay = _moreWayTitles[[moreWayTag intValue]];
        NSString * betType = [moreWay stringByReplacingOccurrencesOfString:@"串" withString:@""];
        [betTypes appendString:betType];
        [betTypes appendString:@","];
    }
    if (betTypes.length > 1) {
        [betTypes deleteCharactersInRange:NSMakeRange(betTypes.length - 1, 1)];
    }
    
    return  betTypes;
}
#pragma mark - 拼接比赛信息的字符串
/* number
 胆：$
 纯的让或非让格式（含胆）：$02|201407244001|3,1,0
 混合格式（含胆）：$02|201407244001|3,1,0&01|201407244001|3,1,0
 */
- (NSMutableString *)getNumbers
{
    NSMutableString *numbers = [NSMutableString string];
    for(YZFbBetCellStatus *status in self.statusArray)
    {
        if(status.btnSelectedCount > 0)
        {
            BOOL isDan = (status.danBtnState == danBtnStateSelected);
            //把二选一转化成让球和非让球
            NSMutableArray * selMatchArray = [YZFootBallTool changeCN06ToCN01AndCN02BySelMatchArray:status.matchInfosStatus.selMatchArr];
            for (NSMutableArray * selMatchArr in selMatchArray) {
                NSString *number = [self getNumberFromOddsInfoArray:selMatchArr withCode:status.code];
                if(isDan && number.length > 0) [numbers appendString:@"$"];
                [numbers appendString:number.length > 0 ? [NSString stringWithFormat:@"%@",number] : @""];
                if(number.length > 0) [numbers appendString:@"&"];
            }
            if(numbers.length > 0) [numbers deleteCharactersInRange:NSMakeRange(numbers.length-1, 1)];//删除最后一个&
            if(numbers.length > 0) [numbers appendString:@";"];
        }
    }
    if(numbers.length > 0) [numbers deleteCharactersInRange:NSMakeRange(numbers.length-1, 1)];//删除最后一个分号
    
    YZLog(@"numbers = %@",numbers);
    return  numbers;
}
//返回的格式是"02|201407244001|3,1,0"
- (NSMutableString *)getNumberFromOddsInfoArray:(NSMutableArray *)oddsInfoArray withCode:(NSString *)code
{
    if(!oddsInfoArray || oddsInfoArray.count == 0) return nil;
    NSString *oddsInfo = [self getOddsInfoFromArray:oddsInfoArray];
    if(oddsInfo.length == 0) return nil;
    NSMutableString *number = [NSMutableString string];
    YZFootBallMatchRate *rate = [oddsInfoArray firstObject];
    NSString *playType = self.playTypeDict[rate.CNType];

    [number appendString:playType];
    [number appendString:@"|"];
    [number appendString:code];
    [number appendString:@"|"];
    [number appendString:oddsInfo];
    
    //设置playType
    if(!_playType)//空，直接赋值
    {
        _playType = playType;
    }else
    {
        if(![_playType isEqualToString:playType])//不相等，说明是混合投注
        {
            _playType = @"06";
        }
    }
    
    return number;
}
//返回的格式是"3,1,0"
- (NSMutableString *)getOddsInfoFromArray:(NSMutableArray *)oddsInfoArray
{
    if(!oddsInfoArray || oddsInfoArray.count == 0) return nil;
    NSMutableString *oddsInfo = [NSMutableString string];
    YZFootBallMatchRate *rate = [oddsInfoArray firstObject];
    //让球和非让
    if ([rate.CNType isEqualToString:@"CN01"] || [rate.CNType isEqualToString:@"CN02"]) {
        for (YZFootBallMatchRate * rate in oddsInfoArray) {
            if ([rate.info isEqualToString:@"胜"]) {
                [oddsInfo appendString:@"3,"];
            }else if ([rate.info isEqualToString:@"平"])
            {
                [oddsInfo appendString:@"1,"];
            }else if ([rate.info isEqualToString:@"负"])
            {
                [oddsInfo appendString:@"0,"];
            }
        }
    }else if ([rate.CNType isEqualToString:@"CN03"])//比分
    {
        for (YZFootBallMatchRate * rate in oddsInfoArray) {
            if ([rate.info rangeOfString:@":"].location != NSNotFound) {
                NSString * oddsInfo1 = [rate.info stringByReplacingOccurrencesOfString:@":" withString:@""];
                [oddsInfo appendString:[NSString stringWithFormat:@"%@,",oddsInfo1]];
            }else if ([rate.info rangeOfString:@"胜其他"].location != NSNotFound)
            {
                [oddsInfo appendString:@"90,"];
            }else if ([rate.info rangeOfString:@"平其他"].location != NSNotFound)
            {
                [oddsInfo appendString:@"99,"];
            }else if ([rate.info rangeOfString:@"负其他"].location != NSNotFound)
            {
                [oddsInfo appendString:@"09,"];
            }
        }
    }else if ([rate.CNType isEqualToString:@"CN04"])//进球数
    {
        for (YZFootBallMatchRate * rate in oddsInfoArray) {
            NSString * oddsInfo1  = [rate.info stringByReplacingOccurrencesOfString:@"+" withString:@""];
            [oddsInfo appendString:[NSString stringWithFormat:@"%@,",oddsInfo1]];
        }
    }else if ([rate.CNType isEqualToString:@"CN05"])//半全场
    {
        for (YZFootBallMatchRate * rate in oddsInfoArray) {
            NSString * oddsInfo1  = [rate.info stringByReplacingOccurrencesOfString:@"胜" withString:@"3"];
            NSString * oddsInfo2  = [oddsInfo1 stringByReplacingOccurrencesOfString:@"平" withString:@"1"];
            NSString * oddsInfo3  = [oddsInfo2 stringByReplacingOccurrencesOfString:@"负" withString:@"0"];
            [oddsInfo appendString:[NSString stringWithFormat:@"%@,",oddsInfo3]];
        }
    }
    if(oddsInfo.length > 0)
    [oddsInfo deleteCharactersInRange:NSMakeRange(oddsInfo.length - 1, 1)];//删除最后一个,
    return oddsInfo;
}
#pragma mark - 改变tableView的高度
- (void)changeTableViewHeight
{
    //判断所以cell的高度之和是否小于tableView的最高高度
    CGFloat allCellH = 0;
    for(YZFbBetCellStatus *status in _statusArray)
    {
        allCellH += status.cellH;
    }
    [UIView beginAnimations:@"changeTableViewHeight" context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if(allCellH < _maxTableViewH)
    {
        self.tableView.height = allCellH;
        self.whiteSawToothImageView.height = allCellH + padding;
    }else
    {
        self.tableView.height = _maxTableViewH;
        self.whiteSawToothImageView.height = _maxTableViewH + padding;
    }
    [UIView commitAnimations];
}
#pragma mark - 键盘监听
//键盘将隐藏调用
- (void)keyboardWillHide:(NSNotification *)note
{
    if([self.multipleTextField.text isEqualToString:@""])
    {
        self.multipleTextField.text = @"1";
    }
}
#pragma mark - 按钮点击事件
- (void)removepassWayBackView
{
    [self.passWayBackView removeFromSuperview];
}
//继续选择添加赛事按钮点击
- (void)goSelectBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 初始化
//每次get都是最新的数据
- (NSMutableArray *)currentFreeWayTitles
{
    if (_currentFreeWayTitles == nil) {
        _currentFreeWayTitles = [NSMutableArray array];
    }
    if(self.statusArray.count >= 2)
    {
        if(self.statusArray.count > maxWayCount) {
            _currentFreeWayTitles = [[_freeWayTitles subarrayWithRange:NSMakeRange(0, maxWayCount - 1)] mutableCopy];
        }else
        {
            _currentFreeWayTitles = [[_freeWayTitles subarrayWithRange:NSMakeRange(0, self.statusArray.count - 1)] mutableCopy];
        }
    }else
    {
        _currentFreeWayTitles = [NSMutableArray array];
    }
    return _currentFreeWayTitles;
}
//每次get都是最新的数据
- (NSArray *)currentMoreWayTitles
{
    if(_currentMoreWayTitles == nil)
    {
        _currentMoreWayTitles = [NSMutableArray array];
    }
    
    if(self.statusArray.count >= maxWayCount)
    {
        for(int i = 0;i < _moreWayTitles.count;i++)
        {
            NSString *str = _moreWayTitles[i];
            if([str hasPrefix:[NSString stringWithFormat:@"%d",maxWayCount]])
            {
                _currentMoreWayTitles = [[_moreWayTitles subarrayWithRange:NSMakeRange(0, i + 1)] mutableCopy];
            }
        }
    }else
    {
        for(int i = 0;i < _moreWayTitles.count;i++)
        {
            NSString *str = _moreWayTitles[i];
            if([str hasPrefix:[NSString stringWithFormat:@"%ld",(unsigned long)self.statusArray.count]])
            {
                _currentMoreWayTitles = [[_moreWayTitles subarrayWithRange:NSMakeRange(0, i + 1)] mutableCopy];
            }
        }
    }
    return _currentMoreWayTitles;
}
- (NSMutableArray *)selectedFreeWayTags//数组元素是 _freeWayTitles 的索引
{
    if(_selectedFreeWayTags == nil)
    {
        _selectedFreeWayTags = [NSMutableArray array];
        NSInteger index;
        if (self.statusArray.count > maxWayCount) {
            index = maxWayCount - 2;
        }else
        {
            index = self.statusArray.count - 2;
        }
        if(index >= _freeWayTitles.count)
        {
            index = _freeWayTitles.count - 1;
        }
        _selectedFreeWayTags = [NSMutableArray arrayWithObject:@(index)];
    }
    return _selectedFreeWayTags;
}
- (NSMutableArray *)selectedMoreWayTags
{
    if(_selectedMoreWayTags == nil)
    {
        _selectedMoreWayTags = [NSMutableArray array];
    }
    return _selectedMoreWayTags;
}
- (void)multipleBtnClick:(UIButton *)btn
{
    int multiple = [self.multipleTextField.text intValue];
    if(btn.tag == 0 && multiple != 1)//是减小按钮
    {
        multiple--;
    }else if(btn.tag == 1 && multiple != 99999)//增大按钮
    {
        multiple++;
    }
    self.multipleTextField.text = [NSString stringWithFormat:@"%d",multiple];
    
    //设置注数和钱
    [self setAmountLabelText:_betCount];
    
    //设置奖金
    [self setBonusLabelTextWithMinPrize:_minPrize maxPrize:_maxPrize];
}

- (NSDictionary *)playTypeDict
{
    if(_playTypeDict == nil)
    {
        _playTypeDict = @{@"CN01" : @"01",@"CN02" : @"02",@"CN03" : @"03",@"CN04" : @"04",@"CN05" : @"05"};
    }
    return _playTypeDict;
}
#pragma mark - 注销通知
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
