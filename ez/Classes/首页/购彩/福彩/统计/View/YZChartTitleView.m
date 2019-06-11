//
//  YZChartTitleView.m
//  ez
//
//  Created by apple on 17/3/3.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZChartTitleView.h"

@interface YZChartTitleView ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *titleButtons;
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, weak) UIView *buttonLine;

@end

@implementation YZChartTitleView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZChartBackgroundColor;
        self.titleArray = titleArray;
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    CGFloat titleButtonW = self.width / 4;
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView = scrollView;
    scrollView.contentSize = CGSizeMake(titleButtonW * self.titleArray.count, self.height);
    scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        titleButton.frame = CGRectMake(titleButtonW * i, 0, titleButtonW, self.height);
        [titleButton setTitle:self.titleArray[i] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        [titleButton setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [titleButton setTitleColor:YZRedTextColor forState:UIControlStateSelected];
        if (i == 0) {//默认第一个被选中
            titleButton.selected = YES;
            titleButton.userInteractionEnabled = NO;
            self.selectedButton = titleButton;
        }
        [titleButton addTarget:self action:@selector(titleButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
    }
    
    //分割线
    UIView * line = [[UIView alloc]init];
    line.frame = CGRectMake(0, self.height - 0.8, self.scrollView.contentSize.width, 0.8);
    line.backgroundColor = YZLightDrayColor;
    [scrollView addSubview:line];
    
    //底部红线
    UIView * buttonLine = [[UIView alloc]init];
    self.buttonLine = buttonLine;
    buttonLine.frame = CGRectMake(5, self.height - 2, titleButtonW - 2 * 5, 2);
    buttonLine.backgroundColor = YZRedTextColor;
    [scrollView addSubview:buttonLine];
}
- (void)titleButtonDidClick:(UIButton *)button
{
    if (button == self.selectedButton) {
        return;
    }
    self.selectedButton.selected = NO;
    self.selectedButton.userInteractionEnabled = YES;
    button.selected = YES;
    button.userInteractionEnabled = NO;
    self.selectedButton = button;
    //红线动画
    [UIView animateWithDuration:animateDuration
                     animations:^{
                         self.buttonLine.centerX = button.centerX;
                     }];
    //所选按钮居中显示
    NSInteger index = button.tag;
    CGFloat buttonW = button.width;
    CGFloat offsetX;
    if (index <= 1) {
        offsetX = 0;
    }else if (index > 1 && index < self.titleButtons.count - 2) {
        offsetX = (index - 1.5) * buttonW;
    }else
    {
        offsetX = self.scrollView.contentSize.width - self.width;
    }
    [self.scrollView setContentOffset:CGPointMake(offsetX, self.scrollView.mj_offsetY) animated:YES];
    //协议
    if (_delegate && [_delegate respondsToSelector:@selector(scrollViewScrollIndex:)]) {
        [_delegate scrollViewScrollIndex:button.tag];
    }
}
- (void)changeSelectedBtnIndex:(NSInteger)index
{
    [self titleButtonDidClick:self.titleButtons[index]];
}
#pragma mark - 初始化
- (NSArray *)titleArray
{
    if (_titleArray == nil) {
        _titleArray = [NSArray array];
    }
    return _titleArray;
}
- (NSMutableArray *)titleButtons
{
    if (_titleButtons == nil) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

@end
