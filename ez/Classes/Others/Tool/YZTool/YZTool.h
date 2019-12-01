//
//  YZTool.h
//  ez
//
//  Created by apple on 14/12/29.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZTool : NSObject

/**
 通过gameId、playType、betType 获得玩法名称、投注名称
 */
+ (NSString *)getPlayBetNameWithGameId:(NSString *)gameId playType:(NSString *)playType betType:(NSString *)betType;
#pragma mark - 彩票信息
/**
    通过gameId获得游戏名称
 */
+ (NSDictionary *)gameIdNameDict;
/**
 竞彩过关方式的字典
 */
+ (NSDictionary *)passWayDict;
/**
    通过gameId、playType获得玩法名称
 */
+ (NSDictionary *)playTypeName;
/**
 获取银行信息
 */
+ (NSDictionary *)getBankDicInfo;
/**
    通过betType获得投注名称
 */
+ (NSDictionary *)betTypeNameDict;
/**
 根据gameId获取游戏目的控制器
 */
+ (NSDictionary *)gameDestClassDict;
/**
 竞彩足球的玩法
 */
+ (NSDictionary *)footBallPlayTypeDic;
/**
 竞彩篮球的玩法
 */
+ (NSDictionary *)basketBallPlayTypeDic;
/**
 竞彩篮球胜负差
 */
+ (NSDictionary *)bBshengfenDic;
/**
 获取订单状态
 */
+ (NSString *)getOrderStatus:(int)status;
/**
 获取票状态
 */
+ (NSString *)getTicketStatus:(int)status;
/**
 获取追号状态
 */
+ (NSString *)getSchemeStatus:(int)status;
/**
 获取合买状态
 */
+ (NSString *)getUnionBuyStatus:(NSInteger)status;
/**
 获取合买订单保密状态
 */
+ (NSString *)getSecretStatus:(NSInteger)status;
#pragma mark - 支付
/**
 是否有足够的钱
 */
+ (BOOL)hasEnoughMoneyWithAmountMoney:(float)amountMoney;
/**
 获取确认支付alertView的文字
 */
+ (NSString *)getAlertViewTextWithAmountMoney:(float)amountMoney;

#pragma mark - 彩种统计图表设置
/**
 获取彩种统计图表设置信息
 */
+ (NSString *)getChartSettingByTitle:(NSString *)title;
/**
 设置彩种统计图表设置信息
 */
+ (void)setChartSettingWithTitle:(NSString *)title string:(NSString *)string;

#pragma mark - 11选5历史中奖设置
/**
 获取当前设置的信息
 */
+ (NSArray *)getCurrentSettingArray;

#pragma mark - 推送
/**
 设置极光推送的别名
 */
+ (void)setAlias;
/**
 注销极光推送的别名
 */
+ (void)logoutAlias;
+ (NSInteger)seq;

#pragma mark - 刷新数据
/*
 设置下拉刷新数据
 */
+ (void)setRefreshHeaderData:(MJRefreshHeader *)header;
/*
 设置下拉刷新gif图
 */
+ (void)setRefreshHeaderGif:(MJRefreshHeader *)header;
/*
 设置上拉加载数据
 */
+ (void)setRefreshFooterData:(MJRefreshFooter *)footer;
#pragma mark - 生成UUID
/*
 生成UUID
 */
+ (NSString *)uuidString;
#pragma mark - 进制转化
/**
 *  返回转换后的值,只能转换2,8,16进制
 *
 *  @para str 需要转换的值
 *
 *  @para sys 需要转换的进制
 */
+(NSString *)transformNumber:(NSString *)str withNumberSystem:(NSString *)sys;
#pragma mark - 处理小数
/**
 *  自适应保留小数
 *
 *  @param f 要处理的数字
 *
 *  @return 处理后的字符串
 */
+ (NSString *)formatFloat:(double)f;
#pragma mark - 获取底部安全区域
/**
 *  获取底部安全区域
 */
+ (CGFloat)getSafeAreaBottom;

#pragma mark - 获取竞彩足球顶部图片
/**
 *  获取竞彩足球顶部图片
 */
+ (UIImage *)getFBNavImage;

#pragma mark - 是否需要修改昵称
/**
 *  是否需要修改昵称
 */
+ (BOOL)needChangeNickName;

#pragma mark - 压缩图片
/**
 * 压缩图片
 *
 * @param myimage 要压缩的图片
 */
+ (UIImage *)imageCompressionWithImage:(UIImage *)myimage;
#pragma mark -- json转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


@end
