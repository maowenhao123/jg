//
//  YZFbBetViewController.h
//  ez
//
//  Created by apple on 14-12-2.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"

@interface YZFbBetViewController : YZBaseViewController

- (instancetype)initWithGameId:(NSString *)gameId
                   statusArray:(NSMutableArray *)statusArray
              selectedPlayType:(int)selectedPlayType;

@end
