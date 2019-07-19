//
//  UILabel+YZ.h
//  ez
//
//  Created by dahe on 2019/6/28.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextModel : NSObject

@property (nonatomic, copy) NSString *string;
@property (nonatomic, assign) NSRange range;

@end

@interface UILabel (YZ)

///是否显示点击效果，默认是打开
@property (nonatomic, assign) BOOL isShowTagEffect;

///TagArray  点击的字符串数组
- (void)onTapRangeActionWithString:(NSArray <NSString *> *)TagArray tapClicked:(void (^) (NSString *string , NSRange range , NSInteger index))tapClick;

@end

NS_ASSUME_NONNULL_END
