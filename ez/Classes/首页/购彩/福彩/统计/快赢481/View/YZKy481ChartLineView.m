//
//  YZKy481ChartLineView.m
//  ez
//
//  Created by dahe on 2019/12/3.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481ChartLineView.h"
#import "Ky481ChartHeader.h"

@implementation YZKy481ChartLineView

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
        NSArray * renxuanMissArray = dataStatus.missNumber[@"renxuan"];
        NSArray * missArray = [NSArray array];
        if (self.chartCellTag == KChartCellTagZiyou) {
            missArray = [renxuanMissArray subarrayWithRange:NSMakeRange(0, 8)];
        }else if (self.chartCellTag == KChartCellTagYang)
        {
            missArray = [renxuanMissArray subarrayWithRange:NSMakeRange(8, 8)];
        }else if (self.chartCellTag == KChartCellTagWa)
        {
            missArray = [renxuanMissArray subarrayWithRange:NSMakeRange(16, 8)];
        }else if (self.chartCellTag == KChartCellTagDie)
        {
            missArray = [renxuanMissArray subarrayWithRange:NSMakeRange(24, 8)];
        }
        int number = 1;
        for (int j = 0; j < missArray.count; j++) {
            NSString * miss = missArray[j];
            if ([miss intValue] == 0) {
                number = j + 1;
            }
        }
        
        CGPoint point = CGPointMake(number * CellH2 - CellH2 / 2, CellH2 * i + CellH2 / 2);
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
    [YZBaseColor setStroke];
    //完成
    CGContextStrokePath(ctx);
    //在连接处要显示号码球，需剪切掉此处的线
    for (int i = 0; i < self.statusArray.count; i++) {
        CGPoint point = [points[i] CGPointValue];
        CGContextClearRect(ctx, CGRectMake(point.x - CellH2 / 2 + 10, point.y - CellH2 / 2 + 10, CellH2 - 20, CellH2 - 20));
    }
}

@end
