//
//  YZQuickUnionBuyView.m
//  ez
//
//  Created by 毛文豪 on 2019/6/5.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZQuickUnionBuyView.h"
#import "YZUnionBuyDetailViewController.h"
#import "YZCircleChart.h"

@interface YZQuickUnionBuyView ()

@property (nonatomic, weak) UIView * contentView;
@property (nonatomic, weak) YZCircleChart *circleChart;
@property (nonatomic, weak)  UILabel *gameNameLabel;
@property (nonatomic, weak)  UILabel *userNameLabel;
@property (nonatomic,weak) UILabel *gradeLabel;
@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UIView *separator;
@property (nonatomic, strong) NSMutableArray *labels;

@end

@implementation YZQuickUnionBuyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZBackgroundColor;
        [self setupChilds];
    }
    return self;
}

#pragma mark - 布局试图
- (void)setupChilds
{
    //内容视图
    UIView * contentView = [[UIView alloc] initWithFrame:CGRectMake(8, 10, screenWidth - 2 * 8, 105)];
    self.contentView = contentView;
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 5;
    contentView.layer.borderColor = YZGrayLineColor.CGColor;
    contentView.layer.borderWidth = 0.5;
    [self addSubview:contentView];
    
    //游戏名称
    UILabel *gameNameLabel = [[UILabel alloc] init];
    self.gameNameLabel = gameNameLabel;
    gameNameLabel.font = bigFont;
    gameNameLabel.textColor = YZBlackTextColor;
    gameNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:gameNameLabel];
    
    //头像
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unionBuy_person"]];
    self.icon = icon;
    [self.contentView addSubview:icon];
    
    //玩家名称
    UILabel *userNameLabel = [[UILabel alloc] init];
    self.userNameLabel = userNameLabel;
    userNameLabel.font = smallFont;
    userNameLabel.textColor = YZBlackTextColor;
    [self.contentView addSubview:userNameLabel];
    
    //等级
    UILabel *gradeLabel = [[UILabel alloc] init];
    self.gradeLabel = gradeLabel;
    gradeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(20)];
    gradeLabel.textColor = YZBlackTextColor;
    [self.contentView addSubview:gradeLabel];
    
    //灰色分割线
    UIView *separator = [[UIView alloc] init];
    self.separator = separator;
    [self.contentView addSubview:separator];
    
    //圆饼图
    YZCircleChart *circleChart = [[YZCircleChart alloc] init];
    circleChart.bounds = CGRectMake(0, 0, circleChartWH, circleChartWH);
    self.circleChart = circleChart;
    [self.contentView addSubview:circleChart];
    
    //总金额、每份、剩余
    NSArray *titles = @[@"总金额",@"每份",@"剩余"];
    for(NSUInteger i = 0;i < 6;i ++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = smallFont;
        label.textColor = YZBlackTextColor;
        if(i < 3)
        {
            label.textColor = YZGrayTextColor;
            label.text = titles[i];
        }
        [self.labels addObject:label];
        [self.contentView addSubview:label];
    }
    
    YZBottomButton *quickPayBtn = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    CGFloat quickPayBtnW = 65;
    CGFloat quickPayBtnH = 30;
    CGFloat quickPayBtnX = self.contentView.width - quickPayBtnW - 5 * 2;
    CGFloat quickPayBtnY = (self.contentView.height - quickPayBtnH) / 2;
    quickPayBtn.frame = CGRectMake(quickPayBtnX, quickPayBtnY, quickPayBtnW, quickPayBtnH);
    [quickPayBtn setTitle:@"我要跟单" forState:UIControlStateNormal];
    quickPayBtn.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [quickPayBtn addTarget:self action:@selector(quickPayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:quickPayBtn];
    
}

- (void)quickPayBtnClick
{
    YZUnionBuyStatus *status = self.statusFrame.status;
    YZUnionBuyDetailViewController *detailVc = [[YZUnionBuyDetailViewController alloc] initWithUnionBuyPlanId:status.unionBuyPlanId gameId:status.gameId];
    detailVc.title = @"合买详情";
    [self.viewController.navigationController pushViewController:detailVc animated:YES];
}

