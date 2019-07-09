//
//  YZUnionBuyCell.m
//  ez
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015年 9ge. All rights reserved.
//
#define padding 5.0f
#import "YZUnionBuyCell.h"

@interface YZUnionBuyCell ()

@property (nonatomic, weak)  UILabel *gameNameLabel;
@property (nonatomic, weak)  UILabel *userNameLabel;
@property (nonatomic,weak) UILabel *gradeLabel;
@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UIView *separator;
@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, weak) UIView *grayLine;

@end

@implementation YZUnionBuyCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"chippedCell";
    YZUnionBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell)
    {
        cell = [[YZUnionBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
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
    //游戏名称
    UILabel *gameNameLabel = [[UILabel alloc] init];
    self.gameNameLabel = gameNameLabel;
    gameNameLabel.font = bigFont;
    gameNameLabel.textColor = YZBlackTextColor;
    gameNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:gameNameLabel];
    
    //头像
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unionBuy_person"]];
    self.icon = icon;
    [self.contentView addSubview:icon];
    
    //玩家名称
    UILabel *userNameLabel = [[UILabel alloc] init];
    self.userNameLabel = userNameLabel;
    userNameLabel.font = smallFont;
    userNameLabel.textColor = YZBlackTextColor;
    [self.contentView addSubview:userNameLabel];
    
    //等级
    UILabel *gradeLabel = [[UILabel alloc] init];
    self.gradeLabel = gradeLabel;
    gradeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(20)];
    gradeLabel.textColor = YZBlackTextColor;
    [self.contentView addSubview:gradeLabel];
    
    //灰色分割线
    UIView *separator = [[UIView alloc] init];
    self.separator = separator;
    [self.contentView addSubview:separator];
    
    //圆饼图
    YZCircleChart *circleChart = [[YZCircleChart alloc] init];
    circleChart.bounds = CGRectMake(0, 0, circleChartWH, circleChartWH);
    self.circleChart = circleChart;
    [self.contentView addSubview:circleChart];
    
    //总金额、每份、剩余
    NSArray *titles = @[@"总金额",@"每份",@"剩余"];
    for(NSUInteger i = 0;i < 6;i ++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = smallFont;
        label.textColor = YZBlackTextColor;
        if(i < 3)
        {
            label.textColor = YZDrayGrayTextColor;
            label.text = titles[i];
        }
        [self.labels addObject:label];
        [self.contentView addSubview:label];
    }
    
    //accessoryButton
    UIButton *accessoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.accessoryBtn = accessoryBtn;
    [accessoryBtn setImage:[UIImage imageNamed:@"unionBuy_graydownArrow"] forState:UIControlStateNormal];
    [accessoryBtn setImage:[UIImage imageNamed:@"unionBuy_orangedownArrow"] forState:UIControlStateSelected];
    [accessoryBtn setImage:[UIImage imageNamed:@"unionBuy_orangedownArrow"] forState:UIControlStateHighlighted];
    [accessoryBtn addTarget:self action:@selector(accessoryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:accessoryBtn];
    
    //cell下面的分割线
    UIView *grayLine = [[UIView alloc] init];
    self.grayLine = grayLine;
    grayLine.backgroundColor = YZWhiteLineColor;
    [self.contentView addSubview:grayLine];
}
- (void)accessoryBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    _statusFrame.status.accessoryBtnSelected = btn.selected;//设置状态
    //通知代理点击了AccessoryBtn
    if([self.delegate respondsToSelector:@selector(unionBuyCellAccessoryBtnDidClick:cell:)])
    {
        [self.delegate unionBuyCellAccessoryBtnDidClick:btn cell:self];
    }
}

#pragma mark - 设置数据
-(void)setStatusFrame:(YZUnionBuyStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    [self setupStatus];//设置数据
    
    [self setupFrame];//设置frame
}
- (void)setupStatus
{
    YZUnionBuyStatus *status = _statusFrame.status;
    self.gameNameLabel.text = status.gameName;
    self.userNameLabel.text = status.userName;
    self.circleChart.selfBuyRatio = status.schedule;
    self.circleChart.guaranteeRatio = @([status.deposit floatValue] / [status.totalAmount floatValue]);
    [self.circleChart strokeChart];
    
    NSArray *titles = @[status.totalAmount,status.singleMoney,status.surplusMoney];
    for(NSUInteger i = 3;i < 6;i ++)
    {
        UILabel *label = self.labels[i];
        label.text = [NSString stringWithFormat:@"%ld元",[titles[i - 3] integerValue] / 100];
    }
    self.accessoryBtn.hidden = _statusFrame.status.search;
    self.accessoryBtn.selected = _statusFrame.status.accessoryBtnSelected;//设置按钮状态
    self.gradeLabel.attributedText = [self getAttStrByGrade:_statusFrame.status.grade];
}

