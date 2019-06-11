//
//  YZBankCardTableViewCell.m
//  ez
//
//  Created by apple on 16/9/2.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZBankCardTableViewCell.h"

@interface YZBankCardTableViewCell ()

@property (nonatomic, weak) UIView * backView;
@property (nonatomic, weak) UIImageView *logoImageView;
@property (nonatomic, weak) UILabel *bankLabel;
@property (nonatomic, weak) UILabel *cardTypeLabel;
@property (nonatomic, weak) UILabel *cardLabel;

@end

@implementation YZBankCardTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *ID = @"BankCardCell";
    YZBankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZBankCardTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = YZBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    //背景
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, screenWidth - 20, 70)];
    self.backView = backView;
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 4;
    [self.contentView addSubview:backView];
    
    //logo
    CGFloat logoWH = 30;
    UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(YZMargin, 15, logoWH, logoWH)];
    self.logoImageView = logoImageView;
    [backView addSubview:logoImageView];
    
    //银行
    UILabel * bankLabel = [[UILabel alloc]initWithFrame:CGRectMake(67, 5, backView.width - 67, 20)];
    self.bankLabel = bankLabel;
    bankLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    bankLabel.textColor = [UIColor whiteColor];
    [backView addSubview: bankLabel];
    
    //银行卡类型
    UILabel * cardTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(bankLabel.x, 25,bankLabel.width, 15)];
    self.cardTypeLabel = cardTypeLabel;
    cardTypeLabel.text = @"储蓄卡";
    cardTypeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(20)];
    cardTypeLabel.textColor = [UIColor whiteColor];
    [backView addSubview: cardTypeLabel];
    
    //银行卡号
    UILabel * cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(bankLabel.x, 40, bankLabel.width, 25)];
    self.cardLabel = cardLabel;
    cardLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    cardLabel.textColor = [UIColor whiteColor];
    [backView addSubview:cardLabel];
}
- (void)setStatus:(YZBankCardStatus *)status
{
    _status = status;
    NSDictionary * bankDic = [YZTool getBankDicInfo];
    if (bankDic[_status.bank]) {
        self.logoImageView.image = [UIImage imageNamed:bankDic[_status.bank]];
    }else
    {
        self.logoImageView.image = [UIImage imageNamed:@"其他银行"];
    }
    self.bankLabel.text = status.bank;
    NSString * accountName = status.accountNumber;
    self.cardLabel.text = accountName;

    //设置背景颜色
    if ([_status.bank isEqualToString:@"中国建设银行"]) {
        self.backView.backgroundColor = YZColor(85, 132, 222, 1);
    }else if ([_status.bank isEqualToString:@"中国工商银行"])
    {
        self.backView.backgroundColor = YZColor(251, 100, 151, 1);
    }else if ([_status.bank isEqualToString:@"招商银行"])
    {
        self.backView.backgroundColor = YZColor(236, 75, 65, 1);
    }else if ([_status.bank isEqualToString:@"中国银行"])
    {
        self.backView.backgroundColor = YZColor(208, 48, 42, 1);
    }else if ([_status.bank isEqualToString:@"中国农业银行"])
    {
        self.backView.backgroundColor = YZColor(23, 166, 146, 1);
    }else//其他银行
    {
        self.backView.backgroundColor = YZColor(166, 202, 228, 1);
    }
}
@end
