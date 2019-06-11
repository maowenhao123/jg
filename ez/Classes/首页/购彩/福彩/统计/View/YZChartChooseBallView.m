//
//  YZChartChooseBallView.m
//  ez
//
//  Created by apple on 17/3/6.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZChartChooseBallView.h"

@interface YZChartChooseBallView ()<UIScrollViewDelegate,YZChartBallViewDelegate>

@property (nonatomic, weak) UILabel *label;
@property (nonatomic, strong) NSMutableArray *ballViews;

@end

@implementation YZChartChooseBallView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupChilds];
        //阴影
        self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shadowOpacity = 1;
    }
    return self;
}
#pragma mark - 布局子视图
- (void)setupChilds
{
    int maxBall = 11;//显示球数
    CGFloat labelWScale = 2;//选号label与ball的比例
    CGFloat ballW = self.width / (maxBall + labelWScale);
    CGFloat labelW = ballW * labelWScale;
    
    //选号
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelW, self.height)];
    self.label = label;
    label.text = @"选号";
    label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    label.textColor = YZBlackTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    //滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(labelW, 0, self.width, self.height)];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    [self addSubview:scrollView];
    
    CGFloat padding = 1;
    CGFloat ballViewWH = ballW - 2 * padding;
    CGFloat ballViewY = (self.height - ballViewWH) / 2;
    UIView * lastView;
    for (int i = 0; i < 50; i++) {
        YZChartBallView * ballView = [[YZChartBallView alloc] initWithFrame:CGRectMake(ballW * i + padding, ballViewY, ballViewWH, ballViewWH)];
        ballView.tag = i;
        ballView.hidden = YES;
        ballView.delegate = self;
        [self.scrollView addSubview:ballView];
        [self.ballViews addObject:ballView];
        lastView = ballView;
    }
}
- (void)ballDidClick:(YZChartBallView *)ballView
{
    if (_delegate && [_delegate respondsToSelector:@selector(ballDidClick:)]) {
        [_delegate ballDidClick:ballView];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_delegate && [_delegate respondsToSelector:@selector(ballViewDidScroll:)]) {
        [_delegate ballViewDidScroll:scrollView.mj_offsetX];
    }
}
#pragma mark - 设置数据
- (void)setBallStatuss:(NSMutableArray *)ballStatuss
{
    _ballStatuss = ballStatuss;

    for (int i = 0; i < self.ballViews.count; i++) {
        YZChartBallView * ballView = self.ballViews[i];
        ballView.hidden = YES;
    }
    for (int i = 0; i < _ballStatuss.count; i++) {
        YZChartBallStatus * ballStatus = _ballStatuss[i];
        YZChartBallView * ballView = self.ballViews[i];
        ballView.hidden = NO;
        ballView.status = ballStatus;
    }
    
    //调整contentSize
    CGFloat ballW = self.width / 14;
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(self.label.frame) + ballW * _ballStatuss.count, self.height);
}
#pragma mark - 初始化
- (NSMutableArray *)ballViews
{
    if (!_ballViews) {
        _ballViews = [NSMutableArray array];
    }
    return _ballViews;
}
@end
