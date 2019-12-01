//
//  YZFBTimeChooseView.m
//  ez
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 9ge. All rights reserved.
//

#define btnH 33

#import "YZFBTimeChooseView.h"

@interface YZFBTimeChooseView ()

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *dates;
@property (nonatomic, weak) UIButton *selDateBtn;
@property (nonatomic, copy) NSString *dateStr;

@end

@implementation YZFBTimeChooseView

- (instancetype)initWithDateStr:(NSString *)dateStr
{
    self = [super init];
    if (self) {
        self.dateStr = dateStr;
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    self.frame = [UIScreen mainScreen].bounds;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self addGestureRecognizer:tap];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(screenWidth - 100, statusBarH + navBarH, 100, 0)];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 2;
    contentView.layer.borderColor = YZGrayLineColor.CGColor;
    contentView.layer.borderWidth = 0.8;
    
    //日期按钮
    for (NSString * date in self.dates) {
        NSInteger index = [self.dates indexOfObject:date];
        //按钮
        UIButton * dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dateBtn.tag = index;
        dateBtn.frame = CGRectMake(0, index * btnH, contentView.width, btnH);
        dateBtn.backgroundColor = [UIColor whiteColor];
        [dateBtn setTitle:self.dates[index] forState:UIControlStateNormal];
        [dateBtn setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        [dateBtn setTitleColor:YZBaseColor forState:UIControlStateSelected];
        [dateBtn setTitleColor:YZBaseColor forState:UIControlStateHighlighted];
        dateBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
        [dateBtn addTarget:self action:@selector(dateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:dateBtn];
        //分割线
        if (index != 0) {
            UIView * line =[[UIView alloc]initWithFrame:CGRectMake(10, index * btnH, contentView.width - 20, 0.8)];
            line.backgroundColor = YZGrayLineColor;
            [contentView addSubview:line];
        }
        if ([self.dateStr isEqualToString:dateBtn.currentTitle]) {
            dateBtn.selected = YES;
            self.selDateBtn = dateBtn;
        }else
        {
            dateBtn.selected = NO;
        }
    }
}
- (void)dateBtnClick:(UIButton *)button
{
    if (button == self.selDateBtn) {
        return;
    }
    button.selected = YES;
    self.selDateBtn.selected = NO;
    self.selDateBtn = button;
    
    if (self.block) {
        self.block(button.currentTitle);
    }
    [self hide];
}
- (void)show
{
    UIView *topView = [KEY_WINDOW.subviews firstObject];
    [topView addSubview:self];
    
    [UIView animateWithDuration:animateDuration
                     animations:^{
                         self.contentView.frame = CGRectMake(self.contentView.x, self.contentView.y, self.contentView.width, self.dates.count * btnH);
                     }];
}
- (void)hide
{
    [UIView animateWithDuration:animateDuration
                     animations:^{
                         self.contentView.frame = CGRectMake(self.contentView.x, self.contentView.y, self.contentView.width, 0);
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}
#pragma mark - 初始化
- (NSMutableArray *)dates
{
    if (_dates == nil) {
        _dates = [NSMutableArray array];
        NSDate *nowDate = [NSDate date];//当前时间
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];//显示格式
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        dateFormatter.timeZone = [NSTimeZone localTimeZone];
        for (int i = 0; i < 10; i++) {
            NSInteger aInterval = 24 * 60 * 60;//一天
            NSDate * aDate = [nowDate dateByAddingTimeInterval:-(aInterval * i)];
            NSString * dateStr = [dateFormatter stringFromDate:aDate];
            [_dates addObject:dateStr];
        }
        [_dates insertObject:@"近期比赛" atIndex:0];
    }
    return _dates;
}

@end
