//
//  YZFBMatchDetailStandingsContentTableViewCell.m
//  ez
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define padding 10
#define cellH 35

#import "YZFBMatchDetailStandingsContentTableViewCell.h"
#import "YZDateTool.h"

@interface YZFBMatchDetailStandingsContentTableViewCell ()

@property (nonatomic, strong) NSMutableArray *contentLabels;

@end

@implementation YZFBMatchDetailStandingsContentTableViewCell

+ (YZFBMatchDetailStandingsContentTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FBMatchDetailStandingsContentTableViewCell";
    YZFBMatchDetailStandingsContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZFBMatchDetailStandingsContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
#pragma mark - 布局视图
- (void)setupChilds
{
    CGFloat width = screenWidth - 2 * padding;
    
    NSArray * labelWs = @[@0.18,@0.18,@0.21,@0.11,@0.21,@0.11];
    UILabel * lastLabel;
    for (int i = 0; i < 6; i++) {
        UILabel * contentLabel = [[UILabel alloc] init];
        contentLabel.frame = CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, [labelWs[i] floatValue] * width, cellH);
        contentLabel.font = [UIFont systemFontOfSize:10];
        contentLabel.textColor = YZBlackTextColor;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
        [self.contentLabels addObject:contentLabel];
        lastLabel = contentLabel;
    }
    
    //分割线
    UIView * line_left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, cellH)];
    line_left.backgroundColor = YZWhiteLineColor;
    [self addSubview:line_left];
    
    UIView * line_right = [[UIView alloc] initWithFrame:CGRectMake(width - 1, 0, 1, cellH)];
    line_right.backgroundColor = YZWhiteLineColor;
    [self addSubview:line_right];
    
    UIView * line_down = [[UIView alloc] initWithFrame:CGRectMake(0, cellH - 1, width, 1)];
    line_down.backgroundColor = YZWhiteLineColor;
    [self addSubview:line_down];
}
#pragma mark - 设置数据
- (void)setMatchCellStatus:(YZMatchCellStatus *)matchCellStatus
{
    _matchCellStatus = matchCellStatus;
    //赛事
    UILabel * label1 = self.contentLabels[0];
    label1.text = _matchCellStatus.matchName;
    
    //比赛时间
    UILabel * label2 = self.contentLabels[1];
    NSString * matchTime = [YZDateTool getTimeByTimestamp:_matchCellStatus.matchTime format:@"YYYY-MM-dd"];
    if (matchTime.length == 10) {
        label2.text = [matchTime substringFromIndex:2];
    }

    //主队
    UILabel * label3 = self.contentLabels[2];
    [self setLabel:label3 text:_matchCellStatus.home];
    
    //比分
    UILabel * label4 = self.contentLabels[3];
    label4.text = _matchCellStatus.score;
    
    //客队
    UILabel * label5 = self.contentLabels[4];
    [self setLabel:label5 text:_matchCellStatus.away];
    
    //胜负
    UILabel * label6 = self.contentLabels[5];
    NSString * winLost = _matchCellStatus.winLost;
    if ([winLost isEqualToString:@"胜"]) {
        label6.textColor = YZMDRedColor;
    }else if ([winLost isEqualToString:@"平"])
    {
        label6.textColor = YZMDBlueColor;
    }else if ([winLost isEqualToString:@"负"])
    {
        label6.textColor = YZMDGreenColor;
    }
    label6.text = winLost;
}
//根据胜负设置文字颜色
- (void)setLabel:(UILabel *)label text:(NSString *)text
{
    label.text = text;
    label.textColor = YZBlackTextColor;
    if ([text isEqualToString:self.homeTeam]) {
        if ([_matchCellStatus.winLost isEqualToString:@"胜"]) {
            label.textColor = YZMDRedColor;
        }else if ([_matchCellStatus.winLost isEqualToString:@"负"])
        {
            label.textColor = YZMDGreenColor;
        }
    }
}
- (void)setMatchFutureStatus:(YZMatchFutureStatus *)matchFutureStatus
{
    _matchFutureStatus = matchFutureStatus;
    //赛事
    UILabel * label1 = self.contentLabels[0];
    label1.text = _matchFutureStatus.matchName;
    
    //比赛时间
    UILabel * label2 = self.contentLabels[1];
    NSString * matchTime = [YZDateTool getTimeByTimestamp:_matchFutureStatus.matchTime format:@"YYYY-MM-dd"];
    if (matchTime.length == 10) {
        label2.text = [matchTime substringFromIndex:2];
    }
    
    //主队
    UILabel * label3 = self.contentLabels[2];
    label3.textColor = YZBlackTextColor;
    label3.text = _matchFutureStatus.home;
    
    //VS
    UILabel * label4 = self.contentLabels[3];
    label4.text = @"VS";
    
    //客队
    UILabel * label5 = self.contentLabels[4];
    label5.textColor = YZBlackTextColor;
    label5.text = _matchFutureStatus.away;
    
    //胜负
    UILabel * label6 = self.contentLabels[5];
    label6.textColor = YZBlackTextColor;
    label6.text = [NSString stringWithFormat:@"%ld天",_matchFutureStatus.apartDay];
}
#pragma mark - 初始化
- (NSMutableArray *)contentLabels
{
    if (!_contentLabels) {
        _contentLabels = [NSMutableArray array];
    }
    return _contentLabels;
}
@end
