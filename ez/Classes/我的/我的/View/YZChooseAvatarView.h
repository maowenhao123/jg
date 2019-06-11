//
//  YZChooseAvatarView.h
//  ez
//
//  Created by apple on 16/10/11.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZChooseAvatarView;
typedef void (^ChooseAvatarViewBlock)(NSInteger index);

@interface YZChooseAvatarView : UIView

@property (copy, nonatomic)ChooseAvatarViewBlock block;
- (void)show;

@end
