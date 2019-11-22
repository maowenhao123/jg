//
//  YZSelectBaseViewController.h
//  ez
//
//  Created by apple on 14-9-9.
//  Copyright (c) 2014年 9ge. All rights reserved.
//

#import "YZGameIdViewController.h"
#import "YZSelectBallCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import "YZBetViewController.h"
#import "YZRecentLotteryStatus.h"
#import "YZMathTool.h"
#import "YZBetTool.h"

#define endTimeLabelH 30

@interface YZSelectBaseViewController : YZGameIdViewController

@property (nonatomic, weak) UIButton *leftBtn;
@property (nonatomic, weak) UIButton *rightBtn;
@property (nonatomic, weak) UIView *topBtnLine;//顶部按钮的下划线
@property (nonatomic, strong) NSMutableArray *tableViews;
@property (nonatomic, weak) UITableView *tableView1;
@property (nonatomic, weak) UITableView *tableView2;
@property (nonatomic, weak) UITableView *currentTableView;//当前选中的tableview
@property (nonatomic, weak) UIButton *selectedBtn;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIView *backView;//存放俩个按钮
@property (nonatomic, strong) NSMutableArray *topBtns;//存放俩个按钮的数组
@property (nonatomic, assign) int pageInt;
@property (nonatomic, weak) UILabel *amountLabel;
@property (nonatomic, assign) int betCount;//注数
@property (nonatomic, weak) UILabel *endTimeLabel;//截止时间label
@property (nonatomic, strong) NSTimer *getCurrentTermDataTimer;
@property (nonatomic, weak) UILabel * autoSelectedLabel;
@property (nonatomic, weak) UIView *bottomView;//底部view
@property (nonatomic, strong) NSArray *recentStatus;//近期开奖数据
@property (nonatomic, assign) NSInteger selectedPlayTypeBtnTag;
@property (nonatomic, assign) int selectcount;

- (NSMutableArray *)sortBallsArray:(NSMutableArray *)mutableArray;//排序数组
- (void)changeBtnState:(UIButton *)btn;
- (void)topBtnClick:(UIButton *)btn;
- (void)removeSetDeadlineTimer;
- (void)setDeleteAutoSelectedBtnTitle;

@end
