//
//  YZMineFunctionTableViewCell.m
//  ez
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZMineFunctionTableViewCell.h"

@interface YZMineFunctionTableViewCell ()

@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation YZMineFunctionTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *ID = @"MineFunctionCell";
    YZMineFunctionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZMineFunctionTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView * selectedBackgroundView = [[UIView alloc]init];
        selectedBackgroundView.backgroundColor = YZColor(233, 233, 233, 1);
        self.selectedBackgroundView = selectedBackgroundView;
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    CGFloat iconWH = 18;
    UIImageView * icon = [[UIImageView alloc]initWithFrame:CGRectMake(YZMargin, (YZCellH  - iconWH) / 2, iconWH, iconWH)];
    self.icon = icon;
    [self addSubview:icon];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    titleLabel.textColor = YZBlackTextColor;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    [self addSubview:titleLabel];
    
    UIImageView * redDot = [[UIImageView alloc]init];
    self.redDot = redDot;
    redDot.image = [UIImage imageNamed:@"mine_newmessage_dot"];
    redDot.hidden = YES;
    [self addSubview:redDot];
    
    //分割线
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(YZMargin, YZCellH - 1, screenWidth - YZMargin, 1)];
    self.line = line;
    line.backgroundColor = YZWhiteLineColor;
    [self addSubview:line];
    
    //accessory
    CGFloat accessoryW = 8;
    CGFloat accessoryH = 11;
    UIImageView * accessory = [[UIImageView alloc]init];
    accessory.frame = CGRectMake(screenWidth - YZMargin - accessoryW, (YZCellH - accessoryH) / 2, accessoryW, accessoryH);
    accessory.image = [UIImage imageNamed:@"accessory_dray"];
    [self addSubview:accessory];
}
- (void)setStatus:(YZFunctionStatus *)status
{
    _status = status;
    self.icon.image = [UIImage imageNamed:_status.icon];
    self.titleLabel.text = _status.title;
    CGSize titleSize = [self.titleLabel.text sizeWithLabelFont:self.titleLabel.font];
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.icon.frame) + YZMargin, 0, titleSize.width, YZCellH);
    self.redDot.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 5, 19, 6, 6);
    
    if ([_status.title isEqualToString:@"分享好友赚钱"]) {
        self.titleLabel.textColor = YZRedTextColor;
    }else
    {
        self.titleLabel.textColor = YZBlackTextColor;
    }
}
@end
