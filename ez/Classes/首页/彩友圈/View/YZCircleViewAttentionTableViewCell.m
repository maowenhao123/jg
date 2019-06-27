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
    CGFloat avatarImageViewWH = 40;
    UIImageView * avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (60 - avatarImageViewWH) / 2, avatarImageViewWH, avatarImageViewWH)];
    self.avatarImageView = avatarImageView;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = 20;
    [self addSubview:avatarImageView];
    
    //昵称
    UILabel * nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(avatarImageView.frame) + 10, 0, 150, 60)];
    self.nickNameLabel = nickNameLabel;
    nickNameLabel.text = @"昵称";
    nickNameLabel.textColor = YZBlackTextColor;
    nickNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [self addSubview:nickNameLabel];
    
    //取消关注
    UIButton *attentionButon = [UIButton buttonWithType:UIButtonTypeCustom];
    attentionButon.frame = CGRectMake(screenWidth - YZMargin - 70, (60 - 30) / 2, 70, 30);
    attentionButon.backgroundColor = YZBaseColor;
    [attentionButon setTitle:@"取消" forState:UIControlStateNormal];
    [attentionButon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    attentionButon.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    attentionButon.layer.masksToBounds = YES;
    attentionButon.layer.cornerRadius = 3;
    [attentionButon addTarget:self action:@selector(attentionButonDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:attentionButon];
}

- (void)attentionButonDidClick
{
    if([self.delegate respondsToSelector:@selector(circleViewAttentionTableViewCellAttentionBtnDidClick:)])
    {
        [self.delegate circleViewAttentionTableViewCellAttentionBtnDidClick:self];
    }
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", _dic[@"headPortraitUrl"]]] placeholderImage:[UIImage imageNamed:@"avatar_zc"]];
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@", _dic[@"nickname"]];
}


@end
