//
//  YZKsPlayTypeView.h
//  ez
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KsPlayTypeViewDelegate <NSObject>

- (void)KsPlayTypeViewButttonClick:(UIButton *)button;

@end

@interface YZKsPlayTypeView : UIView

@property (nonatomic, weak) id<KsPlayTypeViewDelegate> delegate;

@end
