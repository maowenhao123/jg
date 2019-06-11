//
//  YZOrderSectionStatus.h
//  ez
//
//  Created by apple on 16/9/30.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZOrderSectionStatus : NSObject

@property (nonatomic, copy) NSString *title;//分组的标题
@property (nonatomic, strong) NSArray *array;//装一个section所有cell的数据模型

@end
