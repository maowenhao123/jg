//
//  YZCircleCommentListTableViewCell.h
//  ez
//
//  Created by dahe on 2019/7/1.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZCircleCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface YZCircleCommentListTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) YZTopicCommentReplyModel *commentModel;

@end

NS_ASSUME_NONNULL_END
