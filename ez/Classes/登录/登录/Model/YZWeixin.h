//
//  YZWeixin.h
//  ez
//
//  Created by apple on 15/3/6.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZWeixin : NSObject

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, strong) NSNumber *expiresIn;
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *privilege;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *refreshToken;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, copy) NSString *unionId;
/**
 "accessToken": "OezXcEiiBSKSxW0eoylIeO9D43sWk1vX_JHwBXubuxqtE0f3JHsRV-s3SejbTdA4E5f68wNFy97clHNjIYYEzyItjxudpXfCw_3yhnTFnXgHQNbmxXmGV6Kb9n60vZlr_hltadfe4c3CLCrHOLx_3Q",
 "city": "Chaoyang",
 "expiresIn": 7200,
 "headUrl": "http://wx.qlogo.cn/mmopen/Q3auHgzwzM63DhtRjs3tcFCPXlVUWZJbXN8eGicnSFHpfhN8GAZbkV0ictCjvicSrw6YuUddLhOQRGgbzicQPvsP0Q/0",
 "nickName": "\u4e0a\u5b98\u71da\u6d1b\uf48e",
 "openId": "oWdhRt1-AkaHCB-6e3kOqIi8P97o",
 "privilege": "[]",
 "province": "Beijing",
 "refreshToken": "OezXcEiiBSKSxW0eoylIeO9D43sWk1vX_JHwBXubuxqtE0f3JHsRV-s3SejbTdA4cjaDcWTzm1-xQyXZpmlbvCl_9Ug4YMhinKkBFpE38-KkEUyjfSbGR3GwppcPTn18LaLtV0jqKUu-fAO0QSW2cQ",
 "sex": 1,
 "unionId": "oifcnuP_K1BHrf6dDHDyY9277dtA"
 */
@end
