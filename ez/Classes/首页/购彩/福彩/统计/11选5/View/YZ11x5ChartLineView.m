//
//  YZ11x5ChartLineView.m
//  ez
//
//  Created by dahe on 2019/12/6.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZ11x5ChartLineView.h"

@implementation YZ11x5ChartLineView

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
        NSArray * zhixuanMissArray = dataStatus.missNumber[@"qian3_zhixuan"];
        NSArray * missArray = [NSArray array];
        if (self.chartCellTag == KChartCellTagWan)
        {
            missArray = [zhixuanMissArray subarrayWithRange:NSMakeRange(0, 11)];
        }else if (self.chartCellTag == KChartCellTagQian)
        {
            missArray = [zhixuanMissArray subarrayWithRange:NSMakeRange(11, 11)];
        }else if (self.chartCellTag == KChartCellTagBai)
        {
            missArray = [zhixuanMissArray subarrayWithRange:NSMakeRange(22, 11)];
        }
        int number = 1;
        for (int j = 0; j < missArray.count; j++) {
            NSString * miss = missArray[j];
            if ([miss intValue] == 0) {
                number = j + 1;
            }
        }
        
        CGPoint point = CGPointMake(number * CellH - CellH / 2, CellH * i + CellH / 2);
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
    if (self.chartCellTag == KChartCellTagWan)
    {
        [RGBACOLOR(214, 75, 75, 1) setStroke];
    }else if (self.chartCellTag == KChartCellTagQian)
    {
        [RGBACOLOR(61, 166, 103, 1) setStroke];
    }else if (self.chartCellTag == KChartCellTagBai)
    {
        [RGBACOLOR(68, 174, 218, 1) setStroke];
    }
    
    //完成
    CGContextStrokePath(ctx);
    //在连接处要显示号码球，需剪切掉此处的线
    for (int i = 0; i < self.statusArray.count; i++) {
        CGPoint point = [points[i] CGPointValue];
        CGContextClearRect(ctx, CGRectMake(point.x - CellH / 2 + 7, point.y - CellH / 2 + 7, CellH - 14, CellH - 14));
    }
}

@end
