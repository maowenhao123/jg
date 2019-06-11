//
//  YZFBFilterTool.h
//  ez
//
//  Created by apple on 16/6/7.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZFBFilterTool : NSObject
/**
 * @param betArray 需要的筛选的原始数组
 * @return 筛选后的数组
 */
+(NSMutableArray *)FilterBetBy:(NSMutableArray *)betArray;

@end
