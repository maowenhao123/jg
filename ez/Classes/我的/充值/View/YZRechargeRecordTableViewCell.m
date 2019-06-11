//
//  YZRechargeRecordTableViewCell.m
//  ez
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZRechargeRecordTableViewCell.h"

@interface YZRechargeRecordTableViewCell ()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *moneyLabel;
@property (nonatomic, weak) UILabel *statusLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *orderNOLabel;

@end

@implementation YZRechargeRecordTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *ID = @"RechargeRecordCell";
    YZRechargeRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZRechargeRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
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
    //名字
    UILabel * nameLabel = [[UILabel alloc]init];
    self.nameLabel = nameLabel;
    nameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    nameLabel.textColor = YZBlackTextColor;
    [self addSubview:nameLabel];
    
    //金额
    UILabel * moneyLabel = [[UILabel alloc]init];
    self.moneyLabel = moneyLabel;
    moneyLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    moneyLabel.textColor = YZBlackTextColor;
    [self addSubview:moneyLabel];
    
    //时间
    UILabel * timeLabel = [[UILabel alloc]init];
    self.timeLabel = timeLabel;
    timeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    timeLabel.textColor = YZGrayTextColor;
    [self addSubview:timeLabel];
    
    //订单号
    UILabel * orderNOLabel = [[UILabel alloc]init];
    self.orderNOLabel = orderNOLabel;
    orderNOLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    orderNOLabel.textColor = YZGrayTextColor;
    [self addSubview:orderNOLabel];
    
    //状态
    UILabel * statusLabel = [[UILabel alloc]init];
    self.statusLabel = statusLabel;
    statusLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    statusLabel.textColor = YZBlackTextColor;
    [self addSubview:statusLabel];
    
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 65 - 1, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [self addSubview:line];
}
- (void)setStatus:(YZRechargeRecordStatus *)status
{
    _status = status;
    //设置数据
    self.nameLabel.text = _status.fundName;
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[_status.money intValue] / 100.0];
    self.timeLabel.text = _status.createTime;
    self.orderNOLabel.text = [NSString stringWithFormat:@"订单号:%@",_status.chargeId];
    self.statusLabel.text = _status.statusDesc;
    //设置frame
    CGSize nameSize = [self.nameLabel.text sizeWithLabelFont:self.nameLabel.font];
    CGSize moneySize = [self.moneyLabel.text sizeWithLabelFont:self.moneyLabel.font];
    CGSize timeSize = [self.timeLabel.text sizeWithLabelFont:self.timeLabel.font];
    CGSize orderNOSize = [self.orderNOLabel.text sizeWithLabelFont:self.orderNOLabel.font];
    CGSize statusSize = [self.statusLabel.text sizeWithLabelFont:self.statusLabel.font];
    CGFloat nameLabelY = (65 - moneySize.height - orderNOSize.height - 5) / 2;//以money
    self.nameLabel.frame = CGRectMake(YZMargin, nameLabelY, nameSize.width, nameSize.height);
    CGFloat moneyLabelX = nameSize.width == 0 ? YZMargin : CGRectGetMaxX(self.nameLabel.frame) + 5;
    self.moneyLabel.frame = CGRectMake(moneyLabelX, nameLabelY, moneySize.width, moneySize.height);
    self.timeLabel.frame = CGRectMake(screenWidth - YZMargin - timeSize.width, nameLabelY, timeSize.width, timeSize.height);
    self.orderNOLabel.frame = CGRectMake(YZMargin, CGRectGetMaxY(self.moneyLabel.frame) + 8, orderNOSize.width, orderNOSize.height);
    self.statusLabel.frame = CGRectMake(screenWidth - YZMargin - statusSize.width, self.orderNOLabel.y, statusSize.width, statusSize.height);
}
@end
