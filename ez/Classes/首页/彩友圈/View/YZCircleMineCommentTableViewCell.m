//
//  YZCircleMineCommentTableViewCell.m
//  ez
//
//  Created by dahe on 2019/6/28.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZCircleMineCommentTableViewCell.h"
#import "YZUserCircleViewController.h"
#import "YZCircleDetailViewController.h"

@interface YZCircleMineCommentTableViewCell ()

@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *userNameLabel;
@property (nonatomic, weak) UILabel * timeLabel;
@property (nonatomic, weak) UILabel * commentLabel;
@property (nonatomic, weak) UILabel * myCommentLabel;
@property (nonatomic, weak) UILabel * titleLabel;

@end

@implementation YZCircleMineCommentTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CircleMineCommentTableViewCellId";
    YZCircleMineCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZCircleMineCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    avatarImageView.layer.cornerRadius = 18;
    [self addSubview:avatarImageView];
    
    //昵称
    UILabel * userNameLabel = [[UILabel alloc] init];
    self.userNameLabel = userNameLabel;
    userNameLabel.textColor = YZDrayGrayTextColor;
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
    
    //我的评论
    UILabel * myCommentLabel = [[UILabel alloc] init];
    self.myCommentLabel = myCommentLabel;
    myCommentLabel.backgroundColor = YZWhiteLineColor;
    myCommentLabel.textColor = YZDrayGrayTextColor;
    myCommentLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    myCommentLabel.numberOfLines = 0;
    [self addSubview:myCommentLabel];
    
    //原文
    UILabel * titleLabel = [[UILabel alloc] init];
    self.titleLabel = titleLabel;
    titleLabel.backgroundColor = YZWhiteLineColor;
    titleLabel.textColor = YZDrayGrayTextColor;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    titleLabel.numberOfLines = 0;
    titleLabel.userInteractionEnabled = YES;
    [self addSubview:titleLabel];
    
    UITapGestureRecognizer * topicTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topicDidClick)];
    [titleLabel addGestureRecognizer:topicTap];

}

- (void)userCircleDidClick
{
    YZUserCircleViewController * userCircleVC = [[YZUserCircleViewController alloc] init];
    userCircleVC.userId = self.commentModel.userId;
    [self.viewController.navigationController pushViewController:userCircleVC animated:YES];
}

- (void)topicDidClick
{
    YZCircleDetailViewController * circleDetailVC = [[YZCircleDetailViewController alloc] init];
    circleDetailVC.topicId = self.commentModel.topicId;
    [self.viewController.navigationController pushViewController:circleDetailVC animated:YES];
}

- (void)setCommentModel:(YZCircleMineCommentModel *)commentModel
{
    _commentModel = commentModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_commentModel.headPortraitUrl] placeholderImage:[UIImage imageNamed:@"avatar_zc"]];
    self.userNameLabel.attributedText = _commentModel.userNameAttStr;
    self.timeLabel.text = _commentModel.timeStr;
    self.commentLabel.attributedText = _commentModel.commentAttStr;
    self.myCommentLabel.attributedText = _commentModel.myCommentAttStr;
    self.titleLabel.attributedText = _commentModel.titleAttStr;
    
    //frame
    self.avatarImageView.frame = _commentModel.avatarImageViewF;
    self.userNameLabel.frame = _commentModel.userNameLabelF;
    self.timeLabel.frame = _commentModel.timeLabelF;
    self.commentLabel.frame = _commentModel.commentLabelF;
    self.myCommentLabel.frame = _commentModel.myCommentLabelF;
    self.titleLabel.frame = _commentModel.titleLabelF;
}


@end
