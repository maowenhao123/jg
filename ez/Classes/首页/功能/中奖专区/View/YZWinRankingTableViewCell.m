//
//  YZWinRankingTableViewCell.m
//  zc
//
//  Created by dahe on 2020/5/18.
//  Copyright © 2020 9ge. All rights reserved.
//

#import "YZWinRankingTableViewCell.h"

@interface YZWinRankingTableViewCell ()

@property (nonatomic,weak)  UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *rankLabel;
@property (nonatomic,weak) UILabel * nickNameLabel;
@property (nonatomic, weak) UILabel *desLabel;//描述

@end

@implementation YZWinRankingTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZWinRankingTableViewCellId";
    YZWinRankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZWinRankingTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    //头像
    CGFloat avatarImageViewWH = 45;
    UIImageView *avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(YZMargin, 20, avatarImageViewWH, avatarImageViewWH)];
    self.avatarImageView = avatarImageView;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = avatarImageView.width / 2;
    avatarImageView.userInteractionEnabled = YES;
    [self addSubview:avatarImageView];
    
    //排名
    CGFloat rankLabelW = 45;
    CGFloat rankLabelH = 20;
    UILabel * rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(avatarImageView.x + (avatarImageViewWH - rankLabelW) / 2, CGRectGetMaxY(avatarImageView.frame) - rankLabelH / 2, rankLabelW, rankLabelH)];
    self.rankLabel = rankLabel;
    rankLabel.font = [UIFont systemFontOfSize:11];
    rankLabel.textColor = [UIColor whiteColor];
    rankLabel.textAlignment = NSTextAlignmentCenter;
    rankLabel.layer.masksToBounds = YES;
    rankLabel.layer.cornerRadius = rankLabelH / 2;
    rankLabel.layer.borderColor = YZWhiteLineColor.CGColor;
    rankLabel.layer.borderWidth = 1;
    [self addSubview:rankLabel];
    
    //昵称
    UILabel * nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + 7, 15, screenWidth - (CGRectGetMaxX(avatarImageView.frame) + 10), 20)];
    self.nickNameLabel = nickNameLabel;
    nickNameLabel.textColor = YZBlackTextColor;
    nickNameLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:nickNameLabel];
    
    //描述
    UILabel * desLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.avatarImageView.frame) + 7, CGRectGetMaxY(self.nickNameLabel.frame) + 1, screenWidth - (CGRectGetMaxX(avatarImageView.frame) + 10), 40)];
    self.desLabel = desLabel;
    desLabel.font = [UIFont systemFontOfSize:14];
    desLabel.textColor = YZBlackTextColor;
    desLabel.numberOfLines = 0;
    [self addSubview:desLabel];
}

#pragma mark - Setting
- (void)setIndex:(NSInteger)index
{
    _index = index;
    
    if (_index == 0) {
        self.rankLabel.hidden = NO;
        self.rankLabel.text = @"冠军";
        self.rankLabel.backgroundColor = YZBaseColor;
    }else if (_index == 1)
    {
        self.rankLabel.hidden = NO;
        self.rankLabel.text = @"亚军";
        self.rankLabel.backgroundColor = YZColor(237, 125, 49, 1);
    }else if (_index == 2)
    {
        self.rankLabel.hidden = NO;
        self.rankLabel.text = @"季军";
        self.rankLabel.backgroundColor = YZColor(255, 192, 0, 1);
    }else
    {
        self.rankLabel.hidden = YES;
    }
}

- (void)setWinModel:(YZWinModel *)winModel
{
    _winModel = winModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_winModel.userHeadImage] placeholderImage:[UIImage imageNamed:@"avatar_zc"]];
    self.nickNameLabel.text = _winModel.nickName;
    NSString * moneyStr = [YZTool formatFloat:(_winModel.money / 100.0)];
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"本店累计中奖%@元\n%@", moneyStr, _winModel.describe]];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:[attStr.string rangeOfString:moneyStr]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 1;
    [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
    self.desLabel.attributedText = attStr;
}

@end
