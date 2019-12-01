//
//  YZCircleTableViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleTableViewCell.h"
#import "YZCircleDetailViewController.h"
#import "YZUserCircleViewController.h"
#import "YZUnionBuyDetailViewController.h"
#import "XLPhotoBrowser.h"
#import "UIButton+YZ.h"

@interface YZCircleTableViewCell ()<XLPhotoBrowserDatasource>

@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *nickNameLabel;
@property (nonatomic, weak) UILabel * timeLabel;
@property (nonatomic, weak) UILabel * communityLabel;
@property (nonatomic, weak) UIButton *attentionButon;
@property (nonatomic, weak) UILabel * detailLabel;
@property (nonatomic, weak) UIView * lotteryView;
@property (nonatomic, weak) UIView * lotteryLine;
@property (nonatomic, weak) UIImageView *logoImageView;
@property (nonatomic, weak) UIButton * deleteButton;
@property (nonatomic, weak) UIButton * praiseButton;
@property (nonatomic, weak) UIButton * commentButton;
@property (nonatomic, weak) YZBottomButton * followtButton;
@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, strong) NSMutableArray * imageViews;

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
    UITapGestureRecognizer * detailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(circleDetailDidClick)];
    [self addGestureRecognizer:detailTap];
    
    //分割线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 9)];
    lineView.backgroundColor = YZBackgroundColor;
    [self addSubview:lineView];
    
    //头像
    UIImageView * avatarImageView = [[UIImageView alloc] init];
    self.avatarImageView = avatarImageView;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = 18;
    avatarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * avatarUserTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userCircleDidClick)];
    [avatarImageView addGestureRecognizer:avatarUserTap];
    [self addSubview:avatarImageView];
    
    //昵称
    UILabel * nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel = nickNameLabel;
    nickNameLabel.textColor = YZBlackTextColor;
    nickNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    nickNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer * nickNameUserTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userCircleDidClick)];
    [nickNameLabel addGestureRecognizer:nickNameUserTap];
    [self addSubview:nickNameLabel];
    
    //时间
    UILabel * timeLabel = [[UILabel alloc] init];
    self.timeLabel = timeLabel;
    timeLabel.textColor = YZDrayGrayTextColor;
    timeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [self addSubview:timeLabel];
    
    //玩法
    UILabel * communityLabel = [[UILabel alloc] init];
    self.communityLabel = communityLabel;
    communityLabel.textColor = YZDrayGrayTextColor;
    communityLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    communityLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:communityLabel];
    
    //关注
    UIButton *attentionButon = [UIButton buttonWithType:UIButtonTypeCustom];
    self.attentionButon = attentionButon;
    attentionButon.frame = CGRectMake(screenWidth - YZMargin - 70, (60 - 30) / 2, 70, 30);
    [attentionButon setBackgroundImage:[UIImage ImageFromColor:YZBaseColor] forState:UIControlStateNormal];
    [attentionButon setTitle:@"关注" forState:UIControlStateNormal];
    [attentionButon setBackgroundImage:[UIImage ImageFromColor:[UIColor lightGrayColor]] forState:UIControlStateDisabled];
    [attentionButon setTitle:@"已关注" forState:UIControlStateDisabled];
    [attentionButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    attentionButon.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    attentionButon.layer.masksToBounds = YES;
    attentionButon.layer.cornerRadius = 3;
    [attentionButon addTarget:self action:@selector(attentionButonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:attentionButon];
    
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
    
    for(NSUInteger i = 0; i < 7; i++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.textColor = YZDrayGrayTextColor;
        label.numberOfLines = 0;
        [self.labels addObject:label];
        [lotteryView addSubview:label];
    }
    //分割线
    UIView * lotteryLine = [[UIView alloc] init];
    self.lotteryLine = lotteryLine;
    lotteryLine.backgroundColor = [UIColor whiteColor];
    [lotteryView addSubview:lotteryLine];
    
    //logo
    UIImageView * logoImageView = [[UIImageView alloc] init];
    self.logoImageView = logoImageView;
    logoImageView.layer.masksToBounds = YES;
    logoImageView.layer.cornerRadius = 30;
    [lotteryView addSubview:logoImageView];
    
    //图片
    UIView * lastView = detailLabel;
    for (int i = 0; i < 9; i++) {
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
    UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton = deleteButton;
    deleteButton.frame = CGRectMake(lotteryView.x, CGRectGetMaxY(lastView.frame), buttonW, buttonH);
    [deleteButton setImage:[UIImage imageNamed:@"delete_circle_icon"] forState:UIControlStateNormal];
    [deleteButton setTitleColor:YZGrayTextColor forState:UIControlStateNormal];
    deleteButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [deleteButton addTarget:self action:@selector(deleteButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteButton];
    
    //点赞
    UIButton * praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.praiseButton = praiseButton;
    praiseButton.frame = CGRectMake(screenWidth - 2 * YZMargin - buttonW * 2, CGRectGetMaxY(lastView.frame), buttonW, buttonH);
    [praiseButton setImage:[UIImage imageNamed:@"show_praise_gray"] forState:UIControlStateNormal];
    [praiseButton setImage:[UIImage imageNamed:@"show_praise_light"] forState:UIControlStateSelected];
    [praiseButton setTitleColor:YZGrayTextColor forState:UIControlStateNormal];
    praiseButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [praiseButton addTarget:self action:@selector(praiseButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:praiseButton];
    
    //评论
    UIButton * commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commentButton = commentButton;
    commentButton.frame = CGRectMake(screenWidth - YZMargin - buttonW, CGRectGetMaxY(lastView.frame), buttonW, buttonH);
    [commentButton setImage:[UIImage imageNamed:@"show_comment"] forState:UIControlStateNormal];
    [commentButton setTitleColor:YZGrayTextColor forState:UIControlStateNormal];
    commentButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(22)];
    [self addSubview:commentButton];
    
    //跟单
    YZBottomButton * followtButton = [YZBottomButton buttonWithType:UIButtonTypeCustom];
    self.followtButton = followtButton;
    [followtButton setTitle:@"我要跟单" forState:UIControlStateNormal];
    followtButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    [followtButton addTarget:self action:@selector(followtButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.lotteryView addSubview:followtButton];
}

- (void)userCircleDidClick
{
    YZUserCircleViewController * userCircleVC = [[YZUserCircleViewController alloc] init];
    userCircleVC.userId = self.circleModel.userId;
    [self.viewController.navigationController pushViewController:userCircleVC animated:YES];
}

- (void)circleDetailDidClick
{
    YZCircleDetailViewController * circleDetailVC = [[YZCircleDetailViewController alloc] init];
    if (!YZStringIsEmpty(self.circleModel.id)) {
        circleDetailVC.topicId = self.circleModel.id;
    }else
    {
        circleDetailVC.topicId = self.circleModel.topicId;
    }
    [self.viewController.navigationController pushViewController:circleDetailVC animated:YES];
}

- (void)followtButtonDidClick
{
    YZUnionBuyDetailViewController *unionBuyDetailVC = [[YZUnionBuyDetailViewController alloc] initWithUnionBuyPlanId:self.circleModel.extInfo.unionBuyUserId gameId:self.circleModel.extInfo.gameId];
    [self.viewController.navigationController pushViewController:unionBuyDetailVC animated:YES];
}

- (void)attentionButonDidClick
{
    NSDictionary *dict = @{
                           @"userId": UserId,
                           @"byConcernUserId": _circleModel.userId,
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/userConcern") params:dict success:^(id json) {
        YZLog(@"userConcern:%@",json);
        if (SUCCESS){
            self.attentionButon.enabled = NO;
        }else
        {
            ShowErrorView
        }
    }failure:^(NSError *error)
    {
         YZLog(@"error = %@",error);
    }];
}

- (void)deleteButtonDidClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(circleTableViewCellDeleteButtonDidClickWithCell:)]) {
        [_delegate circleTableViewCellDeleteButtonDidClickWithCell:self];
    }
}

