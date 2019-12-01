//
//  YZWinNumberTableViewCell.m
//  ez
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZWinNumberTableViewCell.h"
#import "YZWinNumberBall.h"

@interface YZWinNumberTableViewCell ()

@property (nonatomic, weak) UIImageView *bgImageView;
@property (nonatomic, weak) UIImageView *lotteryImageView;
@property (nonatomic, weak) UILabel *lotteryNameLabel;
@property (nonatomic, weak) UILabel *lotteryPeriodLabel;
@property (nonatomic, weak) UILabel *lotteryTimeLabel;
@property (nonatomic, weak) UILabel *lotteryDetailLabel;
@property (nonatomic, weak) UIView *lotteryNumberView;
@property (nonatomic, weak) UIImageView * accessory;

@end

@implementation YZWinNumberTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"WinNumberCell";
    YZWinNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZWinNumberTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
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
    //1.彩票图片
    UIImageView *lotteryImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:lotteryImageView];
    self.lotteryImageView = lotteryImageView;
    
    //2彩票名字
    UILabel *lotteryNameLabel = [[UILabel alloc] init];
    lotteryNameLabel.textColor = YZBlackTextColor;
    lotteryNameLabel.font = YZLotteryNameFont;
    [self.contentView addSubview:lotteryNameLabel];
    self.lotteryNameLabel = lotteryNameLabel;
    
    //3开奖期数
    UILabel *lotteryPeriodLabel = [[UILabel alloc] init];
    lotteryPeriodLabel.textColor = YZColor(134, 134, 134, 1);
    lotteryPeriodLabel.font = YZLotteryPeriodFont;
    [self.contentView addSubview:lotteryPeriodLabel];
    self.lotteryPeriodLabel = lotteryPeriodLabel;
    
    //4开奖时间
    UILabel *lotteryTimeLabel = [[UILabel alloc] init];
    lotteryTimeLabel.textColor = YZColor(134, 134, 134, 1);
    lotteryTimeLabel.font = YZLotteryTimeFont;
    [self.contentView addSubview:lotteryTimeLabel];
    self.lotteryTimeLabel = lotteryTimeLabel;
    
    //5查看开奖信息
    UILabel *lotteryDetailLabel = [[UILabel alloc] init];
    lotteryDetailLabel.font = YZLotteryDetailFont;
    lotteryDetailLabel.textColor = YZColor(134, 134, 134, 1);
    [self.contentView addSubview:lotteryDetailLabel];
    self.lotteryDetailLabel = lotteryDetailLabel;
    
    //开奖号码
    UIView * lotteryNumberView = [[UIView alloc]init];
    self.lotteryNumberView = lotteryNumberView;
    [self.contentView addSubview:lotteryNumberView];
    
    for (int i = 0; i < 14; i++) {
        YZWinNumberBall * winNumberBall = [[YZWinNumberBall alloc]init];
        [lotteryNumberView addSubview:winNumberBall];
    }
    
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(YZMargin, 0, screenWidth - YZMargin, 1)];
    self.line = line;
    line.backgroundColor = YZWhiteLineColor;
    [self addSubview:line];
    
    //accessory
    UIImageView * accessory = [[UIImageView alloc]init];
    accessory.image = [UIImage imageNamed:@"accessory_dray"];
    [self addSubview:accessory];
    self.accessory = accessory;
}
- (void)setStatusFrame:(YZWinNumberStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    //设置数据
    [self settingData];
    
    //设置frame
    [self settingFrame];

    if ([_statusFrame.status.gameId isEqualToString:@"T51"] || [_statusFrame.status.gameId isEqualToString:@"T52"]) {//竞彩足球没有号码球 名称下移
        self.lotteryDetailLabel.hidden = NO;
        self.lotteryNumberView.hidden = YES;
        self.lotteryNameLabel.y = 15;
    }else
    {
        self.lotteryDetailLabel.hidden = YES;
        self.lotteryNumberView.hidden = NO;
        self.lotteryNameLabel.y = 10;
    }
}
#pragma  mark - 设置frame
- (void)settingFrame
{
    //设置彩票图片frame
    self.lotteryImageView.frame = self.statusFrame.imageF;
    
    //设置名字frame
    self.lotteryNameLabel.frame = self.statusFrame.nameF;
    
    //设置开奖期数frame
    self.lotteryPeriodLabel.frame = self.statusFrame.periodF;
    
    //设置开奖时间frame
    self.lotteryTimeLabel.frame = self.statusFrame.timeF;
    
    //设置开奖号码frame
    self.lotteryNumberView.frame  = self.statusFrame.numberViewF;
    
    //查看比赛结果
    self.lotteryDetailLabel.frame = self.statusFrame.detailF;
    
    self.accessory.frame = self.statusFrame.accessoryF;
}
#pragma  mark - 设置数据
- (void)settingData
{
    //设置显示的数据
    YZWinNumberStatus *status = self.statusFrame.status;
    if (status.lotteryImage) {//有图片时
        self.lotteryImageView.image = [UIImage imageNamed:status.lotteryImage];
    }
    self.lotteryNameLabel.text = status.lotteryName;
    self.lotteryPeriodLabel.text = status.lotteryPeriod;
    self.lotteryTimeLabel.text = status.lotteryTime;
    if ([status.gameId isEqualToString:@"T51"] || [status.gameId isEqualToString:@"T52"]) {
        self.lotteryDetailLabel.text = @"查看比赛结果";
    }else
    {
        for (UIView * ball in self.lotteryNumberView.subviews) {
            if ([ball isKindOfClass:[YZWinNumberBall class]]) {
                ball.hidden = YES;
            }
        }
        
        //设置数据
        for (YZWinNumberBallStatus * winNumberBallStatus in status.lotteryNumberInfos) {
            NSInteger index = [status.lotteryNumberInfos indexOfObject:winNumberBallStatus];
            YZWinNumberBall * winNumberBall = self.lotteryNumberView.subviews[index];
            winNumberBall.hidden = NO;
            if ([status.gameId isEqualToString:@"T53"]) {
                winNumberBall.frame = CGRectMake(16 * index, 0, 15, 25);
            }else
            {
                winNumberBall.frame = CGRectMake(26 * index, 0, 25, 25);
            }
            winNumberBall.status = winNumberBallStatus;
        }
    }
}

@end
