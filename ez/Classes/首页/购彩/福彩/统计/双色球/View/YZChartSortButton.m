//
//  YZChartSortButton.m
//  ez
//
//  Created by apple on 2017/3/20.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZChartSortButton.h"
#import "UIButton+YZ.h"

@interface YZChartSortButton ()

@property (nonatomic, weak) UIView * line;

@end

@implementation YZChartSortButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZChartBackgroundColor;
        [self setupChilds];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.line.frame = CGRectMake(0, 0, 0.8, self.height);
}
- (void)setupChilds
{
    //按钮
    self.adjustsImageWhenHighlighted = NO;
    self.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [self setTitleColor:YZChartGrayColor forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:@"chart_gray_gray"] forState:UIControlStateNormal];
    
    //分割线
    UIView * line = [[UIView alloc] init];
    self.line = line;
    line.backgroundColor = YZLightDrayColor;
    [self addSubview:line];
}
- (void)setText:(NSString *)text
{
    _text = text;
    [self setTitle:_text forState:UIControlStateNormal];
    [self setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentRight imgTextDistance:1.5];
}
- (void)setHiddenLine:(BOOL)hiddenLine
{
    _hiddenLine = hiddenLine;
    if (_hiddenLine) {
        self.line.hidden = YES;
    }else
    {
        self.line.hidden = NO;
    }
}
- (void)setSortMode:(SortMode)sortMode
{
    _sortMode = sortMode;
    if (_sortMode == SortModeAscending) {
        [self setImage:[UIImage imageNamed:@"chart_red_gray"] forState:UIControlStateNormal];
    }else if (_sortMode == SortModeDescending)
    {
        [self setImage:[UIImage imageNamed:@"chart_gray_red"] forState:UIControlStateNormal];
    }else if (_sortMode == SortModeNormal)
    {
        [self setImage:[UIImage imageNamed:@"chart_gray_gray"] forState:UIControlStateNormal];
    }
}

@end
