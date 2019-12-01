//
//  YZUnionChangeNickNameView.h
//  ez
//
//  Created by 毛文豪 on 2017/8/4.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZUnionChangeNickNameViewDelegate <NSObject>

@optional
- (void)confirmBtnDidClick:(NSString *)nickName;

@end

@interface YZUnionChangeNickNameView : UIView

@property (nonatomic, weak) id<YZUnionChangeNickNameViewDelegate> delegate;

@end
