//
//  YZKsDiceView.h
//  ez
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZKsDiceView : UIImageView
/*
 number 骰子的号码
 count 第几个骰子
 */
- (void)setNumber:(int)number count:(int)count;
/*
 筛子的位置随机变动
 */
- (void)diceRandomPostionAnimationWithCount:(int)count index:(int)index;
@end
