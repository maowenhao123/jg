//
//  YZMoneyDetailTableViewCell.m
//  ez
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZMoneyDetailTableViewCell.h"

@interface YZMoneyDetailTableViewCell ()

@property (nonatomic, weak) UILabel *descLabel;
@property (nonatomic, weak) UILabel *createTimeLabel;
@property (nonatomic, weak) UILabel *moneyLabel;

@end

@implementation YZMoneyDetailTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *ID = @"MoneyDetailCellId";
    YZMoneyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZMoneyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChilds];
    }
    return self;
}

- (void)setupChilds
{
    //1、描述label
    UILabel *descLabel = [[UILabel alloc] init];
    self.descLabel = descLabel;
    descLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    descLabel.textColor = YZBlackTextColor;
    [self addSubview:descLabel];
    
    //2、创建时间label
    UILabel *createTimeLabel = [[UILabel alloc] init];
    self.createTimeLabel = createTimeLabel;
    createTimeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    createTimeLabel.textColor = YZColor(134, 134, 134, 134);
    [self addSubview:createTimeLabel];
    
    //3、money的label
    UILabel *moneyLabel = [[UILabel alloc] init];
    self.moneyLabel = moneyLabel;
    moneyLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    moneyLabel.textColor = YZColor(134, 134, 134, 134);
    [self addSubview:moneyLabel];
    
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [self addSubview:line];
}

- (void)setStatus:(YZMoneyDetail *)status
{
    _status = status;
    self.descLabel.text = status.desc;
    self.createTimeLabel.text = status.createTime;
    
    if (self.type == 3) {//积分单位是”个“
        self.moneyLabel.text = [NSString stringWithFormat:@"%d积分",[status.money intValue]];
    }else
    {
        self.moneyLabel.text = [NSString stringWithFormat:@"%.2f元",[status.money intValue] / 100.0];
    }
    
    CGSize descSize = [self.descLabel.text sizeWithLabelFont:self.descLabel.font];
    CGSize timeSize = [self.createTimeLabel.text sizeWithLabelFont:self.createTimeLabel.font];
    CGSize moneySize = [self.moneyLabel.text sizeWithLabelFont:self.moneyLabel.font];
    
    CGFloat descLabelY = (65 - descSize.height - moneySize.height - 8) / 2;
    self.descLabel.frame = CGRectMake(YZMargin, descLabelY, descSize.width, descSize.height);
    self.createTimeLabel.frame = CGRectMake(screenWidth - timeSize.width - YZMargin, descLabelY, timeSize.width, timeSize.height);
    self.moneyLabel.frame = CGRectMake(YZMargin, CGRectGetMaxY(self.descLabel.frame) + 8, moneySize.width, moneySize.height);
}

@end
