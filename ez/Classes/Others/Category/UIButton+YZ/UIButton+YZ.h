//
//  UIButton+YZ.h
//  ez
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIButtonTitleWithImageAlignmentUp = 0,  // image is up, title is down
    UIButtonTitleWithImageAlignmentLeft,    // image is left, title is right
    UIButtonTitleWithImageAlignmentDown,    // image is down, title is up
    UIButtonTitleWithImageAlignmentRight    // image is right, title is left
} UIButtonTitleWithImageAlignment;


@interface UIButton (YZ)

- (void)setButtonTitleWithImageAlignment:(UIButtonTitleWithImageAlignment)buttonTitleWithImageAlignment imgTextDistance:(CGFloat)imgTextDistance;


@end
