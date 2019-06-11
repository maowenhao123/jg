//
//  YZChartSettingView.h
//  ez
//
//  Created by apple on 17/3/9.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZChartSettingViewDelegate <NSObject>

- (void)settingGotoHelpVC;
- (void)settingConfirm;

@end

@interface YZChartSettingView : UIView

- (instancetype)initWithTitleArray:(NSArray *)titleArray;

@property (nonatomic, weak) id<YZChartSettingViewDelegate> delegate;
@property (nonatomic, strong) id owner;//该view是属于哪个VC的

@end
