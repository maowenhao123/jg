//
//  YZVoucherGuideView.h
//  ez
//
//  Created by 毛文豪 on 2017/6/15.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZGuideModel.h"

@interface YZVoucherGuideView : UIView

- (instancetype)initWithFrame:(CGRect)frame guideModel:(YZGuideModel *)guideModel;

@property (nonatomic, strong) UINavigationController *owerViewController;

@end
