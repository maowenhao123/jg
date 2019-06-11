//
//  YZBottomButton.m
//  ez
//
//  Created by 毛文豪 on 2019/3/28.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZBottomButton.h"

@implementation YZBottomButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    YZBottomButton *button = [super buttonWithType:buttonType];
    button.frame = CGRectMake(17, YZBottomButtonMT, screenWidth - 17 * 2, 40);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [button setBackgroundImage:[UIImage ImageFromColor:YZBaseColor] forState:UIControlStateNormal];//正常
    [button setBackgroundImage:[UIImage ImageFromColor:YZColor(163, 32, 27, 1)] forState:UIControlStateHighlighted];//高亮
    [button setBackgroundImage:[UIImage ImageFromColor:YZColor(215, 215, 215, 1)] forState:UIControlStateDisabled];//不可选
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 3;
    return button;
}

@end
