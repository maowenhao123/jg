//
//  YZFbasketBallTool.m
//  ez
//
//  Created by 毛文豪 on 2018/5/29.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZFbasketBallTool.h"
#import "YZMatchInfosStatus.h"
#import "YZPlayPassWay.h"
#import "YZFootBallMatchRate.h"
#import "YZMathTool.h"

@implementation YZFbasketBallTool

//自由过关
+ (NSMutableArray *)computeBetCountAndPrizeRangeWithBetArray:(NSMutableArray *)betArray playWays:(NSArray *)playWayArray selectedPlayType:(int)selectedPlayType
{
    int totalCount = 0;
    float totalMinPrize = 0;
    float totalMaxPrize = 0;
    if (selectedPlayType >= 5) {
        totalCount = [self computeSingleBetCountWithBetArray:betArray];
        totalMinPrize = [self calculatorSingleMinRate:betArray];
        totalMaxPrize = [self calculatorSingleMaxRate:betArray];
    }else
    {
        for(int i = 0;i < playWayArray.count; i++)
        {
            //注数
            YZPlayPassWay *playPassWay = playWayArray[i];
            NSMutableArray * betArr = [NSMutableArray array];
            NSMutableArray * newArr = [NSMutableArray array];
            if (betArray.count > playPassWay.index) {//如果多串过关需先拆分
                [self chaiBetArrayWithBetArray:betArray resultArray:betArr newArray:newArr playWay:playPassWay.index];
            }else
            {
                [betArr addObject:betArray];
            }
            float resultMinRate = 0;
            for (NSMutableArray * newBetArr in betArr) {
                //注数
                //复式转化成单式
                NSMutableArray * danShiArray = [self fuChangeDanBy:newBetArr];
                for (NSMutableArray * dataArray in danShiArray) {
                    //拆票
                    NSMutableArray *resultArray = [NSMutableArray array];
                    NSMutableArray *newArray = [NSMutableArray array];
                    [self chaiBetArrayWithBetArray:dataArray resultArray:resultArray newArray:newArray playWay:playPassWay.number];
                    
                    //注数(几串几,多个相加)
                    int temCount = 0;
                    temCount = [self computeBetCountWithChaiArray:resultArray];
                    totalCount += temCount;
                }
                
                //最大最小奖金
                //拆票
                NSMutableArray *resultArray = [NSMutableArray array];
                NSMutableArray *newArray = [NSMutableArray array];
                [self chaiBetArrayWithBetArray:newBetArr resultArray:resultArray newArray:newArray playWay:playPassWay.number];
                
                //每种过关方式的最小奖金
                float resultMinRate_ = [self calculatorMinRate:resultArray];
                //找出最小的
                if (resultMinRate_ != 0) {
                    if (resultMinRate == 0) {
                        resultMinRate = resultMinRate_;
                    }else
                    {
                        resultMinRate = resultMinRate > resultMinRate_ ? resultMinRate_ : resultMinRate;
                    }
                    
                }
                
                //最大奖金
                float resultMaxRate_ = [self calculatorMaxRate:resultArray];
                //相加
                totalMaxPrize += resultMaxRate_;
            }
            
            NSString * name;
            if (![name isEqualToString:playPassWay.name]) {//每种过关方式的最大赔率(几串几,多个相加
                //重复次数
                float repeatCount = (float)[YZMathTool getCountWithN:(int)(betArray.count - playPassWay.number) andM:(int)(playPassWay.index - playPassWay.number)];
                if (repeatCount == 0) {
                    repeatCount = 1;
                }
                totalMinPrize += resultMinRate * repeatCount;
                name = playPassWay.name;
                
            }
        }
    }
    NSMutableArray *muArr = [NSMutableArray arrayWithObjects:@(totalCount),@(totalMinPrize),@(totalMaxPrize), nil];
    return muArr;
}
/**
 @brif  投注结果
 @param resultArray 单式投注数组
 @param oldArray 需要的已经选择的原始数组
 @param newArray 辅助数组
 @param index 玩法 2串1 等
 */
