//
//  YZWithdrawalViewController.m
//  ez
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZWithdrawalViewController.h"
#import "YZBankCardTableViewCell.h"
#import "YZSettingPassWordViewController.h"
#import "YZAddBankCardViewController.h"
#import "YZWithdrawalBankCardTableViewCell.h"
#import "YZBankCardStatus.h"
#import "YZValidateTool.h"
#import "YZDecimalTextField.h"
#import "YZWithdrawalPasswordView.h"

@interface YZWithdrawalViewController ()<UITableViewDelegate,UITableViewDataSource,YZAddBankCardDelegate, YZWithdrawalPasswordViewDelegate>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIScrollView *mainScrollView;
@property (nonatomic, weak) UILabel * balanceLabel;
@property (nonatomic, weak) YZDecimalTextField *withdrawalTF;
@property (nonatomic, weak) UIButton * submitBtn;
@property (nonatomic, strong) NSArray *bankCards;
@property (nonatomic, assign) NSInteger selBankCardIndex;

@end

@implementation YZWithdrawalViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!UserId)
    {
        [MBProgressHUD hideHUDForView:self.view];
        return;
    }
    NSDictionary *dict = @{
                           @"cmd":@(8006),
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        if (SUCCESS) {
            //存储用户信息
            YZUser *user = [YZUser objectWithKeyValues:json];
            [YZUserDefaultTool saveUser:user];
            self.balanceLabel.text = [NSString stringWithFormat:@"%.2f元",[user.bonus floatValue] / 100.0];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        YZLog(@"账户error");
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"提款";
    [self setupChilds];
    waitingView_loadingData;
    [self getBankData];
}
#pragma mark - 请求历史开奖数据
//断网状态下，此方法必须实现
- (void)noNetReloadRequest
{
    [self getBankData];
}
- (void)getBankData
{
    NSDictionary *dict = @{
                           @"cmd":@(10700),
                           @"userId":UserId
                           };
    [[YZHttpTool shareInstance] requestTarget:self PostWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"%@",json);
        if (SUCCESS) {
            self.bankCards = [YZBankCardStatus objectArrayWithKeyValuesArray:json[@"cards"]];
            for (int i = 0; i < self.bankCards.count; i++) {
                YZBankCardStatus * status = self.bankCards[i];
                if (i == 0) {//默认第一个被选中
                    status.isSelected = YES;
                    self.selBankCardIndex = 0;
                }else
                {
                    status.isSelected = NO;
                }
            }
            [self.tableView reloadData];
            [self setTableFooterView];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"账户error");
    }];
}
- (void)setupChilds
{
    //主TableView
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - statusBarH - navBarH)];
    self.tableView = tableView;
    tableView.backgroundColor = YZBackgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    [tableView setEstimatedSectionHeaderHeightAndFooterHeight];
    [self.view addSubview:tableView];
    
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    //headerView
    UIView *headerView = [[UIView alloc]init];

    //余额
    UIView * balanceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, YZCellH)];
    balanceView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:balanceView];
    
    UILabel * balancePromptLabel = [[UILabel alloc]init];
    balancePromptLabel.text = @"可提款";
    balancePromptLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    balancePromptLabel.textColor = YZBlackTextColor;
    CGSize balancePrompSize = [balancePromptLabel.text sizeWithLabelFont:balancePromptLabel.font];
    balancePromptLabel.frame = CGRectMake(YZMargin, 0, balancePrompSize.width, balanceView.height);
    [balanceView addSubview:balancePromptLabel];
    
    UILabel * balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(balancePromptLabel.frame) + 10, 0, screenWidth - CGRectGetMaxX(balancePromptLabel.frame) - 20, balanceView.height)];
    self.balanceLabel = balanceLabel;
    balanceLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    balanceLabel.textColor = YZRedTextColor;
    balanceLabel.textAlignment = NSTextAlignmentRight;
    [balanceView addSubview:balanceLabel];
    
    //提款输入框
    UIView * withdrawalView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(balanceView.frame) + 10, screenWidth, YZCellH)];
    withdrawalView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:withdrawalView];
    
    UILabel * withdrawalLabel = [[UILabel alloc]init];
    withdrawalLabel.text = @"提款金额(元)";
    withdrawalLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    withdrawalLabel.textColor = YZBlackTextColor;
    CGSize withdrawalSize = [withdrawalLabel.text sizeWithLabelFont:withdrawalLabel.font];
    withdrawalLabel.frame = CGRectMake(YZMargin, 0, withdrawalSize.width, withdrawalView.height);
    [withdrawalView addSubview:withdrawalLabel];
    
    YZDecimalTextField *withdrawalTF = [[YZDecimalTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(withdrawalLabel.frame) + 10, 0, screenWidth - CGRectGetMaxX(withdrawalLabel.frame) - 20, YZCellH)];
    self.withdrawalTF = withdrawalTF;
    withdrawalTF.textAlignment = NSTextAlignmentRight;
    withdrawalTF.keyboardType = UIKeyboardTypeDecimalPad;
    withdrawalTF.borderStyle = UITextBorderStyleNone;
    withdrawalTF.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    withdrawalTF.textColor = YZBlackTextColor;
    withdrawalTF.placeholder = @"至少3元";
    [withdrawalView addSubview:withdrawalTF];
    
    headerView.frame = CGRectMake(0, 0, screenHeight, CGRectGetMaxY(withdrawalView.frame) + 10);
    tableView.tableHeaderView = headerView;
    
    [self setTableFooterView];
}
- (void)setTableFooterView
{
    if (self.bankCards.count == 0) {//没有银行卡时
        //footerView
        UIView * footerView = [[UIView alloc]init];
        
        //提示
        UILabel * promptLabel = [[UILabel alloc]init];
        promptLabel.text = @"您还未绑定银行卡，请绑定！";
        promptLabel.textColor = YZGrayTextColor;
        promptLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        CGSize promptLabelSize = [promptLabel.text sizeWithLabelFont:promptLabel.font];
        promptLabel.frame = CGRectMake(YZMargin, 10, screenWidth - 2 * YZMargin, promptLabelSize.height);
        [footerView addSubview:promptLabel];
        
        //添加银行卡
        YZBottomButton * addBankCardBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
        addBankCardBtn.y = CGRectGetMaxY(promptLabel.frame) + 30;
        [addBankCardBtn setTitle:@"绑定银行卡" forState:UIControlStateNormal];
        [addBankCardBtn addTarget:self action:@selector(addBankCardBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:addBankCardBtn];

        footerView.frame = CGRectMake(0, 0, screenWidth, CGRectGetMaxY(addBankCardBtn.frame) + 10);
        self.tableView.tableFooterView = footerView;
    }else
    {
        //footerView
        UIView * footerView = [[UIView alloc]init];
        
        //添加银行卡
        UIButton * addBankCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addBankCardBtn.backgroundColor = [UIColor clearColor];
        [addBankCardBtn setTitle:@"+添加银行卡" forState:UIControlStateNormal];
        [addBankCardBtn setTitleColor:YZGrayTextColor forState:UIControlStateNormal];
        addBankCardBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        CGSize addBankCardBtnSize = [addBankCardBtn.currentTitle sizeWithLabelFont:addBankCardBtn.titleLabel.font];
        addBankCardBtn.frame = CGRectMake(YZMargin, 0, addBankCardBtnSize.width, 40);
        [addBankCardBtn addTarget:self action:@selector(addBankCardBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:addBankCardBtn];
        
        //提交
        YZBottomButton * submitBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
        self.submitBtn = submitBtn;
        submitBtn.y = CGRectGetMaxY(addBankCardBtn.frame) + 10;
        [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
        [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:submitBtn];
        
        //提示
        UILabel * promptLabel = [[UILabel alloc]init];
        promptLabel.numberOfLines = 0;
        NSMutableAttributedString * promptAttStr = [[NSMutableAttributedString alloc]initWithString:@"温馨提示：\n1、提款金额100元（含）以上免手续费，100元以下2元手续费，为防止恶意提款每日最多可提3笔\n2、提款单笔1万元以下，在工作时间16点前通过中行、农行、工行、建行、招行申请提款后2小时内到账，16点后申请的次日到账，其他银行1-2个工作日到账；单笔1万元（含）以上，申请提款后1-2个工作日到账\n3、若提款3个工作日内仍未到账，请联系客服处理\n4、为了您的资金安全，提款需验证登录密码，如忘记密码请到登录界面进行找回"];
        [promptAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(22)] range:NSMakeRange(0, promptAttStr.length)];
        [promptAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, promptAttStr.length)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5];
        [promptAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, promptAttStr.length)];
        promptLabel.attributedText = promptAttStr;
        CGSize promptLabelSize = [promptLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth - 2 * YZMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        promptLabel.frame = CGRectMake(submitBtn.x, CGRectGetMaxY(submitBtn.frame) + 10, screenWidth - 2 * submitBtn.x, promptLabelSize.height);
        [footerView addSubview:promptLabel];

        UILabel * callLabel = [[UILabel alloc]init];
        callLabel.text = @"5、客服热线：";
        callLabel.textColor = YZGrayTextColor;
        callLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        CGFloat labelY = CGRectGetMaxY(promptLabel.frame) + 5;
        CGSize callLabelSize = [callLabel.text sizeWithFont:callLabel.font maxSize:CGSizeMake(screenWidth - 2 * YZMargin, MAXFLOAT)];
        callLabel.frame = CGRectMake(YZMargin, labelY, callLabelSize.width, callLabelSize.height);
        [footerView addSubview:callLabel];
        
        UIButton * callBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [callBtn setTitleColor:YZBlueBallColor forState:UIControlStateNormal];
        [callBtn setTitle:@"4007001898" forState:UIControlStateNormal];
        callBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        CGSize callBtnSize = [callBtn.currentTitle sizeWithLabelFont:callBtn.titleLabel.font];
        callBtn.frame = CGRectMake(CGRectGetMaxX(callLabel.frame), labelY, callBtnSize.width, callLabelSize.height);
        [callBtn addTarget:self action:@selector(kefuClick) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:callBtn];
        
        footerView.frame = CGRectMake(0, 0, screenWidth, CGRectGetMaxY(callBtn.frame) + 10);
        self.tableView.tableFooterView = footerView;
    }
}
- (void)kefuClick
{
    UIWebView *callWebview =[[UIWebView alloc] init];
    NSString *telUrl = @"tel://4007001898";
    NSURL *telURL =[NSURL URLWithString:telUrl];
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    [self.view addSubview:callWebview];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bankCards.count == 0 ? 0 : self.bankCards.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *rid = @"withrawalAccountCell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:rid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.x = YZMargin;
        cell.textLabel.text = @"提款账号";
        cell.textLabel.textColor = YZGrayTextColor;
        cell.textLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        return cell;
    }else
    {
        YZWithdrawalBankCardTableViewCell * cell = [[YZWithdrawalBankCardTableViewCell alloc]init];
        cell.status = self.bankCards[indexPath.row - 1];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 28;
    }
    return YZCellH;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) return;
    
    //关闭已选中的cell
    if (self.selBankCardIndex == indexPath.row - 1) {//当前是选中状态的
        return;
    }
    NSMutableArray * indexPaths = [NSMutableArray array];
    for (int i = 0; i < self.bankCards.count; i++) {
        YZBankCardStatus * status = self.bankCards[i];
        if (status.isSelected) {
            status.isSelected = NO;
            NSIndexPath * openIndexPath = [NSIndexPath indexPathForRow:i + 1 inSection:0];
            [indexPaths addObject:openIndexPath];
        }
    }
    //点击的indexPath
    YZBankCardStatus * status = self.bankCards[indexPath.row - 1];
    status.isSelected = YES;//选中
    [indexPaths addObject:indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    self.selBankCardIndex = indexPath.row - 1;
}
#pragma mark - 添加银行卡
- (void)addBankCardBtnClick
{
    YZAddBankCardViewController * addBankCardVC = [[YZAddBankCardViewController alloc]init];
    addBankCardVC.delegate = self;
    [self.navigationController pushViewController:addBankCardVC animated:YES];
}
//添加银行卡成功
- (void)addBankSuccess
{
    waitingView_loadingData;
    [self getBankData];
}
#pragma mark - 提交
- (void)submitBtnClick
{
    [self.view endEditing:YES];
    
    YZUser *user = [YZUserDefaultTool user];
    if (!user.modifyPwd) {//如果没有密码，先去设置密码
        YZSettingPassWordViewController *settingPassWordVC = [[YZSettingPassWordViewController alloc]init];
        [self.navigationController pushViewController:settingPassWordVC animated:YES];
        return;
    }
    float totalBalance = [self.balanceLabel.text floatValue];
    float withDrawalMoney = [self.withdrawalTF.text floatValue];
    if (totalBalance == 0) {
        [MBProgressHUD showError:@"可提款金额为0"];
        return;
    }
    if (withDrawalMoney == 0) {
        [MBProgressHUD showError:@"请输入提款金额"];
        return;
    }
    if (totalBalance < withDrawalMoney) {
        [MBProgressHUD showError:@"可提款金额不足"];
        return;
    }
    if (withDrawalMoney < 3) {
        [MBProgressHUD showError:@"提款金额不能小于3元"];
        return;
    }
    
    //输入登录密码
    YZWithdrawalPasswordView * passwordView = [[YZWithdrawalPasswordView alloc] initWithFrame:self.view.bounds];
    passwordView.delegate = self;
    [self.view addSubview:passwordView];
}

- (void)withDrawalWithPassWord:(NSString *)passWord type:(int)type
{
    YZBankCardStatus * status = self.bankCards[self.selBankCardIndex];
    NSString * cardId = status.cardId;
    NSNumber * money = @([self.withdrawalTF.text floatValue] * 100);
#if JG
    NSNumber * cmd = @(10910);
#elif ZC
    NSNumber * cmd = @(10920);
#elif CS
    NSNumber * cmd = @(10920);
#endif
    NSDictionary *dict = [NSDictionary dictionary];
    if (type == 1) {//密码验证
        dict = @{
                @"cmd":cmd,
                @"userId":UserId,
                @"cardId":cardId,
                @"money":money,
                @"passwd":passWord,
                @"type": @(type)
                };
    }else//短信验证
    {
       dict = @{
                @"cmd":cmd,
                @"userId":UserId,
                @"cardId":cardId,
                @"money":money,
                @"verifyCode":passWord,
                @"type": @(type)
                };
    }
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        YZLog(@"%@",json);
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"申请提款成功，请等待"];
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"账户error");
    }];
}
#pragma mark - 初始化
- (NSArray *)bankCards
{
    if (_bankCards == nil) {
        _bankCards = [NSArray array];
    }
    return _bankCards;
}
@end
