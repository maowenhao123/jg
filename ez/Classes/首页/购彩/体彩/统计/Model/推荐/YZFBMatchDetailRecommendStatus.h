//
//  YZFBMatchDetailRecommendStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZRecommendRowStatus.h"
#import "YZRoundStatus.h"

@interface YZFBMatchDetailRecommendStatus : NSObject

@property (nonatomic, strong) YZRoundStatus *round;//交战双方信息
@property (nonatomic, strong) YZRecommendRowStatus *recommendRow;//推荐

@end
