//
//  YZChooseLuckyNumberView.m
//  ez
//
//  Created by 毛文豪 on 2018/7/13.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZChooseLuckyNumberView.h"

@interface YZChooseLuckyNumberView ()

@end

@implementation YZChooseLuckyNumberView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChilds];
    }
    return self;
}

#pragma mark - 创建视图
- (void)setupChilds
{
    CGFloat numberTFWH = 83;
    YZTextField *numberTF = [[YZTextField alloc] initWithFrame:CGRectMake((self.width - numberTFWH) / 2, 20, numberTFWH, numberTFWH)];
    self.numberTF = numberTF;
    numberTF.backgroundColor = RGBACOLOR(196, 165, 134, 1);
    numberTF.textColor = [UIColor whiteColor];
    numberTF.font = [UIFont boldSystemFontOfSize:YZGetFontSize(48)];
    numberTF.textAlignment = NSTextAlignmentCenter;
    numberTF.keyboardType = UIKeyboardTypeNumberPad;
    numberTF.borderStyle = UITextBorderStyleNone;
    numberTF.tintColor = [UIColor whiteColor];
    numberTF.layer.masksToBounds = YES;
    numberTF.layer.cornerRadius = numberTFWH / 2;
    numberTF.maxLength = 2;
    [self addSubview:numberTF];
    
    self.height = CGRectGetMaxY(self.numberTF.frame) + 20;
    
}


@end
