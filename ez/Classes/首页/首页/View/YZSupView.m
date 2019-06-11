//
//  YZSupView.m
//  ez
//
//  Created by apple on 16/12/29.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height
#define PI 3.14159265358979323846
#define angle 2

#import "YZSupView.h"
#import <QuartzCore/QuartzCore.h>  

@implementation YZSupView

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, KHeight / 2 + angle, 0);//从左上角开始
    CGContextAddLineToPoint(context, KWidth - KHeight / 2, 0);
    CGContextAddArc(context, KWidth - KHeight / 2, KHeight / 2, KHeight / 2, PI / 2, -PI / 2, 1);
    CGContextAddLineToPoint(context, KWidth - KHeight / 2, KHeight);
    CGContextAddLineToPoint(context, 0 , KHeight);
    CGContextAddLineToPoint(context, KHeight / 2, 0);
    CGContextAddArc(context, KHeight / 2 + angle, KHeight / 2, KHeight / 2, PI / 2, -PI / 2, 0);
    CGContextSetLineWidth(context, 0.0);//线的宽度
    [YZColor(242, 35, 84, 1) setFill];
    
    CGContextDrawPath(context, kCGPathFillStroke); //绘制路径加填充
    //文字
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.alignment = NSTextAlignmentCenter;//文字居中显示
    NSDictionary * attDic =@{
                             NSFontAttributeName:[UIFont systemFontOfSize:YZGetFontSize(19)],
                             NSForegroundColorAttributeName:[UIColor whiteColor],
                             NSParagraphStyleAttributeName:paragraphStyle
                             };
    
    [self.text drawInRect:CGRectMake(angle, 1, KWidth - angle, KHeight - 1) withAttributes:attDic];
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self layoutIfNeeded];
}

@end