//拆票算法
+ (void)chaiBetArrayWithBetArray:(NSArray *)betArray resultArray:(NSMutableArray *)resultArray newArray:(NSMutableArray *)newArray playWay:(int)index
{
    // 第一次调用此方法时,resultArray中元素个数为0
    if ([newArray count] == index)
    {
        [resultArray addObject:newArray];
        return; // 每一种过关方式计算完成后返回...
    }
    
    //递归函数
    for (int i = 0; i < [betArray count]; i++)  // 遍历所有已选比赛对象(arr_bettingCell)...
    {
        NSArray *mutableArr = [betArray subarrayWithRange:NSMakeRange(i+1, [betArray count]-i-1)];//第i个对象以后
        NSMutableArray *newMuArr = [[NSMutableArray alloc]initWithArray:newArray];
        [newMuArr addObject:[betArray objectAtIndex:i]];    // 首先加入当前比赛对象...
        [self chaiBetArrayWithBetArray:mutableArr resultArray:resultArray newArray:newMuArr playWay:index];
    }
}

//复式转化成单式
+ (NSMutableArray *)fuChangeDanBy:(NSMutableArray *)betArray
{
    NSMutableArray * danShiArray = [NSMutableArray array];
    //一共循环次数 要拆成的单式数
    int total = 1;
    NSMutableArray * dataArray = [NSMutableArray array];
    for (int i = 0; i < betArray.count; i++) {
        YZMatchInfosStatus *matchInfosModel = betArray[i];
        NSMutableArray * selMatchArray = matchInfosModel.selMatchArr;
        int count = 0;
        NSMutableArray * dataArr = [NSMutableArray array];
        for (int j = 0; j < selMatchArray.count; j++) {
            NSMutableArray * selMatchArr = selMatchArray[j];
            if (selMatchArr.count > 0) {//把有数据的玩法加起来
                count++;
                [dataArr addObject:selMatchArr];
            }
        }
        [dataArray addObject:dataArr];
        total *= count;
    }
    
    for (int i = 0; i < total; i++) {
        NSMutableArray * selMatchArray = [NSMutableArray array];
        int groupCount = 1; // 每个位置的元素多少个为一组
        for (int j = 0; j < dataArray.count; j++) {
            NSMutableArray * dataArr = dataArray[j];
            groupCount *= dataArr.count;
            long number = (i / (total / groupCount)) % dataArr.count;
            NSMutableArray * selMatchs = dataArr[number];
            //
            YZMatchInfosStatus * matchInfosModel = [[YZMatchInfosStatus alloc]init];
            NSMutableArray * selMatchArr = matchInfosModel.selMatchArr;
            for (YZFootBallMatchRate * rate in selMatchs) {
                if ([rate.CNType isEqualToString:@"CN01"]) {
                    [selMatchArr[1] addObject:rate];
                }else if ([rate.CNType isEqualToString:@"CN02"])
                {
                    [selMatchArr[0] addObject:rate];
                }else if ([rate.CNType isEqualToString:@"CN03"])
                {
                    [selMatchArr[3] addObject:rate];
                }else if ([rate.CNType isEqualToString:@"CN04"])
                {
                    [selMatchArr[2] addObject:rate];
                }
            }
            matchInfosModel.selMatchArr = selMatchArr;
            [selMatchArray addObject:matchInfosModel];
        }
        [danShiArray addObject:selMatchArray];
    }
    return danShiArray;
}

//算一个过关方式的注数
+ (int)computeBetCountWithChaiArray:(NSArray *)chaiArray
{
    int totalCount = 0;
    
    for (int i = 0; i < [chaiArray count]; i++)
    {
        int resultCount = 1;
        NSArray *array = [chaiArray objectAtIndex:i];
        
        for (YZMatchInfosStatus *matchInfosModel in array)
        {
            if ([matchInfosModel numberSelMatch] > 0)
            {
                resultCount *= [matchInfosModel numberSelMatch];
            }
            
        }
        totalCount +=resultCount;
    }
    
    return totalCount;
}

