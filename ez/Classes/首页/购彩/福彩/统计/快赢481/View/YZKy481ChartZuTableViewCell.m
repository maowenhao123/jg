//
//  YZKy481ChartZuTableViewCell.m
//  ez
//
//  Created by dahe on 2019/12/3.
//  Copyright © 2019 9ge. All rights reserved.
//

#import "YZKy481ChartZuTableViewCell.h"

@interface YZKy481ChartZuTableViewCell ()

@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, weak) UILabel * noDataLabel;

@end


@implementation YZKy481ChartZuTableViewCell

+ (YZKy481ChartZuTableViewCell *)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"YZKy481ChartZuTableViewCellId";
    YZKy481ChartZuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil)
    {
        cell = [[YZKy481ChartZuTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return  cell;
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
    NSArray * labelTexts = @[@"组4", @"组6", @"组12", @"组24", @"和值", @"跨度"];
    CGFloat labelW = (screenWidth - LeftLabelW1 - LeftLabelW2) / labelTexts.count;
    for(int i = 0; i < 2 + labelTexts.count; i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            button.frame = CGRectMake(0, 0, LeftLabelW2, CellH2);
        }else if (i == 1)
        {
            button.frame = CGRectMake(LeftLabelW2, 0, LeftLabelW1, CellH2);
        }else
        {
            button.frame = CGRectMake(LeftLabelW1 + LeftLabelW2 + labelW * (i - 2), 0, labelW, CellH2);
        }
        button.adjustsImageWhenHighlighted = NO;
        [button setTitleColor:YZChartLightGrayColor forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:YZGetFontSize(24)];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 0.25;
        [self.contentView addSubview:button];
        [self.buttons addObject:button];
    }
}

- (void)setDataStatus:(YZChartDataStatus *)dataStatus
{
    _dataStatus = dataStatus;
     
    NSArray * zuArray = @[@"组4", @"组6", @"组12", @"组24"];
    for (int i = 0; i < self.buttons.count; i++) {
        UIButton * button = self.buttons[i];
        [button setTitleColor:YZChartLightGrayColor forState:UIControlStateNormal];
        if (i == 0) {
            [button setTitle:[NSString stringWithFormat:@"%@期", _dataStatus.issue] forState:UIControlStateNormal];
        }else if (i == 1)
        {
            NSString * winNumberStr = [NSString string];//获奖号码
            for (NSString * number in _dataStatus.winNumber) {
                winNumberStr = [NSString stringWithFormat:@"%@%@", winNumberStr, number];
            }
            [button setTitle:winNumberStr forState:UIControlStateNormal];
        }else if (i == 6)
        {
            NSArray * hezhi = _dataStatus.missNumber[@"hezhi"];
            [button setTitle:[NSString stringWithFormat:@"%@", hezhi.firstObject] forState:UIControlStateNormal];
        }else if (i == 7)
        {
            NSArray * kuadu = _dataStatus.missNumber[@"kuadu"];
            [button setTitle:[NSString stringWithFormat:@"%@", kuadu.firstObject] forState:UIControlStateNormal];
        }else
        {
            NSArray * zuxuan = _dataStatus.missNumber[@"zuxuan"];
            if (zuxuan.count > i - 2) {
                NSString * missCharacter = [NSString stringWithFormat:@"%@", zuxuan[i - 2]];
                if ([missCharacter integerValue] == 0) {
                    [button setTitle:zuArray[i - 2] forState:UIControlStateNormal];
                    [button setTitleColor:YZBaseColor forState:UIControlStateNormal];
                }else
                {
                    [button setTitle:missCharacter forState:UIControlStateNormal];
                }
            }
        }
    }
    
}

#pragma mark - 初始化
- (NSMutableArray *)buttons
{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

@end