#pragma mark - 设置数据
-(void)setStatusFrame:(YZUnionBuyStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    [self setupStatus];//设置数据
    
    [self setupFrame];//设置frame
}
- (void)setupStatus
{
    YZUnionBuyStatus *status = _statusFrame.status;
    self.gameNameLabel.text = status.gameName;
    self.userNameLabel.text = status.userName;
    self.circleChart.selfBuyRatio = status.schedule;
    self.circleChart.guaranteeRatio = @([status.deposit floatValue] / [status.totalAmount floatValue]);
    [self.circleChart strokeChart];
    
    NSArray *titles = @[status.totalAmount,status.singleMoney,status.surplusMoney];
    for(NSUInteger i = 3;i < 6;i ++)
    {
        UILabel *label = self.labels[i];
        label.text = [NSString stringWithFormat:@"%ld元",[titles[i - 3] integerValue] / 100];
    }
    self.gradeLabel.attributedText = [self getAttStrByGrade:_statusFrame.status.grade];
}

- (void)setupFrame
{
    self.gameNameLabel.frame = _statusFrame.gameNameFrame;
    self.icon.frame = _statusFrame.iconFrame;
    self.icon.center = CGPointMake(self.icon.center.x, self.gameNameLabel.center.y);
    self.userNameLabel.frame = _statusFrame.userNameFrame;
    self.userNameLabel.center = CGPointMake(self.userNameLabel.center.x, self.gameNameLabel.center.y);
    self.separator.frame = _statusFrame.seperatorFrame;
    self.circleChart.frame = _statusFrame.circleChartFrame;
    
    //6个label的frame
    NSUInteger maxColums = 3;
    CGFloat seperatorX = _statusFrame.seperatorFrame.origin.x;
    CGFloat seperatorY = CGRectGetMaxY(_statusFrame.seperatorFrame);
    CGFloat labelW = (self.contentView.width - seperatorX - 50) / maxColums;
    CGFloat labelH = [[_statusFrame.status.totalAmount stringValue] sizeWithFont:smallFont maxSize:CGSizeMake(screenWidth, CGFLOAT_MAX)].height;
    CGFloat labelVerticalpadding = (CGRectGetHeight(_statusFrame.circleChartFrame) - 2 * labelH) / 3;
    for(NSUInteger i = 0;i < 6;i ++)
    {
        UILabel *label = self.labels[i];
        CGFloat labelX = seperatorX + (i % maxColums) * labelW;
        CGFloat labelY =  seperatorY + labelVerticalpadding + (i / maxColums) * (labelH + labelVerticalpadding);
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
    }
    
    self.gradeLabel.frame = CGRectMake(CGRectGetMaxX(self.userNameLabel.frame) + 4, self.userNameLabel.y, screenWidth - (CGRectGetMaxX(self.userNameLabel.frame) + 4), self.userNameLabel.height);
}

- (NSAttributedString *)getAttStrByGrade:(NSNumber *)grade
{
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] init];
    NSString * gradeSystem8 = [YZTool transformNumber:[NSString stringWithFormat:@"%@", grade] withNumberSystem:@"8"];
    NSMutableArray *characters = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        [characters addObject:@"0"];
    }
    if (gradeSystem8.length >= 4) {
        NSString * character = [gradeSystem8 substringWithRange:NSMakeRange(0, gradeSystem8.length - 3)];
        characters[0] = character;
    }
    if (gradeSystem8.length >= 3) {
        NSString * character = [gradeSystem8 substringWithRange:NSMakeRange(gradeSystem8.length - 3, 1)];
        characters[1] = character;
    }
    if (gradeSystem8.length >= 2) {
        NSString * character = [gradeSystem8 substringWithRange:NSMakeRange(gradeSystem8.length - 2, 1)];
        characters[2] = character;
    }
    if (gradeSystem8.length >= 1) {
        NSString * character = [gradeSystem8 substringWithRange:NSMakeRange(gradeSystem8.length - 1, 1)];
        characters[3] = character;
    }
    
    for (int i = 0; i < characters.count; i++) {
        if ([characters[i] intValue] > 0) {
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc]initWithData:nil ofType:nil];
            textAttachment.bounds = CGRectMake(0, 0, 16, 11);
            textAttachment.image = [UIImage imageNamed:[NSString stringWithFormat:@"unionBuy_gold_grade%d", i + 1]];
            NSAttributedString *textAttachmentString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [attStr appendAttributedString:textAttachmentString];
            
            NSAttributedString * textAttStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ", characters[i]]];
            [attStr appendAttributedString:textAttStr];
        }
    }
    
    return attStr;
}

#pragma mark - 初始化
- (NSMutableArray *)labels
{
    if(_labels == nil)
    {
        _labels = [NSMutableArray array];
    }
    return  _labels;
}


@end
