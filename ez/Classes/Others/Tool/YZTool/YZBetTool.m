//
//  YZBetTool.m
//  ez
//
//  Created by apple on 16/5/11.
//  Copyright (c) 2016年 9ge. All rights reserved.
//

#import "YZBetTool.h"
#import "YZBetStatus.h"
#import "YZStatusCacheTool.h"
#import "YZCommitTool.h"

@implementation YZBetTool

#pragma  mark - 机选号码
+ (void)autoChoose11x5WithPlayType:(NSString *)playType andSelectedPlayTypeBtnTag:(int)tag//11选5
{
    NSArray * minSelCountArray = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8",  @"1", @"2", @"1", @"3", @"22", @"23", @"24", @"25", @"26", @"27", @"29", @"31"];
    NSArray * playTypeBtnTitles = @[@"任选一",@"任选二", @"任选三", @"任选四", @"任选五", @"任选六", @"任选七", @"任选八",  @"前二直选", @"前二组选", @"前三直选", @"前三组选", @"任选二", @"任选三", @"任选四", @"任选五", @"任选六", @"任选七", @"前二组选", @"前三组选"];
    if(tag >= 12) return;
    //随机号码
    int minSelCount = [minSelCountArray[tag] intValue];
    if(tag == 8)//前二直选、前三直选
    {
        minSelCount = 2;
    }else if (tag == 10)
    {
        minSelCount = 3;
    }
    NSMutableSet *randomSet = [NSMutableSet set];
    while (randomSet.count < minSelCount)
    {
        int random = arc4random() % 11 + 1;
        [randomSet addObject:@(random)];
    }
    NSMutableArray *muArr = [[NSMutableArray alloc] initWithArray:[randomSet allObjects]];
    NSMutableString *muStr = [self getNumbersStringWithArray:muArr tag:tag];
    [muStr appendString:[NSString stringWithFormat:@"[%@单式1注]",playTypeBtnTitles[tag]]];
    //拼接完字符串后加颜色
    NSRange range = [muStr rangeOfString:@"["];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:muStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range.location)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range.location, muStr.length-range.location)];
    
    YZBetStatus *status = [[YZBetStatus alloc] init];
    status.labelText = attStr;
    status.betCount = 1;
    status.betType = @"00";
    CGSize labelSize = [muStr sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
    status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
    status.playType = playType;
    //存储一组号码数据
    [YZStatusCacheTool saveStatus:status];
}
//对球号码进行排序、加逗号
+ (NSMutableString *)getNumbersStringWithArray:(NSMutableArray *)muArr tag:(int)tag
{
    NSMutableString *str = [NSMutableString string];
    muArr = [self sortBallsArray:muArr];
    for(NSNumber *num in muArr)
    {
        NSString *dou = @",";
        if(tag == 8 || tag == 10)//前二直选、前三直选
        {
            dou = @"|";
        }
        [str appendFormat:@"%02d%@",[num intValue],dou];
    }
    [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
    return str;
}
//冒泡排序球数组
+ (NSMutableArray *)sortBallsArray:(NSMutableArray *)mutableArray
{
    if(mutableArray.count == 1) return mutableArray;
    for(int i = 0;i < mutableArray.count;i++)
    {
        for(int j = i + 1;j <mutableArray.count;j++)
        {
            NSNumber *num1 = mutableArray[i];
            NSNumber *num2= mutableArray[j];
            if([num1 intValue] > [num2 intValue])
            {
                [mutableArray replaceObjectAtIndex:i withObject:num2];
                [mutableArray replaceObjectAtIndex:j withObject:num1];
            }
        }
    }
    return mutableArray;
}

+ (void)autoChooseKy481WithPlayType:(NSString *)playType andSelectedPlayTypeBtnTag:(int)tag//快赢481
{
    NSArray * playTypes = @[@"任选一", @"任选二", @"任选三", @"任选二全包", @"任选二万能两码", @"任选三全包", @"直选", @"组选4", @"组选6", @"组选12", @"组选24", @"三不重", @"三不重", @"二带一单式", @"二带一包单", @"二带一包对", @"二带一包号", @"包2", @"包3", @"豹子", @"形态", @"拖拉机"];
    
    NSMutableString *muStr = [NSMutableString string];
    int betCount = 1;
    if (tag == 0 || tag == 1 || tag == 2 || tag == 6) {
        int number = tag + 1;
        if (tag == 6) {
            number = 4;
        }
        for (int i = 0; i < number; i++) {
            int random = arc4random() % 8 + 1;
            [muStr appendFormat:@"%d|", random];
        }
        while (muStr.length < 8) {
            [muStr appendFormat:@"_|"];
        }
    }else if (tag == 3 || tag == 4 || tag == 5)
    {
        int number = 2;
        if (tag == 5) {
            number = 3;
        }
        for (int i = 0; i < number; i++) {
            int random = arc4random() % 8 + 1;
            [muStr appendFormat:@"%d,", random];
        }
    }else if (tag == 7 || tag == 8 || tag == 9 || tag == 10)
    {
        NSMutableSet *randomSet = [NSMutableSet set];
        while (randomSet.count < 5)
        {
            int random = arc4random() % 8 + 1;
            [randomSet addObject:@(random)];
        }
        NSMutableArray *muArr = [[NSMutableArray alloc] initWithArray:[randomSet allObjects]];
        int number1 = [muArr[0] intValue];
        int number2 = [muArr[1] intValue];
        int number3 = [muArr[2] intValue];
        int number4 = [muArr[3] intValue];
        if (tag == 7) {
            [muStr appendFormat:@"%d,%d,%d,%d,", number1, number2, number1, number1];
        }else if (tag == 8)
        {
            [muStr appendFormat:@"%d,%d,%d,%d,", number1, number1, number2, number2];
        }else if (tag == 9)
        {
            [muStr appendFormat:@"%d,%d,%d,%d,", number1, number2, number3, number3];
        }else if (tag == 10)
        {
            [muStr appendFormat:@"%d,%d,%d,%d,", number1, number2, number3, number4];
        }
    }else if (tag == 11 || tag == 12 || tag == 14 || tag == 15 || tag == 16 || tag == 17 || tag == 18 || tag == 19)
    {
        int minCount = 0;
        if (tag == 11 || tag == 12 || tag == 18) {
            minCount = 3;
        }else if (tag == 14 || tag == 15 || tag == 16 || tag == 19)
        {
            minCount = 1;
        }else if (tag == 17)
        {
            minCount = 2;
        }
        NSMutableSet *randomSet = [NSMutableSet set];
        while (randomSet.count < minCount)
        {
            int random = arc4random() % 8 + 1;
            [randomSet addObject:@(random)];
        }
        NSMutableArray *muArr = [[NSMutableArray alloc] initWithArray:[randomSet allObjects]];
        muArr = [self sortNumberArray:muArr];
        for (NSNumber * number in muArr) {
            [muStr appendFormat:@"%@,", number];
        }
    }else if (tag == 13)
    {
        NSMutableSet *randomSet = [NSMutableSet set];
        while (randomSet.count < 2)
        {
            int random = arc4random() % 8 + 1;
            [randomSet addObject:@(random)];
        }
        NSMutableArray *muArr = [[NSMutableArray alloc] initWithArray:[randomSet allObjects]];
        int number1 = [muArr[0] intValue];
        int number2 = [muArr[1] intValue];
        [muStr appendFormat:@"%d,%d,%d,", number1, number1, number2];
    }else if (tag == 20)
    {
        int random = arc4random() % 2 + 1;
        if (random == 1) {
            [muStr appendString:@"4,"];
        }else if (random == 2)
        {
            [muStr appendString:@"6,"];
        }
    }else if (tag == 21)
    {
        [muStr appendString:@"1,"];
    }
    [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个符号
    if (tag == 3 || tag == 4 || tag == 5) {
        NSArray * numberArr = [muStr componentsSeparatedByString:@","];
        NSSet * numberSet = [NSSet setWithArray:numberArr];
        NSInteger sameCount = numberArr.count - numberSet.count;
        if (tag == 5) {
            if (sameCount == 0) {
                betCount = 24;
            }else if (sameCount == 1)
            {
                betCount = 12;
            }else if (sameCount == 1)
            {
                betCount = 4;
            }
        }else if (tag == 3 || tag == 4)
        {
            if (sameCount == 0) {
                betCount = 12;
            }else if (sameCount == 1)
            {
                betCount = 6;
            }
        }
        [muStr appendString:[NSString stringWithFormat:@"[%@%d注]", playTypes[tag], betCount]];
    }else if (tag == 13 || tag == 14 || tag == 15 || tag == 16)
    {
        if (tag == 14 || tag == 15) {
            betCount = 7;
        }else if (tag == 16)
        {
            betCount = 14;
        }
        [muStr appendString:[NSString stringWithFormat:@"[%@%d注]", playTypes[tag], betCount]];
    }else if (tag == 17)
    {
        betCount = 8;
        [muStr appendString:[NSString stringWithFormat:@"[%@单式%d注]", playTypes[tag], betCount]];
    }else if (tag == 18)
    {
        betCount = 7;
        [muStr appendString:[NSString stringWithFormat:@"[%@单式%d注]", playTypes[tag], betCount]];
    }else
    {
        [muStr appendString:[NSString stringWithFormat:@"[%@单式1注]", playTypes[tag]]];
    }
    
    //拼接完字符串后加颜色
    NSRange range = [muStr rangeOfString:@"["];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:muStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range.location)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range.location, muStr.length-range.location)];
    
    YZBetStatus *status = [[YZBetStatus alloc] init];
    status.labelText = attStr;
    status.betCount = betCount;
    if (tag == 14) {
        status.betType = @"12";
    }else if (tag == 15)
    {
        status.betType = @"13";
    }else if (tag == 16)
    {
        status.betType = @"14";
    }else
    {
        status.betType = @"00";
    }
    CGSize labelSize = [muStr sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
    status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
    status.playType = playType;
    //存储一组号码数据
    [YZStatusCacheTool saveStatus:status];
}

