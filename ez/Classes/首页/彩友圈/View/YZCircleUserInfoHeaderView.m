//
//  YZCircleUserInfoHeaderView.m
//  ez
//
//  Created by dahe on 2019/6/27.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZCircleUserInfoHeaderView.h"
#import "YZCircleViewAttentionViewController.h"
#import "YZAddImageManage.h"

@interface YZCircleUserInfoHeaderView ()<AddImageManageDelegate>

@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UILabel *nickNameLabel;
@property (nonatomic, weak) UIButton *attentionButon;
@property (nonatomic, weak) UIButton *fansButton;
@property (nonatomic, strong) YZAddImageManage * addImageManage;

@end

@implementation YZCircleUserInfoHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = YZBaseColor;
        [self setupChildViews];
    }
    return self;
}

#pragma mark - 布局子视图
- (void)setupChildViews
{
    //头像
    UIImageView * avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake((screenWidth - 55) / 2, 70, 55, 55)];
    self.avatarImageView = avatarImageView;
    avatarImageView.layer.masksToBounds = YES;
    avatarImageView.layer.cornerRadius = avatarImageView.width / 2;
    avatarImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * chooseAvatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseAvatarDidClick)];
    [avatarImageView addGestureRecognizer:chooseAvatarTap];
    [self addSubview:avatarImageView];
    
    //昵称
    UILabel * nickNameLabel = [[UILabel alloc] init];
    self.nickNameLabel = nickNameLabel;
    nickNameLabel.textColor = [UIColor whiteColor];
    nickNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(32)];
    nickNameLabel.textAlignment = NSTextAlignmentCenter;
    nickNameLabel.frame = CGRectMake(0, CGRectGetMaxY(avatarImageView.frame) + 12, self.width, nickNameLabel.font.lineHeight);
    [self addSubview:nickNameLabel];
    
    CGFloat buttonPadding = 30;
    CGFloat buttonW = (screenWidth - 3 * buttonPadding) / 2;
    for (int i = 0; i < 2; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(buttonPadding + (buttonW + buttonPadding) * i, CGRectGetMaxY(nickNameLabel.frame) + 10, buttonW, 25);
        if (i == 0) {
            self.attentionButon = button;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }else if (i == 1)
        {
            self.fansButton = button;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(screenWidth / 2 - 0.75, CGRectGetMaxY(nickNameLabel.frame) + 15, 1.5, 15)];
    line.backgroundColor = [UIColor whiteColor];
    [self addSubview:line];
}

- (void)setUserInfoModel:(YZCircleUserInfoModel *)userInfoModel
{
    _userInfoModel = userInfoModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_userInfoModel.headPortraitUrl] placeholderImage:[UIImage imageNamed:@"avatar_zc"]];
    self.nickNameLabel.text = _userInfoModel.nickname;
    [self.attentionButon setTitle:[NSString stringWithFormat:@"关注%@", _userInfoModel.concernCount] forState:UIControlStateNormal];
    [self.fansButton setTitle:[NSString stringWithFormat:@"粉丝%@", _userInfoModel.fansCount] forState:UIControlStateNormal];
    
}

- (void)buttonDidClick:(UIButton *)button
{
    YZCircleViewAttentionViewController * attentionVC = [[YZCircleViewAttentionViewController alloc] init];
    attentionVC.isFans = button.tag == 1;
    attentionVC.userId = self.userId;
    [self.viewController.navigationController pushViewController:attentionVC animated:YES];
}

#pragma mark - 修改头像
- (void)chooseAvatarDidClick
{
    if (!self.canChooseAvatar) {
        return;
    }
    
    self.addImageManage = [[YZAddImageManage alloc] init];
    self.addImageManage.viewController = self.viewController;
    self.addImageManage.delegate = self;
    [self.addImageManage addImage];
}

- (void)imageManageCropImage:(UIImage *)image
{
    NSDictionary *dict = @{
                           @"type": @"user",
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/getAliOssToken") params:dict success:^(id json) {
        YZLog(@"getAliOssToken:%@",json);
        if (SUCCESS){
            [[YZHttpTool shareInstance] uploadWithImage:image currentIndex:0 totalCount:1 aliOssToken:json[@"aliOssToken"] Success:^(NSString * picUrl) {
                [self setUserHeadPortraitWithUserHeadPortrait:picUrl image:image];
            } Failure:^(NSError *error) {
                [MBProgressHUD showError:@"上传图片失败"];
            }  Progress:^(float percent) {
                
            }];
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"error = %@",error);
    }];
}

- (void)setUserHeadPortraitWithUserHeadPortrait:(NSString *)userHeadPortrait image:(UIImage *)image
{
    NSDictionary *dict = @{
                           @"userHeadPortrait": userHeadPortrait
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrlInformation(@"/setUserHeadPortrait") params:dict success:^(id json) {
        YZLog(@"setUserHeadPortrait:%@",json);
        if (SUCCESS){
            self.avatarImageView.image = image;
        }else
        {
            ShowErrorView
        }
    } failure:^(NSError *error) {
        YZLog(@"error = %@",error);
    }];
}

@end
