//
//  YZTitleButton.m
//  ez
//
//  Created by apple on 14-11-5.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define IWTitleButtonImageW 16

#import "YZTitleButton.h"
#import "UIButton+YZ.h"

@interface YZTitleButton ()

@end

@implementation YZTitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 高亮的时候不要自动调整图标
        self.adjustsImageWhenHighlighted = NO;
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentRight;
#if JG
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
#elif ZC
        [self setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
#endif

    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    CGRect frame = self.frame;
    
    // 根据title计算自己的宽度
    CGFloat titleW = [title sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(screenWidth, frame.size.height)].width + 2;
    
    CGFloat width = titleW + IWTitleButtonImageW;
    CGFloat x = (screenWidth - width) / 2;
    self.frame = CGRectMake(x, frame.origin.y, width, frame.size.height);
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -IWTitleButtonImageW, 0, IWTitleButtonImageW)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, titleW, 0, -titleW)];
    
}


@end
