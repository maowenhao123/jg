//
//  YZFBMatchDetailOddsStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZRoundStatus.h"
#import "YZEuropeOddsCellStatus.h"
#import "YZAsiaOddsCellStatus.h"
#import "YZOverUnderCellStatus.h"

@interface YZFBMatchDetailOddsStatus : NSObject

@property (nonatomic, strong) YZRoundStatus *round;//交战双方信息
@property (nonatomic, assign) BOOL getData;//是否请求过数据
@property (nonatomic, strong) NSArray <YZEuropeOddsCellStatus *>*europeOddsCells;//欧赔
@property (nonatomic, strong) NSArray <YZAsiaOddsCellStatus *>*asiaOddsCells;//亚盘
@property (nonatomic, strong) NSArray <YZOverUnderCellStatus *>*overUnderCells;//上下盘

@end
