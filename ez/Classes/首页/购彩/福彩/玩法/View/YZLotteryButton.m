//
//  YZLotteryButton.m
//  ez
//
//  Created by apple on 14-8-13.
//  Copyright (c) 2014年 9ge. All rights reserved.
//文字和图片的frame一样的按钮

#import "YZLotteryButton.h"

@implementation YZLotteryButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}


- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return contentRect;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return contentRect;
}

@end
