//
//  YZBuyLotteryCollectionReusableView.m
//  ez
//
//  Created by 毛文豪 on 2019/6/6.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZBuyLotteryCollectionReusableView.h"
#import "YZInformationH5ViewController.h"

@implementation YZBuyLotteryCollectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 10)];
        lineView.backgroundColor = YZBackgroundColor;
        [self addSubview:lineView];
        
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(YZMargin, 10 + 2, screenWidth  - 2 * YZMargin, 40 - 2)];
        titleLabel.text = @"最新资讯";
        titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
        titleLabel.textColor = YZBlackTextColor;
        [self addSubview:titleLabel];
        
        UIButton * allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [allButton setTitle:@"更多>" forState:UIControlStateNormal];
        [allButton setTitleColor:YZDrayGrayTextColor forState:UIControlStateNormal];
        allButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        CGSize allButtonSize = [allButton.currentTitle sizeWithLabelFont:allButton.titleLabel.font];
        allButton.frame = CGRectMake(screenWidth - YZMargin - allButtonSize.width, 10, allButtonSize.width, 40);
        [allButton addTarget:self action:@selector(allButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:allButton];
    }
    return self;
}

- (void)allButtonDidClick
{
    YZInformationH5ViewController * informationVC = [[YZInformationH5ViewController alloc] init];
    [self.viewController.navigationController pushViewController:informationVC animated:YES];
}

@end
