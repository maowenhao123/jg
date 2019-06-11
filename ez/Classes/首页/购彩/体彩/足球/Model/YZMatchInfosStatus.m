//
//  YZMatchInfosStatus.m
//  ez
//
//  Created by apple on 14-11-20.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZMatchInfosStatus.h"
#import "YZFootBallMatchRate.h"

@implementation YZMatchInfosStatus
MJCodingImplementation
//清空
- (void)deleteAllSelBtn
{
    NSMutableArray * array1 = [NSMutableArray array];
    NSMutableArray * array2 = [NSMutableArray array];
    NSMutableArray * array3 = [NSMutableArray array];
    NSMutableArray * array4 = [NSMutableArray array];
    NSMutableArray * array5 = [NSMutableArray array];
    NSMutableArray * array6 = [NSMutableArray array];
    _selMatchArr = [NSMutableArray arrayWithObjects:array1,array2,array3,array4,array5,array6,nil];
}
//初始化
- (NSMutableArray *)selMatchArr
{
    if (_selMatchArr == nil) {
        NSMutableArray * array1 = [NSMutableArray array];//非让球
        NSMutableArray * array2 = [NSMutableArray array];//让球
        NSMutableArray * array3 = [NSMutableArray array];//二选一
        NSMutableArray * array4 = [NSMutableArray array];//半全场
        NSMutableArray * array5 = [NSMutableArray array];//比分
        NSMutableArray * array6 = [NSMutableArray array];//总进球
        _selMatchArr = [NSMutableArray arrayWithObjects:array1,array2,array3,array4,array5,array6,nil];
    }
    return _selMatchArr;
}
//是否有被选中的比赛
- (BOOL)isHaveSelected
{
    BOOL haveSelected = NO;
    for (NSArray * array in self.selMatchArr) {
        if (array.count > 0) {
            haveSelected = YES;
        }
    }
    return haveSelected;
}
- (BOOL)isHaveSelected1
{
    BOOL haveSelected = NO;
    for (int i = 0; i < self.selMatchArr.count; i++) {
        NSArray * array = self.selMatchArr[i];
        if (array.count > 0 && i > 2) {
            haveSelected = YES;
        }
    }
    return haveSelected;
}
- (BOOL)isCloseAllSingle
{
    BOOL isClose = YES;
    if (self.oddsMap.CN01.single || self.oddsMap.CN02.single|| self.oddsMap.CN03.single|| self.oddsMap.CN04.single|| self.oddsMap.CN05.single ) {
        isClose = NO;
    }
    return isClose;
}
//被选中比赛的场数
- (int)numberSelMatch
{
    int count = 0;
    for (NSArray * array in self.selMatchArr) {
        count += array.count;
    }
    return count;
}

- (CGFloat)cellH
{
    self.titleLabelFs = [NSMutableArray array];
    self.conetntLabelFs = [NSMutableArray array];
    self.titleLabelStrs = [NSMutableArray array];
    self.conetntLabelStrs = [NSMutableArray array];
    
    float concedePoints = [_concedePoints floatValue];
    NSString *concedePointsStr = [NSString stringWithFormat:@"%@", [YZTool formatFloat:concedePoints]];
    NSString * rangfenTitleStr = [NSString stringWithFormat:@"让分(%@)：", concedePointsStr];
    NSArray * titles = @[@"胜负：", rangfenTitleStr, @"大小分：", @"胜分差："];
    CGFloat titleLabelW = 0;
    for (NSString *title in titles) {
        NSInteger index = [titles indexOfObject:title];
        NSArray * selMatchArray = _selMatchArr[index];
        if (selMatchArray.count > 0) {
            CGSize titleLabelSize = [title sizeWithLabelFont:[UIFont systemFontOfSize:YZGetFontSize(24)]];
            titleLabelW = titleLabelW < titleLabelSize.width ? titleLabelSize.width : titleLabelW;
            [self.titleLabelStrs addObject:title];
        }else
        {
            [self.titleLabelStrs addObject:@""];
        }
    }
    CGFloat contentLabelW = screenWidth - 20 - 20 - 10 - titleLabelW - 5;
    
    CGFloat lastLabelMaxY = 13;
    for (int i = 0; i < 4; i++) {
        NSArray * selMatchArray = _selMatchArr[i];
        NSString * contentStr = [NSString string];
        for (int j = 0; j < selMatchArray.count; j++) {
            YZFootBallMatchRate *rate = selMatchArray[j];
            if (j % 2 == 1 && j != selMatchArray.count - 1) {
                contentStr = [contentStr stringByAppendingFormat:@"%@\n", rate.info];
            }else
            {
                contentStr = [contentStr stringByAppendingFormat:@"%@  ", rate.info];
            }
        }
        if (selMatchArray.count > 0) {
            [self.conetntLabelStrs addObject:contentStr];
            CGSize contentLabelSize = [contentStr sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(24)] maxSize:CGSizeMake(contentLabelW, MAXFLOAT)];
            CGRect titleLabelF = CGRectMake(10, lastLabelMaxY, titleLabelW, 15);
            [self.titleLabelFs addObject:[NSValue valueWithCGRect:titleLabelF]];
            CGRect contentLabelF = CGRectMake(titleLabelW + 5, lastLabelMaxY, contentLabelW, contentLabelSize.height);
            [self.conetntLabelFs addObject:[NSValue valueWithCGRect:contentLabelF]];
            lastLabelMaxY = CGRectGetMaxY(contentLabelF) + 8;
        }else
        {
            [self.conetntLabelStrs addObject:@""];
            [self.titleLabelFs addObject:[NSValue valueWithCGRect:CGRectZero]];
            [self.conetntLabelFs addObject:[NSValue valueWithCGRect:CGRectZero]];
        }
    }
    
    _cellH = lastLabelMaxY + 5;
    return _cellH;
}
#pragma mark - 初始化
- (NSMutableArray *)titleLabelStrs
{
    if (_titleLabelStrs == nil) {
        _titleLabelStrs = [NSMutableArray array];
    }
    return _titleLabelStrs;
}

- (NSMutableArray *)conetntLabelStrs
{
    if (_conetntLabelStrs == nil) {
        _conetntLabelStrs = [NSMutableArray array];
    }
    return _conetntLabelStrs;
}
- (NSMutableArray *)titleLabelFs
{
    if (_titleLabelFs == nil) {
        _titleLabelFs = [NSMutableArray array];
    }
    return _titleLabelFs;
}

- (NSMutableArray *)conetntLabelFs
{
    if (_conetntLabelFs == nil) {
        _conetntLabelFs = [NSMutableArray array];
    }
    return _conetntLabelFs;
}

@end
