//
//  YZBasketBallTableViewCell2.h
//  ez
//
//  Created by 毛文豪 on 2018/5/28.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZMatchInfosStatus.h"

@protocol YZBasketBallTableViewCell2Delegate <NSObject>

@optional
- (void)reloadBottomMidLabelText;

@end

@interface YZBasketBallTableViewCell2 : UITableViewCell

+ (YZBasketBallTableViewCell2 *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZMatchInfosStatus *matchInfosModel;//一个cell的数据模型

@property (nonatomic, weak) id<YZBasketBallTableViewCell2Delegate> delegate;

@end
