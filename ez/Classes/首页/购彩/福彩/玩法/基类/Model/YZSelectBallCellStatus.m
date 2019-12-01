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
    CGFloat btnW = 36;
    CGFloat btnH = 36;
    CGFloat cellH = 0;
    int maxColumns = 7;//一行显示几个
    if (!YZStringIsEmpty(_icon)) {
        maxColumns = 6;
    }
    if (!YZStringIsEmpty(_leftTitle)) {
        maxColumns = 8;
    }
    CGFloat leftPadding = 0;
    if (!YZStringIsEmpty(_leftTitle)) {
        leftPadding = 20;
    }
    for (int i = 0; i < _ballsCount; i++) {
        CGFloat btnX = 0;
        if (!YZStringIsEmpty(_icon))
        {
            padding = (screenWidth - leftPadding - maxColumns * btnW - iconTitleW) / (maxColumns + 1);
            btnX = leftPadding + padding + iconTitleW + (i % maxColumns) * (btnW + padding);
        }else
        {
            padding = (screenWidth - leftPadding - maxColumns * btnW ) / (maxColumns + 1);
            btnX = leftPadding + padding + (i % maxColumns) * (btnW + padding);
        }
        CGFloat btnY = 0;
        //
        if(_title)
        {
            if (!YZStringIsEmpty(_icon) && !_RandomCount) {
                btnY = 40 + padding + (i / maxColumns) * (btnH + padding);
            }else if (!YZStringIsEmpty(_leftTitle))
            {
                btnY = 60 + 5 + (i / maxColumns) * (btnH + padding);
            }else
            {
                btnY = 30 + padding + (i / maxColumns) * (btnH + padding);
            }
        }else
        {
            if (!YZStringIsEmpty(_leftTitle))
            {
                btnY = 30 + 5 + (i / maxColumns) * (btnH + padding);
            }else
            {
                btnY = padding + (i / maxColumns) * (btnH + padding);
            }
        }
        CGRect rect = CGRectMake(btnX, btnY, btnW, btnH);
        if (padding < 10) {
            cellH = CGRectGetMaxY(rect) + 10;
        }else
        {
            cellH = CGRectGetMaxY(rect) + padding;
        }
    }
    _cellH = cellH;
    return _cellH;
}

@end
