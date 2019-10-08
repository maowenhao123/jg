//
//  YZTool.m
//  ez
//
//  Created by apple on 14/12/29.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#import <HyphenateLite/HyphenateLite.h>
#import "YZTool.h"
#import "YZPlsViewController.h"
#import "YZFootBallViewController.h"
#import "YZBasketBallViewController.h"
#import "YZDltViewController.h"
#import "YZS1x5ViewController.h"
#import "YZSsqViewController.h"
#import "YZQxcViewController.h"
#import "YZPlwViewController.h"
#import "YZFucaiViewController.h"
#import "YZQilecaiViewController.h"
#import "YZSfcViewController.h"
#import "YZScjqViewController.h"
#import "YZKsViewController.h"
#import "YZSchemeSetmealViewController.h"
#import "JPUSHService.h"
#import "YZValidateTool.h"

@implementation YZTool

static NSDictionary *betTypeNameDict;

static NSDictionary *playTypeNameDict;

static NSDictionary *gameIdNameDict;

static NSDictionary *passWayDict;

static NSDictionary *footBallPlayTypeDic;

static NSDictionary *basketBallPlayTypeDic;

static NSDictionary *bBshengfenDic;

static NSArray *gameIds;

static NSDictionary *gameDestClassDict;

static NSDictionary * bankDicInfo;

