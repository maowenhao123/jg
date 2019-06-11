//
//  YZSetmealChooseNumberViewController.h
//  ez
//
//  Created by 毛文豪 on 2018/7/12.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"

@protocol YZSetmealChooseNumberViewControllerDelegate <NSObject>

- (void)getNumberBallStatus:(NSArray *)numberBallStatus;

@end

@interface YZSetmealChooseNumberViewController : YZBaseViewController

@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, assign) ChooseNumberType chooseNumberType;
@property (nonatomic, weak) id <YZSetmealChooseNumberViewControllerDelegate> delegate;

@end
