//
//  YZFCOrderDetailStatus.m
//  ez
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define textPadding 7

#import "YZFCOrderDetailStatus.h"

@implementation YZFCOrderDetailStatus

- (void)setOrder:(YZOrder *)order
{
    _order = order;
}
- (void)setTicketList:(YZTicketList *)ticketList
{
    _ticketList = ticketList;
    NSString *numbers =  ticketList.numbers;
    NSArray *numberArr = [numbers componentsSeparatedByString:@";"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] init];
    for(NSString *str in numberArr)
    {
        YZLog(@"length = %ld",(unsigned long)str.length);
        NSMutableString *muStr = [NSMutableString string];
        NSString *playBetName = [self getPlayBetNameWithGameId:ticketList.gameId playType:ticketList.playType betType:ticketList.betType];
        [muStr appendString:[NSString stringWithFormat:@"%@ [%@]\n",str,playBetName]];
        muStr = [[muStr stringByReplacingOccurrencesOfString:@"," withString:@" "] mutableCopy];
        muStr = [[muStr stringByReplacingOccurrencesOfString:@"|" withString:@" | "] mutableCopy];
                
        NSMutableAttributedString *attStr_ = [[NSMutableAttributedString alloc] initWithString:muStr];
        //中奖号码变色
        if (_order.winNumber.length > 0) {//开奖后
            YZLog(@"winNumber:%@",_order.winNumber);
            if ([_order.gameId isEqualToString:@"T01"] || [_order.gameId isEqualToString:@"F01"]){//双色球、大乐透
                NSArray * winNumberDTStrArr = [_order.winNumber componentsSeparatedByString:@"|"];
                NSArray * codeDTStrArr = [muStr componentsSeparatedByString:@"|"];
                if (winNumberDTStrArr.count == 2 && codeDTStrArr.count == 2) {
                    for (int i = 0; i < 2; i++) {
                        NSString * codeDTStr = codeDTStrArr[i];
                        NSString * winNumberStr = [[winNumberDTStrArr[i] stringByReplacingOccurrencesOfString:@"|" withString:@","] mutableCopy];
                        winNumberStr = [[winNumberStr stringByReplacingOccurrencesOfString:@"&" withString:@","] mutableCopy];
                        NSArray * winNumbrStrArr = [winNumberStr componentsSeparatedByString:@","];
                        for (NSString * winNumber in winNumbrStrArr) {
                            if ([codeDTStr rangeOfString:winNumber].location != NSNotFound) {//有获奖球
                                for (id object in [self getRangesByString:codeDTStr keyword:winNumber]) {
                                    NSRange range = [object rangeValue];
                                    if (i == 0) {//红球
                                        [attStr_ addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:range];
                                    }else//篮球
                                    {
                                        NSString * codeDStr = codeDTStrArr[0];
                                        [attStr_ addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(codeDStr.length + 1 + range.location, range.length)];
                                    }
                                }
                            }
                        }
                    }
                }
            }else if ([_order.gameId isEqualToString:@"F03"])//七乐彩
            {
                NSArray * winNumberDTStrArr = [_order.winNumber componentsSeparatedByString:@"|"];
                NSString * redWinberStr = winNumberDTStrArr.firstObject;
                NSString * blueWinberStr = winNumberDTStrArr.lastObject;
                NSString * winNumberStr = [[_order.winNumber stringByReplacingOccurrencesOfString:@"|" withString:@","] mutableCopy];
                winNumberStr = [[winNumberStr stringByReplacingOccurrencesOfString:@"&" withString:@","] mutableCopy];
                NSArray * winNumbrStrArr = [winNumberStr componentsSeparatedByString:@","];
                for (NSString * winNumber in winNumbrStrArr) {
                    if ([redWinberStr rangeOfString:winNumber].location != NSNotFound) {//有获奖红球
                        for (id object in [self getRangesByString:muStr keyword:winNumber]) {
                            if ([winNumberDTStrArr containsObject:winNumber]) {
                                
                            }
                            [attStr_ addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:[object rangeValue]];
                        }
                    }else if ([blueWinberStr rangeOfString:winNumber].location != NSNotFound) {//有获奖蓝球
                        for (id object in [self getRangesByString:muStr keyword:winNumber]) {
                            if ([winNumberDTStrArr containsObject:winNumber]) {
                                
                            }
                            [attStr_ addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:[object rangeValue]];
                        }
                    }
                }
            }else if ([muStr rangeOfString:@"和值"].location != NSNotFound)//和值
            {
                NSString * winNumberStr = [[_order.winNumber stringByReplacingOccurrencesOfString:@"|" withString:@","] mutableCopy];
                winNumberStr = [[winNumberStr stringByReplacingOccurrencesOfString:@"&" withString:@","] mutableCopy];
                NSArray * winNumbrStrArr = [winNumberStr componentsSeparatedByString:@","];
                int winNumberSum = 0;//和值
                for (NSString * winNumber in winNumbrStrArr) {
                    winNumberSum += [winNumber intValue];
                }
                NSString * winNumberSumStr = [NSString stringWithFormat:@"%d",winNumberSum];
                if ([muStr rangeOfString:winNumberSumStr].location != NSNotFound) {//有获奖球
                    for (id object in [self getRangesByString:muStr keyword:winNumberSumStr]) {
                        [attStr_ addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:[object rangeValue]];
                    }
                }
            }else if ([_order.gameId isEqualToString:@"T53"] || [_order.gameId isEqualToString:@"T54"])//胜负彩 四场进球
            {
                NSArray * winNumbrStrArr = [_order.winNumber componentsSeparatedByString:@"|"];
                NSArray *numbersStrArr = [_ticketList.numbers componentsSeparatedByString:@"|"];
                NSMutableArray * ranges = [NSMutableArray array];
                if (winNumbrStrArr.count == numbersStrArr.count) {
                    for (int i = 0; i < winNumbrStrArr.count; i++) {
                        NSString * winNumberStr = winNumbrStrArr[i];
                        NSString * numbersStr = numbersStrArr[i];
                        if ([numbersStr isEqualToString:winNumberStr]) {
                            NSRange range = NSMakeRange(i * 4, 1);
                            [ranges addObject:[NSValue valueWithRange:range]];
                        }
                    }
                }
                for (id object in ranges) {
                    [attStr_ addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:[object rangeValue]];
                }
            }else
            {
                NSString * winNumberStr = [[_order.winNumber stringByReplacingOccurrencesOfString:@"|" withString:@","] mutableCopy];
                winNumberStr = [[winNumberStr stringByReplacingOccurrencesOfString:@"&" withString:@","] mutableCopy];
                NSArray * winNumbrStrArr = [winNumberStr componentsSeparatedByString:@","];
                for (NSString * winNumber in winNumbrStrArr) {
                    if ([muStr rangeOfString:winNumber].location != NSNotFound) {//有获奖球
                        for (id object in [self getRangesByString:muStr keyword:winNumber]) {
                            [attStr_ addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:[object rangeValue]];
                        }
                    }
                }
            }
        }
        [attStr appendAttributedString:attStr_];
    }
    //倍数和注数
    NSNumber *multiple = ticketList.multiple;
    NSNumber *count = ticketList.count;
    NSString * statusDesc = ticketList.statusDesc;
    
    NSString * betMessageStr = [NSString stringWithFormat:@"倍数:%d倍 注数:%d注 %@",[multiple intValue],[count intValue],statusDesc];
    if (YZStringIsEmpty(statusDesc)) {
        betMessageStr = [NSString stringWithFormat:@"倍数:%d倍 注数:%d注",[multiple intValue],[count intValue]];
    }
    NSMutableAttributedString * betMessageAttStr = [[NSMutableAttributedString alloc]initWithString:betMessageStr];
    [betMessageAttStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(betMessageAttStr.length - statusDesc.length, statusDesc.length)];
    [attStr appendAttributedString:betMessageAttStr];
    //设置文字格式
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:textPadding];
    [paragraphStyle setFirstLineHeadIndent:textPadding];
    [paragraphStyle setHeadIndent:textPadding];
    NSDictionary *attDict = @{NSParagraphStyleAttributeName : paragraphStyle};
    [attStr addAttributes:attDict range:NSMakeRange(0, attStr.length)];
    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(26)] range:NSMakeRange(0, attStr.length)];
    _betNumber = attStr;
    
    CGSize ticketLabelSize = [attStr boundingRectWithSize:CGSizeMake(screenWidth - 2 * 12, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
    _cellH = ticketLabelSize.height + 2 * 12;
}
- (NSMutableArray *)getRangesByString:(NSString *)string keyword:(NSString *)keyword
{
    NSMutableArray * ranges = [NSMutableArray array];
    NSRange range_last = NSMakeRange(0, 0);
    while ([string rangeOfString:keyword options:NSCaseInsensitiveSearch range:NSMakeRange(range_last.location + range_last.length, string.length - (range_last.location + range_last.length))].location != NSNotFound) {//从上一个的末尾
        NSRange range = [string rangeOfString:keyword options:NSCaseInsensitiveSearch range:NSMakeRange(range_last.location + range_last.length, string.length - (range_last.location + range_last.length))];
        [ranges addObject:[NSValue valueWithRange:range]];
        range_last = range;
    }
    return ranges;
}
- (NSString *)getPlayBetNameWithGameId:(NSString *)gameId playType:(NSString *)playType betType:(NSString *)betType
{
    NSString *playName = [YZTool playTypeName][gameId][playType];
    NSString *betName = [YZTool betTypeNameDict][betType];
    
    NSString *playBetName = [NSString stringWithFormat:@"%@%@", playName, betName];
    
    return playBetName;
}
@end
