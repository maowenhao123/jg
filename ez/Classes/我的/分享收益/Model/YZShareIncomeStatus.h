//
//  YZShareIncomeStatus.h
//  ez
//
//  Created by 毛文豪 on 2017/5/23.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZShareIncomeStatus : NSObject

@property (nonatomic,copy) NSString *mobile;//手机号码
@property (nonatomic,strong) NSNumber *money;//收益
@property (nonatomic,copy) NSString *regTime;//注册时间

@end
