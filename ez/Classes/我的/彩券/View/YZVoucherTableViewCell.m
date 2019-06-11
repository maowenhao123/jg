//
//  YZVoucherTableViewCell.m
//  ez
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZVoucherTableViewCell.h"
#import "YZDateTool.h"

@interface YZVoucherTableViewCell ()

@property (nonatomic, weak) UIImageView *backImageView;
@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) UILabel *balanceLabel;//余额
@property (nonatomic, weak) UILabel *titleLabel;//标题
@property (nonatomic, weak) UILabel *descriptionLabel;//描述
@property (nonatomic, weak) UILabel *timeLabel;//有效期

@end

@implementation YZVoucherTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *ID = @"VoucherTableViewCell";
    YZVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZVoucherTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = YZBackgroundColor;
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    CGFloat backImageViewH = 82;
    //背景
    UIImageView * backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"voucher_backImage"]];
    self.backImageView = backImageView;
    backImageView.hidden = YES;
    backImageView.frame = CGRectMake(18 * screenWidth / 375, 0, 340 * screenWidth / 375, backImageViewH);
    [self addSubview:backImageView];
    
    UIView * backView = [[UIView alloc] init];
    self.backView = backView;
    backView.frame = CGRectMake(18 * screenWidth / 375, 0, 340 * screenWidth / 375, backImageViewH);
    [self addSubview:backView];
    
    UIImageView * leftBackImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"voucher_backImage_left"]];
    leftBackImageView.frame = CGRectMake(0, 0, 242 * screenWidth / 375, backImageViewH);
    [backView addSubview:leftBackImageView];
    
    UIImageView * rightBackImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"voucher_backImage_right"]];
    rightBackImageView.frame = CGRectMake(242 * screenWidth / 375, 0, 97 * screenWidth / 375, backImageViewH);
    [backView addSubview:rightBackImageView];
    
    //金额
    UILabel *balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20 * screenWidth / 375, 0, 90 * screenWidth / 375, backImageViewH)];
    self.balanceLabel = balanceLabel;
    balanceLabel.textColor = UIColorFromRGB(0xde352f);
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:balanceLabel];
    
    //标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(110 * screenWidth / 375, 12, 150 * screenWidth / 375, 22)];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    titleLabel.textColor = UIColorFromRGB(0x2b2b2b);
    [self addSubview:titleLabel];
    
    //描述
    UILabel * descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(110 * screenWidth / 375, 37, 150 * screenWidth / 375, 17)];
    self.descriptionLabel = descriptionLabel;
    descriptionLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    descriptionLabel.textColor = UIColorFromRGB(0xb4b4b4);
    [self addSubview:descriptionLabel];
    
    //有效期
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(110 * screenWidth / 375, 56, 150 * screenWidth / 375, 17)];
    self.timeLabel = timeLabel;
    timeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    timeLabel.textColor = UIColorFromRGB(0xb4b4b4);
    [self addSubview:timeLabel];
    
    //去使用
    UIButton * goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goButton = goButton;
    [goButton setTitle:@"去使用" forState:UIControlStateNormal];
    [goButton setTitleColor:UIColorFromRGB(0xfd3736) forState:UIControlStateNormal];
    goButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    goButton.frame = CGRectMake(260 * screenWidth / 375, 0, 90 * screenWidth / 375, backImageViewH);
    [goButton addTarget:self action:@selector(goButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:goButton];
}

- (void)goButtonDidClick
{
    //发送返回购彩大厅通知
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.viewController.navigationController popToRootViewControllerAnimated:NO];
        });
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ToBuyLottery" object:nil];
        });
    }];
    [op2 addDependency:op1];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue waitUntilAllOperationsAreFinished];
    [queue addOperation:op1];
    [queue addOperation:op2];
}

- (void)setIndex:(int)index
{
    _index = index;
}

- (void)setStatus:(YZVoucherStatus *)status
{
    _status = status;
    
    if (self.index == 1) {//可用
        self.backView.hidden = NO;
        self.backImageView.hidden = YES;
        self.balanceLabel.textColor = UIColorFromRGB(0xde352f);
        self.titleLabel.textColor = UIColorFromRGB(0x2b2b2b);
        self.descriptionLabel.textColor = UIColorFromRGB(0xb4b4b4);
        self.timeLabel.textColor = UIColorFromRGB(0xb4b4b4);
        self.goButton.hidden = NO;
    }else
    {
        self.backView.hidden = YES;
        self.backImageView.hidden = NO;
        self.balanceLabel.textColor = YZGrayTextColor;
        self.titleLabel.textColor = YZGrayTextColor;
        self.descriptionLabel.textColor = YZGrayTextColor;
        self.timeLabel.textColor = YZGrayTextColor;
        self.goButton.hidden = YES;
    }
    //面值
    NSString * moneyStr = [NSString stringWithFormat:@"%d", [status.balance intValue] / 100];
    NSMutableAttributedString * moneyAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@", moneyStr]];
    [moneyAttStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:YZGetFontSize(50)] range:NSMakeRange(0, 1)];
    [moneyAttStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:YZGetFontSize(54)] range:NSMakeRange(1, moneyStr.length)];
    self.balanceLabel.attributedText = moneyAttStr;
    
    //标题
    self.titleLabel.text = status.title;
    
    //简介
    self.descriptionLabel.text = status.remark;
    
    //时间
    NSString * endDate  = [YZDateTool getTimeByTimestamp:status.endDate format:@"yyyy-MM-dd HH:mm"];
    self.timeLabel.text = [NSString stringWithFormat:@"有效期:%@",endDate];
}

@end
