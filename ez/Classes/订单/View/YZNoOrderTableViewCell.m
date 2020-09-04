//
//  YZNoOrderTableViewCell.m
//  ez
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define time 0.3

#import "YZNoOrderTableViewCell.h"
#import "YZChooseVoucherViewController.h"
#import "YZRechargeListViewController.h"
#import "YZBetSuccessViewController.h"
#import "YZNavigationController.h"
#import "YZWinNumberBall.h"
#import "NSObject+SBJSON.h"

@interface YZNoOrderTableViewCell ()

@property (nonatomic, weak) UIView *ballView;
@property (nonatomic, strong) NSArray *ssqBalls;
@property (nonatomic, weak) UIButton * afreshButton;
@property (nonatomic, copy) NSString *currentTermId;

@end

@implementation YZNoOrderTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"noOrderTableViewCell";
    YZNoOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell)
    {
        cell = [[YZNoOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = YZBackgroundColor;
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    //提示
    UILabel * promptLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, screenHeight * 0.18, screenWidth, 20)];
    promptLabel.text = @"没有购买记录，为您推荐双色球幸运号码";
    promptLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.textColor = YZGrayTextColor;
    [self addSubview: promptLabel];
    
    //选球的背景图片
    CGFloat scale = 0.9;
    CGFloat backImageViewW = 260 * scale;
    CGFloat backImageViewH = 77 * scale;
    CGFloat backImageViewX = (screenWidth - backImageViewW) / 2;
    CGFloat backImageViewY = CGRectGetMaxY(promptLabel.frame) + 26;
    UIImageView * backImageView = [[UIImageView alloc]init];
    backImageView.frame = CGRectMake(backImageViewX, backImageViewY, backImageViewW, backImageViewH);
    backImageView.image = [UIImage imageNamed:@"no_order_back_icon"];
    [self addSubview:backImageView];
    
    //选球的白色背景
    CGFloat ballViewW = 227 * scale;
    CGFloat ballViewH = 45 * scale;
    CGFloat ballViewX = 13 * scale;
    CGFloat ballViewY = 17 * scale;
    UIView * ballView = [[UIView alloc]init];
    self.ballView = ballView;
    ballView.frame = CGRectMake(ballViewX, ballViewY, ballViewW, ballViewH);
    ballView.layer.masksToBounds = YES;
    [backImageView addSubview:ballView];
    
    //换一注
    CGFloat afreshButtonW = 48 * scale;
    CGFloat afreshButtonH = 77 * scale;
    CGFloat afreshButtonY = backImageView.y + 3;
    UIButton * afreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.afreshButton = afreshButton;
    afreshButton.frame = CGRectMake(CGRectGetMaxX(backImageView.frame) - 3, afreshButtonY, afreshButtonW, afreshButtonH);
    [afreshButton setImage:[UIImage imageNamed:@"no_order_afresh_up"] forState:UIControlStateNormal];
    [afreshButton setImage:[UIImage imageNamed:@"no_order_afresh_down"] forState:UIControlStateHighlighted];
    [afreshButton setImage:[UIImage imageNamed:@"no_order_afresh_down"] forState:UIControlStateSelected];
    [afreshButton addTarget:self action:@selector(setSsqBallViewBall) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:afreshButton];
    
    //立即投注
    YZBottomButton * betButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    betButton.frame = CGRectMake(backImageView.x, CGRectGetMaxY(backImageView.frame) + 22, 239 * scale, 40 * scale);
    betButton.center = CGPointMake(screenWidth / 2, betButton.center.y);
    [betButton setTitle:@"立即投注" forState:UIControlStateNormal];
    [betButton addTarget:self action:@selector(fastBetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:betButton];
    
    [self setSsqBallViewBall];
}
- (void)setSsqBallViewBall
{
    //手柄向下
    self.afreshButton.selected = YES;
    dispatch_time_t selectedtime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animateDuration * NSEC_PER_SEC));
    dispatch_after(selectedtime, dispatch_get_main_queue(), ^{
       self.afreshButton.selected = NO;
    });
    for (UIView * subView in self.ballView.subviews) {//先删除之前的视图
        [subView removeFromSuperview];
    }
    //红球
    NSMutableSet *redSet = [NSMutableSet set];
    while (redSet.count < 6) {//红球至少6个
        int random = arc4random() % 33 + 1;
        [redSet addObject:@(random)];
    }
    NSMutableArray * array1 = [NSMutableArray array];
    for (NSNumber * number in redSet) {
        YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
        ballStatus.number = [NSString stringWithFormat:@"%02d",[number intValue]];
        ballStatus.type = 1;
        [array1 addObject:ballStatus];
    }
    //对红球数组排序
    NSMutableArray *sortArray1 = [self sortBallsArray:array1];
    //蓝球
    NSMutableSet *blueSet = [NSMutableSet set];
    while (blueSet.count < 1) {
        int random = arc4random() % 16 + 1;
        [blueSet addObject:@(random)];
    }
    NSMutableArray * array2 = [NSMutableArray array];
    for (NSNumber * number in blueSet) {
        YZWinNumberBallStatus * ballStatus = [[YZWinNumberBallStatus alloc]init];
        ballStatus.number = [NSString stringWithFormat:@"%02d",[number intValue]];
        ballStatus.type = 2;
        [array2 addObject:ballStatus];
    }
    //对蓝球数组排序
    NSMutableArray *sortArray2 = [self sortBallsArray:array2];
    //合并数组
    NSMutableArray * array = [NSMutableArray arrayWithArray:sortArray1];
    [array addObjectsFromArray:sortArray2];
    self.ssqBalls = array;
    
    CGFloat rollBallW = self.ballView.width / array.count;
    CGFloat rollBallH = self.ballView.height;
    CGFloat ballWH = rollBallW - 6;
    for (YZWinNumberBallStatus * ballStatus in array) {
        NSInteger index = [array indexOfObject:ballStatus];
        NSInteger count = (index + 1) * 2;
        UIView * rollBallView = [[UIView alloc]init];
        rollBallView.frame = CGRectMake(rollBallW * index, 0, rollBallW, rollBallH * count);
        for (int i = 0; i < count; i++) {
            YZWinNumberBallStatus * rollBallStatus = [[YZWinNumberBallStatus alloc]init];
            if (i != 0) {//最上面的是array中的数据
                if (ballStatus.type == 1) {
                    rollBallStatus.number = [NSString stringWithFormat:@"%02d",[self getRandomRedBallNumber]];
                    rollBallStatus.type = 1;
                }else
                {
                    rollBallStatus.number = [NSString stringWithFormat:@"%02d",[self getRandomBlueBallNumber]];
                    rollBallStatus.type = 2;
                }
            }else
            {
                rollBallStatus = ballStatus;
            }
            CGFloat ballY = rollBallH * (i + 1 - count) + (rollBallH - ballWH) / 2;
            YZWinNumberBall * ball = [[YZWinNumberBall alloc]init];
            ball.frame = CGRectMake(4, ballY, ballWH, ballWH);
            ball.status = rollBallStatus;
            [rollBallView addSubview:ball];
        }
        //动画
        CGFloat animateH = rollBallView.height - rollBallH;
        [UIView animateWithDuration:(index + 1) * time
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             rollBallView.y = rollBallView.y + animateH;
                         } completion:^(BOOL finished) {
                             
                         }];
        [self.ballView addSubview:rollBallView];
    }
}
#pragma mark - 购买
- (void)fastBetBtnClick
{
    [self loadUserInfo];
}
- (void)loadUserInfo
{
    if (!UserId)
    {
        return;
    }
    NSDictionary *dict = @{
                           @"cmd":@(8006),
                           @"userId":UserId
                           };
    [MBProgressHUD showMessage:@"客官请稍后" toView:self.viewController.tabBarController.view];
    [[YZHttpTool shareInstance] requestTarget:self.owner PostWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
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
        YZLog(@"账户error");
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
    }];
}
- (void)getConsumableList
{
    NSDictionary * orderDic = @{
                                @"money":@(200),
                                @"game":@"F01"
                                };
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"order":orderDic,
                           };
    [MBProgressHUD showMessage:@"客官请稍后" toView:self.viewController.tabBarController.view];
    [[YZHttpTool shareInstance] requestTarget:self.owner PostWithURL:BaseUrlCoupon(@"/getConsumableList") params:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
        if (SUCCESS) {;
            NSArray * respCouponList = json[@"respCouponList"];
            if (respCouponList.count == 0) {//没有彩券直接购买
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
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
    }];
}
- (void)gotoChooseVoucherVC
{
    //选择彩券
    YZChooseVoucherViewController * chooseVoucherVC = [[YZChooseVoucherViewController alloc]init];
    chooseVoucherVC.gameId = @"F01";
    chooseVoucherVC.amountMoney = 2;
    chooseVoucherVC.betCount = 1;
    chooseVoucherVC.multiple = 1;
    chooseVoucherVC.ticketList = [self getTicketList];
    [self.owner.navigationController pushViewController:chooseVoucherVC animated:YES];
}
- (void)showComfirmPayAlertView
{
    BOOL hasEnoughMoney = [YZTool hasEnoughMoneyWithAmountMoney:2];
    if (hasEnoughMoney) {
        NSString * message = [YZTool getAlertViewTextWithAmountMoney:2];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"支付确认" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self getCurrentTermData];//当前期次的信息
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self.owner presentViewController:alertController animated:YES completion:nil];
    }else
    {
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"余额不足" message:@"对不起，余额不足，请充值。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * alertAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * alertAction2 = [UIAlertAction actionWithTitle:@"去充值" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self gotoRecharge];
        }];
        [alertController addAction:alertAction1];
        [alertController addAction:alertAction2];
        [self.owner presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)gotoRecharge
{
    YZRechargeListViewController *rechargeVc = [[YZRechargeListViewController alloc] init];
    [self.owner.navigationController pushViewController:rechargeVc animated:YES];
}
//获取当前期信息
- (void)getCurrentTermData
{
    NSDictionary *dict = @{
                           @"cmd":@(8026),
                           @"gameId":@"F01"
                           };
    [MBProgressHUD showMessage:text_gettingCurrentTerm toView:self.viewController.tabBarController.view];
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
        if(SUCCESS)
        {
            NSArray *termList = json[@"game"][@"termList"];
            if(!termList.count)
            {
                [MBProgressHUD showError:text_sailStop];
                return;
            }
            self.currentTermId = [termList lastObject][@"termId"];
            [self comfirmPay];//支付
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        YZLog(@"getCurrentTermData - error = %@",error);
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
    }];
}

