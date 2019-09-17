//
//  YZChooseVoucherViewController.m
//  ez
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZChooseVoucherViewController.h"
#import "YZConsumableVoucherViewController.h"
#import "YZFbBetSuccessViewController.h"
#import "YZBetSuccessViewController.h"
#import "YZRechargeListViewController.h"
#import "YZStatusCacheTool.h"
#import "JSON.h"

@interface YZChooseVoucherViewController ()<YZConsumableVoucherDelegate>

@property (nonatomic, weak) UILabel *voucherLabel;//彩券
@property (nonatomic, weak) UILabel *bottomLabel;//底部label
@property (nonatomic, weak) UIButton *confirmBtn;//确认按钮
@property (nonatomic, assign) float payAmountMoney;//需要支付的金额
@property (nonatomic, copy) NSString *currentTermId;
@property (nonatomic, strong) YZVoucherStatus *voucherStatus;

@end

@implementation YZChooseVoucherViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YZBackgroundColor;
    self.title = @"支付选择";
    self.payAmountMoney = self.amountMoney;
    [self setupChilds];
}

#pragma mark - 布局视图
- (void)setupChilds
{
    for (int i = 0; i < 3; i++) {
        CGFloat viewY = 10 + i * YZCellH;
        if (i >= 1) {
            viewY += 10;
        }
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, viewY, screenWidth, YZCellH)];
        view.tag = i;
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        
        //分割线
        if (i == 2) {
            UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
            line.backgroundColor = YZWhiteLineColor;
            [view addSubview:line];
        }
        
        if (i == 2) {
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap:)];
            [view addGestureRecognizer:tap];
        }
        
        UILabel * titleLabel = [[UILabel alloc]init];
        titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        titleLabel.textColor = YZBlackTextColor;
        if (i == 0) {
            titleLabel.text = @"订单详情";
        }else if (i == 1)
        {
            titleLabel.text = @"订单金额";
        }else if (i == 2)
        {
            titleLabel.text = @"彩券";
        }
        CGSize size = [titleLabel.text sizeWithLabelFont:titleLabel.font];
        titleLabel.frame = CGRectMake(YZMargin, 0, size.width, YZCellH);
        [view addSubview:titleLabel];
        
        UILabel * contentLabel = [[UILabel alloc]init];
        contentLabel.textAlignment = NSTextAlignmentRight;
        contentLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        contentLabel.textColor = YZBlackTextColor;
        if (i == 0) {
            NSString * gameName = [YZTool gameIdNameDict][self.gameId];
            contentLabel.text = [NSString stringWithFormat:@"%@, %d注, %d倍",gameName,self.betCount,self.multiple];
            contentLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + 5, 0, screenWidth - (CGRectGetMaxX(titleLabel.frame) + 5 + 15), YZCellH);
        }else if (i == 1)
        {
            contentLabel.text = [NSString stringWithFormat:@"%.2f元",self.amountMoney];
            contentLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + 5, 0, screenWidth - (CGRectGetMaxX(titleLabel.frame) + 5 + 15), YZCellH);
        }else if (i == 2)
        {
            self.voucherLabel = contentLabel;
            contentLabel.text = @"未选择彩券";
            contentLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + 5, 0, screenWidth - (CGRectGetMaxX(titleLabel.frame) + 23 + YZMargin), YZCellH);
        }
        [view addSubview:contentLabel];
        
        if (i == 2) {
            CGFloat accessoryW = 8;
            CGFloat accessoryH = 11;
            UIImageView * accessoryImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 15 - accessoryW, (YZCellH - accessoryH) / 2, accessoryW, accessoryH)];
            accessoryImageView.image = [UIImage imageNamed:@"accessory_dray"];
            [view addSubview:accessoryImageView];
        }
    }
    //底部视图
    UIView * bottomView = [[UIView alloc]init];
    CGFloat bottomViewH = 45 + [YZTool getSafeAreaBottom];
    bottomView.frame = CGRectMake(0, screenHeight - statusBarH - navBarH - bottomViewH, screenWidth, bottomViewH);
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    //底部label
    UILabel *bottomLabel = [[UILabel alloc]init];
    self.bottomLabel = bottomLabel;
    bottomLabel.textColor = YZRedTextColor;
    if ((self.isJC && ![self.gameId isEqualToString:@"T52"]) || self.isSFC) {//竞彩为绿色
        bottomLabel.textColor = YZColor(80, 148, 35, 1);
    }
    bottomLabel.font = [UIFont boldSystemFontOfSize:YZGetFontSize(32)];
    bottomLabel.frame = CGRectMake(YZMargin, 0, screenWidth - YZMargin - 2 * 10 - 60, 45);
    [bottomView addSubview:bottomLabel];
    
    NSString * amountMoneyStr = [NSString stringWithFormat:@"实付：%.2f元",self.amountMoney];;
    bottomLabel.text = amountMoneyStr;
    
    //底部按钮
    YZBottomButton *confirmBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn = confirmBtn;
    CGFloat confirmBtnH = 30;
    CGFloat confirmBtnW = 75;
    confirmBtn.frame = CGRectMake(screenWidth - confirmBtnW - 15, (45 - confirmBtnH) / 2, confirmBtnW, confirmBtnH);
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [bottomView addSubview:confirmBtn];
    [confirmBtn addTarget:self action:@selector(confirmBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    //分割线
    UIView * bottomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    bottomLineView.backgroundColor = YZGrayLineColor;
    [bottomView addSubview:bottomLineView];

}
- (void)viewTap:(UITapGestureRecognizer *)tap
{
    YZConsumableVoucherViewController * consumableVoucherVC = [[YZConsumableVoucherViewController alloc]init];
    consumableVoucherVC.gameId = self.gameId;
    consumableVoucherVC.amountMoney = self.amountMoney;
    consumableVoucherVC.delegate = self;
    [self.navigationController pushViewController:consumableVoucherVC animated:YES];
}
#pragma mark - YZConsumableVoucherDelegate
- (void)cancelUseVoucher//取消使用代金券
{
    self.payAmountMoney = self.amountMoney;
    self.voucherLabel.text = @"未选择彩券";
    NSString * amountMoneyStr = [NSString stringWithFormat:@"实付：%.2f元",self.amountMoney];
    self.bottomLabel.text = amountMoneyStr;
    self.voucherStatus = nil;
}
- (void)chooseVoucherStstus:(YZVoucherStatus *)voucherStatus
{
    self.voucherStatus = voucherStatus;
    float voucherMoney = [voucherStatus.balance floatValue] / 100;
    //底部label
    NSString * totalMoneyStr = [NSString stringWithFormat:@"%d",(int)self.amountMoney];
    NSString * voucherMoneyStr = [NSString stringWithFormat:@"%d",(int)voucherMoney];
    NSString * bottomStr;
    if (self.amountMoney >= voucherMoney) {
        bottomStr = [NSString stringWithFormat:@"实付：%.2f元",[totalMoneyStr floatValue] - [voucherMoneyStr floatValue]];
        self.payAmountMoney = [totalMoneyStr floatValue] - [voucherMoneyStr floatValue];
        self.voucherLabel.text = [NSString stringWithFormat:@"抵用：%.2f元",voucherMoney];
    }else//全部抵用
    {
        self.payAmountMoney = 0;
        bottomStr = @"实付：0.00元";
        self.voucherLabel.text = [NSString stringWithFormat:@"抵用：%.2f元",self.amountMoney];
    }
    self.bottomLabel.text = bottomStr;
}
#pragma mark - 付款
- (void)confirmBtnDidClick
{
    [self showComfirmPayAlertView];
}
- (void)showComfirmPayAlertView
{
    BOOL hasEnoughMoney = [YZTool hasEnoughMoneyWithAmountMoney:self.payAmountMoney];
    if (hasEnoughMoney ||  self.payAmountMoney == 0) {
        NSString * message = [YZTool getAlertViewTextWithAmountMoney:self.payAmountMoney];
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
    NSNumber * cmd = @(8026);
    if (self.isJC) {
        cmd = @(8028);
    }
    [MBProgressHUD showMessage:text_gettingCurrentTerm toView:self.view];
    NSDictionary *dict = @{
                           @"cmd":cmd,
                           @"gameId":self.gameId
                           };
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];
        if(SUCCESS)
        {
            if (self.isJC) {
                [self isJump:Jump];
            }else
            {
                NSArray *termList = json[@"game"][@"termList"];
                if(!termList.count)
                {
                    [MBProgressHUD showError:text_sailStop];
                    return;
                }
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
        [MBProgressHUD showMessage:text_paying toView:self.view];
        if (self.isJC) {
            [self comfirmPayJC];//竞彩支付
        }else if (self.isSFC)//胜负彩
        {
            [self comfirmPaySFC];
        }else
        {
            [self comfirmPay];//支付
        }
    }else //跳转网页
    {
#if JG
        NSString * mcpStr = @"EZmcp";
#elif ZC
        NSString * mcpStr = @"ZCmcp";
#elif CS
        NSString * mcpStr = @"CSmcp";
#elif RR
        NSString * mcpStr = @"CSmcp";
#endif
        if (self.isJC) {
            [MBProgressHUD hideHUDForView:self.view];
            NSNumber *multiple = [NSNumber numberWithInt:self.multiple];//投多少倍
            NSNumber *amount = [NSNumber numberWithInt:(int)self.amountMoney * 100];
            NSString *number = self.numbers;
            NSString *param = [NSString stringWithFormat:@"userId=%@&gameId=%@&multiple=%@&amount=%@&number=%@&payType=%@&id=%@&channel=%@&childChannel=%@&version=%@&playType=%@&betType=%@&remark=%@",UserId,self.gameId,multiple,amount,[number URLEncodedString],@"ACCOUNT",@"1407305392008",mainChannel,childChannel,[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],self.playType,self.betType,mcpStr];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",jumpURLStr,param]];
            YZLog(@"url = %@",url);
            
            [[UIApplication sharedApplication] openURL:url];
        }else if (self.isSFC)
        {
            [MBProgressHUD hideHUDForView:self.view];
            NSNumber *multiple = [NSNumber numberWithInt:self.multiple];//投多少倍
            NSNumber *amount = [NSNumber numberWithInt:(int)self.amountMoney * 100];
            NSMutableArray *ticketList = self.ticketList;
            NSString *ticketListJsonStr = [ticketList JSONRepresentation];
            YZLog(@"ticketListJsonStr = %@",ticketListJsonStr);
            NSString *param = [NSString stringWithFormat:@"userId=%@&gameId=%@&termId=%@&multiple=%@&amount=%@&ticketList=%@&payType=%@&id=%@&channel=%@&childChannel=%@&version=%@&playType=%@&termCount=%@&remark=%@",UserId,self.gameId,self.currentTermId,multiple,amount,[ticketListJsonStr URLEncodedString],@"ACCOUNT",@"1407305392008",mainChannel,childChannel,[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],_playType,@(1),mcpStr];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",jumpURLStr,param]];
            [[UIApplication sharedApplication] openURL:url];
        }else
        {
            [MBProgressHUD hideHUDForView:self.view];
            NSNumber *multiple = [NSNumber numberWithInt:self.multiple];//投多少倍
            NSNumber *amount = [NSNumber numberWithInt:(int)self.amountMoney * 100];
            NSMutableArray *ticketList = self.ticketList;
            NSString *ticketListJsonStr = [ticketList JSONRepresentation];
            YZLog(@"ticketListJsonStr = %@",ticketListJsonStr);
            NSString *param = [NSString stringWithFormat:@"userId=%@&gameId=%@&termId=%@&multiple=%@&amount=%@&ticketList=%@&payType=%@&termCount=%@&startTermId=%@&winStop=%@&id=%@&channel=%@&childChannel=%@&version=%@&remark=%@",UserId,self.gameId,self.currentTermId,multiple,amount,[ticketListJsonStr URLEncodedString],@"ACCOUNT",@1,self.currentTermId,@false,@"1407305392008",mainChannel,childChannel,[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],mcpStr];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",jumpURLStr,param]];
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
#pragma  mark - 确认支付
- (void)comfirmPay//支付接口
{
    NSNumber *multiple = [NSNumber numberWithInt:self.multiple];//投多少倍
    NSNumber *amount = [NSNumber numberWithInt:(int)self.amountMoney * 100];
    NSDictionary * dict= [NSDictionary dictionary];
    if (self.voucherStatus) {//选择彩券
        dict =@{
                @"cmd":@(8052),
                @"userId":UserId,
                @"gameId":self.gameId,
                @"termId":self.currentTermId,
                @"multiple":multiple,
                @"amount":amount,
                @"ticketList":self.ticketList,
                @"payType":@"ACCOUNTCOUPON",
                @"startTermId":self.currentTermId,
                @"couponId":self.voucherStatus.couponId
                };
    }else
    {
        dict =@{
                @"cmd":@(8052),
                @"userId":UserId,
                @"gameId":self.gameId,
                @"termId":self.currentTermId,
                @"multiple":multiple,
                @"amount":amount,
                @"ticketList":self.ticketList,
                @"payType":@"ACCOUNT",
                @"startTermId":self.currentTermId,
                };
    }
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];//隐藏正在支付的弹框
        if(SUCCESS)
        {
            YZBetSuccessViewController *betSuccessVc = [[YZBetSuccessViewController alloc] init];
            betSuccessVc.payVcType = BetTypeNormal;
            betSuccessVc.termCount = 1;
            //删除数据库中得所有号码球数据
            [YZStatusCacheTool deleteAllStatus];
            //跳转
            [self.navigationController pushViewController:betSuccessVc animated:YES];
        }else
        {
            ShowErrorView;
        }
    }failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"error = %@",error);
    }];
}
- (void)comfirmPayJC
{
    NSNumber *multiple = [NSNumber numberWithInt:self.multiple];//投多少倍
    NSNumber *amount = [NSNumber numberWithInt:(int)self.amountMoney * 100];
    NSDictionary * dict= [NSDictionary dictionary];
    if (self.voucherStatus) {//选择彩券
        dict =@{
                @"cmd":@(8034),
                @"userId":UserId,
                @"gameId":self.gameId,
                @"multiple":multiple,
                @"amount":amount,
                @"payType":@"ACCOUNTCOUPON",
                @"number":self.numbers,
                @"playType":self.playType,
                @"betType":self.betType,
                @"couponId":self.voucherStatus.couponId
                };
    }else
    {
        dict =@{
                @"cmd":@(8034),
                @"userId":UserId,
                @"gameId":self.gameId,
                @"multiple":multiple,
                @"amount":amount,
                @"payType":@"ACCOUNT",
                @"number":self.numbers,
                @"playType":self.playType,
                @"betType":self.betType,
                };
    }
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];//隐藏正在支付的弹框
        if(SUCCESS)
        {
            //支付成功控制器
            YZFbBetSuccessViewController *betSuccessVc = [[YZFbBetSuccessViewController alloc] initWithAmount:[amount floatValue] bonus:[json[@"balance"] floatValue] isJC:YES];
            //跳转
            [self.navigationController pushViewController:betSuccessVc animated:YES];
        }else
        {
            ShowErrorView;
        }
    }failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"error = %@",error);
    }];
}
- (void)comfirmPaySFC
{
    NSNumber *multiple = [NSNumber numberWithInt:self.multiple];//投多少倍
    NSNumber *amount = [NSNumber numberWithInt:(int)self.amountMoney * 100];
    NSDictionary * dict= [NSDictionary dictionary];
    if (self.voucherStatus) {//选择彩券
        dict =@{
                @"cmd":@(8052),
                @"userId":UserId,
                @"gameId":self.gameId,
                @"termId":self.termId,
                @"multiple":multiple,
                @"amount":amount,
                @"payType":@"ACCOUNTCOUPON",
                @"playType":_playType,
                @"termCount":@(1),
                @"ticketList":self.ticketList,
                @"couponId":self.voucherStatus.couponId
                };
    }else
    {
        dict =@{
                @"cmd":@(8052),
                @"userId":UserId,
                @"gameId":self.gameId,
                @"termId":self.termId,
                @"multiple":multiple,
                @"amount":amount,
                @"payType":@"ACCOUNT",
                @"playType":_playType,
                @"termCount":@(1),
                @"ticketList":self.ticketList,
                };
    }
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.view];//隐藏正在支付的弹框
        if(SUCCESS)
        {
            //支付成功控制器
            YZFbBetSuccessViewController *betSuccessVc = [[YZFbBetSuccessViewController alloc] initWithAmount:[amount floatValue] bonus:[json[@"balance"] floatValue] isJC:NO];
            //跳转
            [self.navigationController pushViewController:betSuccessVc animated:YES];
        }else
        {
            ShowErrorView;
        }
    }failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        YZLog(@"error = %@",error);
    }];
}
@end