+ (NSString *)getPlayBetNameWithGameId:(NSString *)gameId playType:(NSString *)playType betType:(NSString *)betType
{
    NSString *playName = self.playTypeName[gameId][playType];
    NSString *betName = self.betTypeNameDict[betType];
    
    NSString *playBetName = [NSString stringWithFormat:@"%@%@",playName,betName];
    
    return playBetName;
}
#pragma mark - 彩票信息
+ (NSDictionary *)betTypeNameDict
{
    if(betTypeNameDict == nil)
    {
        betTypeNameDict = @{
                            @"00" :@"单式",
                            @"01" :@"复式",
                            @"02" :@"胆拖",
                            @"03" :@"和值",
                            @"04" :@"组合复式",
                            @"05" :@"组合胆拖",
                            @"06" :@"跨度",
                            @"07" :@"定位",
                            
                            };
    }
    return betTypeNameDict;
}
+ (NSDictionary *)playTypeName
{
    if(playTypeNameDict == nil)
    {
        playTypeNameDict = @{
                             @"F01" : @{@"00" : @""},
                             @"F02" : @{@"01" : @"直选", @"02" : @"组选三", @"03" : @"组选六", @"04" : @"组选"},
                             @"F03" : @{@"00" : @""},
                             @"F04" : @{@"01" : @"三不同",@"02" : @"二同单选",@"03" : @"三同单选",@"04" : @"和值",@"05" : @"二不同",@"06" : @"二同复选",@"07" : @"三同通选",@"08" : @"三连通选"},
                             @"T01" : @{@"00" : @"", @"05" : @"追加"},
                             @"T02" : @{@"00" : @""},
                             @"T03" : @{@"01" : @"直选", @"04" : @"组选", @"02" : @"组选三", @"03" : @"组选六"},
                             @"T04" : @{@"00" : @""},
                             @"T05" : @{@"21" : @"任选一", @"22" : @"任选二", @"23" : @"任选三", @"24" : @"任选四", @"25" : @"任选五", @"26" : @"任选六", @"27" : @"任选七", @"28" : @"任选八", @"29" : @"前二组选", @"30" : @"前二直选", @"31" : @"前三组选", @"32" : @"前三直选",},
                             @"T61" : @{@"21" : @"任选一", @"22" : @"任选二", @"23" : @"任选三", @"24" : @"任选四", @"25" : @"任选五", @"26" : @"任选六", @"27" : @"任选七", @"28" : @"任选八", @"29" : @"前二组选", @"30" : @"前二直选", @"31" : @"前三组选", @"32" : @"前三直选",},
                             @"T62" : @{@"21" : @"任选一", @"22" : @"任选二", @"23" : @"任选三", @"24" : @"任选四", @"25" : @"任选五", @"26" : @"任选六", @"27" : @"任选七", @"28" : @"任选八", @"29" : @"前二组选", @"30" : @"前二直选", @"31" : @"前三组选", @"32" : @"前三直选",},
                             @"T63" : @{@"21" : @"任选一", @"22" : @"任选二", @"23" : @"任选三", @"24" : @"任选四", @"25" : @"任选五", @"26" : @"任选六", @"27" : @"任选七", @"28" : @"任选八", @"29" : @"前二组选", @"30" : @"前二直选", @"31" : @"前三组选", @"32" : @"前三直选",},
                             @"T64" : @{@"21" : @"任选一", @"22" : @"任选二", @"23" : @"任选三", @"24" : @"任选四", @"25" : @"任选五", @"26" : @"任选六", @"27" : @"任选七", @"28" : @"任选八", @"29" : @"前二组选", @"30" : @"前二直选", @"31" : @"前三组选", @"32" : @"前三直选",},
                             @"T51" : @{@"01" : @"让球胜平负", @"02" : @"胜平负", @"03" : @"比分", @"04" : @"总进球", @"05" : @"胜负半全场", @"06" : @"混合投注"},
                             @"T53" : @{@"01" : @"十四场", @"02" : @"任九场"},
                             @"T54" : @{@"01" : @"四场进球"},
                        };
    }
    return playTypeNameDict;
}
+ (NSArray *)gameIds
{
    if(gameIds == nil)
    {
        gameIds = @[@"F04",@"T05",@"T61",@"T62",@"T63",@"T64",@"T51",@"F01",@"T01",@"T03",@"T04",@"T02",@"F02",@"F03",@"T52",@"T53",@"T54"];
    }
    return gameIds;
}
+ (NSDictionary *)gameIdNameDict
{
    if(gameIdNameDict == nil)
    {
        gameIdNameDict = @{@"T03":@"排列三",@"T51":@"竞彩足球",@"T52":@"竞彩篮球",@"T01":@"大乐透", @"T05":@"11选5",@"T61":@"新11选5",@"T62":@"快乐11选5",@"T63":@"幸福11选5",@"T64":@"开心11选5",@"F01":@"双色球",@"T02":@"七星彩",@"T04":@"排列五",@"F02":@"福彩3D",@"F03":@"七乐彩",@"T52":@"竞彩篮球",@"T53":@"胜负彩",@"T54":@"四场进球",@"F04":@"快三"};
    }
    return gameIdNameDict;
}
+ (NSDictionary *)passWayDict
{
    if(passWayDict == nil)
    {
        passWayDict = @{@"11":@"单关",@"21":@"2串1",@"31":@"3串1",@"41":@"4串1",@"51":@"5串1",@"61":@"6串1",@"71":@"7串1",@"81":@"8串1",@"33":@"3串3",@"34": @"3串4",@"44":@"4串4",@"45": @"4串5", @"46":@"4串6", @"411":@"4串11", @"55":@"5串5",@"56":@"5串6", @"510":@"5串10", @"516":@"5串16", @"520":@"5串20", @"526":@"5串26", @"66":@"6串6", @"67":@"6串7",@"615":@"6串15", @"620":@"6串20", @"622":@"6串22", @"635":@"6串35", @"642":@"6串42", @"650":@"6串50", @"657":@"6串57",@"77":@"7串7", @"78":@"7串8", @"721":@"7串21", @"735":@"7串35", @"7120":@"7串120", @"88":@"8串8", @"89":@"8串9",@"828":@"8串28", @"856":@"8串56", @"870":@"8串70", @"8247":@"8串247"};
    }
    return passWayDict;
}
+ (NSDictionary *)gameDestClassDict
{
    if(gameDestClassDict == nil)
    {
        gameDestClassDict = @{
                              @"T51":[YZFootBallViewController class],
                              @"T52":[YZBasketBallViewController class],
                              @"T01":[YZDltViewController class],
                              @"T05":[YZS1x5ViewController class],
                              @"T61":[YZS1x5ViewController class],
                              @"T62":[YZS1x5ViewController class],
                              @"T63":[YZS1x5ViewController class],
                              @"T64":[YZS1x5ViewController class],
                              @"F01":[YZSsqViewController class],
                              @"T02":[YZQxcViewController class],
                              @"T04":[YZPlwViewController class],
                              @"F02":[YZFucaiViewController class],
                              @"F03":[YZQilecaiViewController class],
                              @"T53":[YZSfcViewController class],
                              @"T54":[YZScjqViewController class],
                              @"T03":[YZPlsViewController class],
                              @"F04":[YZKsViewController class],
                              @"TT":[YZSchemeSetmealViewController class]
                              };
    }
    return gameDestClassDict;
}
+ (NSDictionary *)footBallPlayTypeDic
{
    if(footBallPlayTypeDic == nil)
    {
        footBallPlayTypeDic = @{
                                @"01":@"让球胜平负",
                                @"02":@"胜平负",
                                @"03":@"比分",
                                @"04":@"总进球",
                                @"05":@"胜负半全场",
                                @"06":@"混合过关"
                                };
    }
    return footBallPlayTypeDic;
}
+ (NSDictionary *)basketBallPlayTypeDic
{
    if(basketBallPlayTypeDic == nil)
    {
        basketBallPlayTypeDic = @{
                                @"01":@"让球胜负",
                                @"02":@"胜负",
                                @"03":@"胜分差",
                                @"04":@"大小分",
                                @"05":@"混合过关"
                                };
    }
    return basketBallPlayTypeDic;
}
+ (NSDictionary *)bBshengfenDic
{
    if (bBshengfenDic == nil) {
        bBshengfenDic = @{
                         @"01": @"主胜1-5",
                         @"02": @"主胜6-10",
                         @"03": @"主胜11-15",
                         @"04": @"主胜16-20",
                         @"05": @"主胜21-25",
                         @"06": @"主胜26+",
                         @"11": @"客胜1-5",
                         @"12": @"客胜6-10",
                         @"13": @"客胜11-15",
                         @"14": @"客胜16-20",
                         @"15": @"客胜21-25",
                         @"16": @"客胜26+",
                         };
    }
    return bBshengfenDic;
}
+ (NSDictionary *)getBankDicInfo
{
    if (bankDicInfo == nil) {
        bankDicInfo = @{
                        @"中国银行":@"中国银行",
                        @"中国邮政储蓄银行":@"中国邮政储蓄银行",
                        @"中国工商银行":@"中国工商银行",
                        @"农信银":@"其他银行",
                        @"中信银行":@"中信银行",
                        @"工商银行":@"中国工商银行",
                        @"广州银行":@"其他银行",
                        @"交通银行":@"交通银行",
                        @"中国邮政银行":@"中国邮政储蓄银行",
                        @"中国民生银行":@"中国民生银行",
                        @"中国农商银行":@"其他银行",
                        @"中国农业银行":@"中国农业银行",
                        @"中国建设银行":@"中国建设银行",
                        @"中国邮储银行":@"中国邮政储蓄银行",
                        @"平安银行":@"平安银行",
                        @"中国光大银行":@"中国光大银行",
                        @"邮政":@"中国邮政储蓄银行",
                        @"杭州银行":@"其他银行",
                        @"招商银行":@"招商银行",
                        @"广发银行":@"广东发展银行",
                        @"广东发展银行":@"广东发展银行",
                        @"浦东发展银行":@"上海浦东发展银行",
                        @"上海浦东发展银行":@"上海浦东发展银行",
                        @"中国邮政储蓄":@"中国邮政储蓄银行",
                        };
    }
    return bankDicInfo;
}
+ (NSString *)getOrderStatus:(int)status
{
    switch (status) {
        case 1:
            return @"等待出票";
        case 2:
            return @"出票中";
        case 3:
            return @"出票成功";
        case 4:
            return @"投注失败";
        case 5:
            return @"部分出票";
        case 6:
            return @"已取消";
        case 7:
            return @"中奖截止";
        case 8:
            return @"已停追";
        default:
            return @"";
    }
}
+ (NSString *)getTicketStatus:(int)status
{
    switch (status) {
        case 1:
            return @"等待开期";
        case 2:
            return @"等待出票";
        case 3:
            return @"出票中";
        case 4:
            return @"出票成功";
        case 5:
            return @"出票失败";
        case 6:
            return @"已取消";
        case 7:
            return @"中奖截止";
        case 8:
            return @"已停追";
        default:
            return @"";
    }
}
+ (NSString *)getSchemeStatus:(int)status
{
    switch (status) {
        case 1:
            return @"进行中";
        case 2:
            return @"已完成";
        case 3:
            return @"已停追";
        case 4:
            return @"中奖已停追";
        default:
            return @"";
    }
}
+ (NSString *)getUnionBuyStatus:(NSInteger)status
{
    switch (status) {
        case 10:
            return @"方案进行中";
        case 20:
            return @"发起人撤单";
        case 30:
            return @"流单";
        case 40:
            return @"认购满员";
        case 50:
            return @"个保满员";
        case 60:
            return @"系保满员";
        default:
            return @"";
    }
}
+ (NSString *)getSecretStatus:(NSInteger)status
{
    switch (status) {
        case 1:
            return @"完全公开";
        case 2:
            return @"跟单可见";
        case 3:
            return @"截止可见";
        case 4:
            return @"完全保密";
        default:
            return @"";
    }
}
#pragma mark - 支付
//判断是否有足够的余额
+ (BOOL)hasEnoughMoneyWithAmountMoney:(float)amountMoney
{
    YZUser *user = [YZUserDefaultTool user];
    float balance = [user.balance floatValue] / 100;
    float bonus = [user.bonus floatValue] / 100;
    BOOL b = (balance + bonus) >= amountMoney;
    return b;
}
//支付时的弹出信息AlertView
+ (NSString *)getAlertViewTextWithAmountMoney:(float)amountMoney
{
    YZUser *user = [YZUserDefaultTool user];
    float balance = [user.balance floatValue] / 100;//彩金
    float bonus = [user.bonus floatValue] / 100;//奖金
    
    NSString *alertViewText = nil;
    
    if ((balance + bonus) < amountMoney)
    {
        alertViewText = [NSString stringWithFormat:@"对不起，余额不足，请充值"];
    } else if ((balance + bonus) >= amountMoney)
    {
        if (balance < amountMoney)
        {
            //扣除彩金和奖金
            alertViewText = [NSString stringWithFormat:@"彩金支付%0.2f元，奖金支付%0.2f元",balance,amountMoney - balance];
        } else if (balance >= amountMoney)
        {
            //只扣除彩金
            alertViewText = [NSString stringWithFormat:@"彩金支付%0.2f元",amountMoney];
        }
    }
    return alertViewText;
}