+ (void)autoChooseKsWithSelectedPlayTypeBtnTag:(int)tag//机选快三
{
    NSMutableArray * selectedButttonTags = [NSMutableArray array];
    if (tag == 0) {//和值
        int random1 = arc4random() % 6;
        int random2 = arc4random() % 6;
        int random3 = arc4random() % 6;
        
        NSNumber * number = @(random1 + random2 + random3);
        [selectedButttonTags addObject:number];
    }else if (tag == 1)//三同号
    {
        int random = arc4random() % 6;
        
        NSNumber * number = @(random);
        [selectedButttonTags addObject:number];
    }else if (tag == 2)//二同
    {
        NSMutableSet *set = [NSMutableSet set];
        while (set.count < 2) {//至少2个
            int random = arc4random() % 6;
            NSNumber * number = @(random);
            [set addObject:number];
        }
        for (NSNumber * number in set) {
            [selectedButttonTags addObject:[NSArray arrayWithObject:number]];
        }
        [selectedButttonTags addObject:[NSArray array]];
    }else if (tag == 3)//三不同
    {
        NSMutableSet *set = [NSMutableSet set];
        while (set.count < 3) {//至少3个
            int random = arc4random() % 6;
            NSNumber * number = @(random);
            [set addObject:number];
        }
        selectedButttonTags = [[set allObjects] mutableCopy];
    }else if (tag == 4)//二不同
    {
        NSMutableSet *set = [NSMutableSet set];
        while (set.count < 2) {//至少2个
            int random = arc4random() % 6;
            NSNumber * number = @(random);
            [set addObject:number];
        }
        selectedButttonTags = [[set allObjects] mutableCopy];
    }
    //把信息存入数据库
    [YZCommitTool commitKsBetWithNumbers:selectedButttonTags selectedPlayTypeBtnTag:tag];
    
}
+ (void)autoChooseDlt//机选大乐透
{
    NSMutableSet *redSet = [NSMutableSet set];
    while (redSet.count < 5) {//红球至少5个
        int random = arc4random() % 35 + 1;
        [redSet addObject:[NSString stringWithFormat:@"%02d",random]];
    }
    NSMutableArray *redNumberArray = [[redSet allObjects] mutableCopy];
    redNumberArray = [self sortNumberArray:redNumberArray];
    NSMutableSet *blueSet = [NSMutableSet set];
    while (blueSet.count < 2) {
        int random = arc4random() % 12 + 1;
        [blueSet addObject:[NSString stringWithFormat:@"%02d",random]];
    }
    NSMutableArray *blueNumberArray = [[blueSet allObjects] mutableCopy];
    blueNumberArray = [self sortNumberArray:blueNumberArray];
    YZBetStatus *status = [[YZBetStatus alloc] init];
    NSMutableString *str = [NSMutableString string];
    for(NSArray *array in redNumberArray)
    {
        [str appendFormat:@"%@,",array];
    }
    [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
    [str appendFormat:@"|"];//加一竖
    for(NSArray *array in blueNumberArray)
    {
        [str appendFormat:@"%@,",array];//加一竖
    }
    [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
    [str appendString:@"[单式1注]"];
    YZLog(@"blueSet = %@,redSet = %@",[blueSet allObjects],[redSet allObjects]);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, 14)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(14, 1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(15, 5)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(20, 6)];
    status.labelText = attStr;
    CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin -  5 - 18, MAXFLOAT)];
    status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
    status.betCount = 1;
    //存储一组号码数据
    [YZStatusCacheTool saveStatus:status];
}
+ (void)autoChoosefc//机选福彩3D
{
    NSMutableSet *set = [NSMutableSet set];
    while (set.count < 3) {
        int random1 = arc4random() % 10;
        [set addObject:[NSString stringWithFormat:@"%d",random1]];
    }
    YZBetStatus *status = [[YZBetStatus alloc] init];
    NSMutableString *str = [NSMutableString string];
    for(NSString *temp in [set allObjects])
    {
        [str appendFormat:@"%@|",temp];
    }
    [str deleteCharactersInRange:NSMakeRange(str.length - 1, 1)];
    [str appendString:@"[直选单式1注]"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, 5)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(5, 8)];
    status.labelText = attStr;
    CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin -  5 - 18, MAXFLOAT)];
    status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
    status.betCount = 1;
    //存储一组号码数据
    [YZStatusCacheTool saveStatus:status];
}
+ (void)autoChooseQlc//机选七乐彩
{
    NSMutableSet *redSet = [NSMutableSet set];
    while (redSet.count < 7) {
        int random = arc4random() % 30 + 1;
        [redSet addObject:[NSString stringWithFormat:@"%02d",random]];
    }
    NSMutableArray *redNumberArray = [[redSet allObjects] mutableCopy];
    redNumberArray = [self sortNumberArray:redNumberArray];
    
    YZBetStatus *status = [[YZBetStatus alloc] init];
    NSMutableString *str = [NSMutableString string];
    for(NSArray *array in redNumberArray)
    {
        [str appendFormat:@"%@,",array];
    }
    [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
    
    [str appendString:@"[单式1注]"];
    YZLog(@"redSet = %@",[redSet allObjects]);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, 20)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(20, 6)];
    status.labelText = attStr;
    CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin -  5 - 18, MAXFLOAT)];
    status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
    status.betCount = 1;
    //存储一组号码数据
    [YZStatusCacheTool saveStatus:status];
}
+ (void)autoChooseSsq//机选双色球
{
    NSMutableSet *redSet = [NSMutableSet set];
    while (redSet.count < 6) {
        int random = arc4random() % 33 + 1;
        [redSet addObject:[NSString stringWithFormat:@"%02d",random]];
    }
    NSMutableArray *redNumberArray = [[redSet allObjects] mutableCopy];
    redNumberArray = [self sortNumberArray:redNumberArray];
    NSMutableSet *blueSet = [NSMutableSet set];
    while (blueSet.count < 1) {
        int random = arc4random() % 16 + 1;
        [blueSet addObject:[NSString stringWithFormat:@"%02d",random]];
    }
    YZBetStatus *status = [[YZBetStatus alloc] init];
    NSMutableString *str = [NSMutableString string];
    for(NSArray *array in redNumberArray)
    {
        [str appendFormat:@"%@,",array];
    }
    [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
    for(NSArray *array in blueSet)
    {
        [str appendFormat:@"|%@",array];
    }
    [str appendString:@"[单式1注]"];
    YZLog(@"blueSet = %@,redSet = %@",[blueSet allObjects],[redSet allObjects]);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, 17)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(17, 1)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(18, 2)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(20, 6)];
    //    [attStr insertAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "] atIndex:0];
    status.labelText = attStr;
    CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin -  5 - 18, MAXFLOAT)];
    status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
    status.betCount = 1;
    //存储一组号码数据
    [YZStatusCacheTool saveStatus:status];
}
//冒泡排序数组
+ (NSMutableArray *)sortNumberArray:(NSMutableArray *)mutableArray
{
    for(int i = 0;i < mutableArray.count;i++)
    {
        for(int j = i + 1;j <mutableArray.count;j++)
        {
            NSString *str1 = mutableArray[i];
            NSString *str2= mutableArray[j];
            if([str1 intValue] > [str2 intValue])
            {
                [mutableArray replaceObjectAtIndex:i withObject:str2];
                [mutableArray replaceObjectAtIndex:j withObject:str1];
            }
        }
    }
    return mutableArray;
}
+ (void)autoChooseQxc//机选七星彩
{
    NSMutableString *muStr = [NSMutableString string];
    while (muStr.length < 14) {
        int random = arc4random() % 10;
        [muStr appendFormat:@"%d|",random];
    }
    [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];
    [muStr appendString:@"[单式1注]"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:muStr];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, 13)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(13, 6)];
    YZBetStatus *status = [[YZBetStatus alloc] init];
    status.labelText = attStr;
    CGSize labelSize = [muStr sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin -  5 - 18, MAXFLOAT)];
    status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
    status.betCount = 1;
    //存储一组号码数据
    [YZStatusCacheTool saveStatus:status];
}
+ (void)autoChoosePlw//机选排列五
{
    NSMutableSet *wanSet = [NSMutableSet set];
    NSMutableSet *qianSet = [NSMutableSet set];
    NSMutableSet *baiSet = [NSMutableSet set];
    NSMutableSet *shiSet = [NSMutableSet set];
    NSMutableSet *geSet = [NSMutableSet set];
    
    int random1 = arc4random() % 10;
    [baiSet addObject:[NSString stringWithFormat:@"%d",random1]];
    
    int random2 = arc4random() % 10;
    [shiSet addObject:[NSString stringWithFormat:@"%d",random2]];
    
    int random3 = arc4random() % 10;
    [geSet addObject:[NSString stringWithFormat:@"%d",random3]];
    
    int random4 = arc4random() % 10;
    [wanSet addObject:[NSString stringWithFormat:@"%d",random4]];
    
    int random5 = arc4random() % 10;
    [qianSet addObject:[NSString stringWithFormat:@"%d",random5]];
    
    YZBetStatus *status = [[YZBetStatus alloc] init];
    NSMutableString *str = [NSMutableString string];
    [str appendFormat:@"%@|",[wanSet anyObject]];
    [str appendFormat:@"%@|",[qianSet anyObject]];
    [str appendFormat:@"%@|",[baiSet anyObject]];
    [str appendFormat:@"%@|",[shiSet anyObject]];
    [str appendFormat:@"%@",[geSet anyObject]];
    [str appendString:@"[单式1注]"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, 9)];
    [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(9, 6)];
    status.labelText = attStr;
    CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin -  5 - 18, MAXFLOAT)];
    status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
    status.betCount = 1;
    //存储一组号码数据
    [YZStatusCacheTool saveStatus:status];
}
#pragma  mark - 获取提交后台的list
+ (NSMutableArray *)getPlsTicketList
{
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *danshiArr = [NSMutableArray array];
    NSMutableArray *zusanDanshiArr = [NSMutableArray array];
    for(YZBetStatus *status in [YZStatusCacheTool getStatues])
    {
        NSString *temp = [status.labelText string];
        NSRange range = [temp rangeOfString:@"["];
        NSString *temp1 = [temp substringWithRange:NSMakeRange(0, range.location)];//取出没有备注信息的号码
        if([temp rangeOfString:@"直选单式"].location != NSNotFound)//说明号码是直选单式,放到单式数据，以便5个一组
        {
            [danshiArr addObject:temp1];
        }else if ([temp rangeOfString:@"组三单式"].location != NSNotFound)//组三复式
        {
            [zusanDanshiArr addObject:temp1];
        }else
        {
            NSDictionary *dict = @{@"numbers":temp1,
                                   @"betType":status.betType,
                                   @"playType":status.playType};
            [arr addObject:dict];
        }
    }
    //直选单式
    while(danshiArr.count >= 5)//5个直选单式组成一组字符串
    {
        NSArray *fiveArr = [danshiArr subarrayWithRange:NSMakeRange(0, 5)];
        NSMutableString *fiveStr = [NSMutableString string];
        [danshiArr removeObjectsInRange:NSMakeRange(0, 5)];
        for(NSString *str in fiveArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":@"01"};
        [arr addObject:dict];
    }
    if(danshiArr.count > 0 && danshiArr.count < 5)//剩余不足5个通通放一个字符串里
    {
        NSMutableString *fiveStr = [NSMutableString string];
        for(NSString *str in danshiArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":@"01"};
        [arr addObject:dict];
    }
    //组选三的单式
    while(zusanDanshiArr.count >= 5)//5个组选六的单式组成一组字符串
    {
        NSArray *fiveArr = [zusanDanshiArr subarrayWithRange:NSMakeRange(0, 5)];
        NSMutableString *fiveStr = [NSMutableString string];
        [zusanDanshiArr removeObjectsInRange:NSMakeRange(0, 5)];
        for(NSString *str in fiveArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":@"02"};
        [arr addObject:dict];
    }
    if(zusanDanshiArr.count > 0 && zusanDanshiArr.count < 5)//剩余不足5个通通放一个字符串里
    {
        NSMutableString *fiveStr = [NSMutableString string];
        for(NSString *str in zusanDanshiArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":@"02"};
        [arr addObject:dict];
    }
    return arr;
}
+ (void)autoChoosePls//机选排列三
{
    [self autoChoosefc];
}

+ (NSMutableArray *)getS1x5TicketList
{
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *danshiArr = [NSMutableArray array];
    NSString *danPlayType = nil;
    for(YZBetStatus *status in [YZStatusCacheTool getStatues])
    {
        NSString *temp = [status.labelText string];
        NSRange range = [temp rangeOfString:@"["];
        NSString *temp1 = [temp substringWithRange:NSMakeRange(0, range.location)];//取出没有备注信息的号码
        if([status.betType isEqualToString:@"00"])//说明号码是单式,放到单式数据，以便5个一组
        {
            [danshiArr addObject:temp1];
            danPlayType = status.playType;
        }else
        {
            NSDictionary *dict = @{@"numbers":temp1,
                                   @"betType":status.betType,
                                   @"playType":status.playType};
            [arr addObject:dict];
        }
    }
    //直选单式
    while(danshiArr.count >= 5)//5个直选单式组成一组字符串
    {
        NSArray *fiveArr = [danshiArr subarrayWithRange:NSMakeRange(0, 5)];
        NSMutableString *fiveStr = [NSMutableString string];
        [danshiArr removeObjectsInRange:NSMakeRange(0, 5)];
        for(NSString *str in fiveArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":danPlayType};
        [arr addObject:dict];
    }
    if(danshiArr.count > 0 && danshiArr.count < 5)//剩余不足5个通通放一个字符串里
    {
        for(NSString *str in danshiArr)
        {
            NSDictionary *dict = [NSDictionary dictionary];
            dict = @{@"numbers":str,
                     @"betType":@"00",
                     @"playType":danPlayType};
            [arr addObject:dict];
        }
    }
    return arr;
}

+ (NSMutableArray *)getFcTicketList
{
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *danshiArr = [NSMutableArray array];
    NSMutableArray *zusanDanshiArr = [NSMutableArray array];
    NSMutableArray *zuliuDanshiArr = [NSMutableArray array];
    for(YZBetStatus *status in [YZStatusCacheTool getStatues])
    {
        NSString *temp = [status.labelText string];
        NSRange range = [temp rangeOfString:@"["];
        NSString *temp1 = [temp substringWithRange:NSMakeRange(0, range.location)];//取出没有备注信息的号码
        if([temp rangeOfString:@"直选单式"].location != NSNotFound)//说明号码是直选单式
        {
            [danshiArr addObject:temp1];
        }else if([temp rangeOfString:@"直选复式"].location != NSNotFound)//说明号码是直选复式
        {
            NSDictionary *dict = @{@"numbers":temp1,
                                   @"betType":@"01",
                                   @"playType":@"01"};
            
            [arr addObject:dict];
        }else if ([temp rangeOfString:@"直选和值"].location != NSNotFound)//是直选和值
        {
            NSDictionary *dict = @{@"numbers":temp1,
                                   @"betType":@"03",
                                   @"playType":@"01"};
            
            [arr addObject:dict];
        }else if ([temp rangeOfString:@"组三单式"].location != NSNotFound)//组三复式
        {
            [zusanDanshiArr addObject:temp1];
        } else if ([temp rangeOfString:@"组三复式"].location != NSNotFound)//组三复式
        {
            NSDictionary *dict = @{@"numbers":temp1,
                                   @"betType":@"01",
                                   @"playType":@"02"};
            
            [arr addObject:dict];
        }else if ([temp rangeOfString:@"组六单式"].location != NSNotFound)//组六单式
        {
            [zuliuDanshiArr addObject:temp1];
        }else if ([temp rangeOfString:@"组六复式"].location != NSNotFound)//组六复式
        {
            NSDictionary *dict = @{@"numbers":temp1,
                                   @"betType":@"01",
                                   @"playType":@"03"};
            
            [arr addObject:dict];
        }
    }
    //直选和值的单式
    while(danshiArr.count >= 5)//5个直选单式组成一组字符串
    {
        NSArray *fiveArr = [danshiArr subarrayWithRange:NSMakeRange(0, 5)];
        NSMutableString *fiveStr = [NSMutableString string];
        [danshiArr removeObjectsInRange:NSMakeRange(0, 5)];
        for(NSString *str in fiveArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":@"01"};
        [arr addObject:dict];
    }
    if(danshiArr.count > 0 && danshiArr.count < 5)//剩余不足5个通通放一个字符串里
    {
        NSMutableString *fiveStr = [NSMutableString string];
        for(NSString *str in danshiArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":@"01"};
        [arr addObject:dict];
    }
    //组选三的单式
    while(zusanDanshiArr.count >= 5)//5个组选六的单式组成一组字符串
    {
        NSArray *fiveArr = [zusanDanshiArr subarrayWithRange:NSMakeRange(0, 5)];
        NSMutableString *fiveStr = [NSMutableString string];
        [zusanDanshiArr removeObjectsInRange:NSMakeRange(0, 5)];
        for(NSString *str in fiveArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":@"02"};
        [arr addObject:dict];
    }
    if(zusanDanshiArr.count > 0 && zusanDanshiArr.count < 5)//剩余不足5个通通放一个字符串里
    {
        NSMutableString *fiveStr = [NSMutableString string];
        for(NSString *str in zusanDanshiArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":@"02"};
        [arr addObject:dict];
    }
    //组选六的单式
    while(zuliuDanshiArr.count >= 5)//5个组选六的单式组成一组字符串
    {
        NSArray *fiveArr = [zuliuDanshiArr subarrayWithRange:NSMakeRange(0, 5)];
        NSMutableString *fiveStr = [NSMutableString string];
        [zuliuDanshiArr removeObjectsInRange:NSMakeRange(0, 5)];
        for(NSString *str in fiveArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":@"03"};
        [arr addObject:dict];
    }
    if(zuliuDanshiArr.count > 0 && zuliuDanshiArr.count < 5)//剩余不足5个通通放一个字符串里
    {
        NSMutableString *fiveStr = [NSMutableString string];
        for(NSString *str in zuliuDanshiArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":@"03"};
        [arr addObject:dict];
    }
    return arr;
}

+ (NSMutableArray *)getSsqTicketList
{
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *danshiArr = [NSMutableArray array];
    for(YZBetStatus *status in [YZStatusCacheTool getStatues])
    {
        NSString *temp = [status.labelText string];
        NSRange range = [temp rangeOfString:@"["];
        NSString *temp1 = [temp substringWithRange:NSMakeRange(0, range.location)];//取出没有备注信息的号码
        if([temp rangeOfString:@"单式"].location != NSNotFound)//说明号码是单式
        {
            [danshiArr addObject:temp1];
        }else if([temp rangeOfString:@"复式"].location != NSNotFound)//说明号码是复式
        {
            NSDictionary *dict = @{@"numbers":temp1,
                                   @"betType":@"01",
                                   @"playType":@"00"};
            [arr addObject:dict];
        }else if([temp rangeOfString:@"胆拖"].location != NSNotFound)//说明号码胆拖
        {
            NSDictionary *dict = @{@"numbers":temp1,
                                   @"betType":@"02",
                                   @"playType":@"00"};
            [arr addObject:dict];
        }
    }
    while(danshiArr.count >= 5)//5个单式组成一组字符串
    {
        NSArray *fiveArr = [danshiArr subarrayWithRange:NSMakeRange(0, 5)];
        NSMutableString *fiveStr = [NSMutableString string];
        [danshiArr removeObjectsInRange:NSMakeRange(0, 5)];
        for(NSString *str in fiveArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":@"00"};
        [arr addObject:dict];
    }
    if(danshiArr.count > 0 && danshiArr.count < 5)//剩余不足5个通通放一个字符串里
    {
        NSMutableString *fiveStr = [NSMutableString string];
        for(NSString *str in danshiArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":@"00"};
        [arr addObject:dict];
    }
    return arr;
}

+ (NSMutableArray *)getQlcTicketList
{
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *danshiArr = [NSMutableArray array];
    for(YZBetStatus *status in [YZStatusCacheTool getStatues])
    {
        NSString *temp = [status.labelText string];
        NSRange range = [temp rangeOfString:@"["];
        NSString *temp1 = [temp substringWithRange:NSMakeRange(0, range.location)];//取出没有备注信息的号码
        if(temp1.length <= 20)//说明号码是单式
        {
            [danshiArr addObject:temp1];
        }else//说明号码是复式
        {
            NSDictionary *dict = nil;
            if([temp1 rangeOfString:@"$"].location != NSNotFound)//有美元符号,是胆拖
            {
                dict = @{@"numbers":temp1,
                         @"betType":@"02",
                         @"playType":@"00"};
            }else//无美元符号，是普通复式
            {
                dict = @{@"numbers":temp1,
                         @"betType":@"01",
                         @"playType":@"00"};
            }
            [arr addObject:dict];
        }
    }
    while(danshiArr.count >= 5)//5个单式组成一组字符串
    {
        NSArray *fiveArr = [danshiArr subarrayWithRange:NSMakeRange(0, 5)];
        NSMutableString *fiveStr = [NSMutableString string];
        [danshiArr removeObjectsInRange:NSMakeRange(0, 5)];
        for(NSString *str in fiveArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":@"00"};
        [arr addObject:dict];
    }
    if(danshiArr.count > 0 && danshiArr.count < 5)//剩余不足5个通通放一个字符串里
    {
        NSMutableString *fiveStr = [NSMutableString string];
        for(NSString *str in danshiArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":@"00"};
        [arr addObject:dict];
    }
    return arr;
}

+ (NSMutableArray *)getDltTicketListWithZhuijia:(BOOL)zhuijia
{
    NSString *playType = zhuijia ? @"05" : @"00";
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *danshiArr = [NSMutableArray array];
    for(YZBetStatus *status in [YZStatusCacheTool getStatues])
    {
        NSString *temp = [status.labelText string];
        NSRange range = [temp rangeOfString:@"["];
        NSString *temp1 = [temp substringWithRange:NSMakeRange(0, range.location)];//取出没有备注信息的号码
        if([temp rangeOfString:@"单式"].location != NSNotFound)//说明号码是单式
        {
            [danshiArr addObject:temp1];
        }else if([temp rangeOfString:@"复式"].location != NSNotFound)//说明号码是复式
        {
            NSDictionary *dict = @{@"numbers":temp1,
                                   @"betType":@"01",
                                   @"playType":playType};
            
            [arr addObject:dict];
        }else if([temp rangeOfString:@"胆拖"].location != NSNotFound)//说明号码是复式
        {
            NSDictionary *dict = @{@"numbers":temp1,
                                   @"betType":@"02",
                                   @"playType":playType};
            
            [arr addObject:dict];
        }
    }
    while(danshiArr.count >= 5)//5个单式组成一组字符串
    {
        NSArray *fiveArr = [danshiArr subarrayWithRange:NSMakeRange(0, 5)];
        NSMutableString *fiveStr = [NSMutableString string];
        [danshiArr removeObjectsInRange:NSMakeRange(0, 5)];
        for(NSString *str in fiveArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":playType};
        [arr addObject:dict];
    }
    if(danshiArr.count > 0 && danshiArr.count < 5)//剩余不足5个通通放一个字符串里
    {
        NSMutableString *fiveStr = [NSMutableString string];
        for(NSString *str in danshiArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":playType};
        [arr addObject:dict];
    }
    return arr;
}

+ (NSMutableArray *)getQxcTicketList
{
    return [self getDltTicketListWithZhuijia:NO];
}

+ (NSMutableArray *)getPlwTicketList
{
    return [self getDltTicketListWithZhuijia:NO];
}

+ (NSMutableArray *)getKsTicketList
{
    //把不同玩法的投注放在不同的statuesSet_里
    NSMutableDictionary * statuesDic = [NSMutableDictionary dictionary];
    NSString * playType = @"";
    for(YZBetStatus *status in [YZStatusCacheTool getStatues])
    {
        if (![playType isEqualToString:status.playType]) {
            playType = status.playType;
            NSMutableSet * statuesSet = [NSMutableSet set];
            [statuesDic setValue:statuesSet forKey:playType];
        }
    }
    for(YZBetStatus *status in [YZStatusCacheTool getStatues])
    {
        NSMutableSet * statuesSet = statuesDic[status.playType];
        [statuesSet addObject:status];
    }
    //存到数据库里
    NSMutableArray *arr = [NSMutableArray array];
    for (NSSet * statuesSet in statuesDic.allValues) {
        NSMutableArray *danshiArr = [NSMutableArray array];
        NSString *danPlayType = nil;
        //每种playType的投注
        for(YZBetStatus *status in statuesSet)
        {
            NSString *temp = [status.labelText string];
            NSRange range = [temp rangeOfString:@"["];
            NSString *temp1 = [temp substringWithRange:NSMakeRange(0, range.location)];//取出没有备注信息的号码
            if([status.betType isEqualToString:@"00"])//说明号码是单式,放到单式数据，以便5个一组
            {
                [danshiArr addObject:temp1];
                danPlayType = status.playType;
            }else
            {
                NSDictionary *dict = @{@"numbers":temp1,
                                       @"betType":status.betType,
                                       @"playType":status.playType};
                [arr addObject:dict];
            }
        }
        //直选单式
        while(danshiArr.count >= 5)//5个直选单式组成一组字符串
        {
            NSArray *fiveArr = [danshiArr subarrayWithRange:NSMakeRange(0, 5)];
            NSMutableString *fiveStr = [NSMutableString string];
            [danshiArr removeObjectsInRange:NSMakeRange(0, 5)];
            for(NSString *str in fiveArr)
            {
                [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
            }
            [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
            NSDictionary *dict = @{@"numbers":fiveStr,
                                   @"betType":@"00",
                                   @"playType":danPlayType};
            [arr addObject:dict];
        }
        if(danshiArr.count > 0 && danshiArr.count < 5)//剩余不足5个通通放一个字符串里
        {
            for(NSString *str in danshiArr)
            {
                NSDictionary *dict = [NSDictionary dictionary];
                dict = @{@"numbers":str,
                         @"betType":@"00",
                         @"playType":danPlayType};
                [arr addObject:dict];
                
            }
        }
        
    }
    return arr;
}

//获取快赢481的ticketList
+ (NSMutableArray *)getKy481TicketList
{
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *danshiArr = [NSMutableArray array];
    NSString *danPlayType = nil;
    for(YZBetStatus *status in [YZStatusCacheTool getStatues])
    {
        NSString *temp = [status.labelText string];
        NSRange range = [temp rangeOfString:@"["];
        NSString *temp1 = [temp substringWithRange:NSMakeRange(0, range.location)];//取出没有备注信息的号码
        if([status.playType isEqualToString:@"00"])//说明号码是单式
        {
            [danshiArr addObject:temp1];
            danPlayType = status.playType;
        }else//说明号码是复式
        {
            NSDictionary *dict = nil;
            if([temp1 rangeOfString:@"$"].location != NSNotFound)//有美元符号,是胆拖
            {
                dict = @{@"numbers":temp1,
                         @"betType":status.betType,
                         @"playType":status.playType};
            }else//无美元符号，是普通复式
            {
                dict = @{@"numbers":temp1,
                         @"betType":status.betType,
                         @"playType":status.playType};
            }
            [arr addObject:dict];
        }
    }
    while(danshiArr.count >= 5)//5个单式组成一组字符串
    {
        NSArray *fiveArr = [danshiArr subarrayWithRange:NSMakeRange(0, 5)];
        NSMutableString *fiveStr = [NSMutableString string];
        [danshiArr removeObjectsInRange:NSMakeRange(0, 5)];
        for(NSString *str in fiveArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":danPlayType};
        [arr addObject:dict];
    }
    if(danshiArr.count > 0 && danshiArr.count < 5)//剩余不足5个通通放一个字符串里
    {
        NSMutableString *fiveStr = [NSMutableString string];
        for(NSString *str in danshiArr)
        {
            [fiveStr appendString:[NSString stringWithFormat:@"%@;",str]];
        }
        [fiveStr deleteCharactersInRange:NSMakeRange(fiveStr.length - 1, 1)];//删除最后一个分号
        NSDictionary *dict = @{@"numbers":fiveStr,
                               @"betType":@"00",
                               @"playType":danPlayType};
        [arr addObject:dict];
    }
    return arr;
}

@end
