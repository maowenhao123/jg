//
//  YZBasketBallTableViewCell2.m
//  ez
//
//  Created by 毛文豪 on 2018/5/28.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZBasketBallTableViewCell2.h"
#import "YZBasketBallAllPlayView.h"
#import "YZFootBallMatchRate.h"
#import "YZDateTool.h"

@interface YZBasketBallTableViewCell2()<YZBasketBallAllPlayViewDelegate>

@property (nonatomic, weak) UILabel *matchMessageLabel;
@property (nonatomic, weak) UILabel *teamNameLabel;
@property (nonatomic, weak) UIButton *rateButton;
@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) YZBasketBallAllPlayView *allPlayView;

@end

@implementation YZBasketBallTableViewCell2

+ (YZBasketBallTableViewCell2 *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZBasketBallTableViewCell2Id";
    YZBasketBallTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZBasketBallTableViewCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupChilds];
    }
    return self;
}
#pragma mark - 布局视图
- (void)setupChilds
{
    //比赛信息
    UILabel *matchMessageLabel = [[UILabel alloc] init];
    matchMessageLabel.numberOfLines = 0;
    self.matchMessageLabel = matchMessageLabel;
    matchMessageLabel.textColor = YZGrayTextColor;
    matchMessageLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    matchMessageLabel.textAlignment = NSTextAlignmentCenter;
    CGFloat matchMessageLabelW = 75;
    matchMessageLabel.frame = CGRectMake(0, 0, matchMessageLabelW, 90);
    [self addSubview:matchMessageLabel];
    
    //球队名称
    UILabel *teamNameLabel = [[UILabel alloc] init];
    self.teamNameLabel = teamNameLabel;
    teamNameLabel.textColor = YZBlackTextColor;
    teamNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    teamNameLabel.textAlignment = NSTextAlignmentCenter;
    teamNameLabel.frame = CGRectMake(matchMessageLabelW, 2, screenWidth - matchMessageLabelW, 33);
    [self addSubview:teamNameLabel];
    
    //赔率
    CGFloat rateButtonW = screenWidth - matchMessageLabelW - 5 - 15;
    CGFloat rateButtonH = 45;
    UIButton *rateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rateButton = rateButton;
    rateButton.frame = CGRectMake(matchMessageLabelW + 5, CGRectGetMaxY(teamNameLabel.frame), rateButtonW, rateButtonH);
    [rateButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    rateButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [rateButton setTitle:@"请选择输入内容" forState:UIControlStateNormal];
    rateButton.titleLabel.numberOfLines = 2;
    rateButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    rateButton.layer.borderWidth = 0.8;
    rateButton.layer.borderColor = YZWhiteLineColor.CGColor;
    [rateButton setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateSelected];
    [rateButton setBackgroundImage:[UIImage resizedImageWithName:@"playTypeBtnSelBg"] forState:UIControlStateHighlighted];
    [rateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [rateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [rateButton addTarget:self action:@selector(rateButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rateButton];
    
    //分割线
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, screenWidth, 9)];
    lineView.backgroundColor = YZBackgroundColor;
    [self addSubview:lineView];
}

- (void)rateButtonDidClick
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    self.backView = backView;
    backView.backgroundColor = YZColor(0, 0, 0, 0.4);
    [KEY_WINDOW addSubview:backView];
    
    YZBasketBallAllPlayView * allPlayView = [[YZBasketBallAllPlayView alloc]initWithFrame:CGRectMake(20, statusBarH, screenWidth - 40, screenHeight - statusBarH) matchInfosModel:_matchInfosModel onlyShowShengfen:YES];
    self.allPlayView = allPlayView;
    allPlayView.delegate = self;
    [backView addSubview:allPlayView];
    allPlayView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:animateDuration animations:^{
        allPlayView.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBackView)];
    tap.delegate = self;
    [backView addGestureRecognizer:tap];
}

- (void)removeBackView
{
    [self.backView removeFromSuperview];
}

- (void)upDateByMatchInfosModel:(YZMatchInfosStatus *)matchInfosModel
{
    self.matchInfosModel = matchInfosModel;
    //刷新底部的比赛数信息
    if ([_delegate respondsToSelector:@selector(reloadBottomMidLabelText)]) {
        [_delegate reloadBottomMidLabelText];
    }
}

#pragma mark - 设置数据
- (void)setMatchInfosModel:(YZMatchInfosStatus *)matchInfosModel
{
    _matchInfosModel = matchInfosModel;
    
    //比赛信息
    NSString *macthNum = [_matchInfosModel.code substringFromIndex:9];
    NSString * week = [YZDateTool getWeekFromDateString:_matchInfosModel.endTime format:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * timeDate = [YZDateTool getDateFromDateString:_matchInfosModel.endTime format:@"yyyy-MM-dd HH:mm:ss"];
    NSString * time = [YZDateTool getDateStringFromDate:timeDate format:@"HH:mm"];
    NSMutableAttributedString *matchMessageAttStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"篮球\n%@%@\n%@截至", week, macthNum, time]];
    [matchMessageAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(30)] range:NSMakeRange(0, 2)];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [matchMessageAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, matchMessageAttStr.length)];
    self.matchMessageLabel.attributedText = matchMessageAttStr;
    
    //设置VS双方
    NSArray *detailInfoArray = [_matchInfosModel.detailInfo componentsSeparatedByString:@"|"];
    self.teamNameLabel.text = [NSString stringWithFormat:@"%@（客）VS%@（主）", detailInfoArray[1], detailInfoArray[0]];
    
    NSArray * selMatchArr = _matchInfosModel.selMatchArr[3];
    if (selMatchArr.count == 0) {
        self.rateButton.selected = NO;
        [self.rateButton setTitle:@"请选择输入内容" forState:UIControlStateNormal];
    }else
    {
        self.rateButton.selected = YES;
        NSMutableString *selPlayRateStr = [NSMutableString string];
        for (YZFootBallMatchRate * rate in selMatchArr) {
            [selPlayRateStr appendFormat:@"%@,",rate.info];
        }
        [selPlayRateStr deleteCharactersInRange:NSMakeRange(selPlayRateStr.length-1, 1)];//去掉最后一个逗号;
        [self.rateButton setTitle:selPlayRateStr forState:UIControlStateSelected];
    }
}

#pragma mark - 手势协议
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        if (self.allPlayView) {
            CGPoint pos = [touch locationInView:self.allPlayView.superview];
            if (CGRectContainsPoint(self.allPlayView.frame, pos)) {
                return NO;
            }
        }
    }
    return YES;
}

@end
