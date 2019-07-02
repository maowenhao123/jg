//
//  YZCircleCommentTableViewCell.h
//  ez
//
//  Created by dahe on 2019/6/28.
//  Copyright © 2019 9ge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YZCircleCommentModel.h"

NS_ASSUME_NONNULL_BEGIN
@class YZCircleCommentTableViewCell;

@protocol CircleCommentTableViewCellDelegate <NSObject>

- (void)replyButtonDidClickWithCell:(YZCircleCommentTableViewCell *)cell;
- (void)allCommentButtonDidClickWithCell:(YZCircleCommentTableViewCell *)cell;

@end

@interface YZCircleCommentTableViewCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<CircleCommentTableViewCellDelegate> delegate;

@property (nonatomic, strong) YZCircleCommentModel *commentModel;

@end

NS_ASSUME_NONNULL_END