- (void)setupFrame
{
    self.gameNameLabel.frame = _statusFrame.gameNameFrame;
    self.icon.frame = _statusFrame.iconFrame;
    self.icon.center = CGPointMake(self.icon.center.x, self.gameNameLabel.center.y);
    self.userNameLabel.frame = _statusFrame.userNameFrame;
    self.userNameLabel.center = CGPointMake(self.userNameLabel.center.x, self.gameNameLabel.center.y);
    self.separator.frame = _statusFrame.seperatorFrame;
    self.circleChart.frame = _statusFrame.circleChartFrame;
    
    //6个label的frame
    NSUInteger maxColums = 3;
    CGFloat seperatorX = _statusFrame.seperatorFrame.origin.x;
    CGFloat seperatorY = CGRectGetMaxY(_statusFrame.seperatorFrame);
    CGFloat labelW = (screenWidth - seperatorX - 50) / maxColums;
    CGFloat labelH = [[_statusFrame.status.totalAmount stringValue] sizeWithFont:smallFont maxSize:CGSizeMake(screenWidth, CGFLOAT_MAX)].height;
    CGFloat labelVerticalpadding = (CGRectGetHeight(_statusFrame.circleChartFrame) - 2 * labelH) / 3;
    for(NSUInteger i = 0;i < 6;i ++)
    {
        UILabel *label = self.labels[i];
        CGFloat labelX = seperatorX + (i % maxColums) * labelW;
        CGFloat labelY =  seperatorY + labelVerticalpadding + (i / maxColums) * (labelH + labelVerticalpadding);
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
    }
    
    CGFloat accessoryBtnW = 40;
    CGFloat accessoryBtnH = 40;
    self.accessoryBtn.frame = CGRectMake(screenWidth - 30 - 20, 0, accessoryBtnW, accessoryBtnH);
    self.accessoryBtn.centerY = self.circleChart.centerY;
    self.grayLine.frame = _statusFrame.grayLineFrame;
    self.gradeLabel.frame = CGRectMake(CGRectGetMaxX(self.userNameLabel.frame) + 4, self.userNameLabel.y, screenWidth - (CGRectGetMaxX(self.userNameLabel.frame) + 4), self.userNameLabel.height);
}

- (NSAttributedString *)getAttStrByGrade:(NSNumber *)grade
{
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] init];
    NSString * gradeSystem8 = [YZTool transformNumber:[NSString stringWithFormat:@"%@", grade] withNumberSystem:@"8"];
    NSMutableArray *characters = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        [characters addObject:@"0"];
    }
    if (gradeSystem8.length >= 4) {
        NSString * character = [gradeSystem8 substringWithRange:NSMakeRange(0, gradeSystem8.length - 3)];
        characters[0] = character;
    }
    if (gradeSystem8.length >= 3) {
        NSString * character = [gradeSystem8 substringWithRange:NSMakeRange(gradeSystem8.length - 3, 1)];
        characters[1] = character;
    }
    if (gradeSystem8.length >= 2) {
        NSString * character = [gradeSystem8 substringWithRange:NSMakeRange(gradeSystem8.length - 2, 1)];
        characters[2] = character;
    }
    if (gradeSystem8.length >= 1) {
        NSString * character = [gradeSystem8 substringWithRange:NSMakeRange(gradeSystem8.length - 1, 1)];
        characters[3] = character;
    }
    
    for (int i = 0; i < characters.count; i++) {
        if ([characters[i] intValue] > 0) {
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc]initWithData:nil ofType:nil];
            textAttachment.bounds = CGRectMake(0, 0, 16, 11);
            textAttachment.image = [UIImage imageNamed:[NSString stringWithFormat:@"unionBuy_gold_grade%d", i + 1]];
            NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [attStr appendAttributedString:textAttachmentString];
            
            NSAttributedString * textAttStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ", characters[i]]];
            [attStr appendAttributedString:textAttStr];
        }
    }
    
    return attStr;
}

#pragma mark - 初始化
- (NSMutableArray *)labels
{
    if(_labels == nil)
    {
        _labels = [NSMutableArray array];
    }
    return  _labels;
}

@end

