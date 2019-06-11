//
//  YZGrade.h
//  ez
//
//  Created by apple on 14-11-25.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZGrade : NSObject
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *gLevel;
@property (nonatomic, strong) NSNumber *bonus;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *gCount;
@end
