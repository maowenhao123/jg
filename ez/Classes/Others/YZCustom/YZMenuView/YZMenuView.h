//
//  YZMenuView.h
//  ez
//
//  Created by 毛文豪 on 2018/12/11.
//  Copyright © 2018 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewDelegate <NSObject>

- (void)menuViewButtonDidClick:(UIButton *)button;

@end

@interface YZMenuView : UIView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray;

@property (nonatomic, assign) id <MenuViewDelegate> delegate;

- (void)show;

@end
