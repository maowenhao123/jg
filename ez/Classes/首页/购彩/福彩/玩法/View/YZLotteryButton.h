//
//  YZLotteryButton.h
//  ez
//
//  Created by apple on 14-8-13.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZLotteryButton : UIButton
@property (nonatomic, assign) int number;
@property (nonatomic, strong) NSMutableArray *ballsArray;//号球数组
@property (nonatomic, assign) NSRange range;//选球的总数
@property (nonatomic, strong) id owner;//该button是属于哪个cell的
@end
