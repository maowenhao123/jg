//
//  YZFBMatchDetailOddsTrendView.m
//  ez
//
//  Created by apple on 17/2/13.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZFBMatchDetailOddsTrendView.h"

@interface YZFBMatchDetailOddsTrendView ()

@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation YZFBMatchDetailOddsTrendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    UILabel * label = [[UILabel alloc] init];
    self.label = label;
    label.textColor = YZBlackTextColor;
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    [self addSubview:label];
    
    UIImageView * imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [self addSubview:imageView];
}
- (void)setOdds:(NSString *)odds
{
    _odds = odds;
    self.label.text = _odds;
    [self setFitSize];
}
- (void)setTrend:(int)trend
{
    _trend = trend;
    if (_trend > 0) {
        self.imageView.image = [UIImage imageNamed:@"fb_red_up"];
        self.label.textColor = YZMDRedColor;
    }else if (_trend < 0)
    {
        self.imageView.image = [UIImage imageNamed:@"fb_green_down"];
        self.label.textColor = YZMDGreenColor;
    }else
    {
        self.label.textColor = YZBlackTextColor;
    }
    [self setFitSize];
}
- (void)setFitSize
{
    UIImageView * imageView = [[UIImageView alloc] initWithImage:self.imageView.image];
    CGFloat imageViewW = imageView.width;
    CGFloat imageViewH = imageView.height;
    if (self.trend == 0) {
        imageViewW = 0;
        imageViewH = 0;
    }
    CGSize labelSize = [self.label.text sizeWithFont:self.label.font maxSize:CGSizeMake(self.width, MAXFLOAT)];
    CGFloat padding = 0;//文字与图片的分割线
    CGFloat labelX = (self.width - labelSize.width - padding - imageViewW) / 2;
    self.label.frame = CGRectMake(labelX, 0, labelSize.width, self.height);
    CGFloat imageViewX = CGRectGetMaxX(self.label.frame) + padding;
    CGFloat imageViewY = (self.height - imageViewH) / 2;
    self.imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
}
@end
