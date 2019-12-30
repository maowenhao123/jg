//
//  YZMathTool.m
//  ez
//
//  Created by apple on 16/7/25.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZMathTool.h"
#import "YZDateTool.h"

@implementation YZMathTool

//从n个元素中任选m个的可能
+ (int)getCountWithN:(int)n andM:(int)m
{
    if(n<m)
        return 0;
    int temp_sum;
    int temp_i;
    temp_sum=1;
    if(n==0 || m>n) temp_sum=0;
    if ((m!=0) && (m<n) && (n!=0))
    {
        if(2*m<n) m=n-m;
        temp_i=m+1;
        while(temp_i<=n)
        {
            temp_sum=temp_i*temp_sum;
            temp_i=temp_i+1;
        }
        temp_i=n-m;
        while(temp_i>1)
        {
            temp_sum=temp_sum / temp_i;
            temp_i=temp_i-1;
        }
    }
    return temp_sum;
}

+ (NSRange)get11x5Prize_dantuoWithTag:(int)tag danballscount:(int)danballscount tuoballscount:(int)tuoballscount betCount:(int)betCount
{
    NSRange prize = NSMakeRange(0, 0);
    int maxprize = 0 ;
    int minprize = 0;
    if(tag == 0){
        minprize = 6;
        if(betCount <=4){
            maxprize = 6 * betCount;
        }else{
            maxprize = 24;
        }
    }else if(tag == 1){
        minprize = 19;
        
        if(danballscount == 1){
            if(tuoballscount <=4){
                maxprize = 19 * betCount;
            }else {
                maxprize = 114;
            }
        }else if(danballscount ==2){
            if(tuoballscount <= 3){
                maxprize = 19 * betCount;
            }else {
                maxprize = 57;
            }
        }
    }else if(tag == 2){
        //        int redballs_danballs = 5 - danballscount;
        minprize = 78;
        //        if(redballs_danballs <= redballs_danballs){
        maxprize = 78 * betCount;
        //        }else{
        //            maxprize = 312;
        //        }
        
    }else if(tag == 3){
        minprize = 540;
        maxprize = 540;
    }else if(tag == 4){
        int total = tuoballscount+danballscount;
        int temp = total - 5;
        minprize = 90 ;
        maxprize = 90 * temp;
    }else if(tag == 5){
        minprize = 26;
        int total = tuoballscount + danballscount;
        if(danballscount <= 5){
            int temp = total -5;
            int temp_count = 0;
            for(int i = 1;i <= temp -1;i++){
                for(int j = i+1;j <= temp;j++){
                    temp_count++;
                }
            }
            maxprize = 26 * temp_count;
        }else{
            int temp = total - 6;
            maxprize = 26 * temp;
        }
    }else if(tag == 9){
        minprize = 65;
        maxprize = 65;
    }else if(tag == 11){
        minprize = 195;
        maxprize = 195;
    }
    prize.location = minprize;
    prize.length = maxprize;
    return prize;
}

+ (NSRange)get11x5Prize_putongWithTag:(int)tag selectballcount:(int)selectballcount betCount:(int)betCount
{
    int maxprize = 0;
    int minprize = 0;
    if(tag == 0){
        minprize = 13;
        maxprize = 13;
        
    }else if(tag == 1){
        minprize = 6;
        if(selectballcount <=5){
            maxprize = 6 * betCount;
        }else{
            maxprize = 60;
        }
    }else if(tag == 2){
        minprize = 19;
        if(selectballcount <=5){
            maxprize = 19 * betCount;
        }else{
            maxprize = 190;
        }
    }else if(tag == 3){
        minprize = 78;
        if(selectballcount <=5){
            maxprize = 78 * betCount;
        }else{
            maxprize = 390;
        }
    }else if(tag == 4){
        minprize = 540;
        maxprize = 540;
    }else if(tag == 5){
        int temp = selectballcount - 5;
        minprize = 90 * temp;
        maxprize = 90 * temp;
    }else if(tag == 6){
        minprize = 26;
        int temp = selectballcount - 5;
        int temp_count = 0;
        for(int x = 1;x<=temp-1;x++){
            for(int y = x+1;y <=temp;y++){
                temp_count++;
            }
        }
        maxprize = 26*temp_count;
    }else if(tag == 7){
        minprize = 9;
        int temp = selectballcount -5;
        int temp_count = 0;
        for(int x =1;x<=temp -2;x++){
            for(int y = x+1; y <=temp-1;y++){
                for(int z = y+1;z <=temp;z++){
                    temp_count++;
                }
            }
        }
        maxprize = 9*temp_count;
    }else if(tag == 8){
        minprize = 130;
        maxprize =130;
    }else if(tag == 9){
        minprize = 65;
        maxprize = 65;
    }else if(tag == 10){
        minprize = 1170;
        maxprize = 1170;
    }else if(tag == 11){
        minprize = 195;
        maxprize = 195;
    }
    NSRange prize = NSMakeRange(0, 0);
    prize.location = minprize;
    prize.length = maxprize;
    return prize;
}


