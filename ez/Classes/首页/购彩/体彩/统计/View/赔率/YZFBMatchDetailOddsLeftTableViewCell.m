//
//  YZFBMatchDetailOddsLeftTableViewCell.m
//  ez
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZFBMatchDetailOddsLeftTableViewCell.h"

@interface YZFBMatchDetailOddsLeftTableViewCell ()

@property (nonatomic, weak) UILabel *companyLabel;

@end

@implementation YZFBMatchDetailOddsLeftTableViewCell

+ (YZFBMatchDetailOddsLeftTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"FBMatchDetailOddsLeftTableViewCell";
    YZFBMatchDetailOddsLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZFBMatchDetailOddsLeftTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
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
- (void)setupChilds
{
    UILabel * companyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenWidth * 0.25, 35)];
    self.companyLabel = companyLabel;
    companyLabel.textAlignment = NSTextAlignmentCenter;
    companyLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
    companyLabel.textColor = YZBlackTextColor;
    companyLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:companyLabel];
}
- (void)setStatus:(YZOddsCellStatus *)status
{
    _status = status;
    self.companyLabel.text = _status.companyName;
    if (_status.selected) {
        self.companyLabel.textColor = [UIColor whiteColor];
        self.companyLabel.backgroundColor = YZMDGreenColor;
    }else
    {
        self.companyLabel.textColor = YZBlackTextColor;
        self.companyLabel.backgroundColor = [UIColor whiteColor];
    }
}
@end