#pragma mark - 彩种统计图表设置
+ (NSString *)getChartSettingByTitle:(NSString *)title
{
    NSString *string = [[NSUserDefaults standardUserDefaults] objectForKey:title];
    NSDictionary *  defaultSettingDic = @{
                          @"期数":@"近100期",
                          @"排列":@"顺序排列",
                          @"折线":@"显示折线",
                          @"遗漏":@"显示遗漏",
                          @"统计":@"显示统计"
                          };
    if (YZStringIsEmpty(string)) {//为空的时候设置为默认
        string = defaultSettingDic[title];
    }
    return string;
}
+ (void)setChartSettingWithTitle:(NSString *)title string:(NSString *)string
{
    [[NSUserDefaults standardUserDefaults] setObject:string forKey:title];
}
#pragma mark - 11选5历史中奖设置
+ (NSArray *)getCurrentSettingArray
{
    NSString *currentQishuStr = [[NSUserDefaults standardUserDefaults] objectForKey:currentQishu];
    if (currentQishuStr == nil || currentQishuStr.length == 0) {
        currentQishuStr = @"近30期";
    }
    NSString *currentYilouStr = [[NSUserDefaults standardUserDefaults] objectForKey:currentYilou];
    if (currentYilouStr == nil || currentYilouStr.length == 0) {
        currentYilouStr = @"显示遗漏";
    }
    NSString *currentTongjiStr = [[NSUserDefaults standardUserDefaults] objectForKey:currentTongji];
    if (currentTongjiStr == nil || currentTongjiStr.length == 0) {
        currentTongjiStr = @"显示统计";
    }
    NSString *currentZhexianStr = [[NSUserDefaults standardUserDefaults] objectForKey:currentZhexian];
    if (currentZhexianStr == nil || currentZhexianStr.length == 0) {
        currentZhexianStr = @"显示折线";
    }
    NSString *currentHouliangweiStr = [[NSUserDefaults standardUserDefaults] objectForKey:currentHouliangwei];
    if (currentHouliangweiStr == nil || currentHouliangweiStr.length == 0) {
        currentHouliangweiStr = @"显示后";
    }
    NSArray * settingArray = @[currentQishuStr,currentYilouStr,currentTongjiStr,currentZhexianStr,currentHouliangweiStr];
    return (NSArray *)settingArray;
}