+ (NSMutableArray *)get_yinglilvSmartBetArrayByBasemoney:(int)basemoney baseminprize:(int)baseminprize_value basemaxprize:(int)basemaxprize_value yinglilv:(int)yinglilv qihao:(int)qihao currentTermId:(NSString *)currentTermId qishu:(int)qishu firstbeishu:(int)firstbeishu currentleiji:(long)currentleiji
{
    BOOL issureadd = false;
    BOOL isfirst = true;
    
    int baseminprize = baseminprize_value;
    int basemaxprize = basemaxprize_value;
    
    int currentbeishu = 0;//每次计算出来的倍数
    int currentqihao = 0;
    
    int basecount = basemoney; //每注彩票的金额
    
    long currentminprize = 0;//每次计算出来的最小奖金
    long currentmaxprize = 0;//每次计算出来的最大奖金
    
    long currentminyingli = 0;
    long currentmaxyingli = 0;
    
    long leiji = 0;//累计
    
    NSMutableArray * smartBetArray = [NSMutableArray array];
    for (int i = 0; i < qishu; i++) {
        YZSmartBet * smartBet = [[YZSmartBet alloc]init];
        if(isfirst){
            isfirst = false;
            currentqihao = qihao;
            currentbeishu = firstbeishu;
            leiji = currentleiji + basecount * firstbeishu;
            currentminprize = baseminprize * currentbeishu;
            currentmaxprize = basemaxprize * currentbeishu;
            currentminyingli = currentminprize - leiji;
            currentmaxyingli = currentmaxprize - leiji;
            //            int temp_yinglilv = (int)((currentminyingli * 100)/(int)leiji);
            issureadd = true;
        }else{
            currentqihao = [self getCurrentqihaoByQihao:currentqihao curentitem:i qishu:qishu];
            BOOL isneedgo = true;
            int temp_beishu = currentbeishu;
            long temp_leiji = leiji + basecount * (temp_beishu-1);
            long temp_jiangjin_min = 0;
            long temp_jiangjin_max = 0;
            long temp_yingli_min = 0;
            long temp_yingli_max = 0;
            int temp_yinglilv = 0;
            while(isneedgo){
                
                temp_leiji = temp_leiji + basecount;
                temp_jiangjin_min = baseminprize_value * temp_beishu;
                temp_jiangjin_max = basemaxprize_value * temp_beishu;
                temp_yingli_min =  temp_jiangjin_min - temp_leiji;
                temp_yingli_max = temp_jiangjin_max - temp_leiji;
                
                temp_yinglilv = (int)((temp_yingli_min * 100)/(int)temp_leiji);
                if(temp_yinglilv < yinglilv) {
                    isneedgo = true;
                    temp_beishu ++;
                    if(temp_beishu > 10000){
                        isneedgo = false;
                        issureadd = false;
                        i = qishu +1;
                    }
                }
                else {
                    isneedgo = false;
                    issureadd = true;
                }
            }
            currentbeishu = temp_beishu;
            leiji = temp_leiji;
            currentminprize = temp_jiangjin_min;
            currentmaxprize = temp_jiangjin_max;
            currentminyingli = temp_yingli_min;
            currentmaxyingli = temp_yingli_max;
        }
        //赋值
        NSString * dateString = [NSString stringWithFormat:@"20%@",[currentTermId substringToIndex:6]];
        NSString * dateStr = [YZDateTool getChineseDateStringFromDateString:dateString format:@"yyyyMMdd"];
        smartBet.dateStr = dateStr;
        
        smartBet.isTomorrow = [self isTomorrowByQihao:currentqihao curentitem:i qishu:qishu];
        smartBet.termId = [NSString stringWithFormat:@"%02d",currentqihao];
        smartBet.multiple = [NSString stringWithFormat:@"%d",currentbeishu];
        smartBet.total = [NSString stringWithFormat:@"%ld",leiji];
        //奖金
        if (currentminprize == currentmaxprize) {
            smartBet.bonus = [NSString stringWithFormat:@"%ld",currentminprize];
        }else
        {
            smartBet.bonus = [NSString stringWithFormat:@"%ld至%ld",currentminprize,currentmaxprize];
        }
        //盈利
        if (currentminyingli == currentmaxyingli) {
            smartBet.profit = [NSString stringWithFormat:@"%ld",currentminyingli];
        }else
        {
            smartBet.profit = [NSString stringWithFormat:@"%ld至%ld",currentminyingli,currentmaxyingli];
        }
        if ([smartBet.multiple intValue] < 10000) {
            [smartBetArray addObject:smartBet];
        }
    }
    return smartBetArray;
}

