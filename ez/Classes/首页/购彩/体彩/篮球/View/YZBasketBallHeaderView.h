//
//  YZBasketBallHeaderView.h
//  ez
//
//  Created by 毛文豪 on 2018/5/22.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZSectionStatus.h"

@class YZBasketBallHeaderView;

@protocol YZBasketBallHeaderViewDelegate <NSObject>

- (void)headerViewDidClickWithHeader:(YZBasketBallHeaderView *)header;

@end

@interface YZBasketBallHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)talbeView;

@property (nonatomic, weak) id<YZBasketBallHeaderViewDelegate> delegate;

@property (nonatomic, weak) UIButton *btn;

@property (nonatomic, strong) YZSectionStatus *sectionModel;

@end
