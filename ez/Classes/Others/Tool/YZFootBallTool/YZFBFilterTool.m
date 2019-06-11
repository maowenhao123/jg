//
//  YZFBFilterTool.m
//  ez
//
//  Created by apple on 16/6/7.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZFBFilterTool.h"
#import "YZFbBetCellStatus.h"
#import "YZFootBallMatchRate.h"

@implementation YZFBFilterTool

+(NSMutableArray *)FilterBetBy:(NSMutableArray *)betArray
{
    //找出最大赔率为基准
    YZFootBallMatchRate * maxRate = [[YZFootBallMatchRate alloc]init];
    for (NSArray * selMatchArr in betArray) {//每一个玩法
        for (YZFootBallMatchRate * rate in selMatchArr) {//每个玩法的选中赔率
            if ([rate.value floatValue] > [maxRate.value floatValue]) {
                maxRate = rate;
            }
        }
    }
    //拆分成胜平负
    NSString * spf = [self getSpfByMatchRate:maxRate];
    YZLog(@"info : %@ spf : %@",maxRate.info,spf);
    //初始化
    NSMutableSet * set1 = [NSMutableSet set];
    NSMutableSet * set20 = [NSMutableSet set];
    NSMutableSet * set21 = [NSMutableSet set];
    NSMutableSet * set22 = [NSMutableSet set];
    NSMutableSet * set2_1 = [NSMutableSet set];
    NSMutableSet * set2_2 = [NSMutableSet set];
    NSMutableSet * set3 = [NSMutableSet set];
    NSMutableSet * set4 = [NSMutableSet set];
    NSMutableSet * set5 = [NSMutableSet set];
    //如果有胜
    if ([spf rangeOfString:@"3"].location != NSNotFound) {
        NSArray * array1 = @[@"3"];//非让球
        //让球
        NSArray * array21 = [self getRangArrayBySpf:3 andConcedePoints:1];//让1球
        NSArray * array22 = [self getRangArrayBySpf:3 andConcedePoints:2];//让1+球
        NSArray * array20 = [self getRangArrayBySpf:3 andConcedePoints:0];//让0球
        NSArray * array2_1 = [self getRangArrayBySpf:3 andConcedePoints:-1];//让-1球
        NSArray * array2_2 = [self getRangArrayBySpf:3 andConcedePoints:-2];//让-1-球
        NSArray * array3 = @[@"33",@"13",@"03"];//半全场
        NSArray * array4 = @[@"10",@"20",@"21",@"30",@"31",@"32",@"40",@"41",@"42",@"50",@"51",@"52",@"90"];//比分
        NSArray * array5 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];//总进球
        //添加
        [set1 addObjectsFromArray:array1];
        [set21 addObjectsFromArray:array21];
        [set22 addObjectsFromArray:array22];
        [set20 addObjectsFromArray:array20];
        [set2_1 addObjectsFromArray:array2_1];
        [set2_2 addObjectsFromArray:array2_2];
        [set3 addObjectsFromArray:array3];
        [set4 addObjectsFromArray:array4];
        [set5 addObjectsFromArray:array5];
    }
    //如果有平
    if ([spf rangeOfString:@"1"].location != NSNotFound) {
        NSArray * array1 = @[@"1"];//非让球
        //让球
        NSArray * array21 = [self getRangArrayBySpf:1 andConcedePoints:1];//让1球
        NSArray * array22 = [self getRangArrayBySpf:1 andConcedePoints:2];//让1+球
        NSArray * array20 = [self getRangArrayBySpf:1 andConcedePoints:0];//让0球
        NSArray * array2_1 = [self getRangArrayBySpf:1 andConcedePoints:-1];//让-1球
        NSArray * array2_2 = [self getRangArrayBySpf:1 andConcedePoints:-2];//让-1-球
        NSArray * array3 = @[@"31",@"11",@"01"];//半全场
        NSArray * array4 = @[@"00",@"11",@"22",@"33",@"99"];//比分
        NSArray * array5 = @[@"0",@"2",@"4",@"6",@"7"];//总进球
        //添加
        [set1 addObjectsFromArray:array1];
        [set21 addObjectsFromArray:array21];
        [set22 addObjectsFromArray:array22];
        [set20 addObjectsFromArray:array20];
        [set2_1 addObjectsFromArray:array2_1];
        [set2_2 addObjectsFromArray:array2_2];
        [set3 addObjectsFromArray:array3];
        [set4 addObjectsFromArray:array4];
        [set5 addObjectsFromArray:array5];
    }
    //如果有负
    if ([spf rangeOfString:@"0"].location != NSNotFound) {
        NSArray * array1 = @[@"0"];//非让球
        //让球
        NSArray * array21 = [self getRangArrayBySpf:1 andConcedePoints:1];//让1球
        NSArray * array22 = [self getRangArrayBySpf:1 andConcedePoints:2];//让1+球
        NSArray * array20 = [self getRangArrayBySpf:1 andConcedePoints:0];//让0球
        NSArray * array2_1 = [self getRangArrayBySpf:1 andConcedePoints:-1];//让-1球
        NSArray * array2_2 = [self getRangArrayBySpf:1 andConcedePoints:-2];//让-1-球
        NSArray * array3 = @[@"30",@"10",@"00"];//半全场
        NSArray * array4 = @[@"01",@"02",@"12",@"03",@"13",@"23",@"04",@"14",@"24",@"05",@"15",@"25",@"09"];//比分
        NSArray * array5 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"];//总进球
        //添加
        [set1 addObjectsFromArray:array1];
        [set21 addObjectsFromArray:array21];
        [set22 addObjectsFromArray:array22];
        [set20 addObjectsFromArray:array20];
        [set2_1 addObjectsFromArray:array2_1];
        [set2_2 addObjectsFromArray:array2_2];
        [set3 addObjectsFromArray:array3];
        [set4 addObjectsFromArray:array4];
        [set5 addObjectsFromArray:array5];
    }
    //创建一份新的被选中玩法数组
    NSMutableArray * betArray_ = [NSMutableArray array];
    for (NSArray * selMatchArr in betArray) {//每一个玩法
        NSMutableArray * selMatchArr_ = [NSMutableArray array];
        for (YZFootBallMatchRate * rate in selMatchArr) {//每个玩法的选中赔率
            [selMatchArr_ addObject:rate];
        }
        [betArray_ addObject:selMatchArr_];
    }
    //遍历，如果没有就删除
    for (NSArray * selMatchArr in betArray) {
        for (YZFootBallMatchRate * rate in selMatchArr) {
            NSString * info = [self getInfoByByMatchRate:rate];
            if ([rate.CNType isEqualToString:@"CN01"]) {//让球
                NSMutableArray * selMatchArray = betArray_[1];
                //根据被选中比赛的让球数
                if (rate.concedePoints == 1) {
                    if (![set21 containsObject:info]) {
                        if (rate!= maxRate) {
                            [selMatchArray removeObject:rate];
                        }
                    }
                }
                else if (rate.concedePoints > 1)
                {
                    if (![set22 containsObject:info]) {
                        if (rate!= maxRate) {
                            [selMatchArray removeObject:rate];
                        }
                    }
                }
                else if (rate.concedePoints == 0)
                {
                    if (![set20 containsObject:info]) {
                        if (rate!= maxRate) {
                            [selMatchArray removeObject:rate];
                        }
                    }
                }
                else if (rate.concedePoints == -1) {
                    if (![set2_1 containsObject:info]) {
                        if (rate!= maxRate) {
                            [selMatchArray removeObject:rate];
                        }
                    }
                }
                else if (rate.concedePoints < -1)
                {
                    if (![set2_2 containsObject:info]) {
                        if (rate!= maxRate) {
                            [selMatchArray removeObject:rate];
                        }
                    }
                }
            }else if ([rate.CNType isEqualToString:@"CN02"])//非让球
            {
                NSMutableArray * selMatchArray = betArray_[0];
                if (![set1 containsObject:info]) {
                    if (rate!= maxRate) {
                        [selMatchArray removeObject:rate];
                    }
                }
                
            }else if ([rate.CNType isEqualToString:@"CN03"])//比分
            {
                NSMutableArray * selMatchArray = betArray_[4];
                if (![set4 containsObject:info]) {
                    if (rate!= maxRate) {
                        [selMatchArray removeObject:rate];
                    }
                }
            }else if ([rate.CNType isEqualToString:@"CN04"])
            {
                NSMutableArray * selMatchArray = betArray_[5];//总进球
                if (![set5 containsObject:info]) {
                    if (rate!= maxRate) {
                        [selMatchArray removeObject:rate];
                    }
                }
            }else if ([rate.CNType isEqualToString:@"CN05"])//半全场
            {
                NSMutableArray * selMatchArray = betArray_[3];
                if (![set3 containsObject:info]) {
                    if (rate!= maxRate) {
                        [selMatchArray removeObject:rate];
                    }
                }
            }
        }
    }
    return betArray_;
}
//把不同玩法转化成胜平负
+ (NSString *)getSpfByMatchRate:(YZFootBallMatchRate *)matchRate
{
    NSString * spf;
    NSDictionary * exchangeDic = [self getExchangeDic];
    NSDictionary * exchangeDic_ = [NSDictionary dictionary];
    if ([matchRate.CNType isEqualToString:@"CN01"]) {//让球
        NSString * key;//根据让球数找对应的转换方式
        if (matchRate.concedePoints < -1) {
            key = @"rfspf<-1";
        }else if (matchRate.concedePoints == -1)
        {
            key = @"rfspf=-1";
        }else if (matchRate.concedePoints == 0)
        {
            key = @"rfspf=0";
        }else if (matchRate.concedePoints == 1)
        {
            key = @"rfspf=1";
        }else if (matchRate.concedePoints > 1)
        {
            key = @"rfspf>1";
        }
        exchangeDic_ = exchangeDic[key];
    }else if ([matchRate.CNType isEqualToString:@"CN02"])//非让
    {
        exchangeDic_ = exchangeDic[@"spf"];
    }else if ([matchRate.CNType isEqualToString:@"CN03"])//比分
    {
        exchangeDic_ = exchangeDic[@"bf"];
    }else if ([matchRate.CNType isEqualToString:@"CN04"])//总进球
    {
        exchangeDic_ = exchangeDic[@"zjq"];
    }else if ([matchRate.CNType isEqualToString:@"CN05"])//胜负半场
    {
        exchangeDic_ = exchangeDic[@"bqc"];
    }
    NSString * info = [self getInfoByByMatchRate:matchRate];
    spf = exchangeDic_[info];
    return spf;
}
//把玩法前缀转化为数字
+ (NSString *)getInfoByByMatchRate:(YZFootBallMatchRate *)matchRate
{
    NSString * info = matchRate.info;
    if ([matchRate.CNType isEqualToString:@"CN01"] || [matchRate.CNType isEqualToString:@"CN02"]) {//让球 非让球
        if ([matchRate.info rangeOfString:@"胜"].location != NSNotFound) {
            info = @"3";
        } else if ([matchRate.info rangeOfString:@"平"].location != NSNotFound)
        {
            info = @"1";
        }else
        {
            info = @"0";
        }
    }else if ([matchRate.CNType isEqualToString:@"CN03"])//比分
    {
        info = [info stringByReplacingOccurrencesOfString:@":" withString:@""];
        info = [info stringByReplacingOccurrencesOfString:@"胜其他" withString:@"90"];
        info = [info stringByReplacingOccurrencesOfString:@"平其他" withString:@"99"];
        info = [info stringByReplacingOccurrencesOfString:@"负其他" withString:@"09"];
    }else if ([matchRate.CNType isEqualToString:@"CN04"])//总进球
    {
        info = [info stringByReplacingOccurrencesOfString:@"+" withString:@""];
    }else if ([matchRate.CNType isEqualToString:@"CN05"])//胜负半场
    {
        info = [info stringByReplacingOccurrencesOfString:@"胜" withString:@"3"];
        info = [info stringByReplacingOccurrencesOfString:@"平" withString:@"1"];
        info = [info stringByReplacingOccurrencesOfString:@"负" withString:@"0"];
    }
    return info;
}
//根据胜平负和让球数得到让球胜平负
+ (NSArray *)getRangArrayBySpf:(int)spf andConcedePoints:(int)concedePoints
{
    NSMutableSet * rangSet = [NSMutableSet set];
    for (int i = 0; i < 10; i++) {//i为主队进球数
        for (int j = 0; j < 10; j++) {//j为客队进球数
            int zhu = i + concedePoints;
            int ke = j;
            if (spf == 3 && i > j) {
                if (zhu > ke) {
                    [rangSet addObject:@"3"];
                }else if (zhu  == ke)
                {
                    [rangSet addObject:@"1"];
                }else if (zhu < ke)
                {
                    [rangSet addObject:@"0"];
                }
            }else if (spf == 1 && i == j)
            {
                if (zhu > ke) {
                    [rangSet addObject:@"3"];
                }else if (zhu  == ke)
                {
                    [rangSet addObject:@"1"];
                }else if (zhu < ke)
                {
                    [rangSet addObject:@"0"];
                }
            }else if (spf == 0 && i < j)
            {
                if (zhu > ke) {
                    [rangSet addObject:@"3"];
                }else if (zhu  == ke)
                {
                    [rangSet addObject:@"1"];
                }else if (zhu < ke)
                {
                    [rangSet addObject:@"0"];
                }
            }
        }
    }
    NSMutableArray * rangArr = [NSMutableArray array];
    for (id object in rangSet) {
        [rangArr addObject:object];
    }
    return (NSArray *)rangArr;
}
//不同玩法转化成胜平负玩法的字典
+(NSDictionary *)getExchangeDic
{
    NSDictionary * exchangeDic = [NSDictionary dictionary];
    exchangeDic = @{
                    @"spf":@{
                            @"3" : @"3",
                            @"1" : @"1",
                            @"0" : @"0"
                            },
                    @"rfspf=-1":@{
                            @"3" : @"3",
                            @"1" : @"3",
                            @"0" : @"10"
                            },
                    @"rfspf<-1":@{
                            @"3" : @"3",
                            @"1" : @"3",
                            @"0" : @"310"
                            },
                    @"rfspf=1":@{
                            @"3" : @"31",
                            @"1" : @"0",
                            @"0" : @"0"
                            },
                    @"rfspf>1":@{
                            @"3" : @"310",
                            @"1" : @"0",
                            @"0" : @"0"
                            },
                    @"rfspf=0":@{
                            @"3" : @"3",
                            @"1" : @"1",
                            @"0" : @"0"
                            },
                    @"bqc":@{
                            @"33" : @"3",
                            @"31" : @"1",
                            @"30" : @"0",
                            @"13" : @"3",
                            @"11" : @"1",
                            @"10" : @"0",
                            @"03" : @"3",
                            @"01" : @"1",
                            @"00" : @"0"
                            },
                    @"zjq":@{
                            @"0" : @"1",
                            @"1" : @"30",
                            @"2" : @"310",
                            @"3" : @"30",
                            @"4" : @"310",
                            @"5" : @"30",
                            @"6" : @"310",
                            @"7" : @"310"
                            },
                    @"bf":@{
                            @"10" : @"3",
                            @"20" : @"3",
                            @"21" : @"3",
                            @"30" : @"3",
                            @"31" : @"3",
                            @"32" : @"3",
                            @"40" : @"3",
                            @"41" : @"3",
                            @"42" : @"3",
                            @"50" : @"3",
                            @"51" : @"3",
                            @"52" : @"3",
                            @"90" : @"3",
                            @"00" : @"1",
                            @"11" : @"1",
                            @"22" : @"1",
                            @"33" : @"1",
                            @"99" : @"1",
                            @"01" : @"0",
                            @"02" : @"0",
                            @"12" : @"0",
                            @"03" : @"0",
                            @"13" : @"0",
                            @"23" : @"0",
                            @"04" : @"0",
                            @"14" : @"0",
                            @"24" : @"0",
                            @"05" : @"0",
                            @"15" : @"0",
                            @"25" : @"0",
                            @"09" : @"0"
                            }
                    };
    return exchangeDic;
}
@end