+ (NSMutableArray *)get_changeSmartBetArrayByBasemoney:(int)basemoney baseminprize:(int)baseminprize_value basemaxprize:(int)basemaxprize_value firstqishu:(int)firstqishu firstyinglilv:(int)firstyinglilv secondyinglilv:(int)secondyinglilv qihao:(int)qihao currentTermId:(NSString *)currentTermId qishu:(int)qishu firstbeishu:(int)firstbeishu currentleiji:(long)currentleiji
{
    BOOL issureadd = false;
    
    BOOL isfirst = true;
    
    int basecount = 2;
    int baseminprize = baseminprize_value;
    int basemaxprize = basemaxprize_value;
    int currentqihao = 0;
    int currentbeishu = 0;
    long leiji = 0;
    long currentminprize = 0;//每次计算出来的最小奖金
    long currentmaxprize = 0;//每次计算出来的最大奖金
    
    long currentminyingli = 0;
    long currentmaxyingli = 0;
    
    NSMutableArray * smartBetArray = [NSMutableArray array];
    for (int i = 0; i < qishu; i++) {
        YZSmartBet * smartBet = [[YZSmartBet alloc]init];
        if(isfirst){
            isfirst = false;
            currentqihao = qihao;
            currentbeishu = firstbeishu;
            leiji = currentleiji + basecount * firstbeishu;
            currentminprize = baseminprize * currentbeishu;
            currentmaxprize = basemaxprize * currentbeishu;
            currentminyingli = currentminprize - leiji;
            currentmaxyingli = currentmaxprize - leiji;
            int temp_yinglilv = (int)((currentminyingli * 100)/(int)leiji);
            if(temp_yinglilv < firstyinglilv){
                issureadd = false;
                i=qishu +1;
            }else {
                issureadd = true;
            }
        }else{
            currentqihao = [self getCurrentqihaoByQihao:currentqihao curentitem:i qishu:qishu];
            if(i<=firstqishu){
                BOOL isneedgo = true;
                int temp_beishu = currentbeishu;
                long temp_leiji = leiji + basecount * (temp_beishu-1);
                long temp_jiangjin_min = 0;
                long temp_jiangjin_max = 0;
                long temp_yingli_min = 0;
                long temp_yingli_max = 0;
                int temp_yinglilv = 0;
                while(isneedgo){
                    
                    
                    temp_leiji = temp_leiji + basecount ;
                    temp_jiangjin_min = baseminprize * temp_beishu;
                    temp_jiangjin_max = basemaxprize * temp_beishu;
                    temp_yingli_min = temp_jiangjin_min - temp_leiji;
                    temp_yingli_max = temp_jiangjin_max - temp_leiji;
                    temp_yinglilv = (int)(temp_yingli_min * 100)/(int)temp_leiji;
                    if(temp_yinglilv <firstyinglilv) {
                        isneedgo = true;
                        temp_beishu ++;
                        if(temp_beishu > 10000){
                            isneedgo = false;
                            issureadd = false;
                            i = firstqishu+1;
                        }
                        
                    }
                    else {
                        isneedgo = false;
                        issureadd = true;
                    }
                }
                currentbeishu = temp_beishu;
                leiji = temp_leiji;
                currentminprize = temp_jiangjin_min;
                currentmaxprize = temp_jiangjin_max;
                currentminyingli = temp_yingli_min;
                currentmaxyingli = temp_yingli_max;
            }else{
                BOOL isneedgo = true;
                int temp_beishu = currentbeishu;
                long temp_leiji = leiji + basecount * (temp_beishu-1);
                long temp_jiangjin_min = 0;
                long temp_jiangjin_max = 0;
                long temp_yingli_min = 0;
                long temp_yingli_max = 0;
                int temp_yinglilv = 0;
                while(isneedgo){
                    
                    temp_leiji = temp_leiji + basecount;
                    temp_jiangjin_min = baseminprize * temp_beishu;
                    temp_jiangjin_max = basemaxprize * temp_beishu;
                    
                    temp_yingli_min = temp_jiangjin_min - temp_leiji;
                    temp_yingli_max = temp_jiangjin_max - temp_leiji;
                    
                    temp_yinglilv = (int)(temp_yingli_min * 100)/(int)temp_leiji;
                    if(temp_yinglilv <secondyinglilv) {
                        isneedgo = true;
                        temp_beishu ++;
                        if(temp_beishu > 10000){
                            isneedgo = false;
                            issureadd = false;
                            i = qishu+1;
                        }
                    }
                    else {
                        isneedgo = false;
                        issureadd = true;
                    }
                }
                currentbeishu = temp_beishu;
                leiji = temp_leiji;
                currentminprize = temp_jiangjin_min;
                currentmaxprize = temp_jiangjin_max;
                currentminyingli = temp_yingli_min;
                currentmaxyingli = temp_yingli_max;
            }
        }
        //赋值
        NSString * dateString = [NSString stringWithFormat:@"20%@",[currentTermId substringToIndex:6]];
        NSString * dateStr = [YZDateTool getChineseDateStringFromDateString:dateString format:@"yyyyMMdd"];
        smartBet.dateStr = dateStr;
        
        smartBet.isTomorrow = [self isTomorrowByQihao:currentqihao curentitem:i qishu:qishu];
        smartBet.termId = [NSString stringWithFormat:@"%02d",currentqihao];
        smartBet.multiple = [NSString stringWithFormat:@"%d",currentbeishu];
        smartBet.total = [NSString stringWithFormat:@"%ld",leiji];
        //奖金
        if (currentminprize == currentmaxprize) {
            smartBet.bonus = [NSString stringWithFormat:@"%ld",currentminprize];
        }else
        {
            smartBet.bonus = [NSString stringWithFormat:@"%ld至%ld",currentminprize,currentmaxprize];
        }
        //盈利
        if (currentminyingli == currentmaxyingli) {
            smartBet.profit = [NSString stringWithFormat:@"%ld",currentminyingli];
        }else
        {
            smartBet.profit = [NSString stringWithFormat:@"%ld至%ld",currentminyingli,currentmaxyingli];
        }
        if ([smartBet.multiple intValue] < 10000) {
            [smartBetArray addObject:smartBet];
        }
    }
    return smartBetArray;
}

