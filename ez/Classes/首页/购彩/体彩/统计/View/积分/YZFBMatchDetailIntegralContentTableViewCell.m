//
//  YZFBMatchDetailIntegralContentTableViewCell.m
//  ez
//
//  Created by apple on 17/2/7.
//  Copyright © 2017年 9ge. All rights reserved.
//
#define padding 10
#define cellH 35

#import "YZFBMatchDetailIntegralContentTableViewCell.h"

@interface YZFBMatchDetailIntegralContentTableViewCell ()

@property (nonatomic, strong) NSMutableArray *contentLabels;

@end

@implementation YZFBMatchDetailIntegralContentTableViewCell

+ (YZFBMatchDetailIntegralContentTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FBMatchDetailIntegralContentTableViewCell";
    YZFBMatchDetailIntegralContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZFBMatchDetailIntegralContentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
    CGFloat width = screenWidth - 2 * padding;
    UILabel * lastLabel;
    for (int i = 0; i < 10; i++) {
        UILabel * contentLabel = [[UILabel alloc] init];
        if (i == 1) {
            contentLabel.frame = CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, width / 11 * 2, 35);
        }else
        {
            contentLabel.frame = CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, width / 11, 35);
        }

        contentLabel.font = [UIFont systemFontOfSize:10];
        contentLabel.textColor = YZBlackTextColor;
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
        [self.contentLabels addObject:contentLabel];
        lastLabel = contentLabel;
    }
    
    //分割线
    UIView * line_left = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, cellH)];
    line_left.backgroundColor = YZWhiteLineColor;
    [self addSubview:line_left];
    
    UIView * line_right = [[UIView alloc] initWithFrame:CGRectMake(width - 1, 0, 1, cellH)];
    line_right.backgroundColor = YZWhiteLineColor;
    [self addSubview:line_right];
    
    UIView * line_down = [[UIView alloc] initWithFrame:CGRectMake(0, cellH - 1, width, 1)];
    line_down.backgroundColor = YZWhiteLineColor;
    [self addSubview:line_down];
}

- (void)setIntegralStatus:(YZIntegralStatus *)integralStatus
{
    _integralStatus = integralStatus;
    //排名
    UILabel * label1 = self.contentLabels[0];
    label1.text = [NSString stringWithFormat:@"%d",_integralStatus.ranking];
    
    //球队
    UILabel * label2 = self.contentLabels[1];
    label2.text = [NSString stringWithFormat:@"%@",_integralStatus.teamName];
    
    //已赛
    UILabel * label3 = self.contentLabels[2];
    label3.text = [NSString stringWithFormat:@"%d",_integralStatus.finished];
    
    //胜
    UILabel * label4 = self.contentLabels[3];
    label4.text = [NSString stringWithFormat:@"%d",_integralStatus.win];
    
    //平
    UILabel * label5 = self.contentLabels[4];
    label5.text = [NSString stringWithFormat:@"%d",_integralStatus.draw];
    
    //负
    UILabel * label6 = self.contentLabels[5];
    label6.text = [NSString stringWithFormat:@"%d",_integralStatus.loss];
    
    //进
    UILabel * label7 = self.contentLabels[6];
    label7.text = [NSString stringWithFormat:@"%d",_integralStatus.goal];
    
    //失
    UILabel * label8 = self.contentLabels[7];
    label8.text = [NSString stringWithFormat:@"%d",_integralStatus.lossGoal];
    
    //净
    UILabel * label9 = self.contentLabels[8];
    label9.text = [NSString stringWithFormat:@"%d",_integralStatus.pureGoal];
    
    //积分
    UILabel * label10 = self.contentLabels[9];
    label10.text = [NSString stringWithFormat:@"%d",_integralStatus.score];
}
- (void)setTeamNames:(NSArray *)teamNames
{
    _teamNames = teamNames;
    self.backgroundColor = [UIColor whiteColor];//默认白色
    for (NSString * teamName in _teamNames) {
        if ([teamName isEqualToString:_integralStatus.teamName]) {
            self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        }
    }
}
#pragma mark - 初始化
- (NSMutableArray *)contentLabels
{
    if (!_contentLabels) {
        _contentLabels = [NSMutableArray array];
    }
    return _contentLabels;
}

@end
