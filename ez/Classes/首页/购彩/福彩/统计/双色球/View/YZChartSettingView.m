//
//  YZChartSettingView.m
//  ez
//
//  Created by apple on 17/3/9.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define padding 30

#import "YZChartSettingView.h"
#import "UIButton+YZ.h"

@interface YZChartSettingView ()<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView * contentView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSDictionary *settingDic;
@property (nonatomic, strong) NSMutableArray *selectedButtons;

@end

@implementation YZChartSettingView

- (instancetype)initWithTitleArray:(NSArray *)titleArray
{
    self = [super init];
    if (self) {
        self.titleArray = titleArray;
        [self setupChilds];
    }
    return self;
}
#pragma mark - 布局子视图
- (void)setupChilds
{
    self.frame = KEY_WINDOW.bounds;
    self.backgroundColor = YZColor(0, 0, 0, 0.4);
    UIView *topView = [KEY_WINDOW.subviews firstObject];
    [topView addSubview:self];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth -  2 * padding, 0)];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.cornerRadius = 5;
    [self addSubview:contentView];
    
    //icon
    UIImageView * imageView = [[UIImageView alloc] init];
    CGFloat imageViewWH = 18;
    imageView.frame = CGRectMake(20, (40 - imageViewWH) / 2, imageViewWH, imageViewWH);
    imageView.image = [UIImage imageNamed:@"chart_setting"];
    [contentView addSubview:imageView];
    
    //title
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"走势图设置";
    titleLabel.textColor = YZBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(32)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    CGSize titleLabelSize = [titleLabel.text sizeWithLabelFont:titleLabel.font];
    titleLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, titleLabelSize.width, 40);
    [contentView addSubview:titleLabel];
    
    //帮助
    UIButton * helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpButton setTitle:@"帮助>" forState:UIControlStateNormal];
    [helpButton setTitleColor:YZBlueBallColor forState:UIControlStateNormal];
    helpButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(27)];
    [helpButton addTarget:self action:@selector(helpButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    CGSize helpButtonSize = [helpButton.currentTitle sizeWithLabelFont:helpButton.titleLabel.font];
    helpButton.frame = CGRectMake(contentView.width - helpButtonSize.width - 10, 0, helpButtonSize.width, 40);
    [contentView addSubview:helpButton];
    
    //分割线1
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), contentView.width, 1)];
    line1.backgroundColor = YZWhiteLineColor;
    [contentView addSubview:line1];
    
    //选项
    UIView * lastView;
    CGFloat titleLabelX = 20;
    CGFloat titleLabelH = 20;
    CGFloat optionButtonW = 100;
    for (int i = 0; i < self.titleArray.count; i++) {
        //标题
        NSString * title = self.titleArray[i];
        NSArray * options = self.settingDic[title];
        CGFloat titleViewH = 50;
        if (options.count == 4) {//四个选项的
            titleViewH = 80;
        }
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.text = [NSString stringWithFormat:@"%@:",self.titleArray[i]];
        titleLabel.textColor = YZBlackTextColor;
        titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
        CGSize titleLabelSize = [titleLabel.text sizeWithLabelFont:titleLabel.font];
        titleLabel.frame = CGRectMake(titleLabelX, CGRectGetMaxY(lastView.frame) + 17, titleLabelSize.width, titleLabelH);
        if (i == 0) {//第一个
            titleLabel.y = CGRectGetMaxY(line1.frame) + 15;
        }else
        {
            NSString * lastTitle = self.titleArray[i - 1];
            NSArray * lastOptions = self.settingDic[lastTitle];
            if (lastOptions.count == 4) {//上一个有4个选项 增加高度
                titleLabel.y = CGRectGetMaxY(lastView.frame) + 8 + titleLabelH + 17;
            }
        }
        [contentView addSubview:titleLabel];
        
        //选项
        for (int j = 0; j < options.count; j++) {
            UIButton * optionButton = [UIButton buttonWithType:UIButtonTypeCustom];
            optionButton.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame) + 10 + j % 2 * (optionButtonW + 20), titleLabel.y + j / 2 * (titleLabelH + 8), optionButtonW, titleLabelH);
            optionButton.tag = 100 * i + j;
            [optionButton setTitle:options[j] forState:UIControlStateNormal];
            [optionButton setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
            optionButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
            [optionButton setImage:[UIImage imageNamed:@"chart_weixuanzhong"] forState:UIControlStateNormal];
            [optionButton setImage:[UIImage imageNamed:@"chart_xuanzhong"] forState:UIControlStateHighlighted];
             [optionButton setImage:[UIImage imageNamed:@"chart_xuanzhong"] forState:UIControlStateSelected];
            [optionButton addTarget:self action:@selector(optionButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
            //设置图片和文字的间距
            optionButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
            CGFloat imgTextDistance = 3;//图片文字的间距
            [optionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, imgTextDistance, 0, 0)];
            //设置选中状态
            optionButton.selected = NO;
            NSString * settingStr = [YZTool getChartSettingByTitle:self.titleArray[i]];
            if ([optionButton.currentTitle isEqualToString:settingStr]) {
                optionButton.selected = YES;
                [self.selectedButtons addObject:optionButton];
            }
            [contentView addSubview:optionButton];
        }
        
        lastView = titleLabel;
    }
    if ([self.titleArray containsObject:@"统计"]) {
        UILabel * detailLabel = [[UILabel alloc] init];
        detailLabel.text = @"(走势图底部的出现次数等统计数据)";
        detailLabel.textColor = YZLightDrayColor;
        detailLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        CGSize detailLabelSize = [detailLabel.text sizeWithLabelFont:detailLabel.font];
        detailLabel.frame = CGRectMake(CGRectGetMaxX(lastView.frame) + 10, CGRectGetMaxY(lastView.frame) + 5, detailLabelSize.width, detailLabelSize.height);
        [contentView addSubview:detailLabel];
        lastView = detailLabel;
    }
    //分割线2
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lastView.frame) + 15, contentView.width, 1)];
    line2.backgroundColor = YZWhiteLineColor;
    [contentView addSubview:line2];
    
    CGFloat buttonW = 100;
    CGFloat buttonH = 30;
    CGFloat buttonY = CGRectGetMaxY(line2.frame) + 10;
    //取消
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake((contentView.width / 2 - buttonW) / 2, buttonY, buttonW, buttonH);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [cancelBtn addTarget:self action:@selector(cancelBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.layer.cornerRadius = 4;
    cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cancelBtn.layer.borderWidth = 0.5f;
    [contentView addSubview:cancelBtn];
    
    //确定
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(contentView.width / 2 + (contentView.width / 2 - buttonW) / 2, buttonY, buttonW, buttonH);
    confirmBtn.backgroundColor = YZRedBallColor;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [confirmBtn addTarget:self action:@selector(confirmBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.layer.cornerRadius = 4;
    [contentView addSubview:confirmBtn];
    
    //设置大小
    contentView.height = CGRectGetMaxY(cancelBtn.frame) + 10;
    contentView.center = self.center;
    contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        contentView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)optionButtonDidClick:(UIButton *)button
{
    if (button.selected) return;//当前按钮是被选中状态
    button.selected = YES;
    UIButton * _selectedButton;
    for (UIButton * selectedButton in self.selectedButtons) {
        if (button.tag / 100 == selectedButton.tag / 100) {
            selectedButton.selected = NO;
            _selectedButton = selectedButton;
            break;
        }
    }
    [self.selectedButtons removeObject:_selectedButton];
    [self.selectedButtons addObject:button];
}
- (void)hide
{
    self.alpha = 1;
    [UIView animateWithDuration:animateDuration
                     animations:^{
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}
- (void)helpButtonDidClick
{
    [self hide];
    //协议
    if (_delegate && [_delegate respondsToSelector:@selector(settingGotoHelpVC)]) {
        [_delegate settingGotoHelpVC];
    }
}
- (void)cancelBtnDidClick
{
    [self hide];
}
- (void)confirmBtnDidClick
{
    [self hide];
    //更新设置数据
    for (UIButton * selectedButton in self.selectedButtons) {
        [YZTool setChartSettingWithTitle:self.titleArray[selectedButton.tag / 100] string:selectedButton.currentTitle];
    }
    //协议
    if (_delegate && [_delegate respondsToSelector:@selector(settingConfirm)]) {
        [_delegate settingConfirm];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        CGPoint pos = [touch locationInView:self.contentView.superview];
        if (CGRectContainsPoint(self.contentView.frame, pos)) {
            return NO;
        }
    }
    return YES;
}
#pragma mark - 初始化
- (NSMutableArray *)selectedButtons
{
    if (!_selectedButtons) {
        _selectedButtons = [NSMutableArray array];
    }
    return _selectedButtons;
}
- (NSDictionary *)settingDic
{
    if (!_settingDic) {
        _settingDic = [NSDictionary dictionary];
        _settingDic = @{
                      @"期数":@[@"近30期",@"近50期",@"近100期",@"近200期"],
                      @"排列":@[@"顺序排列",@"倒序排列"],
                      @"折线":@[@"显示折线",@"隐藏折线"],
                      @"遗漏":@[@"显示遗漏",@"隐藏遗漏"],
                      @"统计":@[@"显示统计",@"隐藏统计"],
                      };
    }
    return _settingDic;
}
@end
