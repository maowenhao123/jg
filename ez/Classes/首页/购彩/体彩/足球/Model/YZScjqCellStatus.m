//
//  YZScjqCellStatus.m
//  ez
//
//  Created by apple on 14-12-15.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZScjqCellStatus.h"

@implementation YZScjqCellStatus
- (instancetype)init
{
    if(self = [super init])
    {
        [self commonFunc];
    }
    return self;
}
- (void)deleteAllSelBtn
{
    [self commonFunc];
}
- (void)commonFunc
{
    NSMutableArray *btnStateArray1 = [NSMutableArray arrayWithObjects:@(0),@(0),@(0),@(0), nil];
    NSMutableArray *btnStateArray2 = [NSMutableArray arrayWithObjects:@(0),@(0),@(0),@(0), nil];
    _btnStateArray = [NSMutableArray arrayWithObjects:btnStateArray1,btnStateArray2, nil];
    
    //按钮选中个数
    NSNumber *btnSelectedCount1 = @(0);
    NSNumber *btnSelectedCount2 = @(0);
    _btnSelectedCountArr = [NSMutableArray arrayWithObjects:btnSelectedCount1,btnSelectedCount2, nil];

}
@end
