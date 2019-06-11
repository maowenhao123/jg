//
//  YZSmartBetTableViewCell.m
//  ez
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define lineWidth 0.4
#import "YZSmartBetTableViewCell.h"

@interface YZSmartBetTableViewCell ()

@property (nonatomic, weak) UILabel *tomorrowLabel;
@property (nonatomic, weak) UILabel *termLabel;
@property (nonatomic, weak) UILabel *multipleLabel;
@property (nonatomic, weak) UILabel *totalLabel;
@property (nonatomic, weak) UILabel *bonusLabel;
@property (nonatomic, weak) UILabel *profitLabel;
@property (nonatomic, weak) UIView *line1;
@property (nonatomic, weak) UIView *line2;
@property (nonatomic, weak) UIView *line3;
@property (nonatomic, weak) UIView *line4;
@property (nonatomic, weak) UIView *line;

@end


@implementation YZSmartBetTableViewCell
+ (YZSmartBetTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SmartBetTableViewCell";
    YZSmartBetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZSmartBetTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    //明天
    UILabel * tomorrowLabel = [[UILabel alloc]init];
    self.tomorrowLabel = tomorrowLabel;
    tomorrowLabel.backgroundColor = YZColor(255, 254, 241, 1);
    tomorrowLabel.font = [UIFont systemFontOfSize:13];
    tomorrowLabel.textColor = [UIColor grayColor];
    tomorrowLabel.layer.borderWidth = lineWidth;
    tomorrowLabel.layer.borderColor = [UIColor grayColor].CGColor;
    [self.contentView addSubview:tomorrowLabel];
    //期次
    UILabel * termLabel = [[UILabel alloc]init];
    self.termLabel = termLabel;
    termLabel.textAlignment = NSTextAlignmentCenter;
    termLabel.font = [UIFont systemFontOfSize:11];
    termLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:termLabel];
    
    UIView *line1 = [[UIView alloc]init];
    self.line1 = line1;
    line1.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line1];
    
    //倍数
    UITextField * multipleTextField = [[UITextField alloc]init];
    self.multipleTextField = multipleTextField;
    multipleTextField.backgroundColor = [UIColor whiteColor];
    multipleTextField.placeholder = @"1";
    multipleTextField.borderStyle = UITextBorderStyleNone;
    multipleTextField.textAlignment = NSTextAlignmentCenter;
    multipleTextField.font = [UIFont systemFontOfSize:11];
    multipleTextField.keyboardType = UIKeyboardTypeNumberPad;
    multipleTextField.layer.masksToBounds = YES;
    multipleTextField.layer.cornerRadius = 1;
    multipleTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    multipleTextField.layer.borderWidth = lineWidth;
    [self.contentView addSubview:multipleTextField];
    
    UILabel *multipleLabel = [[UILabel alloc]init];
    self.multipleLabel = multipleLabel;
    multipleLabel.text = @"倍";
    multipleLabel.textColor = [UIColor grayColor];
    multipleLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:multipleLabel];
    
    UIView *line2 = [[UIView alloc]init];
    self.line2 = line2;
    line2.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line2];
    
    //累计
    UILabel *totalLabel = [[UILabel alloc]init];
    self.totalLabel = totalLabel;
    totalLabel.numberOfLines = 0;
    totalLabel.font = [UIFont systemFontOfSize:11];
    totalLabel.textColor = [UIColor grayColor];
    totalLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:totalLabel];
    
    UIView *line3 = [[UIView alloc]init];
    self.line3 = line3;
    line3.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line3];
    
    //奖金
    UILabel *bonusLabel = [[UILabel alloc]init];
    self.bonusLabel = bonusLabel;
    bonusLabel.numberOfLines = 0;
    bonusLabel.font = [UIFont systemFontOfSize:11];
    bonusLabel.textColor = [UIColor grayColor];
    bonusLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:bonusLabel];
    
    UIView *line4 = [[UIView alloc]init];
    self.line4 = line4;
    line4.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line4];
    
    //盈利
    UILabel *profitLabel = [[UILabel alloc]init];
    self.profitLabel = profitLabel;
    profitLabel.numberOfLines = 0;
    profitLabel.font = [UIFont systemFontOfSize:11];
    profitLabel.textColor = [UIColor redColor];
    profitLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:profitLabel];
    
    //分割线
    UIView *line = [[UIView alloc]init];
    self.line = line;
    line.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:line];
}
- (void)setShowLine:(BOOL)showLine
{
    if (showLine) {
        self.line.hidden = NO;
    }else
    {
        self.line.hidden = YES;
    }
}
- (void)setStatus:(YZSmartBet *)status
{
    //设置frame
    CGFloat cellH = 0;
    if (status.isTomorrow) {
        cellH = 35 + 30;
        self.tomorrowLabel.frame = CGRectMake(0, 35, screenWidth, 30);
    }else
    {
        cellH = 35;
        self.tomorrowLabel.frame = CGRectZero;
    }
    CGFloat viewY = 0;
    CGFloat viewH = 35;
    self.termLabel.frame = CGRectMake(0,viewY, screenWidth * 0.1, viewH);
    self.line1.frame = CGRectMake(CGRectGetMaxX(self.termLabel.frame), viewY, lineWidth, viewH);
    self.multipleTextField.frame = CGRectMake(CGRectGetMaxX(self.line1.frame) + screenWidth * 0.02,viewY + 2,screenWidth * 0.18, viewH - 4);
    self.multipleLabel.frame = CGRectMake(CGRectGetMaxX(self.multipleTextField.frame) + screenWidth * 0.01, viewY, screenWidth * 0.05, viewH);
    self.line2.frame = CGRectMake(CGRectGetMaxX(self.multipleLabel.frame) + screenWidth * 0.01, viewY, lineWidth, viewH);
    self.totalLabel.frame = CGRectMake(CGRectGetMaxX(self.line2.frame), viewY, screenWidth * 0.17, viewH);
    self.line3.frame = CGRectMake(CGRectGetMaxX(self.totalLabel.frame), viewY, lineWidth, viewH);
    self.bonusLabel.frame = CGRectMake(CGRectGetMaxX(self.line3.frame), viewY, screenWidth * 0.22, viewH);
    self.line4.frame = CGRectMake(CGRectGetMaxX(self.bonusLabel.frame), viewY, lineWidth, viewH);
    self.profitLabel.frame = CGRectMake(CGRectGetMaxX(self.line4.frame), viewY, screenWidth * 0.24,viewH);
    self.line.frame = CGRectMake(0, cellH - lineWidth, screenWidth, lineWidth);
    
    //设置数据
    self.tomorrowLabel.text = [NSString stringWithFormat:@"  %@",status.dateStr];
    self.termLabel.text = status.termId;
    self.multipleTextField.text = status.multiple;
    self.totalLabel.text = status.total;
    self.bonusLabel.text = status.bonus;
    self.profitLabel.text = [NSString stringWithFormat:@"%@",status.profit];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
