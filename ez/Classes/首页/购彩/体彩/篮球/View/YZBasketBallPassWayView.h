//
//  YZBasketBallPassWayView.h
//  ez
//
//  Created by 毛文豪 on 2018/5/29.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZPlayPassWay.h"

@interface YZBasketBallPassWayView : UIView

- (instancetype)initWithFrame:(CGRect)frame statusArray:(NSMutableArray *)statusArray;

@property (nonatomic, strong) NSMutableArray *selFreeWayButtons;
@property (nonatomic, strong) NSMutableArray *selMoreWayButtons;

@end
