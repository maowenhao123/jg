//
//  YZFBMatchDetailTitleView.m
//  ez
//
//  Created by apple on 17/1/12.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZFBMatchDetailTitleView.h"

@interface YZFBMatchDetailTitleView ()

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *titleButtons;
@property (nonatomic, weak) UIButton *selectedButton;
@property (nonatomic, weak) UIView *buttonLine;

@end

@implementation YZFBMatchDetailTitleView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        //上分割线
        UIView * line_up = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        line_up.backgroundColor = YZWhiteLineColor;
        [self addSubview:line_up];
        //阴影
        self.layer.masksToBounds = NO;
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shadowOpacity = 1;
        self.titleArray = titleArray;
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    CGFloat titleButtonW = self.width / self.titleArray.count;
    for (int i = 0; i < self.titleArray.count; i++) {
        UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        titleButton.frame = CGRectMake(titleButtonW * i, 0, titleButtonW, self.height);
        [titleButton setTitle:self.titleArray[i] forState:UIControlStateNormal];
        titleButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [titleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [titleButton setTitleColor:YZMDGreenColor forState:UIControlStateSelected];
        if (i == 0) {//默认第一个被选中
            titleButton.selected = YES;
            titleButton.userInteractionEnabled = NO;
            self.selectedButton = titleButton;
        }
        [titleButton addTarget:self action:@selector(titleButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
    }
    //底部绿线
    UIView * buttonLine = [[UIView alloc]init];
    self.buttonLine = buttonLine;
    buttonLine.frame = CGRectMake(5, self.height - 2, titleButtonW - 2 * 5, 2);
    buttonLine.backgroundColor = YZMDGreenColor;
    [self addSubview:buttonLine];
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
