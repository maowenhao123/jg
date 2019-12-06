//
//  YZBaseChartViewController.h
//  ez
//
//  Created by dahe on 2019/12/6.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZBaseViewController.h"
#import "YZChartStatus.h"
#import "YZChartPlayTypeView.h"

NS_ASSUME_NONNULL_BEGIN

#define bottomViewH 44

@interface YZBaseChartViewController : YZBaseViewController

@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, assign) NSInteger selectedPlayTypeBtnTag;

@property (nonatomic, strong) YZChartStatus * chartStatus;//数据
@property (nonatomic, strong) NSArray * dataArray;//遗漏集合

@property (nonatomic, weak) YZTitleButton *titleBtn;

- (void)setupChilds;
- (void)setSettingData;
- (void)playTypeDidClickBtn:(UIButton *)btn;

@end

NS_ASSUME_NONNULL_END
