//
//  YZFBTicketDetailTableViewCell.m
//  ez
//
//  Created by apple on 16/10/11.
//  Copyright © 2016年 9ge. All rights reserved.
//
#import "YZFBTicketDetailTableViewCell.h"
#import "NSDate+YZ.h"

@interface YZFBTicketDetailTableViewCell ()

@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, weak) UIView *line1;
@property (nonatomic, weak) UIView *line2;

@end

@implementation YZFBTicketDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FBTicketDetailTableViewCell";
    YZFBTicketDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell)
    {
        cell = [[YZFBTicketDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    //四个label
    NSArray * labelWs = @[@0.2,@0.4,@0.15,@0.25];
    UILabel * lastLabel;
    for (int i = 0; i < 4; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, [labelWs[i] floatValue] * screenWidth, 60)];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.textColor = YZBlackTextColor;
        [self addSubview:label];
        [self.labels addObject:label];
        lastLabel = label;
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, lineWidth, 60)];
        line.backgroundColor = YZGrayTextColor;
        [self.lines addObject:line];
        [self addSubview:line];
    }
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 60 - lineWidth, screenWidth, lineWidth)];
    self.line1 = line1;
    line1.backgroundColor = YZGrayTextColor;
    [self addSubview:line1];
    
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, lineWidth, 60)];
    self.line2 = line2;
    line2.backgroundColor = YZGrayTextColor;
    [self addSubview:line2];
}
- (void)setTicketList:(YZTicketList *)ticketList
{
    _ticketList = ticketList;
    
    CGFloat cellH = 0.0;
    for (int i = 0; i < 4; i++) {
        UILabel * label = self.labels[i];
        if (i == 0) {
            NSString * ticketTime = ticketList.ticketTime;
            if (ticketTime && ticketTime.length) {//有时间
                label.text = [NSString stringWithFormat:@"%@\n%@",[ticketTime substringWithRange:NSMakeRange(5, 5)],[ticketTime substringWithRange:NSMakeRange(11, 5)]];
            }
        }else if (i == 1)
        {
            NSArray *orderCodes = [ticketList.orderCode componentsSeparatedByString:@";"];
            NSArray *numbers = [ticketList.numbers componentsSeparatedByString:@";"];
            NSString * text = [YZTicketList getTicketInfos:orderCodes numbers:numbers gameId:ticketList.gameId];
            label.text = text;
            CGSize size = [text sizeWithFont:label.font maxSize:CGSizeMake(screenWidth * 0.4, MAXFLOAT)];
            cellH = (size.height + 20) > 60 ? (size.height + 20) : 60;
        }else if (i == 2)
        {
            label.text = [NSString stringWithFormat:@"%@",ticketList.multiple];
        }else if (i == 3)
        {
            //是否中奖
            float bonus = [ticketList.bonus intValue] / 100.0;
            NSString *isHitStr = nil;
            if(bonus > 0)
            {
                isHitStr = [NSString stringWithFormat:@"中奖：%.2f元",bonus];
                label.textColor = YZRedTextColor;
            }else
            {
                isHitStr = ticketList.statusDesc;
                label.textColor = YZBlackTextColor;
            }
            label.text = isHitStr;
        }
    }
    for (int i = 0; i < 4; i++) {
        UILabel * label = self.labels[i];
        label.height = cellH;
        UIView * line = self.lines[i];
        line.height = cellH;
    }
    self.line1.y = cellH - lineWidth;
    self.line2.height = cellH;
}
#pragma mark - 初始化
- (NSMutableArray *)labels
{
    if (_labels == nil) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}
- (NSMutableArray *)lines
{
    if (_lines == nil) {
        _lines = [NSMutableArray array];
    }
    return _lines;
}

@end
