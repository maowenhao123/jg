//
//  YZFBMatchDetailRecommendView.m
//  ez
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define padding 10
#define padding1 5
#define labelH 40

#import "YZFBMatchDetailRecommendView.h"
#import "UIButton+YZ.h"

@interface YZFBMatchDetailRecommendView ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) NSMutableArray *line1s;//竖直分割线数组
@property (nonatomic, strong) NSMutableArray *line2s;//水平分割线数组
@property (nonatomic, weak) UILabel * noDataLabel;

@end

@implementation YZFBMatchDetailRecommendView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZBackgroundColor;
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(padding, padding, self.width - 2 * padding, self.height - 2 * padding)];
    self.scrollView = scrollView;
    scrollView.delegate = self;
    scrollView.bounces = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    //暂无数据
    UILabel * noDataLabel = [[UILabel alloc] init];
    self.noDataLabel = noDataLabel;
    noDataLabel.text = @"暂无数据";
    noDataLabel.textColor = YZGrayTextColor;
    noDataLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    CGSize noDataLabelSzie = [noDataLabel.text sizeWithLabelFont:noDataLabel.font];
    CGFloat noDataLabelW = noDataLabelSzie.width;
    CGFloat noDataLabelH = noDataLabelSzie.height;
    CGFloat noDataLabelX = (scrollView.width - noDataLabelW) / 2;
    CGFloat noDataLabelY = 10;
    noDataLabel.frame = CGRectMake(noDataLabelX, noDataLabelY, noDataLabelW, noDataLabelH);
    [scrollView addSubview:noDataLabel];
    
    //表格
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, labelH * 6)];
    self.contentView = contentView;
    contentView.hidden = YES;
    contentView.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:contentView];
    
    //前九个label
    CGFloat labelW = scrollView.width / 3;
    for (int i = 0; i < 9; i++) {
        UILabel * label = [[UILabel alloc] init];
        CGFloat labelX = i % 3 * labelW;
        CGFloat labelY = i / 3 * labelH;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = YZBlackTextColor;
        label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        if (i == 0) {
            label.text = @"走势分析";
        }else if (i == 3)
        {
            label.text = @"近期走势";
        }else if (i == 6)
        {
            label.text = @"盘路走势";
        }
        [contentView addSubview:label];
        [self.labels addObject:label];
    }
    
    //后六个label
    for (int i = 0; i < 6; i++) {
        UILabel * label = [[UILabel alloc] init];
        CGFloat labelX = i % 2 * labelW;
        CGFloat labelY = i / 2 * labelH;
        label.frame = CGRectMake(labelX, labelY + labelH * 3, labelW, labelH);
        if (i % 2 == 1) {
            label.width = labelW * 2;
        }
        label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
         label.textColor = YZBlackTextColor;
        if (i == 0) {
            label.text = @"对战成绩";
        }else if (i == 2)
        {
            label.text = @"点评";
        }else if (i == 4)
        {
            label.text = @"信心指数";
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = YZMDGreenColor;
        }else if (i == 5)
        {
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = YZMDGreenColor;
        }
        if (i == 3) {
            label.textAlignment = NSTextAlignmentLeft;
            label.x += padding1;
            label.y += padding1;
            label.width -= 2 * padding1;
            label.height -= 2 * padding1;
        }else
        {
            label.textAlignment = NSTextAlignmentCenter;
        }
        label.numberOfLines = 0;
        [contentView addSubview:label];
        [self.labels addObject:label];
    }
    
    //竖直分割线
    for (int i = 0; i < 4; i++) {
        UIView * line1 = [[UIView alloc] init];
        line1.frame = CGRectMake(labelW * i, 0, 1, labelH * 6);
        if (i == 2) {
            line1.height = labelH * 3;
        }else if (i == 3)
        {
            line1.x -= 1;
        }
        line1.backgroundColor = YZWhiteLineColor;
        [contentView addSubview:line1];
        [self.line1s addObject:line1];
    }
    
    //水平分割线
    for (int i = 0; i < 7; i++) {
        UIView * line2 = [[UIView alloc] init];
        line2.frame = CGRectMake(0, labelH * i, scrollView.width, 1);
        line2.backgroundColor = YZWhiteLineColor;
        [contentView addSubview:line2];
        [self.line2s addObject:line2];
    }
}
#pragma mark - 设置数据
- (void)setRecommendRowStatus:(YZRecommendRowStatus *)recommendRowStatus
{
    _recommendRowStatus = recommendRowStatus;
    if (YZStringIsEmpty(_recommendRowStatus.home) && YZStringIsEmpty(_recommendRowStatus.away)) {//没有数据时
        self.contentView.hidden = YES;
        self.noDataLabel.hidden = NO;
        return;
    }
    self.contentView.hidden = NO;
    self.noDataLabel.hidden = YES;
    
    //主队名
    NSString * home = _recommendRowStatus.home;
    UILabel * label1 = self.labels[1];
    label1.text = home;
    
    //客队名
    NSString * away = _recommendRowStatus.away;
    UILabel * label2 = self.labels[2];
    label2.text = away;
    
    //主队近期走势
    NSString * homeRecent = _recommendRowStatus.homeRecent;
    UILabel * label4 = self.labels[4];
    label4.attributedText = [self getAttributedStringByString:homeRecent];
    
    //客队近期走势
    NSString * awayRecent = _recommendRowStatus.awayRecent;
    UILabel * label5 = self.labels[5];
    label5.attributedText = [self getAttributedStringByString:awayRecent];
    
    //主队盘路
    NSString * homePanlv = _recommendRowStatus.homePanlv;
    UILabel * label7 = self.labels[7];
    label7.attributedText = [self getAttributedStringByString:homePanlv];
    
    //客队盘路
    NSString * awayPanlv = _recommendRowStatus.awayPanlv;
    UILabel * label8 = self.labels[8];
    label8.attributedText = [self getAttributedStringByString:awayPanlv];
    
    //对战成绩
    int win = _recommendRowStatus.win;
    NSString * winStr = [NSString stringWithFormat:@"%d胜",win];
    int draw = _recommendRowStatus.draw;
    NSString * drawStr = [NSString stringWithFormat:@"%d平",draw];
    int lost = _recommendRowStatus.lost;
    NSString * lostStr = [NSString stringWithFormat:@"%d负",lost];
    NSString * recommendStr = [NSString stringWithFormat:@"%@ %@ %@",winStr,drawStr,lostStr];
    NSMutableAttributedString * recommendAttStr = [[NSMutableAttributedString alloc] initWithString:recommendStr];
    NSRange rang_win = [recommendStr rangeOfString:winStr];
    [recommendAttStr addAttribute:NSForegroundColorAttributeName value:YZMDRedColor range:rang_win];
    NSRange rang_draw = [recommendStr rangeOfString:drawStr];
    [recommendAttStr addAttribute:NSForegroundColorAttributeName value:YZMDBlueColor range:rang_draw];
    NSRange rang_lost = [recommendStr rangeOfString:lostStr];
    [recommendAttStr addAttribute:NSForegroundColorAttributeName value:YZMDGreenColor range:rang_lost];
    UILabel * label10 = self.labels[10];
    label10.attributedText = recommendAttStr;
    
    //点评
    NSString * evaluate = _recommendRowStatus.text;
    UILabel * label12 = self.labels[12];
    NSMutableAttributedString * evaluateAttStr = [[NSMutableAttributedString alloc] initWithString:evaluate];
    [evaluateAttStr addAttribute:NSFontAttributeName value:label12.font range:NSMakeRange(0, evaluateAttStr.length)];
    label12.attributedText = evaluateAttStr;
    
    //信心指数
    UILabel * label14 = self.labels[14];
    for (UIView * subView in label14.subviews) {
        [subView removeFromSuperview];
    }
    int confidence = _recommendRowStatus.confidence;
    UIButton * recommendStarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recommendStarBtn.frame = CGRectMake(0, 0, label14.width, label14.height);
    recommendStarBtn.userInteractionEnabled = NO;
    [recommendStarBtn setTitle:_recommendRowStatus.recommend forState:UIControlStateNormal];
    [recommendStarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    recommendStarBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [recommendStarBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"star%d",confidence]] forState:UIControlStateNormal];
    [recommendStarBtn setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentRight imgTextDistance:1];
    [label14 addSubview:recommendStarBtn];
    
    //调整大小
    CGSize evaluateSize = [label12.attributedText boundingRectWithSize:CGSizeMake(label12.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGFloat evaluateH = evaluateSize.height + padding1 * 2 > labelH ? evaluateSize.height + 2 * padding1 : labelH;
    if (evaluateH != labelH)
    {
        //设置frame
        for (int i = 11; i < 13; i++) {
            UILabel * label = self.labels[i];
            label.height = evaluateH;
            label.centerY = labelH * 4 + evaluateH / 2 + padding1;
        }
        for (int i = 13; i < 15; i++) {
            UILabel * label = self.labels[i];
            label.y = evaluateH + 2 * padding1 + 4 * labelH;
        }
        for (int i = 0; i < 4; i++) {
            if (i != 2) {
                UIView * line = self.line1s[i];
                line.height = evaluateH + 2 * padding1 + 5 * labelH;
            }
        }
        for (int i = 5; i < 7; i++) {
            UIView * line = self.line2s[i];
            line.y = 4 * labelH + evaluateH + 2 * padding1 + labelH * (i - 5);
        }
    }
    
    UILabel * lastLabel = self.labels.lastObject;
    self.contentView.frame = CGRectMake(0, 0, self.scrollView.width, CGRectGetMaxY(lastLabel.frame));
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, CGRectGetMaxY(lastLabel.frame));
}
//胜平负字符串转化成富文本
- (NSAttributedString *)getAttributedStringByString:(NSString *)string
{
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:string];
    for (int i = 0; i < string.length; i++) {
        NSRange range = NSMakeRange(i, 1);
        NSString * character = [string substringWithRange:range];
        if ([character isEqualToString:@"胜"])
        {//胜红色
            [attStr addAttribute:NSForegroundColorAttributeName value:YZMDRedColor range:range];
        }else if ([character isEqualToString:@"平"])
        {//平蓝色
            [attStr addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:range];
        }else if ([character isEqualToString:@"负"])
        {//负绿色
            [attStr addAttribute:NSForegroundColorAttributeName value:YZMDGreenColor range:range];
        }
    }
    return attStr;
}
#pragma mark - 初始化
- (NSMutableArray *)labels
{
    if (!_labels) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}
- (NSMutableArray *)line1s
{
    if (!_line1s) {
        _line1s = [NSMutableArray array];
    }
    return _line1s;
}
- (NSMutableArray *)line2s
{
    if (!_line2s) {
        _line2s = [NSMutableArray array];
    }
    return _line2s;
}
@end
