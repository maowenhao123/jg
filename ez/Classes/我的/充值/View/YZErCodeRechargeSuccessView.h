//
//  YZErCodeRechargeSuccessView.h
//  ez
//
//  Created by dahe on 2019/11/11.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YZErCodeRechargeSuccessView : UIView

- (instancetype)initWithFrame:(CGRect)frame clientId:(NSString *)clientId;

@property (nonatomic, strong) UIViewController * ower;

@end

NS_ASSUME_NONNULL_END
