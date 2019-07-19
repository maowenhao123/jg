//
//  YZUnionBuyFollowUserCellStatusFrame.m
//  ez
//
//  Created by apple on 15/3/23.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import "YZUnionBuyFollowUserCellStatusFrame.h"

@implementation YZUnionBuyFollowUserCellStatusFrame
- (void)setStatus:(YZUnionBuyStatus *)status
{
    _status = status;
    
    [self setupFrame];
}
- (void)setupFrame
{
    CGFloat padding = 8;
    //参与者label的frame
    CGFloat userNameX = YZMargin;
    CGFloat userNameY = 10;
    CGSize userNameSize = [self sizeWithFont:bigFont text:_status.userName];
    CGFloat userNameW = userNameSize.width;
    CGFloat userNameH = userNameSize.height;
    _userNameF = CGRectMake(userNameX, userNameY, userNameW, userNameH);
    
    //创建时间label的frame
    CGSize createTimeSize = [self sizeWithFont:smallFont text:_status.createTime];
    CGFloat createTimeW = createTimeSize.width;
    CGFloat createTimeH = createTimeSize.height;
    CGFloat createTimeX = screenWidth - createTimeW - YZMargin;
    CGFloat createTimeY = userNameY;
    _createTimeF = CGRectMake(createTimeX, createTimeY, createTimeW, createTimeH);
    
    //参与金额label的frame
    CGFloat moneyX = userNameX;
    CGFloat moneyY = CGRectGetMaxY(_userNameF) + padding;
    CGSize moneySize = [self sizeWithFont:smallFont text:_status.followMoney];
    CGFloat moneyW = moneySize.width;
    CGFloat moneyH = moneySize.height;
    _moneyF = CGRectMake(moneyX, moneyY, moneyW, moneyH);
    
    //占方案总金额label的frame
    CGSize moneyOfTotalSize = [self sizeWithFont:smallFont text:_status.moneyOfTotal];
    CGFloat moneyOfTotalW = moneyOfTotalSize.width;
    CGFloat moneyOfTotalH = moneyOfTotalSize.height;
    CGFloat moneyOfTotalX = screenWidth - moneyOfTotalW - YZMargin;
    CGFloat moneyOfTotalY = moneyY;
    _moneyOfTotalF = CGRectMake(moneyOfTotalX, moneyOfTotalY, moneyOfTotalW, moneyOfTotalH);
    
    _cellH = CGRectGetMaxY(_moneyOfTotalF) + 10;
}
- (CGSize)sizeWithFont:(UIFont *)font text:(NSString *)text
{
    CGSize size = [text sizeWithFont:font maxSize:CGSizeMake(screenWidth, CGFLOAT_MAX)];
    return size;
}
@end
