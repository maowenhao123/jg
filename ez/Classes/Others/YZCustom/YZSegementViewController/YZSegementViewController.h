//
//  YZSegementViewController.h
//  ez
//
//  Created by apple on 16/9/29.
//  Copyright © 2016年 9ge. All rights reserved.
//
#define topBtnH 42

#import "YZBaseViewController.h"

@interface YZSegementViewController : YZBaseViewController

@property (nonatomic, assign) int canEdit;
@property (nonatomic, strong) NSArray *btnTitles;//顶部按钮标题数组
@property (nonatomic, strong) NSMutableArray *views;//要显示的view数组
@property (nonatomic,assign) NSInteger maxViewCount;//最多显示的按钮数
@property (nonatomic, assign) int currentIndex;//显示第几个view
@property (nonatomic, weak) UIScrollView *scrollView;//滑动的scrollview
@property (nonatomic, strong) NSMutableArray *topBtns;//顶部按钮数组

- (void)configurationComplete;//配置好btnTitles views currentIndex后调用，开始布局视图
- (void)topBtnClick:(UIButton *)btn;//第几个按钮点击
- (void)changeCurrentIndex:(int)currentIndex;//当前页面切换，子类实现
- (void)sortDone;

@end
