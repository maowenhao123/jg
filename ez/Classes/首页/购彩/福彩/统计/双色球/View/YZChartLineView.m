//
//  YZChartLineView.m
//  ez
//
//  Created by apple on 17/3/10.
//  Copyright © 2017年 9ge. All rights reserved.
//

#define cellH screenWidth / 13

#import "YZChartLineView.h"
#import "YZChartDataStatus.h"

@implementation YZChartLineView

- (void)setStatusArray:(NSArray *)statusArray
{
    _statusArray = statusArray;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //连线
    NSMutableArray * points = [NSMutableArray array];
    for (int i = 0; i < _statusArray.count; i++) {
        YZChartDataStatus * dataStatus = _statusArray[i];
        NSArray * missArray = dataStatus.missNumber[@"bluemiss"];
        int number = 1;
        for (int j = 0; j < missArray.count; j++) {
            NSString * miss = missArray[j];
            if ([miss intValue] == 0) {
                number = j + 1;
            }
        }
        
        CGPoint point = CGPointMake(number * cellH - cellH / 2, cellH * i + cellH / 2);
        [points addObject:[NSValue valueWithCGPoint:point]];
        if (i == 0) {
            CGContextMoveToPoint(ctx, point.x, point.y);
        }else{
            if (missArray.count > 0) {
                CGContextAddLineToPoint(ctx, point.x, point.y);
            }
        }
    }
    // 设置线宽
    CGContextSetLineWidth(ctx, 1.3);
    //设置颜色
    [YZColor(51, 111, 218, 1) setStroke];
    //完成
    CGContextStrokePath(ctx);
    //在连接处要显示号码球，需剪切掉此处的线
    for (int i = 0; i < self.statusArray.count; i++) {
        CGPoint point = [points[i] CGPointValue];
        CGContextClearRect(ctx, CGRectMake(point.x - cellH / 2 + 5,point.y - cellH / 2 + 5, cellH - 10, cellH - 10));
    }
}

@end
