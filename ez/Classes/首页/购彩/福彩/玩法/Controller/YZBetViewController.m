//
//  YZBetViewController.m
//  ez
//
//  Created by apple on 14-9-12.
//  Copyright (c) 2014年 9ge. All rights reserved.
//  投注界面
#define margin 10

#import "YZBetViewController.h"
#import "YZBetCell.h"
#import "YZLoginViewController.h"
#import "YZBetSuccessViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "YZRechargeListViewController.h"
#import "YZValidateTool.h"
#import "YZBetTool.h"
#import "YZNavigationController.h"
#import "JSON.h"
#import "YZSmartBetViewController.h"
#import "YZChooseVoucherViewController.h"
#import "YZStartUnionBuyViewController.h"
#import "UIButton+YZ.h"

@interface YZBetViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *_playType;//游戏类型
    BOOL _termIdChanged;
    NSString *_changedTermId;//更换了得期次
}
@property (nonatomic, weak) UITextField *multipleTextField;//倍数输入框
@property (nonatomic, weak) UITextField *termTextField;//期数输入框
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) MJRefreshGifHeader * headerView;
@property (nonatomic, weak) UIView *multipleBackView;//投注倍数背景
@property (nonatomic, assign) int betCount;//注数
@property (nonatomic, assign) float amountMoney;//金额
@property (nonatomic, strong) NSMutableArray *ticketList;//请求参数的号码数组
@property (nonatomic, copy) NSString *currentTermId;//当前期
@property (nonatomic, weak) UIButton *zhuijiaBtn;//追加投注那妞
@property (nonatomic, weak) UIButton *winStopBtn;//中奖后停追按钮
@property (nonatomic, weak) UIImageView *backImageView1;
@property (nonatomic, weak) UIImageView *backImageView2;

@end

@implementation YZBetViewController

- (instancetype)initWithPlayType:(NSString *)playType
{
    if(self = [super init])
    {
        _playType = playType;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.tableView) {
        [self.tableView reloadData];
        [self computeAmountMoney];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [NSString stringWithFormat:@"%@投注",[YZTool gameIdNameDict][self.gameId]];
    [self setupChilds];//初始化子控件
    
    // 2.监听textView文字改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(multipleTextDidChange) name:UITextFieldTextDidChangeNotification object:self.multipleTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(termTextDidChange) name:UITextFieldTextDidChangeNotification object:self.termTextField];
    
    // 3.监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    //让本控制器支持摇动感应
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    
    //11选5的接受期次更改通知
    if([self.gameId isEqualToString:@"T05"] || [self.gameId isEqualToString:@"T61"] || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(termIdChangedNote:) name:TermIdChangedNote object:nil];
    }
}
- (void)termIdChangedNote:(NSNotification *)note
{
    NSString *currentTermId = note.object;
    _changedTermId = currentTermId;
    _termIdChanged = YES;
}
- (void)multipleTextDidChange
{
    if([self.multipleTextField.text intValue] > 99)
    {
        self.multipleTextField.text = @"99";
    }
    [self computeAmountMoney];
}
- (void)termTextDidChange
{
    int termCount = [self.termTextField.text intValue];
    if(termCount > 200)
    {
        self.termTextField.text = @"200";
    }
    [self computeAmountMoney];
}
- (void)keyboardWillHide:(NSNotification *)note
{
    if([self.multipleTextField.text isEqualToString:@""])
    {
        self.multipleTextField.text = @"1";
    }
    if([self.termTextField.text isEqualToString:@""])
    {
        self.termTextField.text = @"1";
    }
}
- (void)keyboardDidHide:(NSNotification *)note
{
    int termCount = [self.termTextField.text intValue];
    //设置中奖后停追按钮
    if(termCount == 1)
    {
        [self hiddenWinStopBtn];
    }else
    {
        [self showWinStopBtn];
    }
    if ([self.gameId isEqualToString:@"T01"]) {
        if(termCount == 1)
        {
            self.winStopBtn.hidden = YES;
        }else
        {
            self.winStopBtn.hidden = NO;
        }
    }
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZBetCell *cell = [YZBetCell cellWithTableView:tableView];
    cell.deleteBtn.tag = indexPath.row;
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.status = self.statusArray[indexPath.row];
    [self computeAmountMoney];
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZBetStatus *status = self.statusArray[indexPath.row];
    return status.cellH;
}

