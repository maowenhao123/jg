//
//  YZCircleUserInfoModel.h
//  ez
//
//  Created by dahe on 2019/7/2.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZCircleUserInfoModel : NSObject

@property (nonatomic, strong) NSNumber * concernCount;//关注数
@property (nonatomic, assign) BOOL concernable;
@property (nonatomic, strong) NSNumber * fansCount;
@property (nonatomic, copy) NSString *headPortraitUrl;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *statusDesc;

@end

NS_ASSUME_NONNULL_END
