//
//  YZSelectedBetNumberView.h
//  ez
//
//  Created by 毛文豪 on 2017/12/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZSelectedBetNumberViewDelegate <NSObject>

- (void)selectedBetNumberViewSelectedNumber:(NSInteger)number;

@end

@interface YZSelectedBetNumberView : UIView

@property (nonatomic, weak) id<YZSelectedBetNumberViewDelegate> delegate;

@end
