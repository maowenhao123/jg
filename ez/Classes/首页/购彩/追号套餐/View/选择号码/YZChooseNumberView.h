//
//  YZChooseNumberView.h
//  ez
//
//  Created by 毛文豪 on 2018/7/12.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZChooseNumberView : UIView

- (instancetype)initWithFrame:(CGRect)frame chooseNumberType:(ChooseNumberType)chooseNumberType;

@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, weak) UIImageView *bgImageView;
@property (nonatomic, strong) NSArray * numberBallStatus;

@end
