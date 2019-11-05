//
//  YZFootBallBaseViewController.h
//  ez
//
//  Created by apple on 14-11-19.
//  Copyright (c) 2014年 9ge. All rights reserved.
//


#import "YZGameIdViewController.h"

@interface YZFootBallBaseViewController : YZGameIdViewController

@property (nonatomic, weak) UILabel *bottomMidLabel;//显示选择多少场比赛
@property (nonatomic, strong) NSArray *matchInfosStatusArray;//比赛信息模型数组
@property (nonatomic, weak) UIView *bottomView;//底部背景view
@property (nonatomic, weak) UITableView *tableView;
- (void)openMenuView;
- (void)getCurrentMatchInfo;//获取当前比赛信息
- (void)confirmBtnClick;
- (void)getCurrentMatchInfoFailed;

@end
