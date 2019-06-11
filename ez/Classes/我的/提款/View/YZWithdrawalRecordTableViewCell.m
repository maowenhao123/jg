//
//  YZWithdrawalRecordTableViewCell.m
//  ez
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 9ge. All rights reserved.
//
#import "YZWithdrawalRecordTableViewCell.h"

@interface YZWithdrawalRecordTableViewCell ()

@property (nonatomic, weak) UIImageView *logo;
@property (nonatomic, weak) UILabel *bankLabel;
@property (nonatomic, weak) UILabel *bankNumberLabel;
@property (nonatomic, weak) UILabel *moneyLabel;
@property (nonatomic, weak) UILabel *statusLabel;
@property (nonatomic, weak) UILabel *timeLabel;

@end

@implementation YZWithdrawalRecordTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *ID = @"WithdrawalRecordCell";
    YZWithdrawalRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZWithdrawalRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    //logo
    CGFloat logoWH = 30;
    UIImageView * logo = [[UIImageView alloc]init];
    self.logo = logo;
    logo.frame = CGRectMake(YZMargin, (85 - logoWH) / 2, logoWH, logoWH);
    [self addSubview:logo];
    
    //银行
    UILabel * bankLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.logo.frame) + YZMargin, 5, screenWidth - CGRectGetMaxX(self.logo.frame) - YZMargin, 30)];
    self.bankLabel = bankLabel;
    bankLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    bankLabel.textColor = YZBlackTextColor;
    [self addSubview:bankLabel];
    
    //银行卡号
    UILabel * bankNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bankLabel.x, 35, self.bankLabel.width, 20)];
    self.bankNumberLabel = bankNumberLabel;
    bankNumberLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    bankNumberLabel.textColor = YZGrayTextColor;
    [self addSubview:bankNumberLabel];
    
    //金额
    UILabel * moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 100 - YZMargin, 0, 100, 60)];
    self.moneyLabel = moneyLabel;
    moneyLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    moneyLabel.textColor = YZBlackTextColor;
    moneyLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:moneyLabel];
    
    //时间
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bankLabel.x, 60, self.bankLabel.width, 25)];
    self.timeLabel = timeLabel;
    timeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    timeLabel.textColor = YZGrayTextColor;
    [self addSubview:timeLabel];
    
    //状态
    UILabel * statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 60 - YZMargin, 60, 60, 25)];
    self.statusLabel = statusLabel;
    statusLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    statusLabel.textColor = YZBlackTextColor;
    statusLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:statusLabel];
    
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(self.bankLabel.x, 60, screenWidth - self.bankLabel.x, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [self addSubview:line];
}
- (void)setStatus:(YZWithdrawalRecordStatus *)status
{
    _status = status;
    NSDictionary * bankDic = [YZTool getBankDicInfo];
    if (bankDic[_status.bank]) {
        self.logo.image = [UIImage imageNamed:bankDic[_status.bank]];
    }else
    {
        self.logo.image = [UIImage imageNamed:@"其他银行"];
    }
    self.bankLabel.text = _status.bank;
    self.bankNumberLabel.text = _status.accountNumber;
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[_status.money floatValue] / 100.0];
    self.timeLabel.text = _status.createTime;
    self.statusLabel.text = _status.statusDesc;
}
@end
