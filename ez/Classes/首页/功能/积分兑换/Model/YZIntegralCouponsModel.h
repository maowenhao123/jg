//
//  YZIntegralCouponsModel.h
//  ez
//
//  Created by 毛文豪 on 2018/2/6.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZIntegralCouponsModel : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *points;
@property (nonatomic,copy) NSString *desc;

@property (nonatomic,assign) BOOL selected;

@end
