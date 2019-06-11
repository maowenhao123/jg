//
//  YZFBTimeChooseView.h
//  ez
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZFBTimeChooseView;
typedef void (^FBTimeChooseBlock)(NSString * dateStr);

@interface YZFBTimeChooseView : UIView

- (instancetype)initWithDateStr:(NSString *)dateStr;

@property (copy, nonatomic)FBTimeChooseBlock block;

- (void)show;

@end