- (void)deleteBtnDidClick:(UIButton *)btn
{
    [YZStatusCacheTool deleteStatusWithTag:(int)btn.tag];
    [self.tableView reloadData];
    [self computeAmountMoney];
}

#pragma  mark - 机选号码
- (void)autoChoose
{
    //如果是双色球
    if ([self.gameId isEqualToString:@"F01"])
    {
        [YZBetTool autoChooseSsq];//机选双色球
    }else if ([self.gameId isEqualToString:@"F02"])//如果是福彩3D
    {
        [YZBetTool autoChoosefc];
    }else if ([self.gameId isEqualToString:@"F03"])//如果是七乐彩
    {
        [YZBetTool autoChooseQlc];
    }else if([self.gameId isEqualToString:@"T01"])//大乐透
    {
        [YZBetTool autoChooseDlt];
    }else if([self.gameId isEqualToString:@"T03"])//排列三
    {
        [YZBetTool autoChoosePls];
    }else if([self.gameId isEqualToString:@"T04"])//排列五
    {
        [YZBetTool autoChoosePlw];
    }else if([self.gameId isEqualToString:@"T02"])//七星彩
    {
        [YZBetTool autoChooseQxc];
    }else if([self.gameId isEqualToString:@"T05"] || [self.gameId isEqualToString:@"T61"] || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"])//11选5
    {
        [YZBetTool autoChooseS1x5WithPlayType:_playType andSelectedPlayTypeBtnTag:self.selectedPlayTypeBtnTag];
    }else if ([self.gameId isEqualToString:@"F04"])//快三
    {
        [YZBetTool autoChooseKsWithSelectedPlayTypeBtnTag:self.selectedPlayTypeBtnTag];
    }

    [self.tableView reloadData];//刷新数据
}
- (void)refreshViewBeginRefreshing
{
    [self.headerView endRefreshing];
    [self autoChoose];
}
#pragma mark - 初始化子控件
- (void)setupChilds
{
    //bar
#if JG
    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithIcon:@"back_btn_flat" highIcon:@"back_btn_flat" target:self action:@selector(back)];
#elif ZC
    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithIcon:@"black_back_bar" highIcon:@"black_back_bar" target:self action:@selector(back)];
#elif CS
    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithIcon:@"black_back_bar" highIcon:@"black_back_bar" target:self action:@selector(back)];
#elif RR
    self.navigationItem.leftBarButtonItem  = [UIBarButtonItem itemWithIcon:@"black_back_bar" highIcon:@"black_back_bar" target:self action:@selector(back)];
