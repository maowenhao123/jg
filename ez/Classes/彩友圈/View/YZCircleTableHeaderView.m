//
//  YZCircleTableHeaderView.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleTableHeaderView.h"
#import "YZCircleSortView.h"

@implementation YZCircleTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    CGFloat circleSortViewH = 100;
    for (int i = 0; i < 3; i++) {
        YZCircleSortView * circleSortView = [[YZCircleSortView alloc] initWithFrame:CGRectMake(screenWidth / 3 * i, 0, screenWidth / 3, circleSortViewH)];
        [self addSubview:circleSortView];
    }
    
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, circleSortViewH, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [self addSubview:line];
    
    //公告
    UILabel * noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = @"公告：";
    noticeLabel.frame = CGRectMake(YZMargin, circleSortViewH, self.width - 2 *YZMargin, 40);
    noticeLabel.textColor = YZBlackTextColor;
    noticeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [self addSubview:noticeLabel];
}

@end
