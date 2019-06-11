//
//  YZBasketBallBetHeaderView.h
//  ez
//
//  Created by 毛文豪 on 2018/5/30.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZMatchInfosStatus.h"

@class YZBasketBallBetHeaderView;

@protocol YZBasketBallBetHeaderViewDelegate <NSObject>

- (void)headerViewDidClickWithHeader:(YZBasketBallBetHeaderView *)header;

@end

@interface YZBasketBallBetHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)talbeView;

@property (nonatomic, weak) id<YZBasketBallBetHeaderViewDelegate> delegate;

@property (nonatomic, strong) YZMatchInfosStatus *matchInfosModel;

@end
