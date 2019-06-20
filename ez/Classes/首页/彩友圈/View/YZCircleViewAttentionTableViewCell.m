//
//  YZCircleViewAttentionTableViewCell.m
//  ez
//
//  Created by 毛文豪 on 2018/7/18.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZCircleViewAttentionTableViewCell.h"

@interface YZCircleViewAttentionTableViewCell ()

@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *nickNameLabel;
@property (nonatomic, weak) UILabel * timeLabel;
@property (nonatomic, weak) UILabel * commentLabel;

@end

@implementation YZCircleViewAttentionTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"CircleViewAttentionTableViewCellId";
    YZCircleViewAttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZCircleViewAttentionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
    CGFloat avatarImageViewWH = 35;
    UIImageView * avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (50 - avatarImageViewWH) / 2, avatarImageViewWH, avatarImageViewWH)];
    self.avatarImageView = avatarImageView;
    avatarImageView.image = [UIImage imageNamed:@"avatar_zc"];
    [self addSubview:avatarImageView];
    
    //昵称
    UILabel * nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + 10, 0, 150, 50)];
    self.nickNameLabel = nickNameLabel;
    nickNameLabel.text = @"昵称";
    nickNameLabel.textColor = YZBlackTextColor;
    nickNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [self addSubview:nickNameLabel];
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_dic[@"headPortraitUrl"]]];
    self.nickNameLabel.text = _dic[@"nickname"];
}


@end