+ (NSMutableArray *)get_lessSmartBetArrayByBasemoney:(int)basemoney baseminprize:(int)baseminprize_value basemaxprize:(int)basemaxprize_value qihao:(int)qihao currentTermId:(NSString *)currentTermId qishu:(int)qishu firstbeishu:(int)firstbeishu lessyingli:(int)lessyingli currentleiji:(long)currentleiji
{
    BOOL isfirst = true;
    BOOL issureadd = false;
    
    int basecount = 2; //每注彩票的金额
    
    int baseminprize = baseminprize_value;
    int basemaxprize = basemaxprize_value;
    
    int currentqihao = 0; // 每次的当前期号
    int currentbeishu = 0;//每次计算出来的倍数
    
    long leiji = 0;//累计
    
    long currentminprize = 0;//每次计算出来的最小奖金
    long currentmaxprize = 0;//每次计算出来的最大奖金
    
    long currentminyingli = 0;
    long currentmaxyingli = 0;
    
    NSMutableArray * smartBetArray = [NSMutableArray array];
    for (int i = 0; i < qishu; i++) {
        YZSmartBet * smartBet = [[YZSmartBet alloc]init];
        if(isfirst){
            BOOL isneedgo = true;
            isfirst = false;
            currentqihao = qihao;
            currentbeishu = firstbeishu;
            leiji = currentleiji + basecount * firstbeishu;
            currentminprize =  baseminprize * currentbeishu;
            currentmaxprize = basemaxprize * currentbeishu;
            currentminyingli = currentminprize - leiji;
            currentmaxyingli = currentmaxprize - leiji;
            while(isneedgo){
                if(currentminyingli >= lessyingli){
                    issureadd = true;
                    isneedgo = false;
                }else{
                    currentbeishu++;
                    if(currentbeishu > 10000){
                        issureadd = false;
                        isneedgo = false;
                        i = qishu+1;
                    }
                }
                leiji = leiji + basecount;
                currentminprize =  baseminprize * currentbeishu;
                currentmaxprize = basemaxprize * currentbeishu;
                currentminyingli = currentminprize - leiji;
                currentmaxyingli = currentmaxprize - leiji;
            }
        }else{
            currentqihao = [self getCurrentqihaoByQihao:currentqihao curentitem:i qishu:qishu];
            BOOL isneedgo = true;
            int temp_beishu = currentbeishu;
            long temp_leiji = leiji + basecount * (temp_beishu-1);
            long temp_jiangjin_min = 0;
            long temp_jiangjin_max = 0;
            long temp_yingli_min = 0;
            long temp_yingli_max = 0;
            while(isneedgo){
                
                temp_leiji = temp_leiji + basecount ;
                temp_jiangjin_min = baseminprize * temp_beishu;
                temp_jiangjin_max = basemaxprize * temp_beishu;
                temp_yingli_min = temp_jiangjin_min - temp_leiji;
                temp_yingli_max = temp_jiangjin_max - temp_leiji;
                if(temp_yingli_min <lessyingli) {
                    isneedgo = true;
                    temp_beishu ++;
                    if(temp_beishu > 10000){
                        isneedgo = false;
                        issureadd = false;
                        i = qishu +1;
                    }
                }
                else {
                    isneedgo = false;
                    issureadd = true;
                }
            }
            currentbeishu = temp_beishu;
            leiji = temp_leiji;
            currentminprize = temp_jiangjin_min;
            currentmaxprize = temp_jiangjin_max;
            currentminyingli = temp_yingli_min;
            currentmaxyingli = temp_yingli_max;
            
        }
        //赋值
        NSString * dateString = [NSString stringWithFormat:@"20%@",[currentTermId substringToIndex:6]];
        NSString * dateStr = [YZDateTool getChineseDateStringFromDateString:dateString format:@"yyyyMMdd"];
        smartBet.dateStr = dateStr;
        smartBet.isTomorrow = [self isTomorrowByQihao:currentqihao curentitem:i qishu:qishu];
        smartBet.termId = [NSString stringWithFormat:@"%02d",currentqihao];
        smartBet.multiple = [NSString stringWithFormat:@"%d",currentbeishu];
        smartBet.total = [NSString stringWithFormat:@"%ld",leiji];
        //奖金
        if (currentminprize == currentmaxprize) {
            smartBet.bonus = [NSString stringWithFormat:@"%ld",currentminprize];
        }else
        {
            smartBet.bonus = [NSString stringWithFormat:@"%ld至%ld",currentminprize,currentmaxprize];
        }
        //盈利
        if (currentminyingli == currentmaxyingli) {
            smartBet.profit = [NSString stringWithFormat:@"%ld",currentminyingli];
        }else
        {
            smartBet.profit = [NSString stringWithFormat:@"%ld至%ld",currentminyingli,currentmaxyingli];
        }
        if ([smartBet.multiple intValue] < 10000) {
            [smartBetArray addObject:smartBet];
        }
    }
    return smartBetArray;
}
//获取当前期号
+ (int)getCurrentqihaoByQihao:(int)qihao curentitem:(int)curentitem qishu:(int)qishu
{
    int currentQihao = 0;
    if(qihao == 78){
        if(curentitem == qishu){
            currentQihao = qihao +1;
        }else
        {
            currentQihao = 01;
        }
    }else
    {
        currentQihao = qihao +1;
    }
    return  currentQihao;
}

