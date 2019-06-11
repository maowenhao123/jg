//
//  YZWinNumberFBTableViewCell.m
//  ez
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define YZYellowColor YZColor(255, 185, 84, 1)

#import "YZWinNumberFBTableViewCell.h"
#import "YZDateTool.h"

@interface YZWinNumberFBTableViewCell ()

@property (nonatomic, weak) UILabel *matchLabel;//比赛
@property (nonatomic, weak) UILabel *homeTeamLabel;//主队
@property (nonatomic, weak) UILabel *scroeLabel;//比分
@property (nonatomic, weak) UILabel *guestTeamLabel;//客队
@property (nonatomic, weak) UIView *amidithionView;//赛果视图
@property (nonatomic, strong) NSMutableArray *titleLabels;//比赛结果labels
@property (nonatomic, strong) NSMutableArray *labels;//比赛结果labels

@end

@implementation YZWinNumberFBTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"WinNumberFBCell";
    YZWinNumberFBTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZWinNumberFBTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChildViews];
    }
    return self;
}
- (void)setupChildViews
{
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [self addSubview:line];

    CGFloat labelW = screenWidth / 4;
    for (int i = 0; i < 4; i++) {
        UILabel * label = [[UILabel alloc]init];
        label.frame = CGRectMake(labelW * i, 0, labelW, 50);
        label.textColor = YZBlackTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
        label.numberOfLines = 0;
        [self addSubview:label];
        if (i == 0) {
            self.matchLabel = label;
        }else if (i == 1)
        {
            self.homeTeamLabel = label;
        }else if (i == 2)
        {
            self.scroeLabel = label;
        }else if (i == 3)
        {
            self.guestTeamLabel = label;
        }
    }

    //赛果
    UIView *amidithionView = [[UIView alloc]init];
    self.amidithionView = amidithionView;
    amidithionView.frame = CGRectMake(0, 50, screenWidth, 38);
    amidithionView.backgroundColor = YZBackgroundColor;
    [self addSubview:amidithionView];
    
    UIView * line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    line1.backgroundColor = YZWhiteLineColor;
    [amidithionView addSubview:line1];
    
    CGFloat amidithionLabelW = screenWidth / 4;
    
    //赛果视图的分割线
    for (int i = 1; i < 4; i++) {
        UIView * line0 = [[UIView alloc]initWithFrame:CGRectMake(i * amidithionLabelW, 4, 1, 30)];
        line0.backgroundColor = YZWhiteLineColor;
        [amidithionView addSubview:line0];
    }
    
    NSArray * playTypes = @[@"胜平负",@"让分胜平负",@"总进球",@"半全场"];
    CGFloat amidithionLabelH = 19;
    for (int i = 0; i < 8; i++) {
        UILabel * label = [[UILabel alloc]init];
        CGFloat labelX = amidithionLabelW * (i % 4);
        CGFloat labelY = amidithionLabelH * (i / 4);
        label.frame = CGRectMake(labelX, labelY, amidithionLabelW, amidithionLabelH);
        label.font = [UIFont systemFontOfSize:YZGetFontSize(20)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = YZBlackTextColor;
        if (i < 4) {
            label.text = playTypes[i];
            [self.titleLabels addObject:label];
        }else
        {
            label.textColor = YZYellowColor;
            [self.labels addObject:label];
        }
        [amidithionView addSubview:label];
    }
}
- (void)setStatus:(YZWinNumberFBStatus *)status
{
    _status = status;
    //编号
    NSMutableString * muStr = [NSMutableString string];
    NSString *week = [YZDateTool getWeekFromDateString:[_status.roundNum substringToIndex:8] format:@"yyyyMMdd"];
    week = [week stringByReplacingOccurrencesOfString:@"星期" withString:@"周"];
    [muStr appendString:week];
    [muStr appendString:[_status.roundNum substringWithRange:NSMakeRange(9, 3)]];//拼接出："周四001"格式
    [muStr appendFormat:@"\n%@",_status.league];
    NSString * time = [YZDateTool getTimeByTimestamp:_status.matchTime format:@"HH:mm"];
    [muStr appendFormat:@"\n%@",time];
    NSRange leagueRange = [muStr rangeOfString:_status.league];
    NSRange timeRange = [muStr rangeOfString:time];
    NSMutableAttributedString * muAttStr = [[NSMutableAttributedString alloc]initWithString:muStr];
    [muAttStr addAttribute:NSForegroundColorAttributeName value:YZYellowColor range:NSMakeRange(0, leagueRange.location)];//周和编号黄色
    [muAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(134, 134, 134, 1) range:timeRange];//时间灰色
    self.matchLabel.attributedText = muAttStr;
    //主队
    self.homeTeamLabel.text = _status.homeShort;
    
    //客队
    self.guestTeamLabel.text = _status.guestShort;

    //打开 关闭
    if (_status.open) {
        self.amidithionView.hidden = NO;
    }else
    {
        self.amidithionView.hidden = YES;
    }
    
    //详细赛果
    NSArray * playTypes = [NSArray array];
    if (self.isBasketBall) {
        playTypes = @[@"胜平负",@"让球胜平负",@"大小分",@"胜分差"];
    }else
    {
        playTypes = @[@"胜平负",@"让分胜平负",@"总进球",@"半全场"];
    }
    for (UILabel * label in self.titleLabels) {
        label.text = playTypes[[self.titleLabels indexOfObject:label]];
    }
    
    self.scroeLabel.text = @"";
    for (UILabel * label in self.labels) {//先清空
        label.text = @"-";
    }
    
    if (YZStringIsEmpty(_status.result)) return;
    
    NSArray * matchResults = [_status.result componentsSeparatedByString:@";"];
    NSString * rangfen;
    NSString * yuzongfen;
    for (NSString * matchResult in matchResults) {
        //总比分
        if ([matchResult containsString:@"F|"]) {
            self.scroeLabel.text = [matchResult stringByReplacingOccurrencesOfString:@"F|" withString:@""];
        }
        //让分
        if ([matchResult containsString:@"R|"]) {
            rangfen = [matchResult stringByReplacingOccurrencesOfString:@"R|" withString:@""];
        }
        //预计总分
        if ([matchResult containsString:@"Y|"]) {
            yuzongfen = [matchResult stringByReplacingOccurrencesOfString:@"Y|" withString:@""];
        }
    }
    
    for (NSString * matchResult in matchResults) {
        if (self.isBasketBall) {
            if ([matchResult rangeOfString:@"02|"].location != NSNotFound) {//胜平负
                UILabel * label = self.labels[0];
                NSArray *matchResults = [matchResult componentsSeparatedByString:@"|"];
                NSString * matchResultStr = matchResults.lastObject;
                NSString * text;
                if ([matchResultStr isEqualToString:@"1"]) {
                    text = @"主胜";
                }else if ([matchResultStr isEqualToString:@"2"])
                {
                    text = @"客胜";
                }
                label.text = text.length == 0 ? @"-" : text;
            }else if ([matchResult rangeOfString:@"01|"].location != NSNotFound)//让球胜平负
            {
                UILabel * label = self.labels[1];
                NSArray *matchResults = [matchResult componentsSeparatedByString:@"|"];
                NSString * matchResultStr = matchResults.lastObject;
                if ([matchResultStr isEqualToString:@"1"]) {
                    label.text = [NSString stringWithFormat:@"（%@）让分主胜", rangfen];
                }else if ([matchResultStr isEqualToString:@"2"])
                {
                    label.text = [NSString stringWithFormat:@"（%@）让分客胜", rangfen];
                }else
                {
                    label.text = @"-";
                }
            }else if ([matchResult rangeOfString:@"04|"].location != NSNotFound)//大小分
            {
                UILabel * label = self.labels[2];
                NSArray *matchResults = [matchResult componentsSeparatedByString:@"|"];
                NSString * matchResultStr = matchResults.lastObject;
                if ([matchResultStr isEqualToString:@"1"]) {
                    label.text = [NSString stringWithFormat:@"大（%@）", yuzongfen];
                }else if ([matchResultStr isEqualToString:@"2"])
                {
                    label.text = [NSString stringWithFormat:@"小（%@）", yuzongfen];
                }else
                {
                    label.text = @"-";
                }
            }else if ([matchResult rangeOfString:@"03|"].location != NSNotFound)//胜分差
            {
                UILabel * label = self.labels[3];
                NSArray *matchResults = [matchResult componentsSeparatedByString:@"|"];
                NSString * matchResultStr = matchResults.lastObject;
                NSString * text = [YZTool bBshengfenDic][matchResultStr];
                label.text = text.length == 0 ? @"-" : text;
            }
        }else
        {
            if ([matchResult rangeOfString:@"01|"].location != NSNotFound) {//让球
                UILabel * label = self.labels[1];
                NSArray *matchResults_01 = [matchResult componentsSeparatedByString:@"|"];
                NSString * matchResult_01 = matchResults_01.lastObject;
                matchResult_01 = [matchResult_01 stringByReplacingOccurrencesOfString:@"3" withString:@"胜"];
                matchResult_01 = [matchResult_01 stringByReplacingOccurrencesOfString:@"1" withString:@"平"];
                matchResult_01 = [matchResult_01 stringByReplacingOccurrencesOfString:@"0" withString:@"负"];
                NSRange range_rang1 = [_status.result rangeOfString:@"R|"];
                NSRange range_rang2 = [_status.result rangeOfString:@";H"];
                if (range_rang1.location != NSNotFound && range_rang2.location != NSNotFound) {
                    NSString *rang = [_status.result substringWithRange:NSMakeRange(range_rang1.location + range_rang1.length, range_rang2.location - range_rang1.location)];
                    NSString * text = [NSString stringWithFormat:@"(%d)%@",[rang intValue],matchResult_01];
                    label.text = text.length == 0 ? @"-" : text;
                }
            }else if ([matchResult rangeOfString:@"02|"].location != NSNotFound)//胜平负
            {
                UILabel * label = self.labels[0];
                NSArray *matchResults_02 = [matchResult componentsSeparatedByString:@"|"];
                NSString * matchResult_02 = matchResults_02.lastObject;
                matchResult_02 = [matchResult_02 stringByReplacingOccurrencesOfString:@"3" withString:@"胜"];
                matchResult_02 = [matchResult_02 stringByReplacingOccurrencesOfString:@"1" withString:@"平"];
                matchResult_02 = [matchResult_02 stringByReplacingOccurrencesOfString:@"0" withString:@"负"];
                label.text = matchResult_02.length == 0 ? @"-" : matchResult_02;
            }else if ([matchResult rangeOfString:@"04|"].location != NSNotFound)//进球数
            {
                UILabel * label = self.labels[2];
                NSArray *matchResults_04 = [matchResult componentsSeparatedByString:@"|"];
                NSString * text = matchResults_04.lastObject;
                label.text = text.length == 0 ? @"-" : text;
            }else if ([matchResult rangeOfString:@"05|"].location != NSNotFound)//半全场
            {
                UILabel * label = self.labels[3];
                NSArray *matchResults_05 = [matchResult componentsSeparatedByString:@"|"];
                NSString * matchResult_05 = matchResults_05.lastObject;
                matchResult_05 = [matchResult_05 stringByReplacingOccurrencesOfString:@"3" withString:@"胜"];
                matchResult_05 = [matchResult_05 stringByReplacingOccurrencesOfString:@"1" withString:@"平"];
                matchResult_05 = [matchResult_05 stringByReplacingOccurrencesOfString:@"0" withString:@"负"];
                label.text = matchResult_05.length == 0 ? @"-" : matchResult_05;
            }
        }
    }
}

- (NSMutableArray *)titleLabels
{
    if (_titleLabels == nil) {
        _titleLabels = [NSMutableArray array];
    }
    return _titleLabels;
}

- (NSMutableArray *)labels
{
    if (_labels == nil) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

@end
