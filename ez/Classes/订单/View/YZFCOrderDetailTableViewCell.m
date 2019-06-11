//
//  YZFCOrderDetailTableViewCell.m
//  ez
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZFCOrderDetailTableViewCell.h"

@interface YZFCOrderDetailTableViewCell ()

@property (nonatomic, weak) UILabel *betNumberLabel;

@end

@implementation YZFCOrderDetailTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FCOrderDetailTableViewCell";
    YZFCOrderDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell)
    {
        cell = [[YZFCOrderDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    UILabel * betNumberLabel = [[UILabel alloc]init];
    self.betNumberLabel = betNumberLabel;
    betNumberLabel.numberOfLines = 0;
    betNumberLabel.textColor = YZBlackTextColor;
    [self addSubview:betNumberLabel];
}
- (void)setStatus:(YZFCOrderDetailStatus *)status
{
    _status = status;
    self.betNumberLabel.frame = CGRectMake(12, 0, screenWidth - 2 * 12, status.cellH);
    self.betNumberLabel.attributedText = status.betNumber;
}
@end
