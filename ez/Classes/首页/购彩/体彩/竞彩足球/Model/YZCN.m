//
//  YZCN.m
//  ez
//
//  Created by apple on 14-11-20.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZCN.h"

@implementation YZCN

- (instancetype)init
{
    if(self = [super init])
    {
//        _btnStateArray = [[NSMutableArray alloc] initWithCapacity:3];
//        NSArray *arr = [NSArray arrayWithObjects:@(0),@(0),@(0), nil];
//        [_btnStateArray addObjectsFromArray:arr];//按钮选中状态默认位0，即不选中
    }
    return self;
}
////根据按钮状态获取选择的赔率
//- (NSMutableArray *)getSelectedOddsInfoArray
//{
//    NSArray *oddsInfoArr = [_oddsInfo componentsSeparatedByString:@"|"];
//    NSMutableArray *muArr = [NSMutableArray arrayWithObjects:@"",@"",@"", nil];
//    for(int i = 0;i < _btnStateArray.count;i++)
//    {
//        NSNumber *num = _btnStateArray[i];
//        if([num intValue])
//        {
//            [muArr replaceObjectAtIndex:i withObject:oddsInfoArr[i]];
//        }
//    }
//    return muArr;
//}
MJCodingImplementation

@end
