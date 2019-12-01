//
//  YZRechargeTableViewCell.m
//  ez
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZRechargeTableViewCell.h"

@interface YZRechargeTableViewCell ()

@property (nonatomic, weak) UIImageView *rechargeLogo;
@property (nonatomic, weak) UILabel *rechargeNameLabel;

@end

@implementation YZRechargeTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *ID = @"RechargeCell";
    YZRechargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZRechargeTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupChilds];
    }
    return self;
}

- (void)setupChilds
{
    //图片
    CGFloat logoWH = 18;
    CGFloat logoY = (YZCellH - logoWH) / 2;
    UIImageView *rechargeLogo = [[UIImageView alloc] init];
    rechargeLogo.frame = CGRectMake(YZMargin, logoY, logoWH, logoWH);
    self.rechargeLogo = rechargeLogo;
    [self.contentView addSubview:rechargeLogo];
    
    //标题
    UILabel *rechargeNameLabel = [[UILabel alloc] init];
    self.rechargeNameLabel = rechargeNameLabel;
    rechargeNameLabel.frame = CGRectMake(CGRectGetMaxX(rechargeLogo.frame) + YZMargin, 0, screenWidth - CGRectGetMaxX(rechargeLogo.frame) - YZMargin, YZCellH);
    rechargeNameLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    rechargeNameLabel.textColor = YZColor(43, 43, 43, 1);
    [self.contentView addSubview:rechargeNameLabel];
    
    //accessory
    CGFloat accessoryW = 8;
    CGFloat accessoryH = 11;
    UIImageView * accessory = [[UIImageView alloc]init];
    accessory.frame = CGRectMake(screenWidth - YZMargin - accessoryW, (YZCellH - accessoryH) / 2, accessoryW, accessoryH);
    accessory.image = [UIImage imageNamed:@"accessory_dray"];
    [self addSubview:accessory];
    
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(YZMargin, YZCellH - 1, screenWidth - YZMargin, 1)];
    self.line = line;
    line.backgroundColor = YZWhiteLineColor;
    [self addSubview:line];
}

- (void)setStatus:(YZRechargeStatus *)status
{
    _status = status;
    
    [self.rechargeLogo sd_setImageWithURL:[NSURL URLWithString:_status.imageUrl] placeholderImage:[UIImage imageNamed:status.imageName]];
    self.rechargeNameLabel.text = status.title;
}

@end
