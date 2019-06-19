//
//  YZCircleSortView.m
//  ez
//
//  Created by 毛文豪 on 2018/5/8.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleSortView.h"

@implementation YZCircleSortView

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
    logoImageView.image = [UIImage imageNamed:@"icon_F01"];
    [self addSubview:logoImageView];
    
    UILabel * gameNameLabel = [[UILabel alloc] init];
    gameNameLabel.text = @"高频彩";
    gameNameLabel.frame = CGRectMake(0, CGRectGetMaxY(logoImageView.frame) + 3, self.width, 15);
    gameNameLabel.textColor = YZBlackTextColor;
    gameNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    gameNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:gameNameLabel];
    
    UILabel * numberLabel = [[UILabel alloc] init];
    numberLabel.text = @"128";
    numberLabel.frame = CGRectMake(0, CGRectGetMaxY(gameNameLabel.frame) + 3, self.width, 15);
    numberLabel.textColor = YZRedTextColor;
    numberLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:numberLabel];
}

@end
