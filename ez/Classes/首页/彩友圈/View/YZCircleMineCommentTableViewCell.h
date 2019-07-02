//
//  YZCircleMineCommentTableViewCell.h
//  ez
//
//  Created by dahe on 2019/6/28.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZCircleMineCommentModel.h"

@interface YZCircleMineCommentTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZCircleMineCommentModel *commentModel;

@end

