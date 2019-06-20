//
//  YZTextView.h
//  ez
//
//  Created by dahe on 2019/6/20.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZTextView : UITextView

@property(nonatomic,copy) NSString *myPlaceholder;  //文字
@property(nonatomic,strong) UIColor *myPlaceholderColor; //文字颜色

@property (nonatomic, assign) NSInteger maxLimitNums;//最大字数
@property (nonatomic, weak) UIColor *maxLimitNumColor;

@end

NS_ASSUME_NONNULL_END
