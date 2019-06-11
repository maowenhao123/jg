//
//  YZAdjustNumberView.h
//  ez
//
//  Created by 毛文豪 on 2018/5/29.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZAdjustNumberView;

@protocol YZAdjustNumberViewDelegate <NSObject>

@optional
- (void)adjustNumbeView:(YZAdjustNumberView *)numberView currentNumber:(NSString *)number;
- (void)decreaseNumberAdjustNumbeView:(YZAdjustNumberView *)numberView currentNumber:(NSString *)number;
- (void)increaseNumberAdjustNumbeView:(YZAdjustNumberView *)numberView currentNumber:(NSString *)number;

@end

@interface YZAdjustNumberView : UIView


/**
 *  边框颜色，默认值是浅灰色
 */
@property (nonatomic, assign) UIColor *lineColor;

/**
 *  文本框内容
 */
@property (nonatomic, copy) NSString *currentNum;

/**
 *  输入框
 */
@property (nonatomic, weak) UITextField *textField;
/**
 *  最大值
 */
@property (nonatomic, assign) NSInteger max;
/**
 *  最小值
 */
@property (nonatomic, assign) NSInteger min;

/**
 协议
 */
@property (nonatomic, weak) id <YZAdjustNumberViewDelegate> delegate;

@end
