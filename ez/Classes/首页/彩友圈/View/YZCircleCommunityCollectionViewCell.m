//
//  YZCircleCommunityCollectionViewCell.m
//  ez
//
//  Created by dahe on 2019/6/20.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZCircleCommunityCollectionViewCell.h"

@interface YZCircleCommunityCollectionViewCell ()

@property (nonatomic,weak) UIImageView * logoImageView;
@property (nonatomic,weak) UILabel * gameNameLabel;
@property (nonatomic,weak) UILabel * numberLabel;

@end

@implementation YZCircleCommunityCollectionViewCell

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
    CGFloat logoImageViewWH = 45;
    UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - logoImageViewWH) / 2, 10, logoImageViewWH, logoImageViewWH)];
    self.logoImageView = logoImageView;
    logoImageView.backgroundColor = YZLightDrayColor;;
    [self addSubview:logoImageView];
    
    UILabel * gameNameLabel = [[UILabel alloc] init];
    self.gameNameLabel = gameNameLabel;
    gameNameLabel.frame = CGRectMake(0, CGRectGetMaxY(logoImageView.frame) + 3, self.width, 15);
    gameNameLabel.textColor = YZBlackTextColor;
    gameNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    gameNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:gameNameLabel];
    
    UILabel * numberLabel = [[UILabel alloc] init];
    self.numberLabel = numberLabel;
    numberLabel.frame = CGRectMake(0, CGRectGetMaxY(gameNameLabel.frame) + 3, self.width, 15);
    numberLabel.textColor = YZRedTextColor;
    numberLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:numberLabel];
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:_dic[@"picUrl"]]];
    self.gameNameLabel.text = _dic[@"name"];
}

@end
