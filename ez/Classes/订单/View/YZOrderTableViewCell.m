//
//  YZOrderTableViewCell.m
//  ez
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define cellH 65

#import "YZOrderTableViewCell.h"

@interface YZOrderTableViewCell ()

@property (nonatomic, weak) UIImageView *bgImageView;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIImageView *logoImageView;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UIImageView *givingImageView;
@property (nonatomic, weak) UILabel *termCountLabel;
@property (nonatomic, weak) UILabel *amountLabel;
@property (nonatomic, weak) UILabel *statusLabel;

@end

@implementation YZOrderTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"orderTableViewCell";
    YZOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell)
    {
        cell = [[YZOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
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
    //时间
    UILabel * timeLabel = [[UILabel alloc]init];
    self.timeLabel = timeLabel;
    timeLabel.textColor = YZColor(186, 186, 186, 1);
    timeLabel.numberOfLines = 0;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:timeLabel];
    
    //logo
    UIImageView * logoImageView = [[UIImageView alloc]init];
    self.logoImageView = logoImageView;
    [self addSubview:logoImageView];
    
    //名称
    UILabel * nameLabel = [[UILabel alloc]init];
    self.nameLabel = nameLabel;
    nameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    nameLabel.textColor = YZBlackTextColor;
    [self addSubview:nameLabel];
    
    //赠送
    UIImageView * givingImageView = [[UIImageView alloc]init];
    self.givingImageView = givingImageView;
    givingImageView.image = [UIImage imageNamed:@"giving"];
    [self addSubview:givingImageView];
    
    //追期数
    UILabel * termCountLabel = [[UILabel alloc]init];
    self.termCountLabel = termCountLabel;
    termCountLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    termCountLabel.textColor = YZBlackTextColor;
    [self addSubview:termCountLabel];
    
    //金额
    UILabel * amountLabel = [[UILabel alloc]init];
    self.amountLabel = amountLabel;
    amountLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    amountLabel.textColor = YZColor(134, 134, 134, 1);
    [self addSubview:amountLabel];
    
    //状态
    UILabel * statusLabel = [[UILabel alloc]init];
    self.statusLabel = statusLabel;
    statusLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    statusLabel.textColor = YZColor(134, 134, 134, 1);
    statusLabel.textAlignment = NSTextAlignmentRight;
    statusLabel.numberOfLines = 0;
    [self addSubview:statusLabel];
    
    //分割线
    UIView * line = [[UIView alloc]init];
    self.line = line;
    line.backgroundColor = YZWhiteLineColor;
    [self addSubview:line];
}
- (void)setStatus:(YZOrderStatus *)status
{
    _status = status;
    //赋值
    NSString * timeStr = [self getDateAndWeekStringFromDateString:status.createTime];
    NSMutableAttributedString * timeAttStr = [[NSMutableAttributedString alloc]initWithString:timeStr];
    [timeAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(30)] range:NSMakeRange(0, 2)];
    [timeAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(2, timeAttStr.length - 2)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    [timeAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, timeAttStr.length)];
    self.timeLabel.attributedText = timeAttStr;
    
    if (status.index == 1 && !YZStringIsEmpty(_status.noHitDesc)) {
        if ([status.gameId isEqualToString:@"F01"]) {
            self.logoImageView.image = [UIImage imageNamed:@"scheme_setmeal_ssq"];
        }else if ([status.gameId isEqualToString:@"T01"])
        {
            self.logoImageView.image = [UIImage imageNamed:@"scheme_setmeal_dlt"];
        }else
        {
            self.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",status.gameId]];
        }
    }else
    {
        self.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",status.gameId]];
    }
    
    NSString * name = [[YZTool gameIdNameDict] objectForKey:status.gameId];
    self.nameLabel.text = name;
    
    if (status.index == 3) {
        self.termCountLabel.text = [NSString stringWithFormat:@"(%@)", _status.userTypeDesc];
    }else
    {
        if (status.termCount) {
            NSString * termCount = [NSString stringWithFormat:@"追%@期",status.termCount];
            self.termCountLabel.text = termCount;
        }else
        {
            self.termCountLabel.text = nil;
        }
    }
    
    if (status.index == 3) {
        NSString * money = [NSString stringWithFormat:@"%.2f元",[_status.money longValue] / 100.0];
        self.amountLabel.text = money;
    }else
    {
        if (status.index == 1 && !YZStringIsEmpty(_status.noHitDesc)) {
            NSString * amount = _status.noHitDesc;
            self.amountLabel.text = amount;
            self.amountLabel.textColor = YZRedTextColor;
        }else
        {
            NSString * amount = [NSString stringWithFormat:@"%.2f元",[_status.amount longLongValue] / 100.0];
            self.amountLabel.text = amount;
            self.amountLabel.textColor = YZColor(134, 134, 134, 1);
        }
    }
    
    if (status.index == 3) {
        if ([status.hitmoney longLongValue] > 0) {//中奖
            self.statusLabel.textColor = YZColor(246, 53, 80, 1);
            self.statusLabel.text = [NSString stringWithFormat:@"%@\n%.2f元",status.statusDesc, [status.hitmoney longLongValue] / 100.0];
        }else
        {
            self.statusLabel.textColor = YZColor(134, 134, 134, 1);
            self.statusLabel.text = status.statusDesc;
        }
    }else
    {
        if ([status.bonus longLongValue] > 0) {//中奖
            self.statusLabel.textColor = YZColor(246, 53, 80, 1);
            self.statusLabel.text = [NSString stringWithFormat:@"%@\n%.2f元",status.statusDesc, [status.bonus longLongValue] / 100.0];
        }else
        {
            self.statusLabel.textColor = YZColor(134, 134, 134, 1);
            self.statusLabel.text = status.statusDesc;
        }
    }
    
    //设置frame
    CGSize timeSize = [self.timeLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth, cellH) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.timeLabel.frame = CGRectMake(14, 0, timeSize.width, cellH);

    CGFloat logoY = (cellH - 39) / 2;
    self.logoImageView.frame = CGRectMake(CGRectGetMaxX(self.timeLabel.frame) + 15, logoY, 39, 39);
    
    if ([status.bonus longLongValue] > 0 && status.index != 3) {//中奖
        CGSize nameSize = [self.nameLabel.text sizeWithLabelFont:self.nameLabel.font];
        CGFloat nameLabelY = (cellH - nameSize.height) / 2;
        self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 15,nameLabelY, nameSize.width, nameSize.height);
        self.givingImageView.frame = CGRectZero;
        self.termCountLabel.frame = CGRectZero;
        self.amountLabel.frame = CGRectZero;
    }else
    {
        CGSize nameSize = [self.nameLabel.text sizeWithLabelFont:self.nameLabel.font];
        CGSize termCountSize = [self.termCountLabel.text sizeWithLabelFont:self.termCountLabel.font];
        CGSize amountSize = [self.amountLabel.text sizeWithLabelFont:self.amountLabel.font];
        CGFloat nameLabelY = (cellH - nameSize.height - amountSize.height - 7) / 2;
        self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 15,nameLabelY, nameSize.width, nameSize.height);
        self.termCountLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 5, self.nameLabel.y, termCountSize.width, self.nameLabel.height);
        self.amountLabel.frame = CGRectMake(self.nameLabel.x, CGRectGetMaxY(self.nameLabel.frame) + 7, amountSize.width, amountSize.height);
    }
    
    CGSize statusSize = [self.statusLabel.text sizeWithLabelFont:self.statusLabel.font];
    self.statusLabel.frame = CGRectMake(screenWidth - 14 - statusSize.width, 0, statusSize.width, cellH);
    self.line.frame = CGRectMake(15, cellH, screenWidth - 15, 1);
}
- (void)setIndex:(int)index
{
    _index = index;
    if (_index == 1) {//追号不显示赠送
        if ([_status.orderType intValue] == 1) {
            self.givingImageView.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 5, self.nameLabel.y, 25, 15);
        }else
        {
            self.givingImageView.frame = CGRectZero;
        }
    }else
    {
         self.givingImageView.frame = CGRectZero;
    }
}
/**
 *  从日期字符串获取格式为
 dateString:2016-09-21 11:12:57
 返回值:周三 09-21
 */
- (NSString *)getDateAndWeekStringFromDateString:(NSString *)dateString
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSInteger unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [fmt dateFromString:dateString];
    NSDateComponents *components = [calendar components:unit fromDate:date];
    NSArray *weakDayArray = [[NSArray alloc] initWithObjects:@"",@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六", nil];
    NSInteger weekDay = components.weekday;
    NSString *weakDayStr = weakDayArray[weekDay];
    NSString *chineseDateStr = [NSString stringWithFormat:@"%@\n%02ld-%02ld",weakDayStr,(long)components.month,(long)components.day];
    return chineseDateStr;
}
@end
