//
//  YZCircleTableViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleTableViewCell.h"
#import "UIButton+YZ.h"

@interface YZCircleTableViewCell ()

@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *nickNameLabel;
@property (nonatomic, weak) UILabel * timeLabel;
@property (nonatomic, weak) UILabel * detailLabel;
@property (nonatomic, weak) UIView * lotteryView;
@property (nonatomic, weak) UIImageView *logoImageView;
@property (nonatomic, weak) UIButton * praiseButton;
@property (nonatomic, weak) UIButton * commentButton;
@property (nonatomic, strong) NSMutableArray *labels;

@end

@implementation YZCircleTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CircleTableViewCellId";
    YZCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZCircleTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 9)];
    lineView.backgroundColor = YZBackgroundColor;
    [self addSubview:lineView];
    
    //头像
    UIImageView * avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView = avatarImageView;
    [self addSubview:avatarImageView];
    
    //昵称
    UILabel * nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel = nickNameLabel;
    nickNameLabel.textColor = YZBlackTextColor;
    nickNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [self addSubview:nickNameLabel];
    
    //时间
    UILabel * timeLabel = [[UILabel alloc] init];
    self.timeLabel = timeLabel;
    timeLabel.textColor = YZGrayTextColor;
    timeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [self addSubview:timeLabel];
    
    //内容
    UILabel * detailLabel = [[UILabel alloc] init];
    self.detailLabel = detailLabel;
    detailLabel.textColor = YZBlackTextColor;
    detailLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    detailLabel.numberOfLines = 0;
    [self addSubview:detailLabel];
    
    //彩票信息
    UIView * lotteryView = [[UIView alloc] init];
    self.lotteryView = lotteryView;
    lotteryView.backgroundColor = YZColor(255, 251, 243, 1);
    [self addSubview:lotteryView];
    
    NSArray * lotteryMessages = @[@"期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数期数", @"倍数", @"金额", @"佣金", @"方案"];
    for(NSUInteger i = 0; i < lotteryMessages.count; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = lotteryMessages[i];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        label.textColor = YZDrayGrayTextColor;
        label.numberOfLines = 0;
        [self.labels addObject:label];
        [lotteryView addSubview:label];
    }
    
    //logo
    UIImageView * logoImageView = [[UIImageView alloc] init];
    self.logoImageView = logoImageView;
    logoImageView.backgroundColor = [UIColor redColor];
    logoImageView.layer.masksToBounds = YES;
    logoImageView.layer.cornerRadius = 30;
    [lotteryView addSubview:logoImageView];
    
    //图片
    UIView * lastView = detailLabel;
    for (int i = 0; i < 3; i++) {
        UIImageView * imageView = [[UIImageView alloc] init];
        imageView.tag = i;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.hidden = YES;
        [self addSubview:imageView];
        [self.imageViews addObject:imageView];
        lastView = imageView;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidClick:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
    }
    
    CGFloat buttonW = 40;
    CGFloat buttonH = 26;
    //点赞
    UIButton * praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.praiseButton = praiseButton;
    praiseButton.frame = CGRectMake(screenWidth - 2 * YZMargin - buttonW * 2, CGRectGetMaxY(lastView.frame), buttonW, buttonH);
    [praiseButton setImage:[UIImage imageNamed:@"show_praise_gray"] forState:UIControlStateNormal];
    [praiseButton setTitleColor:YZGrayTextColor forState:UIControlStateNormal];
    praiseButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [self addSubview:praiseButton];
    
    //评论
    UIButton * commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentButton = commentButton;
    commentButton.frame = CGRectMake(screenWidth - YZMargin - buttonW, CGRectGetMaxY(lastView.frame), buttonW, buttonH);
    [commentButton setImage:[UIImage imageNamed:@"show_comment"] forState:UIControlStateNormal];
    [commentButton setTitleColor:YZGrayTextColor forState:UIControlStateNormal];
    commentButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [self addSubview:commentButton];
}

- (void)imageViewDidClick:(UIGestureRecognizer *)ges
{
    
}

- (void)setCircleModel:(YZCircleModel *)circleModel
{
    _circleModel = circleModel;
    
    self.avatarImageView.image = [UIImage imageNamed:@"avatar_zc"];
    self.nickNameLabel.text = _circleModel.nickName;
    self.timeLabel.text = _circleModel.timeStr;
    self.detailLabel.attributedText = _circleModel.detailAttStr;
    [self.praiseButton setTitle:@"11" forState:UIControlStateNormal];
    [self.commentButton setTitle:@"11" forState:UIControlStateNormal];
    [self.praiseButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:2];
    [self.commentButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:2];
    
    //frame
    self.avatarImageView.frame = _circleModel.avatarImageViewF;
    self.nickNameLabel.frame = _circleModel.nickNameLabelF;
    self.timeLabel.frame = _circleModel.timeLabelF;
    self.detailLabel.frame = _circleModel.detailLabelF;
    self.lotteryView.frame = _circleModel.lotteryViewF;
    for (int i = 0; i < self.labels.count; i++) {
        UILabel * label = self.labels[i];
        label.frame = [_circleModel.labelFs[i] CGRectValue];
    }
    self.logoImageView.frame = _circleModel.logoImageViewF;
    UIView * lastView = self.lotteryView;
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView * imageView = self.imageViews[i];
        imageView.hidden = YES;
        if (i < _circleModel.imageViewFs.count) {
            imageView.backgroundColor = [UIColor redColor];
            CGRect imageViewF = [_circleModel.imageViewFs[i] CGRectValue];
            imageView.hidden = NO;
            imageView.frame = imageViewF;
            lastView = imageView;
        }
    }
    self.praiseButton.y = CGRectGetMaxY(lastView.frame);
    self.commentButton.y = CGRectGetMaxY(lastView.frame);
}

#pragma mark - 初始化
- (NSMutableArray *)labels
{
    if(_labels == nil)
    {
        _labels = [NSMutableArray array];
    }
    return  _labels;
}

- (NSMutableArray *)imageViews
{
    if (!_imageViews) {
        _imageViews = [NSMutableArray array];
    }
    return _imageViews;
}


@end
