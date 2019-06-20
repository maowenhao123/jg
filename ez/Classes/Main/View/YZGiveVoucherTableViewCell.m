//
//  YZGiveVoucherTableViewCell.m
//  ez
//
//  Created by 孔琪琪 on 2018/3/29.
//  Copyright © 2018年 9ge. All rights reserved.
//

#import "YZGiveVoucherTableViewCell.h"

@interface YZGiveVoucherTableViewCell ()

@property (nonatomic, weak) UIImageView *backImageView;
@property (nonatomic, weak) UILabel *balanceLabel;//余额
@property (nonatomic, weak) UILabel *titleLabel;//标题
@property (nonatomic, weak) UILabel *descriptionLabel;//描述
@property (nonatomic, weak) UILabel *timeLabel;//有效期
@property (nonatomic, weak) UIButton * getButton;

@end

@implementation YZGiveVoucherTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"GiveVoucherTableViewCellId";
    YZGiveVoucherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZGiveVoucherTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
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
    //背景
    CGFloat bgImageViewW = 320 * screenWidth / 375;
    CGFloat backImageViewW = 269 * screenWidth / 375;
    CGFloat backImageViewX = (bgImageViewW - backImageViewW) / 2;
    CGFloat backImageViewH = 67;
    CGFloat backImageViewY = (85 - backImageViewH) / 2;
    UIImageView * backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"give_voucher_item_bg"]];
    self.backImageView = backImageView;
    backImageView.userInteractionEnabled = YES;
    backImageView.frame = CGRectMake(backImageViewX, backImageViewY, backImageViewW, backImageViewH);
    [self addSubview:backImageView];
    
    //金额
    UILabel *balanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70 * screenWidth / 375, backImageViewH)];
    self.balanceLabel = balanceLabel;
    balanceLabel.textColor = UIColorFromRGB(0xfd3736);
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    [backImageView addSubview:balanceLabel];
    
    //标题
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70 * screenWidth / 375, 8, 110 * screenWidth / 375, 17)];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(26)];
    titleLabel.textColor = UIColorFromRGB(0x2b2b2b);
    [backImageView addSubview:titleLabel];
    
    //描述
    UILabel * descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(70 * screenWidth / 375, 25, 110 * screenWidth / 375, 17)];
    self.descriptionLabel = descriptionLabel;
    descriptionLabel.font = [UIFont systemFontOfSize:YZGetFontSize(20)];
    descriptionLabel.textColor = UIColorFromRGB(0xb4b4b4);
    [backImageView addSubview:descriptionLabel];
    
    //有效期
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70 * screenWidth / 375, 42, 110 * screenWidth / 375, 17)];
    self.timeLabel = timeLabel;
    timeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(20)];
    timeLabel.textColor = UIColorFromRGB(0xb4b4b4);
    [backImageView addSubview:timeLabel];
    
    UIButton * getButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getButton = getButton;
    [getButton setTitle:@"待领取" forState:UIControlStateNormal];
    [getButton setTitleColor:UIColorFromRGB(0xfd3736) forState:UIControlStateNormal];
    getButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    getButton.titleLabel.numberOfLines = 0;
    getButton.frame = CGRectMake(180 * screenWidth / 375, 0, 89 * screenWidth / 375, backImageViewH);
    [getButton addTarget:self action:@selector(getVoucherButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:getButton];
}

- (void)getVoucherButtonDidClick:(UIButton *)button
{
    if ([_couponRedPackage.status isEqualToString:@"WAIT"]) {//待领取
        [self getVoucher];
    }else if ([_couponRedPackage.status isEqualToString:@"RECEIVE"])//已领取
    {
        if (_delegate && [_delegate respondsToSelector:@selector(useVoucher)]) {
            [_delegate useVoucher];
        }
    }
}

- (void)getVoucher
{
    if (!UserId) return;
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"promotionId":self.promotionId,
                           @"redpackageId":self.couponRedPackage.redpackageId,
                           };
    [[YZHttpTool shareInstance] postWithURL:BaseUrl(@"promotion/getCouponRedPackage") params:dict success:^(id json) {
        YZLog(@"getCouponRedPackage:%@",json);
        if (SUCCESS) {
            [MBProgressHUD showSuccess:@"领取成功"];
            if (_delegate && [_delegate respondsToSelector:@selector(receiveVoucher)]) {
                [_delegate receiveVoucher];
            }
        }
    } failure:^(NSError *error)
    {
        YZLog(@"error = %@",error);
    }];
}

- (void)setCouponRedPackage:(CouponRedPackage *)couponRedPackage
{
    _couponRedPackage = couponRedPackage;
    
    //面值
    NSMutableAttributedString * moneyAttStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", _couponRedPackage.templatePrice]];
    [moneyAttStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:YZGetFontSize(28)] range:NSMakeRange(0, 1)];
    [moneyAttStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:YZGetFontSize(58)] range:NSMakeRange(1, moneyAttStr.length - 1)];
    self.balanceLabel.attributedText = moneyAttStr;
    self.titleLabel.text = _couponRedPackage.title;
    self.descriptionLabel.text = _couponRedPackage.remark;
    self.timeLabel.text = _couponRedPackage.describe;
    
    if ([_couponRedPackage.status isEqualToString:@"RECEIVE"])//已领取
    {
        NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:@"已领取\n去使用"];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(24)] range:NSMakeRange(0, 3)];
        [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:YZGetFontSize(30)] range:NSMakeRange(3, attStr.length - 3)];
        [attStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xb4b4b4) range:NSMakeRange(0, 3)];
        [attStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xfd3736) range:NSMakeRange(3, attStr.length - 3)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:3];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        [attStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attStr.length)];
        [self.getButton setAttributedTitle:attStr forState:UIControlStateNormal];
    }else if ([_couponRedPackage.status isEqualToString:@"EXPIRED"])//已过期
    {
        [self.getButton setTitle:@"已过期" forState:UIControlStateNormal];
        [self.getButton setTitleColor:UIColorFromRGB(0xb4b4b4) forState:UIControlStateNormal];
        self.getButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    }else//待领取
    {
        [self.getButton setTitle:@"待领取" forState:UIControlStateNormal];
        [self.getButton setTitleColor:UIColorFromRGB(0xfd3736) forState:UIControlStateNormal];
        self.getButton.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(30)];
    }
    
}

@end
