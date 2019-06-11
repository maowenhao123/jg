//
//  YZOddsMap.h
//  ez
//
//  Created by apple on 14-11-20.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZCN.h"
@interface YZOddsMap : NSObject

@property (nonatomic, strong) YZCN *CN01;//让球
@property (nonatomic, strong) YZCN *CN02;//非让
@property (nonatomic, strong) YZCN *CN03;//比分
@property (nonatomic, strong) YZCN *CN04;//总进球
@property (nonatomic, strong) YZCN *CN05;//胜负半场
@property (nonatomic, strong) YZCN *CN13;

@end
