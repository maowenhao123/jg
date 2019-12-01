//
//  YZKsBaseView.h
//  ez
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZKsBtn.h"
#import "YZKsBottomBtn.h"

@interface YZKsBaseView : UIScrollView

@property (nonatomic, weak) UIImageView * bgImageView;

/*
 选择对应的按钮
 */
- (void)setContentSizeByMaxY:(CGFloat)maxY;
/*
 选择对应的按钮
 */
- (void)chooseNumberByTags:(NSMutableArray *)tags;
/*
 删除已选的按钮
 */
- (void)deleteAllSelectedNumbersState;

@end
