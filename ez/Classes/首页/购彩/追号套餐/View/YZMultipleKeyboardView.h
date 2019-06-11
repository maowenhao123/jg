//
//  YZMultipleKeyboardView.h
//  ez
//
//  Created by 毛文豪 on 2018/7/11.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZMultipleKeyboardViewCellDelegate <NSObject>

- (void)multipleKeyboardViewDidChangeMultiple:(NSString *)multiple;

@end

@interface YZMultipleKeyboardView : UIView

- (instancetype)initWithMultiple:(NSString *)multiple;

@property (nonatomic, weak) id <YZMultipleKeyboardViewCellDelegate> delegate;

- (void)show;

@end
