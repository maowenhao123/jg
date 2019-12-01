//
//  YZFbBetCellStatus.h
//  ez
//
//  Created by apple on 14-12-4.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
typedef enum : NSUInteger {
    danBtnStateDisabled,
    danBtnStateNormal,
    danBtnStateSelected,
} danBtnState;

#define btnsBgViewYY 52 //固定，无适配问题
#define btnsViewW (screenWidth- 74)   //自动适配屏幕分辨率,宽320，则是246
#import <Foundation/Foundation.h>
#import "YZMatchInfosStatus.h"
@interface YZFbBetCellStatus : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSMutableAttributedString *vs1MuAttText;
@property (nonatomic, copy) NSString *vs2Text;

@property (nonatomic, assign) NSInteger lineNum;//一共有几行数据
@property (nonatomic, assign) NSInteger feirangNum;//非让球的行数
@property (nonatomic, assign) NSInteger rangNum;//让球的行数
@property (nonatomic, assign) NSInteger erxuanyiNum;//二选一的行数
@property (nonatomic, assign) NSInteger banquanchangNum;//半全场的行数
@property (nonatomic, assign) NSInteger bifenNum;//比分的行数
@property (nonatomic, assign) NSInteger zongjinqiuNum;//总进球的行数

//@property (nonatomic, strong) NSMutableArray *selectedOddsInfoArray;//每场比赛选择了的赔率


@property (nonatomic, assign) CGFloat btnsBgViewH;
@property (nonatomic, assign) CGFloat cellH;

@property (nonatomic, assign) int playType;
@property (nonatomic, assign) int btnSelectedCount;//表示该cell有赔率按钮被选中,多少个按钮选中
@property (nonatomic, strong) YZMatchInfosStatus *matchInfosStatus;
@property (nonatomic, assign) danBtnState danBtnState;//胆按钮的状态
@end
