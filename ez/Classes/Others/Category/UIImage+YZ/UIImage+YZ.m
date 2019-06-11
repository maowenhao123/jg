//
//  UIImage+YZ.m
//  ez
//
//  Created by apple on 14-8-12.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "UIImage+YZ.h"

@implementation UIImage (YZ)

+ (UIImage *)imageWithName:(NSString *)name
{
    NSString *newName = [name stringByAppendingString:@"_os7"];
    UIImage *image = [UIImage imageNamed:newName];
    if (image == nil) { // 没有_os7后缀的图片
        image = [UIImage imageNamed:name];
    }
    return image;
}

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [self imageWithName:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}
+ (UIImage *)ImageFromColor:(UIColor *)color WithRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage*)ImageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
}


@end
