//
//  YZGiveVoucherModel.h
//  ez
//
//  Created by 孔琪琪 on 2018/3/29.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponRedPackagePromotion : NSObject

@property (nonatomic, copy) NSString *imgPath;
@property (nonatomic, copy) NSString *promotionId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *remark;

@end

@interface CouponRedPackage : NSObject

@property (nonatomic, copy) NSString *redpackageId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *templatePrice;
@property (nonatomic, copy) NSString *status;//WAIT:待领取    RECEIVE:已领取    EXPIRED:已过期

@end

@interface YZGiveVoucherModel : NSObject

@property (nonatomic, strong) CouponRedPackagePromotion * couponRedPackagePromotion;
@property (nonatomic, strong) NSArray * couponRedpackageList;

@end
