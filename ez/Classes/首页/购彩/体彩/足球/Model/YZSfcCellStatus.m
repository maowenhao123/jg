//
//  YZSfcCellStatus.m
//  ez
//
//  Created by apple on 14-12-12.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZSfcCellStatus.h"

@implementation YZSfcCellStatus
- (instancetype)init
{
    if(self = [super init])
    {
        _btnStateArray = [[NSMutableArray alloc] initWithCapacity:3];
        NSArray *arr = [NSArray arrayWithObjects:@(0),@(0),@(0), nil];;
        [_btnStateArray addObjectsFromArray:arr];//按钮选中状态默认位0，即不选中
    }
    return self;
}
- (void)deleteAllSelBtn
{
    _btnSelectedCount = 0;
    _btnStateArray = [NSMutableArray arrayWithObjects:@(0),@(0),@(0), nil];
}
@end