- (void)praiseButtonDidClick
{
    NSString * topicId = self.circleModel.topicId;
    if (YZStringIsEmpty(topicId)) {
        topicId = self.circleModel.id;
    }
    NSDictionary *dict = @{
                           @"userId": UserId,
                           @"topicId": topicId,
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/topicLike") params:dict success:^(id json) {
        YZLog(@"topicLike:%@",json);
        if (SUCCESS){
            self.praiseButton.selected = [json[@"likeStatus"] boolValue];
            int likeNumber = [self.praiseButton.currentTitle intValue];
            if (self.praiseButton.selected) {
                likeNumber++;
            }else
            {
                likeNumber--;
            }
            [self.praiseButton setTitle:[NSString stringWithFormat:@"%d", likeNumber] forState:UIControlStateNormal];
        }else
        {
            ShowErrorView
        }
    }failure:^(NSError *error)
     {
         YZLog(@"error = %@",error);
     }];
}

- (void)imageViewDidClick:(UIGestureRecognizer *)ges
{
    UIView * view = ges.view;
    NSMutableArray * imageUrls = [NSMutableArray array];
    for (NSDictionary * topicAlbumDic in self.circleModel.topicAlbumList) {
        [imageUrls addObject:topicAlbumDic[@"originalUrl"]];
    }
    XLPhotoBrowser * photoBrowser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:view.tag imageCount:imageUrls.count datasource:self];
    photoBrowser.browserStyle = XLPhotoBrowserStyleSimple;
}

