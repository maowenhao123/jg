//
//  YZUnionBuyComfirmPayTool.h
//  ez
//
//  Created by 毛文豪 on 2017/7/27.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZStartUnionbuyModel.h"

@interface YZUnionBuyComfirmPayTool : NSObject
//单例
+ (YZUnionBuyComfirmPayTool *)shareInstance;

#pragma mark - 发起合买
- (void)startUnionBuyOfAllWithParam:(YZStartUnionbuyModel *)param sourceController:(UIViewController *)sourceController;

#pragma mark - 参与合买
- (void)participateUnionBuyOfAllWithParam:(YZStartUnionbuyModel *)param sourceController:(UIViewController *)sourceController;


@end
