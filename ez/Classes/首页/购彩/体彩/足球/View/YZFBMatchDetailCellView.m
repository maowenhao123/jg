//
//  YZFBMatchDetailCellView.m
//  ez
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height

#import "YZFBMatchDetailCellView.h"
#import "UIButton+YZ.h"

@interface YZFBMatchDetailCellView ()

@property (nonatomic, strong) NSMutableArray *contentLabels;

@end

@implementation YZFBMatchDetailCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZColor(238, 238, 238, 1);
        [self setupChilds];
    }
    return self;
}
#pragma mark - 布局子视图
- (void)setupChilds
{
    CGFloat titleLabelH = 30;
    CGFloat titleLabelW = 70;
    NSArray * titleArray = @[@"历史交锋",@"近期战绩",@"联赛排名"];
    for (int i = 0; i < 3; i++) {
        //标题
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.frame = CGRectMake(0, titleLabelH * i, titleLabelW, titleLabelH);
        titleLabel.text = titleArray[i];
        titleLabel.textColor = YZBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        
        //内容
        UILabel * contentLabel = [[UILabel alloc] init];
        contentLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame), titleLabelH * i, screenWidth - CGRectGetMaxX(titleLabel.frame), titleLabelH);
        contentLabel.text = @"暂无数据";
        contentLabel.textColor = YZColor(116, 116, 116, 1);
        contentLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        [self addSubview:contentLabel];
        [self.contentLabels addObject:contentLabel];
        
        //分割线
        UIView * line = [[UIView alloc] init];
        line.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame), screenWidth, 0.8);
        line.backgroundColor = YZGrayLineColor;
        [self addSubview:line];
    }
    
    //查看更多
    UIButton * showDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    showDetailBtn.frame = CGRectMake(0, KHeight - 30, screenWidth, 30);
    [showDetailBtn setImage:[UIImage imageNamed:@"fb_show_detail_icon"] forState:UIControlStateNormal];
    [showDetailBtn setTitle:@"详细赛事分析>" forState:UIControlStateNormal];
    [showDetailBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    showDetailBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [showDetailBtn setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:1.5];
    [showDetailBtn addTarget:self action:@selector(showDetailBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:showDetailBtn];
}
- (void)showDetailBtnDidClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(showDetailBtnDidClick)])
    {
        [_delegate showDetailBtnDidClick];
    }
}
#pragma mark - 设置数据
- (void)setMatchDetailStatus:(YZFBMatchDetailStatus *)matchDetailStatus
{
    _matchDetailStatus = matchDetailStatus;
    //历史交锋
    int gameCount = _matchDetailStatus.record.num;
    NSString * homeTeamName = _matchDetailStatus.record.name;
    int homeTeamSuccess = _matchDetailStatus.record.win;
    int homeTeamEqual = _matchDetailStatus.record.draw;
    int homeTeamLost = _matchDetailStatus.record.lost;
    NSString * str1 = [NSString stringWithFormat:@"近%d次交锋，%@%d胜%d平%d负",gameCount,homeTeamName,homeTeamSuccess,homeTeamEqual,homeTeamLost];
    NSMutableAttributedString * attStr1 = [[NSMutableAttributedString alloc] initWithString:str1];
    [attStr1 addAttribute:NSForegroundColorAttributeName value:YZMDRedColor range:NSMakeRange(str1.length - 6, 2)];
    [attStr1 addAttribute:NSForegroundColorAttributeName value:YZMDBlueColor range:NSMakeRange(str1.length - 4, 2)];
    [attStr1 addAttribute:NSForegroundColorAttributeName value:YZMDGreenColor range:NSMakeRange(str1.length - 2, 2)];
    UILabel * contentLabel1 = self.contentLabels[0];
    if (gameCount == 0) {//没有交锋过
        contentLabel1.text = @"暂无数据";
    }else
    {
        contentLabel1.attributedText = attStr1;
    }
    
    //近期战绩
    int homeTeamRecentSuccess = _matchDetailStatus.recent.homeWin;
    int homeTeamRecentEqual = _matchDetailStatus.recent.homeDraw;
    int homeTeamRecentLost = _matchDetailStatus.recent.homeLost;
    int guestTeamRecentSuccess = _matchDetailStatus.recent.awayWin;
    int guestTeamRecentEqual = _matchDetailStatus.recent.awayDraw;
    int guestTeamRecentLost = _matchDetailStatus.recent.awayLost;
    NSString * str21 = [NSString stringWithFormat:@"主队%d胜%d平%d负，",homeTeamRecentSuccess,homeTeamRecentEqual,homeTeamRecentLost];
    NSMutableAttributedString * attStr21 = [[NSMutableAttributedString alloc] initWithString:str21];
    [attStr21 addAttribute:NSForegroundColorAttributeName value:YZMDRedColor range:NSMakeRange(2, 2)];
    [attStr21 addAttribute:NSForegroundColorAttributeName value:YZMDBlueColor range:NSMakeRange(4, 2)];
    [attStr21 addAttribute:NSForegroundColorAttributeName value:YZMDGreenColor range:NSMakeRange(6, 2)];
    NSString * str22 = [NSString stringWithFormat:@"客队%d胜%d平%d负",guestTeamRecentSuccess,guestTeamRecentEqual,guestTeamRecentLost];
    NSMutableAttributedString * attStr22 = [[NSMutableAttributedString alloc] initWithString:str22];
    [attStr22 addAttribute:NSForegroundColorAttributeName value:YZMDRedColor range:NSMakeRange(2, 2)];
    [attStr22 addAttribute:NSForegroundColorAttributeName value:YZMDBlueColor range:NSMakeRange(4, 2)];
    [attStr22 addAttribute:NSForegroundColorAttributeName value:YZMDGreenColor range:NSMakeRange(6, 2)];
    NSMutableAttributedString * attStr2 = [[NSMutableAttributedString alloc] init];
    [attStr2 appendAttributedString:attStr21];
    [attStr2 appendAttributedString:attStr22];
    UILabel * contentLabel2 = self.contentLabels[1];
    contentLabel2.attributedText = attStr2;
    
    //联赛排名
    int homeTeamRank = _matchDetailStatus.leagueRank.homeRank;
    int guestTeamRank = _matchDetailStatus.leagueRank.awayRank;
    NSString * str3 = [NSString stringWithFormat:@"主队%d，客队%d",homeTeamRank,guestTeamRank];
    UILabel * contentLabel3 = self.contentLabels[2];
    if (homeTeamRank == 0 && guestTeamRank == 0) {
        contentLabel3.text = @"暂无数据";
    }else
    {
        contentLabel3.text = str3;
    }
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
