//
//  YZBasketBallBetTableViewCell.h
//  ez
//
//  Created by 毛文豪 on 2018/5/30.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZMatchInfosStatus.h"

@interface YZBasketBallBetTableViewCell : UITableViewCell

+ (YZBasketBallBetTableViewCell *)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZMatchInfosStatus *matchInfosModel;//一个cell的数据模型

@end
