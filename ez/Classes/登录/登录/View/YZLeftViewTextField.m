//
//  YZLeftViewTextField.m
//  ez
//
//  Created by apple on 16/10/26.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZLeftViewTextField.h"

@implementation YZLeftViewTextField

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    [super textRectForBounds:bounds];
    CGFloat leftViewW = 18;
    return CGRectInset(bounds, leftViewW + 10, 0);
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    [super editingRectForBounds:bounds];
    CGFloat leftViewW = 18;
    return CGRectInset(bounds, leftViewW + 10, 0);
}
@end
