//
//  YZChartSortButton.h
//  ez
//
//  Created by apple on 2017/3/20.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKIt/UIKIt.h>

typedef enum {
    SortModeNormal = 0,  //不排序
    SortModeAscending,   //升序
    SortModeDescending,  //降序
} SortMode;

@interface YZChartSortButton : UIButton

@property (nonatomic, copy) NSString *text;//标题

@property (nonatomic, assign) SortMode sortMode;//排序的状态

@property (nonatomic, assign) BOOL hiddenLine;//隐藏分割线

@end
