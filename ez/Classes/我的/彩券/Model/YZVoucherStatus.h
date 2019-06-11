//
//  YZVoucherStatus.h
//  ez
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZVoucherStatus : NSObject

@property (nonatomic, copy) NSString *couponId;//id
@property (nonatomic, strong) NSNumber *money;//面值
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) long createDate;//创建时间
@property (nonatomic, assign) long startDate;//有效期开始时间
@property (nonatomic, assign) long endDate;//有效期截止时间
@property (nonatomic, assign) long effectDate;//生效时间(激活时间)
@property (nonatomic, strong) NSNumber *status;//状态 2:未激活;4:可使用;8:已用 完;16:已失效
@property (nonatomic, strong) NSNumber *balance;//余额
@property (nonatomic, copy) NSString *remark;//备注(代金券使用规则)

@end
