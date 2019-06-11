//
//  YZNoDataTableViewCell.m
//  ez
//
//  Created by apple on 16/10/28.
//  Copyright © 2016年 9ge. All rights reserved.
//

#import "YZNoDataTableViewCell.h"

@interface YZNoDataTableViewCell ()

@property (nonatomic, weak) UIImageView *noDataImageView;
@property (nonatomic, weak) UILabel *noDataLabel;

@end

@implementation YZNoDataTableViewCell
//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView cellId:(NSString *)cellId
{
    NSString *ID = cellId;
    YZNoDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZNoDataTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    //没记录显示的图片和文字
    UIImageView *noDataImageView =  [[UIImageView alloc]init];
    self.noDataImageView = noDataImageView;
    [self addSubview:noDataImageView];
    
    UILabel *noDataLabel = [[UILabel alloc] init];
    self.noDataLabel = noDataLabel;
    noDataLabel.numberOfLines = 0;
    noDataLabel.textColor = YZBlackTextColor;
    noDataLabel.font = [UIFont systemFontOfSize:YZGetFontSize(28)];
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:noDataLabel];
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    UIImage * image = [UIImage imageNamed:imageName];
    self.noDataImageView.image = image;
    self.noDataImageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
}

- (void)setNoDataStr:(NSString *)noDataStr
{
    _noDataStr = noDataStr;
    self.noDataLabel.text = noDataStr;
    CGSize labelSize = [self.noDataLabel.text sizeWithFont:self.noDataLabel.font maxSize:CGSizeMake(screenWidth -  2 * YZMargin, screenHeight)];
    self.noDataLabel.bounds = CGRectMake(0, 0, screenWidth -  2 * YZMargin, labelSize.height);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = 20;
    CGFloat imageViewY = (self.height - self.noDataImageView.height - padding - self.noDataLabel.height) / 2;
    self.noDataImageView.x = (screenWidth - self.noDataImageView.width) / 2;
    self.noDataImageView.y = imageViewY;
    
    self.noDataLabel.x = YZMargin;
    self.noDataLabel.y = CGRectGetMaxY(self.noDataImageView.frame) + padding;
}

@end
