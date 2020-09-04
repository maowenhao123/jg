//
//  YZFBOrderStatus.m
//  ez
//
//  Created by apple on 16/10/11.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZFBOrderStatus.h"
#import "YZDateTool.h"

@implementation YZFBOrderStatus

#pragma mark - 设置数据
- (void)setTermValue:(NSDictionary *)termValue
{
    NSString * winningNumber = termValue[@"winningNumber"];
    
    //球队信息
    NSString *week = [YZDateTool getWeekFromDateString:[termValue[@"code"] substringToIndex:8] format:@"yyyyMMdd"];
    week = [week stringByReplacingOccurrencesOfString:@"星期" withString:@"周"];
    NSString * message = [NSString stringWithFormat:@"%@%@", week, [termValue[@"code"] substringWithRange:NSMakeRange(9, 3)]];
    NSArray *detailInfos = [termValue[@"detailInfo"] componentsSeparatedByString:@"|"];
    NSString * teamName1 = detailInfos[0];
    NSString * teamName2 = detailInfos[1];
    NSString * greenStr = @"";
    if (!YZStringIsEmpty(winningNumber)) {//开奖后的
        NSRange range = [winningNumber rangeOfString:@"F|"];
        NSString *bifen = [winningNumber substringWithRange:NSMakeRange(range.location + 2, winningNumber.length - range.location - 2)];
        if (bifen.length > 0) {
            greenStr = bifen;
        }else
        {
            greenStr = @"VS";
        }
    }else
    {
        greenStr = @"VS";
    }
    _teamMessage = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@(%@) %@ %@", message, teamName1, termValue[@"concedePoints"], greenStr, teamName2]];
    [_teamMessage addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:[_teamMessage.string rangeOfString:message]];//灰色
    [_teamMessage addAttribute:NSForegroundColorAttributeName value:YZColor(7, 161, 61, 1) range:[_teamMessage.string rangeOfString:greenStr]];//绿色
    NSMutableParagraphStyle *teamMessageParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    teamMessageParagraphStyle.lineSpacing = 3;
    teamMessageParagraphStyle.alignment = NSTextAlignmentCenter;
    [_teamMessage addAttribute:NSParagraphStyleAttributeName value:teamMessageParagraphStyle range:NSMakeRange(0, _teamMessage.length)];
    
    //赛果
    NSArray *betTypeOddArr = [self.codes componentsSeparatedByString:@";"];
    NSString * codeStr = @"";
    for (NSString * code_ in betTypeOddArr) {
        if ([code_ rangeOfString:termValue[@"code"]].location != NSNotFound) {
            codeStr = code_;
        }
    }
    _resultsArray = [self getResultsArrayWithWinNumber:winningNumber andCode:codeStr];
    
    //我的投注
    _betArray = [self getBetArrayWithWinNumber:winningNumber andCode:codeStr];
    
    //cell高度
    CGFloat cellH = 0;
    _labelHArray = [NSMutableArray array];
    for (NSAttributedString * codeAttStr in _betArray) {
        CGSize size = [codeAttStr boundingRectWithSize:CGSizeMake(screenWidth * 0.3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        CGFloat height = size.height + 2 * 10;
        [_labelHArray addObject:@(height)];
        cellH += height;
    }
    _cellH = cellH > 60 ? cellH : 60;
}

#pragma mark - 获取赛果数组
//code 02|201606072101|3,1,0&01|201606072101|3,1,0&05|201606072101|33,31,30,13,11,10,03,01,00
//winNum winningNumber = "01|0;02|0;03|09;04|7;05|00;R|-1.0;H|0:1;F|3:4";
- (NSMutableArray *)getResultsArrayWithWinNumber:(NSString *)winNumber andCode:(NSString *)code
{
    if (YZStringIsEmpty(winNumber)) {
        return nil;
    }
    NSMutableArray *resultsArray = [NSMutableArray array];
    NSArray * codeArray = [code componentsSeparatedByString:@"&"];//02|201606072101|3,1,0
    NSArray * winNumberArray = [winNumber componentsSeparatedByString:@";"];
    for (NSString * codeString in codeArray) {
        NSArray * codeArr = [codeString componentsSeparatedByString:@"|"];
        NSString * playTypeStr = codeArr[0];//02
        playTypeStr = [playTypeStr stringByReplacingOccurrencesOfString:@"$" withString:@""];
        for (NSString * winNumberCode in winNumberArray) {
            if ([winNumberCode rangeOfString:[NSString stringWithFormat:@"%@|", playTypeStr]].location != NSNotFound){
                NSString * winNumberStr = [self getWinNumberStrByWinNumberCode:winNumberCode];
                NSMutableAttributedString * winNumberAttStr = [[NSMutableAttributedString alloc] initWithString:winNumberStr];
                NSMutableParagraphStyle *codeParagraphStyle = [[NSMutableParagraphStyle alloc] init];
                codeParagraphStyle.lineSpacing = 3;
                codeParagraphStyle.alignment = NSTextAlignmentCenter;
                [winNumberAttStr addAttribute:NSParagraphStyleAttributeName value:codeParagraphStyle range:NSMakeRange(0, winNumberAttStr.length)];
                [resultsArray addObject:winNumberAttStr];
            }
        }
    }
    return resultsArray;
}
//winNumberCode:01|0
- (NSString *)getWinNumberStrByWinNumberCode:(NSString *)winNumberCode
{
    NSArray *winNumberCodes = [winNumberCode componentsSeparatedByString:@"|"];
    NSString *winNumberPlayType = winNumberCodes.firstObject;//玩法
    NSString *winNumberResult = winNumberCodes.lastObject;//赛果
    NSString *oddInfoName = [self getCodeStrWithBetType:winNumberPlayType odd:winNumberResult];
    NSString *betTypeName = @"";
    if([winNumberPlayType rangeOfString:@"01"].location != NSNotFound && [_gameId isEqualToString:@"T51"])//让球
    {
        betTypeName = @"让球";
    }else if ([winNumberPlayType rangeOfString:@"01"].location != NSNotFound && [_gameId isEqualToString:@"T52"])//让分
    {
        betTypeName = @"让分";
    }
    return [NSString stringWithFormat:@"%@%@", betTypeName, oddInfoName];;
}

#pragma mark - 获取投注数组
//code格式：02|201501084001|3&02|201501084002|3,1
- (NSMutableArray *)getBetArrayWithWinNumber:(NSString *)winNumberCode andCode:(NSString *)code
{
    NSMutableArray *muArr = [NSMutableArray array];
    NSArray *codes = [code componentsSeparatedByString:@"&"];
    for(NSString *aCode in codes)
    {
        NSMutableAttributedString *codeAttStr = [self getAFbBetTypeOddName:aCode winNumberCode:winNumberCode];
        if (!YZStringIsEmpty(codeAttStr.string)) {
            NSMutableParagraphStyle *codeParagraphStyle = [[NSMutableParagraphStyle alloc] init];
            codeParagraphStyle.lineSpacing = 3;
            codeParagraphStyle.alignment = NSTextAlignmentCenter;
            [codeAttStr addAttribute:NSParagraphStyleAttributeName value:codeParagraphStyle range:NSMakeRange(0, codeAttStr.length)];
            [muArr addObject:codeAttStr];
        }else
        {
            [muArr addObject:[[NSAttributedString alloc] init]];
        }
    }
    return muArr;
}

- (NSMutableAttributedString *)getAFbBetTypeOddName:(NSString *)acode winNumberCode:(NSString *)winNumberCode
{
    NSArray *codeArray = [acode componentsSeparatedByString:@"|"];
    NSArray *odds = [[codeArray lastObject] componentsSeparatedByString:@","];//投注
    NSString *betType = codeArray.firstObject;//玩法
    betType = [betType stringByReplacingOccurrencesOfString:@"$" withString:@""];
    NSArray * winNumberArray = [NSArray array];
    if (!YZStringIsEmpty(winNumberCode)) {
        winNumberArray = [winNumberCode componentsSeparatedByString:@";"];//01|3
    }
    NSString *winNumberPlayType;//玩法
    NSString *winNumberResult;//赛果
    for (NSString * winNumberCodeStr in winNumberArray) {
        if ([winNumberCodeStr rangeOfString:[NSString stringWithFormat:@"%@|",betType]].location != NSNotFound)//对应的赢球号码
        {
            NSArray *winNumberStrCodes = [winNumberCodeStr componentsSeparatedByString:@"|"];
            winNumberPlayType = winNumberStrCodes.firstObject;//玩法
            winNumberResult = winNumberStrCodes.lastObject;//赛果
        }
    }
    NSString *playTypeStr;
    NSString *betTypeName = @"";
    if([betType rangeOfString:@"01"].location != NSNotFound && [_gameId isEqualToString:@"T51"])//让球
    {
        betTypeName = @"让球";
        playTypeStr = @"[让球胜平负]\n";
    }else if ([betType rangeOfString:@"01"].location != NSNotFound && [_gameId isEqualToString:@"T52"])//让分
    {
        betTypeName = @"让分";
        playTypeStr = @"[让分胜负]\n";
    }else if ([betType rangeOfString:@"02"].location != NSNotFound && [_gameId isEqualToString:@"T51"])//胜平负
    {
        playTypeStr = @"[胜平负]\n";
    }else if ([betType rangeOfString:@"02"].location != NSNotFound && [_gameId isEqualToString:@"T52"])//胜负
    {
        playTypeStr = @"[胜负]\n";
    }else if ([betType rangeOfString:@"03"].location != NSNotFound && [_gameId isEqualToString:@"T51"])//比分
    {
        playTypeStr = @"[比分]\n";
    }else if ([betType rangeOfString:@"03"].location != NSNotFound && [_gameId isEqualToString:@"T52"])//胜分差
    {
        playTypeStr = @"[胜分差]\n";
    }else if ([betType rangeOfString:@"04"].location != NSNotFound && [_gameId isEqualToString:@"T51"])//进球数
    {
        playTypeStr = @"[进球数]\n";
    }else if ([betType rangeOfString:@"04"].location != NSNotFound && [_gameId isEqualToString:@"T52"])//大小分
    {
        playTypeStr = @"[大小分]\n";
    }else if ([betType rangeOfString:@"05"].location != NSNotFound && [_gameId isEqualToString:@"T51"])//半全场
    {
        playTypeStr = @"[半全场]\n";
    }
    NSMutableAttributedString * codeAttStr = [[NSMutableAttributedString alloc] initWithString:playTypeStr];//我的投注富文本
    [codeAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, playTypeStr.length)];//玩法字体灰色
    for (NSString *odd in odds) {
        NSString *oddInfoName = [self getCodeStrWithBetType:betType odd:odd];
        NSMutableString * betCodeStr = [NSMutableString stringWithFormat:@"%@%@", betTypeName, oddInfoName];
        if (odd != [odds lastObject]) {
            [betCodeStr appendString:@"\n"];
        }
        NSMutableAttributedString * betCodeAttStr = [[NSMutableAttributedString alloc] initWithString:betCodeStr];
        if ([winNumberPlayType isEqualToString:betType] && [winNumberResult isEqualToString:odd]) {//如果中间,变为红色
            [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, betCodeAttStr.length)];
        }else
        {
            [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, betCodeAttStr.length)];
        }
        [codeAttStr appendAttributedString:betCodeAttStr];
    }
    return codeAttStr;
}

