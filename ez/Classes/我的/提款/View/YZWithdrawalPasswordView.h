//
//  YZWithdrawalPasswordView.h
//  ez
//
//  Created by 毛文豪 on 2018/5/22.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZWithdrawalPasswordViewDelegate <NSObject>

- (void)withDrawalWithPassWord:(NSString *)passWord type:(int)type;

@end

@interface YZWithdrawalPasswordView : UIView

@property (nonatomic, weak) id <YZWithdrawalPasswordViewDelegate> delegate;

@end