//是否显示明天
+ (BOOL)isTomorrowByQihao:(int)qihao curentitem:(int)curentitem qishu:(int)qishu
{
    BOOL isTomorrow = NO;
    if(qihao == 78){
        if(curentitem == qishu){
            isTomorrow = false;
        }else
        {
            isTomorrow = true;
        }
    }else
    {
        isTomorrow = false;
    }
    
    return isTomorrow;
}

+ (NSMutableArray *)get_changeBeishuSmartBetArrayBySmartBetArray:(NSMutableArray *)smartBetArray itemnum:(int)itemnum beishu:(int)beishu
{
    NSMutableArray * newSmartBetArray = [NSMutableArray arrayWithArray:smartBetArray];
    YZSmartBet * smartBetFirst = [newSmartBetArray firstObject];
    int basemoney = [smartBetFirst.total intValue]/[smartBetFirst.multiple intValue];
    NSString * bonus = smartBetFirst.bonus;
    int minprize = 0;
    int maxprize = 0;
    if ([bonus rangeOfString:@"至"].location == NSNotFound) {
        maxprize = [bonus intValue];
        minprize = [bonus intValue];
    }else
    {
        NSArray * prizes = [bonus componentsSeparatedByString:@"至"];
        minprize = [prizes[0] intValue];
        maxprize = [prizes[1] intValue];
    }
    int baseminprize2 = minprize/[smartBetFirst.multiple intValue];
    int basemaxprize2 = maxprize/[smartBetFirst.multiple intValue];
    long beforeleiji = 0;
    
    if(itemnum == 0){
        beforeleiji = 0;
    }else
    {
        YZSmartBet * smartBetLast = newSmartBetArray[itemnum - 1];
        beforeleiji = [smartBetLast.total intValue];
    }
    
    long currentleiji2 = beforeleiji;
    BOOL isfirst = true;
    for(int i = itemnum;i < newSmartBetArray.count;i++){
        YZSmartBet * smartBet = newSmartBetArray[i];
        if(isfirst){
            isfirst = false;
            smartBet.multiple = [NSString stringWithFormat:@"%d",beishu];
            if (baseminprize2 == basemaxprize2) {
                smartBet.bonus = [NSString stringWithFormat:@"%d",baseminprize2 * beishu];
            }else
            {
                smartBet.bonus = [NSString stringWithFormat:@"%d至%d",baseminprize2 *beishu,basemaxprize2 *beishu];
            }
        }
        currentleiji2 = currentleiji2 + basemoney * [smartBet.multiple intValue];
        
        smartBet.total = [NSString stringWithFormat:@"%ld",currentleiji2];
        
        if ([smartBet.profit rangeOfString:@"至"].location == NSNotFound) {
            smartBet.profit = [NSString stringWithFormat:@"%ld",[smartBet.bonus intValue] - currentleiji2];
        }else
        {
            NSArray * prizes_ = [smartBet.bonus componentsSeparatedByString:@"至"];
            int minprize_ = [prizes_[0] intValue];
            int maxprize_ = [prizes_[1] intValue];
            smartBet.profit = [NSString stringWithFormat:@"%ld至%ld",minprize_- currentleiji2,maxprize_ - currentleiji2];
        }
    }
    
    return newSmartBetArray;
}

