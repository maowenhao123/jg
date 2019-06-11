//
//  YZUnionStatusFrame.m
//  ez
//
//  Created by apple on 15/3/12.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import "YZUnionBuyStatusFrame.h"

@implementation YZUnionBuyStatusFrame

- (instancetype)init
{
    if(self = [super init])
    {
        _status = [[YZUnionBuyStatus alloc] init];
    }
    return self;
}
- (void)setStatus:(YZUnionBuyStatus *)status
{
    _status = status;
    
    [self setFrame];
}
- (void)setFrame
{
    CGFloat padding = 7;
    //游戏名称的frame
    CGFloat gameNameLabelX = 2 * padding;
    CGFloat gameNameLabelY = 2 * padding;
    CGSize gameNameLabelSize = [_status.gameName sizeWithFont:bigFont maxSize:CGSizeMake(screenWidth, CGFLOAT_MAX)];
    CGFloat gameNameLabelW = gameNameLabelSize.width;
    CGFloat gameNameLabelH = gameNameLabelSize.height;
    _gameNameFrame = CGRectMake(gameNameLabelX, gameNameLabelY, gameNameLabelW, gameNameLabelH);
    
    //圆饼图的frame
    _circleChartFrame = CGRectMake(gameNameLabelX, CGRectGetMaxY(_gameNameFrame) + padding, circleChartWH, circleChartWH);
    if(circleChartWH > gameNameLabelW)//为了名字和圆饼图上下一线
    {
        _gameNameFrame = CGRectMake(gameNameLabelX, gameNameLabelY, circleChartWH, gameNameLabelH);
    }
    
    //icon的frame
    CGFloat iconX = CGRectGetMaxX(_gameNameFrame) + 6 * padding;
    CGFloat iconY = gameNameLabelY;
    CGFloat iconW = 9.0f;
    CGFloat iconH = 11.0f;
    _iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    //userName的frame
    CGFloat userNameX = CGRectGetMaxX(_iconFrame) + padding;
    CGFloat userNameY = gameNameLabelY;
    CGSize userNameSize = [_status.userName sizeWithFont:smallFont maxSize:CGSizeMake(screenWidth, CGFLOAT_MAX)];
    CGFloat userNameW = userNameSize.width;
    CGFloat userNameH = userNameSize.height;
    _userNameFrame = CGRectMake(userNameX, userNameY, userNameW, userNameH);
    
    //分割线的frame
    _seperatorFrame = CGRectMake(iconX, CGRectGetMaxY(_userNameFrame) + padding, screenWidth - iconX, 1);
    
    CGFloat dividerH = 1;
    _grayLineFrame = CGRectMake(0, CGRectGetMaxY(_circleChartFrame) + 2 * padding, screenWidth, dividerH);
    
    _cellH = CGRectGetMaxY(_grayLineFrame);
}
@end
