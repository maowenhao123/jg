//
//  YZServiceTableViewCell.m
//  ez
//
//  Created by dahe on 2019/7/15.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZServiceTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface YZServiceTableViewCell ()

@property (nonatomic, weak) UIImageView * logoImageView;
@property (nonatomic, weak) UILabel * titleLabel;
@property (nonatomic, weak) UILabel *subTitleLabel;

@end

@implementation YZServiceTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *ID = @"ServiceTableViewCellId";
    YZServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZServiceTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    //logo
    CGFloat logoWH = 30;
    CGFloat logoY = (60 - logoWH) / 2;
    UIImageView * logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(YZMargin, logoY, logoWH, logoWH)];
    self.logoImageView = logoImageView;
    logoImageView.layer.masksToBounds = YES;
    logoImageView.layer.cornerRadius = logoWH / 2;
    [self addSubview:logoImageView];
    
    //title
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 10, 10, screenWidth - CGRectGetMaxX(logoImageView.frame) - 10, 25)];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    titleLabel.textColor = YZBlackTextColor;
    [self addSubview:titleLabel];
    
    //subTitle
    UILabel *subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.x, CGRectGetMaxY(titleLabel.frame), titleLabel.width, 20)];
    self.subTitleLabel = subTitleLabel;
    subTitleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    subTitleLabel.textColor = YZGrayTextColor;
    [self addSubview:subTitleLabel];
}

- (void)setServiceModel:(YZServiceModel *)serviceModel
{
    _serviceModel = serviceModel;
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:_serviceModel.icon] placeholderImage:[UIImage imageNamed:@"contact_customerService_chat"]];
    NSDictionary *extendDic = [YZTool dictionaryWithJsonString:serviceModel.extendParams];
    if ([serviceModel.redirectType isEqualToString:@"WEIXIN"])
    {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", _serviceModel.name ,extendDic[@"weixin"]];
    }else if ([serviceModel.redirectType isEqualToString:@"QQ"])
    {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", _serviceModel.name ,extendDic[@"qq"]];
    }else if ([serviceModel.redirectType isEqualToString:@"TELL"])
    {
        self.titleLabel.text = [NSString stringWithFormat:@"%@ %@", _serviceModel.name ,extendDic[@"tellphone"]];
    }else if ([serviceModel.redirectType isEqualToString:@"EASEMOB"])
    {
        self.titleLabel.text = [NSString stringWithFormat:@"%@", _serviceModel.name];
    }
    self.subTitleLabel.text = _serviceModel.description_;
}

@end
