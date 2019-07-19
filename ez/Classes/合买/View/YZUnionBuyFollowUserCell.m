//
//  YZUnionBuyFollowUserCell.m
//  ez
//
//  Created by apple on 15/3/23.
//  Copyright (c) 2015年 9ge. All rights reserved.
//

#import "YZUnionBuyFollowUserCell.h"
#import "NSString+YZ.h"

@interface YZUnionBuyFollowUserCell ()
@property (nonatomic, strong) NSMutableArray *labels;
@end

@implementation YZUnionBuyFollowUserCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"unionBuyFollowUserCell";
    YZUnionBuyFollowUserCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell)
    {
        cell = [[YZUnionBuyFollowUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self setupChilds];
    }
    return self;
}
//初始化所有的子控件
- (void)setupChilds
{
    for(NSUInteger i = 0;i < 4;i ++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor clearColor];
        [self.labels addObject:label];
        if(i > 0)
        {
            label.font = smallFont;
            label.textColor = YZDrayGrayTextColor;
        }else
        {
            label.font = bigFont;
            label.textColor = YZBlackTextColor;
        }
        [self.contentView addSubview:label];
    }
}
- (void)setStatusFrame:(YZUnionBuyFollowUserCellStatusFrame *)statusFrame
{
    _statusFrame = statusFrame;
    
    YZUnionBuyStatus *status = _statusFrame.status;
    for(NSUInteger i = 0;i < self.labels.count;i ++)
    {
        UILabel *label = self.labels[i];
        if(i == 0)
        {
            label.text = status.userName;
            label.frame = _statusFrame.userNameF;
        }else if(i == 1)
        {
            label.text = status.createTime;
            label.frame = _statusFrame.createTimeF;
        }else if(i == 2)
        {
            label.attributedText = [status.followMoney attributedStringWithAttributs:@{NSForegroundColorAttributeName : YZRedTextColor, NSFontAttributeName : smallFont} firstString:@"：" secondString:@"元"];
            label.frame = _statusFrame.moneyF;
        }else if(i == 3)
        {
            label.attributedText = [status.moneyOfTotal attributedStringWithAttributs:@{NSForegroundColorAttributeName : YZRedTextColor, NSFontAttributeName : smallFont} firstString:@"：" secondString:@"%"];
            label.frame = _statusFrame.moneyOfTotalF;
        }
    }
}

- (NSMutableArray *)labels
{
    if(_labels == nil)
    {
        _labels = [NSMutableArray array];
    }
    return _labels;
}

@end
