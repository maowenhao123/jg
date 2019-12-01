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

#pragma mark - 篮球
- (void)setBbTermValue:(NSDictionary *)termValue
{
    NSString * winningNumber = termValue[@"winningNumber"];
    
    //球队信息
    NSString *week = [YZDateTool getWeekFromDateString:[termValue[@"code"] substringToIndex:8] format:@"yyyyMMdd"];
    week = [week stringByReplacingOccurrencesOfString:@"星期" withString:@"周"];
    NSString * message = [NSString stringWithFormat:@"%@%@", week, [termValue[@"code"] substringWithRange:NSMakeRange(9, 3)]];
    NSArray *detailInfos = [termValue[@"detailInfo"] componentsSeparatedByString:@"|"];
    NSString * teamName1 = detailInfos[0];
    NSString * teamName2 = detailInfos[1];
    if (!YZStringIsEmpty(winningNumber)) {//开奖后的
        _haveLottery = YES;
        //分数
        NSArray * matchResults = [winningNumber componentsSeparatedByString:@";"];
        for (NSString * matchResult in matchResults) {
            //总比分
            if ([matchResult containsString:@"F|"]) {
                _score = [matchResult stringByReplacingOccurrencesOfString:@"F|" withString:@""];
            }
        }
    }else
    {
        _haveLottery = NO;
    }
    _bBTeamMessageAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@ VS %@",message,teamName1,teamName2]];
    [_bBTeamMessageAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:[_bBTeamMessageAttStr.string rangeOfString:message]];
    [_bBTeamMessageAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(7, 161, 61, 1) range:[_bBTeamMessageAttStr.string rangeOfString:@"VS"]];
    NSMutableParagraphStyle *bBTeamMessageParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    bBTeamMessageParagraphStyle.lineSpacing = 5;
    bBTeamMessageParagraphStyle.alignment = NSTextAlignmentCenter;
    [_bBTeamMessageAttStr addAttribute:NSParagraphStyleAttributeName value:bBTeamMessageParagraphStyle range:NSMakeRange(0, _bBTeamMessageAttStr.length)];
        
    //我的投注
    NSArray *betTypeOddArr = [self.codes componentsSeparatedByString:@";"];
    NSString * codeStr = @"";
    for (NSString * code_ in betTypeOddArr) {
        if ([code_ rangeOfString:termValue[@"code"]].location != NSNotFound) {
            codeStr = code_;
        }
    }
    
    _bBBetAttStr = [self getBbBetTypeOddName:codeStr winNumberCode:winningNumber];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [_bBBetAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _bBBetAttStr.length)];
    
    CGSize betLabelSize = [_bBBetAttStr boundingRectWithSize:CGSizeMake(screenWidth * 0.3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    _bBCellH = (betLabelSize.height + 15) > 60 ? (betLabelSize.height + 15) : 60;
}

- (NSMutableAttributedString *)getBbBetTypeOddName:(NSString *)code winNumberCode:(NSString *)winNumberCode
{
    NSMutableAttributedString *bBBetAttStr = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    NSArray *codes = [code componentsSeparatedByString:@"&"];
    NSArray * winNumberArray = [winNumberCode componentsSeparatedByString:@";"];//01|1
    for(NSString *aCode in codes)
    {
        NSArray *codeArray = [aCode componentsSeparatedByString:@"|"];
        NSArray *odds = [[codeArray lastObject] componentsSeparatedByString:@","];//投注
        NSString *betType = [codeArray firstObject];//玩法
        for (NSString * odd in odds) {
            if ([betType isEqualToString:@"01"]) {
                NSString *winNumberPlayType;//玩法
                NSString *winNumberResults;//赛果
                for (NSString * winNumberCodeStr in winNumberArray) {
                    if ([winNumberCodeStr rangeOfString:[NSString stringWithFormat:@"%@|",betType]].location != NSNotFound)//对应的赢球号码
                    {
                        NSArray *winNumberStrCodes = [winNumberCodeStr componentsSeparatedByString:@"|"];
                        winNumberPlayType = [winNumberStrCodes firstObject];//玩法
                        winNumberResults = [winNumberStrCodes lastObject];//赛果
                    }
                }
                
                NSMutableString *bBBetStr = [NSMutableString string];
                if ([odd isEqualToString:@"1"]) {
                    [bBBetStr appendFormat:@"让分主胜\n"];
                }else if ([odd isEqualToString:@"2"])
                {
                    [bBBetStr appendFormat:@"让分客胜\n"];
                }
                
                NSMutableAttributedString * betCodeAttStr = [[NSMutableAttributedString alloc] initWithString:bBBetStr];
                if ([winNumberPlayType isEqualToString:betType] && [winNumberResults isEqualToString:odd]) {//如果中间,变为红色
                    [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, betCodeAttStr.length)];
                }else
                {
                    [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, betCodeAttStr.length)];
                }
                [bBBetAttStr appendAttributedString:betCodeAttStr];
            }else if ([betType isEqualToString:@"02"])
            {
                NSString *winNumberPlayType;//玩法
                NSString *winNumberResults;//赛果
                for (NSString * winNumberCodeStr in winNumberArray) {
                    if ([winNumberCodeStr rangeOfString:[NSString stringWithFormat:@"%@|",betType]].location != NSNotFound)//对应的赢球号码
                    {
                        NSArray *winNumberStrCodes = [winNumberCodeStr componentsSeparatedByString:@"|"];
                        winNumberPlayType = [winNumberStrCodes firstObject];//玩法
                        winNumberResults = [winNumberStrCodes lastObject];//赛果
                    }
                }
                
                NSMutableString *bBBetStr = [NSMutableString string];
                if ([odd isEqualToString:@"1"]) {
                    [bBBetStr appendFormat:@"主胜\n"];
                }else if ([odd isEqualToString:@"2"])
                {
                    [bBBetStr appendFormat:@"客胜\n"];
                }
                
                NSMutableAttributedString * betCodeAttStr = [[NSMutableAttributedString alloc] initWithString:bBBetStr];
                if ([winNumberPlayType isEqualToString:betType] && [winNumberResults isEqualToString:odd]) {//如果中间,变为红色
                    [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, betCodeAttStr.length)];
                }else
                {
                    [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, betCodeAttStr.length)];
                }
                [bBBetAttStr appendAttributedString:betCodeAttStr];
            }else if ([betType isEqualToString:@"03"])
            {
                NSString *winNumberPlayType;//玩法
                NSString *winNumberResults;//赛果
                for (NSString * winNumberCodeStr in winNumberArray) {
                    if ([winNumberCodeStr rangeOfString:[NSString stringWithFormat:@"%@|",betType]].location != NSNotFound)//对应的赢球号码
                    {
                        NSArray *winNumberStrCodes = [winNumberCodeStr componentsSeparatedByString:@"|"];
                        winNumberPlayType = [winNumberStrCodes firstObject];//玩法
                        winNumberResults = [winNumberStrCodes lastObject];//赛果
                    }
                }
                
                NSMutableString *bBBetStr = [NSMutableString string];
                [bBBetStr appendFormat:@"%@\n", [YZTool bBshengfenDic][odd]];
                
                NSMutableAttributedString * betCodeAttStr = [[NSMutableAttributedString alloc] initWithString:bBBetStr];
                if ([winNumberPlayType isEqualToString:betType] && [winNumberResults isEqualToString:odd]) {//如果中间,变为红色
                    [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, betCodeAttStr.length)];
                }else
                {
                    [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, betCodeAttStr.length)];
                }
                [bBBetAttStr appendAttributedString:betCodeAttStr];
            }else if ([betType isEqualToString:@"04"])
            {
                NSString *winNumberPlayType;//玩法
                NSString *winNumberResults;//赛果
                for (NSString * winNumberCodeStr in winNumberArray) {
                    if ([winNumberCodeStr rangeOfString:[NSString stringWithFormat:@"%@|",betType]].location != NSNotFound)//对应的赢球号码
                    {
                        NSArray *winNumberStrCodes = [winNumberCodeStr componentsSeparatedByString:@"|"];
                        winNumberPlayType = [winNumberStrCodes firstObject];//玩法
                        winNumberResults = [winNumberStrCodes lastObject];//赛果
                    }
                }
                
                NSMutableString *bBBetStr = [NSMutableString string];
                if ([odd isEqualToString:@"1"]) {
                    [bBBetStr appendFormat:@"大分\n"];
                }else if ([odd isEqualToString:@"2"])
                {
                    [bBBetStr appendFormat:@"小分\n"];
                }
                
                NSMutableAttributedString * betCodeAttStr = [[NSMutableAttributedString alloc] initWithString:bBBetStr];
                if ([winNumberPlayType isEqualToString:betType] && [winNumberResults isEqualToString:odd]) {//如果中间,变为红色
                    [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, betCodeAttStr.length)];
                }else
                {
                    [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, betCodeAttStr.length)];
                }
                [bBBetAttStr appendAttributedString:betCodeAttStr];
            }
        }
    }
    
    return bBBetAttStr;
}
#pragma mark - 足球
- (void)setTermValue:(NSDictionary *)termValue
{
    if ([_gameId isEqualToString:@"T52"]) {
        [self setBbTermValue:termValue];
        return;
    }
    NSString * winningNumber = termValue[@"winningNumber"];
    
    //球队信息
    NSString *week = [YZDateTool getWeekFromDateString:[termValue[@"code"] substringToIndex:8] format:@"yyyyMMdd"];
    week = [week stringByReplacingOccurrencesOfString:@"星期" withString:@"周"];
    NSArray *detailInfos = [termValue[@"detailInfo"] componentsSeparatedByString:@"|"];
    NSString * teamName1 = detailInfos[0];
    NSString * teamName2 = detailInfos[1];
    if (winningNumber.length > 0) {//开奖后的
        _haveLottery = YES;
        NSRange range = [winningNumber rangeOfString:@"F|"];
        NSString *bifen = [winningNumber substringWithRange:NSMakeRange(range.location + 2, 3)];
        if (bifen.length > 0) {
            NSString *teamMessageStr = [NSString stringWithFormat:@"%@\n%@ %@ %@",week,teamName1,bifen,teamName2];
            NSMutableAttributedString * teamMessage = [[NSMutableAttributedString alloc]initWithString:teamMessageStr];
            NSRange range_bifen = [teamMessageStr rangeOfString:bifen];
            [teamMessage addAttribute:NSForegroundColorAttributeName value:YZColor(7, 161, 61, 1) range:range_bifen];//比分为绿色
            _teamMessage = teamMessage;
        }else
        {
            _teamMessage = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@ VS %@",week,teamName1,teamName2]];
        }
    }else
    {
        _haveLottery = NO;
        _teamMessage = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@\n%@ VS %@",week,teamName1,teamName2]];
    }
    
    //赛果
    NSArray *betTypeOddArr = [self.codes componentsSeparatedByString:@";"];
    NSString * codeStr = @"";
    for (NSString * code_ in betTypeOddArr) {
        if ([code_ rangeOfString:termValue[@"code"]].location != NSNotFound) {
            codeStr = code_;
        }
    }
    _resultsArray = [self getResultsArrayByWinNumber:winningNumber andCode:codeStr];

    //我的投注
    _betArray = [self getFbBetTypeOddName:codeStr winNumberCode:winningNumber];
    
    //cell高度
    CGFloat cellH = 0;
    for (NSAttributedString * codeAttStr in [self getFbBetTypeOddName:codeStr winNumberCode:winningNumber]) {
        CGSize size = [codeAttStr boundingRectWithSize:CGSizeMake(screenWidth * 0.3, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        cellH += size.height + 2 * 5;
    }
    _cellH = cellH > 55 ? cellH : 55;
}

#pragma mark - 获取赛果数组
//code 02|201606072101|3,1,0&01|201606072101|3,1,0&05|201606072101|33,31,30,13,11,10,03,01,00
//winNum winningNumber = "01|0;02|0;03|09;04|7;05|00;R|-1.0;H|0:1;F|3:4";
- (NSMutableArray *)getResultsArrayByWinNumber:(NSString *)winNumber andCode:(NSString *)code
{
    NSMutableArray *resultsArray = [NSMutableArray array];
    NSArray * codeArray = [code componentsSeparatedByString:@"&"];//02|201606072101|3,1,0
    NSArray * winNumberArray = [winNumber componentsSeparatedByString:@";"];
    for (NSString * codeString in codeArray) {
        NSArray * codeArr = [codeString componentsSeparatedByString:@"|"];
        NSString * playTypeStr = codeArr[0];//02
        for (NSString * winNumberCode in winNumberArray) {
            if ([winNumberCode rangeOfString:[NSString stringWithFormat:@"%@|",playTypeStr]].location != NSNotFound){
                NSString * winNumberStr = [self getWinNumberStrByWinNumberCode:winNumberCode];
                [resultsArray addObject:winNumberStr];
            }
        }
    }
    return resultsArray;
}
//winNumberCode:01|0
- (NSString *)getWinNumberStrByWinNumberCode:(NSString *)winNumberCode
{
    NSString *winNumberStr;
    NSArray *winNumberCodes = [winNumberCode componentsSeparatedByString:@"|"];
    NSString *winNumberPlayType = [winNumberCodes firstObject];//玩法
    NSString *winNumberResults = [winNumberCodes lastObject];//赛果
    if ([winNumberPlayType rangeOfString:@"01"].location != NSNotFound || [winNumberPlayType rangeOfString:@"02"].location != NSNotFound) {
        NSString *betTypeName = @"";
        if([winNumberPlayType rangeOfString:@"01"].location != NSNotFound)//玩法
        {
            betTypeName = @"让球";
        }
        NSString *oddInfoName;
        if([winNumberResults isEqualToString:@"3"])//
        {
            oddInfoName = @"胜";
        }else if([winNumberResults isEqualToString:@"1"])
        {
            oddInfoName = @"平";
        }else if([winNumberResults isEqualToString:@"0"])
        {
            oddInfoName = @"负";
        }
        winNumberStr = [NSString stringWithFormat:@"%@%@",betTypeName,oddInfoName];
    }else if ([winNumberPlayType rangeOfString:@"03"].location != NSNotFound)//比分
    {
        NSString *oddInfoName = nil;
        if ([winNumberResults isEqualToString:@"90"]) {
            oddInfoName = @"胜其他";
        }else if ([winNumberResults isEqualToString:@"99"]) {
            oddInfoName = @"平其他";
        }else if ([winNumberResults isEqualToString:@"09"]) {
            oddInfoName = @"负其他";
        }else
        {
            oddInfoName = [NSMutableString stringWithFormat:@"%@",winNumberResults];
            [(NSMutableString *)oddInfoName insertString:@":" atIndex:1];
        }
        winNumberStr = oddInfoName;
    }else if ([winNumberPlayType rangeOfString:@"04"].location != NSNotFound)//进球数
    {
        winNumberStr = winNumberResults;
    }else if ([winNumberPlayType rangeOfString:@"05"].location != NSNotFound)//半全场
    {
        NSString * oddInfoName = [NSMutableString stringWithFormat:@"%@",winNumberResults];
        oddInfoName = [oddInfoName stringByReplacingOccurrencesOfString:@"3" withString:@"胜"];
        oddInfoName = [oddInfoName stringByReplacingOccurrencesOfString:@"1" withString:@"平"];
        oddInfoName = [oddInfoName stringByReplacingOccurrencesOfString:@"0" withString:@"负"];
        winNumberStr = winNumberResults;
    }
    return winNumberStr;
}
#pragma mark - 获取投注数组
//code格式：02|201501084001|3&02|201501084002|3,1
- (NSMutableArray *)getFbBetTypeOddName:(NSString *)code winNumberCode:(NSString *)winNumberCode
{
    NSMutableArray *muArr = [NSMutableArray array];
    NSArray *codes = [code componentsSeparatedByString:@"&"];
    for(NSString *aCode in codes)
    {
        NSMutableAttributedString *codeStr = [self getAFbBetTypeOddName:aCode winNumberCode:winNumberCode];
        [muArr addObject:codeStr];
    }
    return  muArr;
}
- (NSMutableAttributedString *)getAFbBetTypeOddName:(NSString *)acode winNumberCode:(NSString *)winNumberCode
{
    NSArray *codeArray = [acode componentsSeparatedByString:@"|"];
    NSArray *odds = [[codeArray lastObject] componentsSeparatedByString:@","];//投注
    NSString *betType = [codeArray firstObject];//玩法
    NSArray * winNumberArray = [winNumberCode componentsSeparatedByString:@";"];//01|3
    if ([betType rangeOfString:@"01"].location != NSNotFound || [betType rangeOfString:@"02"].location != NSNotFound) {
        NSString *winNumberPlayType;//玩法
        NSString *winNumberResults;//赛果
        for (NSString * winNumberCodeStr in winNumberArray) {
            if ([winNumberCodeStr rangeOfString:[NSString stringWithFormat:@"%@|",betType]].location != NSNotFound)//对应的赢球号码
                 {
                     NSArray *winNumberStrCodes = [winNumberCodeStr componentsSeparatedByString:@"|"];
                     winNumberPlayType = [winNumberStrCodes firstObject];//玩法
                     winNumberResults = [winNumberStrCodes lastObject];//赛果
            }
        }
        NSString *playTypeStr;
        NSString *betTypeName = @"";
        if([betType rangeOfString:@"01"].location != NSNotFound)//让球
        {
            betTypeName = @"让球";
            playTypeStr = @"[让球胜平负]\n";
        }else
        {
            playTypeStr = @"[胜平负]\n";
        }
        NSMutableAttributedString * codeAttStr = [[NSMutableAttributedString alloc]initWithString:playTypeStr];//我的投注富文本
        [codeAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, playTypeStr.length)];//玩法字体灰色
        for(NSString *odd in odds)
        {
            NSString *oddInfoName = nil;
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
            NSString *temp = [NSString stringWithFormat:@"%@%@",betTypeName,oddInfoName];
            NSString * betCodeStr;
            if (odd == [odds lastObject]) {
                betCodeStr = [NSString stringWithFormat:@"%@",temp];
            }else
            {
                betCodeStr = [NSString stringWithFormat:@"%@\n",temp];
            }
            NSMutableAttributedString * betCodeAttStr = [[NSMutableAttributedString alloc]initWithString:betCodeStr];
            
            if ([winNumberPlayType isEqualToString:betType] && [winNumberResults isEqualToString:odd]) {//如果中间,变为红色
                [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, betCodeAttStr.length)];
            }else
            {
                [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, betCodeAttStr.length)];
            }
            [codeAttStr appendAttributedString:betCodeAttStr];
        }
        return codeAttStr;
    }else if ([betType rangeOfString:@"03"].location != NSNotFound)//比分
    {
        NSString *winNumberPlayType;//玩法
        NSString *winNumberResults;//赛果
        for (NSString * winNumberCodeStr in winNumberArray) {
            if ([winNumberCodeStr rangeOfString:[NSString stringWithFormat:@"%@|",betType]].location != NSNotFound)//对应的赢球号码
            {
                NSArray *winNumberStrCodes = [winNumberCodeStr componentsSeparatedByString:@"|"];
                winNumberPlayType = [winNumberStrCodes firstObject];//玩法
                winNumberResults = [winNumberStrCodes lastObject];//赛果
            }
        }

        NSString *codePlayTypeStr = @"[比分]\n";
        NSMutableAttributedString * codeAttStr = [[NSMutableAttributedString alloc]initWithString:codePlayTypeStr];//我的投注富文本
        [codeAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, codePlayTypeStr.length)];//玩法字体灰色
        for (NSString *odd in odds) {
            NSString *oddInfoName = nil;
            if ([odd isEqualToString:@"90"]) {
                oddInfoName = @"胜其他";
            }else if ([odd isEqualToString:@"99"]) {
                oddInfoName = @"平其他";
            }else if ([odd isEqualToString:@"09"]) {
                oddInfoName = @"负其他";
            }else
            {
                oddInfoName = [NSMutableString stringWithFormat:@"%@",odd];
                [(NSMutableString *)oddInfoName insertString:@":" atIndex:1];
            }
            NSString * betCodeStr;
            if (odd == [odds lastObject]) {
                betCodeStr = [NSString stringWithFormat:@"%@",oddInfoName];
            }else
            {
                betCodeStr =[NSString stringWithFormat:@"%@\n",oddInfoName];
            }
            NSMutableAttributedString * betCodeAttStr = [[NSMutableAttributedString alloc]initWithString:betCodeStr];
            if ([winNumberPlayType isEqualToString:betType] && [winNumberResults isEqualToString:odd]) {//如果中间,变为红色
                [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, betCodeAttStr.length)];
            }else
            {
                [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, betCodeAttStr.length)];
            }
            [codeAttStr appendAttributedString:betCodeAttStr];
        }
        return codeAttStr;
    }else if ([betType rangeOfString:@"04"].location != NSNotFound)//进球数
    {
        NSString *winNumberPlayType;//玩法
        NSString *winNumberResults;//赛果
        for (NSString * winNumberCodeStr in winNumberArray) {
            if ([winNumberCodeStr rangeOfString:[NSString stringWithFormat:@"%@|",betType]].location != NSNotFound)//对应的赢球号码
            {
                NSArray *winNumberStrCodes = [winNumberCodeStr componentsSeparatedByString:@"|"];
                winNumberPlayType = [winNumberStrCodes firstObject];//玩法
                winNumberResults = [winNumberStrCodes lastObject];//赛果
            }
        }

        NSString *codePlayTypeStr = @"[进球数]\n";
        NSMutableAttributedString * codeAttStr = [[NSMutableAttributedString alloc]initWithString:codePlayTypeStr];//我的投注富文本
        [codeAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, codePlayTypeStr.length)];//玩法字体灰色
        for (NSString *odd in odds) {
            NSString * betCodeStr;
            if (odd == [odds lastObject]) {
                betCodeStr = [NSString stringWithFormat:@"%@",odd];
            }else
            {
                betCodeStr =[NSString stringWithFormat:@"%@\n",odd];
            }
            NSMutableAttributedString * betCodeAttStr = [[NSMutableAttributedString alloc]initWithString:betCodeStr];
            if ([winNumberPlayType isEqualToString:betType] && [winNumberResults isEqualToString:odd]) {//如果中间,变为红色
                [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, betCodeAttStr.length)];
            }else
            {
                [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, betCodeAttStr.length)];
            }
            [codeAttStr appendAttributedString:betCodeAttStr];
        }
        return codeAttStr;
    }else if ([betType rangeOfString:@"05"].location != NSNotFound)//半全场
    {
        NSString *winNumberPlayType;//玩法
        NSString *winNumberResults;//赛果
        for (NSString * winNumberCodeStr in winNumberArray) {
            if ([winNumberCodeStr rangeOfString:[NSString stringWithFormat:@"%@|",betType]].location != NSNotFound)//对应的赢球号码
            {
                NSArray *winNumberStrCodes = [winNumberCodeStr componentsSeparatedByString:@"|"];
                winNumberPlayType = [winNumberStrCodes firstObject];//玩法
                winNumberResults = [winNumberStrCodes lastObject];//赛果
            }
        }

        NSString *codePlayTypeStr = @"[半全场]\n";
        NSMutableAttributedString * codeAttStr = [[NSMutableAttributedString alloc]initWithString:codePlayTypeStr];//我的投注富文本
        [codeAttStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(0, codePlayTypeStr.length)];//玩法字体灰色
        for (NSString *odd in odds) {
            NSString * oddInfoName = [NSMutableString stringWithFormat:@"%@",odd];
            oddInfoName = [oddInfoName stringByReplacingOccurrencesOfString:@"3" withString:@"胜"];
            oddInfoName = [oddInfoName stringByReplacingOccurrencesOfString:@"1" withString:@"平"];
            oddInfoName = [oddInfoName stringByReplacingOccurrencesOfString:@"0" withString:@"负"];
            
            NSString * betCodeStr;
            if (odd == [odds lastObject]) {
                betCodeStr = [NSString stringWithFormat:@"%@",oddInfoName];
            }else
            {
                betCodeStr =[NSString stringWithFormat:@"%@\n",oddInfoName];
            }
            NSMutableAttributedString * betCodeAttStr = [[NSMutableAttributedString alloc]initWithString:betCodeStr];
            if ([winNumberPlayType isEqualToString:betType] && [winNumberResults isEqualToString:odd]) {//如果中间,变为红色
                [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:NSMakeRange(0, betCodeAttStr.length)];
            }else
            {
                [betCodeAttStr addAttribute:NSForegroundColorAttributeName value:YZBlackTextColor range:NSMakeRange(0, betCodeAttStr.length)];
            }
            [codeAttStr appendAttributedString:betCodeAttStr];
        }
        return codeAttStr;
    }
    return nil;
}
#pragma mark - 是否有让球胜平负
- (BOOL)haveRangWithCode:(NSString *)code
{
    NSArray *codes = [code componentsSeparatedByString:@"&"];
    for(NSString *aCode in codes)
    {
        NSArray *codeArray = [aCode componentsSeparatedByString:@"|"];
        NSString *betType = [codeArray firstObject];//玩法
        if([betType rangeOfString:@"01"].location != NSNotFound)//让球
        {
            return YES;
        }
    }
    return NO;
}
@end
