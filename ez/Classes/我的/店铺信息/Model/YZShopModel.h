//
//  YZShopModel.h
//  zc
//
//  Created by dahe on 2020/4/14.
//  Copyright © 2020 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZShopPayModel : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *imgUrl;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger type;

@end

@interface YZShopModel : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *notice;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *weixin;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSArray *payList;
@property (nonatomic, assign) BOOL spread;//是否有分享赚钱；1：有；0：没有

@end

NS_ASSUME_NONNULL_END
