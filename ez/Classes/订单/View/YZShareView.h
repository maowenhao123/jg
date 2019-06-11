//
//  YZShareView.h
//  ez
//
//  Created by apple on 16/11/18.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>

typedef void (^ShareChoicePlatformTypBlock)(UMSocialPlatformType platformType);

@interface YZShareView : UIView

@property (copy, nonatomic)ShareChoicePlatformTypBlock block;

- (void)show;

@end
