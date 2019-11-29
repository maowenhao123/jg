//
//  YZChartPlayTypeTitleButton.m
//  ez
//
//  Created by apple on 2017/3/22.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define IWTitleButtonImageW 12

#import "YZChartPlayTypeTitleButton.h"
#import "UIButton+YZ.h"

@interface YZChartPlayTypeTitleButton ()

@property (nonatomic, weak) UILabel * playTypeLabel;//玩法label

@end

@implementation YZChartPlayTypeTitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 高亮的时候不要自动调整图标
        self.adjustsImageWhenHighlighted = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(32)];
        [self setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        
        //边框
        self.layer.cornerRadius = 4;
        self.layer.borderColor = YZBlackTextColor.CGColor;
        self.layer.borderWidth = 0.8;
        
        //玩法label
        UILabel * playTypeLabel = [[UILabel alloc] init];
        self.playTypeLabel = playTypeLabel;
        playTypeLabel.text = @"玩\n法";
        playTypeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        playTypeLabel.textColor = YZBlackTextColor;
        playTypeLabel.numberOfLines = 2;
        [self addSubview:playTypeLabel];
    }
    return self;
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    CGRect frame = self.frame;
    
    // 根据title计算自己的宽度
    CGFloat titleW = [title sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(screenWidth, frame.size.height)].width + 2;
    
    CGFloat width = titleW + IWTitleButtonImageW + 12;
    CGFloat x = (screenWidth - width) / 2;
    self.frame = CGRectMake(x, frame.origin.y, width, frame.size.height);
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -IWTitleButtonImageW, 0, IWTitleButtonImageW)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleW, 0, -titleW)];
    
    CGFloat playTypeLabelW = [self.playTypeLabel.text sizeWithFont:self.playTypeLabel.font maxSize:CGSizeMake(screenWidth, frame.size.height)].width + 3;
    self.playTypeLabel.frame = CGRectMake(-playTypeLabelW, -5, playTypeLabelW, self.height + 10);
}
@end
