//
//  UIImage+YZ.h
//  ez
//
//  Created by apple on 14-8-12.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YZ)

/**
 *  加载图片
 *
 *  @param name 图片名
 */
+ (UIImage *)imageWithName:(NSString *)name;

/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

+ (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top;
/**
 *  返回一张给定颜色和大小的图片
 */
+ (UIImage *)ImageFromColor:(UIColor *)color WithRect:(CGRect)rect;
/**
 *  返回一张给定颜色的图片
 */
+ (UIImage*)ImageFromColor:(UIColor *)color;

@end
