//
//  YZThirdPartyStatus.h
//  ez
//
//  Created by apple on 16/12/17.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>

@interface YZThirdPartyStatus : NSObject

@property (nonatomic, copy) NSString  *name;
@property (nonatomic, copy) NSString  *iconurl;
@property (nonatomic, copy) NSString  *gender;

@property (nonatomic, copy) NSString  *uid;
@property (nonatomic, copy) NSString  *openid;
@property (nonatomic, copy) NSString  *refreshToken;
@property (nonatomic, copy) NSDate    *expiration;
@property (nonatomic, copy) NSString  *accessToken;

@property (nonatomic, assign) UMSocialPlatformType  platformType;
/**
 * 第三方原始数据
 */
@property (nonatomic, strong) id originalResponse;

@end
