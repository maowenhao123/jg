//
//  UIButton+YZ.m
//  ez
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "UIButton+YZ.h"

@implementation UIButton (YZ)

- (void)setButtonTitleWithImageAlignment:(UIButtonTitleWithImageAlignment)buttonTitleWithImageAlignment imgTextDistance:(CGFloat)imgTextDistance
{
    //default Alignment is in order to facilitate the layout
    [self setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    
    CGFloat buttonWidth = self.frame.size.width;
    CGFloat buttonHeight = self.frame.size.height;
    CGFloat imgWidth = self.imageView.image.size.width;
    CGFloat imgHeight = self.imageView.image.size.height;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGFloat textWitdh = textSize.width;
    CGFloat textHeight = textSize.height;
    
    CGFloat interval;      // distance between the whole image title part and button
    CGFloat imgOffsetX;    // horizontal offset of image
    CGFloat imgOffsetY;    // vertical offset of image
    CGFloat titleOffsetX;  // horizontal offset of title
    CGFloat titleOffsetY;  // vertical offset of title
    
    if (buttonTitleWithImageAlignment == UIButtonTitleWithImageAlignmentUp) {
        interval = (buttonHeight - (imgHeight + imgTextDistance + textHeight)) / 2;
        imgOffsetX = (buttonWidth - imgWidth) / 2;
        imgOffsetY = interval;
        titleOffsetX = (buttonWidth - textWitdh) / 2 - imgWidth;
        titleOffsetY = interval + imgHeight + imgTextDistance;
    }else if (buttonTitleWithImageAlignment == UIButtonTitleWithImageAlignmentLeft) {
        interval = (buttonWidth - (imgWidth + imgTextDistance + textWitdh)) / 2;
        imgOffsetX = interval;
        imgOffsetY = (buttonHeight - imgHeight) / 2;
        titleOffsetX = buttonWidth - (imgWidth + textWitdh + interval);
        titleOffsetY = (buttonHeight - textHeight) / 2;
    }else if (buttonTitleWithImageAlignment == UIButtonTitleWithImageAlignmentDown) {
        interval = (buttonHeight - (imgHeight + imgTextDistance + textHeight)) / 2;
        imgOffsetX = (buttonWidth - imgWidth) / 2;
        imgOffsetY = interval + textHeight + imgTextDistance;
        titleOffsetX = (buttonWidth - textWitdh) / 2 - imgWidth;
        titleOffsetY = interval;
    }else {
        interval = (buttonWidth - (imgWidth + imgTextDistance + textWitdh)) / 2;
        imgOffsetX = interval + textWitdh + imgTextDistance;
        imgOffsetY = (buttonHeight - imgHeight) / 2;
        titleOffsetX = - (imgWidth - interval);
        titleOffsetY = (buttonHeight - textHeight) / 2;
    }
    [self setImageEdgeInsets:UIEdgeInsetsMake(imgOffsetY, imgOffsetX,0, 0)];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(titleOffsetY, titleOffsetX, 0, 0)];
}

@end
