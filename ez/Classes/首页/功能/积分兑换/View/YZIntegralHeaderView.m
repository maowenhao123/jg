//
//  YZIntegralHeaderView.m
//  ez
//
//  Created by 毛文豪 on 2018/2/5.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZIntegralHeaderView.h"

@interface YZIntegralHeaderView ()

@property (nonatomic,weak) UIView * line;
@property (nonatomic,weak) UILabel *label;

@end

@implementation YZIntegralHeaderView

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
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    self.line = line;
    line.backgroundColor = YZWhiteLineColor;
    [self addSubview:line];
    
    //选择兑换张数
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 13, 5, 15)];
    lineView.backgroundColor = YZBaseColor;
    [self addSubview:lineView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineView.frame) + 7, 13, screenWidth - CGRectGetMaxX(lineView.frame) - 7 - 10, 15)];
    self.label = label;
    label.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    label.textColor = YZDrayGrayTextColor;
    [self addSubview:label];
}

- (void)setHideLine:(BOOL)hideLine
{
    _hideLine = hideLine;
    
    self.line.hidden = hideLine;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.label.text = _title;
}

@end
