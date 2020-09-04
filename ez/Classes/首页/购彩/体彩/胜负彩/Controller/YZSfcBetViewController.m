//
//  YZSfcBetViewController.m
//  ez
//
//  Created by apple on 14-12-12.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#define padding 10.0f
#import "YZSfcBetViewController.h"
#import "YZLoginViewController.h"
#import "YZRechargeListViewController.h"
#import "YZStartUnionBuyViewController.h"
#import "YZSfcCell.h"
#import "YZFootBallTool.h"
#import "YZValidateTool.h"
#import "YZFbBetSuccessViewController.h"
#import "YZNavigationController.h"
#import "JSON.h"

@interface YZSfcBetViewController ()<UITableViewDataSource,UITableViewDelegate,YZSfcCellDelegate>
{
    NSArray *_minMatchCounts;//最少要求选择的比赛场次数
}
@property (nonatomic, weak) UILabel *amountLabel;
@property (nonatomic, weak) UIButton *goSelectBtn;
@property (nonatomic, copy) NSString *currentTermId;//当前期
@end

@implementation YZSfcBetViewController
- (instancetype)initWithPlayTypeTag:(int)playTypeTag statusArray:(NSMutableArray *)statusArray
{
    if(self = [super init])
    {
        _playTypeTag = playTypeTag;
        if(playTypeTag == 0)
        {
            _playType = @"01";//胜负彩
        }else
        {
            _playType = @"02";//任九场
        }
        _statusArray = statusArray;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
#endif
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupChilds];
    _minMatchCounts = [NSArray arrayWithObjects:@(14),@(9), nil];
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 监听textView文字改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(multipleTextDidChange) name:UITextFieldTextDidChangeNotification object:self.multipleTextField];
}
- (void)multipleTextDidChange
{
    if([self.multipleTextField.text intValue] > 99)
    {
        self.multipleTextField.text = @"99";
    }
    [self setAmountLabelText];
}
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
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [bottomView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(betBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.layer.cornerRadius = 2;
    
    //合买按钮
    UIButton *unionBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.unionBuyBtn = unionBuyBtn;
    unionBuyBtn.frame = CGRectMake(15, (bottomViewH - confirmBtnH) / 2, confirmBtnW, confirmBtnH);
    [unionBuyBtn setBackgroundImage:[UIImage ImageFromColor:YZColor(238, 238, 238, 1) WithRect:confirmBtn.bounds] forState:UIControlStateNormal];
    [unionBuyBtn setTitle:@"发起合买" forState:UIControlStateNormal];
    [unionBuyBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    unionBuyBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [unionBuyBtn addTarget:self action:@selector(unionBuyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    unionBuyBtn.layer.borderWidth = 1;
    unionBuyBtn.layer.borderColor = YZColor(213, 213, 213, 1).CGColor;
    [bottomView addSubview:unionBuyBtn];
    
    //注数和倍数和金额总数
    UILabel *amountLabel = [[UILabel alloc] init];
    amountLabel.backgroundColor = [UIColor clearColor];
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
    [bottomView addSubview:amountLabel];
    
    //倍数输入框
    UITextField *multipleTextField = [[UITextField alloc] init];
    self.multipleTextField = multipleTextField;
    multipleTextField.backgroundColor = [UIColor whiteColor];
    multipleTextField.placeholder = @"1";
    multipleTextField.text = @"1";
    multipleTextField.textAlignment = NSTextAlignmentCenter;
    multipleTextField.keyboardType = UIKeyboardTypeNumberPad;
    multipleTextField.layer.borderWidth = 0.5;
    multipleTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    multipleTextField.textColor = YZBlackTextColor;
    multipleTextField.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    CGFloat multipleTextFieldX = padding;
    CGFloat multipleTextFieldH = 35;
    CGFloat multipleTextFieldY = bottomView.y - multipleTextFieldH;
    CGFloat multipleTextFieldW = (screenWidth - 2 * padding) / 2;
    multipleTextField.frame = CGRectMake(multipleTextFieldX, multipleTextFieldY, multipleTextFieldW, multipleTextFieldH);
    [self.view addSubview:multipleTextField];
    
    //加减号按钮
    CGFloat btnImageW = 30;
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
    
//    //继续选择添加赛事
//    if([_playType isEqualToString:@"02"])//是任九场
//    {
//        UIButton *goSelectBtn = [[UIButton alloc] init];
//        self.goSelectBtn = goSelectBtn;
//        CGFloat goSelectBtnW = screenWidth - 2 * padding;
//        CGFloat goSelectBtnH = 44;
//        CGFloat goSelectBtnY = multipleTextField.y - padding - goSelectBtnH;
//        goSelectBtn.frame = CGRectMake(padding, goSelectBtnY, goSelectBtnW, goSelectBtnH);
//        goSelectBtn.backgroundColor = YZColor(97, 180, 59, 1);//草绿
//        UIImage *goSelectBtnImage = [UIImage imageNamed:@"fb_round_plus"];
//        [goSelectBtn setImage:goSelectBtnImage forState:UIControlStateNormal];
//        goSelectBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
//        goSelectBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//        [goSelectBtn setTitle:@"继续选择添加赛事" forState:UIControlStateNormal];
//        [goSelectBtn setTitleColor:YZDrayGrayTextColor forState:UIControlStateHighlighted];
//        CGSize titleSize = [goSelectBtn.currentTitle sizeWithFont:goSelectBtn.titleLabel.font maxSize:CGSizeMake(screenWidth, screenHeight)];
//        CGFloat imageTitleWidth = goSelectBtnImage.size.width + titleSize.width;
//        CGFloat twoSidePadding = (goSelectBtnW - imageTitleWidth) / 2.0f;
//        [goSelectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, twoSidePadding, 0, titleSize.width+twoSidePadding)];
//        [goSelectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, twoSidePadding+goSelectBtnImage.size.width-10, 0, twoSidePadding-18)];
//        [goSelectBtn addTarget:self action:@selector(goSelectBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:goSelectBtn];
//    }
    
    UIView *tableViewBgView = [[UIView alloc] init];
    tableViewBgView.backgroundColor = YZColor(240, 254, 236, 1);
    CGFloat tableViewBgViewH = 0;
    if(self.goSelectBtn)
    {
        tableViewBgViewH = self.goSelectBtn.y - 5;
    }else
    {
        tableViewBgViewH = multipleTextField.y;
    }
    tableViewBgView.frame = CGRectMake(0, 0, screenWidth, tableViewBgViewH);
    [self.view addSubview:tableViewBgView];
    
    //tableView
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = YZColor(240, 254, 236, 1);
    CGFloat tableViewX = padding;
    CGFloat tableViewW = screenWidth - 2 * tableViewX;
    CGFloat tableViewH = tableViewBgViewH;
    tableView.frame = CGRectMake(tableViewX, 0, tableViewW, tableViewH);
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [tableViewBgView addSubview:tableView];
    
    [self setAmountLabelText];//设置注数和金额
}
- (void)multipleBtnClick:(UIButton *)btn
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
    [self setAmountLabelText];
}
- (void)unionBuyBtnClick
{
    if(![self.tableView numberOfRowsInSection:0])
    {
        [MBProgressHUD showError:@"请至少添加一注号码"];
        return;
    }else if (self.amountMoney > 20000)
    {
        [MBProgressHUD showError:@"单次投注方案不能超过2万元!"];
        return;
    }
    NSNumber *multiple = [NSNumber numberWithInt:[self.multipleTextField.text intValue]];//投多少倍
    NSNumber *amount = [NSNumber numberWithInt:(int)self.amountMoney * 100];
    NSMutableArray *ticketList = [self getTicketList];
    
    YZStartUnionbuyModel *unionbuyModel = [[YZStartUnionbuyModel alloc] init];
    unionbuyModel.multiple = multiple;
    unionbuyModel.amount = amount;
    unionbuyModel.ticketList = ticketList;
    unionbuyModel.gameId = self.gameId;
    
    YZStartUnionBuyViewController * startUnionBuyVC = [[YZStartUnionBuyViewController alloc] initWithGameId:self.gameId amountMoney:(NSInteger)self.amountMoney unionbuyModel:unionbuyModel];
    [self.navigationController pushViewController:startUnionBuyVC animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YZSfcCell *cell = [YZSfcCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.betStatus = self.statusArray[indexPath.row];
    return  cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return sfcCellH;
}
#pragma mark - cell的赔率按钮点击
- (void)sfcCellOddsInfoBtnDidClick:(UIButton *)btn withCell:(YZSfcCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    YZSfcCellStatus *status = self.statusArray[indexPath.row];
    
    status.btnStateArray[btn.tag] = btn.isSelected ? @(1) : @(0);//按钮状态改相反
    
    if(btn.selected)
    {
        status.btnSelectedCount ++;
    }else//取消选中
    {
        status.btnSelectedCount --;
        int betCount = [self computeBetCount];
        if(betCount == 0)
        {
            [MBProgressHUD showError:@"至少选择一注"];
            btn.selected = YES;
            status.btnStateArray[btn.tag] = btn.isSelected ? @(1) : @(0);//按钮状态改相反
            status.btnSelectedCount ++;
        }
    }
    //设置底部的文字
    [self setAmountLabelText];
}

#pragma mark - 投注按钮点击
- (void)betBtnClick
{
    if(!UserId)//没登录
    {
        YZLoginViewController *loginVc = [[YZLoginViewController alloc] init];
        YZNavigationController *nav = [[YZNavigationController alloc] initWithRootViewController:loginVc];
        [self presentViewController:nav animated:YES completion:nil];
        return;
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
    chooseVoucherVC.ticketList = [self getTicketList];
    chooseVoucherVC.termId = self.termId;
    chooseVoucherVC.gameId = self.gameId;
    chooseVoucherVC.amountMoney = self.amountMoney;
    chooseVoucherVC.betCount = self.betCount;
    chooseVoucherVC.multiple = [self.multipleTextField.text intValue];
    chooseVoucherVC.playType = _playType;
    chooseVoucherVC.isSFC = YES;
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
                           @"cmd":@(8026),
                           @"gameId":self.gameId
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"getCurrentTermData - json = %@",json);
        if([json[@"retCode"] isEqualToNumber:@(0)])
        {
            NSArray *termList = json[@"game"][@"termList"];
            if(!termList.count)
            {
                [MBProgressHUD showError:text_sailStop];
                return ;
            }
            self.currentTermId = [termList lastObject][@"termId"];
            [self comfirmPay];//支付
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
    NSDictionary *dict = @{
                           @"cmd":@(8052),
                           @"userId":UserId,
                           @"gameId":self.gameId,
                           @"termId":self.termId,
                           @"multiple":multiple,
                           @"amount":amount,
                           @"payType":@"ACCOUNT",
                           @"playType":_playType,
                           @"termCount":@(1),
                           @"ticketList":[self getTicketList],
                           };
    
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        
        YZLog(@"json = %@",json);
        [MBProgressHUD hideHUDForView:self.view];//隐藏正在支付的弹框
        if(SUCCESS)
        {
            //刷新tableView
            [[NSNotificationCenter defaultCenter] postNotificationName:@"tableViewNeedReload" object:nil];
            
            //支付成功控制器
            YZFbBetSuccessViewController *betSuccessVc = [[YZFbBetSuccessViewController alloc] initWithAmount:[amount floatValue] bonus:[json[@"balance"] floatValue] isJC:NO];
            //跳转
            [self.navigationController pushViewController:betSuccessVc animated:YES];
            //删除选号数据
            [self deleteAllSelBtn];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];//隐藏正在支付的弹框
        YZLog(@"error = %@",error);
    }];
}
- (void)deleteAllSelBtn
{
    for(YZSfcCellStatus *status in self.statusArray)
    {
        [status deleteAllSelBtn];
    }
    [self.tableView reloadData];
    [self setAmountLabelText];
}
- (NSMutableArray *)getTicketList
{
    NSMutableArray *ticketList = [NSMutableArray array];
    NSMutableString *muStr = [NSMutableString string];
    NSArray *spfCodeArr = [NSArray arrayWithObjects:@"3",@"1",@"0", nil];
    NSMutableArray *tempStatusArr = [self.statusArray mutableCopy];
    for(int i = 0;i < 14;i ++)
    {
        YZSfcCellStatus *status = [tempStatusArr firstObject];
        if(status.number == i + 1)
        {
            for(int j = (int)status.btnStateArray.count - 1;j >= 0;j --)
            {
                NSNumber *btnState = status.btnStateArray[j];
                NSString *spfCode = nil;
                if([btnState intValue])//按钮选中
                {
                    spfCode = spfCodeArr[j];
                }
                if(spfCode)
                {
                    [muStr appendString:[NSString stringWithFormat:@"%@,",spfCode]];//赔率间加,
                }
            }
            [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//删除最后一个“,”
            [tempStatusArr removeObjectAtIndex:0];
        }else
        {
            [muStr appendString:@"_"];//该场次未选，加上_
        }
        [muStr appendString:@"|"];//场次间加上|
    }
    [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//删除最后一个“|”
    NSString *betType = nil;
    if(_betCount > 1)
    {
        betType = @"01";//复式
    }else
    {
        betType = @"00";//单式
    }
    NSDictionary *dict = @{@"numbers":muStr,
                           @"betType":betType,
                            @"playType":_playType};
    [ticketList addObject:dict];
    return ticketList;
}
#pragma mark - 计算注数的
- (int)computeBetCount
{
    int count = 1;
    
    if([_playType isEqualToString:@"01"])//算胜负彩的注数
    {
        for(YZSfcCellStatus *status in self.statusArray)
        {
            count = count * status.btnSelectedCount;
        }
    }else//任九场的注数
    {
        NSMutableArray *cellSelBtnCountArr = [NSMutableArray array];
        for(YZSfcCellStatus *status in self.statusArray)
        {
            if(status.btnSelectedCount > 0)
            {
                [cellSelBtnCountArr addObject:@(status.btnSelectedCount)];
            }
        }
        if(cellSelBtnCountArr.count >= 9)
        {
            count = [YZFootBallTool getRenjiuBetCount:cellSelBtnCountArr :9];
        }else{
            count = 0;
        }
    }
    _betCount = count;
    int multiple = [self.multipleTextField.text intValue] ? [self.multipleTextField.text intValue] : 1;
    _amountMoney = 2 * _betCount * multiple;
    return count;
}
- (int)getSelMatchCount
{
    int count = 0;
    for(YZSfcCellStatus *status in self.statusArray)
    {
        if(status.btnSelectedCount)
        {
            count ++;
        }
    }
    return count;
}
#pragma mark - 设置总金额注数label的文字 bonusLabel
- (void)setAmountLabelText
{
    _betCount = [self computeBetCount];
    int multiple = [self.multipleTextField.text intValue] ? [self.multipleTextField.text intValue] : 1;
    NSString *temp = [NSString stringWithFormat:@"共%d注%d倍%d元",_betCount,multiple,(int)_amountMoney];
    
    NSRange range1 = [temp rangeOfString:@"共"];
    NSRange range2 = [temp rangeOfString:@"注"];
    NSRange range3 = [temp rangeOfString:@"倍"];
    NSRange range4 = [temp rangeOfString:@"元"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:temp];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:NSMakeRange(range2.location + 1, range3.location - range2.location - 1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(range3.location + 1, range4.location - range3.location - 1)];
    self.amountLabel.attributedText = attStr;
}
- (void)setStatusArray:(NSMutableArray *)statusArray
{
    _statusArray = statusArray;
    
    [self.tableView reloadData];
}
- (void)keyboardWillHide:(NSNotification *)note
{
    if([self.multipleTextField.text isEqualToString:@""])
    {
        self.multipleTextField.text = @"1";
    }
}
//继续选择添加赛事按钮点击
- (void)goSelectBtnClick
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