#pragma mark - 推送
static NSInteger seq = 0;
+ (void)setAlias
{
    if (!UserId)
    {
        NSSet * tagSet = [NSSet setWithArray:@[mainChannel, childChannel, [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]]];
        [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            [JPUSHService setTags:tagSet completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                YZLog(@"%ld", (long)iResCode);
            } seq:[YZTool seq]];
        }seq:[YZTool seq]];
        return;
    }
    
    [JPUSHService setAlias:UserId completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
        YZLog(@"setAlias：%ld", (long)iResCode);
    } seq:[self seq]];
    
    //设置tag
    NSDictionary *dict = @{
                           @"userId":UserId,
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlJiguang(@"/getTag") params:dict success:^(id json) {
        if (SUCCESS) {
            NSArray * tagArray = json[@"tag"];
            NSMutableSet * tagSet = [NSMutableSet setWithArray:tagArray];
            //获得当前版本号
            NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
            [tagSet addObject:currentVersion];
            [tagSet addObject:@"1abcdfasf"];
            [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                [JPUSHService setTags:tagSet completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                    YZLog(@"tagSet：%ld", (long)iResCode);
                } seq:[self seq]];
            }seq:[YZTool seq]];
        }
    } failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
    }];
}

+ (void)logoutAlias
{
//    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//
//    } seq:[self seq]];
//    [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
//
//    } seq:[self seq]];
    
    //退出环信
    HError *error = [[HChatClient sharedClient] logout:YES];
    if (error) { //登出出错
    } else {//登出成功
    }
}

