//
//  YZSectionStatus.h
//  ez
//
//  Created by apple on 14-12-1.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZSectionStatus : NSObject

@property (nonatomic, assign,getter = isOpened) BOOL opened;//分组是否打开
@property (nonatomic, copy) NSString *title;//分组的标题
@property (nonatomic, strong) NSArray *matchInfosArray;//装一个section所有cell的数据模型

@end
