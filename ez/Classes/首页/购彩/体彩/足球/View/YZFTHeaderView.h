//
//  YZFTHeaderView.h
//  ez
//
//  Created by apple on 14-11-20.
//  Copyright (c) 2014年 9ge. All rights reserved.
//
#define headerViewH 44

#import <UIKit/UIKit.h>
#import "YZSectionStatus.h"

@class YZFTHeaderView;

@protocol YZFTHeaderViewDelegate <NSObject>

- (void)headerViewDidClickWithHeader:(YZFTHeaderView *)header;

@end

@interface YZFTHeaderView : UITableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)talbeView;

@property (nonatomic, weak) id<YZFTHeaderViewDelegate> delegate;
@property (nonatomic, strong) YZSectionStatus *sectionStatus;//每个section的数据模型
@property (nonatomic, weak) UIButton *btn;

@end
