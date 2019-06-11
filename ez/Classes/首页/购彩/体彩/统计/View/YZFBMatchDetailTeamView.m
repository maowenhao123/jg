//
//  YZFBMatchDetailTeamView.m
//  ez
//
//  Created by apple on 17/1/12.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define alphaPadding 7
#define padding 7

#import "YZFBMatchDetailTeamView.h"
#import "UIImageView+WebCache.h"

@interface YZFBMatchDetailTeamView ()

@property (nonatomic, weak) UIImageView *homeTeamImageView;//主队
@property (nonatomic, weak) UIImageView *guestTeamImageView;//客队


@end

@implementation YZFBMatchDetailTeamView

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
    UIView * homeAlphaView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, 80, 80)];
    homeAlphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    homeAlphaView.layer.masksToBounds = YES;
    homeAlphaView.layer.cornerRadius = homeAlphaView.width / 2;
    [self addSubview:homeAlphaView];
    
    UIView * homeView = [[UIView alloc] initWithFrame:CGRectMake(alphaPadding, alphaPadding, homeAlphaView.width - 2 * alphaPadding, homeAlphaView.height - 2 * alphaPadding)];
    homeView.backgroundColor = [UIColor whiteColor];
    homeView.layer.masksToBounds = YES;
    homeView.layer.cornerRadius = homeView.width / 2;
    [homeAlphaView addSubview:homeView];
    
    UIImageView * homeTeamImageView = [[UIImageView alloc]initWithFrame:CGRectMake(padding, padding, homeView.width - 2 * padding, homeView.height - 2 * padding)];
    self.homeTeamImageView = homeTeamImageView;
    homeTeamImageView.image = [UIImage imageNamed:@"fb_logo_none"];
    [homeView addSubview:homeTeamImageView];
    
    //比分
    UILabel * scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.width / 2 - 40, 0, 80, 80)];
    self.scoreLabel = scoreLabel;
    scoreLabel.text = @"VS";
    scoreLabel.font = [UIFont boldSystemFontOfSize:28];
    scoreLabel.textColor = [UIColor colorWithWhite:0 alpha:1];
    scoreLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:scoreLabel];
    
    //客队
    UIView * guestAlphaView = [[UIView alloc] initWithFrame:CGRectMake(self.width - 40 - 80, 0, 80, 80)];
    guestAlphaView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    guestAlphaView.layer.masksToBounds = YES;
    guestAlphaView.layer.cornerRadius = homeAlphaView.width / 2;
    [self addSubview:guestAlphaView];
    
    UIView * guestView = [[UIView alloc] initWithFrame:CGRectMake(alphaPadding, alphaPadding, guestAlphaView.width - 2 * alphaPadding, guestAlphaView.height - 2 * alphaPadding)];
    guestView.backgroundColor = [UIColor whiteColor];
    guestView.layer.masksToBounds = YES;
    guestView.layer.cornerRadius = guestView.width / 2;
    [guestAlphaView addSubview:guestView];
    
    UIImageView * guestTeamImageView = [[UIImageView alloc]initWithFrame:CGRectMake(padding, padding, guestView.width - 2 * padding, guestView.height - 2 * padding)];
    self.guestTeamImageView = guestTeamImageView;
    guestTeamImageView.image = [UIImage imageNamed:@"fb_logo_none"];
    [guestView addSubview:guestTeamImageView];
}
- (void)setRound:(YZRoundStatus *)round
{
    _round = round;
    UIImage * placeholderImage = [UIImage imageNamed:@"fb_logo_none"];
    [self.homeTeamImageView sd_setImageWithURL:[NSURL URLWithString:_round.home.logo] placeholderImage:placeholderImage];
    [self.guestTeamImageView sd_setImageWithURL:[NSURL URLWithString:_round.away.logo] placeholderImage:placeholderImage];
}

@end
