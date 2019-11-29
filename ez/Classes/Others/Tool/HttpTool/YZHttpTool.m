//
//  YZHttpTool.m
//  ez
//
//  Created by apple on 14-8-7.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define requestTimeoutInterval 25

#import <AliyunOSSiOS/OSSService.h>
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
- (void) postWithParams:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
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
    
    NSString * posternBaseUrl = [YZUserDefaultTool getObjectForKey:@"PosternBaseUrl"];
    NSString * posternMainChannel = [YZUserDefaultTool getObjectForKey:@"PosternMainChannel"];
    NSString * posternChildChannel = [YZUserDefaultTool getObjectForKey:@"PosternChildChannel"];
    if (YZStringIsEmpty(posternBaseUrl)) {
        posternBaseUrl = mcpUrl;
    }
    if (YZStringIsEmpty(posternMainChannel)) {
        posternMainChannel = mainChannel;
    }
    if (YZStringIsEmpty(posternChildChannel)) {
        posternChildChannel = childChannel;
    }
    //发送请求
    NSDictionary *dict = @{
                           @"id":nowDateStr,
                           @"channel":posternMainChannel,
                           @"childChannel":posternChildChannel,
                           @"clientVersion":[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],
                           };
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    [tempDict addEntriesFromDictionary:params];//拼接参数
    [mgr POST:posternBaseUrl
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

    NSString * posternMainChannel = [YZUserDefaultTool getObjectForKey:@"PosternMainChannel"];
    NSString * posternChildChannel = [YZUserDefaultTool getObjectForKey:@"PosternChildChannel"];
    if (YZStringIsEmpty(posternMainChannel)) {
        posternMainChannel = mainChannel;
    }
    if (YZStringIsEmpty(posternChildChannel)) {
        posternChildChannel = childChannel;
    }
    
    //发送请求
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    NSString *nowDateStr = [formatter stringFromDate:[NSDate date]];
    NSDictionary *dict = @{
                           @"id":nowDateStr,
                           @"channel":posternMainChannel,
                           @"childChannel":posternChildChannel,
                           @"clientVersion":[NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"],
                           @"sequence":[YZTool uuidString],
                           };
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (![tempDict.allKeys containsObject:@"version"]) {
        [tempDict setValue:@"0.0.1" forKey:@"version"];
    }
    NSString * KUserId = [YZUserDefaultTool getObjectForKey:@"userId"];
    if (!YZStringIsEmpty(KUserId) && ![tempDict.allKeys containsObject:@"userId"]) {
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
//上传图片
- (void)uploadWithImage:(UIImage *)image currentIndex:(NSInteger)currentIndex totalCount:(NSInteger)totalCount aliOssToken:(NSDictionary *)aliOssToken Success:(void (^)(NSString * picUrl))success Failure:(void (^)(NSError * error))failure Progress:(void(^)(float percent))percent
{
    __block MBProgressHUD *HUD;
    dispatch_async(dispatch_get_main_queue(), ^{
        HUD = [MBProgressHUD showHUDAddedTo:KEY_WINDOW animated:YES];
        HUD.mode = MBProgressHUDModeAnnularDeterminate;//圆环作为进度条
        if (totalCount == 1)
        {
            HUD.label.text = @"图片上传中....";
        }else
        {
            HUD.label.text = [NSString stringWithFormat:@"%ld/%ld图片上传中....", (long)currentIndex, totalCount];
        }
    });
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = aliOssToken[@"bucket"];
    // 设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@%@.png", aliOssToken[@"path"], str];
    put.objectKey = fileName;
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > 300 && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    put.uploadingData = data; // 直接上传NSData
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        percent(1.0 * totalByteSent / totalBytesExpectedToSend);
        dispatch_async(dispatch_get_main_queue(), ^{
            HUD.progress = 1.0 * totalByteSent / totalBytesExpectedToSend;
        });
    };
    NSString *endpoint = [NSString stringWithFormat:@"%@", aliOssToken[@"url"]];
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc] initWithAccessKeyId:aliOssToken[@"accessKeyId"] secretKeyId:aliOssToken[@"accessKeySecret"] securityToken:aliOssToken[@"securityToken"]];
    OSSClient *client = [[OSSClient alloc] initWithEndpoint:endpoint credentialProvider:credential];
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        task = [client presignPublicURLWithBucketName:aliOssToken[@"bucket"]
                                            withObjectKey:fileName];
        if (!task.error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD hideAnimated:YES];
                success(task.result);
                NSLog(@"result%@", task.result);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [HUD hideAnimated:YES];
                failure(task.error);
                NSLog(@"error%@", task.error);
            });
        }
        return putTask;
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

@end
