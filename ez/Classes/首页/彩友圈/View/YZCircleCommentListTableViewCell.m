//
//  YZCircleCommentListTableViewCell.m
//  ez
//
//  Created by dahe on 2019/7/1.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZCircleCommentListTableViewCell.h"
#import "YZUserCircleViewController.h"
#import "UILabel+YZ.h"

@interface YZCircleCommentListTableViewCell ()

@property (nonatomic, weak) UILabel * commentLabel;

@end

@implementation YZCircleCommentListTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CircleCommentListTableViewCellId";
    YZCircleCommentListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZCircleCommentListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChildViews];
    }
    return self;
}

- (void)setupChildViews
{
    //内容
    UILabel * commentLabel = [[UILabel alloc] init];
    self.commentLabel = commentLabel;
    commentLabel.numberOfLines = 0;
    [self addSubview:commentLabel];
}

- (void)setCommentModel:(YZTopicCommentReplyModel *)commentModel
{
    _commentModel = commentModel;
    
    self.commentLabel.attributedText = _commentModel.commentAttStr;
    self.commentLabel.frame = _commentModel.commentLabelF;
//    
//    typeof(self) __weak weakSelf = self;
//    [self.commentLabel onTapRangeActionWithString:@[_commentModel.userName] tapClicked:^(NSString *string, NSRange range, NSInteger index) {
//        YZUserCircleViewController * userCircleVC = [[YZUserCircleViewController alloc] init];
//        userCircleVC.userId = weakSelf.commentModel.userId;
//        [weakSelf.viewController.navigationController pushViewController:userCircleVC animated:YES];
//    }];
}

@end
