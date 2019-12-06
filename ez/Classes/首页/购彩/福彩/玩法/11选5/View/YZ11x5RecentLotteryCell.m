//
//  YZ11x5RecentLotteryCell.m
//  ez
//
//  Created by apple on 14-11-17.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZ11x5RecentLotteryCell.h"

@interface YZ11x5RecentLotteryCell ()

@property (nonatomic, strong) NSMutableArray *btns;

@end

@implementation YZ11x5RecentLotteryCell

+ (YZ11x5RecentLotteryCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZ11x5RecentLotteryCellId";
    YZ11x5RecentLotteryCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZ11x5RecentLotteryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  cell;
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
- (void)setupChilds
{
    int btnCount = 12;
    CGFloat btn1W = screenWidth - (btnCount - 1) * btnWH;
    for(int i = 0;i < btnCount;i++)
    {
        UIButton *btn = [[UIButton alloc] init];
        [self.btns addObject:btn];
        btn.userInteractionEnabled = NO;
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 0.25;
        CGFloat btnX = 0;
        if(i == 0){
            btnX = 0;
            btn.frame = CGRectMake(btnX, 0, btn1W, btnWH);
        }else{
            btnX = btn1W + (i-1) * btnWH;
            btn.frame = CGRectMake(btnX, 0, btnWH, btnWH);
        }
        [self.contentView addSubview:btn];
    }
}

- (void)setStatus:(YZRecentLotteryStatus *)status
{
    _status = status;
    
    //设置期数
    NSString *termId = nil;
    if(_status.termId)
    {
        termId = [status.termId substringFromIndex:6];
    }else
    {
        termId = @"";
    }
    UIButton *btn =  self.btns[0];
    [btn setTitle:[NSString stringWithFormat:@"%@期",termId] forState:UIControlStateNormal];
    [btn setTitleColor:YZChartTitleColor forState:UIControlStateNormal];

    //设置号码球
    NSArray *ballArray = [_status.winNumber componentsSeparatedByString:@","];
    NSString *imageName = @"redBg";
    if(_cellTag)//是万千百的cell
    {
        NSArray *subArr = ballArray;
        if(_cellTag == KhistoryCellTagWan && _status.termId)
        {
            subArr = [ballArray subarrayWithRange:NSMakeRange(0, 1)];
        }else if(_cellTag == KhistoryCellTagQian && _status.termId)
        {
            subArr = [ballArray subarrayWithRange:NSMakeRange(1, 1)];
            imageName = @"greenBg";
        }else if(_cellTag == KhistoryCellTagBai && _status.termId)
        {
            subArr = [ballArray subarrayWithRange:NSMakeRange(2, 1)];
            imageName = @"blueBg";
        }
        [self setBallsWithBallsArray:subArr ballImageName:imageName];
    }else
    {
        [self setBallsWithBallsArray:ballArray ballImageName:imageName];
    }
}

- (void)setBallsWithBallsArray:(NSArray *)ballsArray ballImageName:(NSString *)imageName
{
    for(NSString *str in ballsArray)
    {
        UIButton *btn = self.btns[[str intValue]];
        [btn setTitle:[NSString stringWithFormat:@"%02d",[str intValue]] forState:UIControlStateNormal];
        if(_status.termId)
        {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }else
        {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:nil forState:UIControlStateNormal];
        }
    }
}

- (NSMutableArray *)btns
{
    if(_btns == nil)
    {
        _btns = [[NSMutableArray alloc] init];
    }
    return _btns;
}
@end
