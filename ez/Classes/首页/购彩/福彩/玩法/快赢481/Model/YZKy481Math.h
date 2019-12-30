//
//  YZKy481Math.h
//  ez
//
//  Created by dahe on 2019/11/14.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZKy481Math : NSObject

+ (int)getBetCountWithSelStatusArray:(NSArray *)selStatusArray selectedPlayTypeBtnTag:(NSInteger)selectedPlayTypeBtnTag;
/**
 快赢 获取投注的最大最小奖金
 */
+ (NSRange)getKy481Prize_putongWithTag:(int)tag selectCount:(int)selectCount betCount:(int)betCount;

@end

NS_ASSUME_NONNULL_END
