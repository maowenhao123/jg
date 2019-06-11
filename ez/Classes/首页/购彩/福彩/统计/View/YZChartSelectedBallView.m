//
//  YZChartSelectedBallView.m
//  ez
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZChartSelectedBallView.h"

@implementation YZChartSelectedBallView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChilds];
    }
    return self;
}
#pragma mark - 布局子视图
- (void)setupChilds
{
    int maxBall = 12;//显示球数
    CGFloat labelWScale = 2;//选号label与ball的比例
    CGFloat ballW = self.width / (maxBall + labelWScale);
    CGFloat labelW = ballW * labelWScale;
    
    //已选
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelW, self.height)];
    label.text = @"已选";
    label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    label.textColor = YZBlackTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    //号码label
    UILabel * numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, self.width - CGRectGetMaxX(label.frame), self.height)];
    self.numberLabel = numberLabel;
    numberLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [self addSubview:numberLabel];
}

@end
