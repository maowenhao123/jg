//
//  YZWinNumberStatusFrame.m
//  ez
//
//  Created by apple on 16/9/7.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZWinNumberStatusFrame.h"

@implementation YZWinNumberStatusFrame

-(void)setStatus:(YZWinNumberStatus *)status
{
    _status = status;
    
    _bgImageViewF = CGRectMake(YZMargin, 5, screenWidth - 2 * YZMargin, 70);
    //设置彩票图片的frame
    CGFloat imageX = YZMargin;
    CGFloat imageY = (70 - 39) / 2;
    CGFloat imageW = 39;
    CGFloat imageH = 39;
    _imageF = CGRectMake(imageX, imageY, imageW, imageH);
    
    //设置彩票名字的frame
    CGFloat nameX = (status.lotteryImage ? CGRectGetMaxX(_imageF) : 0) + YZMargin;
    CGFloat nameY = 10;
    CGSize nameSize = [status.lotteryName sizeWithLabelFont:YZLotteryNameFont];
    CGFloat nameW = nameSize.width;
    _nameF = CGRectMake(nameX, nameY, nameW, 20);
    
    //设置彩票期数的frame
    CGFloat periodX = CGRectGetMaxX(_nameF) + 10;
    CGSize periodSize = [status.lotteryPeriod sizeWithLabelFont:YZLotteryPeriodFont];
    CGFloat periodW = periodSize.width;
    CGFloat periodY = nameY;
    _periodF = CGRectMake(periodX, periodY, periodW, 20);
    
    //设置开奖时间的frame
    CGSize timeSize = [status.lotteryTime sizeWithLabelFont:YZLotteryTimeFont];
    CGFloat timeW = timeSize.width;
    CGFloat timeX = CGRectGetMaxX(_periodF) + 5;
    CGFloat timeY = nameY;
    _timeF = CGRectMake(timeX, timeY, timeW, 20);
    
    //设置查看比赛结果的frame
    CGFloat detailX = nameX;
    CGFloat detailY = CGRectGetMaxY(_nameF) + 5;
    CGSize detailSize = [@"查看比赛结果" sizeWithLabelFont:YZLotteryDetailFont];
    CGFloat detailW = detailSize.width;
    _detailF = CGRectMake(detailX, detailY, detailW + 100, 25);
    
    //设置开奖号码frame
    CGFloat numberViewX = nameX;
    CGFloat numberViewY = CGRectGetMaxY(_nameF) + 5;
    CGFloat numberViewW = screenWidth - nameX - 20;
    CGFloat numberViewH = 20;
    _numberViewF = CGRectMake(numberViewX, numberViewY, numberViewW, numberViewH);

    CGFloat accessoryW = 8;
    CGFloat accessoryH = 11;
    _accessoryF = CGRectMake(screenWidth - YZMargin - accessoryW, (70 - accessoryH) / 2, accessoryW, accessoryH);
    
    _cellH = CGRectGetMaxY(_detailF) + 5;
    
}


@end
