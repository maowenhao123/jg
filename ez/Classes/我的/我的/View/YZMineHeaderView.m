//
//  YZMineHeaderView.m
//  ez
//
//  Created by 毛文豪 on 2018/11/28.
//  Copyright © 2018 9ge. All rights reserved.
//

#define KWidth self.bounds.size.width
#define KHeight self.bounds.size.height

#import "YZMineHeaderView.h"
#import "UIButton+YZ.h"
#import "YZThirdPartyStatus.h"
#import "UIImageView+WebCache.h"

@interface YZMineHeaderView ()

@property (nonatomic, weak) UILabel *nickNameLabel;
@property (nonatomic, weak) UILabel * nameCertificationLabel;
@property (nonatomic, weak) UIView *line1;
@property (nonatomic, weak) UILabel * phoneBindingLabel;
@property (nonatomic, strong) NSMutableArray *moneyDetailbtns;
@property (nonatomic, weak) UIButton * rechargeButton;
@property (nonatomic, weak) UIButton * withdrawalButton;
@property (nonatomic, weak) UIButton * voucheButton;

@end

@implementation YZMineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupChilds];
    }
    return self;
}

- (void)setupChilds
{
    //背景
    UIImageView * backView = [[UIImageView alloc]init];
    backView.frame = CGRectMake(0, 0, screenWidth, 146);
    backView.image = [UIImage imageNamed:@"mine_top_back2"];
    backView.userInteractionEnabled = YES;
    [self addSubview:backView];
    
    //头像
    UIImageView *avatar = [[UIImageView alloc]initWithFrame:CGRectMake(YZMargin, 8, 65, 65)];
    self.avatar = avatar;
    avatar.layer.masksToBounds = YES;
    avatar.layer.cornerRadius = avatar.width / 2;
    avatar.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:avatar];
    avatar.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarClick)];
    [avatar addGestureRecognizer:tap];
    
    //昵称
    UILabel * nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(avatar.frame) + 10, 15, screenWidth - (CGRectGetMaxX(avatar.frame) + 10), 30)];
    self.nickNameLabel = nickNameLabel;
    nickNameLabel.textColor = [UIColor whiteColor];
    nickNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    [self addSubview:nickNameLabel];
    
    //实名认证
    UILabel * nameCertificationLabel = [[UILabel alloc]init];
    self.nameCertificationLabel = nameCertificationLabel;
    nameCertificationLabel.textColor = YZColor(253, 165, 162, 1);
    nameCertificationLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [self addSubview:nameCertificationLabel];
    
    //分割线1
    UIView * line1 = [[UIView alloc]init];
    self.line1 = line1;
    line1.backgroundColor = YZColor(253, 165, 162, 1);
    [self addSubview:line1];
    
    //手机绑定信息
    UILabel * phoneBindingLabel = [[UILabel alloc]init];
    self.phoneBindingLabel = phoneBindingLabel;
    phoneBindingLabel.textColor = YZColor(253, 165, 162, 1);
    phoneBindingLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    [self addSubview:phoneBindingLabel];
    
    //分割线2
    UIView * line2 = [[UIView alloc]initWithFrame:CGRectMake(YZMargin, CGRectGetMaxY(avatar.frame) + 8, screenWidth - 2 * YZMargin, 1)];
    line2.backgroundColor = YZColor(205, 29, 42, 1);
    [self addSubview:line2];
    
    //accessory
    CGFloat accessoryW = 8;
    CGFloat accessoryH = 11;
    UIImageView * accessory = [[UIImageView alloc]init];
    accessory.frame = CGRectMake(screenWidth - YZMargin - accessoryW, (81 - accessoryH) / 2, accessoryW, accessoryH);
    accessory.image = [UIImage imageNamed:@"accessory_red"];
    [self addSubview:accessory];
    
    //资金
    CGFloat moneyDetailBtnY = CGRectGetMaxY(line2.frame);
    CGFloat moneyDetailBtnH = 65;
    CGFloat line3H = 35;
    for (int i = 0; i < 3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(screenWidth * i / 3, moneyDetailBtnY, screenWidth / 3, moneyDetailBtnH);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.numberOfLines = 2;
        [self addSubview:button];
        [self.moneyDetailbtns addObject:button];
        if (i != 2) {
            UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(screenWidth / 3 - 1,(moneyDetailBtnH - line3H) / 2, 1.5, line3H)];
            line3.backgroundColor = YZColor(205, 29, 42, 1);
            [button addSubview:line3];
        }
    }
    //充值提款
    CGFloat rechargeBtnY = CGRectGetMaxY(backView.frame);
    CGFloat rechargeBtnH = 58;
    CGFloat line4H = 30;
    for (int i = 0; i < 3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(screenWidth / 3 * i, rechargeBtnY, screenWidth / 3, rechargeBtnH);
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            self.rechargeButton = button;
            [button setImage:[UIImage imageNamed:@"mine_recharge_icon"] forState:UIControlStateNormal];
            [button setTitle:@"充值" forState:UIControlStateNormal];
        }else if (i == 1)
        {
            self.withdrawalButton = button;
            [button setImage:[UIImage imageNamed:@"mine_withdrawal_icon"] forState:UIControlStateNormal];
            [button setTitle:@"提款" forState:UIControlStateNormal];
        }else if (i == 2)
        {
            self.voucheButton = button;
            [button setImage:[UIImage imageNamed:@"vouche_bar"] forState:UIControlStateNormal];
            [button setTitle:@"彩券" forState:UIControlStateNormal];
        }
        [button setTitleColor:YZBlackTextColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
        [button setButtonTitleWithImageAlignment:UIButtonTitleWithImageAlignmentLeft imgTextDistance:10];//图片和文字的间距
        [button addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        if (i != 0) {
            UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, (rechargeBtnH - line4H) / 2, 1, line4H)];
            line4.backgroundColor = YZWhiteLineColor;
            [button addSubview:line4];
        }
    }
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDidClick)]];
}

