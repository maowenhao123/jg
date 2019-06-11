//
//  YZMatchInfosStatus.h
//  ez
//
//  Created by apple on 14-11-20.
//  Copyright (c) 2014年 9ge. All rights reserved.
//一个cell的数据

#import <Foundation/Foundation.h>
#import "YZOddsMap.h"

@interface YZMatchInfosStatus : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) NSNumber *concedePoints;
@property (nonatomic, copy) NSString *detailInfo;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *matchTime;
@property (nonatomic, strong) YZOddsMap *oddsMap;
@property (nonatomic, copy) NSString *openTime;
@property (nonatomic, strong) NSNumber *status;

//自定义,非返回数据
@property (nonatomic, copy) NSString *matchName;//cell的比赛名称，请求返回数据没有，
@property (nonatomic, assign) int playTypeTag;//玩法tag，titlebtn的展示菜单按钮的tag
@property (nonatomic, strong) NSMutableArray *selMatchArr;//选中的玩法 有空数组
@property (nonatomic, assign,getter=isOpen) BOOL open;//是否是展开的
//清空数据
- (void)deleteAllSelBtn;
//是否有被选中的比赛
- (BOOL)isHaveSelected;
//是否有被选中的比赛(除了胜平负)
- (BOOL)isHaveSelected1;
//是否所有的玩法都不支持单关
- (BOOL)isCloseAllSingle;
//被选中比赛的场数
- (int)numberSelMatch;

//篮球
@property (nonatomic, strong) NSMutableArray *titleLabelStrs;
@property (nonatomic, strong) NSMutableArray *conetntLabelStrs;
@property (nonatomic, strong) NSMutableArray *titleLabelFs;
@property (nonatomic, strong) NSMutableArray *conetntLabelFs;
@property (nonatomic, assign) CGFloat cellH;

@end
