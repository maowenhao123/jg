//
//  YZSetmealShowNumberViewController.h
//  ez
//
//  Created by 毛文豪 on 2018/7/12.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZBaseViewController.h"

@protocol YZSetmealShowNumberViewControllerDelegate <NSObject>

- (void)getNumberBallStatus:(NSArray *)numberBallStatus numberArray:(NSArray *)numberArray;

@end

@interface YZSetmealShowNumberViewController : YZBaseViewController

@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, strong) NSArray *numberArray;
@property (nonatomic, weak) id <YZSetmealShowNumberViewControllerDelegate> delegate;

@end
