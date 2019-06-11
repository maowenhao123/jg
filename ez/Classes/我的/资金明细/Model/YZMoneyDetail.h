//
//  YZMoneyDetail.h
//  ez
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZMoneyDetail : NSObject

@property (nonatomic, copy) NSString *desc;//描述
@property (nonatomic, copy) NSString *createTime;//创建时间
@property (nonatomic, copy) NSString *money;//money
@property (nonatomic, copy) NSString *afterMoney;//余额
@property (nonatomic, copy) NSString *type;

@end