#pragma  mark - 确认支付
- (void)comfirmPay//支付接口
{
    NSNumber *multiple = @(1);//投多少倍
    NSNumber *amount = @(200);
    NSMutableArray *ticketList = [self getTicketList];
    NSDictionary * dict = @{
                            @"cmd":@(8052),
                            @"userId":UserId,
                            @"gameId":@"F01",
                            @"termId":self.currentTermId,
                            @"multiple":multiple,
                            @"amount":amount,
                            @"ticketList":ticketList,
                            @"payType":@"ACCOUNT",
                            @"startTermId":self.currentTermId,
                            };
    [MBProgressHUD showMessage:text_paying toView:self.viewController.tabBarController.view];
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
        if(SUCCESS)
        {
            YZBetSuccessViewController *betSuccessVc = [[YZBetSuccessViewController alloc] init];
            betSuccessVc.termCount = 1;
            //跳转
            [self.owner.navigationController pushViewController:betSuccessVc animated:YES];
        }else
        {
            ShowErrorView;
        }
    } failure:^(NSError *error) {
        YZLog(@"error = %@",error);
        [MBProgressHUD hideHUDForView:self.viewController.tabBarController.view animated:YES];
    }];
}
- (NSMutableArray *)getTicketList
{
    NSMutableArray * ticketList = [NSMutableArray array];
    NSMutableString *numbers = [NSMutableString string];
    for(YZWinNumberBallStatus * ballStatus in self.ssqBalls)
    {
        if (ballStatus.type == 1) {
            [numbers appendString:[NSString stringWithFormat:@",%@",ballStatus.number]];
        }else if (ballStatus.type == 2)
        {
            [numbers appendString:[NSString stringWithFormat:@"|%@",ballStatus.number]];
        }
    }
    [numbers deleteCharactersInRange:NSMakeRange(0, 1)];//删除第一个一个逗号
    NSDictionary *dict = @{@"numbers":numbers,
                           @"betType":@"00",
                           @"playType":@"00"};
    [ticketList addObject:dict];
    return ticketList;
}
#pragma mark - 工具
- (int)getRandomRedBallNumber
{
    return arc4random() % 33 + 1;
}
- (int)getRandomBlueBallNumber
{
    return arc4random() % 16 + 1;
}
//冒泡排序球数组
- (NSMutableArray *)sortBallsArray:(NSMutableArray *)mutableArray
{
    if(mutableArray.count == 1) return mutableArray;
    for(int i = 0;i < mutableArray.count;i++)
    {
        for(int j = i + 1;j <mutableArray.count;j++)
        {
            YZWinNumberBallStatus * ballStatus1 = mutableArray[i];
            YZWinNumberBallStatus * ballStatus2 = mutableArray[j];
            int number1 = [ballStatus1.number intValue];
            int number2 = [ballStatus2.number intValue];
            if(number1 > number2)
            {
                [mutableArray replaceObjectAtIndex:i withObject:ballStatus2];
                [mutableArray replaceObjectAtIndex:j withObject:ballStatus1];
            }
        }
    }
    return mutableArray;
}

@end