+ (int)computeSingleBetCountWithBetArray:(NSArray *)betArray
{
    int totalCount = 0;
    for (YZMatchInfosStatus *matchInfosModel in betArray)
    {
        totalCount += [matchInfosModel numberSelMatch];
    }
    return totalCount;
}

#pragma  mark -  计算奖金范围

//单关方式的最大奖金
+ (float)calculatorSingleMaxRate:(NSMutableArray *)betArray
{
    float resultMaxRate = 0;
    
    for (YZMatchInfosStatus *matchInfosModel in betArray)
    {
        float maxSum = 0;
        for (NSArray * selMatchArr in matchInfosModel.selMatchArr) {
            float max = 0;
            for (YZFootBallMatchRate * rate in selMatchArr) {
                max = max > [rate.value floatValue] ? max:[rate.value floatValue];
            }
            maxSum += max;
        }
        resultMaxRate += maxSum;
    }
    
    return resultMaxRate;
}

//单个过关方式的最大奖金
+ (float)calculatorMaxRate:(NSMutableArray *)resultArray
{
    float resultMaxRate = 0;
    
    for (int i = 0; i < [resultArray count]; i++)
    {
        NSArray *array = [resultArray objectAtIndex:i];
        float maxRate = 1;
        for (YZMatchInfosStatus *matchInfosModel in array)
        {
            float maxSum = 0;
            NSMutableArray * selMatchArray = matchInfosModel.selMatchArr;
            
            for (NSArray * selMatchArr in selMatchArray) {
                float max = 0;
                for (YZFootBallMatchRate * rate in selMatchArr) {
                    max = max > [rate.value floatValue] ? max:[rate.value floatValue];
                }
                maxSum += max;
            }
            maxRate *= maxSum;
        }
        resultMaxRate += maxRate;
    }
    
    return resultMaxRate;
}

//单关方式的最小奖金
+ (float)calculatorSingleMinRate:(NSMutableArray *)betArray
{
    float resultMinRate = 0;
    
    for (YZMatchInfosStatus *matchInfosModel in betArray)
    {
        float min = 0;
        for (NSArray * selMatchArr in matchInfosModel.selMatchArr) {
            for (YZFootBallMatchRate * rate in selMatchArr) {
                if (min == 0)
                {
                    min = [rate.value floatValue];
                }
                else{
                    min = min > [rate.value floatValue] ? [rate.value floatValue] : min;
                }
            }
        }
        if (resultMinRate == 0)
        {
            resultMinRate = min;
        }
        else
        {
            resultMinRate = resultMinRate > min ? min :resultMinRate;
        }
    }
    return resultMinRate;
}

//所有过关方式的最小奖金
+ (float)calculatorMinRate:(NSMutableArray *)resultArray
{
    float resultMinRate = 0;
    
    for (int i = 0; i < [resultArray count]; i++)
    {
        
        NSArray *array = [resultArray objectAtIndex:i];
        float minRate = 1;
        for (YZMatchInfosStatus *matchInfosModel in array)
        {
            float min = 0;
            for (NSArray * selMatchArr in matchInfosModel.selMatchArr) {
                for (YZFootBallMatchRate * rate in selMatchArr) {
                    if (min == 0)
                    {
                        min = [rate.value floatValue];
                    }
                    else
                    {
                        min = min > [rate.value floatValue] ? [rate.value floatValue] : min;
                    }
                }
            }
            minRate *= min;
        }
        if (resultMinRate == 0)
        {
            resultMinRate = minRate;
        }
        else
        {
            resultMinRate = resultMinRate > minRate ? minRate :resultMinRate;
            
        }
    }
    return resultMinRate;
}

+ (int)getMaxWayCountByStatusArray:(NSArray *)statusArray
{
    int maxWayCount = 8;
    
    return maxWayCount;
}

@end
