//
//  YZHttpTool.m
//  ez
//
//  Created by apple on 14-8-7.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define requestTimeoutInterval 25

#import "YZHttpTool.h"
#import "AFHTTPSessionManager.h"
#import "UIViewController+YZNoNetController.h"

@implementation YZHttpTool
+ (YZHttpTool *)shareInstance
{
    static YZHttpTool *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[[self class] alloc] init];
    });
    return shareInstance;
}
/**
 *  判断网络状态的POST请求
 */
- (void)requestTarget:(UIViewController*)target PostWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    if ([self checkNetState]) {//有网的时候去请求数据
        [target hiddenNonetWork];
        [self postWithURL:url params:params success:success failure:failure];
    }else{//没网时显示
        [target showNonetWork];
        [MBProgressHUD hideHUDForView:target.view animated:YES];
    }
}
- (void)requestTarget:(UIViewController*)target PostWithParams:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    if ([self checkNetState]) {//有网的时候去请求数据
        [target hiddenNonetWork];
        [self postWithParams:params success:success failure:failure];
    }else{//没网时显示
        [target showNonetWork];
        [MBProgressHUD hideHUDForView:target.view animated:YES];
    }
}
/**
 *  请求数据
 */
- (void)postWithParams:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 设置请求格式
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置请求时间
    mgr.requestSerializer.timeoutInterval = requestTimeoutInterval;
    // 设置返回格式
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    NSString *nowDateStr = [formatter stringFromDate:[NSDate date]];
    //发送请求
    NSDictionary *dict = @{
                           @"id":nowDateStr,
                           @"channel":mainChannel,
                           @"childChannel":childChannel,
                           @"clientVersion":[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],
                           };
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [tempDict addEntriesFromDictionary:params];//拼接参数
    [mgr POST:mcpUrl
   parameters:tempDict
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             
             failure(error);
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             NSInteger statusCode = response.statusCode;
             YZLog(@"error:%ld",statusCode);
             
             YZLog(@"系统繁忙 - YZHttpTool：%@",[NSString stringWithFormat:@"cmd=%@,error=%@",params[@"cmd"],error]);
             
             NSNumber *cmd = tempDict[@"cmd"];
             NSNumber *cmd1 = @(8026);//普通投注获取当期期次
             NSNumber *cmd2 = @(8027);//获取所有彩种信息
             NSNumber *cmd3 = @(8028);//竞彩足球投注获取当期期次
             if(!([cmd isEqualToNumber:cmd1] || [cmd isEqualToNumber:cmd2] || [cmd isEqualToNumber:cmd3]))//这俩个接口，获取不到数据会每秒提醒一次，故不提醒
             {
                 if ([self checkNetState]) {
                     [MBProgressHUD showError:@"加载失败，请稍后再试"];
                 }else
                 {
                     [MBProgressHUD showError:@"亲~~~网络不给力..."];
                 }
             }
         }
     }];
}
- (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 创建请求管理对象
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 设置请求格式
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置请求时间
    mgr.requestSerializer.timeoutInterval = requestTimeoutInterval;
    // 设置返回格式
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];

    //发送请求
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    NSString *nowDateStr = [formatter stringFromDate:[NSDate date]];
    NSDictionary *dict = @{
                           @"id":nowDateStr,
                           @"channel":mainChannel,
                           @"childChannel":childChannel,
                           @"clientVersion":[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],
                           @"sequence":[YZTool uuidString],
                           };
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (![tempDict.allKeys containsObject:@"version"]) {
        [tempDict setValue:@"0.0.1" forKey:@"version"];
    }
    NSString * KUserId = [YZUserDefaultTool getObjectForKey:@"userId"];
    if (!YZStringIsEmpty(KUserId)) {
        [tempDict setValue:KUserId forKey:@"userId"];
    }
    [tempDict addEntriesFromDictionary:params];//拼接参数
    // 发送请求
    [mgr POST:url
   parameters:tempDict
     progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         if (success) {
             success(responseObject);
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (failure) {
             failure(error);
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             NSInteger statusCode = response.statusCode;
             YZLog(@"error:%ld",statusCode);
             if ([self checkNetState]) {
                 [MBProgressHUD showError:@"加载失败，请稍后再试"];
             }else
             {
                 [MBProgressHUD showError:@"亲~~~网络不给力..."];
             }
         }
     }];
}
#pragma mark - 获取合买数据
- (void)getUnionBuyStatusWithUserName:(NSString *)userName gameId:(NSString *)gameId sortType:(SortType)sortType fieldType:(FieldType)fieldType  index:(NSInteger)index getSuccess:(void(^)(NSArray *unionBuys))getSuccess getFailure:(void(^)())getFailure
{
    NSMutableDictionary *dict = [@{
                                   @"cmd":@(8120),
                                   @"sort":@(1),//1：升序、2：降序
                                   @"field":@(1),//1：金额排序、2：进度排序、3：战绩排序
                                   @"pageIndex":@(index),
                                   @"pageSize":@(10),
                                   } mutableCopy];
    
    if(userName) [dict setValue:userName forKey:@"userName"];
    if(gameId) [dict setValue:gameId forKey:@"gameId"];
    if(sortType > 0) [dict setValue:@(sortType) forKey:@"sort"];
    if(fieldType > 0) [dict setValue:@(fieldType) forKey:@"field"];
    
    [[YZHttpTool shareInstance] postWithParams:dict success:^(id json) {
        
        YZLog(@"getAllUnionBuyStatusWithUserName - json = %@",json);
        if(SUCCESS)
        {
            getSuccess(json[@"unionBuys"]);
        }else
        {
            [MBProgressHUD showError:json[@"retDesc"]];
            getFailure();
        }
        
    } failure:^(NSError *error) {
        getFailure();
    }];
}
#pragma mark - 网络变化
/**
 *  判断网络状态
 *
 *  @return 返回状态 YES 为有网 NO 为没有网
 */
- (BOOL)checkNetState
{
    /*
     AFNetworkReachabilityStatusUnknown          = -1,
     AFNetworkReachabilityStatusNotReachable     = 0,
     AFNetworkReachabilityStatusReachableViaWWAN = 1,
     AFNetworkReachabilityStatusReachableViaWiFi = 2,
     */
    return [AFNetworkReachabilityManager sharedManager].isReachable;
}
//错误处理
+ (void)errorHandle:(NSURLSessionDataTask * _Nullable)task error:(NSError * _Nonnull)error failure:(void (^)(NSError *))failure
{
    
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
    NSInteger statusCode = response.statusCode;
    
//    error.statusCode = statusCode;
    
    if (statusCode == 401) {//密码错误
        
    } else if (statusCode == 0) {//没有网络
        
    } else if (statusCode == 500) {//参数错误
        
    } else if (statusCode == 404) {
        
    } else if (statusCode == 400) {
        
    }
//    
//    if (failure) {
//        failure(error);
//    }
}
@end
