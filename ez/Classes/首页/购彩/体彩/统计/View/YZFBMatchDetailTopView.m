//
//  YZFBMatchDetailTopView.m
//  ez
//
//  Created by apple on 17/1/12.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZFBMatchDetailTopView.h"
#import "YZDateTool.h"

@interface YZFBMatchDetailTopView ()

@property (nonatomic, weak) UILabel * homeTeamLabel;
@property (nonatomic, weak) UILabel * guestTeamLabel;
@property (nonatomic, weak) UILabel * matchLabel;

@end

@implementation YZFBMatchDetailTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    //主队
    UILabel * homeTeamLabel = [[UILabel alloc] init];
    self.homeTeamLabel = homeTeamLabel;
    homeTeamLabel.numberOfLines = 0;
    [self addSubview:homeTeamLabel];
    
    //客队
    UILabel * guestTeamLabel = [[UILabel alloc] init];
    self.guestTeamLabel = guestTeamLabel;
    guestTeamLabel.numberOfLines = 0;
    [self addSubview:guestTeamLabel];
    
    //比赛信息
    UILabel * matchLabel = [[UILabel alloc] init];
    self.matchLabel = matchLabel;
    matchLabel.textAlignment = NSTextAlignmentCenter;
    matchLabel.numberOfLines = 0;
    [self addSubview:matchLabel];
}
- (void)setRound:(YZRoundStatus *)round
{
    _round = round;
    //主队
    NSString * homeTeamName = _round.home.name;
    int homeTeamTotal = _round.home.total;
    int homeTeamRank = _round.home.rank;
    NSString * homeTeamMessage = [NSString stringWithFormat:@"%@\n排名:  总%d 主%d",homeTeamName,homeTeamTotal,homeTeamRank];
    NSMutableAttributedString * homeTeamMessageAttStr = [[NSMutableAttributedString alloc] initWithString:homeTeamMessage];
    [homeTeamMessageAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, homeTeamMessage.length)];
    [homeTeamMessageAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, homeTeamMessage.length)];
    //排名 字体大小颜色
    [homeTeamMessageAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(116, 116, 116, 1) range:NSMakeRange(homeTeamName.length,homeTeamMessage.length - homeTeamName.length)];
    [homeTeamMessageAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(homeTeamName.length,homeTeamMessage.length - homeTeamName.length)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];//行间距7
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [homeTeamMessageAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, homeTeamMessageAttStr.length)];
    self.homeTeamLabel.attributedText = homeTeamMessageAttStr;
    
    CGSize homeTeamLabelSize = [self.homeTeamLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth, screenHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.homeTeamLabel.frame = CGRectMake(0, 0, homeTeamLabelSize.width, homeTeamLabelSize.height);
    self.homeTeamLabel.center = CGPointMake(40 + 80 / 2, 80 + 50 / 2);
    
    //客队
    NSString * guestTeamName = _round.away.name;
    int guestTeamTotal = _round.away.total;
    int guestTeamRank = _round.away.rank;
    NSString * guestTeamMessage = [NSString stringWithFormat:@"%@\n排名:  总%d  客%d",guestTeamName,guestTeamTotal,guestTeamRank];
    NSMutableAttributedString * guestTeamMessageAttStr = [[NSMutableAttributedString alloc] initWithString:guestTeamMessage];
    [guestTeamMessageAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, guestTeamMessage.length)];
    [guestTeamMessageAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, guestTeamMessage.length)];
    //排名 字体大小颜色
    [guestTeamMessageAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(116, 116, 116, 1) range:NSMakeRange(guestTeamName.length, guestTeamMessage.length - guestTeamName.length)];
    [guestTeamMessageAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(guestTeamName.length, guestTeamMessage.length - guestTeamName.length)];
    [guestTeamMessageAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, guestTeamMessageAttStr.length)];
    self.guestTeamLabel.attributedText = guestTeamMessageAttStr;
    
    CGSize guestTeamLabelSize = [self.guestTeamLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth, screenHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.guestTeamLabel.frame = CGRectMake(0, 0, guestTeamLabelSize.width, guestTeamLabelSize.height);
    self.guestTeamLabel.center = CGPointMake(screenWidth - (40 + 80 / 2), 80 + 50 / 2);
    
    //比赛信息
    NSString *matchTimeStr = [YZDateTool getTimeByTimestamp:_round.time format:@"MM-dd\nhh:mm"];
    
    NSMutableAttributedString * matchTimeAttStr = [[NSMutableAttributedString alloc] initWithString:matchTimeStr];
    [matchTimeAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(116, 116, 116, 1) range:NSMakeRange(0, matchTimeAttStr.length)];
    [matchTimeAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, matchTimeAttStr.length)];
    self.matchLabel.attributedText = matchTimeAttStr;
    
    CGSize matchLabelSize = [self.matchLabel.attributedText boundingRectWithSize:CGSizeMake(screenWidth, screenHeight) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.matchLabel.frame = CGRectMake(0, 0, matchLabelSize.width, matchLabelSize.height);
    self.matchLabel.center = CGPointMake(screenWidth / 2, 80 + 50 / 2);

}
@end