- (NSString *)getCodeStrWithBetType:(NSString *)betType odd:(NSString *)odd
{
    NSString *oddInfoName = nil;
    if (([betType rangeOfString:@"01"].location != NSNotFound || [betType rangeOfString:@"02"].location != NSNotFound) && [_gameId isEqualToString:@"T51"]) {
        if([odd isEqualToString:@"3"])
        {
            oddInfoName = @"胜";
        }else if([odd isEqualToString:@"1"])
        {
            oddInfoName = @"平";
        }else if([odd isEqualToString:@"0"])
        {
            oddInfoName = @"负";
        }
    }else if (([betType rangeOfString:@"01"].location != NSNotFound || [betType rangeOfString:@"02"].location != NSNotFound) && [_gameId isEqualToString:@"T52"])
    {
        if ([odd isEqualToString:@"1"]) {
            oddInfoName = @"主胜";
        }else if ([odd isEqualToString:@"2"])
        {
            oddInfoName = @"客胜";
        }
    }else if ([betType rangeOfString:@"03"].location != NSNotFound && [_gameId isEqualToString:@"T51"])//比分
    {
        if ([odd isEqualToString:@"90"]) {
            oddInfoName = @"胜其他";
        }else if ([odd isEqualToString:@"99"]) {
            oddInfoName = @"平其他";
        }else if ([odd isEqualToString:@"09"]) {
            oddInfoName = @"负其他";
        }else
        {
            oddInfoName = [NSMutableString stringWithFormat:@"%@", odd];
            [(NSMutableString *)oddInfoName insertString:@":" atIndex:1];
        }
    }else if ([betType rangeOfString:@"03"].location != NSNotFound && [_gameId isEqualToString:@"T52"])//胜分差
    {
        oddInfoName = [YZTool bBshengfenDic][odd];
    }else if ([betType rangeOfString:@"04"].location != NSNotFound && [_gameId isEqualToString:@"T51"])//进球数
    {
        oddInfoName = [NSString stringWithFormat:@"%@", odd];
    }else if ([betType rangeOfString:@"04"].location != NSNotFound && [_gameId isEqualToString:@"T52"])//大小分
    {
        if ([odd isEqualToString:@"1"]) {
            oddInfoName = @"大分";
        }else if ([odd isEqualToString:@"2"])
        {
            oddInfoName = @"小分";
        }
    }else if ([betType rangeOfString:@"05"].location != NSNotFound && [_gameId isEqualToString:@"T51"])//半全场
    {
        oddInfoName = [NSMutableString stringWithFormat:@"%@",odd];
        oddInfoName = [oddInfoName stringByReplacingOccurrencesOfString:@"3" withString:@"胜"];
        oddInfoName = [oddInfoName stringByReplacingOccurrencesOfString:@"1" withString:@"平"];
        oddInfoName = [oddInfoName stringByReplacingOccurrencesOfString:@"0" withString:@"负"];
    }
    return oddInfoName;
}

@end