#pragma mark - XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSMutableArray * imageUrls = [NSMutableArray array];
    for (NSDictionary * topicAlbumDic in self.circleModel.topicAlbumList) {
        [imageUrls addObject:topicAlbumDic[@"originalUrl"]];
    }
    return imageUrls[index];
}

- (UIView *)photoBrowser:(XLPhotoBrowser *)browser sourceImageViewForIndex:(NSInteger)index
{
    return self.imageViews[index];
}

- (void)setCircleModel:(YZCircleModel *)circleModel
{
    _circleModel = circleModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_circleModel.headPortraitUrl] placeholderImage:[UIImage imageNamed:@"avatar_zc"]];
    self.nickNameLabel.text = _circleModel.nickname ? _circleModel.nickname : _circleModel.userName;
    self.timeLabel.attributedText = _circleModel.timeAttStr;
    self.communityLabel.text = _circleModel.communityName;
    self.attentionButon.enabled = ![_circleModel.concernStatus boolValue];
#if JG
    self.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@", _circleModel.extInfo.gameId]];
#elif ZC
    self.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_zc", _circleModel.extInfo.gameId]];
#elif CS
    self.logoImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@_zc", _circleModel.extInfo.gameId]];
#endif
    self.detailLabel.attributedText = _circleModel.detailAttStr;
    [self.praiseButton setTitle:[NSString stringWithFormat:@"%@", _circleModel.likeNumber] forState:UIControlStateNormal];
    [self.commentButton setTitle:@"0" forState:UIControlStateNormal];
    [self.praiseButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:2];
    [self.commentButton setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:2];
    
    //frame
    if (_circleModel.circleTableViewType == CircleTableViewUser || _circleModel.circleTableViewType == CircleTableViewMine) {
        self.avatarImageView.hidden = YES;
        self.nickNameLabel.hidden = YES;
    }else
    {
        self.avatarImageView.hidden = NO;
        self.nickNameLabel.hidden = NO;
        self.avatarImageView.frame = _circleModel.avatarImageViewF;
        self.nickNameLabel.frame = _circleModel.nickNameLabelF;
    }
    self.timeLabel.frame = _circleModel.timeLabelF;
    self.communityLabel.frame = _circleModel.communityLabelF;
    self.attentionButon.frame = _circleModel.attentionButonF;
    self.detailLabel.frame = _circleModel.detailLabelF;
    self.lotteryView.frame = _circleModel.lotteryViewF;
    self.lotteryView.hidden = [_circleModel.type intValue] != 1;
    for (int i = 0; i < self.labels.count; i++) {
        UILabel * label = self.labels[i];
        label.hidden = YES;
        if (i < _circleModel.labelFs.count) {
            label.hidden = NO;
            label.frame = [_circleModel.labelFs[i] CGRectValue];
        }
        if (i < _circleModel.lotteryMessages.count) {
            label.hidden = NO;
            label.attributedText = _circleModel.lotteryMessages[i];
        }
    }
    CGRect labelF1 = [_circleModel.labelFs[0] CGRectValue];
    self.lotteryLine.frame = CGRectMake(0, CGRectGetMaxY(labelF1) + 6, self.lotteryView.width, 2.5);
    
    self.followtButton.frame = _circleModel.followtButtonF;
    self.logoImageView.frame = _circleModel.logoImageViewF;
    UIView * lastView = self.lotteryView;
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView * imageView = self.imageViews[i];
        imageView.hidden = YES;
        if (i < _circleModel.imageViewFs.count) {
            NSDictionary * imageDic = _circleModel.topicAlbumList[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageDic[@"originalUrl"]] placeholderImage:[UIImage ImageFromColor:YZWhiteLineColor]];
            CGRect imageViewF = [_circleModel.imageViewFs[i] CGRectValue];
            imageView.hidden = NO;
            imageView.frame = imageViewF;
            if (i % 3 == 0) {
               lastView = imageView;
            }
        }
    }
    if (_circleModel.circleTableViewType == CircleTableViewMine) {
        self.deleteButton.y = CGRectGetMaxY(lastView.frame) + 5;
        if ([_circleModel.type intValue] == 1) {
            self.deleteButton.x = self.lotteryView.x;
        }else
        {
            self.deleteButton.x = lastView.x;
        }
        self.deleteButton.hidden = NO;
    }else
    {
        self.deleteButton.hidden = YES;
    }
    
    if (_circleModel.circleTableViewType == CircleTableViewDetail) {
        self.praiseButton.hidden = YES;
        self.commentButton.hidden = YES;
    }else
    {
        self.praiseButton.hidden = NO;
        self.commentButton.hidden = NO;
        self.praiseButton.y = CGRectGetMaxY(lastView.frame) + 5;
        self.commentButton.y = CGRectGetMaxY(lastView.frame) + 5;
    }
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
