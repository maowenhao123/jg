//
//  YZFootBallTool.m
//  ez
//
//  Created by apple on 14-12-9.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZFootBallTool.h"
#import "YZFbBetCellStatus.h"
#import "YZFootBallMatchRate.h"
#import "YZPlayPassWay.h"
#import "YZFBFilterTool.h"
#import "YZMathTool.h"

@interface YZFootBallTool ()

@property (nonatomic, strong)  NSDictionary *morePassWayDict;

@end

@implementation YZFootBallTool

static NSDictionary *morePassWayDict;

#pragma  mark - 计算单串过关注数和奖金(zzj write it)
/**
 * @param betArray 需要的已经选择的原始数组
 * @param playWays 单串过关方式m串1的m
 * @param danArray 选了胆的场次的数组
 * @return 返回结果是含注数、最小奖金、最大奖金的一个数组
 */
//自由过关
+ (NSMutableArray *)computeBetCountAndPrizeRangeWithBetArray:(NSMutableArray *)betArray playWays:(NSArray *)playWayArray danArray:(NSMutableArray *)danArray selectedPlayType:(int)selectedPlayType
{
    int totalCount = 0;
    float totalMinPrize = 0;
    float totalMaxPrize = 0;
    if (selectedPlayType >= 7) {
        totalCount = [self computeSingleBetCountWithBetArray:betArray];
        totalMinPrize = [self calculatorSingleMinRate:betArray];
        totalMaxPrize = [self calculatorSingleMaxRate:betArray];
    }else
    {
        NSString * name;
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
                NSMutableArray * danShiArray = [NSMutableArray array];
                if (danArray.count > 0) {//
                    [danShiArray addObject:newBetArr];
                    
                }else
                {
                    danShiArray = [self fuChangeDanBy:newBetArr andDanArray:danArray];
                }
                for (NSMutableArray * dataArray in danShiArray) {
                    //拆票
                    NSMutableArray *resultArray = [NSMutableArray array];
                    NSMutableArray *newArray = [NSMutableArray array];
                    [self chaiBetArrayWithBetArray:dataArray resultArray:resultArray newArray:newArray playWay:playPassWay.number];
                    if(danArray)//如果有胆的话，就要对resultArray除去不含有胆的场次
                    {
                        NSMutableArray *tempArr = [NSMutableArray array];
                        for(NSMutableArray *muArr in resultArray)//muArr是每一串的场次组合
                        {
                            if([self array1containsArray2AllObjectWithArray1:muArr array2:danArray])//全包含
                            {
                                [tempArr addObject:muArr];
                            }
                        }
                        resultArray = tempArr;
                    }
                    
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
                if(danArray)//如果有胆的话，就要对resultArray除去不含有胆的场次
                {
                    NSMutableArray *tempArr = [NSMutableArray array];
                    for(NSMutableArray *muArr in resultArray)//muArr是每一串的场次组合
                    {
                        if([self array1containsArray2AllObjectWithArray1:muArr array2:danArray])//全包含
                        {
                            [tempArr addObject:muArr];
                        }
                    }
                    resultArray = tempArr;
                }
                
                
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
            if (![name isEqualToString:playPassWay.name]) {//每种过关方式的最大赔率(几串几,多个相加
                //重复次数
                float repeatCount = (float)[YZMathTool getCountWithN:(int)(betArray.count - playPassWay.number) andM:(int)(playPassWay.index - playPassWay.number)];
                if (repeatCount == 0) {
                    repeatCount = 1;
                }
                YZLog(@"repeatCount : %.2f index : %d  number : %d",repeatCount,playPassWay.index,playPassWay.number);
                totalMinPrize += resultMinRate * repeatCount;
                name = playPassWay.name;
                
            }
        }
        //playWayArray遍历完毕
    }
    
    NSMutableArray *muArr = [NSMutableArray arrayWithObjects:@(totalCount),@(totalMinPrize),@(totalMaxPrize), nil];
    return muArr;
}
//返回no就是不全包含array2的所有元素
+ (BOOL)array1containsArray2AllObjectWithArray1:(NSMutableArray *)array1 array2:(NSMutableArray *)array2
{
    BOOL b = YES;
    for(YZFbBetCellStatus *status in array2)
    {
        if(![array1 containsObject:status])//不包含
        {
            b = NO;
            break;
        }
    }
    return b;
}
//复式转化成单式
+ (NSMutableArray *)fuChangeDanBy:(NSMutableArray *)betArray andDanArray:(NSMutableArray *)danArray
{
    NSMutableArray * danShiArray = [NSMutableArray array];
    //一共循环次数 要拆成的单式数
    int total = 1;
    NSMutableArray * dataArray = [NSMutableArray array];
    for (int i = 0; i < betArray.count; i++) {
        YZFbBetCellStatus *match = betArray[i];
        NSMutableArray * selMatchArray = match.matchInfosStatus.selMatchArr;
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
            YZFbBetCellStatus * cellStatus = [[YZFbBetCellStatus alloc]init];
            YZMatchInfosStatus * matchInfosStatus = [[YZMatchInfosStatus alloc]init];
            NSMutableArray * selMatchArr = matchInfosStatus.selMatchArr;
            for (YZFootBallMatchRate * rate in selMatchs) {
                if ([rate.CNType isEqualToString:@"CN01"]) {
                    [selMatchArr[1] addObject:rate];
                }else if ([rate.CNType isEqualToString:@"CN02"])
                {
                    [selMatchArr[0] addObject:rate];
                }else if ([rate.CNType isEqualToString:@"CN03"])
                {
                    [selMatchArr[4] addObject:rate];
                }else if ([rate.CNType isEqualToString:@"CN04"])
                {
                    [selMatchArr[5] addObject:rate];
                }else if ([rate.CNType isEqualToString:@"CN05"])
                {
                    [selMatchArr[3] addObject:rate];
                }else if ([rate.CNType isEqualToString:@"CN06"])
                {
                    [selMatchArr[2] addObject:rate];
                }
            }
            matchInfosStatus.selMatchArr = selMatchArr;
            cellStatus.matchInfosStatus = matchInfosStatus;
            cellStatus.btnSelectedCount = (int)selMatchs.count;
            [selMatchArray addObject:cellStatus];
        }
        [danShiArray addObject:selMatchArray];
    }
    return danShiArray;
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
    /* 
     <YZFbBetCellStatus: 0x7fac8b6f9870>,
     <YZFbBetCellStatus: 0x7fac8c89c040>,
     <YZFbBetCellStatus: 0x7fac8b60bd20>*/
    //递归函数
    for (int i = 0; i < [betArray count]; i++)  // 遍历所有已选比赛对象(arr_bettingCell)...
    {
        NSArray *mutableArr = [betArray subarrayWithRange:NSMakeRange(i+1, [betArray count]-i-1)];//第i个对象以后
        NSMutableArray *newMuArr = [[NSMutableArray alloc]initWithArray:newArray];
        [newMuArr addObject:[betArray objectAtIndex:i]];    // 首先加入当前比赛对象...
        [self chaiBetArrayWithBetArray:mutableArr resultArray:resultArray newArray:newMuArr playWay:index];
    }
}
#pragma  mark -  算一个过关方式的注数
+ (int)computeBetCountWithChaiArray:(NSArray *)chaiArray
{
    int totalCount = 0;
    
    for (int i = 0; i < [chaiArray count]; i++)
    {
        int resultCount = 1;
        NSArray *array = [chaiArray objectAtIndex:i];
        
        for (YZFbBetCellStatus *match in array)
        {
            if (match.btnSelectedCount > 0)
            {
                resultCount *= match.btnSelectedCount;
            }
            
        }
        totalCount +=resultCount;
    }
    
    return totalCount;
}
+ (int)computeSingleBetCountWithBetArray:(NSArray *)betArray
{
    int totalCount = 0;
    for (YZFbBetCellStatus *match in betArray)
    {
        totalCount += match.btnSelectedCount;
    }
    return totalCount;
}
#pragma  mark -  计算奖金范围
//单个过关方式的最大奖金
+ (float)calculatorMaxRate:(NSMutableArray *)resultArray
{
    float resultMaxRate = 0;
    
    for (int i = 0; i < [resultArray count]; i++)
    {
        NSArray *array = [resultArray objectAtIndex:i];
        float maxRate = 1;
        for (YZFbBetCellStatus *match in array)
        {
            float maxSum = 0;
            NSMutableArray * selMatchArray = [NSMutableArray array];
            if (match.playType == 0) {//混合过关才需要筛选
                selMatchArray = [YZFBFilterTool FilterBetBy:match.matchInfosStatus.selMatchArr];
            }else
            {
                selMatchArray = match.matchInfosStatus.selMatchArr;
            }
            
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
//单关方式的最大奖金
+ (float)calculatorSingleMaxRate:(NSMutableArray *)betArray
{
    float resultMaxRate = 0;

    for (YZFbBetCellStatus *match in betArray)
    {
        float maxSum = 0;
        NSMutableArray * selMatchArray = [YZFBFilterTool FilterBetBy:match.matchInfosStatus.selMatchArr];//筛选
        
        for (NSArray * selMatchArr in selMatchArray) {
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
//所有过关方式的最小奖金
+ (float)calculatorMinRate:(NSMutableArray *)resultArray
{
	float resultMinRate = 0;
	
	for (int i = 0; i < [resultArray count]; i++)
	{
		
		NSArray *array = [resultArray objectAtIndex:i];
		float minRate = 1;
		for (YZFbBetCellStatus *match in array)
		{
			float min = 0;
            for (NSArray * selMatchArr in match.matchInfosStatus.selMatchArr) {
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
//单关方式的最小奖金
+ (float)calculatorSingleMinRate:(NSMutableArray *)betArray
{
    float resultMinRate = 0;
    
    for (YZFbBetCellStatus *match in betArray)
    {
        float min = 0;
        for (NSArray * selMatchArr in match.matchInfosStatus.selMatchArr) {
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
#pragma  mark - 二选一转化成胜平负
+ (NSMutableArray *)changeCN06ToCN01AndCN02BySelMatchArray:(NSMutableArray *)selMatchArray
{
    NSMutableArray * selMatchArray_ = [NSMutableArray array];
    for (NSArray * array in selMatchArray) {
        NSMutableArray * array_ = [NSMutableArray array];
        for (id object in array) {
            [array_ addObject:object];
        }
        [selMatchArray_ addObject:array_];
    }
    NSMutableArray * selMatchs_ = selMatchArray_[2];
    NSMutableArray * selMatchs = [NSMutableArray array];
    for (id object in selMatchs_) {
        [selMatchs addObject:object];
    }
    
    //如果没有二选一
    if (selMatchs.count == 0) {
        return selMatchArray_;
    }
    NSMutableArray * oddsInfoArray1_ = selMatchArray_[1];//让球
    NSMutableArray * oddsInfoArray1 = [NSMutableArray array];
    for (id object in oddsInfoArray1_) {
        [oddsInfoArray1 addObject:object];
    }
    NSMutableArray * oddsInfoArray2_ = selMatchArray_[0];//非让
    NSMutableArray * oddsInfoArray2 = [NSMutableArray array];
    for (id object in oddsInfoArray2_) {
        [oddsInfoArray2 addObject:object];
    }
    for (YZFootBallMatchRate * rate in selMatchs) {
        if ([rate.info isEqualToString:@"主不胜"]) {//让球
            YZFootBallMatchRate * rate_ = [[YZFootBallMatchRate alloc]init];
            rate_.CNType = @"CN01";
            rate_.info = @"负";
            rate_.value = rate.value;
            [oddsInfoArray1 addObject:rate_];
        }else if ([rate.info isEqualToString:@"主不败"])//让球
        {
            YZFootBallMatchRate * rate_ = [[YZFootBallMatchRate alloc]init];
            rate_.CNType = @"CN01";
            rate_.info = @"胜";
            rate_.value = rate.value;
            [oddsInfoArray1 addObject:rate_];
        }else if ([rate.info isEqualToString:@"主胜"])//非让球
        {
            YZFootBallMatchRate * rate_ = [[YZFootBallMatchRate alloc]init];
            rate_.CNType = @"CN02";
            rate_.info = @"胜";
            rate_.value = rate.value;
            [oddsInfoArray2 addObject:rate_];
        }else if ([rate.info isEqualToString:@"主败"])//非让球
        {
            YZFootBallMatchRate * rate_ = [[YZFootBallMatchRate alloc]init];
            rate_.CNType = @"CN02";
            rate_.info = @"负";
            rate_.value = rate.value;
            [oddsInfoArray2 addObject:rate_];
        }
    }
    selMatchArray_[0] = oddsInfoArray2;
    selMatchArray_[1] = oddsInfoArray1;
    return selMatchArray_;
}

#pragma  mark - 任九场的注数算法
+ (int)getRenjiuBetCount:(NSArray *)a :(int)num
{
    int total = 0;
    int c = 1;
    NSMutableArray *b = [a mutableCopy];
    for (int i = 0; i < b.count; i++) {
        if (i < num) {
            b[i] = @"1";
        } else
            b[i] = @"0";
    }
    
    int point = 0;
    int nextPoint = 0;
    int amount = 0;
    int sum = 0;
    NSString *temp = @"1";
    while (true) {
        
        // 判断是否全部移位完毕
        for (int i = (int)[b count] - 1; i >=  ((int)[b count] - num); i--) {
            if ([b[i] isEqualToString:@"1"])
                sum += 1;
        }
        // 根据移位生成数据
        for (int i = 0; i < [b count]; i++) {
            if ([b[i] isEqualToString:@"1"]) {
                point = i;
                c *= [a[point] intValue];
                amount++;
                if (amount == num)
                    break;
            }
        }
        // 往返回值列表添加数据
        total += c;
        
        // 当数组的最后num位全部为1 退出
        if (sum == num) {
            break;
        }
        sum = 0;
        
        // 修改从左往右第一个10变成01
        for (int i = 0; i < [b count] - 1; i++) {
            if ([b[i] isEqualToString:@"1"] && [b[i + 1] isEqualToString:@"0"]) {
                point = i;
                nextPoint = i + 1;
                b[point] = @"0";
                b[nextPoint] = @"1";
                break;
            }
        }
        // 将 i-point个元素的1往前移动 0往后移动
        for (int i = 0; i < point - 1; i++)
            for (int j = i; j < point - 1; j++) {
                if ([b[i] isEqualToString:@"0"]) {
                    temp = b[i];
                    b[i] = b[j + 1];
                    b[j + 1] = temp;
                }
            }
        // 清空 StringBuffer
        c = 1;
        amount = 0;
    }
    //
    return total;
}
#pragma  mark - 多串过关方式的字典
+ (NSDictionary *)getMorePassWayDict
{
    if(morePassWayDict == nil)
    {
        morePassWayDict = @{
                             @"3串3" :@"3,0,0,0,0,0,0",
                             @"3串4" :@"3,1,0,0,0,0,0",
                             
                             @"4串4" :@"0,4,0,0,0,0,0",
                             @"4串5" :@"0,4,1,0,0,0,0",
                             @"4串6" :@"6,0,0,0,0,0,0",
                             @"4串11" :@"6,4,1,0,0,0,0",
                             
                             @"5串5" :@"0,0,5,0,0,0,0",
                             @"5串6" :@"0,0,5,1,0,0,0",
                             @"5串10" :@"10,0,0,0,0,0,0",
                             @"5串16" :@"0,10,5,1,0,0,0",
                             @"5串20" :@"10,10,0,0,0,0,0",
                             @"5串26" :@"10,10,5,1,0,0,0",
                             
                             @"6串6" :@"0,0,0,6,0,0,0",
                             @"6串7" :@"0,0,0,6,1,0,0",
                             @"6串15" :@"15,0,0,0,0,0,0",
                             @"6串20" :@"0,20,0,0,0,0,0",
                             @"6串22" :@"0,0,15,6,1,0,0",
                             @"6串35" :@"15,20,0,0,0,0,0",
                             @"6串42" :@"0,20,15,6,1,0,0",
                             @"6串50" :@"15,20,15,0,0,0,0",
                             @"6串57" :@"15,20,15,6,1,0,0",
                             
                             @"7串7" :@"0,0,0,0,7,0,0",
                             @"7串8" :@"0,0,0,0,7,1,0",
                             @"7串21" :@"0,0,0,21,0,0,0",
                             @"7串35" :@"0,0,35,0,0,0,0",
                             @"7串120" :@"21,35,35,21,7,1,0",
                             
                             @"8串8" :@"0,0,0,0,0,8,0",
                             @"8串9" :@"0,0,0,0,0,8,1",
                             @"8串28" :@"0,0,0,0,28,0,0",
                             @"8串56" :@"0,0,0,56,0,0,0",
                             @"8串70" :@"0,0,70,0,0,0,0",
                             @"8串247" :@"28,56,70,56,28,8,1"
                             };
    }
    return morePassWayDict;
}
/*
 code 02|201606072101|3,1,0&01|201606072101|3,1,0&05|201606072101|33,31,30,13,11,10,03,01,00
 winNum winningNumber = "01|0;02|0;03|09;04|7;05|00;R|-1.0;H|0:1;F|3:4";
 */
//判断是非中奖
+ (BOOL)isHitByWinNumber:(NSString *)winNumber andCode:(NSString *)code
{
    BOOL isHit = NO;
    NSArray * codeArray = [code componentsSeparatedByString:@"&"];//02|201606072101|3,1,0
    for (NSString * codeString in codeArray) {
        NSArray * codeArr = [codeString componentsSeparatedByString:@"|"];
        NSString * playTypeStr = codeArr[0];//02
        NSString * selNumStr = codeArr[2];//3,1,0
        NSArray * selNumArr = [selNumStr componentsSeparatedByString:@","];//3
        for (NSString * selNum in selNumArr) {
            NSString * selCode = [NSString stringWithFormat:@"%@|%@",playTypeStr,selNum];//02|3
            selCode = [selCode stringByReplacingOccurrencesOfString:@"$" withString:@""];
            if ([winNumber rangeOfString:selCode].location != NSNotFound) {
                return YES;
            }
        }
    }
    return isHit;
}
// winningNumber 01|1;02|3;03|10;04|1;05|13;R|-1.0;H|0:0;F|1:0
// playType 02
+ (NSString *)getJCMatchResultByWinningNumber:(NSString *)winningNumber playType:(NSString *)playType
{
    NSString * result;
    if ([playType isEqualToString:@"06"]) {//混合过关显示比分
        playType = @"03";
    }
    NSArray * winningNumbers = [winningNumber componentsSeparatedByString:@";"];
    NSString * winningNumStr;
    for (NSString * winningNum in winningNumbers) {
        if ([winningNum rangeOfString:[NSString stringWithFormat:@"%@|",playType]].location != NSNotFound) {
            winningNumStr = winningNum;
        }
    }
    NSArray * winningNumStrs = [winningNumStr componentsSeparatedByString:@"|"];
    result = [self getResultByPlayType:winningNumStrs[0] winningNumber:winningNumStrs[1]];
    return result;
}
+ (NSString *)getResultByPlayType:(NSString *)playType winningNumber:(NSString *)winningNumber
{
    NSString * result;
    if ([playType isEqualToString:@"01"] || [playType isEqualToString:@"02"]) {
        NSString *betTypeName = @"";
        if([playType isEqualToString:@"01"])//让球
        {
            betTypeName = @"让球";
        }
        NSString *oddInfoName = nil;
        if([winningNumber isEqualToString:@"3"])
        {
            oddInfoName = @"胜";
        }else if([winningNumber isEqualToString:@"1"])
        {
            oddInfoName = @"平";
        }else if([winningNumber isEqualToString:@"0"])
        {
            oddInfoName = @"负";
        }
        result = [NSString stringWithFormat:@"%@%@",betTypeName,oddInfoName];
    }else if ([playType isEqualToString:@"03"])//比分
    {
        if ([winningNumber isEqualToString:@"90"]) {
            result = @"胜其他";
        }else if ([winningNumber isEqualToString:@"99"]) {
            result = @"平其他";
        }else if ([winningNumber isEqualToString:@"09"]) {
            result = @"负其他";
        }else
        {
            result = [NSMutableString stringWithFormat:@"%@",winningNumber];
            [(NSMutableString *)result insertString:@":" atIndex:1];
        }
    }else if ([playType isEqualToString:@"04"])//进球数
    {
        result = winningNumber;
    }else if ([playType isEqualToString:@"05"])//半全场
    {
        result = [winningNumber stringByReplacingOccurrencesOfString:@"3" withString:@"胜"];
        result = [result stringByReplacingOccurrencesOfString:@"1" withString:@"平"];
        result = [result stringByReplacingOccurrencesOfString:@"0" withString:@"负"];
    }
    return  result;
}
//获取playType
+ (NSString *)getPlayTypeByCode:(NSString *)code
{
    NSString * playType;
    NSArray * codes = [code componentsSeparatedByString:@"&"];
    for (NSString * codeStr in codes) {
        NSArray * codeStrs = [codeStr componentsSeparatedByString:@"|"];
        NSString * playType_ = [codeStrs firstObject];
        if ([playType_ rangeOfString:@"$"].location != NSNotFound) {//除去胆$
            playType_ = [playType_ stringByReplacingOccurrencesOfString:@"$" withString:@""];
        }
        if (playType.length == 0) {
            playType = playType_;
        }
        if ([playType isEqualToString:playType_]) {
            playType = playType_;
        }else
        {
            playType = @"06";
        }
    }
    return playType;
}
+ (int)getMaxWayCountByStatusArray:(NSArray *)statusArray
{
    int maxWayCount = 8;
    for (YZFbBetCellStatus *status in statusArray) {
        for (NSMutableArray * selMatchArray in status.matchInfosStatus.selMatchArr) {
            for (YZFootBallMatchRate * rate in selMatchArray) {
                if ([rate.CNType isEqualToString:@"CN04"]) {
                    maxWayCount = 6;
                }else if ([rate.CNType isEqualToString:@"CN03"] || [rate.CNType isEqualToString:@"CN05"])
                {
                    return 4;
                }
            }
        }
    }
    return maxWayCount;
}
@end
