//
//  YZCommitTool.m
//  ez
//
//  Created by apple on 16/5/11.
//  Copyright (c) 2016年 9ge. All rights reserved.
//

#import "YZCommitTool.h"
#import "YZBetStatus.h"
#import "YZMathTool.h"
#import "YZStatusCacheTool.h"

@implementation YZCommitTool
#pragma mark - 排列三
//提交排三普通的数据
+ (void)commitPisNormalBetWithBaiBalls:(NSMutableArray *)baiBalls shiBalls:(NSMutableArray *)shiBalls geBalls:(NSMutableArray *)geBalls betCount:(int)betCount playType:(NSString *)playTypeCode
{
    if(baiBalls.count < 1 || shiBalls.count < 1 || geBalls.count < 1)
    {//没有一注
        [MBProgressHUD showError:@"请每位至少选择1个号码"];
    }else//其他正确情况就传数据
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对百位球数组排序
        baiBalls = [self sortBallsArray:baiBalls];
        for(YZBallBtn *btn in baiBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"|"];
        //对十位球数组排序
        shiBalls = [self sortBallsArray:shiBalls];
        for(YZBallBtn *btn in shiBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"|"];
        //对个位球数组排序
        geBalls = [self sortBallsArray:geBalls];
        for(YZBallBtn *btn in geBalls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        if(betCount == 1)
        {
            [str appendString:@"[直选单式1注]"];
        }else
        {
            [str appendString:[NSString stringWithFormat:@"[直选复式%d注]",betCount]];
        }
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"["];//20
        NSRange range2 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, range2.location - range1.location + 1)];
        status.labelText = attStr;
        status.betCount = betCount;
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        status.playType = playTypeCode;
        NSString *betType = nil;
        if(betCount == 1)
        {
            betType = @"00";
        }else
        {
            betType = @"01";
        }
        status.betType = betType;
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
//提交和值的数据
+ (void)commitPisHezhiBetWithBalls:(NSMutableArray *)balls betCount:(int)betCount playType:(NSString *)playTypeCode
{
    if (balls.count < 1)
    {
        [MBProgressHUD showError:@"请至少选择1个号码"];
    }else
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对球数组排序
        balls = [self sortBallsArray:balls];
        for(YZBallBtn *btn in balls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];//添加胆码
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:[NSString stringWithFormat:@"[直选和值%d注]",betCount]];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"["];//20
        NSRange range2 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, range2.location - range1.location + 1)];
        status.labelText = attStr;
        status.betCount = betCount;
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        
        status.playType = playTypeCode;
        status.betType = @"03";
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
//提交排三组选和值的数据
+ (void)commitPisZuheBetWithBalls:(NSMutableArray *)balls betCount:(int)betCount playType:(NSString *)playTypeCode
{
    if (balls.count < 3)
    {
        [MBProgressHUD showError:@"请至少选择1个号码"];
    }else
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对球数组排序
        balls = [self sortBallsArray:balls];
        for(YZBallBtn *btn in balls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:[NSString stringWithFormat:@"[直选组合%d注]",betCount]];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"["];//20
        NSRange range2 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, range2.location - range1.location + 1)];
        status.labelText = attStr;
        status.betCount = betCount;
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        status.playType = playTypeCode;
        status.betType = @"04";
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
//提交排三组选的数据
+ (void)commitPisZuxuanBetWithBalls:(NSMutableArray *)balls andBetCount:(int)betCount andPlayType:(NSString *)playTypeCode
{
    if(balls.count < 1)
    {
        [MBProgressHUD showError:@"请至少选择1个号码"];
    }else
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对球数组排序
        balls = [self sortBallsArray:balls];
        for(YZBallBtn *btn in balls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:[NSString stringWithFormat:@"[组选和值%d注]",betCount]];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"["];//20
        NSRange range2 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, range2.location - range1.location + 1)];
        status.labelText = attStr;
        status.betCount = betCount;
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        status.playType = playTypeCode;
        status.betType = @"03";
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
//提交排三直选三单式的数据
+ (void)commitPisSanDanBetWithDanBall:(YZBallBtn *)danBall chongBall:(YZBallBtn *)chongBall betCount:(int)betCount playType:(NSString *)playTypeCode
{
    if (!danBall || !chongBall) {
        [MBProgressHUD showError:@"请每位至少选择1个号码"];
    }else
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        [str appendString:[NSString stringWithFormat:@"%ld,",(long)danBall.tag]];
        [str appendString:[NSString stringWithFormat:@"%ld,",(long)chongBall.tag]];
        [str appendString:[NSString stringWithFormat:@"%ld",(long)chongBall.tag]];
        [str appendString:@"[组三单式1注]"];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"["];//20
        NSRange range2 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, range2.location - range1.location + 1)];
        status.labelText = attStr;
        status.betCount = betCount;
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        status.playType = playTypeCode;
        status.betType = @"00";
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
//提交排三直选三复式的数据
+ (void)commitPisSanFuBetWithBalls:(NSMutableArray *)balls andBetCount:(int)betCount andPlayType:(NSString *)playTypeCode
{
    if(balls.count < 2)
    {
        [MBProgressHUD showError:@"请至少选择2个号码"];
    }else
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对球数组排序
        balls = [self sortBallsArray:balls];
        for(YZBallBtn *btn in balls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:[NSString stringWithFormat:@"[组三复式%d注]",betCount]];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"["];//20
        NSRange range2 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, range2.location - range1.location + 1)];
        status.labelText = attStr;
        status.betCount = betCount;
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        status.playType = playTypeCode;
        status.betType = @"01";
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
//提交排三直选六复式的数据
+ (void)commitPisLiuBetWithBalls:(NSMutableArray *)balls BetCount:(int)betCount PlayType:(NSString *)playTypeCode
{
    if(balls.count < 3)
    {
        [MBProgressHUD showError:@"请至少选择3个号码"];
    }else
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对球数组排序
        balls = [self sortBallsArray:balls];
        for(YZBallBtn *btn in balls)
        {
            [str appendFormat:@"%ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        if(balls.count == 3)//组六单式
        {
            [str appendString:[NSString stringWithFormat:@"[组六单式%d注]",betCount]];
        }else if(balls.count >= 4)//组六复式
        {
            [str appendString:[NSString stringWithFormat:@"[组六复式%d注]",betCount]];
        }
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"["];//20
        NSRange range2 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, range2.location - range1.location + 1)];
        status.labelText = attStr;
        status.betCount = betCount;
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        status.playType = playTypeCode;
        NSString *betType = nil;
        if(betCount == 1)
        {
            betType = @"00";
        }else
        {
            betType = @"01";
        }
        status.betType = betType;
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
#pragma mark - 大乐透
//提交大乐透普通投注的数据
+ (void)commitDltNormalBetWithRedBalls:(NSMutableArray *)redBalls blueBalls:(NSMutableArray *)blueBalls betCount:(int)betCount
{
    if(redBalls.count < 5 || blueBalls.count < 2)
    {//没有一注
        [MBProgressHUD showError:@"红球至少选5个，蓝球至少选2个"];
    }else if(betCount * 2 > 20000)
    {
        [MBProgressHUD showError:@"单注金额不能超过2万元"];
    }else//其他正确情况就传数据
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对球数组排序
        redBalls = [self sortBallsArray:redBalls];
        for(YZBallBtn *btn in redBalls)
        {
            [str appendFormat:@"%02ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"|"];
        //对球数组排序
        blueBalls = [self sortBallsArray:blueBalls];
        for(YZBallBtn *btn in blueBalls)
        {
            [str appendFormat:@"%02ld,",(long)btn.tag];
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        if(betCount == 1)
        {
            [str appendString:@"[单式1注]"];
        }else
        {
            [str appendString:[NSString stringWithFormat:@"[复式%d注]",betCount]];
        }
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"|"];//17
        NSRange range2 = [str rangeOfString:@"["];//20
        NSRange range3 = [str rangeOfString:@"]"];//25
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, 1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(range1.location + 1, blueBalls.count * 3 - 1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range2.location, range3.location - range2.location + 1)];
        status.labelText = attStr;
        status.betCount = betCount;
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
//提交胆拖投注的数据
+ (void)commitDltBileBetWithRedBalls1:(NSMutableArray *)redBalls1 blueBalls1:(NSMutableArray *)blueBalls1 redBalls2:(NSMutableArray *)redBalls2 blueBalls2:(NSMutableArray *)blueBalls2 betCount:(int)betCount
{
    if (redBalls1.count < 1 || redBalls1.count > 4) {
        [MBProgressHUD showError:@"前区胆码至少选1个,至多选4个"];
    }else if (redBalls2.count < 2)
    {
        [MBProgressHUD showError:@"前区拖码至少选择2个"];
    }else if (blueBalls1.count > 1)
    {
        [MBProgressHUD showError:@"后区胆码至多选择1个"];
    }else if (blueBalls2.count < 2)
    {
        [MBProgressHUD showError:@"后区拖码至少选择2个"];
    }else if(betCount * 2 > 20000)
    {
        [MBProgressHUD showError:@"单注金额不能超过2万元"];
    }else if (redBalls1.count + redBalls2.count < 6){
        [MBProgressHUD showError:@"前区拖码和胆码之和不能小于6个"];
    }else
    {
        YZBetStatus *status = [[YZBetStatus alloc] init];
        NSMutableString *str = [NSMutableString string];
        //对球数组排序
        redBalls1 = [self sortBallsArray:redBalls1];
        for(YZBallBtn *btn in redBalls1)
        {
            [str appendFormat:@"%02ld,",(long)btn.tag];//添加胆码
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:@"$"];//添加美元符号
        //对球数组排序
        redBalls2 = [self sortBallsArray:redBalls2];
        for(YZBallBtn *btn in redBalls2)
        {
            [str appendFormat:@"%02ld,",(long)btn.tag];//拖码
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendFormat:@"|"];//添加竖线
        if (blueBalls1.count > 0) {
            blueBalls1 = [self sortBallsArray:blueBalls1];
            for(YZBallBtn *btn in blueBalls1)
            {
                [str appendFormat:@"%02ld,",(long)btn.tag];//添加胆码
            }
            [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        }
        [str appendString:@"$"];//添加美元符号
        //对球数组排序
        blueBalls2 = [self sortBallsArray:blueBalls2];
        for(YZBallBtn *btn in blueBalls2)
        {
            [str appendFormat:@"%02ld,",(long)btn.tag];//拖码
        }
        [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
        [str appendString:[NSString stringWithFormat:@"[胆拖%d注]",betCount]];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str];
        NSRange range1 = [str rangeOfString:@"|"];
        NSRange range2 = [str rangeOfString:@"["];
        NSRange range3 = [str rangeOfString:@"]"];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range1.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range1.location, 1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZBlueBallColor range:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range2.location, range3.location - range2.location)];
        status.labelText = attStr;
        status.betCount = betCount;
        CGSize labelSize = [str sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
#pragma mark - 11选5
//提交11选5的数据
+ (void)commit1x5BetWithBalls:(NSMutableArray *)balls betCount:(int)betCount playType:(NSString *)playTypeCode currentTitle:(NSString *)currentTitle selectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag
{
    NSArray *waringTitles = @[@"至少选择1个号码",@"至少选择2个号码", @"至少选择3个号码", @"至少选择4个号码", @"至少选择5个号码", @"至少选择6个号码", @"至少选择7个号码", @"请选择8个号码", @"每位至少选1个号", @"至少选择2个号码", @"每位至少选1个号", @"至少选择3个号码", @"请按规则选择号码"];
    if(betCount == 0)//没有注数，就弹框警示
    {
        if(selectedPlayTypeBtnTag < 12)//普通投注的警示
        {
            [MBProgressHUD showError:waringTitles[selectedPlayTypeBtnTag]];
        }else//胆拖则选最后一个警示
        {
            [MBProgressHUD showError:[waringTitles lastObject]];
        }
    }else
    {
        //有注数，则存储数据
        NSMutableString *muStr = [NSMutableString string];
        NSMutableArray *statusArray = balls[selectedPlayTypeBtnTag];
        NSString *betType = nil;
        if(selectedPlayTypeBtnTag <= 7 || selectedPlayTypeBtnTag == 9 || selectedPlayTypeBtnTag == 11)//只有一个cell的
        {
            //拼接字符串
            [muStr appendString:[self getNumbersStringWithArray:statusArray digit:@"02"]];
            if(betCount == 1)
            {
                [muStr appendString:[NSString stringWithFormat:@"[%@单式1注]",currentTitle]];
                betType = @"00";
            }else
            {
                [muStr appendString:[NSString stringWithFormat:@"[%@复式%d注]",currentTitle,betCount]];
                betType = @"01";
            }
        }else if(selectedPlayTypeBtnTag == 8 || selectedPlayTypeBtnTag == 10)//前二直选、前三直选
        {
            for(NSMutableArray *muArr in statusArray)
            {
                [muStr appendString:[self getNumbersStringWithArray:muArr digit:@"02"]];
                [muStr appendString:@"|"];
            }
            [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个|
            if(betCount == 1)
            {
                [muStr appendString:[NSString stringWithFormat:@"[%@单式1注]",currentTitle]];
                betType = @"00";
            }else
            {
                [muStr appendString:[NSString stringWithFormat:@"[%@定位%d注]",currentTitle,betCount]];
                betType = @"07";
            }
        }else//胆拖
        {
            for(NSMutableArray *muArr in statusArray)
            {
                [muStr appendString:[self getNumbersStringWithArray:muArr digit:@"02"]];
                [muStr appendString:@"$"];
            }
            [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个$
            [muStr appendString:[NSString stringWithFormat:@"[%@%d注]",currentTitle,betCount]];
            betType = @"02";
        }
        //拼接完字符串后加颜色
        NSRange range = [muStr rangeOfString:@"["];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:muStr];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range.location, muStr.length-range.location)];
        
        YZBetStatus *status = [[YZBetStatus alloc] init];
        status.labelText = attStr;
        status.betCount = betCount;
        CGSize labelSize = [muStr sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        status.playType = playTypeCode;
        status.betType = betType;
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
//对球号码进行排序、加逗号
+ (NSMutableString *)getNumbersStringWithArray:(NSMutableArray *)muArr digit:(NSString *)digit
{
    NSMutableString *str = [NSMutableString string];
    muArr = [self sortBallsArray:muArr];
    for(YZBallBtn *ball in muArr)
    {
        if (YZStringIsEmpty(digit)) {
            [str appendFormat:@"%ld,", (long)ball.tag];
        }else
        {
            [str appendFormat:@"%02ld,", (long)ball.tag];
        }
    }
    [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];//去掉最后一个逗号
    return str;
}
#pragma mark - 快赢481
+ (void)commitKy481BetWithBalls:(NSMutableArray *)balls betCount:(int)betCount playType:(NSString *)playTypeCode currentTitle:(NSString *)currentTitle selectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag
{    
    NSMutableArray *selStatusArray = balls[selectedPlayTypeBtnTag];
    if (selectedPlayTypeBtnTag == 0 || selectedPlayTypeBtnTag == 1 || selectedPlayTypeBtnTag == 2 || selectedPlayTypeBtnTag == 3 || selectedPlayTypeBtnTag == 5 || selectedPlayTypeBtnTag == 6) {
        NSMutableString *muStr = [NSMutableString string];
        NSString *betType = nil;
        for (NSMutableArray * cellStatusArray in selStatusArray) {
            if (cellStatusArray.count > 0) {
                [muStr appendString:[self getNumbersStringWithArray:cellStatusArray digit:@""]];
                [muStr appendString:@"|"];
            }else if (selectedPlayTypeBtnTag < 3)
            {
                [muStr appendString:@"_"];
                [muStr appendString:@"|"];
            }
        }
        if ((selectedPlayTypeBtnTag == 3 && muStr.length == 4) || (selectedPlayTypeBtnTag == 5 && muStr.length == 6)) {
            muStr = [NSMutableString stringWithString:[muStr stringByReplacingOccurrencesOfString:@"|" withString:@","]];
        }
        [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个|
        if (selectedPlayTypeBtnTag < 3 || selectedPlayTypeBtnTag == 6)
        {
            if(betCount == 1)
            {
                [muStr appendString:[NSString stringWithFormat:@"[%@单式1注]",currentTitle]];
                betType = @"00";
            }else
            {
                [muStr appendString:[NSString stringWithFormat:@"[%@复式%d注]",currentTitle,betCount]];
                betType = @"01";
            }
        }else
        {
            [muStr appendString:[NSString stringWithFormat:@"[%@%d注]",currentTitle,betCount]];
            if (selectedPlayTypeBtnTag == 3) {
                if (betCount == 6 || betCount == 12) {
                    betType = @"09";
                }else
                {
                    betType = @"99";
                }
            }else if (selectedPlayTypeBtnTag == 5)
            {
                if (betCount == 4 || betCount == 12 || betCount == 24) {
                    betType = @"09";
                }else
                {
                    betType = @"99";
                }
            }
        }
        
        //拼接完字符串后加颜色
        NSRange range = [muStr rangeOfString:@"["];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:muStr];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range.location, muStr.length-range.location)];
        
        YZBetStatus *status = [[YZBetStatus alloc] init];
        status.labelText = attStr;
        status.betCount = betCount;
        CGSize labelSize = [muStr sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        status.playType = playTypeCode;
        status.betType = betType;
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }else if (selectedPlayTypeBtnTag == 4)
    {
        NSArray * cellStatusArray = selStatusArray[0];
        for (NSInteger i = cellStatusArray.count - 1; i >= 0; i--) {
            YZBallBtn * ballBtn = cellStatusArray[i];
            NSString * number = ballBtn.currentTitle;
            if (!YZStringIsEmpty(number) && number.length == 2) {
                NSString * subNumber1 = [number substringWithRange:NSMakeRange(0, 1)];
                NSString * subNumber2 = [number substringWithRange:NSMakeRange(1, 1)];
                int subBetCount = 0;
                if ([subNumber1 isEqualToString:subNumber2]) {
                    subBetCount = 6;
                }else
                {
                    subBetCount = 12;
                }
                NSMutableString *muStr = [NSMutableString string];
                [muStr appendFormat:@"%@,%@", subNumber1, subNumber2];
                [muStr appendString:[NSString stringWithFormat:@"[%@%d注]", currentTitle, subBetCount]];
                
                //拼接完字符串后加颜色
                NSRange range = [muStr rangeOfString:@"["];
                NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:muStr];
                [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range.location)];
                [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range.location, muStr.length-range.location)];
                YZBetStatus *status = [[YZBetStatus alloc] init];
                status.labelText = attStr;
                status.betCount = subBetCount;
                CGSize labelSize = [muStr sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
                status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
                status.playType = playTypeCode;
                status.betType = @"09";
                //存储一组号码数据
                [YZStatusCacheTool saveStatus:status];
            }
        }
    }else if (selectedPlayTypeBtnTag == 8 || selectedPlayTypeBtnTag == 10)
    {
        NSMutableArray * cellStatusArray0 = selStatusArray[0];
        NSMutableArray * cellStatusArray1 = selStatusArray[1];//胆
        NSMutableString *muStr = [NSMutableString string];
        NSString *betType = nil;
        if (betCount == 1 && selectedPlayTypeBtnTag == 8) {
            YZBallBtn *ball00 = cellStatusArray0[0];
            YZBallBtn *ball01 = cellStatusArray0[1];
            [muStr appendFormat:@"%ld,%ld,%ld,%ld", ball00.tag - 10, ball00.tag - 10, ball01.tag - 10, ball01.tag - 10];
        }else
        {
            if (cellStatusArray1.count > 0) {
                [muStr appendString:[self getNumbersStringWithArray:cellStatusArray1 digit:@""]];
                [muStr appendString:@"$"];
            }
            NSMutableArray *cellStatusArray0_ = [NSMutableArray array];
            for(YZBallBtn *ball in cellStatusArray0)
            {
                if (![muStr containsString:ball.currentTitle]) {
                    YZBallBtn *ball_ = [YZBallBtn button];
                    ball_.tag = ball.tag - 10;
                    [cellStatusArray0_ addObject:ball_];
                }
            }
            [muStr appendString:[self getNumbersStringWithArray:cellStatusArray0_ digit:@""]];
        }
        if (cellStatusArray1.count > 0) {
            [muStr appendString:[NSString stringWithFormat:@"[%@胆拖%d注]", currentTitle, betCount]];
            betType = @"02";
        }else
        {
            if(betCount == 1)
            {
                [muStr appendString:[NSString stringWithFormat:@"[%@单式1注]",currentTitle]];
                betType = @"00";
            }else
            {
                [muStr appendString:[NSString stringWithFormat:@"[%@复式%d注]",currentTitle,betCount]];
                betType = @"01";
            }
        }
        //拼接完字符串后加颜色
        NSRange range = [muStr rangeOfString:@"["];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:muStr];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range.location, muStr.length-range.location)];
        
        YZBetStatus *status = [[YZBetStatus alloc] init];
        status.labelText = attStr;
        status.betCount = betCount;
        CGSize labelSize = [muStr sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        status.playType = playTypeCode;
        status.betType = betType;
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }else if (selectedPlayTypeBtnTag == 7 || selectedPlayTypeBtnTag == 9)
    {
        NSMutableArray * cellStatusArray0 = selStatusArray[0];//胆
        NSMutableArray * cellStatusArray1 = selStatusArray[1];
        
        NSMutableString *muStr = [NSMutableString string];
        NSString *betType = nil;
        if (betCount == 1) {
            if (selectedPlayTypeBtnTag == 7) {
                YZBallBtn *ball00 = cellStatusArray0[0];
                YZBallBtn *ball10 = cellStatusArray1[0];
                [muStr appendFormat:@"%ld,%ld,%ld,%ld", ball00.tag, ball10.tag - 10, ball00.tag, ball00.tag];
            }else if (selectedPlayTypeBtnTag == 9)
            {
                YZBallBtn *ball00 = cellStatusArray0[0];
                YZBallBtn *ball10 = cellStatusArray1[0];
                YZBallBtn *ball11 = cellStatusArray1[1];
                [muStr appendFormat:@"%ld,%ld,%ld,%ld", ball10.tag - 10, ball11.tag - 10, ball00.tag, ball00.tag];
            }
        }else
        {
            if (cellStatusArray0.count > 0) {
                [muStr appendString:[self getNumbersStringWithArray:cellStatusArray0 digit:@""]];
                [muStr appendString:@"$"];
            }
            NSMutableArray *cellStatusArray1_ = [NSMutableArray array];
            for(YZBallBtn *ball in cellStatusArray1)
            {
                if (![muStr containsString:ball.currentTitle]) {
                    YZBallBtn *ball_ = [YZBallBtn button];
                    ball_.tag = ball.tag - 10;
                    [cellStatusArray1_ addObject:ball_];
                }
            }
            [muStr appendString:[self getNumbersStringWithArray:cellStatusArray1_ digit:@""]];
        }
        
        if (cellStatusArray0.count > 0) {
            if(betCount == 1)
            {
                [muStr appendString:[NSString stringWithFormat:@"[%@单式1注]",currentTitle]];
                betType = @"00";
            }else
            {
                if ((cellStatusArray1.count == 1 && selectedPlayTypeBtnTag == 7) || (cellStatusArray1.count == 2 && selectedPlayTypeBtnTag == 9)) {
                    [muStr appendString:[NSString stringWithFormat:@"[%@单复式%d注]", currentTitle, betCount]];
                    muStr = [NSMutableString stringWithString:[muStr stringByReplacingOccurrencesOfString:@"$" withString:@"|"]];
                    betType = @"10";
                }else if (cellStatusArray0.count == 1)
                {
                    [muStr appendString:[NSString stringWithFormat:@"[%@重胆拖%d注]", currentTitle, betCount]];
                    betType = @"08";
                }else
                {
                    [muStr appendString:[NSString stringWithFormat:@"[%@重胆拖复式%d注]", currentTitle, betCount]];
                    betType = @"11";
                }
            }
        }else
        {
            if(betCount == 1)
            {
                [muStr appendString:[NSString stringWithFormat:@"[%@单式1注]",currentTitle]];
                betType = @"00";
            }else
            {
                [muStr appendString:[NSString stringWithFormat:@"[%@复式%d注]",currentTitle,betCount]];
                betType = @"01";
            }
        }
        //拼接完字符串后加颜色
        NSRange range = [muStr rangeOfString:@"["];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:muStr];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range.location, muStr.length-range.location)];
        
        YZBetStatus *status = [[YZBetStatus alloc] init];
        status.labelText = attStr;
        status.betCount = betCount;
        CGSize labelSize = [muStr sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        status.playType = playTypeCode;
        status.betType = betType;
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }else if (selectedPlayTypeBtnTag == 11 || selectedPlayTypeBtnTag == 12 || selectedPlayTypeBtnTag == 13 || selectedPlayTypeBtnTag == 14 || selectedPlayTypeBtnTag == 15 || selectedPlayTypeBtnTag == 16 || selectedPlayTypeBtnTag == 17 || selectedPlayTypeBtnTag == 18 || selectedPlayTypeBtnTag == 19 || selectedPlayTypeBtnTag == 20 || selectedPlayTypeBtnTag == 21)
    {
        NSMutableString *muStr = [NSMutableString string];
        NSString *betType = @"";
        NSInteger minBetCount = 0;
        if (selectedPlayTypeBtnTag == 11) {
            betType = @"12";
            minBetCount = 1;
        }else if (selectedPlayTypeBtnTag == 13 || selectedPlayTypeBtnTag == 14 || selectedPlayTypeBtnTag == 15 || selectedPlayTypeBtnTag == 16)
        {
            betType = @"09";
        }else if (selectedPlayTypeBtnTag == 17)
        {
            betType = @"10";
            minBetCount = 8;
        }else if (selectedPlayTypeBtnTag == 18)
        {
            betType = @"11";
            minBetCount = 7;
        }else if (selectedPlayTypeBtnTag == 19)
        {
            betType = @"15";
            minBetCount = 1;
        }else if (selectedPlayTypeBtnTag == 20)
        {
            betType = @"16";
            minBetCount = 1;
        }else if (selectedPlayTypeBtnTag == 21)
        {
            betType = @"13";
            minBetCount = 1;
        }
        NSMutableArray * cellStatusArray = selStatusArray.firstObject;
        if (selectedPlayTypeBtnTag == 12 || selectedPlayTypeBtnTag == 13) {
            if (betCount == 1) {
                for (NSMutableArray * cellStatusArray in selStatusArray) {
                    NSInteger index = [selStatusArray indexOfObject:cellStatusArray];
                    if (cellStatusArray.count > 0) {
                        YZBallBtn *ball = cellStatusArray.firstObject;
                        if (index == 0) {
                            [muStr appendFormat:@"%ld,%ld,", ball.tag - 99, ball.tag - 99];
                        }else if (index == 1)
                        {
                            [muStr appendFormat:@"%ld", ball.tag - 109];
                        }
                    }
                }
            }else
            {
                for (NSMutableArray * cellStatusArray in selStatusArray) {
                    if (cellStatusArray.count > 0) {
                        NSInteger index = [selStatusArray indexOfObject:cellStatusArray];
                        NSArray * muArr = [self sortBallsArray:cellStatusArray];
                        for(YZBallBtn *ball in muArr)
                        {
                            if (index == 0) {
                                [muStr appendFormat:@"%ld,", (long)ball.tag - 99];
                            }else if (index == 1)
                            {
                                [muStr appendFormat:@"%ld,", (long)ball.tag - 109];
                            }
                        }
                        [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个逗号
                        if (selectedPlayTypeBtnTag == 12) {
                            [muStr appendString:@"$"];
                        }else if (selectedPlayTypeBtnTag == 13)
                        {
                            [muStr appendString:@"|"];
                        }
                    }
                }
                [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个|
            }
        }else if (selectedPlayTypeBtnTag == 20)
        {
            if (cellStatusArray.count > 0) {
                NSMutableArray * muArr = [self sortBallsArray:cellStatusArray];
                for(YZBallBtn *ball in muArr)
                {
                    if (ball.tag == 1) {
                        [muStr appendFormat:@"%d,", 4];
                    }else if (ball.tag == 2)
                    {
                        [muStr appendFormat:@"%d,", 6];
                    }
                }
                [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个逗号
            }
        }else
        {
            if (cellStatusArray.count > 0) {
                [muStr appendString:[self getNumbersStringWithArray:cellStatusArray digit:@""]];
            }
        }
        if (selectedPlayTypeBtnTag == 12)
        {
            [muStr appendString:[NSString stringWithFormat:@"[%@%d注]", currentTitle, betCount]];
            betType = @"02";
        }else if (selectedPlayTypeBtnTag == 13)
        {
            if (betCount == 1) {
                [muStr appendString:[NSString stringWithFormat:@"[%@%d注]", currentTitle, betCount]];
                betType = @"00";
            }else
            {
                [muStr appendString:[NSString stringWithFormat:@"[%@%d注]", [currentTitle stringByReplacingOccurrencesOfString:@"单式" withString:@"单复式"], betCount]];
                betType = @"10";
            }
        }else if (selectedPlayTypeBtnTag == 14)
        {
            [muStr appendString:[NSString stringWithFormat:@"[%@%d注]", currentTitle, betCount]];
            betType = @"12";
        }else if (selectedPlayTypeBtnTag == 15)
        {
            [muStr appendString:[NSString stringWithFormat:@"[%@%d注]", currentTitle, betCount]];
            betType = @"13";
        }else if (selectedPlayTypeBtnTag == 16)
        {
            [muStr appendString:[NSString stringWithFormat:@"[%@%d注]", currentTitle, betCount]];
            betType = @"14";
        }else
        {
            if(betCount == minBetCount)
            {
                [muStr appendString:[NSString stringWithFormat:@"[%@单式1注]", currentTitle]];
                betType = @"00";
            }else
            {
                [muStr appendString:[NSString stringWithFormat:@"[%@复式%d注]", currentTitle, betCount]];
                betType = @"01";
            }
        }
        
        //拼接完字符串后加颜色
        NSRange range = [muStr rangeOfString:@"["];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:muStr];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range.location, muStr.length-range.location)];
        
        YZBetStatus *status = [[YZBetStatus alloc] init];
        status.labelText = attStr;
        status.betCount = betCount;
        CGSize labelSize = [muStr sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        status.playType = playTypeCode;
        status.betType = betType;
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}

#pragma mark - 快三
+ (void)commitKsBetWithNumbers:(NSMutableArray *)numbers selectedPlayTypeBtnTag:(NSInteger)tag
{
    if (numbers.count == 0) return;
    
    int betCount = 0;
    NSString * betType = @"00";
    NSString * playTypeCode;
    NSMutableString *muStr = [NSMutableString string];
    if (tag == 0) {//和值
        betCount = (int)numbers.count;
        betType = @"01";
        playTypeCode = @"04";
        for (NSNumber * number in numbers) {
            [muStr appendString:[NSString stringWithFormat:@"%d",[number intValue] + 3]];
            [muStr appendString:@","];
        }
        [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个逗号
        [muStr appendString:[NSString stringWithFormat:@"[和值%d注]",betCount]];
    }else if (tag == 1)//三同号
    {
        if ([numbers containsObject:@(6)]) {//三同号通选
            YZBetStatus *status = [[YZBetStatus alloc] init];
            NSMutableString *muStr = [NSMutableString string];
            for (int i = 1; i < 7; i++) {
                [muStr appendString:[NSString stringWithFormat:@"%d%d%d",i,i,i]];
                [muStr appendString:@","];
            }
            [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个逗号
            [muStr appendString:@"[三同号通选1注]"];
            NSRange range = [muStr rangeOfString:@"["];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:muStr];
            [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range.location)];
            [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range.location, muStr.length-range.location)];
            CGSize labelSize = [muStr sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
            status.labelText = attStr;
            status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
            status.betCount = 1;
            status.playType = @"07";
            status.betType = @"00";
            [YZStatusCacheTool saveStatus:status];
            [numbers removeObject:@(6)];
        }
        if (numbers.count > 0) {
            betCount = (int)numbers.count;
            playTypeCode = @"03";
            for (NSNumber * number in numbers) {
                [muStr appendString:[NSString stringWithFormat:@"%d,%d,%d",[number intValue] + 1,[number intValue] + 1,[number intValue] + 1]];
                [muStr appendString:@";"];
            }
            [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个分号
            [muStr appendString:[NSString stringWithFormat:@"[三同号%d注]",betCount]];
        }
    }else if (tag == 2) //二同号
    {
        NSArray * array1 = numbers[0];
        NSArray * array2 = numbers[1];
        NSArray * array3 = numbers[2];
        if ((array1.count == 0 || array2.count == 0) && array3.count == 0) return;
        //二同号复选
        if (array3.count > 0) {
            betCount = (int)array3.count;
            YZBetStatus *status = [[YZBetStatus alloc] init];
            NSMutableString *muStr = [NSMutableString string];
            for (NSNumber * number in array3) {
                [muStr appendString:[NSString stringWithFormat:@"%d%d;",[number intValue] + 1,[number intValue] + 1]];
            }
            [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个分号
            [muStr appendString:[NSString stringWithFormat:@"[二同号复选%d注]",betCount]];
            NSRange range = [muStr rangeOfString:@"["];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:muStr];
            [attStr addAttribute:NSForegroundColorAttributeName value:YZBaseColor range:NSMakeRange(0, range.location)];
            [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range.location, muStr.length-range.location)];
           CGSize labelSize = [muStr sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
            status.labelText = attStr;
            status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
            status.betCount = betCount;
            status.playType = @"06";
            betType = @"01";
            status.betType = betType;
            [YZStatusCacheTool saveStatus:status];
        }
        //二同号单选
        if (array1.count > 0 && array2.count > 0) {
            betCount = (int)array1.count * (int)array2.count;
            playTypeCode = @"02";
            if (array1.count == 1 && array2.count == 1) {
                for (NSNumber * number in array1) {
                    [muStr appendString:[NSString stringWithFormat:@"%d,%d,",[number intValue] + 1,[number intValue] + 1]];
                }
                for (NSNumber * number in array2) {
                    [muStr appendString:[NSString stringWithFormat:@"%d",[number intValue] + 1]];
                }
            }else
            {
                for (NSNumber * number in array1) {
                    [muStr appendString:[NSString stringWithFormat:@"%d%d,",[number intValue] + 1,[number intValue] + 1]];
                }
                [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个逗号
                [muStr appendString:@"|"];
                for (NSNumber * number in array2) {
                    [muStr appendString:[NSString stringWithFormat:@"%d,",[number intValue] + 1]];
                }
                [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个逗号
            }
            [muStr appendString:[NSString stringWithFormat:@"[二同号单选%d注]",betCount]];
        }
    }else if (tag == 3) //三不同号
    {
        if ([numbers containsObject:@(6)]) {
            YZBetStatus *status = [[YZBetStatus alloc] init];
            NSMutableString *muStr = [NSMutableString string];
            for (int i = 1; i < 5; i++) {
                [muStr appendString:[NSString stringWithFormat:@"%d%d%d,",i,i+1,i+2]];
            }
            [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个逗号
            [muStr appendString:@"[三连号通选1注]"];
            NSRange range = [muStr rangeOfString:@"["];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:muStr];
            [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range.location)];
            [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range.location, muStr.length-range.location)];
            CGSize labelSize = [muStr sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
            status.labelText = attStr;
            status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
            status.betCount = 1;
            status.playType = @"08";
            status.betType = betType;
            [YZStatusCacheTool saveStatus:status];
            [numbers removeObject:@(6)];
        }
        if (numbers.count < 3) return;
        betCount = [YZMathTool getCountWithN:(int)numbers.count andM:3];
        playTypeCode = @"01";
        for (NSNumber * number in numbers) {
            [muStr appendString:[NSString stringWithFormat:@"%d,",[number intValue] + 1]];
        }
        [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个分号
        [muStr appendString:[NSString stringWithFormat:@"[三不同号%d注]",betCount]];
    }else if (tag == 4)//二不同
    {
        if (numbers.count < 2) return;
        betCount = [YZMathTool getCountWithN:(int)numbers.count andM:2];
        playTypeCode = @"05";
        for (NSNumber * number in numbers) {
            [muStr appendString:[NSString stringWithFormat:@"%d,",[number intValue] + 1]];
        }
        [muStr deleteCharactersInRange:NSMakeRange(muStr.length-1, 1)];//去掉最后一个分号
        [muStr appendString:[NSString stringWithFormat:@"[二不同号%d注]",betCount]];
    }
    if (muStr.length > 0) {
        //拼接完字符串后加颜色
        NSRange range = [muStr rangeOfString:@"["];
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:muStr];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZRedTextColor range:NSMakeRange(0, range.location)];
        [attStr addAttribute:NSForegroundColorAttributeName value:YZGrayTextColor range:NSMakeRange(range.location, muStr.length-range.location)];
        
        if (tag != 0)
        {
            betType = betCount > 1 ? @"01" : @"00";
        }
        
        YZBetStatus *status = [[YZBetStatus alloc] init];
        status.labelText = attStr;
        status.betCount = betCount;
        CGSize labelSize = [muStr sizeWithFont:[UIFont systemFontOfSize:YZGetFontSize(30)] maxSize:CGSizeMake(screenWidth - 2 * YZMargin - 18 - 5, MAXFLOAT)];
        status.cellH = labelSize.height + 10 > 45 ? labelSize.height + 10 : 45;
        status.playType = playTypeCode;
        status.betType = betType;
        //存储一组号码数据
        [YZStatusCacheTool saveStatus:status];
    }
}
#pragma mark - 冒泡排序球数组
+ (NSMutableArray *)sortBallsArray:(NSMutableArray *)mutableArray
{
    if(mutableArray.count == 1) return mutableArray;
    for(int i = 0;i < mutableArray.count;i++)
    {
        for(int j = i + 1;j <mutableArray.count;j++)
        {
            YZBallBtn *ballBtn1 = mutableArray[i];
            YZBallBtn *ballBtn2= mutableArray[j];
            if(ballBtn1.tag > ballBtn2.tag)
            {
                [mutableArray replaceObjectAtIndex:i withObject:ballBtn2];
                [mutableArray replaceObjectAtIndex:j withObject:ballBtn1];
            }
        }
    }
    return mutableArray;
}

@end
