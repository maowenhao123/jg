
//  YZSelectBallCellStatus.h
//  ez
//
//  Created by apple on 14-9-11.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZSelectBallCellStatus : NSObject

@property (nonatomic, copy) NSMutableAttributedString *title;//标题
@property (nonatomic, assign) BOOL isRed;//cell主要颜色格调
@property (nonatomic, assign) int ballsCount;//球的总数
@property (nonatomic, strong) NSMutableArray *selBalls;
@property (nonatomic, copy) NSMutableString *selballStr;
@property (nonatomic, strong) NSMutableArray *autoSelBallNums;//机选求号码数组
@property (nonatomic, assign) int RandomCount;//随机数
@property (nonatomic, assign) NSRange randomCountRange;//随机数的变化值
@property (nonatomic, copy) NSString *icon;//图片名
@property (nonatomic, copy) NSString *leftTitle;//左边标题
@property (nonatomic, copy) NSString *startNumber;//球号码以多少开始
@property (nonatomic, assign) BOOL ballReuse;//号码球是否重用
@property (nonatomic, assign) CGFloat cellH;//cell的高度

@end
