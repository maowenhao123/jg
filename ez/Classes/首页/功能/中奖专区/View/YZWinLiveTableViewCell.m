//
//  YZWinLiveTableViewCell.m
//  zc
//
//  Created by dahe on 2020/5/18.
//  Copyright © 2020 9ge. All rights reserved.
//

#import "YZWinLiveTableViewCell.h"

@interface YZWinLiveTableViewCell ()

@property (nonatomic, weak) UIImageView *logoImageView;//logo
@property (nonatomic, weak) UILabel *moneyLabel;//金额
@property (nonatomic, weak) UILabel *timeLabel;//时间
@property (nonatomic, weak) UILabel *desLabel;//描述

@end

@implementation YZWinLiveTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZWinLiveTableViewCellId";
    YZWinLiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZWinLiveTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    //logo
    CGFloat logoWH = 40;
    UIImageView *logoImageView = [[UIImageView alloc]init];
    self.logoImageView = logoImageView;
    logoImageView.frame = CGRectMake(YZMargin, (70 - logoWH) / 2, logoWH, logoWH);
    [self addSubview:logoImageView];
    
    //金额
    UILabel * moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 7, 13, screenWidth - 155 - CGRectGetMaxX(self.logoImageView.frame) - 7, 20)];
    self.moneyLabel = moneyLabel;
    moneyLabel.font = [UIFont boldSystemFontOfSize:16];
    moneyLabel.textColor = YZBaseColor;
    [self addSubview:moneyLabel];
    
    //时间
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth - 10 - 150, 13, 150, 20)];
    self.timeLabel = timeLabel;
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = YZGrayTextColor;
    timeLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:timeLabel];
    
    //描述
    UILabel * desLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + 7, CGRectGetMaxY(self.moneyLabel.frame) + 4, screenWidth - 10 - CGRectGetMaxX(self.logoImageView.frame) - 5, 20)];
    self.desLabel = desLabel;
    desLabel.font = [UIFont systemFontOfSize:14];
    desLabel.textColor = YZDrayGrayTextColor;
    [self addSubview:desLabel];
}

#pragma mark - Setting
- (void)setWinModel:(YZWinModel *)winModel
{
    _winModel = winModel;

    self.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@", _winModel.gameId]];
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%@元", [YZTool formatFloat:(_winModel.money / 100.0)]];
    self.desLabel.text = _winModel.describe;
    self.timeLabel.text = _winModel.hitDate;
}

@end
