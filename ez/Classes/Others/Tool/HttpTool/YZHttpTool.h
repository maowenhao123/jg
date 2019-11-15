//
//  YZHttpTool.h
//  ez
//
//  Created by apple on 14-8-7.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
typedef enum : NSUInteger {
    sortTypeAscending = 1,//1：升序
    sortTypeDescending = 2,//2：降序
} SortType;

typedef enum : NSUInteger {
    fieldTypeOrderByMoney = 1,//1：金额排序
    fieldTypeOrderByProgress = 2,//2：进度排序
    fieldTypeOrderByRecord = 3,//3：战绩排序
} FieldType;


typedef enum : NSUInteger {
    AccountRecordTypeMyBet = 0,//我的投注
    AccountRecordTypeMyScheme = 1,//我的追号
    AccountRecordTypeMyUnionBuy = 3,//我的合买
} AccountRecordType;

typedef enum : NSUInteger {
    ChooseNumberByBirthday = 1,
    ChooseNumberByPhone = 2,
    ChooseNumberByLuckyNumber = 3,
} ChooseNumberType;

#define Jump  [json[@"status"] isEqualToNumber:@(1)]  //1跳0不跳
#if JG
#define mainChannel @"local"
#elif ZC
#define mainChannel @"zhongcai"
#elif CS
#define mainChannel @"caidd"
#elif RR
#define mainChannel @"rrcai"
#endif

#define jumpURLStr @"http://html5.51mcp.com/ios/confirm.jsp"

////预发布环境
//#define baseUrl @"http://www1.51mcp.com"
//#define shareBaseUrl @"http://stage.ez1898.com"
//#define mcpUrl [NSString stringWithFormat:@"%@/portal/gateway",baseUrl]
//
//#if JG
//#define childChannel @"taylor"
//#elif ZC
//#define childChannel @"zc_taylor"
//#elif CS
//#define childChannel @"caidd_ios_taylor"
//#elif RR
//#define childChannel @"rrcai_ios_taylor"
//#endif

//正式环境
#define baseUrl @"http://www1.51mcp.com"
#define shareBaseUrl @"https://cp.ez1898.com"
#define mcpUrl [NSString stringWithFormat:@"%@/portal/gateway",baseUrl]

#if JG
#define childChannel @"ios_0001"
//#define childChannel @"ios_taylor"
#elif ZC
#define childChannel @"zc_ios_0001"
#elif CS
#define childChannel @"zc_ios"
#elif RR
#define childChannel @"rrcai_ios_taylor"
#endif

////测试环境
//#define baseUrl @"http://c.ez1898.com"
//#define shareBaseUrl @"http://test.ez1898.com"
//#define mcpUrl [NSString stringWithFormat:@"%@/portral/gateway",baseUrl]
//
//#if JG
//#define childChannel @"ios_test"
//#elif ZC
//#define childChannel @"zhongcai_ios"
//#elif CS
//#define childChannel @"zhongcai_ios"
//#elif RR
//#define childChannel @"rrcai_ios_taylor"
//#endif

////人人彩
//#define baseUrl @"http://api.qgmzn.com"
//#define shareBaseUrl [NSString stringWithFormat:@"%@/stakerules",baseUrl]
//#define mcpUrl [NSString stringWithFormat:@"%@/portal/gateway",baseUrl]
//#define childChannel @"rrcai_ios_adele"

//URL
#define baseH5Url @"http://s.51mcp.com"

#define BaseUrl(param) [NSString stringWithFormat:@"%@/%@", baseUrl, param]
//极光推送url
#define BaseUrlJiguang(param) [NSString stringWithFormat:@"%@/jiguang%@",baseUrl,param]
//代金券url
#define BaseUrlCoupon(param) [NSString stringWithFormat:@"%@/coupon%@",baseUrl,param]
//轮播图
#define BaseUrlAdvert(param) [NSString stringWithFormat:@"%@/advert%@",baseUrl,param]
//竞彩开奖
#define BaseUrlJingcai(param) [NSString stringWithFormat:@"%@/jingcai%@",baseUrl,param]
//充值方式
#define BaseUrlSalesManager(param) [NSString stringWithFormat:@"%@/sales-manager%@",baseUrl,param]
//中奖轮播
#define BaseUrlNotice(param) [NSString stringWithFormat:@"%@/notice%@",baseUrl,param]
//竞彩比赛详情
#define BaseUrlFootball(param) [NSString stringWithFormat:@"%@/football%@",baseUrl,param]
//环信
#define BaseUrlEasemob(param) [NSString stringWithFormat:@"%@/easemob%@",baseUrl,param]
//分享
#define BaseUrlShare(param) [NSString stringWithFormat:@"%@/promotion%@", baseUrl, param]
//预测
#define BaseUrlInformation(param) [NSString stringWithFormat:@"%@/information%@", baseUrl, param]
//积分
#define BaseUrlPoint(param) [NSString stringWithFormat:@"%@/point%@", baseUrl, param]
//彩友圈
#define BaseUrlCircle(param) [NSString stringWithFormat:@"%@/information-platform%@", baseUrl, param]

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface YZHttpTool : NSObject

+ (YZHttpTool *)shareInstance;
/**
 *  判断网络状态的POST请求
 */
- (void)requestTarget:(UIViewController*)target PostWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
- (void)requestTarget:(UIViewController*)target PostWithParams:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
/**
 *  发送一个POST请求
 *
 *  @param url     请求路径
 *  @param params  请求参数
 *  @param success 请求成功后的回调
 *  @param failure 请求失败后的回调
 */
- (void)postWithParams:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
- (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;
//合买大厅获取合买数据
- (void)getUnionBuyStatusWithUserName:(NSString *)userName gameId:(NSString *)gameId sortType:(SortType)sortType fieldType:(FieldType)fieldType  index:(NSInteger)index getSuccess:(void(^)(NSArray *unionBuys))getSuccess getFailure:(void(^)())getFailure;
#pragma mark - 图片上传
- (void)uploadWithImage:(UIImage *)image currentIndex:(NSInteger)currentIndex totalCount:(NSInteger)totalCount aliOssToken:(NSDictionary *)aliOssToken Success:(void (^)(NSString * picUrl))success Failure:(void (^)(NSError * error))failure Progress:(void(^)(float percent))percent;

@end
