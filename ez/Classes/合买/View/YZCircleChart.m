//
//  YZCircleChart.m
//  ez
//
//  Created by apple on 15/3/11.
//  Copyright (c) 2015年 9ge. All rights reserved.
//
#define animateDurationOfCircle 0.4f
#define KLineWidth 3.0f
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#import "YZCircleChart.h"
#import "UICountingLabel.h"

@interface YZCircleChart ()
{
    CAShapeLayer *_trackLayer;
    CAShapeLayer *_selfBuyLayer;
    CAShapeLayer *_guaranteeLayer;
    UILabel *_selfBuyCountLabel;
    UILabel *_guaranteeCountLabel;
}
@end

@implementation YZCircleChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        //轨道
        _trackLayer = [CAShapeLayer layer];
        _trackLayer.fillColor = [UIColor clearColor].CGColor;
        _trackLayer.strokeColor = YZColor(237, 237, 237, 1).CGColor;
        _trackLayer.lineWidth = KLineWidth;
        [self.layer addSublayer:_trackLayer];
        
        //保底
        _guaranteeLayer = [CAShapeLayer layer];
        _guaranteeLayer.fillColor = [UIColor clearColor].CGColor;
        _guaranteeLayer.strokeColor = YZColor(255, 221, 105, 1).CGColor;
        _guaranteeLayer.lineWidth = KLineWidth;
        _guaranteeLayer.lineCap = kCALineCapRound;
        _guaranteeLayer.lineJoin = kCALineJoinBevel;
        [self.layer addSublayer:_guaranteeLayer];
        
        //自购
        _selfBuyLayer = [CAShapeLayer layer];
        _selfBuyLayer.fillColor = [UIColor clearColor].CGColor;
        _selfBuyLayer.strokeColor = YZColor(246, 53, 80, 1).CGColor;
        _selfBuyLayer.lineWidth = KLineWidth;
        _selfBuyLayer.lineCap = kCALineCapRound;
        _selfBuyLayer.lineJoin = kCALineJoinBevel;
        [self.layer addSublayer:_selfBuyLayer];
        
        //显示比例的label
        for(NSUInteger i = 0;i < 2;i ++)
        {
            UILabel *label = [[UILabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
            if(i == 0)
            {
                _selfBuyCountLabel = label;
                label.textColor = YZBlackTextColor;
                label.font = [UIFont boldSystemFontOfSize:YZGetFontSize(28)];
            }else
            {
                _guaranteeCountLabel = label;
                label.font = [UIFont systemFontOfSize:YZGetFontSize(20)];
                label.textColor = YZColor(246, 104, 6, 1);
            }
        }
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (void)setSelfBuyRatio:(NSNumber *)selfBuyRatio
{
    _selfBuyRatio = selfBuyRatio;

    _selfBuyCountLabel.text = [NSString stringWithFormat:@"%@%%", _selfBuyRatio];
}

- (void)setGuaranteeRatio:(NSNumber *)guaranteeRatio
{
    _guaranteeRatio = guaranteeRatio;

    int guaranteeRatio100 = round(_guaranteeRatio.floatValue * 100);
    _guaranteeCountLabel.text = [NSString stringWithFormat:@"保%d%%", guaranteeRatio100];
    _guaranteeCountLabel.hidden = guaranteeRatio100 == 0 ? YES :NO;
    if (_guaranteeCountLabel.hidden) {
        _selfBuyCountLabel.frame = self.bounds;
    }else
    {
        _selfBuyCountLabel.frame = CGRectMake(0, 5, self.width, self.height * 0.5);
        _guaranteeCountLabel.frame = CGRectMake(0, CGRectGetMaxY(_selfBuyCountLabel.frame), self.width, self.height * 0.2);
    }
}

- (void)strokeChart
{
    CGPoint arcCenter = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    CGFloat radius = (self.frame.size.width - KLineWidth) / 2;
    
    UIBezierPath *trackPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(360) clockwise:YES];
    _trackLayer.path = trackPath.CGPath;
    
    UIBezierPath *zeroPath = [UIBezierPath bezierPathWithArcCenter:CGPointZero radius:0 startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
    _guaranteeLayer.path = zeroPath.CGPath;
    _selfBuyLayer.path = zeroPath.CGPath;
    
    //自购
    CGFloat startAngleNumber = -90;
    CGFloat selfBuyEndNumber = startAngleNumber + (self.selfBuyRatio.intValue * 360) / 100;
    
    UIBezierPath *selfBuyPath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:DEGREES_TO_RADIANS(startAngleNumber) endAngle:DEGREES_TO_RADIANS(selfBuyEndNumber) clockwise:YES];
    _selfBuyLayer.path = selfBuyPath.CGPath;
    
    //保底
    CGFloat guaranteeNumber = selfBuyEndNumber + self.guaranteeRatio.floatValue * 360;
    int guaranteeRatio100 = round(_guaranteeRatio.floatValue * 100);
    if(self.selfBuyRatio.intValue == 1 || guaranteeRatio100 == 0) //进度满了，就不画黄色圈 保底进度0，就不画黄色圈
    {
        guaranteeNumber = selfBuyEndNumber;
    }
    UIBezierPath *guaranteePath = [UIBezierPath bezierPathWithArcCenter:arcCenter radius:radius startAngle:DEGREES_TO_RADIANS(selfBuyEndNumber) endAngle:DEGREES_TO_RADIANS(guaranteeNumber) clockwise:YES];
    _guaranteeLayer.path = guaranteePath.CGPath;
}


@end
