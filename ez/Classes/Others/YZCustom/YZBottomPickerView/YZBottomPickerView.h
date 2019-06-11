//
//  YZBottomPickerView.h
//  ez
//
//  Created by apple on 16/12/5.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZBottomPickerView;
typedef void (^ChoicePickerViewBlock)(NSInteger selectedIndex);

@interface YZBottomPickerView : UIView
/**
 *  创建一个底部的pickview
 *
 *  @param dataArray  数据源
 *  @param index      当前选中的index
 */
- (instancetype)initWithArray:(NSArray *)dataArray index:(NSInteger)index;

@property (copy, nonatomic)ChoicePickerViewBlock block;

- (void)show;

@end