+ (NSInteger)seq
{
    return ++ seq;
}

#pragma mark - 刷新数据

//设置下拉刷新数据
+ (void)setRefreshHeaderData:(MJRefreshHeader *)header
{
    if ([header isKindOfClass:[MJRefreshGifHeader class]]) {
        
    }
}
// 设置下拉刷新gif图
+ (void)setRefreshHeaderGif:(MJRefreshHeader *)header
{
    if ([header isKindOfClass:[MJRefreshGifHeader class]]) {
        MJRefreshGifHeader *gifHeader = (MJRefreshGifHeader *)header;
        // 设置文字
        [gifHeader setTitle:@"" forState:MJRefreshStateIdle];
        [gifHeader setTitle:@"" forState:MJRefreshStatePulling];
        [gifHeader setTitle:@"" forState:MJRefreshStateRefreshing];
        gifHeader.lastUpdatedTimeLabel.hidden= YES;//如果不隐藏这个会默认 图片在最左边不是在中间
        gifHeader.stateLabel.hidden = YES;
        NSMutableArray * images = [NSMutableArray array];
#if JG
        for (int i = 0; i < 10; i++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"RefreshGifHeader%d",i+1]];
            [images addObject:image];
        }
#elif ZC
        for (int i = 0; i < 10; i++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"RefreshGifHeader%d",i+1]];
            [images addObject:image];
        }
#elif CS
        for (int i = 0; i < 10; i++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"RefreshGifHeader%d",i+1]];
            [images addObject:image];
        }
#elif RR
        for (int i = 0; i < 12; i++) {
            UIImage * image = [UIImage imageNamed:[NSString stringWithFormat:@"RefreshGifHeader_%d_rr",i+1]];
            [images addObject:image];
        }
