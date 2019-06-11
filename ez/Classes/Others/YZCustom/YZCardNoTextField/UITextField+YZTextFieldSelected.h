//
//  UITextField+YZTextFieldSelected.h
//  ez
//
//  Created by apple on 16/12/1.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (YZTextFieldSelected)

- (NSRange)selectedRange;
- (void)setSelectedRange:(NSRange) range;

@end