#pragma mark - 按钮点击
- (void)tapDidClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(mineHeaderViewDidClick)]) {
        [_delegate mineHeaderViewDidClick];
    }
}

- (void)avatarClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(mineDetailTableViewCellDidClickAvatar)]) {
        [_delegate mineDetailTableViewCellDidClickAvatar];
    }
}

- (void)buttonDidClick:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(mineRechargeTableViewCellDidClickBtn:)]) {
        [_delegate mineRechargeTableViewCellDidClickBtn:button];
    }
}
#pragma mark - 设置数据
- (void)setUser:(YZUser *)user
{
    _user = user;
    //头像
    NSString * loginWay = [YZUserDefaultTool getObjectForKey:@"loginWay"];
    YZThirdPartyStatus *thirdPartyStatus = [YZUserDefaultTool thirdPartyStatus];
    if ([loginWay isEqualToString:@"thirdPartyLogin"] && thirdPartyStatus) {//第三方登录
        NSURL *imageUrl = [NSURL URLWithString:thirdPartyStatus.iconurl];
        //取出偏好设置中得已选图片
        NSString *imageTag = [YZUserDefaultTool getObjectForKey:@"selectedIconTag"];
        imageTag = imageTag ? imageTag : @"0";
        UIImage *placeholderImage = [UIImage imageNamed:[NSString stringWithFormat:@"icon%@",imageTag]];
        [self.avatar sd_setImageWithURL:imageUrl placeholderImage:placeholderImage];
    }else
    {
        //取出偏好设置中得已选图片
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *imageTag = [defaults stringForKey:@"selectedIconTag"];
        if(imageTag == nil)
        {//如果没有就默认第一张图片
            imageTag = @"0";
        }
        self.avatar.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon%@",imageTag]];
    }
    
    //赋值个人基本信息
    if ([loginWay isEqualToString:@"thirdPartyLogin"] && thirdPartyStatus) {//第三方登录
        self.nickNameLabel.text = thirdPartyStatus.name;
    }else
    {
        self.nickNameLabel.text = _user.nickName;
    }
    
    if (_user.userInfo.realname) {
        self.nameCertificationLabel.text = @"已认证";
    }else
    {
        self.nameCertificationLabel.text = @"未认证";
    }
    if (_user.mobilePhone) {
        self.phoneBindingLabel.text = @"已绑定手机";
    }else
    {
        self.phoneBindingLabel.text = @"未绑定手机";
    }
    //赋值彩金、奖金、积分
    NSString *balance = [NSString stringWithFormat:@"%.2f元",[_user.balance intValue] / 100.0];
    if ([_user.balance intValue] == 0)
    {
        balance = @"0元";
    }
    NSString *bonus = [NSString stringWithFormat:@"%.2f元",[_user.bonus intValue] / 100.0];
    if ([_user.bonus intValue] == 0)
    {
        bonus = @"0元";
    }
    NSString *grade = [NSString stringWithFormat:@"%d",[_user.grade intValue]];
    NSArray *moneys = [NSArray arrayWithObjects:balance,bonus,grade,nil];
    NSArray * moneyDetailbtnTitles = @[@"彩金",@"奖金",@"积分"];
    for (UIButton * button in self.moneyDetailbtns) {
        NSInteger index = [self.moneyDetailbtns indexOfObject:button];
        NSString * btnStr = [NSString stringWithFormat:@"%@\n%@",moneyDetailbtnTitles[index],moneys[index]];
        NSMutableAttributedString * btnAttStr = [[NSMutableAttributedString alloc]initWithString:btnStr];
        [btnAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(0, 2)];
        [btnAttStr addAttribute:NSForegroundColorAttributeName value:YZColor(253, 165, 162, 1) range:NSMakeRange(0, 2)];
        [btnAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(35)] range:NSMakeRange(2, btnAttStr.length - 2)];
        [btnAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(2, btnAttStr.length - 2)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;//居中
        [paragraphStyle setLineSpacing:7];//行间距
        [btnAttStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, btnAttStr.length)];
        [button setAttributedTitle:btnAttStr forState:UIControlStateNormal];
    }
    
    //frame
    CGSize nickSize = [self.nickNameLabel.text sizeWithLabelFont:self.nickNameLabel.font];
    CGSize nameSize = [self.nameCertificationLabel.text sizeWithLabelFont:self.nameCertificationLabel.font];
    CGFloat padding = 5;
    CGFloat nickNameY = (81 - nickSize.height - nameSize.height - padding) / 2;
    CGRectMake(CGRectGetMaxX(self.avatar.frame) + 10, nickNameY, nickSize.width, nickSize.height);
    self.nameCertificationLabel.frame = CGRectMake(self.nickNameLabel.x, CGRectGetMaxY(self.nickNameLabel.frame) + padding, nameSize.width, nameSize.height);
    
    self.line1.frame = CGRectMake(CGRectGetMaxX(self.nameCertificationLabel.frame) + 3, self.nameCertificationLabel.y, 1, self.nameCertificationLabel.height);
    
    CGSize mobilePhoneSize = [self.phoneBindingLabel.text sizeWithLabelFont:self.phoneBindingLabel.font];
    self.phoneBindingLabel.frame = CGRectMake(CGRectGetMaxX(self.line1.frame) + 3, self.nameCertificationLabel.y, mobilePhoneSize.width, self.nameCertificationLabel.height);
}
#pragma mark - 初始化
- (NSMutableArray *)moneyDetailbtns
{
    if (_moneyDetailbtns == nil) {
        _moneyDetailbtns = [NSMutableArray array];
    }
    return _moneyDetailbtns;
}

@end
