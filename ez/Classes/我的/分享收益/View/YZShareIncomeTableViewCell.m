//
//  YZShareIncomeTableViewCell.m
//  ez
//
//  Created by 毛文豪 on 2017/5/23.
//  Copyright © 2017年 9ge. All rights reserved.
//

#import "YZShareIncomeTableViewCell.h"

@interface YZShareIncomeTableViewCell ()

@property (nonatomic, strong) NSMutableArray *labels;

@end

@implementation YZShareIncomeTableViewCell

//初始化一个cell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *ID = @"ShareIncomeTableViewCellId";
    YZShareIncomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZShareIncomeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle  =UITableViewCellSelectionStyleNone;
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
    UILabel * lastLabel;
    NSArray * labelWs = @[@0.3,@0.45,@0.25];
    for (int i = 0; i < labelWs.count; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lastLabel.frame), 0, [labelWs[i] floatValue] * screenWidth, 35)];
        label.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        label.textColor = YZBlackTextColor;
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        [self.labels addObject:label];
        lastLabel = label;
    }
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 35 - 0.8, screenWidth, 0.8)];
    self.line = line;
    line.backgroundColor = YZGrayTextColor;
    [self addSubview:line];
}
- (void)setStatus:(YZShareIncomeStatus *)status
{
    _status = status;
    for (UILabel * label in self.labels) {
        NSInteger index = [self.labels indexOfObject:label];
        if (index == 0) {
            label.text = _status.mobile;
        }else if (index == 1)
        {
            label.text = _status.regTime;
        }else
        {
            label.text = [NSString stringWithFormat:@"%.2f",[_status.money floatValue] / 100];
        }
    }
}
#pragma mark - 初始化
- (NSMutableArray *)labels
{
    if (_labels == nil) {
        _labels = [NSMutableArray array];
    }
    return _labels;
}


@end
