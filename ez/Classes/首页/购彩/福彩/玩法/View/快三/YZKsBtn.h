//
//  YZKsBtn.h
//  ez
//
//  Created by apple on 16/8/8.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZKsBtn : UIButton

//+ (YZKsBtn *)button;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)btnChangeSelected;
- (void)btnChangeNormal;
- (void)btnChangeState;

@end
