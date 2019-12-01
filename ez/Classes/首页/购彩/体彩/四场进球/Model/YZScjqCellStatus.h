//
//  YZScjqCellStatus.h
//  ez
//
//  Created by apple on 14-12-15.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZScjqCellStatus : NSObject
@property (nonatomic, assign) int number;//比赛次序
@property (nonatomic, copy) NSString *matchName;//比赛名称
@property (nonatomic, copy) NSString *endTime;//截止时间
@property (nonatomic, copy) NSString *vsText;//比赛双方名称

@property (nonatomic, strong) NSMutableArray *btnStateArray;//返回数据中没有，自定义，一排三个按钮的状态数组
@property (nonatomic, strong) NSMutableArray *btnSelectedCountArr;//钮被选中个数数组
@property (nonatomic, copy) NSString *code;
- (void)deleteAllSelBtn;
@end
