//
//  YZMessageTableViewCell.m
//  ez
//
//  Created by apple on 16/9/1.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZMessageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "YZDateTool.h"

@interface YZMessageTableViewCell ()

@property (nonatomic, weak) UIView *backView;
@property (nonatomic, weak) UIImageView * lineView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UILabel *describeLabel;

@end

@implementation YZMessageTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *ID = @"MessageTableViewCell";
    YZMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle  =UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = YZBackgroundColor;
        [self setupChilds];
    }
    return self;
}
- (void)setupChilds
{
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, screenWidth - 20, 95)];
    self.backView = backView;
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.masksToBounds = YES;
    backView.layer.cornerRadius = 3;
    [self.contentView addSubview:backView];
    
    //title
    UILabel * titleLabel = [[UILabel alloc]init];
    self.titleLabel = titleLabel;
    titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    titleLabel.textColor = YZBlackTextColor;
    titleLabel.numberOfLines = 0;
    [backView addSubview:titleLabel];

    //time
    UILabel * timeLabel = [[UILabel alloc]init];
    self.timeLabel = timeLabel;
    timeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    timeLabel.textColor = YZGrayTextColor;
    [backView addSubview:timeLabel];
    
    //分割线
    UIImageView * lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 33, backView.width, 1)];
    self.lineView = lineView;
    lineView.backgroundColor = YZWhiteLineColor;
    [backView addSubview:lineView];
    
    //describe
    UILabel * describeLabel = [[UILabel alloc]init];
    self.describeLabel = describeLabel;
    describeLabel.numberOfLines = 0;
    describeLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    describeLabel.textColor = YZGrayTextColor;
    [backView addSubview:describeLabel];
}
- (void)setMessageStstus:(YZMessageStstus *)messageStstus
{
    _messageStstus = messageStstus;
    self.titleLabel.text = messageStstus.title;
    
    self.timeLabel.text = [YZDateTool getTimeByTimestamp:messageStstus.createTime format:@"yyyy-MM-dd HH:mm"];
    
    self.describeLabel.text = messageStstus.intro;
    
    //设置frame
    CGSize timeSize = [self.timeLabel.text sizeWithLabelFont:self.timeLabel.font];
    self.timeLabel.frame = CGRectMake(self.backView.width - YZMargin - timeSize.width, 0, timeSize.width, 33);
    
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(self.backView.width - 2 * YZMargin - timeSize.width, 33)];
    self.titleLabel.frame = CGRectMake(YZMargin, 0, titleSize.width, 33);
    
    CGSize describeSize = [self.describeLabel.text sizeWithFont:self.describeLabel.font maxSize:CGSizeMake(self.backView.width - 2 * YZMargin, MAXFLOAT)];
    if (describeSize.height + 20 > 62) {
        CGFloat describeLabelH = describeSize.height;
        self.describeLabel.frame = CGRectMake(self.titleLabel.x, CGRectGetMaxY(self.titleLabel.frame) + 10, describeSize.width, describeLabelH);
        self.backView.height = 33 + describeLabelH + 20;
    }else
    {
        CGFloat describeLabelH = 62;
        self.describeLabel.frame = CGRectMake(self.titleLabel.x, CGRectGetMaxY(self.titleLabel.frame), describeSize.width, describeLabelH);
        self.backView.height = 33 + describeLabelH;
    }
}

@end
