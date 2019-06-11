//
//  YZWithdrawalBankCardTableViewCell.m
//  ez
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZWithdrawalBankCardTableViewCell.h"

@interface YZWithdrawalBankCardTableViewCell ()

@property (nonatomic, weak) UIImageView *bankIcon;
@property (nonatomic, weak) UILabel * bankNameLabel;
@property (nonatomic, weak) UILabel *bankNumberLabel;
@property (nonatomic, weak) UIImageView *selectedIcon;

@end

@implementation YZWithdrawalBankCardTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *ID = @"WithdrawalBankCardCell";
    YZWithdrawalBankCardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZWithdrawalBankCardTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
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
    //银行图标
    UIImageView * bankIcon = [[UIImageView alloc]init];
    self.bankIcon = bankIcon;
    [self addSubview:bankIcon];
    
    //银行名称
    UILabel * bankNameLabel = [[UILabel alloc]init];
    self.bankNameLabel = bankNameLabel;
    bankNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    bankNameLabel.textColor = YZGrayTextColor;
    [self addSubview:bankNameLabel];
    
    //银行卡号
    UILabel * bankNumberLabel = [[UILabel alloc]init];
    self.bankNumberLabel = bankNumberLabel;
    bankNumberLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    bankNumberLabel.textColor = YZGrayTextColor;
    bankNumberLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:bankNumberLabel];
    
    //选中图标
    UIImageView * selectedIcon = [[UIImageView alloc]init];
    self.selectedIcon = selectedIcon;
    [self addSubview:selectedIcon];
    
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [self addSubview:line];
}
- (void)setStatus:(YZBankCardStatus *)status
{
    _status = status;
    self.bankNameLabel.text = _status.bank;
    self.bankNumberLabel.text = _status.accountNumber;
    NSDictionary * bankDic = [YZTool getBankDicInfo];
    if (_status.isSelected) {//被选中状态
        if (bankDic[_status.bank]) {
            self.bankIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@小", bankDic[_status.bank]]];
        }else
        {
            self.bankIcon.image = [UIImage imageNamed:@"其他银行小"];
        }
        self.bankNameLabel.textColor = YZColor(1, 203, 187, 1);
        self.bankNumberLabel.textColor = YZColor(1, 203, 187, 1);
        self.selectedIcon.image = [UIImage imageNamed:@"withdrawal_bankCard_selected"];
    }else
    {
        if (bankDic[_status.bank]) {
            self.bankIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@灰", _status.bank]];
        }else
        {
            self.bankIcon.image = [UIImage imageNamed:@"其他银行灰"];
        }
        self.bankNameLabel.textColor = YZGrayTextColor;
        self.bankNumberLabel.textColor = YZGrayTextColor;
        self.selectedIcon.image = [UIImage imageNamed:@"withdrawal_bankCard_uncheck"];
    }
    
    //frame
    CGFloat bankIconWH = 18;
    CGFloat bankIconY = (YZCellH - bankIconWH) / 2;
    self.bankIcon.frame = CGRectMake(YZMargin, bankIconY, bankIconWH, bankIconWH);
    
    CGSize bankNameSize = [self.bankNameLabel.text sizeWithLabelFont:self.bankNameLabel.font];
    self.bankNameLabel.frame = CGRectMake(CGRectGetMaxX(self.bankIcon.frame) + YZMargin, 0, bankNameSize.width, YZCellH);
    
    CGFloat selectedIconWH = 18;
    CGFloat selectedIconY = (YZCellH - selectedIconWH) / 2;
    self.selectedIcon.frame = CGRectMake(screenWidth - YZMargin - selectedIconWH, selectedIconY, selectedIconWH, selectedIconWH);
    
    CGSize bankNumberSize = [self.bankNumberLabel.text sizeWithLabelFont:self.bankNumberLabel.font];
    self.bankNumberLabel.frame = CGRectMake(self.selectedIcon.x - YZMargin - bankNumberSize.width, 0, bankNumberSize.width, YZCellH);
    
}
@end
