//
//  YZSetmealNumberTableViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/7/11.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZSetmealNumberTableViewCell.h"
#import "YZWinNumberBall.h"

@interface YZSetmealNumberTableViewCell ()

@property (nonatomic, strong) NSMutableArray *winNumberBalls;

@end

@implementation YZSetmealNumberTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"SetmealNumberTableViewCellId";
    YZSetmealNumberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZSetmealNumberTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
    CGFloat ballWH = 33;
    for (int i = 0; i < 7; i++) {
        YZWinNumberBall * winNumberBall = [[YZWinNumberBall alloc]init];
        winNumberBall.frame = CGRectMake(10 + (ballWH + 7) * i, 10, ballWH, ballWH);
        [self.contentView addSubview:winNumberBall];
        [self.winNumberBalls addObject:winNumberBall];
    }
}

- (void)setNumberArray:(NSArray *)numberArray
{
    _numberArray = numberArray;
    
    for (YZWinNumberBallStatus * ballStatus in _numberArray) {
        NSInteger index = [_numberArray indexOfObject:ballStatus];
        YZWinNumberBall * winNumberBall = self.winNumberBalls[index];
        ballStatus.isRecommendLottery = NO;
        winNumberBall.status = ballStatus;
    }
}

#pragma mark - 初始化
- (NSMutableArray *)winNumberBalls
{
    if(_winNumberBalls == nil)
    {
        _winNumberBalls = [NSMutableArray array];
    }
    return _winNumberBalls;
}

@end
