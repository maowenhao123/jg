//
//  YZFbBetCellStatus.m
//  ez
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 9ge. All rights reserved.
//  竞彩足球投注界面的cell的数据模型
#define btnsViewH 40
#import "YZFbBetCellStatus.h"
#import "YZFootBallMatchRate.h"

@implementation YZFbBetCellStatus
- (instancetype)init
{
    if(self = [super init])
    {
        _danBtnState = danBtnStateDisabled;
    }
    return  self;
}
- (void)setPlayType:(int)playType
{
    _playType = playType;
}
- (void)setMatchInfosStatus:(YZMatchInfosStatus *)matchInfosStatus
{
    _matchInfosStatus = matchInfosStatus;
    NSMutableArray * selMatchArray0 = matchInfosStatus.selMatchArr[0];//非让球
    NSMutableArray * selMatchArray1 = matchInfosStatus.selMatchArr[1];//让球
    NSMutableArray * selMatchArray2 = matchInfosStatus.selMatchArr[2];//二选一
    NSMutableArray * selMatchArray3 = matchInfosStatus.selMatchArr[3];//半全场
    NSMutableArray * selMatchArray4 = matchInfosStatus.selMatchArr[4];//比分
    NSMutableArray * selMatchArray5 = matchInfosStatus.selMatchArr[5];//总进球
    NSInteger lineNum = 0;//一共有几行
    
    NSInteger feirangNum = (selMatchArray0.count + 2) / 3;
    NSInteger rangNum = (selMatchArray1.count + 2) / 3;
    NSInteger erxuanyiNum = (selMatchArray2.count + 1) / 2;
    NSInteger banquanchangNum = (selMatchArray3.count + 2) / 3;
    NSInteger bifenNum = (selMatchArray4.count + 2) / 3;
    NSInteger zongjinqiuNum = (selMatchArray5.count + 2) / 3;
    lineNum = feirangNum + rangNum + erxuanyiNum + banquanchangNum + bifenNum + zongjinqiuNum;
    
    _feirangNum = feirangNum;
    _rangNum = rangNum;
    _erxuanyiNum = erxuanyiNum;
    _banquanchangNum = banquanchangNum;
    _bifenNum = bifenNum;
    _zongjinqiuNum = zongjinqiuNum;
    
    CGFloat padding = 2;
    _lineNum = lineNum;
    _btnsBgViewH = _lineNum * (btnsViewH + padding) + 5;
    _cellH = btnsBgViewYY + _lineNum * (btnsViewH + padding) + 5;
}
@end
