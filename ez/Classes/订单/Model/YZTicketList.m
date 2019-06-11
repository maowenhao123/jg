//
//  YZTicketList.m
//  ez
//
//  Created by apple on 14/12/27.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZTicketList.h"
#import "YZDateTool.h"

@implementation YZTicketList
MJCodingImplementation
/**
 返回  周四001 [让球胜(4.000),让球负(3.000)] * 周四001 [让球胜(4.000),让球负(3.000)]
 orderCodes格式："02|201501073001|3@1.430;02|201501073002|3@1.390;02|201501073003|3@1.540"
 */
+ (NSString *)getTicketInfos:(NSArray *)orderCodes numbers:(NSArray *)numbers gameId:(NSString *)gameId
{
    NSMutableString *muStr = [NSMutableString string];
    orderCodes = orderCodes.count > 0 ? orderCodes : numbers;
    for(int i = 0;i < orderCodes.count;i++)
    {
        NSString *orderCode = orderCodes[i];
        [muStr appendString:[NSString stringWithFormat:@"%@\n\n",[self getTicketInfoWithOrderCode:orderCode gameId:gameId]]];
    }
    [muStr deleteCharactersInRange:NSMakeRange(muStr.length - 2, 2)];
    return  muStr;
}
//orderCode格式:02|201501084001|3@4.000，返回周四001 [让球胜(4.000),让球负(3.000)]
+ (NSString *)getTicketInfoWithOrderCode:(NSString *)orderCode gameId:(NSString *)gameId
{
    NSMutableString *muStr = [NSMutableString string];
    NSArray *arr = [orderCode componentsSeparatedByString:@"|"];
    NSString * dateStr = arr[1];
    NSString *week = [YZDateTool getWeekFromDateString:[dateStr substringToIndex:8] format:@"yyyyMMdd"];
    week = [week stringByReplacingOccurrencesOfString:@"星期" withString:@"周"];
    [muStr appendString:week];
    [muStr appendString:[arr[1] substringWithRange:NSMakeRange(9, 3)]];//拼接出："周四001"格式
    [muStr appendString:@" "];
    NSString *sfcInfo = [self getFbBetTypeOddsStr:arr[0] oddInfos:arr[2] gameId:gameId];
    [muStr appendString:[NSString stringWithFormat:@"[%@]",sfcInfo]];
    
    return muStr;
}
////orderCode格式:02|201501084001|3@4.000，返回周四001 [让球胜(4.000),让球负(3.000)]
//+ (NSString *)getTicketInfoWithNumber:(NSString *)number
//{
//    NSMutableString *muStr = [NSMutableString string];
//    NSArray *arr = [number componentsSeparatedByString:@"|"];
//    NSString *week = [YZDateTool getWeekFromDateString:arr[1] format:@"yyyyMMdd"];
//    week = [week stringByReplacingOccurrencesOfString:@"星期" withString:@"周"];
//    [muStr appendString:week];
//    [muStr appendString:[arr[1] substringWithRange:NSMakeRange(9, 3)]];//拼接出："周四001"格式
//    [muStr appendString:@" "];
//    NSString *sfcInfo = [self getFbBetTypeOddsStr:[arr objectAtIndex:0] oddInfos:[arr objectAtIndex:2]];
//    [muStr appendString:[NSString stringWithFormat:@"[%@]",sfcInfo]];
//
//    return muStr;
//}
//返回字符串格式："让球胜(4.000),让球负(3.000)"
+ (NSString *)getFbBetTypeOddsStr:(NSString *)betType oddInfos:(NSString *)oddInfos gameId:(NSString *)gameId
{
    NSMutableString *muStr = [NSMutableString string];
    NSArray *oddInfoArr = [oddInfos componentsSeparatedByString:@","];
    for(NSString *oddInfo in oddInfoArr)
    {
        [muStr appendString:[self getFbBetTypeOdd:betType oddInfo:oddInfo gameId:gameId]];
        [muStr appendString:@","];
    }
    [muStr deleteCharactersInRange:NSMakeRange(muStr.length - 1, 1)];
    return  muStr;
}
//返回字符串格式："让球胜(4.000)"
+ (NSString *)getFbBetTypeOdd:(NSString *)betType oddInfo:(NSString *)oddInfo gameId:(NSString *)gameId
{
    NSMutableString *muStr = [NSMutableString string];
    NSArray *temp = [oddInfo componentsSeparatedByString:@"@"];//oddInfo格式是"3@4.000"或者"3"
    if ([gameId isEqualToString:@"T52"]) {
        NSString *spf = [temp firstObject];
        if ([betType isEqualToString:@"01"]) {
            if ([spf isEqualToString:@"1"]) {
                [muStr appendFormat:@"让分主胜"];
            }else if ([spf isEqualToString:@"2"])
            {
                [muStr appendFormat:@"让分客胜"];
            }
        }else if ([betType isEqualToString:@"02"])
        {
            if ([spf isEqualToString:@"1"]) {
                [muStr appendFormat:@"主胜"];
            }else if ([spf isEqualToString:@"2"])
            {
                [muStr appendFormat:@"客胜"];
            }
        }else if ([betType isEqualToString:@"03"])
        {
            [muStr appendString:[YZTool bBshengfenDic][spf]];
        }else if ([betType isEqualToString:@"04"])
        {
            if ([spf isEqualToString:@"1"]) {
                [muStr appendFormat:@"大分"];
            }else if ([spf isEqualToString:@"2"])
            {
                [muStr appendFormat:@"小分"];
            }
        }
    }else
    {
        if ([betType isEqualToString:@"01"] || [betType isEqualToString:@"02"]) {
            NSString *betTypeName = nil;
            NSString *spf = [temp firstObject];
            if([betType isEqualToString:@"01"])//让球
            {
                betTypeName = @"让球";
            }else if([betType isEqualToString:@"02"])//非让
            {
                betTypeName = @"";
            }
            NSString *oddInfoName = nil;
            if([spf isEqualToString:@"3"])
            {
                oddInfoName = @"胜";
            }else if([spf isEqualToString:@"1"])
            {
                oddInfoName = @"平";
            }else if([spf isEqualToString:@"0"])
            {
                oddInfoName = @"负";
            }
            [muStr appendString:betTypeName];
            [muStr appendString:oddInfoName];
        }else if ([betType isEqualToString:@"03"])
        {
            NSString *oddInfoName = nil;
            NSString *spf = [temp firstObject];
            if ([spf isEqualToString:@"90"]) {
                oddInfoName = @"胜其他";
            }else if ([spf isEqualToString:@"99"]) {
                oddInfoName = @"平其他";
            }else if ([spf isEqualToString:@"09"]) {
                oddInfoName = @"负其他";
            }else
            {
                oddInfoName = [NSMutableString stringWithFormat:@"%@",spf];
                [(NSMutableString *)oddInfoName insertString:@":" atIndex:1];
            }
            [muStr appendString:oddInfoName];
        }else if ([betType isEqualToString:@"04"])
        {
            NSString *spf = [temp firstObject];
            if ([spf isEqualToString:@"7"]) {
                spf = @"7+";
            }
            [muStr appendFormat:@"进球数%@",spf];
        }else if ([betType isEqualToString:@"05"])
        {
            NSString *spf = [temp firstObject];
            NSString * oddInfoName = [NSMutableString stringWithFormat:@"%@",spf];
            oddInfoName = [oddInfoName stringByReplacingOccurrencesOfString:@"3" withString:@"胜"];
            oddInfoName = [oddInfoName stringByReplacingOccurrencesOfString:@"1" withString:@"平"];
            oddInfoName = [oddInfoName stringByReplacingOccurrencesOfString:@"0" withString:@"负"];
            [muStr appendString:oddInfoName];
        }
    }
    if(temp.count > 1)
    {
        [muStr appendString:[temp objectAtIndex:1] ? [NSString stringWithFormat:@"(%@)",[temp objectAtIndex:1]] : @""];
    }
    return  muStr;
}

@end
