//
//  YZCircleCommentTableViewCell.m
//  ez
//
//  Created by dahe on 2019/6/28.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZCircleCommentTableViewCell.h"
#import "YZUserCircleViewController.h"
#import "UILabel+YZ.h"

@interface YZCircleCommentTableViewCell ()

@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *userNameLabel;
@property (nonatomic, weak) UILabel * timeLabel;
@property (nonatomic, weak) UILabel * commentLabel;
@property (nonatomic, weak) UIButton *replyButton;
@property (nonatomic, weak) UILabel * replyLabel;

@end

@implementation YZCircleCommentTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CircleCommentTableViewCellId";
    YZCircleCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZCircleCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 1)];
    line.backgroundColor = YZWhiteLineColor;
    [self addSubview:line];
    
    //头像
    UIImageView * avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView = avatarImageView;
    avatarImageView.layer.masksToBounds = YES;
    [self addSubview:avatarImageView];
    
    //昵称
    UILabel * userNameLabel = [[UILabel alloc] init];
    self.userNameLabel = userNameLabel;
    userNameLabel.textColor = YZDrayGrayTextColor;
    userNameLabel.textColor = YZBlackTextColor;
    userNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    userNameLabel.userInteractionEnabled = YES;
    [self addSubview:userNameLabel];
    
    UITapGestureRecognizer * userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userCircleDidClick)];
    [userNameLabel addGestureRecognizer:userTap];
    
    //时间
    UILabel * timeLabel = [[UILabel alloc] init];
    self.timeLabel = timeLabel;
    timeLabel.textColor = YZDrayGrayTextColor;
    timeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [self addSubview:timeLabel];
    
    //内容
    UILabel * commentLabel = [[UILabel alloc] init];
    self.commentLabel = commentLabel;
    commentLabel.textColor = YZBlackTextColor;
    commentLabel.numberOfLines = 0;
    [self addSubview:commentLabel];
    
    //回复内容
    UILabel * replyLabel = [[UILabel alloc] init];
    self.replyLabel = replyLabel;
    replyLabel.backgroundColor = YZWhiteLineColor;
    replyLabel.numberOfLines = 0;
    [self addSubview:replyLabel];
    
    //回复
    UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.replyButton = replyButton;
    [replyButton setTitle:@"回复" forState:UIControlStateNormal];
    [replyButton setTitleColor:YZDrayGrayTextColor forState:UIControlStateNormal];
    replyButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [replyButton addTarget:self action:@selector(replyButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:replyButton];
}

- (void)userCircleDidClick
{
    YZUserCircleViewController * userCircleVC = [[YZUserCircleViewController alloc] init];
    userCircleVC.userId = self.commentModel.byCommentUserId;
    [self.viewController.navigationController pushViewController:userCircleVC animated:YES];
}

- (void)replyButtonDidClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(replyButtonDidClickWithCell:)]) {
        [self.delegate replyButtonDidClickWithCell:self];
    }
}

- (void)setCommentModel:(YZCircleCommentModel *)commentModel
{
    _commentModel = commentModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_commentModel.headPortraitUrl] placeholderImage:[UIImage imageNamed:@"avatar_zc"]];
    self.userNameLabel.text = _commentModel.userName;
    self.timeLabel.text = _commentModel.timeStr;
    self.commentLabel.attributedText = _commentModel.commentAttStr;
    self.replyLabel.attributedText = _commentModel.replyAttStr;
    
    //frame
    self.avatarImageView.frame = _commentModel.avatarImageViewF;
    self.avatarImageView.layer.cornerRadius = _commentModel.avatarImageViewF.size.width / 2;
    self.userNameLabel.frame = _commentModel.userNameLabelF;
    self.timeLabel.frame = _commentModel.timeLabelF;
    self.commentLabel.frame = _commentModel.commentLabelF;
    self.replyLabel.hidden = [_commentModel.replyCount intValue] == 0;
    self.replyLabel.frame = _commentModel.replyLabelF;
    self.replyButton.frame = _commentModel.replyButtonF;
    
    //点击事件
    NSMutableArray * tagArray = [NSMutableArray array];
    for (YZTopicCommentReplyModel * replyModel in _commentModel.topicCommentReplys) {
        [tagArray addObject:replyModel.byReplyUserName];
    }
    NSString * allCommentStr = [NSString stringWithFormat:@"\n查看全部%@条评论", _commentModel.replyCount];
    [tagArray addObject:allCommentStr];
    typeof(self) __weak weakSelf = self;
    [self.replyLabel onTapRangeActionWithString:tagArray tapClicked:^(NSString *string, NSRange range, NSInteger index) {
        if ([string isEqualToString:allCommentStr]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(allCommentButtonDidClickWithCell:)]) {
                [self.delegate allCommentButtonDidClickWithCell:self];
            }
        }else
        {
            YZUserCircleViewController * userCircleVC = [[YZUserCircleViewController alloc] init];
            YZTopicCommentReplyModel * replyModel = _commentModel.topicCommentReplys[index];
            userCircleVC.userId = replyModel.userId;
            [weakSelf.viewController.navigationController pushViewController:userCircleVC animated:YES];
        }
    }];
}

@end