#endif
        [gifHeader setImages:images forState:MJRefreshStateIdle];
        [gifHeader setImages:images forState:MJRefreshStatePulling];
        [gifHeader setImages:images forState:MJRefreshStateRefreshing];
    }
}
// 设置上拉加载数据
+ (void)setRefreshFooterData:(MJRefreshFooter *)footer
{
    if ([footer isKindOfClass:[MJRefreshBackGifFooter class]]) {
        
    }
}
#pragma mark - 生成UUID
+ (NSString *)uuidString
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_ref);
    CFRelease(uuid_string_ref);
    return [uuid lowercaseString];
}
#pragma mark - 进制转化
+ (NSString *)transformNumber:(NSString *)str withNumberSystem:(NSString *)sys
{
    NSMutableString *mstring = [NSMutableString stringWithFormat:@"X"];
    NSString *bitString = [NSString stringWithFormat:@"0123456789ABCDEF"];
    long long int tmp = [str intValue],num = [sys intValue], p, a, b;
    if(num ==2)
    {
        a = 1;
        b = 1;
    }else if (num == 8)
    {
        a = 7;
        b = 3;
    }else if (num == 16)
    {
        a = 15;
        b = 4;
    }else
    {
        NSLog(@"您输入的进制错误!请输入2,8,16进制!");
        return nil;
    }
    while(tmp!=0)
    {
        p=tmp&a;
        NSString *str1=[NSString stringWithFormat:@"%c",[bitString characterAtIndex:p]];
        [mstring insertString:str1 atIndex:0];
        tmp=tmp>>b;
    }
    
    return [mstring substringWithRange:NSMakeRange(0, [mstring length]-1)];
}

#pragma mark - 处理小数
+ (NSString *)formatFloat:(double)f
{
    if (fmod(f, 1)==0) {//如果是整数
        return [NSString stringWithFormat:@"%.0f",f];
    } else if (fmod(f*10, 1)==0) {//如果有一位小数点
        return [NSString stringWithFormat:@"%.1f",f];
    } else {
        return [NSString stringWithFormat:@"%.2f",f];
    }
}

#pragma mark - 获取底部安全区域
+ (CGFloat)getSafeAreaBottom
{
    if (@available(iOS 11.0, *)) {
        return KEY_WINDOW.safeAreaInsets.bottom;
    }
    return 0;
}

#pragma mark - 获取竞彩足球顶部图片
+ (UIImage *)getFBNavImage
{
    CGFloat weight = 25 ;
    CGSize size = CGSizeMake(weight * 2, statusBarH + navBarH);
    CGRect rect = CGRectMake(0, 0, screenWidth, statusBarH + navBarH);
    UIColor * paleGreenColor = YZColor(122, 160, 60, 1);
    UIColor * drayGreenColor = YZColor(109, 151, 59, 1);
    
    UIGraphicsBeginImageContextWithOptions(size , NO, 0);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddRect(ctx, CGRectMake(0, 0, size.width, size.height));
    [paleGreenColor set];
    CGContextFillPath(ctx);

    CGContextMoveToPoint(ctx, weight, 0);
    CGContextAddLineToPoint(ctx, weight, statusBarH + navBarH);
    CGContextSetLineWidth(ctx, weight);
    [drayGreenColor set];
    CGContextStrokePath(ctx);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    UIColor *color=[UIColor colorWithPatternImage:img];
    UIImage * image = [UIImage ImageFromColor:color WithRect:rect];
    return image;
}

#pragma mark - 是否需要修改昵称
+ (BOOL)needChangeNickName
{
    YZUser *user = [YZUserDefaultTool user];
    if (YZStringIsEmpty(user.nickName)) {
        return YES;
    }
    NSString * nickName = user.nickName;
    if ([YZValidateTool validateMobile:nickName])//是手机号码
    {
        return YES;
    }
    NSString * first = [nickName substringWithRange:NSMakeRange(0, 1)];
    NSString * remain = [nickName substringWithRange:NSMakeRange(1, nickName.length - 1)];
    if ([YZValidateTool validateMobile:remain] && [first isEqualToString:@"m"]) {//默认昵称
        return YES;
    }
    return NO;
}

#pragma mark - 压缩图片
+ (UIImage *)imageCompressionWithImage:(UIImage *)myimage{
    NSData *data = UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(myimage, 0.9);
        }
    }
    return [UIImage imageWithData:data];
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) return nil;
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
