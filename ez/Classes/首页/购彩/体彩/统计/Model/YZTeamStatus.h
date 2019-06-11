//
//  YZTeamStatus.h
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZTeamStatus : NSObject

@property (nonatomic, copy) NSString *name;//队名
@property (nonatomic, copy) NSString *logo;//图标
@property (nonatomic, assign) int total;//总排名
@property (nonatomic, assign) int rank;//排名

@end