+ (NSRange)getKsPrizeWithTag:(int)tag selectNumbers:(NSArray *)selectNumbers
{
    NSRange prize = NSMakeRange(0, 0);
    int maxprize = 0;
    int minprize = 0;
    if (tag == 0) {//和值
        NSArray * prizes = @[@(240),@(80),@(40),@(25),@(16),@(12),@(10),@(9)];
        minprize = 240;
        for (NSNumber * selectNumber in selectNumbers) {
            int number = [selectNumber intValue];
            int prizeNumber = 0;
            if (number > 7) {
                number = 15 - number;
            }
            prizeNumber = [prizes[number] intValue];
            minprize = minprize < prizeNumber ? minprize : prizeNumber;
            maxprize = maxprize > prizeNumber ? maxprize : prizeNumber;
        }
    }else if (tag == 1)//三同
    {
        if ([selectNumbers containsObject:@(6)]) {
            if (selectNumbers.count == 1) {
                maxprize = 40;
                minprize = 40;
            }else
            {
                maxprize = 280;
                minprize = 40;
            }
        }else
        {
            maxprize = 240;
            minprize = 240;
        }
    }else if (tag == 2)//二同号
    {
        NSArray * selectNumbers1 = selectNumbers[0];
        NSArray * selectNumbers2 = selectNumbers[1];
        NSArray * selectNumbers3 = selectNumbers[2];
        BOOL haveDan = selectNumbers1.count != 0 && selectNumbers2.count != 0;
        BOOL haveFu = selectNumbers3.count != 0;
        if (haveDan && haveFu) {
            maxprize = 95;
            minprize = 15;
        }else if (!haveDan && haveFu)
        {
            maxprize = 15;
            minprize = 15;
        }else if (haveDan && !haveFu)
        {
            maxprize = 80;
            minprize = 80;
        }else if (!haveDan && !haveFu)
        {
            maxprize = 0;
            minprize = 0;
        }
    }else if (tag == 3)//三不同
    {
        if ([selectNumbers containsObject:@(6)]) {
            maxprize = 50;
            minprize = 10;
        }else{
            maxprize = 40;
            minprize = 40;
        }
    }else if (tag == 4)//二不同
    {
        minprize = 8;
        if (selectNumbers.count > 2) {
            maxprize = 24;
        }else{
            maxprize = 8;
        }
    }
    prize.location = minprize;
    prize.length = maxprize;
    return prize;
}

@end