#endif
    
    //两个按钮
    CGFloat btnMaxY = 0;
    for(int i = 0;i < 2;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        CGFloat btnW = (screenWidth - 3 * 30) / 2;
        CGFloat btnH = 30;
        CGFloat btnX = 30 + i * (btnW + 30);
        CGFloat btnY = margin;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        btnMaxY = CGRectGetMaxY(btn.frame);
        [btn setBackgroundImage:[UIImage ImageFromColor:[UIColor whiteColor] WithRect:btn.bounds] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage ImageFromColor:YZColor(213, 213, 213, 1) WithRect:btn.bounds] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"bet_add_icon"] forState:UIControlStateNormal];
        if(i == 0)
        {
            [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"自选号码" forState:UIControlStateNormal];
        }else if(i == 1)
        {

            [btn addTarget:self action:@selector(autoChoose) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:@"机选一注" forState:UIControlStateNormal];
        }
        [btn setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:5];
        [self.view addSubview:btn];
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = btnH / 2;
    }
    
    UIView * promptView = [[UIView alloc]initWithFrame:CGRectMake(0, btnMaxY + margin, screenWidth, 27)];
    promptView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:promptView];
    
    UILabel *promptlabel = [[UILabel alloc] init];
    promptlabel.backgroundColor = [UIColor whiteColor];
    NSMutableAttributedString *labelAttStr = [[NSMutableAttributedString alloc] initWithString:@"选号列表（下拉列表区可机选号码）"];
    [labelAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, 4)];
    [labelAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(4, 12)];
    promptlabel.attributedText = labelAttStr;
    promptlabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    CGSize labelSize = [promptlabel.text sizeWithFont:promptlabel.font maxSize:CGSizeMake(screenWidth - 2 * YZMargin, 27)];
    promptlabel.frame = CGRectMake(YZMargin, 0, labelSize.width, promptView.height);
    [promptView addSubview:promptlabel];
    
    //底栏
    CGFloat bottomViewH = 49;
    CGFloat bottomViewY = screenHeight - bottomViewH - statusBarH - navBarH - [YZTool getSafeAreaBottom];
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomViewY, screenWidth, bottomViewH)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    //分割线
    UIView * bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    bottomLineView.backgroundColor = YZWhiteLineColor;
    [bottomView addSubview:bottomLineView];
    //发起合买、确认支付按钮
    CGFloat padding = 5;
    CGFloat confirmBtnH = 30;
    CGFloat confirmBtnW = 75;
    for(NSInteger i = 0;i < 2; i++)
    {
        YZBottomButton *confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        confirmBtn.tag = i;
        if(i == 0)
        {
            [confirmBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
            confirmBtn.frame = CGRectMake(YZMargin,(bottomViewH - confirmBtnH) / 2, confirmBtnW, confirmBtnH);
            [confirmBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(238, 238, 238, 1) WithRect:confirmBtn.bounds] forState:UIControlStateNormal];
            [confirmBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(216, 216, 216, 1) WithRect:confirmBtn.bounds] forState:UIControlStateHighlighted];
            confirmBtn.layer.borderWidth = 1;
            confirmBtn.layer.borderColor = YZColor(213, 213, 213, 1).CGColor;
            if([self.gameId isEqualToString:@"T05"] || [self.gameId isEqualToString:@"T61"] || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"])//11选5才有智能追号
            {
                [confirmBtn setTitle:@"智能追号" forState:UIControlStateNormal];
            }else
            {
                [confirmBtn setTitle:@"发起合买" forState:UIControlStateNormal];
            }
        }else
        {
            confirmBtn.frame = CGRectMake(screenWidth - confirmBtnW - 15, (bottomViewH - confirmBtnH) / 2, confirmBtnW, confirmBtnH);
            [confirmBtn setTitle:@"投注" forState:UIControlStateNormal];
        }
        [bottomView addSubview:confirmBtn];
        [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //注数和倍数和金额总数
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.textAlignment = NSTextAlignmentCenter;
    self.amountLabel = amountLabel;
    amountLabel.numberOfLines = 0;
    CGFloat amountLabelX = YZMargin + confirmBtnW + padding;
    CGFloat amountLabelW = screenWidth - 2 * amountLabelX;
    amountLabel.frame = CGRectMake(amountLabelX, 0, amountLabelW, bottomViewH);
    [self setBetCount:0];
    [bottomView addSubview:amountLabel];
    
    //倍数按钮的背景view
    UIView *multipleBackView = [[UIView alloc] init];
    self.multipleBackView = multipleBackView;
    CGFloat multipleBackViewH = 80;
    CGFloat multipleBackViewY = bottomViewY - multipleBackViewH + 31;
    if ([self.gameId isEqualToString:@"T01"]) {//大乐透显示加奖按钮
        multipleBackViewY -= 31;
    }
    multipleBackView.frame =  CGRectMake(0, multipleBackViewY, screenWidth, multipleBackViewH);
    multipleBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:multipleBackView];
    [self.view bringSubviewToFront:bottomView];
    //分割线
    UIView * multipleLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    multipleLineView.backgroundColor = YZWhiteLineColor;
    [multipleBackView addSubview:multipleLineView];
    
    for(int i = 0;i < 2;i++)
    {
        CGFloat multipleTextFieldW = 100;
        CGFloat backViewH = 25;
        CGFloat wordW = 15;
        UIView *backView = [[UIView alloc] init];
        CGFloat backViewX = YZMargin;
        CGFloat backViewW = 2 * wordW + multipleTextFieldW;
        if (i == 1) {
            backViewX = screenWidth - (YZMargin + backViewW);
        }
        backView.frame = CGRectMake(backViewX, margin + 2, backViewW, backViewH);
        [multipleBackView addSubview:backView];
        
        //倍数输入框，期数输入框
        UITextField *multipleTextField = [[UITextField alloc] init];
        if(i == 0)
        {
            self.multipleTextField = multipleTextField;
        }else
        {
            self.termTextField = multipleTextField;
        }
        multipleTextField.keyboardType = UIKeyboardTypeNumberPad;
        multipleTextField.placeholder = @"1";
        multipleTextField.text = @"1";
        multipleTextField.textColor = YZBlackTextColor;
        multipleTextField.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        multipleTextField.textAlignment = NSTextAlignmentCenter;
        multipleTextField.frame = CGRectMake(wordW, 0, multipleTextFieldW, backViewH);
        [backView addSubview:multipleTextField];
        multipleTextField.layer.borderColor = YZColor(213, 213, 213, 1).CGColor;
        multipleTextField.layer.borderWidth = 0.8;
        multipleTextField.layer.cornerRadius = 1;
        
        for(int j = 0;j < 2;j++)
        {
            //减小和增大按钮
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = j;
            CGFloat btnX = 0;
            if(j == 1)
            {
                btnX = multipleTextFieldW - backViewH;
            }
            btn.frame = CGRectMake(btnX, 0, backViewH, backViewH);
            if(j == 0)
            {
                [btn setImage:[UIImage imageNamed:@"bet_subtract_icon"] forState:UIControlStateNormal];
            }else
            {
                [btn setImage:[UIImage imageNamed:@"bet_add_icon"] forState:UIControlStateNormal];
            }
            [btn setBackgroundImage:[UIImage ImageFromColor:YZColor(238, 238, 238, 1) WithRect:btn.bounds] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage ImageFromColor:YZGrayTextColor WithRect:btn.bounds] forState:UIControlStateSelected];
            if(i == 0)//倍数的按钮
            {
                [btn addTarget:self action:@selector(multipleBtn:) forControlEvents:UIControlEventTouchUpInside];
            }else
            {//期数的按钮
                [btn addTarget:self action:@selector(termBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
            [multipleTextField addSubview:btn];

            //投注俩字
            UILabel *betLabel = [[UILabel alloc] init];
            betLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
            betLabel.textColor = YZBlackTextColor;
            NSString *text = @"投";
            if(i == 0 && j == 1)
            {
                text = @"倍";
            }else if(i == 1 && j == 0)
            {
                text = @"买";
            }else if(i == 1 && j == 1)
            {
                text = @"期";
            }
            betLabel.text = text;
            CGFloat betLabelX = -5;
            if(j == 1)
            {
                betLabelX = CGRectGetMaxX(multipleTextField.frame) + 5;
            }
            betLabel.frame = CGRectMake(betLabelX, 0 , wordW, backViewH);
            [backView addSubview:betLabel];
        }
        //右边的追加投注、中奖后停追
        UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightbtn.tag = i;
        [rightbtn setImage:[UIImage imageNamed:@"bet_weixuanzhong"] forState:UIControlStateNormal];
        [rightbtn setImage:[UIImage imageNamed:@"bet_xuanzhong"] forState:UIControlStateSelected];
        [rightbtn.titleLabel setFont:[UIFont systemFontOfSize:YZGetFontSize(26)]];
        if(i == 0)
        {
            self.zhuijiaBtn = rightbtn;
            [rightbtn setTitle:@"追加投注" forState:UIControlStateNormal];
        }else
        {
            if ([self.gameId isEqualToString:@"T01"]) {
                rightbtn.hidden = YES;
            }
            self.winStopBtn = rightbtn;
            rightbtn.selected = NO;
            [rightbtn setTitle:@"中奖后停追" forState:UIControlStateNormal];
        }
        [rightbtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        CGFloat rightbtnX = 15;
        if (i == 1) {
            rightbtnX = backViewX;
        }
        CGFloat rightbtnW = 120;
        rightbtn.frame = CGRectMake(rightbtnX, CGRectGetMaxY(backView.frame) + margin, rightbtnW, 20);
        [rightbtn setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:5];
        [rightbtn addTarget:self action:@selector(clickrightbtn:) forControlEvents:UIControlEventTouchUpInside];
        [multipleBackView addSubview:rightbtn];
        if(![self.gameId isEqualToString:@"T01"])//大乐透才有追加投注
        {
            [self.zhuijiaBtn removeFromSuperview];
            self.zhuijiaBtn = nil;
        }
    }

    //tableView
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGFloat tableViewH = multipleBackViewY - CGRectGetMaxY(promptView.frame);
    tableView.frame = CGRectMake(0, CGRectGetMaxY(promptView.frame), screenWidth, tableViewH);
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:tableView];
    //刷新控件
    MJRefreshGifHeader * headerView = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshViewBeginRefreshing)];
    [headerView setTitle:@"下拉添加1注机选" forState:MJRefreshStateIdle];
    [headerView setTitle:@"松开添加1注机选" forState:MJRefreshStatePulling];
    [headerView setTitle:@"添加中..." forState:MJRefreshStateRefreshing];
    headerView.lastUpdatedTimeLabel.hidden = YES;//隐藏时间
    tableView.mj_header = headerView;;
    self.headerView = headerView;
}
#pragma mark - 按钮点击
- (void)back
{
    if (self.isDismissVC) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (self.isChartVC)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        UIViewController * popVC = self.navigationController.viewControllers[1];
        [self.navigationController popToViewController:popVC animated:YES];
    }
}
- (void)confirmBtnClick:(UIButton *)btn
{
    if(btn.tag == 0)
    {
        if([btn.currentTitle isEqualToString:@"发起合买"])
        {
            [self unionBuyBtnClick];
        }else//智能追号
        {
            [self smartBet];
        }
    }else
    {
        [self confirmBtn];
    }
}
- (void)smartBet//智能追号
{
    if (self.statusArray.count == 0) {
        [MBProgressHUD showError:@"请先选择一注，才能智能追号哦"];
        return;
    }else if (self.statusArray.count > 1)
    {
        [MBProgressHUD showError:@"您选择的注数多于一注，暂时无法智能追号哦"];
        return;
    }
    [self getCurrentTermDataWithIsSmartBet:YES];//获取当前期次信息
}
- (void)goSmartBet
{
    YZSmartBetViewController * smartBetVC = [[YZSmartBetViewController alloc]init];
    smartBetVC.gameId = self.gameId;
    smartBetVC.selectedPlayTypeBtnTag = self.selectedPlayTypeBtnTag;
    [self.navigationController pushViewController:smartBetVC animated:YES];
}
- (void)unionBuyBtnClick
{
    if(![self.tableView numberOfRowsInSection:0])
    {
        [MBProgressHUD showError:@"请至少添加一注号码"];
        return;
    }
    NSNumber *termCount = [NSNumber numberWithInt:[self.termTextField.text intValue]];//追期数
    if([termCount intValue] > 1)
    {
        [MBProgressHUD showError:@"合买方案不支持追期"];
        return;
    }
    if (self.amountMoney > 20000)
    {
        [MBProgressHUD showError:@"单次投注方案不能超过2万元!"];
        return;
    }
    NSNumber *multiple = [NSNumber numberWithInt:[self.multipleTextField.text intValue]];//投多少倍
    NSNumber *amount = [NSNumber numberWithInt:(int)self.amountMoney * 100];
    NSMutableArray *ticketList = self.ticketList;
    
    YZStartUnionbuyModel *unionbuyModel = [[YZStartUnionbuyModel alloc] init];
    unionbuyModel.multiple = multiple;
    unionbuyModel.amount = amount;
    unionbuyModel.ticketList = ticketList;
    unionbuyModel.gameId = self.gameId;

    YZStartUnionBuyViewController * startUnionBuyVC = [[YZStartUnionBuyViewController alloc] initWithGameId:self.gameId amountMoney:(NSInteger)self.amountMoney unionbuyModel:unionbuyModel];
    [self.navigationController pushViewController:startUnionBuyVC animated:YES];
}
-(void)clickrightbtn:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if(btn.tag == 0)//追加按钮
    {
        [self computeAmountMoney];
    }
}
- (void)multipleBtn:(UIButton *)btn
{
   int multiple = [self.multipleTextField.text intValue];
    if(btn.tag == 0 && multiple != 1)//是减小按钮
    {
        multiple--;
    }else if(btn.tag == 1 && multiple != 99)//增大按钮
    {
        multiple++;
    }
    
    self.multipleTextField.text = [NSString stringWithFormat:@"%d",multiple];
    [self computeAmountMoney];
}
- (void)termBtn:(UIButton *)btn
{
    int termCount = [self.termTextField.text intValue];
    if(btn.tag == 0 && termCount != 1)//是减小按钮
    {
        termCount--;
    }else if(btn.tag == 1 && termCount != 200)//增大按钮
    {
        termCount++;
    }
    //设置中奖后停追按钮
    if(termCount == 1)
    {
        [self hiddenWinStopBtn];
    }else
    {
        [self showWinStopBtn];
    }
    if ([self.gameId isEqualToString:@"T01"]) {
        if(termCount == 1)
        {
            self.winStopBtn.hidden = YES;
        }else
        {
            self.winStopBtn.hidden = NO;
        }
    }
    self.termTextField.text = [NSString stringWithFormat:@"%d",termCount];
    [self computeAmountMoney];
}
- (void)showWinStopBtn
{
    if ([self.gameId isEqualToString:@"T01"]) return;
    CGFloat multipleBackViewY = screenHeight - 49 - statusBarH - navBarH - 80 - [YZTool getSafeAreaBottom];
    if (self.multipleBackView.y != multipleBackViewY) {
        [UIView animateWithDuration:animateDuration
                         animations:^{
                             self.multipleBackView.y -= 31;
                             self.tableView.height -= 31;
                         }
         ];
    }
}
- (void)hiddenWinStopBtn
{
    if ([self.gameId isEqualToString:@"T01"]) return;
    CGFloat multipleBackViewY = screenHeight - 49 - statusBarH - navBarH - 80 - [YZTool getSafeAreaBottom];
    if (self.multipleBackView.y == multipleBackViewY) {
        [UIView animateWithDuration:animateDuration
                         animations:^{
                             self.multipleBackView.y += 31;
                             self.tableView.height += 31;
                         }
         ];
    }
}
#pragma  mark - 投注按钮点击
- (void)confirmBtn
{
    if(![self.tableView numberOfRowsInSection:0])
    {
        [MBProgressHUD showError:@"请至少添加一注号码"];
        return;
    }
    if (self.amountMoney > 20000)
    {
        [MBProgressHUD showError:@"单次投注方案不能超过2万元!"];
        return;
    }
    if(!UserId)//没登录
    {
        YZLoginViewController *loginVc = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
    }else if(_termIdChanged)//期次更换提醒
    {
        NSString *message = [NSString stringWithFormat:@"当前期次已发生变化，当前在售%@期，是否继续投注？",_changedTermId];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"温馨提示"  message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showComfirmPayAlertView];
            _termIdChanged = NO;
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self presentViewController:alertController animated:YES completion:nil];
    }else
    {
        [self loadUserInfo];
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
            NSNumber *termCount = [NSNumber numberWithInt:[self.termTextField.text intValue]];//追期数
            if ([termCount intValue] == 1) {//普通投注
                [self getConsumableList];
            }else
            {
                [self showComfirmPayAlertView];
            }
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
        [self showComfirmPayAlertView];
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
    chooseVoucherVC.ticketList = self.ticketList;
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
            [self getCurrentTermDataWithIsSmartBet:NO];//当前期次的信息
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
- (void)getCurrentTermDataWithIsSmartBet:(BOOL)isSmartBet
{
    [MBProgressHUD showMessage:text_gettingCurrentTerm toView:self.view];
    NSDictionary *dict = @{
                           @"cmd":@(8026),
                           @"gameId":self.gameId
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            NSArray *termList = json[@"game"][@"termList"];
            if(!termList.count)
            {
                [MBProgressHUD showError:text_sailStop];
                return;
            }
            if (isSmartBet) {
                [self goSmartBet];
            }else
            {
                self.currentTermId = [termList lastObject][@"termId"];
                [self isJump:Jump];
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
- (void)isJump:(BOOL)jump
{
    if(!jump)//不跳
    {
        [self comfirmPay];//支付
    }else //跳转网页
    {
        [MBProgressHUD hideHUDForView:self.view];
        NSNumber *multiple = [NSNumber numberWithInt:[self.multipleTextField.text intValue]];//投多少倍
        NSNumber *amount = [NSNumber numberWithInt:(int)self.amountMoney * 100];
        NSNumber *termCount = [NSNumber numberWithInt:[self.termTextField.text intValue]];//追期数
        NSMutableArray *ticketList = self.ticketList;
        NSString *ticketListJsonStr = [ticketList JSONRepresentation];
        YZLog(@"ticketListJsonStr = %@",ticketListJsonStr);
#if JG
        NSString * mcpStr = @"EZmcp";
#elif ZC
        NSString * mcpStr = @"ZCmcp";
#elif CS
        NSString * mcpStr = @"CSmcp";
#elif RR
        NSString * mcpStr = @"CSmcp";
#endif
        NSString *param = [NSString stringWithFormat:@"userId=%@&gameId=%@&termId=%@&multiple=%@&amount=%@&ticketList=%@&payType=%@&termCount=%@&startTermId=%@&winStop=%@&id=%@&channel=%@&childChannel=%@&version=%@&remark=%@",UserId,self.gameId,self.currentTermId,multiple,amount,[ticketListJsonStr URLEncodedString],@"ACCOUNT",termCount,self.currentTermId,self.winStopBtn.selected ? @true : @false,@"1407305392008",mainChannel,childChannel,[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],mcpStr];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",jumpURLStr,param]];
        YZLog(@"url:%@",url);
        [[UIApplication sharedApplication] openURL:url];
    }
}
#pragma  mark - 确认支付
- (void)comfirmPay//支付接口
{
    NSNumber *multiple = [NSNumber numberWithInt:[self.multipleTextField.text intValue]];//投多少倍
    NSNumber *amount = [NSNumber numberWithInt:(int)self.amountMoney * 100];
    NSNumber *termCount = [NSNumber numberWithInt:[self.termTextField.text intValue]];//追期数
    NSMutableArray *ticketList = self.ticketList;
    NSDictionary * dict = [NSDictionary dictionary];
    if ([termCount intValue] == 1) {//普通投注
        dict = @{
                 @"cmd":@(8052),
                 @"userId":UserId,
                 @"gameId":self.gameId,
                 @"termId":self.currentTermId,
                 @"multiple":multiple,
                 @"amount":amount,
                 @"ticketList":ticketList,
                 @"payType":@"ACCOUNT",
                 @"startTermId":self.currentTermId,
                 };
    }else//追号投注
    {
        dict = @{
                 @"cmd":@(8050),
                 @"userId":UserId,
                 @"gameId":self.gameId,
                 @"termId":self.currentTermId,
                 @"multiple":multiple,
                 @"amount":amount,
                 @"ticketList":ticketList,
                 @"payType":@"ACCOUNT",
                 @"termCount":termCount,
                 @"startTermId":self.currentTermId,
                 @"winStop":self.winStopBtn.selected ? @true : @false,
                 };
    }
    [MBProgressHUD showMessage:text_paying toView:self.view];
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        if(SUCCESS)
        {
            [MBProgressHUD hideHUDForView:self.view];
            YZBetSuccessViewController *betSuccessVc = [[YZBetSuccessViewController alloc] init];
            betSuccessVc.payVcType = BetTypeNormal;
            betSuccessVc.termCount = [termCount intValue];
            betSuccessVc.isDismissVC = self.isDismissVC;
            //跳转
            [self.navigationController pushViewController:betSuccessVc animated:YES];

            //删除数据库中得所有号码球数据
            [YZStatusCacheTool deleteAllStatus];
            [self.tableView reloadData];
            [self computeAmountMoney];
        }else
        {
            [MBProgressHUD hideHUDForView:self.view];//隐藏正在支付的弹框
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"error = %@",error);
    }];
}
#pragma mark - 生成ticketList
- (NSMutableArray *)ticketList
{
    NSMutableArray * arr = nil;
    if([self.gameId isEqualToString:@"F01"])//双色球
    {
        arr = [YZBetTool getSsqTicketList];
    }else if ([self.gameId isEqualToString:@"F02"])//福彩3D
    {
        arr = [YZBetTool getFcTicketList];
    }else if ([self.gameId isEqualToString:@"F03"])//七乐彩
    {
        arr = [YZBetTool getQlcTicketList];
    }else if ([self.gameId isEqualToString:@"T01"])//大乐透
    {
        BOOL zhuijia = self.zhuijiaBtn.selected   ;
        arr = [YZBetTool getDltTicketListWithZhuijia:zhuijia];
    }else if ([self.gameId isEqualToString:@"T03"])//排列三
    {
        arr = [YZBetTool getPlsTicketList];
    }else if ([self.gameId isEqualToString:@"T04"])//排列五
    {
        arr = [YZBetTool getPlwTicketList];
    }else if ([self.gameId isEqualToString:@"T02"])//七星彩
    {
        arr = [YZBetTool getQxcTicketList];
    }else if ([self.gameId isEqualToString:@"T05"] || [self.gameId isEqualToString:@"T61"] || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"])//11选5
    {
        arr = [YZBetTool getS1x5TicketList];
    }else if ([self.gameId isEqualToString:@"F04"])//快三
    {
        arr = [YZBetTool getKsTicketList];
    }
    return _ticketList = arr;
}
//计算注数
- (void)computeAmountMoney
{
    int count = 0;
    for(YZBetStatus *status in self.statusArray)
    {
        count += status.betCount;
    }
    NSString *multiple = self.multipleTextField.text;
    NSString *term = self.termTextField.text;

    if([self.multipleTextField.text isEqualToString:@""])
    {
        multiple = @"1";
    }
    if([self.termTextField.text isEqualToString:@""])
    {
        term = @"1";
    }
    int prize = 2;
    if(self.zhuijiaBtn && self.zhuijiaBtn.isSelected)
    {
        prize = 3;
    }
    _amountMoney = count * prize * [multiple floatValue] * [term floatValue];//金额
    self.betCount = count;//注数
}
#pragma mark - 设置注数
- (void)setBetCount:(int)betCount//设置注数
{
    _betCount = betCount;
    if (self.multiple > 0) {
        self.multipleTextField.text = [NSString stringWithFormat:@"%d",self.multiple];
    }
    NSString *multiple = self.multipleTextField.text;
    NSString *term = self.termTextField.text;
    if([self.multipleTextField.text isEqualToString:@""] || !self.multipleTextField.text)
    {
        multiple = @"1";
    }
    if([self.termTextField.text isEqualToString:@""] || !self.termTextField.text)
    {
        term = @"1";
    }
    NSString *str = [NSString stringWithFormat:@"共 %.2f 元\n%d 注 %@ 倍 %@ 期",_amountMoney,betCount,multiple,term];

    NSRange range1 = [str rangeOfString:@"共"];
    NSRange range2 = [str rangeOfString:@"元"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(range2.location + range2.length, attStr.length - (range2.location + range2.length))];
    self.amountLabel.attributedText = attStr;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([self.multipleTextField.text intValue] == 0 && [string intValue] == 0)
    {
        self.multipleTextField.text = @"1";
        return NO;
    }
    return [YZValidateTool validateNumber:string];
}
//摇动震动
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSString * allowShake = [YZUserDefaultTool getObjectForKey:@"allowShake"];
    if ([allowShake isEqualToString:@"0"]) return;
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//震动
    [self autoChoose];
}
- (NSMutableArray *)statusArray
{
    if(_statusArray == nil)
    {
        _statusArray = [NSMutableArray array];
    }
    //从数据库中获取所有号码模型数据
    NSArray *temp = [YZStatusCacheTool getStatues];
    _statusArray = [NSMutableArray arrayWithArray:temp];
    
    return  _statusArray;
}
#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.multipleTextField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.multipleTextField];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    if([self.gameId isEqualToString:@"T05"] || [self.gameId isEqualToString:@"T61"] || [self.gameId isEqualToString:@"T62"] || [self.gameId isEqualToString:@"T63"] || [self.gameId isEqualToString:@"T64"])
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:TermIdChangedNote object:nil];
    }
}
@end
