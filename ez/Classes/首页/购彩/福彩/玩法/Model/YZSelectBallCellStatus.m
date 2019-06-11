//
//  YZSelectBallCellStatus.m
//  ez
//
//  Created by apple on 14-9-11.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define iconTitleW 44

#import "YZSelectBallCellStatus.h"

@implementation YZSelectBallCellStatus

- (instancetype)init
{
    if(self = [super init])
    {
        _ballReuse = YES;
    }
    return self;
}

- (NSMutableArray *)selBalls
{
    if(_selBalls == nil)
    {
        _selBalls = [NSMutableArray array];
    }
    return _selBalls;
}

- (CGFloat)cellH
{
    CGFloat padding = 0;//球与球的边距
    CGFloat btnW = 35;
    CGFloat btnH = 35;
    CGFloat cellH = 0;
    int maxColumns = _icon ? 6 : 7;//一行显示几个
    for (int i = 0; i < _ballsCount; i++) {
        CGFloat btnX = 0;
        if(_icon)//红色图片有文字
        {
            padding = (screenWidth - maxColumns * btnW - iconTitleW) / (maxColumns + 1);
            btnX = padding + iconTitleW + (i % maxColumns) * (btnW + padding);
        }else
        {
            padding = (screenWidth - maxColumns * btnW ) / (maxColumns + 1);
            btnX = padding + (i % maxColumns) * (btnW + padding);
        }
        CGFloat btnY = 0;
        //
        if(_title)
        {
            if (_icon && !_RandomCount) {
                btnY = 40 + padding + (i / maxColumns) * (btnH + padding);
            }else
            {
                btnY = 30 + padding + (i / maxColumns) * (btnH + padding);
            }
        }else
        {
            btnY = padding + (i / maxColumns) * (btnH + padding);
        }
        CGRect rect = CGRectMake(btnX, btnY, btnW, btnH);
        cellH = CGRectGetMaxY(rect) + padding;
    }
    _cellH = cellH;
    return _cellH;
}
@end
