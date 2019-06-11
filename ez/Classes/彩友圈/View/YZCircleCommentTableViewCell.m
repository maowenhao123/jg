//
//  YZCircleCommentTableViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleCommentTableViewCell.h"
@interface YZCircleCommentTableViewCell ()

@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *nickNameLabel;
@property (nonatomic, weak) UILabel * timeLabel;
@property (nonatomic, weak) UILabel * commentLabel;

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
    [self addSubview:avatarImageView];
    
    //昵称
    UILabel * nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel = nickNameLabel;
    nickNameLabel.textColor = YZBlackTextColor;
    nickNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [self addSubview:nickNameLabel];
    
    //时间
    UILabel * timeLabel = [[UILabel alloc] init];
    self.timeLabel = timeLabel;
    timeLabel.textColor = YZGrayTextColor;
    timeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [self addSubview:timeLabel];
    
    //内容
    UILabel * commentLabel = [[UILabel alloc] init];
    self.commentLabel = commentLabel;
    commentLabel.textColor = YZBlackTextColor;
    commentLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    commentLabel.numberOfLines = 0;
    [self addSubview:commentLabel];
    
}

- (void)setCommentModel:(YZCircleCommentModel *)commentModel
{
    _commentModel = commentModel;
    
    self.avatarImageView.image = [UIImage imageNamed:@"avatar_zc"];
    self.nickNameLabel.text = _commentModel.nickName;
    self.timeLabel.text = _commentModel.timeStr;
    self.commentLabel.text = _commentModel.content;
    
    self.avatarImageView.frame = _commentModel.avatarImageViewF;
    self.nickNameLabel.frame = _commentModel.nickNameLabelF;
    self.timeLabel.frame = _commentModel.timeLabelF;
    self.commentLabel.frame = _commentModel.commentLabelF;
}

@end
