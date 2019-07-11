//
//  YZMineHeaderView.h
//  ez
//
//  Created by 毛文豪 on 2018/11/28.
//  Copyright © 2018 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YZMineHeaderViewDelegate <NSObject>

@optional
- (void)mineHeaderViewDidClick;//点击头像imageview的代理方法
- (void)mineDetailTableViewCellDidClickAvatar;//点击头像imageview的代理方法
- (void)mineRechargeTableViewCellDidClickBtn:(UIButton *)button;//点击提现和充值的代理方法

@end

@interface YZMineHeaderView : UIView

@property (nonatomic, weak) UIImageView *avatar;
@property (nonatomic, weak) id<YZMineHeaderViewDelegate> delegate;
@property (nonatomic, strong) YZUser *user;

@end

