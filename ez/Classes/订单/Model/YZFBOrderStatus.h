//
//  YZFBOrderStatus.h
//  ez
//
//  Created by apple on 16/10/11.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZFBOrderStatus : NSObject

@property (nonatomic, assign) CGFloat bBCellH;
@property (nonatomic, copy) NSMutableAttributedString *bBTeamMessageAttStr;
@property (nonatomic, copy) NSString *score;
@property (nonatomic, copy) NSMutableAttributedString *bBBetAttStr;

@property (nonatomic, assign) CGFloat cellH;//cell高度
@property (nonatomic, copy) NSMutableAttributedString *teamMessage;//球队
@property (nonatomic, strong) NSMutableArray *resultsArray;//赛果的数组
@property (nonatomic, strong) NSMutableArray *betArray;//我的投注的数组
@property (nonatomic, assign) BOOL haveLottery;//是否开奖

@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, copy) NSString *codes;
@property (nonatomic, strong) NSDictionary *termValue;


@end
